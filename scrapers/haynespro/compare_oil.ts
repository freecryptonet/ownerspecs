#!/usr/bin/env tsx
/**
 * Oil-audit comparator.
 *
 * INPUT
 * -----
 * 1) scrapers/haynespro/typeids.json — curated engine_code → typeId mapping.
 * 2) scrapers/output/haynespro-oil-{engine_code}.json — per-engine harvest
 *    output written by the Playwright-driven harvester (see harvest_oil.md
 *    workflow).
 *
 * COMPARISON
 * ----------
 * For each engine in typeids.json:
 *   - Read scraped HaynesPro values (preferred viscosity, spec, sump capacity,
 *     drain torque).
 *   - Query DB engine_oil rows for that engine_code across all gens.
 *   - Compare and emit per-row discrepancy entries.
 *
 * OUTPUT
 * ------
 * Writes scrapers/output/oil-audit-{YYYY-MM-DD}.md — Markdown report grouped
 * by engine_code with a Status column (OK / WRONG-VISC / WRONG-CAP /
 * WRONG-SPEC / NO-DATA).
 *
 * Usage:
 *   npx tsx scrapers/haynespro/compare_oil.ts
 *   npx tsx scrapers/haynespro/compare_oil.ts --engine B48B20B  (single engine)
 */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { resolve } from "node:path";
import mysql from "mysql2/promise";

// Env loaded by caller: `set -a && source .env.local && set +a && npx tsx ...`

type TypeIdEntry = {
  engine_code: string;
  display: string;
  modelId: string;
  chassis: string;
  typeIds: string[];
};
type TypeIdsFile = {
  _meta: Record<string, string>;
  engines: TypeIdEntry[];
};

type ScrapedOil = {
  engine_code: string;
  typeId: string;
  fetched_at: string;
  preferred?: { viscosity: string | null; spec: string | null };
  alternatives?: Array<{ viscosity: string | null; spec: string | null }>;
  sump_l: number | null;
  drain_nm: number | null;
  notes?: string;
};

type DbOilRow = {
  fluid_id: number;
  generation_id: number;
  gen_slug: string;
  brand: string;
  engine_id: number;
  engine_code: string;
  capacity_l: number | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
};

const TOLERANCE_L = 0.20;  // ±0.2 L tolerance for capacity comparison

