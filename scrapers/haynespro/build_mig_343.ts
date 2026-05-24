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
lines.push("--   - DELETE old auto-imported torque_specs (rows linked to @s_haynes via spec_sources)");
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
    // 1. DELETE old auto-imported torque rows (identified by spec_sources -> @s_haynes linkage)
    lines.push(`DELETE ts FROM torque_specs ts JOIN spec_sources ss ON ss.spec_table='torque_specs' AND ss.spec_id=ts.id WHERE ts.generation_id=${genId} AND ss.source_id=@s_haynes;`);
    // 2. INSERT new clean torques (notes NULL — never expose ingest provenance publicly)
    for (const t of (cw.torques ?? [])) {
      const ftlb = Math.round(t.torque_nm * 0.7376);
      lines.push(`INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES (${genId}, ${esc(t.fastener)}, ${t.torque_nm}, ${ftlb}, NULL);`);
      stats.torquesInserted++;
    }
    // 3. INSERT electrical (only if chassis has data)
    for (const e of (cw.electrical ?? [])) {
      const cca = e.cca_din_a == null ? "NULL" : String(e.cca_din_a);
      const ah = e.capacity_ah == null ? "NULL" : String(e.capacity_ah);
      lines.push(`INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (${genId}, ${esc(e.equipment_code)}, ${cca}, ${ah}, NULL);`);
      stats.electricalInserted++;
    }
    // 4. Cite all rows for this gen to the workshop source (notes is now NULL,
    //    so cite EVERY torque row for the gen — handles the case where this
    //    script is run multiple times; INSERT IGNORE prevents dupes)
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_haynes FROM torque_specs WHERE generation_id=${genId};`);
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=${genId};`);
  }
  stats.chassisProcessed++;
}

lines.push("");
lines.push("-- Audit");
lines.push("SELECT COUNT(*) AS total_torques FROM torque_specs;");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_torques FROM torque_specs;");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_electrical FROM electrical_specs;");

writeFileSync("db/migrations/343_bulk_clean_torques_electrical.sql", lines.join("\n"), "utf8");
console.log("Wrote db/migrations/343_bulk_clean_torques_electrical.sql");
console.log(`  chassis processed: ${stats.chassisProcessed}`);
console.log(`  catalog gens touched: ${stats.gensTouched}`);
console.log(`  torque inserts: ${stats.torquesInserted}`);
console.log(`  electrical inserts: ${stats.electricalInserted}`);
if (stats.missingGens.length) console.log(`  ⚠ ${stats.missingGens.length} gen slugs missing from DB:`, stats.missingGens.slice(0, 10));
