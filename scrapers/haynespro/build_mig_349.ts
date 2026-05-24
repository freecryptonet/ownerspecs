#!/usr/bin/env tsx
/**
 * Phase D-3: BMW/Mercedes battery ingest (parseElectricalV2 fallback).
 *
 * Input: scrapers/output/bat_all.json — 68 non-Audi chassis × extracted batteries
 * (BMW/MB format: 'Battery capacity N (Ah)' without preceding 'Equipment code'.
 *  Synthesised equipment_code as 'STD-NAh'.)
 *
 * Per (chassis, catalog_gen): INSERT IGNORE electrical_specs rows. Doesn't
 * delete existing rows — pre-existing electrical from mig 343 (Audi-format)
 * remains. spec_sources cite to workshop source.
 */
import { readFileSync, writeFileSync } from "node:fs";

const crawls = JSON.parse(readFileSync("scrapers/output/bat_all.json", "utf8"));
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

const lines: string[] = [];
lines.push("-- mig 349 — Phase D-3: BMW/Mercedes battery ingest");
lines.push("-- parseElectricalV2 fallback extracts 'Battery capacity N (Ah)' without 'Equipment code' header.");
lines.push("-- Synthesised equipment_code 'STD-NAh' when BMW/MB doesn't expose an OE code.");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

let stats = { chassis: 0, gens: 0, inserts: 0 };

for (const cw of crawls) {
  if (cw.error || !cw.batteries || cw.batteries.length === 0) continue;
  const gens = modelToGens.get(cw.modelId) ?? [];
  if (gens.length === 0) continue;
  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${cw.modelId}`;
  lines.push("");
  lines.push(`-- ──── ${cw.label ?? cw.modelId} (${gens.length} gens · ${cw.batteries.length} batteries) ────`);
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${esc(haynesUrl)} ORDER BY id DESC LIMIT 1);`);
  for (const slug of gens) {
    const genId = slugToId.get(slug);
    if (!genId) continue;
    stats.gens++;
    for (const b of cw.batteries) {
      const cca = b.cca_din_a == null ? "NULL" : String(b.cca_din_a);
      const ah = b.capacity_ah == null ? "NULL" : String(b.capacity_ah);
      // Drop synthesized 'STD-NAh' battery_group — Tim's rule: no invented data.
      // Only persist the real OE equipment_code (Audi format). For BMW/MB the
      // workshop database doesn't expose a group code → battery_group = NULL.
      const realGroup = b.equipment_code && !b.equipment_code.startsWith("STD-") ? esc(b.equipment_code) : "NULL";
      lines.push(`INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (${genId}, ${realGroup}, ${cca}, ${ah}, NULL);`);
      stats.inserts++;
    }
    lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=${genId};`);
  }
  stats.chassis++;
}

lines.push("");
lines.push("-- Audit");
lines.push("SELECT COUNT(DISTINCT generation_id) AS gens_with_electrical FROM electrical_specs;");

writeFileSync("db/migrations/349_bmw_mb_batteries.sql", lines.join("\n"), "utf8");
console.log(`Wrote db/migrations/349_bmw_mb_batteries.sql`);
console.log(`  chassis: ${stats.chassis}  gens: ${stats.gens}  inserts: ${stats.inserts}`);
