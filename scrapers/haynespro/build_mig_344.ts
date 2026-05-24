#!/usr/bin/env tsx
/**
 * Phase C-2 mega-migration: per-item service_intervals + procedure titles for
 * all 94 chassis, mapped onto the catalog gens via chassis_registry.
 *
 * Inputs:
 *   scrapers/output/maint_all_chassis.json — 94 chassis × intervals[].items[] + procedures[]
 *   scrapers/haynespro/chassis_registry.json — chassis modelId → catalog_gens
 *   scrapers/output/slug_to_id.tsv — slug → gen_id
 *
 * Output:
 *   db/migrations/344_bulk_service_intervals_procedures.sql
 *
 * Per (chassis, catalog_gen):
 *   - DELETE service_intervals WHERE generation_id=X AND notes LIKE 'HaynesPro modelDetailMaintenance%'
 *     (clears v1 interval-header junk from mig 341 — only Q5 FY had these)
 *   - INSERT mapped service rows (engine_oil_and_filter, brake_inspection, etc.)
 *     at smallest km recurrence
 *   - INSERT procedures rows (title-only, body_md placeholder)
 *   - Cite to HaynesPro source
 */
import { readFileSync, writeFileSync } from "node:fs";

const KM_TO_MI = 0.621371;

type Crawl = {
  modelId: string;
  label?: string;
  intervals?: Array<{ ms: string; mp: string; label: string; km?: number | null; months?: number | null; items?: string[] }>;
  procedures?: Array<{ storyId: string; title: string; subject?: string | null; page?: string | null }>;
  error?: string;
};

const crawls: Crawl[] = JSON.parse(readFileSync("scrapers/output/maint_all_chassis.json", "utf8"));
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

function slugify(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 96);
}

