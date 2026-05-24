#!/usr/bin/env tsx
/**
 * Phase D-2: Mercedes assyst maintenance items ingest.
 *
 * Inputs:
 *   scrapers/output/mb_maint_all.json — 14 MB chassis × intervals[].items[]
 *
 * Same logic shape as build_mig_344.ts but only for the 14 Mercedes chassis
 * the v1 crawler skipped (assyst pages have non-km/months labels so the
 * v1 km-label filter rejected every interval). The v3 crawler extracts
 * km/months from the page text body when the link label has neither.
 *
 * Mig 348 DELETEs via spec_sources -> @s_haynes linkage and re-inserts
 * the mapped service rows per gen.
 */
import { readFileSync, writeFileSync } from "node:fs";

const KM_TO_MI = 0.621371;

const crawls = JSON.parse(readFileSync("scrapers/output/mb_maint_all.json", "utf8"));
const registry = JSON.parse(readFileSync("scrapers/haynespro/chassis_registry.json", "utf8"));
const slugTsv = readFileSync("scrapers/output/slug_to_id.tsv", "utf8").trim().split("\n").slice(1);
const slugToId = new Map<string, number>();
for (const line of slugTsv) {
  const [id, slug] = line.split("\t");
  slugToId.set(slug, parseInt(id, 10));
}
const modelToGens = new Map<string, string[]>();
for (const v of Object.values(registry.chassis) as Array<any>) {
  if (typeof v !== "object" || !v.modelId) continue;
  modelToGens.set(v.modelId, v.catalog_gens ?? []);
}

