#!/usr/bin/env tsx
/**
 * Multi-gen HaynesPro chassis ingest.
 *
 * Where ingest_to_sql.ts handles one chassis → one catalog generation,
 * this script handles one chassis → many catalog generations. For brands
 * like Audi (A4 8W = sedan+avant × pre-LCI/LCI = 4 gens), BMW 5-series
 * (G30 sedan/touring × pre/LCI + F90 M5 = 5 gens), and the A6 4A family
 * (sedan + avant + LCI + Allroad + S6×4 + RS6×2 = 11 gens), each crawled
 * typeId can apply to multiple catalog gens — so per-typeId classify
 * rules are required.
 *
 * Each output migration uses INSERT...WHERE NOT EXISTS guards so existing
 * hand-seeded rich fluid_specs rows are preserved.
 *
 * Usage:
 *   npx tsx scrapers/haynespro/ingest_multi_gen.ts <chassis-key> [--mig-number NNN]
 *
 * Run it once per chassis key. Chassis keys are defined in CHASSIS_RULES
 * below and correspond to entries in scrapers/haynespro/chassis_registry.json.
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
  oil?: { visc: string | null; spec: string | null; sump_l: number | null; drain_nm: number | null } | null;
  coolant?: { spec: string | null; capacity_l: number | null } | null;
  brake_fluid?: { spec: string | null; spec_alt: string | null; capacity_l: number | null } | null;
  transmission?: { type: string; label: string; spec: string | null; capacity_l: number | null } | null;
};

type Crawl = {
  chassis: { modelId: string; label: string | null; engines_count: number; fetched_at: string };
  types: EngineRecord[];
};

type Classifier = (type: string, years: string) => number[];

type ChassisRule = {
  crawlFile: string;
  modelId: string;
  label: string;
  classify: Classifier;
};

function parseYears(years: string): [number, number] {
  const m = years.match(/(\d{4})\s*-\s*(\d{4}|\.{3}|)/);
  if (!m) return [0, 0];
  return [parseInt(m[1], 10), /^\d{4}$/.test(m[2]) ? parseInt(m[2], 10) : 2099];
}

function overlaps(eStart: number, eEnd: number, gStart: number, gEnd: number) {
  return eStart <= gEnd && eEnd >= gStart;
}

const CHASSIS_RULES: Record<string, ChassisRule> = {
  // Audi A4 (8W) — 4 catalog gens: sedan/avant × pre-LCI/LCI. No S4/RS4 catalog gens.
  // Gens: 24=sedan-B9, 149=avant-B9, 150=sedan-B9-LCI, 151=avant-B9-LCI
  "a4-8w": {
    crawlFile: "haynespro-crawl-a4-8w-2026-05-23.json",
    modelId: "d_317000026",
    label: "Audi A4 (8W)",
    classify: (type, years) => {
      // Skip S4 / RS4 — no catalog gens exist for them on the B9
      if (/^(S4|RS4)/i.test(type)) return [];
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2015, 2018)) gens.push(24, 149);
      if (overlaps(s, e, 2019, 2025)) gens.push(150, 151);
      return gens;
    },
  },
  // Audi A6 (4A) — 11 gens: sedan/avant pre/LCI + Allroad + S6×4 + RS6×2
  // Gens: 115=sedan-C8, 152=avant-C8, 153=sedan-C8-LCI, 154=avant-C8-LCI, 155=allroad-C8
  //       156=S6-sedan, 157=S6-avant, 158=S6-LCI-sedan, 159=S6-LCI-avant
  //       160=RS6-avant, 161=RS6-avant-LCI
  "a6-4a": {
    crawlFile: "haynespro-crawl-a6-allroad-4a-2026-05-23.json",
    modelId: "d_319001693",
    label: "Audi A6 (4A)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (/^RS6/i.test(type)) {
        if (overlaps(s, e, 2019, 2023)) gens.push(160);
        if (overlaps(s, e, 2023, 2099)) gens.push(161);
        return gens;
      }
      if (/^S6/i.test(type)) {
        if (overlaps(s, e, 2019, 2023)) gens.push(156, 157);
        if (overlaps(s, e, 2023, 2099)) gens.push(158, 159);
        return gens;
      }
      // Regular A6: sedan + avant pre/LCI, + Allroad if 2020+
      if (overlaps(s, e, 2018, 2023)) gens.push(115, 152);
      if (overlaps(s, e, 2023, 2099)) gens.push(153, 154);
      if (overlaps(s, e, 2020, 2099)) gens.push(155);
      return gens;
    },
  },
  // BMW 5 (G30/G31/F90) — 5 gens: G30/G31 pre/LCI + M5 F90
  // Gens: 81=G30-sedan, 131=G31-touring, 127=G30-LCI-sedan, 133=G31-LCI-touring, 146=M5-F90-sedan
  "bmw-5-g30": {
    crawlFile: "haynespro-crawl-bmw-5-g30-2026-05-23.json",
    modelId: "d_319001371",
    label: "BMW 5 (G30, G31, F90)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      // M5 F90 — only the M-tagged engines: "M5", "M5 CS", "M5 Competition"
      if (/^M5(\s|$)/.test(type)) {
        if (overlaps(s, e, 2018, 2023)) gens.push(146);
        return gens;
      }
      // M550i / M550d — high-performance trim of regular G30 (in catalog under G30 LCI)
      if (/^M550/.test(type)) {
        if (overlaps(s, e, 2017, 2020)) gens.push(81, 131);
        if (overlaps(s, e, 2020, 2024)) gens.push(127, 133);
        return gens;
      }
      // Regular 5-series — sedan + touring, pre/LCI
      if (overlaps(s, e, 2017, 2020)) gens.push(81, 131);
      if (overlaps(s, e, 2020, 2024)) gens.push(127, 133);
      return gens;
    },
  },
  // BMW 5 (G60/G61/G90/G99) — 6 gens. Current MY, no LCI.
  // Gens: 128=5-G60-sedan, 134=5-G61-touring, 129=i5-G60-sedan, 135=i5-G61-touring,
  //       147=M5-G90-sedan, 148=M5-G99-touring
  "bmw-5-g60": {
    crawlFile: "haynespro-crawl-bmw-5-g60-2026-05-23.json",
    modelId: "d_319018562",
    label: "BMW 5 (G60, G61, G90)",
    classify: (type) => {
      if (/^M5/.test(type)) return [147, 148];          // both M5 body styles
      if (/^i5/i.test(type) || /eDrive|electric/i.test(type)) return [129, 135];
      return [128, 134];                                  // regular G60 sedan + G61 touring
    },
  },
  // Single-gen chassis missed in Phase 2 (3 of them — Q7, Golf VIII, Civic XI)
  "q7-4mb": {
    crawlFile: "haynespro-crawl-q7-4mb-2026-05-23.json",
    modelId: "d_312000002",
    label: "Audi Q7 (4MB, 4MG)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2015, 2019) ? [90] : [];
    },
  },
  "vw-golf-viii": {
    crawlFile: "haynespro-crawl-vw-golf-viii-cd-2026-05-23.json",
    modelId: "d_319007235",
    label: "VW Golf VIII (CD, CG)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // R + GTI use same chassis catalog gen for now
      return overlaps(s, e, 2020, 2024) ? [18] : [];
    },
  },
  "honda-civic-xi": {
    crawlFile: "haynespro-crawl-honda-civic-xi-fe-2026-05-23.json",
    modelId: "d_319010573",
    label: "Honda Civic XI (FE, FL)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2022, 2025) ? [50] : [];
    },
  },
  // Phase 2 chassis added here so the same multi-gen ingest now covers them
  // for the new brake_fluid + transmission fluid types (Phase 4).
  "q5-fy": {
    crawlFile: "haynespro-crawl-q5-fy-2026-05-23.json",
    modelId: "d_319001449",
    label: "Audi Q5 (FY)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2017, 2020) ? [82] : [];
    },
  },
  "vw-tiguan-ad": {
    crawlFile: "haynespro-crawl-vw-tiguan-ii-ad-2026-05-23.json",
    modelId: "d_317000050",
    label: "VW Tiguan II (AD, AX, BT, BW, BJ)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2017, 2024) ? [44] : [];
    },
  },
  "honda-civic-x": {
    crawlFile: "haynespro-crawl-honda-civic-x-fk-2026-05-23.json",
    modelId: "d_319001478",
    label: "Honda Civic X (FK, FC)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2016, 2021) ? [1] : [];
    },
  },
  "toyota-camry-xv70": {
    crawlFile: "haynespro-crawl-toyota-camry-xv70-2026-05-23.json",
    modelId: "d_319001688",
    label: "Toyota Camry (XV70)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2018, 2024) ? [2] : [];
    },
  },
  // BMW 3 (F30, F31, F80) — 5 catalog gens (4 regular + M3 F80)
  // Gens: 53=F30-sedan, 136=F31-touring, 125=F30-LCI-sedan, 137=F31-LCI-touring, 141=M3-F80-sedan
  // LCI cutoff for F30/F31: mid-2015 (used 2015 boundary in classify)
  "bmw-3-f30": {
    crawlFile: "haynespro-crawl-bmw-3-f30-2026-05-23.json",
    modelId: "d_200000009",
    label: "BMW 3 (F30, F31, F80)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M3 → F80 only
      if (/^M3(\s|$)/.test(type)) {
        return overlaps(s, e, 2014, 2018) ? [141] : [];
      }
      // Skip 3 GT F34 — not in chassis listing but in case
      if (/^GT|F34/.test(type)) return [];
      // Regular 3-series — sedan + touring × pre/LCI
      const gens: number[] = [];
      if (overlaps(s, e, 2012, 2015)) gens.push(53, 136);
      if (overlaps(s, e, 2015, 2020)) gens.push(125, 137);
      return gens;
    },
  },
  // BMW iX3 (G08) — BEV single catalog gen (2 motor variants: iX3, iX3 M).
  // Note: 'iX3 M' is a sport trim, not a separate M-car. Gen: 169.
  "bmw-ix3-g08": {
    crawlFile: "haynespro-crawl-bmw-ix3-g08-2026-05-23.json",
    modelId: "d_319018751",
    label: "BMW iX3 (G08)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2020, 2024) ? [169] : [];
    },
  },
  // BMW X3 (E83) — 2 catalog gens: pre-LCI 2004-2006 + LCI 2006-2010.
  // Gens: 170=x3-e83-suv-2004-2006, 171=x3-e83-lci-suv-2006-2010.
  "bmw-x3-e83": {
    crawlFile: "haynespro-crawl-bmw-x3-e83-2026-05-23.json",
    modelId: "d_840",
    label: "BMW X3 (E83)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2004, 2006)) gens.push(170);
      if (overlaps(s, e, 2006, 2010)) gens.push(171);
      return gens;
    },
  },
  // BMW X3 (F25) — 2 catalog gens: pre-LCI 2011-2014 + LCI 2014-2018.
  // Gens: 166=x3-f25-suv-2011-2014, 167=x3-f25-lci-suv-2014-2018.
  "bmw-x3-f25": {
    crawlFile: "haynespro-crawl-bmw-x3-f25-2026-05-23.json",
    modelId: "d_102000210",
    label: "BMW X3 (F25)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2011, 2014)) gens.push(166);
      if (overlaps(s, e, 2014, 2018)) gens.push(167);
      return gens;
    },
  },
  // BMW X5 (F15, F85) — single catalog gen (no X5 M F85 separate).
  // Gen: 168=x5-f15-suv-2013-2019.
  "bmw-x5-f15": {
    crawlFile: "haynespro-crawl-bmw-x5-f15-2026-05-23.json",
    modelId: "d_301000058",
    label: "BMW X5 (F15, F85)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2013, 2019) ? [168] : [];
    },
  },
  // BMW X3 (G01) — single catalog gen (no X3 M / iX3 in catalog yet).
  // Routes all engines including M40i, X3 M (F97) into x3-g01-suv-2018-2024.
  "bmw-x3-g01": {
    crawlFile: "haynespro-crawl-bmw-x3-g01-2026-05-23.json",
    modelId: "d_319001442",
    label: "BMW X3 (G01)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2018, 2024) ? [60] : [];
    },
  },
  // BMW X5 (G05, F95) — single catalog gen (no X5 M F95 separate in catalog).
  // Routes all engines including X5 M (F95) into x5-g05-suv-2019-2023.
  "bmw-x5-g05": {
    crawlFile: "haynespro-crawl-bmw-x5-g05-2026-05-23.json",
    modelId: "d_319003510",
    label: "BMW X5 (G05, F95)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2019, 2023) ? [48] : [];
    },
  },
  // BMW i4 G26 — single BEV gen (3 motor variants: M50 xDrive, eDrive35, eDrive40)
  "bmw-i4-g26": {
    crawlFile: "haynespro-crawl-bmw-i4-g26-2026-05-23.json",
    modelId: "d_319009109",
    label: "BMW i4 (G26)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2021, 2099) ? [119] : [];
    },
  },
  // BMW 3 (G20, G21, G80, G81) — 8 catalog gens (4 regular + 4 M3 variants)
  // Gens: 6=G20-sedan, 138=G21-touring, 126=G20-LCI-sedan, 139=G21-LCI-touring,
  //       142=M3-G80, 144=M3-G81-touring, 143=M3-G80-LCI, 145=M3-G81-LCI-touring
  // LCI cutoff: 2022 boundary
  "bmw-3-g20": {
    crawlFile: "haynespro-crawl-bmw-3-g20-2026-05-23.json",
    modelId: "d_319003007",
    label: "BMW 3 (G20, G21, G80)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M3 → G80 sedan + G81 touring × pre/LCI
      if (/^M3(\s|$)/.test(type)) {
        const gens: number[] = [];
        if (overlaps(s, e, 2020, 2024)) gens.push(142, 144);
        if (overlaps(s, e, 2024, 2099)) gens.push(143, 145);
        return gens;
      }
      // M340 — high-trim 3-series (not M3), under regular G20/G21
      // Regular 3-series (incl M340) — sedan + touring × pre/LCI
      const gens: number[] = [];
      if (overlaps(s, e, 2019, 2022)) gens.push(6, 138);
      if (overlaps(s, e, 2022, 2099)) gens.push(126, 139);
      return gens;
    },
  },
};

function arg(flag: string): string | null {
  const i = process.argv.indexOf(flag);
  return i < 0 ? null : process.argv[i + 1];
}

function escapeSql(s: string | null): string {
  if (s == null) return "NULL";
  return "'" + s.replace(/'/g, "''") + "'";
}
function num(n: number | null | undefined): string {
  return n == null ? "NULL" : String(n);
}

function inferFuel(type: string, code: string): string {
  if (/TFSI e|MHEV|eTSI|e-tron/i.test(type)) return "hybrid";
  if (/^[A-Z]\d{2}[A-Z]-F[XHK]S/i.test(code || "")) return "hybrid";
  if (/TDI|HDi|BlueTec|d4D|JTD/i.test(type)) return "diesel";
  if (/^(B47|N47|M47|N57|B57|OM)/i.test(code || "")) return "diesel";
  if (/^EV/i.test(type) || /^i5|electric/i.test(type)) return "electric";
  return "petrol";
}
function inferAsp(type: string, code: string): string {
  if (/TFSI|TSI|TDI|turbo|biturbo|TGI|TwinPower/i.test(type)) return "turbo";
  if (/^B(46|47|48|57|58)/i.test(code || "")) return "turbo";
  if (/^(N20|N26|N54|N55|N63|S55|S58|S63)/i.test(code || "")) return "turbo";
  return "NA";
}

function main() {
  const key = process.argv[2];
  const migNumber = arg("--mig-number") ?? "XXX";
  if (!key || !CHASSIS_RULES[key]) {
    console.error("Usage: ingest_multi_gen.ts <chassis-key> [--mig-number NNN]");
    console.error("Available keys: " + Object.keys(CHASSIS_RULES).join(", "));
    process.exit(1);
  }
  const rule = CHASSIS_RULES[key];
  const crawl: Crawl = JSON.parse(readFileSync(resolve("scrapers/output", rule.crawlFile), "utf8"));

  // Dedupe to one record per engine_code (HaynesPro lubricants are engine-scoped, not typeId-scoped)
  const byEngine = new Map<string, EngineRecord>();
  const engineToGens = new Map<string, Set<number>>();
  let skipped = 0;
  for (const t of crawl.types) {
    if (!t.engine_code) continue;
    const baseCode = t.engine_code.split("+")[0];
    const gens = rule.classify(t.type, t.years);
    if (gens.length === 0) { skipped++; continue; }
    if (!byEngine.has(baseCode)) byEngine.set(baseCode, { ...t, engine_code: baseCode });
    let set = engineToGens.get(baseCode);
    if (!set) { set = new Set(); engineToGens.set(baseCode, set); }
    for (const g of gens) set.add(g);
  }

  console.log(`${rule.label}: ${byEngine.size} engines → ${[...engineToGens.values()].reduce((a, s) => a + s.size, 0)} (engine,gen) pairs. Skipped ${skipped} typeIds (out-of-scope variants).`);

  const lines: string[] = [];
  lines.push(`-- mig ${migNumber} — multi-gen HaynesPro ingest: ${rule.label}`);
  lines.push(`-- crawl: ${rule.crawlFile}`);
  lines.push(`-- modelId: ${rule.modelId}`);
  lines.push(`-- ${byEngine.size} engines × per-engine target gens, with INSERT...NOT EXISTS guards.`);
  lines.push("");
  lines.push("SET NAMES utf8mb4;");
  lines.push("");
  // 1) HaynesPro source row
  const haynesUrl = `https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=${rule.modelId}`;
  lines.push(`INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES`);
  lines.push(`  (${escapeSql("HaynesPro WorkshopData — " + rule.label)}, ${escapeSql(haynesUrl)}, NOW(), ${escapeSql(`Multi-gen ingest, ${byEngine.size} engines across ${new Set([...engineToGens.values()].flatMap(s => [...s])).size} catalog gens.`)}, 0, 0);`);
  lines.push(`SET @s_haynes := (SELECT id FROM sources WHERE url = ${escapeSql(haynesUrl)} ORDER BY id DESC LIMIT 1);`);
  lines.push("");

  // 2) Engines INSERT IGNORE
  lines.push("INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES");
  const engineRows: string[] = [];
  for (const e of byEngine.values()) {
    const display = `${e.type ?? ""} (${e.engine_code}) ${e.kw ? e.kw + "kW" : ""}`.trim().replace(/\s+/g, " ");
    engineRows.push(`  (${escapeSql(e.engine_code)}, ${escapeSql(display)}, ${num(e.cc)}, ${escapeSql(inferFuel(e.type, e.engine_code!))}, ${escapeSql(inferAsp(e.type, e.engine_code!))}, NULL)`);
  }
  lines.push(engineRows.join(",\n") + ";");
  lines.push("");

  // 3) Per-(engine, gen) fluid_specs INSERT...NOT EXISTS
  lines.push("-- Per-(engine, gen) fluid_specs with NOT EXISTS guard");
  let fluidRows = 0;
  for (const [code, gens] of engineToGens) {
    const e = byEngine.get(code)!;
    for (const genId of gens) {
      const engLookup = `(SELECT id FROM engines WHERE code = ${escapeSql(code)})`;
      if (e.oil && (e.oil.sump_l != null || e.oil.spec)) {
        const capQt = e.oil.sump_l != null ? Math.round(e.oil.sump_l * 1.05669 * 100) / 100 : null;
        const notes = `HaynesPro typeId ${e.typeId}; ${e.type}; drain ${e.oil.drain_nm ?? "?"} Nm`;
        lines.push(`INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)`);
        lines.push(`SELECT ${genId}, 'engine_oil', ${engLookup}, ${num(e.oil.sump_l)}, ${num(capQt)}, ${escapeSql(e.oil.visc)}, ${escapeSql(e.oil.spec)}, ${escapeSql(notes)}`);
        lines.push(`WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = ${genId} AND fluid_type = 'engine_oil' AND engine_id = ${engLookup});`);
        fluidRows++;
      }
      if (e.coolant && (e.coolant.capacity_l != null || e.coolant.spec)) {
        const capQt = e.coolant.capacity_l != null ? Math.round(e.coolant.capacity_l * 1.05669 * 100) / 100 : null;
        const notes = `HaynesPro typeId ${e.typeId}; ${e.type}`;
        lines.push(`INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)`);
        lines.push(`SELECT ${genId}, 'coolant', ${engLookup}, ${num(e.coolant.capacity_l)}, ${num(capQt)}, NULL, ${escapeSql(e.coolant.spec)}, ${escapeSql(notes)}`);
        lines.push(`WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = ${genId} AND fluid_type = 'coolant' AND engine_id = ${engLookup});`);
        fluidRows++;
      }
      // Per-engine transmission row (engine-scoped) — emit if spec OR capacity present
      if (e.transmission && (e.transmission.spec || e.transmission.capacity_l != null)) {
        const tType = e.transmission.type;
        const capQt = e.transmission.capacity_l != null ? Math.round(e.transmission.capacity_l * 1.05669 * 100) / 100 : null;
        const notes = `HaynesPro typeId ${e.typeId}; ${e.type}; ${e.transmission.label}`;
        lines.push(`INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)`);
        lines.push(`SELECT ${genId}, ${escapeSql(tType)}, ${engLookup}, ${num(e.transmission.capacity_l)}, ${num(capQt)}, NULL, ${escapeSql(e.transmission.spec)}, ${escapeSql(notes)}`);
        lines.push(`WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = ${genId} AND fluid_type = ${escapeSql(tType)} AND engine_id = ${engLookup});`);
        fluidRows++;
      }
    }
  }
  lines.push("");

  // 3b) Per-gen brake_fluid (gen-wide, engine_id NULL) using modal brake spec across all engines
  const brakeCounts = new Map<string, { spec: string; spec_alt: string | null; capacity_l: number | null; count: number }>();
  for (const e of byEngine.values()) {
    if (!e.brake_fluid || !e.brake_fluid.spec) continue;
    const key = `${e.brake_fluid.spec}|${e.brake_fluid.spec_alt ?? ""}|${e.brake_fluid.capacity_l ?? ""}`;
    const cur = brakeCounts.get(key);
    if (cur) cur.count++;
    else brakeCounts.set(key, { spec: e.brake_fluid.spec, spec_alt: e.brake_fluid.spec_alt, capacity_l: e.brake_fluid.capacity_l, count: 1 });
  }
  const modalBrake = [...brakeCounts.values()].sort((a, b) => b.count - a.count)[0] ?? null;
  if (modalBrake) {
    const genIds = [...new Set([...engineToGens.values()].flatMap(s => [...s]))];
    const capQt = modalBrake.capacity_l != null ? Math.round(modalBrake.capacity_l * 1.05669 * 100) / 100 : null;
    const altNote = modalBrake.spec_alt ? `Alt: ${modalBrake.spec_alt}` : "";
    const notes = `HaynesPro chassis ${rule.modelId}; ${altNote}`.trim();
    for (const genId of genIds) {
      lines.push(`INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)`);
      lines.push(`SELECT ${genId}, 'brake_fluid', NULL, ${num(modalBrake.capacity_l)}, ${num(capQt)}, NULL, ${escapeSql(modalBrake.spec)}, ${escapeSql(notes)}`);
      lines.push(`WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = ${genId} AND fluid_type = 'brake_fluid' AND engine_id IS NULL);`);
      fluidRows++;
    }
  }
  lines.push("");

  // 4) Link inserted rows to HaynesPro source
  const genIds = [...new Set([...engineToGens.values()].flatMap(s => [...s]))];
  const codeList = [...engineToGens.keys()].map(escapeSql).join(", ");
  lines.push("-- Link engine-scoped rows (oil, coolant, transmission_*)");
  lines.push("INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)");
  lines.push(`SELECT 'fluid_specs', fs.id, @s_haynes`);
  lines.push(`FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id`);
  lines.push(`WHERE fs.generation_id IN (${genIds.join(", ")})`);
  lines.push(`  AND e.code IN (${codeList})`);
  lines.push(`  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');`);
  lines.push("");
  lines.push("-- Link gen-wide brake_fluid rows");
  lines.push("INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)");
  lines.push(`SELECT 'fluid_specs', fs.id, @s_haynes`);
  lines.push(`FROM fluid_specs fs`);
  lines.push(`WHERE fs.generation_id IN (${genIds.join(", ")})`);
  lines.push(`  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;`);
  lines.push("");

  // 5) Audit
  lines.push(`SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count`);
  lines.push(`FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id`);
  lines.push(`WHERE fs.generation_id IN (${genIds.join(", ")}) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')`);
  lines.push(`GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;`);

  const outPath = resolve("db/migrations", `${migNumber}_ingest_multigen_${key}.sql`);
  writeFileSync(outPath, lines.join("\n"), "utf8");
  console.log(`Wrote ${outPath} — ${fluidRows} INSERT statements across ${genIds.length} gens`);
}

main();