// Map raw HaynesPro item text → canonical snake_case service code
function mapItemToCode(raw: string): string | null {
  const s = raw.toLowerCase();
  if ((s.includes("engine oil") || s.includes("renew the engine oil")) && (s.includes("filter") || s.includes("oil filter"))) return "engine_oil_and_filter";
  if (s.includes("renew the engine oil") || (s.includes("change the oil") && !s.includes("transmission"))) return "engine_oil_and_filter";
  if (s.includes("renew the oil filter")) return null; // dedup with above
  if (s.includes("dust and pollen") || s.includes("cabin filter") || s.includes("pollen filter") || s.includes("cabin air") || s.includes("pollen and odor")) return "cabin_air_filter";
  if (s.includes("air filter") && !s.includes("dust") && !s.includes("pollen") && !s.includes("cabin")) return "engine_air_filter";
  if (s.includes("fuel filter") || s.includes("diesel particulate")) return s.includes("diesel particulate") ? "dpf_inspection" : "fuel_filter";
  if (s.includes("timing belt")) return "timing_belt_replacement";
  if (s.includes("timing chain")) return "timing_chain_inspection";
  if (s.includes("brake pad thickness") || (s.includes("brake pad") && (s.includes("inspect") || s.includes("check")))) return "brake_inspection";
  if (s.includes("brake fluid")) return "brake_fluid_flush";
  if (s.includes("cooling system") || s.includes("coolant") || s.includes("antifreeze")) return "coolant_flush";
  if (s.includes("spark plug")) return "spark_plugs";
  if (s.includes("glow plug")) return "glow_plugs";
  if (s.includes("tyre pressure monitoring") || s.includes("tire pressure monitoring") || s.includes("tpms")) return "tpms_reset";
  if (s.includes("tyre pressure") || s.includes("tire pressure")) return "tire_pressure_check";
  if (s.includes("tread depth") || s.includes("tire wear")) return "tire_inspection";
  if (s.includes("tyre sealant") || s.includes("tire sealant")) return "tire_sealant_check";
  if (s.includes("rotate") && (s.includes("tyre") || s.includes("tire"))) return "tire_rotation";
  if (s.includes("reset the service indicator") || s.includes("service indicator")) return "service_indicator_reset";
  if (s.includes("automatic transmission") && (s.includes("fluid") || s.includes("oil"))) return "transmission_at_fluid";
  if (s.includes("manual transmission") && (s.includes("fluid") || s.includes("oil"))) return "transmission_mt_fluid";
  if (s.includes("cvt") && (s.includes("fluid") || s.includes("oil"))) return "transmission_cvt_fluid";
  if (s.includes("dsg") && (s.includes("fluid") || s.includes("oil"))) return "transmission_dsg_fluid";
  if (s.includes("transmission") && (s.includes("fluid") || s.includes("oil"))) return "transmission_at_fluid";
  if (s.includes("drive shaft") || s.includes("driveshaft")) return "drive_shaft_inspection";
  if (s.includes("steering")) return "steering_inspection";
  if (s.includes("suspension")) return "suspension_inspection";
  if (s.includes("brake lines") || s.includes("brake hoses")) return "brake_line_inspection";
  if (s.includes("exterior lights")) return "exterior_light_check";
  if (s.includes("interior") && s.includes("light")) return "interior_warning_check";
  if (s.includes("instrument cluster")) return "instrument_cluster_check";
  if (s.includes("headlight alignment")) return "headlight_alignment";
  if (s.includes("headlight washing") || s.includes("headlight washer")) return "headlight_washer_check";
  if (s.includes("luggage compartment")) return "luggage_light_check";
  if (s.includes("windscreen wiper park")) return "wiper_park_check";
  if (s.includes("windscreen wiper") || s.includes("windshield wiper")) return "wiper_blades";
  if (s.includes("windscreen washer") || s.includes("washer fluid")) return "washer_fluid_check";
  if (s.includes("door hinge") || s.includes("hinge")) return "door_hinge_lube";
  if (s.includes("underbody")) return "underbody_inspection";
  if (s.includes("engine lower cover")) return "engine_cover_inspection";
  if (s.includes("body for corrosion") || (s.includes("corrosion") && s.includes("body"))) return "body_corrosion_check";
  if (s.includes("first-aid kit") || s.includes("first aid")) return "first_aid_check";
  if (s.includes("warning triangle")) return "warning_triangle_check";
  if (s.includes("horn")) return "horn_check";
  if (s.includes("test drive")) return "test_drive";
  if (s.includes("fuel lines") || s.includes("fuel hoses")) return "fuel_line_inspection";
  if (s.includes("oil leak")) return "oil_leak_check";
  if (s.includes("engine for damage") || s.includes("engine inspection")) return "engine_visual_inspection";
  if (s.includes("wiring loom") || s.includes("wiring harness")) return "wiring_inspection";
  if (s.includes("transfer case") || s.includes("transfer box")) return "transfer_case_fluid";
  if (s.includes("front differential") || s.includes("front diff")) return "front_differential_fluid";
  if (s.includes("rear differential") || s.includes("rear diff") || s.includes("haldex")) return "rear_differential_fluid";
  if (s.includes("seat belt") || s.includes("seat-belt")) return "seat_belt_check";
  if (s.includes("airbag") || s.includes("srs")) return "airbag_inspection";
  if (s.includes("battery")) return "battery_inspection";
  if (s.includes("alternator") || s.includes("starter motor")) return "alternator_inspection";
  if (s.includes("drive belt") || s.includes("accessory belt") || s.includes("ancillary belt")) return "drive_belt_inspection";
  return null;
}

const lines: string[] = [];
lines.push("-- mig 344 — Phase C-2 bulk per-item service_intervals + procedures across 94 chassis.");
lines.push("-- Per (chassis, catalog_gen):");
lines.push("--   DELETE old v1 interval-header service rows (notes LIKE 'HaynesPro modelDetailMaintenance%')");
lines.push("--   INSERT mapped service items at smallest km recurrence (snake_case via mapItemToCode)");
lines.push("--   INSERT procedures (titles only, body_md placeholder)");
lines.push("--   Cite to HaynesPro source");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

let stats = { chassis: 0, gens: 0, services: 0, procedures: 0, unmappedItems: new Map<string, number>(), missingGens: [] as string[] };

