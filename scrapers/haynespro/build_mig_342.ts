#!/usr/bin/env tsx
/**
 * One-off: build mig 342 to (a) replace the junky Q5 FY torque_specs rows
 * (parenthetical fragments captured as fastener names by the v1 parser), and
 * (b) replace the gen-wide interval-header service_intervals rows with
 * per-item rows derived from per-interval maintenanceSchedule fetches.
 *
 * Inputs:
 *   scrapers/output/q5-fy-torques-recrawl.json        — new line-aware parser output
 *   scrapers/output/q5-fy-maintenance-items.json      — per-interval items
 *
 * Output:
 *   db/migrations/342_q5_fy_cleanup_torque_intervals.sql
 */
import { readFileSync, writeFileSync } from "node:fs";

const GEN_ID = 82;

type TorqueRow = { fastener: string; torque_nm: number };
type CrawlT = { results: Array<{ torques?: TorqueRow[] }> };
type Item = { km: number | null; months: number | null };
type CrawlM = { intervals: Array<{ ms: string; mp: string; label: string; items?: string[] }> };

const torquesIn: CrawlT = JSON.parse(readFileSync("scrapers/output/q5-fy-torques-recrawl.json", "utf8"));
const maintIn: CrawlM = JSON.parse(readFileSync("scrapers/output/q5-fy-maintenance-items.json", "utf8"));

// ────── Aggregate torques ──────
const torquesMap = new Map<string, TorqueRow>();
for (const r of torquesIn.results) {
  for (const t of r.torques ?? []) {
    const key = `${t.fastener}|${t.torque_nm}`;
    if (!torquesMap.has(key)) torquesMap.set(key, t);
  }
}

// ────── Aggregate service items by smallest km ──────
const itemMap = new Map<string, Item>();
for (const iv of maintIn.intervals) {
  const km = iv.label.match(/([\d,]+)\s*km/);
  const months = iv.label.match(/(\d+)\s*months?/);
  if (!km && !months) continue;
  const kmN = km ? parseInt(km[1].replace(/,/g, ""), 10) : null;
  const moN = months ? parseInt(months[1], 10) : null;
  for (const raw of iv.items ?? []) {
    const existing = itemMap.get(raw);
    if (!existing) itemMap.set(raw, { km: kmN, months: moN });
    else {
      if (kmN != null && (existing.km == null || kmN < existing.km)) existing.km = kmN;
      if (moN != null && (existing.months == null || moN < existing.months)) existing.months = moN;
    }
  }
}

// ────── Map raw HaynesPro item text → canonical snake_case service code ──────
// Codes that already have labels in lib/labels.ts get matched first. Unknowns
// fall back to a slugified short form so they still render via humanize().
function mapItemToCode(raw: string): string | null {
  const s = raw.toLowerCase();
  if (s.includes("engine oil") && s.includes("filter")) return "engine_oil_and_filter";
  if (s.includes("renew the engine oil")) return "engine_oil_and_filter";
  if (s.includes("renew the oil filter")) return null; // covered by combined row
  if (s.includes("dust and pollen") || s.includes("cabin filter") || s.includes("pollen filter")) return "cabin_air_filter";
  if (s.includes("air filter") && !s.includes("dust") && !s.includes("pollen")) return "engine_air_filter";
  if (s.includes("fuel filter")) return "fuel_filter";
  if (s.includes("timing belt")) return "timing_belt_replacement";
  if (s.includes("brake pad thickness") || s.includes("brake pad")) return "brake_inspection";
  if (s.includes("brake fluid")) return "brake_fluid_flush";
  if (s.includes("cooling system") || s.includes("coolant")) return "coolant_flush";
  if (s.includes("spark plug")) return "spark_plugs";
  if (s.includes("tyre pressure") && s.includes("monitoring")) return "tpms_reset";
  if (s.includes("tyre pressure")) return "tire_pressure_check";
  if (s.includes("tyre") && s.includes("tread depth")) return "tire_inspection";
  if (s.includes("tyre sealant")) return "tire_sealant_check";
  if (s.includes("reset the service indicator")) return "service_indicator_reset";
  if (s.includes("transmission")) return "transmission_at_fluid";
  if (s.includes("drive shaft")) return "drive_shaft_inspection";
  if (s.includes("steering assembly")) return "steering_inspection";
  if (s.includes("suspension protective boots")) return "suspension_boot_inspection";
  if (s.includes("brake lines")) return "brake_line_inspection";
  if (s.includes("exterior lights")) return "exterior_light_check";
  if (s.includes("interior warning lights")) return "interior_warning_check";
  if (s.includes("instrument cluster")) return "instrument_cluster_check";
  if (s.includes("headlight alignment")) return "headlight_alignment";
  if (s.includes("luggage compartment")) return "luggage_light_check";
  if (s.includes("headlight washing")) return "headlight_washer_check";
  if (s.includes("windscreen wiper park")) return "wiper_park_check";
  if (s.includes("windscreen wipers")) return "wiper_blades";
  if (s.includes("door hinges")) return "door_hinge_lube";
  if (s.includes("underbody protective")) return "underbody_inspection";
  if (s.includes("engine lower cover")) return "engine_cover_inspection";
  if (s.includes("body for corrosion")) return "body_corrosion_check";
  if (s.includes("first-aid kit")) return "first_aid_check";
  if (s.includes("warning triangle")) return "warning_triangle_check";
  if (s.includes("horn")) return "horn_check";
  if (s.includes("test drive")) return "test_drive";
  if (s.includes("fuel lines") || s.includes("fuel hoses")) return "fuel_line_inspection";
  if (s.includes("oil leaks")) return "oil_leak_check";
  if (s.includes("engine for damage")) return "engine_visual_inspection";
  if (s.includes("wiring looms")) return "wiring_inspection";
  return null;
}

