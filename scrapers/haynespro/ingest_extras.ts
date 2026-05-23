#!/usr/bin/env tsx
/**
 * HaynesPro exhaustive crawl → SQL ingest for torque_specs + electrical_specs
 * + service_intervals + procedures.
 *
 * Companion to ingest_multi_gen.ts (which handles fluid_specs only). This
 * picks up the gap: HaynesPro exposes torque settings, battery, service
 * intervals, and procedure titles via adjustmentData + modelDetailMaintenance
 * endpoints — and they weren't being captured by the lubricants-only crawls.
 *
 * Usage:
 *   npx tsx scrapers/haynespro/ingest_extras.ts \
 *     scrapers/output/haynespro-exhaustive-q5-fy-2026-05-24.json \
 *     --gen-id 82 \
 *     --slug q5-fy \
 *     --mig-number 341
 *
 * All inserts use INSERT...WHERE NOT EXISTS guards on the natural keys so
 * existing hand-seeded rows are preserved.
 */

import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

type EngineRecord = {
  typeId: string;
  type: string;
  engine_code: string | null;
  cc: number | null;
  kw: number | null;
  years: string;
  adjustment?: {
    torques?: { fastener: string; torque_nm: number }[];
    electrical?: { equipment_code: string; capacity_ah: number; cca_din_a: number | null; chemistry: string | null }[];
  } | null;
  maintenance?: {
    procedures?: { title: string; storyId: string; subject: string | null; page: string | null }[];
    intervals?: { label: string; ms: string; mp: string; items?: string[] }[];
  } | null;
};

type Crawl = {
  chassis: { modelId: string; label: string | null; engines_count: number; fetched_at?: string };
  types: EngineRecord[];
};

function arg(flag: string): string | null {
  const i = process.argv.indexOf(flag);
  return i < 0 ? null : process.argv[i + 1];
}

function escapeSql(s: string | null | undefined): string {
  if (s == null) return "NULL";
  return "'" + String(s).replace(/'/g, "''") + "'";
}

function num(n: number | null | undefined): string {
  return n == null ? "NULL" : String(n);
}

function slugify(s: string): string {
  return s.toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 96);
}

function parseInterval(label: string): { km: number | null; miles: number | null; months: number | null } {
  // "15,000 km/12 months", "30,000 km/24 months", or "Timing belt intervals" (no numeric)
  const km = label.match(/([\d,]+)\s*km/);
  const months = label.match(/(\d+)\s*months?/);
  return {
    km: km ? parseInt(km[1].replace(/,/g, ""), 10) : null,
    miles: km ? Math.round(parseInt(km[1].replace(/,/g, ""), 10) * 0.621371) : null,
    months: months ? parseInt(months[1], 10) : null,
  };
}