for (const cw of crawls) {
  if (cw.error) {
    lines.push(`-- SKIP ${cw.modelId} — crawl error: ${cw.error}`);
    continue;
  }
  const gens = modelToGens.get(cw.modelId) ?? [];
  if (gens.length === 0) {
    lines.push(`-- SKIP ${cw.modelId} (${cw.label ?? "?"}) — no catalog gens`);
    continue;
  }

  // Aggregate items across intervals (smallest km wins)
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

  // Map to snake_case service codes (only keep mapped items + first occurrence per code)
  const serviceMap = new Map<string, { miles: number | null; km: number | null; months: number | null; notes: string }>();
  for (const [raw, agg] of itemAgg.entries()) {
    const code = mapItemToCode(raw);
    if (code === null) {
      stats.unmappedItems.set(raw, (stats.unmappedItems.get(raw) ?? 0) + 1);
      continue;
    }
    const miles = agg.km != null ? Math.round(agg.km * KM_TO_MI / 100) * 100 : null;
    const existing = serviceMap.get(code);
    if (!existing) serviceMap.set(code, { miles, km: agg.km, months: agg.months, notes: raw.slice(0, 90) });
    else {
      if (agg.km != null && (existing.km == null || agg.km < existing.km)) {
        existing.km = agg.km; existing.miles = miles;
      }
      if (agg.months != null && (existing.months == null || agg.months < existing.months)) existing.months = agg.months;
    }
  }

  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${cw.modelId}`;
  lines.push("");
  lines.push(`-- ──── ${cw.label ?? cw.modelId} (${gens.length} catalog gens · ${serviceMap.size} mapped services · ${cw.procedures?.length ?? 0} procedures) ────`);
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${esc(haynesUrl)} ORDER BY id DESC LIMIT 1);`);

  for (const slug of gens) {
    const genId = slugToId.get(slug);
    if (!genId) { stats.missingGens.push(slug); lines.push(`-- SKIP slug=${slug} — not in DB`); continue; }
    stats.gens++;
    lines.push(`-- gen ${genId} (${slug})`);
    // 1. DELETE v1 service interval-header rows
    lines.push(`DELETE ss FROM spec_sources ss JOIN service_intervals si ON si.id = ss.spec_id WHERE ss.spec_table='service_intervals' AND si.generation_id=${genId} AND si.notes LIKE 'HaynesPro modelDetailMaintenance%';`);
    lines.push(`DELETE FROM service_intervals WHERE generation_id=${genId} AND notes LIKE 'HaynesPro modelDetailMaintenance%';`);
    // 2. INSERT mapped service rows (INSERT IGNORE on (gen, service) to skip duplicates with existing scraper rows)
    for (const [code, v] of serviceMap.entries()) {
      const km = v.km == null ? "NULL" : String(v.km);
      const mi = v.miles == null ? "NULL" : String(v.miles);
      const mo = v.months == null ? "NULL" : String(v.months);
      const noteCap = v.notes.replace(/[^\x20-\x7E]/g, ' ').slice(0, 90);
      lines.push(`INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) SELECT ${genId}, ${esc(code)}, ${km}, ${mi}, ${mo}, ${esc(noteCap)} WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id=${genId} AND service=${esc(code)});`);
      stats.services++;
    }
    // 3. INSERT procedures
    for (const p of (cw.procedures ?? [])) {
      const procType = p.page === "SERVICERESET" ? "service_reset" : p.page === "SCHEDULES" ? "schedule_note" : "maintenance";
      const slugVal = slugify(`${procType}-${p.title}`).slice(0, 96);
      const title = p.title.slice(0, 255);
      lines.push(`INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) SELECT ${genId}, ${esc(procType)}, ${esc(slugVal)}, ${esc(title)}, ${esc(`(See HaynesPro WorkshopData for full procedure — storyId ${p.storyId})`)}, NULL, NULL WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id=${genId} AND slug=${esc(slugVal)});`);
      stats.procedures++;
    }
    // 4. Cite to HaynesPro
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @s_haynes FROM service_intervals WHERE generation_id=${genId};`);
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @s_haynes FROM procedures WHERE generation_id=${genId};`);
  }
  stats.chassis++;
}

lines.push("");
lines.push("-- Audit");
lines.push("SELECT 'gens_with_services' AS metric, COUNT(DISTINCT generation_id) FROM service_intervals;");
lines.push("UNION ALL SELECT 'gens_with_procedures', COUNT(DISTINCT generation_id) FROM procedures;");
lines.push("UNION ALL SELECT 'total_services', COUNT(*) FROM service_intervals;");
lines.push("UNION ALL SELECT 'total_procedures', COUNT(*) FROM procedures;");

writeFileSync("db/migrations/344_bulk_service_intervals_procedures.sql", lines.join("\n"), "utf8");
console.log("Wrote db/migrations/344_bulk_service_intervals_procedures.sql");
console.log(`  chassis: ${stats.chassis}  gens: ${stats.gens}  service inserts: ${stats.services}  procedure inserts: ${stats.procedures}`);
console.log(`  unmapped items (top 10):`);
const top = [...stats.unmappedItems.entries()].sort((a,b)=>b[1]-a[1]).slice(0,10);
for (const [k,v] of top) console.log(`    ${v}× ${k}`);
if (stats.missingGens.length) console.log(`  ⚠ missing gens: ${stats.missingGens.length}`);