const serviceRows = new Map<string, { miles: number | null; km: number | null; months: number | null; notes: string }>();
const KM_TO_MI = 0.621371;
for (const [raw, iv] of itemMap.entries()) {
  const code = mapItemToCode(raw);
  if (code === null) continue;
  const existing = serviceRows.get(code);
  const km = iv.km;
  const miles = km != null ? Math.round(km * KM_TO_MI / 100) * 100 : null; // round to nearest 100mi
  const months = iv.months;
  if (!existing) {
    serviceRows.set(code, { miles, km, months, notes: raw.length < 90 ? raw : null });
  } else {
    if (km != null && (existing.km == null || km < existing.km)) {
      existing.km = km; existing.miles = miles;
    }
    if (months != null && (existing.months == null || months < existing.months)) existing.months = months;
  }
}

// ────── Build SQL ──────
const lines: string[] = [];
lines.push("-- mig 342 — Q5 FY (gen_id 82) cleanup: replace v1-parser junk with new clean rows.");
lines.push("--   torque_specs: drop 105 v1 rows (notes='HaynesPro adjustmentData' from mig 341),");
lines.push("--                 insert " + torquesMap.size + " unique torques from new line-aware parser.");
lines.push("--   service_intervals: drop 33 interval-header rows from mig 341,");
lines.push("--                 insert " + serviceRows.size + " per-item rows mapped to snake_case codes.");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

lines.push("-- 1. Resolve existing HaynesPro source ID");
lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449' ORDER BY id DESC LIMIT 1);`);
lines.push("");

lines.push("-- 2. DELETE v1 junk torque rows");
lines.push(`DELETE ss FROM spec_sources ss JOIN torque_specs ts ON ts.id = ss.spec_id WHERE ss.spec_table = 'torque_specs' AND ts.generation_id = ${GEN_ID} AND ts.notes = 'HaynesPro adjustmentData';`);
lines.push(`DELETE FROM torque_specs WHERE generation_id = ${GEN_ID} AND notes = 'HaynesPro adjustmentData';`);
lines.push("");

lines.push("-- 3. DELETE v1 interval-header service rows");
lines.push(`DELETE ss FROM spec_sources ss JOIN service_intervals si ON si.id = ss.spec_id WHERE ss.spec_table = 'service_intervals' AND si.generation_id = ${GEN_ID} AND si.notes LIKE 'HaynesPro modelDetailMaintenance%';`);
lines.push(`DELETE FROM service_intervals WHERE generation_id = ${GEN_ID} AND notes LIKE 'HaynesPro modelDetailMaintenance%';`);
lines.push("");

lines.push(`-- 4. INSERT ${torquesMap.size} clean torque rows`);
function esc(s: string | null): string {
  if (s == null) return "NULL";
  return "'" + s.replace(/'/g, "''") + "'";
}
for (const t of torquesMap.values()) {
  const ftlb = Math.round(t.torque_nm * 0.7376);
  lines.push(`INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES (${GEN_ID}, ${esc(t.fastener)}, ${t.torque_nm}, ${ftlb}, 'HaynesPro adjustmentData');`);
}
lines.push("");

lines.push(`-- 5. INSERT ${serviceRows.size} per-item service rows`);
for (const [code, v] of serviceRows.entries()) {
  const km = v.km == null ? "NULL" : String(v.km);
  const mi = v.miles == null ? "NULL" : String(v.miles);
  const mo = v.months == null ? "NULL" : String(v.months);
  lines.push(`INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES (${GEN_ID}, ${esc(code)}, ${km}, ${mi}, ${mo}, ${esc(v.notes ?? "HaynesPro maintenanceSchedule")});`);
}
lines.push("");

lines.push("-- 6. Citations");
lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_haynes FROM torque_specs WHERE generation_id = ${GEN_ID} AND notes = 'HaynesPro adjustmentData';`);
lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @s_haynes FROM service_intervals WHERE generation_id = ${GEN_ID} AND (notes = 'HaynesPro maintenanceSchedule' OR notes IS NOT NULL);`);
lines.push("");

lines.push("-- Audit");
lines.push(`SELECT 'torque_specs' AS spec, COUNT(*) FROM torque_specs WHERE generation_id = ${GEN_ID} UNION ALL SELECT 'service_intervals', COUNT(*) FROM service_intervals WHERE generation_id = ${GEN_ID};`);

writeFileSync("db/migrations/342_q5_fy_cleanup_torque_intervals.sql", lines.join("\n"), "utf8");
console.log("Wrote db/migrations/342_q5_fy_cleanup_torque_intervals.sql");
console.log(`  torques=${torquesMap.size}  service_items=${serviceRows.size}`);
