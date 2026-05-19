/**
 * Insert a reconciled TrimSpec into MariaDB.
 *
 * Idempotent: re-running with the same input upserts (no duplicates).
 * Transactional: any failure rolls back the whole record.
 *
 * Field mapping to existing schema:
 * - merged.brand                      → makes (find-or-create by slug)
 * - merged.model                      → models (find-or-create per make)
 * - merged.generation + body + years  → generations (find-or-create per model)
 * - merged.engine.*                   → engines (find-or-create by code)
 * - merged.drivetrain.transmission    → transmissions (find-or-create by display_name)
 * - merged.trim_modification + perf   → trims (upsert per generation+market+slug)
 * - merged.fluid_hints.engine_oil_*   → fluid_specs (fluid_type='engine_oil')
 * - merged.fluid_hints.coolant_l      → fluid_specs (fluid_type='coolant')
 * - sources (auto-data + ultimatespecs URLs) → sources rows + spec_sources links
 *
 * Not yet in schema (intentional v1 gaps):
 * - dimensions (length/width/height/wheelbase/track) — need a generation_specs
 *   table or columns; for now we log+skip.
 * - weight.max_kg, fuel_tank_l, trunk_l, trailer_braked_kg, trailer_unbraked_kg
 *   — same reason. Logged in the result manifest.
 */
import mysql from "mysql2/promise";
import type { Reconciled } from "./reconcile.js";
import { slugify, log } from "./lib.js";

export type InsertResult = {
  makeId: number;
  modelId: number;
  generationId: number;
  engineId: number | null;
  transmissionId: number | null;
  trimId: number;
  sourceIds: number[];
  fluidSpecIds: number[];
  skippedFields: string[];
  reused: { make: boolean; model: boolean; generation: boolean; trim: boolean };
};

type Conn = mysql.Connection;

async function findOrCreateMake(conn: Conn, brand: string): Promise<{ id: number; reused: boolean }> {
  const slug = slugify(brand);
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM makes WHERE slug = ? LIMIT 1",
    [slug],
  );
  if (existing.length > 0) return { id: existing[0].id as number, reused: true };
  const [res] = await conn.execute<mysql.ResultSetHeader>(
    "INSERT INTO makes (slug, name) VALUES (?, ?)",
    [slug, brand],
  );
  return { id: res.insertId, reused: false };
}

async function findOrCreateModel(
  conn: Conn,
  makeId: number,
  modelName: string,
): Promise<{ id: number; reused: boolean }> {
  const slug = slugify(modelName);
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM models WHERE make_id = ? AND slug = ? LIMIT 1",
    [makeId, slug],
  );
  if (existing.length > 0) return { id: existing[0].id as number, reused: true };
  const [res] = await conn.execute<mysql.ResultSetHeader>(
    "INSERT INTO models (make_id, slug, name) VALUES (?, ?, ?)",
    [makeId, slug, modelName],
  );
  return { id: res.insertId, reused: false };
}

