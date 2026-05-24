#!/usr/bin/env tsx
/**
 * Phase C-1 mega-migration builder. Reads:
 *   scrapers/output/bulk_all_chassis.json — 94 chassis × torques + electrical
 *   scrapers/haynespro/chassis_registry.json — chassis → catalog_gens mapping
 *   scrapers/output/slug_to_id.tsv — gen slug → gen_id from DB
 *
 * Emits db/migrations/343_bulk_clean_torques_electrical.sql which:
 *   1. For each (chassis, catalog_gen) pair:
 *      - DELETE existing torque_specs WHERE generation_id=X AND notes='HaynesPro adjustmentData'
 *        (clears v1-parser junk from earlier today's wave)
 *      - INSERT N clean torques from the chassis crawl
 *      - INSERT M electrical_specs (where chassis has electrical data)
 *   2. Re-link all new rows to existing HaynesPro source via spec_sources.
 */
import { readFileSync, writeFileSync } from "node:fs";

type Crawl = { modelId: string; label?: string; engines?: number; errors?: number; uniqueTorques?: number; uniqueElectrical?: number; torques?: Array<{ fastener: string; torque_nm: number }>; electrical?: Array<{ equipment_code: string; capacity_ah: number; cca_din_a: number | null; chemistry: string | null }>; error?: string };

const crawls: Crawl[] = JSON.parse(readFileSync("scrapers/output/bulk_all_chassis.json", "utf8"));
const registry = JSON.parse(readFileSync("scrapers/haynespro/chassis_registry.json", "utf8"));
const slugTsv = readFileSync("scrapers/output/slug_to_id.tsv", "utf8").trim().split("\n").slice(1);
const slugToId = new Map<string, number>();
for (const line of slugTsv) {
  const [id, slug] = line.split("\t");
  slugToId.set(slug, parseInt(id, 10));
}

// Build modelId → catalog gen slugs
const modelToGens = new Map<string, string[]>();
for (const v of Object.values(registry.chassis) as Array<any>) {
  if (typeof v !== "object" || !v.modelId) continue;
  modelToGens.set(v.modelId, v.catalog_gens ?? []);
}

function esc(s: string | null): string {
  if (s == null) return "NULL";
  return "'" + s.replace(/'/g, "''") + "'";
}

const lines: string[] = [];
lines.push("-- mig 343 — Phase C-1 bulk cleanup: replace v1-parser torque junk + add electrical");
lines.push("-- across 94 HaynesPro chassis, covering all currently-affected catalog gens.");
lines.push("--");
lines.push("-- Per chassis × catalog gen:");
lines.push("--   - DELETE old torque_specs with notes='HaynesPro adjustmentData' (v1-parser junk)");
lines.push("--   - INSERT new clean torques (line-aware parser, deduped across all chassis engines)");
lines.push("--   - INSERT electrical_specs rows where chassis has battery data");
lines.push("--   - Cite all new rows to existing HaynesPro source for that chassis");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

let stats = { chassisProcessed: 0, gensTouched: 0, torquesInserted: 0, electricalInserted: 0, missingGens: [] as string[] };

for (const cw of crawls) {
  if (cw.error) {
    lines.push(`-- SKIP ${cw.modelId} — crawl error: ${cw.error}`);
    continue;
  }
  const gens = modelToGens.get(cw.modelId) ?? [];
  if (gens.length === 0) {
    lines.push(`-- SKIP ${cw.modelId} (${cw.label ?? "?"}) — no catalog gens in registry`);
    continue;
  }
  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${cw.modelId}`;
  lines.push("");
  lines.push(`-- ──── ${cw.label ?? cw.modelId} (${gens.length} catalog gens · ${cw.torques?.length ?? 0} torques · ${cw.electrical?.length ?? 0} electrical) ────`);
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${esc(haynesUrl)} ORDER BY id DESC LIMIT 1);`);

  for (const slug of gens) {
    const genId = slugToId.get(slug);
    if (!genId) {
      stats.missingGens.push(slug);
      lines.push(`-- SKIP gen slug=${slug} — not found in DB`);
      continue;
    }
    stats.gensTouched++;
    lines.push(`-- gen ${genId} (${slug})`);
    // 1. DELETE old v1 torque rows
    lines.push(`DELETE ss FROM spec_sources ss JOIN torque_specs ts ON ts.id = ss.spec_id WHERE ss.spec_table='torque_specs' AND ts.generation_id=${genId} AND ts.notes='HaynesPro adjustmentData';`);
    lines.push(`DELETE FROM torque_specs WHERE generation_id=${genId} AND notes='HaynesPro adjustmentData';`);
    // 2. INSERT new clean torques
    for (const t of (cw.torques ?? [])) {
      const ftlb = Math.round(t.torque_nm * 0.7376);
      lines.push(`INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES (${genId}, ${esc(t.fastener)}, ${t.torque_nm}, ${ftlb}, 'HaynesPro adjustmentData');`);
      stats.torquesInserted++;
    }
    // 3. INSERT electrical (only if chassis has data)
    for (const e of (cw.electrical ?? [])) {
      const cca = e.cca_din_a == null ? "NULL" : String(e.cca_din_a);
      const ah = e.capacity_ah == null ? "NULL" : String(e.capacity_ah);
      lines.push(`INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (${genId}, ${esc(e.equipment_code)}, ${cca}, ${ah}, NULL);`);
      stats.electricalInserted++;
    }
    // 4. Cite all rows for this gen to the HaynesPro source
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_haynes FROM torque_specs WHERE generation_id=${genId} AND notes='HaynesPro adjustmentData';`);
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=${genId};`);
  }
  stats.chassisProcessed++;
}

lines.push("");
lines.push("-- Audit");
lines.push("SELECT COUNT(*) AS total_torques_with_haynespro FROM torque_specs WHERE notes='HaynesPro adjustmentData';");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_torques FROM torque_specs;");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_electrical FROM electrical_specs;");

writeFileSync("db/migrations/343_bulk_clean_torques_electrical.sql", lines.join("\n"), "utf8");
console.log("Wrote db/migrations/343_bulk_clean_torques_electrical.sql");
console.log(`  chassis processed: ${stats.chassisProcessed}`);
console.log(`  catalog gens touched: ${stats.gensTouched}`);
console.log(`  torque inserts: ${stats.torquesInserted}`);
console.log(`  electrical inserts: ${stats.electricalInserted}`);
if (stats.missingGens.length) console.log(`  ⚠ ${stats.missingGens.length} gen slugs missing from DB:`, stats.missingGens.slice(0, 10));