function esc(s: string | null): string {
  if (s == null) return "NULL";
  return "'" + s.replace(/'/g, "''") + "'";
}

function mapItemToCode(raw: string): string | null {
  const s = raw.toLowerCase();
  if ((s.includes("engine oil") || s.includes("the engine oil")) && (s.includes("filter") || s.includes("oil filter"))) return "engine_oil_and_filter";
  if (s.includes("renew the engine oil") || s.startsWith("engine oil")) return "engine_oil_and_filter";
  if (s.includes("oil level") && s.includes("top up")) return "engine_oil_check";
  if (s.includes("dust and pollen") || s.includes("cabin filter") || s.includes("pollen filter")) return "cabin_air_filter";
  if (s.includes("air filter") && !s.includes("dust") && !s.includes("pollen") && !s.includes("cabin")) return "engine_air_filter";
  if (s.includes("fuel filter")) return "fuel_filter";
  if (s.includes("timing belt")) return "timing_belt_replacement";
  if (s.includes("brake pad thickness") || (s.includes("brake pad") && (s.includes("inspect") || s.includes("check")))) return "brake_inspection";
  if (s.includes("brake fluid") && (s.includes("level") || s.includes("top up"))) return "brake_fluid_check";
  if (s.includes("brake fluid")) return "brake_fluid_flush";
  if (s.includes("cooling system") || s.includes("coolant") || s.includes("antifreeze")) return "coolant_flush";
  if (s.includes("spark plug")) return "spark_plugs";
  if (s.includes("glow plug")) return "glow_plugs";
  if (s.includes("tyre pressure monitoring") || s.includes("tpms")) return "tpms_reset";
  if (s.includes("tyre pressure") || s.includes("tire pressure")) return "tire_pressure_check";
  if (s.includes("tread depth")) return "tire_inspection";
  if (s.includes("reset the service")) return "service_indicator_reset";
  if (s.includes("ancillary drive belt") || s.includes("drive belt")) return "drive_belt_inspection";
  if (s.includes("automatic transmission") && (s.includes("level") || s.includes("fluid"))) return "transmission_at_fluid";
  if (s.includes("steering")) return "steering_inspection";
  if (s.includes("suspension")) return "suspension_inspection";
  if (s.includes("exhaust gas")) return "exhaust_emissions_check";
  if (s.includes("fuel system") || s.includes("fuel lines") || s.includes("fuel hoses")) return "fuel_line_inspection";
  if (s.includes("oil leaks")) return "oil_leak_check";
  if (s.includes("power steering")) return "power_steering_check";
  if (s.includes("exterior lights")) return "exterior_light_check";
  if (s.includes("headlight")) return "headlight_check";
  if (s.includes("wiper")) return "wiper_blades";
  if (s.includes("door hinge")) return "door_hinge_lube";
  if (s.includes("body for corrosion") || (s.includes("corrosion") && s.includes("body"))) return "body_corrosion_check";
  if (s.includes("battery")) return "battery_inspection";
  if (s.includes("drive shaft")) return "drive_shaft_inspection";
  if (s.includes("differential")) return "differential_fluid_check";
  if (s.includes("transfer case")) return "transfer_case_fluid";
  if (s.includes("test drive")) return "test_drive";
  return null;
}

const lines: string[] = [];
lines.push("-- mig 348 — Phase D-2: Mercedes assyst maintenance items + procedures (14 chassis).");
lines.push("-- v3 crawler extracts km/months from page body text when the interval link label has neither.");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

let stats = { chassis: 0, gens: 0, services: 0, procedures: 0 };

for (const cw of crawls) {
  if (cw.error) continue;
  const gens = modelToGens.get(cw.modelId) ?? [];
  if (gens.length === 0) continue;

  const itemAgg = new Map<string, { km: number | null; months: number | null; raw: string }>();
  for (const iv of cw.intervals ?? []) {
    for (const raw of iv.items ?? []) {
      const existing = itemAgg.get(raw);
      if (!existing) itemAgg.set(raw, { km: iv.km ?? null, months: iv.months ?? null, raw });
      else {
        if (iv.km != null && (existing.km == null || iv.km < existing.km)) existing.km = iv.km;
        if (iv.months != null && (existing.months == null || iv.months < existing.months)) existing.months = iv.months;
      }
    }
  }

  const serviceMap = new Map<string, { miles: number | null; km: number | null; months: number | null; notes: string }>();
  for (const [raw, agg] of itemAgg.entries()) {
    const code = mapItemToCode(raw);
    if (code === null) continue;
    const miles = agg.km != null ? Math.round(agg.km * KM_TO_MI / 100) * 100 : null;
    const existing = serviceMap.get(code);
    if (!existing) serviceMap.set(code, { miles, km: agg.km, months: agg.months, notes: raw.slice(0, 90) });
    else {
      if (agg.km != null && (existing.km == null || agg.km < existing.km)) { existing.km = agg.km; existing.miles = miles; }
      if (agg.months != null && (existing.months == null || agg.months < existing.months)) existing.months = agg.months;
    }
  }

  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${cw.modelId}`;
  lines.push("");
  lines.push(`-- ──── ${cw.label ?? cw.modelId} (${gens.length} gens · ${serviceMap.size} mapped) ────`);
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${esc(haynesUrl)} ORDER BY id DESC LIMIT 1);`);

  for (const slug of gens) {
    const genId = slugToId.get(slug);
    if (!genId) continue;
    stats.gens++;
    lines.push(`-- gen ${genId} (${slug})`);
    lines.push(`DELETE si FROM service_intervals si JOIN spec_sources ss ON ss.spec_table='service_intervals' AND ss.spec_id=si.id WHERE si.generation_id=${genId} AND ss.source_id=@s_haynes;`);
    for (const [code, v] of serviceMap.entries()) {
      const km = v.km == null ? "NULL" : String(v.km);
      const mi = v.miles == null ? "NULL" : String(v.miles);
      const mo = v.months == null ? "NULL" : String(v.months);
      const noteCap = v.notes.replace(/[^\x20-\x7E]/g, ' ').slice(0, 90);
      lines.push(`INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) SELECT ${genId}, ${esc(code)}, ${km}, ${mi}, ${mo}, ${esc(noteCap)} WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id=${genId} AND service=${esc(code)});`);
      stats.services++;
    }
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @s_haynes FROM service_intervals WHERE generation_id=${genId};`);
  }
  stats.chassis++;
}

lines.push("");
lines.push("-- Audit");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_services FROM service_intervals;");

writeFileSync("db/migrations/348_mercedes_assyst_maintenance.sql", lines.join("\n"), "utf8");
console.log(`Wrote db/migrations/348_mercedes_assyst_maintenance.sql`);
console.log(`  chassis: ${stats.chassis}  gens: ${stats.gens}  service inserts: ${stats.services}`);