async function findOrCreateGeneration(
  conn: Conn,
  modelId: number,
  modelSlug: string,
  displayName: string,
  bodyType: string,
  codename: string | null,
  startYear: number,
  endYear: number | null,
  layout: string | null,
): Promise<{ id: number; slug: string; reused: boolean }> {
  // Match by codename FIRST when available — codename is the stable identity
  // (G20, FC, XV70, etc.) regardless of trim-specific year ranges. Only fall
  // back to slug-match when codename is missing.
  if (codename) {
    const [byCode] = await conn.execute<mysql.RowDataPacket[]>(
      "SELECT id, slug, start_year, end_year FROM generations WHERE model_id = ? AND codename = ? LIMIT 1",
      [modelId, codename],
    );
    if (byCode.length > 0) {
      const row = byCode[0];
      // Widen year range if this trim extends it
      const newStart = Math.min(row.start_year as number, startYear);
      const newEnd =
        row.end_year === null || endYear === null
          ? null
          : Math.max(row.end_year as number, endYear);
      if (newStart !== row.start_year || newEnd !== row.end_year) {
        await conn.execute(
          "UPDATE generations SET start_year = ?, end_year = ? WHERE id = ?",
          [newStart, newEnd, row.id],
        );
      }
      return { id: row.id as number, slug: row.slug as string, reused: true };
    }
  }

  // Slug for new generations: {model}-{body}-{codename}-{startYear}-{endYear|present}.
  // Matches the existing seed pattern (civic-sedan-x-2016-2021).
  const codePart = codename ? slugify(codename) : "";
  const yearPart = `${startYear}-${endYear ?? "present"}`;
  const bodyPart = slugify(bodyType);
  const parts = [modelSlug, bodyPart, codePart, yearPart].filter(Boolean);
  const slug = parts.join("-");

  // Last-resort slug match (for codenameless generations)
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM generations WHERE model_id = ? AND slug = ? LIMIT 1",
    [modelId, slug],
  );
  if (existing.length > 0) return { id: existing[0].id as number, slug, reused: true };

  const [res] = await conn.execute<mysql.ResultSetHeader>(
    `INSERT INTO generations
       (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [modelId, slug, codename, displayName, bodyType, startYear, endYear, layout],
  );
  return { id: res.insertId, slug, reused: false };
}

/** Normalize a verbose fuel-type string to the short code our schema uses. */
function normalizeFuel(raw: string | null): string {
  if (!raw) return "gasoline";
  const v = raw.toLowerCase();
  if (/diesel/.test(v)) return "diesel";
  if (/electric/.test(v) && !/hybrid/.test(v)) return "electric";
  if (/hybrid/.test(v)) return "hybrid";
  if (/cng|natural gas/.test(v)) return "cng";
  if (/lpg/.test(v)) return "lpg";
  if (/hydrogen|fuel cell/.test(v)) return "hydrogen";
  return "gasoline";
}

/** Normalize aspiration to a short code: NA / turbo / supercharged / twin-turbo. */
function normalizeAspiration(raw: string | null): string | null {
  if (!raw) return null;
  const v = raw.toLowerCase();
  if (/twin[- ]?turbo|biturbo|twin[- ]?power/.test(v)) return "twin-turbo";
  if (/super[- ]?charg/.test(v)) return "supercharged";
  if (/turbo/.test(v)) return "turbo";
  if (/\bna\b|naturally aspirated|atmospheric/.test(v)) return "NA";
  return "NA";
}

async function findOrCreateEngine(
  conn: Conn,
  code: string,
  displayName: string,
  fields: {
    displacement_cc: number | null;
    fuel: string | null;
    aspiration: string | null;
    valvetrain: string | null;
    cylinders: number | null;
    bore_mm: number | null;
    stroke_mm: number | null;
    compression: number | null;
  },
): Promise<number> {
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM engines WHERE code = ? LIMIT 1",
    [code],
  );
  if (existing.length > 0) return existing[0].id as number;
  const [res] = await conn.execute<mysql.ResultSetHeader>(
    `INSERT INTO engines
       (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders,
        bore_mm, stroke_mm, compression)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      code,
      displayName,
      fields.displacement_cc,
      normalizeFuel(fields.fuel),
      normalizeAspiration(fields.aspiration),
      fields.valvetrain ? fields.valvetrain.slice(0, 48) : null,
      fields.cylinders,
      fields.bore_mm,
      fields.stroke_mm,
      fields.compression,
    ],
  );
  return res.insertId;
}

