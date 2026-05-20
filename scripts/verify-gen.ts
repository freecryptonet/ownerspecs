/**
 * verify-gen.ts — cross-check a generation against NHTSA vPIC.
 *
 * Usage (run on the VPS where DB env vars are loaded):
 *   tsx scripts/verify-gen.ts <gen-slug> [<sample-year>]
 *
 * Examples:
 *   tsx scripts/verify-gen.ts charger-ld-sedan-2011-2023 2020
 *   tsx scripts/verify-gen.ts ev6-suv-2021-present 2023
 *
 * What it does
 * ------------
 * 1. Loads the gen + its trims from MariaDB.
 * 2. Calls NHTSA GetCanadianVehicleSpecifications for the gen's
 *    (make, model, sample-year).
 * 3. Prints a diff report: AGREE / DISAGREE / MISSING per field, with
 *    the source values side-by-side and a recommended action.
 * 4. Exits 0 always — this is a read-only audit. Migrations are written
 *    by hand once the human reads the report.
 *
 * The whole point: writes go through a verified-before-commit gate.
 */

import mysql from "mysql2/promise";
import { getCanadianSpecs, aggregate, type CanadianSpec } from "../scrapers/nhtsa.js";

type GenRow = {
  id: number;
  slug: string;
  display_name: string;
  start_year: number;
  end_year: number | null;
  make_slug: string;
  make_name: string;
  model_slug: string;
  model_name: string;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  fuel_tank_l: number | null;
  cargo_l: number | null;
  layout: string | null;
};

type TrimRow = {
  id: number;
  name: string;
  hp: number | null;
  torque_nm: number | null;
  curb_weight_kg: number | null;
  drive_wheel: string | null;
};

const TOLERANCE_MM = 30; // ±30 mm wiggle room — rounding / facelift drift
const TOLERANCE_KG = 50; // ±50 kg — different option packages