function main() {
  const path = process.argv[2];
  if (!path) { console.error("Usage: ingest_extras.ts <crawl.json> --gen-id N --slug SLUG [--mig-number NNN]"); process.exit(1); }
  const genId = arg("--gen-id");
  const slug = arg("--slug");
  const migNumber = arg("--mig-number") ?? "XXX";
  if (!genId || !slug) { console.error("--gen-id and --slug are required"); process.exit(1); }

  const crawl: Crawl = JSON.parse(readFileSync(path, "utf8"));
  const gen = parseInt(genId, 10);

  // Dedupe per natural keys
  const torquesByKey = new Map<string, { fastener: string; torque_nm: number }>();
  const electricalByEquipment = new Map<string, { equipment_code: string; capacity_ah: number; cca_din_a: number | null; chemistry: string | null }>();
  const proceduresByStoryId = new Map<string, { title: string; storyId: string; subject: string | null; page: string | null }>();
  const intervalsByMp = new Map<string, { label: string; ms: string; mp: string }>();

  for (const t of crawl.types) {
    for (const x of t.adjustment?.torques ?? []) {
      const k = `${x.fastener}|${x.torque_nm}`;
      if (!torquesByKey.has(k)) torquesByKey.set(k, x);
    }
    for (const x of t.adjustment?.electrical ?? []) {
      if (!electricalByEquipment.has(x.equipment_code)) electricalByEquipment.set(x.equipment_code, x);
    }
    for (const x of t.maintenance?.procedures ?? []) {
      if (!proceduresByStoryId.has(x.storyId)) proceduresByStoryId.set(x.storyId, x);
    }
    for (const x of t.maintenance?.intervals ?? []) {
      if (!intervalsByMp.has(x.mp)) intervalsByMp.set(x.mp, x);
    }
  }

  const lines: string[] = [];
  lines.push(`-- mig ${migNumber} — ingest_extras: ${crawl.chassis.label ?? slug} (gen_id ${gen})`);
  lines.push(`-- Crawl source: ${path}`);
  lines.push(`-- ${torquesByKey.size} torques · ${electricalByEquipment.size} batteries · ${proceduresByStoryId.size} procedures · ${intervalsByMp.size} intervals`);
  lines.push("");
  lines.push("SET NAMES utf8mb4;");
  lines.push("");

  // 1) HaynesPro source row (re-use existing if present)
  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${crawl.chassis.modelId}`;
  lines.push("-- 1. HaynesPro source row (re-uses existing if present)");
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${escapeSql(haynesUrl)} ORDER BY id DESC LIMIT 1);`);
  lines.push("");

  // 2) torque_specs — fastener-scoped, gen-wide (no engine_id since HaynesPro torques apply across engine variants)
  if (torquesByKey.size > 0) {
    lines.push(`-- 2. torque_specs (${torquesByKey.size} rows)`);
    for (const t of torquesByKey.values()) {
      const ftlb = Math.round(t.torque_nm * 0.7376);
      lines.push(`INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)`);
      lines.push(`SELECT ${gen}, ${escapeSql(t.fastener.slice(0, 64))}, ${num(t.torque_nm)}, ${num(ftlb)}, 'HaynesPro adjustmentData'`);
      lines.push(`WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = ${gen} AND fastener = ${escapeSql(t.fastener.slice(0, 64))});`);
    }
    lines.push("");
  }

  // 3) electrical_specs — battery info per equipment code
  if (electricalByEquipment.size > 0) {
    lines.push(`-- 3. electrical_specs (${electricalByEquipment.size} rows)`);
    for (const e of electricalByEquipment.values()) {
      const eqShort = e.equipment_code.slice(0, 24);
      lines.push(`INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)`);
      lines.push(`SELECT ${gen}, ${escapeSql(eqShort)}, ${num(e.cca_din_a)}, ${num(e.capacity_ah)}, NULL`);
      lines.push(`WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = ${gen} AND battery_group = ${escapeSql(eqShort)});`);
    }
    lines.push("");
  }

  // 4) service_intervals — interval headers only (km/months), no per-service items yet
  if (intervalsByMp.size > 0) {
    lines.push(`-- 4. service_intervals (${intervalsByMp.size} interval headers; no per-service items yet)`);
    for (const iv of intervalsByMp.values()) {
      const { km, miles, months } = parseInterval(iv.label);
      // Skip non-numeric (Timing belt intervals, Service Item Intervals)
      if (km == null && months == null) continue;
      const svc = iv.label.slice(0, 96);
      lines.push(`INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)`);
      lines.push(`SELECT ${gen}, ${escapeSql(svc)}, ${num(km)}, ${num(miles)}, ${num(months)}, 'HaynesPro modelDetailMaintenance (interval header)'`);
      lines.push(`WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = ${gen} AND service = ${escapeSql(svc)});`);
    }
    lines.push("");
  }

  // 5) procedures — title + storyId (no body_md captured yet — separate fetch per storyId)
  if (proceduresByStoryId.size > 0) {
    lines.push(`-- 5. procedures (${proceduresByStoryId.size} titles; body_md empty until repairManuals fetch)`);
    for (const p of proceduresByStoryId.values()) {
      const procType = p.page === "SERVICERESET" ? "service_reset" : p.page === "SCHEDULES" ? "schedule_note" : "maintenance";
      const slugVal = slugify(`${procType}-${p.title}`);
      lines.push(`INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)`);
      lines.push(`SELECT ${gen}, ${escapeSql(procType)}, ${escapeSql(slugVal.slice(0, 96))}, ${escapeSql(p.title.slice(0, 255))}, '(See HaynesPro WorkshopData for full procedure — storyId ${p.storyId})', NULL, NULL`);
      lines.push(`WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = ${gen} AND slug = ${escapeSql(slugVal.slice(0, 96))});`);
    }
    lines.push("");
  }

  // 6) Citations
  lines.push("-- 6. spec_sources — link new torque/electrical/service/procedure rows to HaynesPro");
  lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)`);
  lines.push(`SELECT 'torque_specs', id, @s_haynes FROM torque_specs WHERE generation_id = ${gen};`);
  lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)`);
  lines.push(`SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id = ${gen};`);
  lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)`);
  lines.push(`SELECT 'service_intervals', id, @s_haynes FROM service_intervals WHERE generation_id = ${gen};`);
  lines.push(`INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)`);
  lines.push(`SELECT 'procedures', id, @s_haynes FROM procedures WHERE generation_id = ${gen};`);
  lines.push("");

  // Audit
  lines.push("-- Audit");
  lines.push(`SELECT 'torque_specs' AS spec, COUNT(*) AS n FROM torque_specs WHERE generation_id = ${gen}`);
  lines.push(`UNION ALL SELECT 'electrical_specs', COUNT(*) FROM electrical_specs WHERE generation_id = ${gen}`);
  lines.push(`UNION ALL SELECT 'service_intervals', COUNT(*) FROM service_intervals WHERE generation_id = ${gen}`);
  lines.push(`UNION ALL SELECT 'procedures', COUNT(*) FROM procedures WHERE generation_id = ${gen};`);

  const outPath = resolve(process.cwd(), `db/migrations/${migNumber}_ingest_extras_${slug}.sql`);
  writeFileSync(outPath, lines.join("\n"), "utf8");
  console.log(`Wrote ${outPath}`);
  console.log(`  torques=${torquesByKey.size}  electrical=${electricalByEquipment.size}  intervals=${intervalsByMp.size}  procedures=${proceduresByStoryId.size}`);
}

main();