async function findOrCreateTransmission(
  conn: Conn,
  displayName: string,
): Promise<number> {
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM transmissions WHERE display_name = ? LIMIT 1",
    [displayName],
  );
  if (existing.length > 0) return existing[0].id as number;

  // Parse type + gears from display name
  let type = "AT";
  if (/manual|MT\b/i.test(displayName)) type = "MT";
  else if (/CVT|eCVT/i.test(displayName)) type = "CVT";
  else if (/DCT|dual-clutch/i.test(displayName)) type = "DCT";
  else if (/automatic|steptronic|tiptronic/i.test(displayName)) type = "AT";

  const gearsMatch = displayName.match(/(\d+)[\s-]*(?:speed|gear|gears)/i);
  const gears = gearsMatch ? Number(gearsMatch[1]) : 0;

  const [res] = await conn.execute<mysql.ResultSetHeader>(
    "INSERT INTO transmissions (type, gears, display_name) VALUES (?, ?, ?)",
    [type, gears, displayName],
  );
  return res.insertId;
}

async function upsertTrim(
  conn: Conn,
  generationId: number,
  engineId: number | null,
  transmissionId: number | null,
  trimName: string,
  perf: {
    hp: number | null;
    torque_nm: number | null;
    zero_100_kmh_s: number | null;
    top_speed_kmh: number | null;
    fuel_combined_l_100km: number | null;
    co2_g_km: number | null;
  },
  curb_kg: number | null,
  startYear: number | null,
  endYear: number | null,
): Promise<{ id: number; reused: boolean }> {
  const slug = slugify(trimName);

  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM trims WHERE generation_id = ? AND market_id IS NULL AND slug = ? LIMIT 1",
    [generationId, slug],
  );
  if (existing.length > 0) {
    const id = existing[0].id as number;
    await conn.execute(
      `UPDATE trims SET
         name = ?, engine_id = ?, transmission_id = ?, start_year = ?, end_year = ?,
         hp = ?, torque_nm = ?, zero_100_kmh_s = ?, top_speed_kmh = ?,
         fuel_combined_l_100km = ?, co2_g_km = ?, curb_weight_kg = ?
       WHERE id = ?`,
      [
        trimName,
        engineId,
        transmissionId,
        startYear,
        endYear,
        perf.hp,
        perf.torque_nm,
        perf.zero_100_kmh_s,
        perf.top_speed_kmh,
        perf.fuel_combined_l_100km,
        perf.co2_g_km,
        curb_kg,
        id,
      ],
    );
    return { id, reused: true };
  }

  const [res] = await conn.execute<mysql.ResultSetHeader>(
    `INSERT INTO trims
       (generation_id, market_id, slug, name, engine_id, transmission_id, start_year, end_year,
        hp, torque_nm, zero_100_kmh_s, top_speed_kmh, fuel_combined_l_100km, co2_g_km,
        curb_weight_kg)
     VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      generationId,
      slug,
      trimName,
      engineId,
      transmissionId,
      startYear,
      endYear,
      perf.hp,
      perf.torque_nm,
      perf.zero_100_kmh_s,
      perf.top_speed_kmh,
      perf.fuel_combined_l_100km,
      perf.co2_g_km,
      curb_kg,
    ],
  );
  return { id: res.insertId, reused: false };
}

async function findOrCreateSource(
  conn: Conn,
  type: string,
  citation: string,
  url: string,
): Promise<number> {
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    "SELECT id FROM sources WHERE url = ? LIMIT 1",
    [url],
  );
  if (existing.length > 0) {
    await conn.execute("UPDATE sources SET retrieved_at = NOW() WHERE id = ?", [
      existing[0].id,
    ]);
    return existing[0].id as number;
  }
  const [res] = await conn.execute<mysql.ResultSetHeader>(
    "INSERT INTO sources (type, citation, url, retrieved_at) VALUES (?, ?, ?, NOW())",
    [type, citation, url],
  );
  return res.insertId;
}

async function upsertFluidSpec(
  conn: Conn,
  generationId: number,
  fluidType: string,
  capacityL: number,
  spec: string | null,
): Promise<number> {
  // Idempotent on (generation_id, trim_id=NULL, market_id=NULL, fluid_type)
  const [existing] = await conn.execute<mysql.RowDataPacket[]>(
    `SELECT id FROM fluid_specs
     WHERE generation_id = ? AND trim_id IS NULL AND market_id IS NULL AND fluid_type = ?
     LIMIT 1`,
    [generationId, fluidType],
  );
  if (existing.length > 0) {
    const id = existing[0].id as number;
    await conn.execute(
      "UPDATE fluid_specs SET capacity_l = ?, spec_standard = COALESCE(?, spec_standard) WHERE id = ?",
      [capacityL, spec, id],
    );
    return id;
  }
  const [res] = await conn.execute<mysql.ResultSetHeader>(
    `INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard)
     VALUES (?, ?, ?, ?)`,
    [generationId, fluidType, capacityL, spec],
  );
  return res.insertId;
}

async function linkSpecSources(
  conn: Conn,
  specTable: string,
  specId: number,
  sourceIds: number[],
): Promise<void> {
  for (const sourceId of sourceIds) {
    // Idempotent — unique key on (spec_table, spec_id, source_id)
    await conn.execute(
      `INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) VALUES (?, ?, ?)`,
      [specTable, specId, sourceId],
    );
  }
}

/** Main entry. */
export async function insertReconciled(reconciled: Reconciled): Promise<InsertResult> {
  const m = reconciled.merged;
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || "127.0.0.1",
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME || "ownerspecs",
    charset: "utf8mb4_unicode_ci",
  });

  const skippedFields: string[] = [];

  try {
    await conn.beginTransaction();

    if (!m.brand) throw new Error("merged.brand is required");
    if (!m.model) throw new Error("merged.model is required (auto-data should provide it)");
    if (!m.generation) throw new Error("merged.generation is required");
    if (!m.body_type) throw new Error("merged.body_type is required");
    if (!m.trim_modification) throw new Error("merged.trim_modification is required");
    if (m.start_year == null) throw new Error("merged.start_year is required");

    const make = await findOrCreateMake(conn, m.brand);
    log("insert", `make: ${m.brand} → id ${make.id} (${make.reused ? "reused" : "new"})`);

    const model = await findOrCreateModel(conn, make.id, m.model);
    log("insert", `model: ${m.model} → id ${model.id} (${model.reused ? "reused" : "new"})`);

    // Codename: parse from generation string like "3 Series Sedan (G20)" → "G20"
    const codename = m.generation.match(/\(([^)]+)\)/)?.[1] ?? null;

    // Schema `layout` is short (VARCHAR 16) — meant for FF/FR/MR/RR/4WD codes.
    // TrimSpec.engine.layout is a different concept (engine orientation).
    // Derive layout from drive_wheel instead.
    const driveWheel = (m.drivetrain.drive_wheel ?? "").toLowerCase();
    let layoutCode: string | null = null;
    if (/rear/.test(driveWheel) || /\brwd\b/.test(driveWheel)) layoutCode = "FR";
    else if (/front/.test(driveWheel) || /\bfwd\b/.test(driveWheel)) layoutCode = "FF";
    else if (/all/.test(driveWheel) || /\bawd\b/.test(driveWheel) || /\b4wd\b/.test(driveWheel)) layoutCode = "AWD";

    const gen = await findOrCreateGeneration(
      conn,
      model.id,
      slugify(m.model),
      m.generation,
      m.body_type,
      codename,
      m.start_year,
      m.end_year,
      layoutCode,
    );
    log("insert", `generation: ${m.generation} → id ${gen.id} slug=${gen.slug} (${gen.reused ? "reused" : "new"})`);

    let engineId: number | null = null;
    if (m.engine.code) {
      engineId = await findOrCreateEngine(conn, m.engine.code, m.engine.code, {
        displacement_cc: m.engine.displacement_cc,
        fuel: m.engine.fuel,
        aspiration: m.engine.aspiration,
        valvetrain: m.engine.valvetrain,
        cylinders: m.engine.cylinders,
        bore_mm: m.engine.bore_mm,
        stroke_mm: m.engine.stroke_mm,
        compression: m.engine.compression,
      });
      log("insert", `engine: ${m.engine.code} → id ${engineId}`);
    } else {
      skippedFields.push("engine.code (missing)");
    }

    let transmissionId: number | null = null;
    if (m.drivetrain.transmission) {
      transmissionId = await findOrCreateTransmission(conn, m.drivetrain.transmission);
      log("insert", `transmission: ${m.drivetrain.transmission} → id ${transmissionId}`);
    } else {
      skippedFields.push("drivetrain.transmission (missing)");
    }

    const trim = await upsertTrim(
      conn,
      gen.id,
      engineId,
      transmissionId,
      m.trim_modification,
      {
        hp: m.performance.hp,
        torque_nm: m.performance.torque_nm,
        zero_100_kmh_s: m.performance.zero_100_kmh_s,
        top_speed_kmh: m.performance.top_speed_kmh,
        fuel_combined_l_100km: m.performance.fuel_combined_l_100km,
        co2_g_km: m.performance.co2_g_km,
      },
      m.weight.kerb_kg,
      m.start_year,
      m.end_year,
    );
    log("insert", `trim: ${m.trim_modification} → id ${trim.id} (${trim.reused ? "reused" : "new"})`);

    // Sources
    const sourceIds: number[] = [];
    if (reconciled.urls.autoData) {
      const id = await findOrCreateSource(
        conn,
        "auto_data",
        "Auto-Data.net trim page",
        reconciled.urls.autoData,
      );
      sourceIds.push(id);
    }
    if (reconciled.urls.ultimatespecs) {
      const id = await findOrCreateSource(
        conn,
        "ultimatespecs",
        "Ultimatespecs.com trim page",
        reconciled.urls.ultimatespecs,
      );
      sourceIds.push(id);
    }

    // Cite the trim row from both sources
    await linkSpecSources(conn, "trims", trim.id, sourceIds);

    // Fluid hints (auto-data only)
    const fluidSpecIds: number[] = [];
    if (m.fluid_hints.engine_oil_capacity_l) {
      const fsId = await upsertFluidSpec(
        conn,
        gen.id,
        "engine_oil",
        m.fluid_hints.engine_oil_capacity_l,
        m.fluid_hints.engine_oil_spec,
      );
      // Only auto-data has fluid hints; cite single source
      const adSourceId = sourceIds.find((id, i) => reconciled.urls.autoData && i === 0);
      if (adSourceId) await linkSpecSources(conn, "fluid_specs", fsId, [adSourceId]);
      fluidSpecIds.push(fsId);
    }
    if (m.fluid_hints.coolant_l) {
      const fsId = await upsertFluidSpec(conn, gen.id, "coolant", m.fluid_hints.coolant_l, null);
      const adSourceId = sourceIds.find((id, i) => reconciled.urls.autoData && i === 0);
      if (adSourceId) await linkSpecSources(conn, "fluid_specs", fsId, [adSourceId]);
      fluidSpecIds.push(fsId);
    }

    // Dimensions don't have a home in the current schema — log and continue
    if (m.dimensions.length_mm) skippedFields.push("dimensions.* (schema missing — not stored)");
    if (m.weight.fuel_tank_l) skippedFields.push("weight.fuel_tank_l (schema missing)");
    if (m.weight.trunk_l) skippedFields.push("weight.trunk_l (schema missing)");
    if (m.weight.trailer_braked_kg)
      skippedFields.push("weight.trailer_* (schema missing)");

    await conn.commit();

    return {
      makeId: make.id,
      modelId: model.id,
      generationId: gen.id,
      engineId,
      transmissionId,
      trimId: trim.id,
      sourceIds,
      fluidSpecIds,
      skippedFields,
      reused: {
        make: make.reused,
        model: model.reused,
        generation: gen.reused,
        trim: trim.reused,
      },
    };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    await conn.end();
  }
}