function pool() {
  return mysql.createPool({
    host: process.env.DB_HOST ?? "127.0.0.1",
    port: Number(process.env.DB_PORT ?? 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME ?? "ownerspecs",
    waitForConnections: true,
    connectionLimit: 2,
  });
}

function compare(field: string, ours: number | null, theirs: number | null, tolerance: number) {
  if (ours == null && theirs == null) return { state: "BOTH_NULL" as const, line: `${field}: — (both unknown)` };
  if (ours == null) return { state: "MISSING_OURS" as const, line: `${field}: OURS=NULL  NHTSA=${theirs}  → BACKFILL` };
  if (theirs == null) return { state: "MISSING_THEIRS" as const, line: `${field}: OURS=${ours}  NHTSA=NULL  → unverified; need 2nd source` };
  const diff = Math.abs(ours - theirs);
  if (diff <= tolerance) return { state: "AGREE" as const, line: `${field}: ${ours} ≈ ${theirs} (Δ${diff})  → OK` };
  return { state: "DISAGREE" as const, line: `${field}: OURS=${ours}  NHTSA=${theirs}  (Δ${diff})  → INVESTIGATE` };
}

async function main() {
  const slug = process.argv[2];
  const sampleYear = process.argv[3] ? Number(process.argv[3]) : null;
  if (!slug) {
    console.error("Usage: tsx scripts/verify-gen.ts <gen-slug> [<sample-year>]");
    process.exit(2);
  }

  const db = pool();
  try {
    const [genRows] = await db.execute(
      `SELECT g.id, g.slug, g.display_name, g.start_year, g.end_year,
              g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
              g.fuel_tank_l, g.cargo_l, g.layout,
              mk.slug AS make_slug, mk.name AS make_name,
              m.slug AS model_slug, m.name AS model_name
       FROM generations g
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE g.slug = ?`,
      [slug],
    );
    const gen = (genRows as GenRow[])[0];
    if (!gen) {
      console.error(`gen not found: ${slug}`);
      process.exit(1);
    }

    const [trimRows] = await db.execute(
      `SELECT id, name, hp, torque_nm, curb_weight_kg, drive_wheel
       FROM trims WHERE generation_id = ? ORDER BY hp DESC, name`,
      [gen.id],
    );
    const trims = trimRows as TrimRow[];

    const year =
      sampleYear ??
      Math.floor((gen.start_year + (gen.end_year ?? new Date().getFullYear())) / 2);

    console.log(`\n=== ${gen.make_name} ${gen.display_name}  (${gen.slug})`);
    console.log(`    NHTSA sample year: ${year}  ·  ${trims.length} trims in DB`);

    // 1. Pull NHTSA — try the exact make/model with several spellings
    const candidates = [
      gen.model_name,
      gen.model_slug.replace(/-/g, " "),
      gen.model_slug.toUpperCase(),
    ];
    let specs: CanadianSpec[] = [];
    let usedModel = "";
    for (const m of candidates) {
      specs = await getCanadianSpecs(year, gen.make_name, m);
      if (specs.length > 0) {
        usedModel = m;
        break;
      }
    }

    if (specs.length === 0) {
      console.log(`    NHTSA Canadian Specs: NO MATCH for any of [${candidates.join(", ")}]`);
      console.log(`    Likely an EU/JDM-exclusive gen, or wrong year. Try a different sample year.`);
      return;
    }

    console.log(`    NHTSA matched as Make=${gen.make_name} Model="${usedModel}" → ${specs.length} variants`);
    const agg = aggregate(specs);

    // 2. Dimension diff
    console.log(`\n  --- Gen-level dimensions ---`);
    [
      compare("length_mm", gen.length_mm, agg.length_mm, TOLERANCE_MM),
      compare("width_mm", gen.width_mm, agg.width_mm, TOLERANCE_MM),
      compare("height_mm", gen.height_mm, agg.height_mm, TOLERANCE_MM),
      compare("wheelbase_mm", gen.wheelbase_mm, agg.wheelbase_mm, TOLERANCE_MM),
    ].forEach((r) => console.log(`    ${r.line}`));

    // 3. Per-trim curb weight: dump NHTSA's per-variant figures
    console.log(`\n  --- Per-trim curb weight ---`);
    for (const s of specs) {
      const config = (s.Model ?? "—").replace(/\s+/g, " ");
      const cw = s.CW ?? "—";
      const myr = s.MYR ? `20${s.MYR}` : "—";
      console.log(`    NHTSA: ${config.padEnd(45)} curb=${cw} kg  (year ${myr})`);
    }
    console.log(`    OURS:`);
    for (const t of trims) {
      const cw = t.curb_weight_kg ?? "—";
      console.log(`           ${t.name.padEnd(40)} curb=${cw} kg`);
    }
    if (agg.curb_weight_kg_min != null && agg.curb_weight_kg_max != null) {
      console.log(`    Range from NHTSA: ${agg.curb_weight_kg_min}–${agg.curb_weight_kg_max} kg`);
    }

    // 4. Recommendation
    console.log(`\n  --- Recommendation ---`);
    const dims = [gen.length_mm, gen.width_mm, gen.height_mm, gen.wheelbase_mm];
    const dimsAgg = [agg.length_mm, agg.width_mm, agg.height_mm, agg.wheelbase_mm];
    const missingOurs = dims.map((d, i) => d == null && dimsAgg[i] != null);
    const missingCount = missingOurs.filter(Boolean).length;
    if (missingCount > 0) {
      console.log(`    ${missingCount} gen dimension field(s) are NULL but NHTSA has a value.`);
      console.log(`    → Find a 2nd source (Wikipedia / press kit) and confirm before writing.`);
    }
    const trimsWithoutCurb = trims.filter((t) => t.curb_weight_kg == null).length;
    if (trimsWithoutCurb > 0) {
      console.log(`    ${trimsWithoutCurb}/${trims.length} trims lack curb_weight_kg.`);
      console.log(`    → Match NHTSA Configuration text to our trim names, write where they agree.`);
    }
  } finally {
    await db.end();
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