function normalizeSpec(s: string | null | undefined): string {
  if (!s) return "";
  return s
    .replace(/\bLL-(\d+)/g, "Longlife-$1")
    .replace(/\bLL\b/g, "Longlife")
    .replace(/\s*\(.*?\)\s*/g, "")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

function specsMatch(scraped: string | null | undefined, db: string | null | undefined): boolean {
  const s = normalizeSpec(scraped);
  const d = normalizeSpec(db);
  if (!s || !d) return false;
  return s === d || s.includes(d) || d.includes(s);
}

function viscMatch(scraped: string | null | undefined, db: string | null | undefined): boolean {
  if (!scraped || !db) return false;
  return scraped.replace(/\s+/g, "").toUpperCase() === db.replace(/\s+/g, "").toUpperCase();
}

function statusFor(row: DbOilRow, scraped: ScrapedOil): { status: string; note: string } {
  const pref = scraped.preferred ?? { viscosity: null, spec: null };
  const alts = scraped.alternatives ?? [];
  // 1) Visc check
  const viscPref = viscMatch(pref.viscosity, row.viscosity);
  const viscAlt = alts.some((a) => viscMatch(a.viscosity, row.viscosity));
  // 2) Spec check
  const specPref = specsMatch(pref.spec, row.spec_standard);
  const specAlt = alts.some((a) => specsMatch(a.spec, row.spec_standard));
  // 3) Capacity check
  const capOk =
    row.capacity_l != null &&
    scraped.sump_l != null &&
    Math.abs(Number(row.capacity_l) - scraped.sump_l) <= TOLERANCE_L;
  // Resolve
  const reasons: string[] = [];
  if (!viscPref && !viscAlt) reasons.push(`WRONG-VISC (db=${row.viscosity}, hp=${pref.viscosity})`);
  if (!specPref && !specAlt) reasons.push(`WRONG-SPEC (db=${row.spec_standard}, hp=${pref.spec})`);
  if (!capOk) reasons.push(`WRONG-CAP (db=${row.capacity_l}L, hp=${scraped.sump_l}L)`);
  if (reasons.length === 0) return { status: "OK", note: viscPref && specPref ? "preferred match" : "alternative match" };
  return { status: reasons[0].split(" ")[0], note: reasons.join("; ") };
}

async function main() {
  const args = process.argv.slice(2);
  const engineFilter = args.includes("--engine") ? args[args.indexOf("--engine") + 1] : null;

  const typeIdsPath = resolve(process.cwd(), "scrapers/haynespro/typeids.json");
  const typeIds = JSON.parse(readFileSync(typeIdsPath, "utf8")) as TypeIdsFile;

  const conn = await mysql.createConnection({
    host: process.env.DB_HOST ?? "127.0.0.1",
    port: Number(process.env.DB_PORT ?? 3306),
    user: process.env.DB_USER ?? "ownerspecs_app",
    password: process.env.DB_PASSWORD ?? "",
    database: process.env.DB_NAME ?? "ownerspecs",
  });

  const lines: string[] = [];
  const today = new Date().toISOString().slice(0, 10);
  lines.push(`# Oil audit report — ${today}`);
  lines.push("");
  lines.push("Comparison of DB `engine_oil` rows vs. HaynesPro scraped values per engine_code.");
  lines.push(`Capacity tolerance: ±${TOLERANCE_L} L. Spec match: normalized + substring fallback.`);
  lines.push("");

  let totalRows = 0;
  let totalOk = 0;
  let totalWrong = 0;

  for (const entry of typeIds.engines) {
    if (engineFilter && entry.engine_code !== engineFilter) continue;
    const scrapedPath = resolve(
      process.cwd(),
      `scrapers/output/haynespro-oil-${entry.engine_code}.json`,
    );
    if (!existsSync(scrapedPath)) {
      lines.push(`## ${entry.engine_code} — ${entry.display}`);
      lines.push(`_(no scraped JSON at ${scrapedPath} — run harvester)_`);
      lines.push("");
      continue;
    }
    const scraped = JSON.parse(readFileSync(scrapedPath, "utf8")) as ScrapedOil;
    const [dbRows] = await conn.query<mysql.RowDataPacket[]>(
      `SELECT fs.id AS fluid_id, fs.generation_id, g.slug AS gen_slug,
              mk.slug AS brand, fs.engine_id, e.code AS engine_code,
              fs.capacity_l, fs.viscosity, fs.spec_standard, fs.filter_part_no
       FROM fluid_specs fs
       JOIN engines e ON e.id = fs.engine_id
       JOIN generations g ON g.id = fs.generation_id
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE fs.fluid_type = 'engine_oil' AND e.code = ?
       ORDER BY mk.slug, g.slug, fs.id`,
      [entry.engine_code],
    );

    lines.push(`## ${entry.engine_code} — ${entry.display}`);
    lines.push(`HaynesPro: ${scraped.preferred?.viscosity ?? "?"} ${scraped.preferred?.spec ?? "?"}, sump ${scraped.sump_l ?? "?"} L, drain ${scraped.drain_nm ?? "?"} Nm`);
    if (dbRows.length === 0) {
      lines.push("_No DB rows for this engine_code._");
      lines.push("");
      continue;
    }
    lines.push("");
    lines.push("| Gen | Visc | Spec | Cap L | Status | Note |");
    lines.push("|---|---|---|---|---|---|");
    for (const r of dbRows as unknown as DbOilRow[]) {
      const { status, note } = statusFor(r, scraped);
      totalRows++;
      if (status === "OK") totalOk++;
      else totalWrong++;
      lines.push(`| ${r.brand}/${r.gen_slug} | ${r.viscosity ?? "—"} | ${r.spec_standard ?? "—"} | ${r.capacity_l ?? "—"} | **${status}** | ${note} |`);
    }
    lines.push("");
  }

  lines.unshift("");
  lines.unshift(`Summary: ${totalRows} rows audited · ${totalOk} OK · ${totalWrong} need attention.`);

  const outPath = resolve(process.cwd(), `scrapers/output/oil-audit-${today}.md`);
  writeFileSync(outPath, lines.join("\n"), "utf8");
  await conn.end();
  console.log(`\nWrote ${outPath}`);
  console.log(`Summary: ${totalRows} rows · ${totalOk} OK · ${totalWrong} need attention.`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
