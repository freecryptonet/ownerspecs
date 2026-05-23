#!/usr/bin/env tsx
/**
 * HaynesPro crawl diff — compare two chassis crawl JSONs.
 *
 * Use case: periodic re-crawl picks up new model years / engine codes
 * HaynesPro adds, and existing engines occasionally get capacity or
 * spec updates. This script tells you what's NEW, REMOVED, or CHANGED
 * since last crawl.
 *
 * Usage:
 *   npx tsx scrapers/haynespro/diff_crawls.ts \
 *     scrapers/output/haynespro-crawl-q5-fy-2026-05-23.json \
 *     scrapers/output/haynespro-crawl-q5-fy-2026-08-15.json
 *
 * Output: Markdown report on stdout, also written to
 * scrapers/output/haynespro-diff-{label}-{old}-vs-{new}.md
 */

import { readFileSync, writeFileSync } from "node:fs";
import { resolve, basename } from "node:path";

type EngineRecord = {
  typeId: string;
  type: string;
  engine_code: string | null;
  cc: number | null;
  kw: number | null;
  years: string;
  oil?: {
    visc: string | null;
    spec: string | null;
    sump_l: number | null;
    drain_nm: number | null;
  } | null;
  coolant?: {
    spec: string | null;
    capacity_l: number | null;
  } | null;
};

type Crawl = {
  chassis: {
    modelId: string;
    label: string | null;
    engines_count: number;
    fetched_at: string;
  };
  types: EngineRecord[];
};

function loadCrawl(path: string): Crawl {
  return JSON.parse(readFileSync(path, "utf8"));
}

function eqLoose(a: unknown, b: unknown): boolean {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  return String(a).trim() === String(b).trim();
}

function diffEngine(oldR: EngineRecord, newR: EngineRecord): string[] {
  const changes: string[] = [];
  // Identity-fields drift (unlikely but checked)
  if (oldR.engine_code !== newR.engine_code) changes.push(`engine_code: '${oldR.engine_code}' → '${newR.engine_code}'`);
  if (oldR.cc !== newR.cc) changes.push(`cc: ${oldR.cc} → ${newR.cc}`);
  if (oldR.kw !== newR.kw) changes.push(`kw: ${oldR.kw} → ${newR.kw}`);
  if (oldR.years !== newR.years) changes.push(`years: '${oldR.years}' → '${newR.years}'`);
  // Oil
  const o1 = oldR.oil ?? {} as any;
  const o2 = newR.oil ?? {} as any;
  if (!eqLoose(o1.visc, o2.visc)) changes.push(`oil.visc: '${o1.visc}' → '${o2.visc}'`);
  if (!eqLoose(o1.spec, o2.spec)) changes.push(`oil.spec: '${o1.spec}' → '${o2.spec}'`);
  if (o1.sump_l !== o2.sump_l) changes.push(`oil.sump_l: ${o1.sump_l} → ${o2.sump_l}`);
  if (o1.drain_nm !== o2.drain_nm) changes.push(`oil.drain_nm: ${o1.drain_nm} → ${o2.drain_nm}`);
  // Coolant
  const c1 = oldR.coolant ?? {} as any;
  const c2 = newR.coolant ?? {} as any;
  if (!eqLoose(c1.spec, c2.spec)) changes.push(`coolant.spec: '${c1.spec}' → '${c2.spec}'`);
  if (c1.capacity_l !== c2.capacity_l) changes.push(`coolant.capacity_l: ${c1.capacity_l} → ${c2.capacity_l}`);
  return changes;
}

function main() {
  const [oldPath, newPath] = process.argv.slice(2);
  if (!oldPath || !newPath) {
    console.error("Usage: diff_crawls.ts <old.json> <new.json>");
    process.exit(1);
  }
  const oldC = loadCrawl(oldPath);
  const newC = loadCrawl(newPath);

  if (oldC.chassis.modelId !== newC.chassis.modelId) {
    console.error(`WARNING: different modelIds (${oldC.chassis.modelId} vs ${newC.chassis.modelId}). Diffing anyway.`);
  }

  const oldByType = new Map(oldC.types.map((t) => [t.typeId, t]));
  const newByType = new Map(newC.types.map((t) => [t.typeId, t]));

  const added: EngineRecord[] = [];
  const removed: EngineRecord[] = [];
  const changed: Array<{ typeId: string; oldR: EngineRecord; newR: EngineRecord; changes: string[] }> = [];
  const unchanged: string[] = [];

  for (const [typeId, newR] of newByType) {
    const oldR = oldByType.get(typeId);
    if (!oldR) { added.push(newR); continue; }
    const c = diffEngine(oldR, newR);
    if (c.length === 0) unchanged.push(typeId);
    else changed.push({ typeId, oldR, newR, changes: c });
  }
  for (const [typeId, oldR] of oldByType) {
    if (!newByType.has(typeId)) removed.push(oldR);
  }

  const lines: string[] = [];
  const today = new Date().toISOString().slice(0, 10);
  lines.push(`# HaynesPro crawl diff — ${oldC.chassis.label ?? oldC.chassis.modelId}`);
  lines.push("");
  lines.push(`Old: ${basename(oldPath)} (${oldC.chassis.fetched_at})`);
  lines.push(`New: ${basename(newPath)} (${newC.chassis.fetched_at})`);
  lines.push("");
  lines.push(`Summary: ${added.length} added · ${removed.length} removed · ${changed.length} changed · ${unchanged.length} unchanged.`);
  lines.push("");

  if (added.length > 0) {
    lines.push("## Added engines (new in HaynesPro since last crawl)");
    lines.push("");
    lines.push("| typeId | type | engine | cc | kW | years | oil | coolant |");
    lines.push("|---|---|---|---|---|---|---|---|");
    for (const r of added) {
      lines.push(`| ${r.typeId} | ${r.type} | ${r.engine_code ?? "—"} | ${r.cc ?? "—"} | ${r.kw ?? "—"} | ${r.years} | ${r.oil?.visc ?? "—"} ${r.oil?.spec ?? ""} ${r.oil?.sump_l ?? "?"}L | ${r.coolant?.spec ?? "—"} ${r.coolant?.capacity_l ?? "?"}L |`);
    }
    lines.push("");
  }

  if (removed.length > 0) {
    lines.push("## Removed engines (no longer in HaynesPro)");
    lines.push("");
    for (const r of removed) lines.push(`- ${r.typeId} ${r.engine_code} ${r.type} (${r.years})`);
    lines.push("");
  }

  if (changed.length > 0) {
    lines.push("## Changed engines (existing typeId, different values)");
    lines.push("");
    for (const c of changed) {
      lines.push(`### ${c.typeId} — ${c.newR.engine_code} ${c.newR.type} (${c.newR.years})`);
      for (const ch of c.changes) lines.push(`- ${ch}`);
      lines.push("");
    }
  }

  if (changed.length === 0 && added.length === 0 && removed.length === 0) {
    lines.push("## All typeIds unchanged — no action needed.");
  }

  const outDir = resolve(process.cwd(), "scrapers/output");
  const outName = `haynespro-diff-${oldC.chassis.modelId}-${today}.md`;
  writeFileSync(resolve(outDir, outName), lines.join("\n"), "utf8");
  console.log(lines.join("\n"));
  console.error(`\nWrote scrapers/output/${outName}`);
}

main();
