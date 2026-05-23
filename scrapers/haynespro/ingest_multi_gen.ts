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
  // Mercedes-Benz C-Class W203 (2000-2007) — single gen.
  "mb-c-w203": {
    crawlFile: "haynespro-crawl-mb-c-w203-2026-05-23.json",
    modelId: "d_3610",
    label: "Mercedes-Benz C (W203, S203)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2000, 2007) ? [302] : [];
    },
  },
  // Mercedes-Benz C-Class W204 (2007-2014) — single gen. C63 AMG merged.
  "mb-c-w204": {
    crawlFile: "haynespro-crawl-mb-c-w204-2026-05-23.json",
    modelId: "d_3600",
    label: "Mercedes-Benz C (W204)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2007, 2014) ? [303] : [];
    },
  },
  // Mercedes-Benz C-Class W205 (2014-2023) — base + AMG C63 W205 (4.0 V8 BiTurbo).
  // Gens: 304 (base), 306 (AMG C63). 43 AMG (6-cyl) stays in base.
  "mb-c-w205": {
    crawlFile: "haynespro-crawl-mb-c-w205-2026-05-23.json",
    modelId: "d_301000084",
    label: "Mercedes-Benz C (W205)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/63 AMG/.test(type)) return overlaps(s, e, 2014, 2021) ? [306] : [];
      return overlaps(s, e, 2014, 2021) ? [304] : [];
    },
  },
  // Mercedes-Benz C-Class W206 (2021-) — single gen. C43/C63 PHEV merged.
  "mb-c-w206": {
    crawlFile: "haynespro-crawl-mb-c-w206-2026-05-23.json",
    modelId: "d_319008822",
    label: "Mercedes-Benz C (W206)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2021, 2099) ? [305] : [];
    },
  },
  // Mercedes-Benz E-Class W211 (2002-2009) — single gen.
  "mb-e-w211": {
    crawlFile: "haynespro-crawl-mb-e-w211-2026-05-23.json",
    modelId: "d_3340",
    label: "Mercedes-Benz E (W211, S211)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2002, 2009) ? [307] : [];
    },
  },
  // Mercedes-Benz E-Class W212 (2009-2016) — single gen.
  "mb-e-w212": {
    crawlFile: "haynespro-crawl-mb-e-w212-2026-05-23.json",
    modelId: "d_102000087",
    label: "Mercedes-Benz E (W212)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2009, 2016) ? [308] : [];
    },
  },
  // Mercedes-Benz E-Class C207/A207 Coupe/Cabriolet (2009-2016) — single gen.
  "mb-e-w207": {
    crawlFile: "haynespro-crawl-mb-e-w207-2026-05-23.json",
    modelId: "d_102000173",
    label: "Mercedes-Benz E Coupe/Cabrio (W207)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2009, 2016) ? [309] : [];
    },
  },
  // Mercedes-Benz E-Class W213 (2016-2023) — single gen.
  "mb-e-w213": {
    crawlFile: "haynespro-crawl-mb-e-w213-2026-05-23.json",
    modelId: "d_319000496",
    label: "Mercedes-Benz E (W213)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2016, 2023) ? [310] : [];
    },
  },
  // Mercedes-Benz E-Class C238/A238 Coupe/Cabriolet (2017-2022) — single gen.
  "mb-e-w238": {
    crawlFile: "haynespro-crawl-mb-e-w238-2026-05-23.json",
    modelId: "d_319001437",
    label: "Mercedes-Benz E Coupe/Cabrio (W238)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2017, 2022) ? [311] : [];
    },
  },
  // Mercedes-Benz E-Class W214 (2023-) — single gen.
  "mb-e-w214": {
    crawlFile: "haynespro-crawl-mb-e-w214-2026-05-23.json",
    modelId: "d_319018555",
    label: "Mercedes-Benz E (W214)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2023, 2099) ? [312] : [];
    },
  },
  // Audi A1 8X (2011-2018) — single gen, S1 (CWZA 2.0 TFSI) included in base.
  "audi-a1-8x": {
    crawlFile: "haynespro-crawl-audi-a1-8x-2026-05-23.json",
    modelId: "d_102000157",
    label: "Audi A1 (8X)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2011, 2018) ? [293] : [];
    },
  },
  // Audi A1 GB (2019-) — single gen.
  "audi-a1-gb": {
    crawlFile: "haynespro-crawl-audi-a1-gb-2026-05-23.json",
    modelId: "d_319002998",
    label: "Audi A1 (GBA, GBH)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2019, 2099) ? [294] : [];
    },
  },
  // Audi Q2 GA (2017-) — base + SQ2 (300hp 2.0 TFSI). Gens: 295, 296.
  "audi-q2-ga": {
    crawlFile: "haynespro-crawl-audi-q2-ga-2026-05-23.json",
    modelId: "d_319000521",
    label: "Audi Q2 (GA)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^SQ2\b/.test(type)) return overlaps(s, e, 2018, 2099) ? [296] : [];
      return overlaps(s, e, 2017, 2099) ? [295] : [];
    },
  },
  // Audi TT 8N (1998-2006) — 1st gen, single gen (no RS in 8N). Gen: 297.
  "audi-tt-8n": {
    crawlFile: "haynespro-crawl-audi-tt-8n-2026-05-23.json",
    modelId: "d_420",
    label: "Audi TT (8N)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 1998, 2006) ? [297] : [];
    },
  },
  // Audi TT 8J (2006-2014) — base + TT RS 8J. HaynesPro labels RS as 'RS (2.5 TFSI)'.
  // Gens: 298 (base), 299 (RS).
  "audi-tt-8j": {
    crawlFile: "haynespro-crawl-audi-tt-8j-2026-05-23.json",
    modelId: "d_102000006",
    label: "Audi TT (8J)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS\b/.test(type)) return overlaps(s, e, 2009, 2014) ? [299] : [];
      return overlaps(s, e, 2006, 2014) ? [298] : [];
    },
  },
  // Audi TT FV/8S (2015-2023) — base + TT RS FV. TTS (S (2.0 TFSI)) stays in base.
  // Gens: 300 (base), 301 (RS).
  "audi-tt-fv": {
    crawlFile: "haynespro-crawl-audi-tt-fv-2026-05-23.json",
    modelId: "d_303000002",
    label: "Audi TT (FV/8S)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS\b/.test(type)) return overlaps(s, e, 2016, 2023) ? [301] : [];
      return overlaps(s, e, 2015, 2023) ? [300] : [];
    },
  },
  // Audi A7 4G (2010-2018) — base + RS7 4G (4.0 V8 TFSI). Gens: 283, 284.
  "audi-a7-4g": {
    crawlFile: "haynespro-crawl-audi-a7-4g-2026-05-23.json",
    modelId: "d_102000177",
    label: "Audi A7 (4G)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS7\b/.test(type)) return overlaps(s, e, 2013, 2018) ? [284] : [];
      return overlaps(s, e, 2010, 2018) ? [283] : [];
    },
  },
  // Audi A7 4K (2018-) — base + RS7 4K. Gens: 285, 286.
  "audi-a7-4k": {
    crawlFile: "haynespro-crawl-audi-a7-4k-2026-05-23.json",
    modelId: "d_319001691",
    label: "Audi A7 (4K)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS7\b/.test(type)) return overlaps(s, e, 2019, 2099) ? [286] : [];
      return overlaps(s, e, 2018, 2099) ? [285] : [];
    },
  },
  // Audi A8 4E (2003-2010) — single gen. Gen: 287.
  "audi-a8-4e": {
    crawlFile: "haynespro-crawl-audi-a8-4e-2026-05-23.json",
    modelId: "d_440",
    label: "Audi A8 (4E)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2003, 2010) ? [287] : [];
    },
  },
  // Audi A8 4H (2010-2017) — single gen. Gen: 288.
  "audi-a8-4h": {
    crawlFile: "haynespro-crawl-audi-a8-4h-2026-05-23.json",
    modelId: "d_102000172",
    label: "Audi A8 (4H)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2010, 2017) ? [288] : [];
    },
  },
  // Audi A8 4N (2018-) — single gen. Gen: 289.
  "audi-a8-4n": {
    crawlFile: "haynespro-crawl-audi-a8-4n-2026-05-23.json",
    modelId: "d_319001497",
    label: "Audi A8 (4N)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2018, 2099) ? [289] : [];
    },
  },
  // Audi Q8 4MN (2019-) — base + RS Q8 4MN. SQ8 stays in base. Gens: 290, 291.
  "audi-q8-4mn": {
    crawlFile: "haynespro-crawl-audi-q8-4mn-2026-05-23.json",
    modelId: "d_319002009",
    label: "Audi Q8 (4MN)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RSQ8\b/.test(type)) return overlaps(s, e, 2019, 2099) ? [291] : [];
      return overlaps(s, e, 2019, 2099) ? [290] : [];
    },
  },
  // Audi Q8 e-tron (2023-) — BEV single gen. Gen: 292.
  "audi-q8-e-tron": {
    crawlFile: "haynespro-crawl-audi-q8-e-tron-2026-05-23.json",
    modelId: "d_319017708",
    label: "Audi Q8 e-tron (GET, GEG)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2023, 2099) ? [292] : [];
    },
  },
  // Audi A3 8P (2003-2013) — single base gen + RS3 8P Sportback (2011-2013 only).
  "audi-a3-8p": {
    crawlFile: "haynespro-crawl-audi-a3-8p-2026-05-23.json",
    modelId: "d_480",
    label: "Audi A3 II (8P)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS3\b/.test(type)) return overlaps(s, e, 2011, 2013) ? [268] : [];
      return overlaps(s, e, 2003, 2013) ? [267] : [];
    },
  },
  // Audi A3 8V (2013-2020) — base + RS3 8V.
  "audi-a3-8v": {
    crawlFile: "haynespro-crawl-audi-a3-8v-2026-05-23.json",
    modelId: "d_102000240",
    label: "Audi A3 III (8V)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS3\b/.test(type)) return overlaps(s, e, 2015, 2020) ? [270] : [];
      return overlaps(s, e, 2013, 2020) ? [269] : [];
    },
  },
  // Audi A3 8Y (2020-) — base + RS3 8Y.
  "audi-a3-8y": {
    crawlFile: "haynespro-crawl-audi-a3-8y-2026-05-23.json",
    modelId: "d_319007427",
    label: "Audi A3 IV (8Y)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS3\b/.test(type)) return overlaps(s, e, 2021, 2099) ? [272] : [];
      return overlaps(s, e, 2020, 2099) ? [271] : [];
    },
  },
  // Audi A5 8T (2007-2017) — base + RS5 8T (V8 FSI).
  "audi-a5-8t": {
    crawlFile: "haynespro-crawl-audi-a5-8t-2026-05-23.json",
    modelId: "d_110000005",
    label: "Audi A5 (8T, 8F)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS5\b/.test(type)) return overlaps(s, e, 2010, 2015) ? [274] : [];
      return overlaps(s, e, 2007, 2017) ? [273] : [];
    },
  },
  // Audi A5 F5 (2017-2025) — base + RS5 F5 (2.9 TFSI V6).
  "audi-a5-f5": {
    crawlFile: "haynespro-crawl-audi-a5-f5-2026-05-23.json",
    modelId: "d_319000522",
    label: "Audi A5 (F5)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RS5\b/.test(type)) return overlaps(s, e, 2017, 2025) ? [276] : [];
      return overlaps(s, e, 2017, 2025) ? [275] : [];
    },
  },
  // Audi A5 FU (2024-) — new gen replacing A4. Single gen.
  "audi-a5-fu": {
    crawlFile: "haynespro-crawl-audi-a5-fu-2026-05-23.json",
    modelId: "d_319022568",
    label: "Audi A5 (FU)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2024, 2099) ? [277] : [];
    },
  },
  // Audi Q3 8U (2012-2018) — base + RS Q3 8U.
  "audi-q3-8u": {
    crawlFile: "haynespro-crawl-audi-q3-8u-2026-05-23.json",
    modelId: "d_200000005",
    label: "Audi Q3 (8U)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RSQ3\b/.test(type)) return overlaps(s, e, 2013, 2018) ? [279] : [];
      return overlaps(s, e, 2012, 2018) ? [278] : [];
    },
  },
  // Audi Q3 F3 (2018-) — base + RS Q3 F3.
  "audi-q3-f3": {
    crawlFile: "haynespro-crawl-audi-q3-f3-2026-05-23.json",
    modelId: "d_319003511",
    label: "Audi Q3 (G2, F3)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^RSQ3\b/.test(type)) return overlaps(s, e, 2019, 2099) ? [281] : [];
      return overlaps(s, e, 2018, 2099) ? [280] : [];
    },
  },
  // Audi Q3 FJ (2024-) — new gen. Single gen.
  "audi-q3-fj": {
    crawlFile: "haynespro-crawl-audi-q3-fj-2026-05-23.json",
    modelId: "d_319023857",
    label: "Audi Q3 (FJ)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2024, 2099) ? [282] : [];
    },
  },
  // BMW 6 Series E63/E64 (2003-2011) — Coupe + Convertible + M6 V10.
  // M6 → m6-e63-coupe (255) + m6-e64-convertible (256). Regular → 253 + 254.
  "bmw-6-e63": {
    crawlFile: "haynespro-crawl-bmw-6-e63-2026-05-23.json",
    modelId: "d_860",
    label: "BMW 6 (E63, E64)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^M6\b/.test(type)) {
        const gens: number[] = [];
        if (overlaps(s, e, 2005, 2010)) gens.push(255);  // M6 E63 coupe
        if (overlaps(s, e, 2006, 2010)) gens.push(256);  // M6 E64 convertible
        return gens;
      }
      const gens: number[] = [];
      if (overlaps(s, e, 2003, 2010)) gens.push(253);  // E63 coupe
      if (overlaps(s, e, 2004, 2010)) gens.push(254);  // E64 convertible
      return gens;
    },
  },
  // BMW 6 Series F06/F12/F13 (2011-2018) — Coupe + Convertible + Gran Coupe + M6 V8.
  // M6 → m6-f13/f12/f06 fan-out. Regular → 6-series-f13/f12/f06 fan-out.
  "bmw-6-f13": {
    crawlFile: "haynespro-crawl-bmw-6-f13-2026-05-23.json",
    modelId: "d_102000141",
    label: "BMW 6 (F06, F12, F13)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^M6\b/.test(type)) {
        const gens: number[] = [];
        if (overlaps(s, e, 2012, 2018)) gens.push(260, 261);  // M6 F13 + F12
        if (overlaps(s, e, 2013, 2018)) gens.push(262);       // M6 F06 GC (from 2013)
        return gens;
      }
      const gens: number[] = [];
      if (overlaps(s, e, 2011, 2018)) gens.push(257, 258);  // F13 + F12
      if (overlaps(s, e, 2012, 2018)) gens.push(259);       // F06 GC (from 2012)
      return gens;
    },
  },
  // BMW 6 Series Gran Turismo G32 (2017-) — single gen.
  "bmw-6-g32": {
    crawlFile: "haynespro-crawl-bmw-6-g32-2026-05-23.json",
    modelId: "d_319001547",
    label: "BMW 6 GT (G32)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2017, 2099) ? [263] : [];
    },
  },
  // BMW X2 F39 (1st gen, 2018-2023) — single gen.
  "bmw-x2-f39": {
    crawlFile: "haynespro-crawl-bmw-x2-f39-2026-05-23.json",
    modelId: "d_319001659",
    label: "BMW X2 (F39)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2018, 2023) ? [264] : [];
    },
  },
  // BMW X2 U10 (2nd gen, 2023-) — single gen.
  "bmw-x2-u10": {
    crawlFile: "haynespro-crawl-bmw-x2-u10-2026-05-23.json",
    modelId: "d_319021717",
    label: "BMW X2 (U10)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2023, 2099) ? [265] : [];
    },
  },
  // BMW iX I20 (2021-2025, BEV) — single gen.
  "bmw-ix-i20": {
    crawlFile: "haynespro-crawl-bmw-ix-i20-2026-05-23.json",
    modelId: "d_319009108",
    label: "BMW iX (I20)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2021, 2025) ? [266] : [];
    },
  },
  // BMW Z4 E85/E86 (2003-2009) — Roadster (E85, 2003-2009) + Coupe (E86, 2006-2009).
  // HaynesPro doesn't differentiate body in chassis listing — fan out to both.
  "bmw-z4-e85": {
    crawlFile: "haynespro-crawl-bmw-z4-e85-2026-05-23.json",
    modelId: "d_890",
    label: "BMW Z4 (E85, E86)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2003, 2009)) gens.push(243);  // E85 Roadster
      if (overlaps(s, e, 2006, 2009)) gens.push(244);  // E86 Coupe (2006-2009 only)
      return gens;
    },
  },
  // BMW Z4 E89 (2nd gen, 2009-2016) — folding hardtop convertible, single gen.
  "bmw-z4-e89": {
    crawlFile: "haynespro-crawl-bmw-z4-e89-2026-05-23.json",
    modelId: "d_102000124",
    label: "BMW Z4 (E89)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2009, 2016) ? [245] : [];
    },
  },
  // BMW Z4 G29 (3rd gen, 2019-) — soft-top Roadster, single gen.
  "bmw-z4-g29": {
    crawlFile: "haynespro-crawl-bmw-z4-g29-2026-05-23.json",
    modelId: "d_319003512",
    label: "BMW Z4 (G29)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2019, 2099) ? [246] : [];
    },
  },
  // BMW 8 Series + M8 (G15/G14/G16/F91/F92/F93, 2018-) — 6 catalog gens.
  // M8 / M8 Competition → F92 coupe (250) + F91 convertible (251) + F93 Gran Coupe (252).
  // Regular incl M850i → G15 coupe (247) + G14 convertible (248) + G16 Gran Coupe (249).
  "bmw-8-g15": {
    crawlFile: "haynespro-crawl-bmw-8-g15-2026-05-23.json",
    modelId: "d_319003011",
    label: "BMW 8 (F91, F92, F93, G14, G15, G16)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M8 / M8 Competition → F92/F91/F93 fan-out
      if (/^M8\b/.test(type)) {
        return overlaps(s, e, 2019, 2099) ? [250, 251, 252] : [];
      }
      // Regular incl M850i → G15/G14/G16 fan-out
      const gens: number[] = [];
      if (overlaps(s, e, 2018, 2099)) gens.push(247);  // G15 coupe (from 2018)
      if (overlaps(s, e, 2019, 2099)) gens.push(248, 249);  // G14 conv + G16 GC (from 2019)
      return gens;
    },
  },
  // BMW X4 F26 (1st gen, 2014-2018) — single gen. M40i is high-trim, not separate M-car.
  "bmw-x4-f26": {
    crawlFile: "haynespro-crawl-bmw-x4-f26-2026-05-23.json",
    modelId: "d_304000002",
    label: "BMW X4 (F26)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2014, 2018) ? [230] : [];
    },
  },
  // BMW X4 F98/G02 (2018-) — 3 gens: G02 pre/LCI 2022 + X4 M F98.
  // "M Competition" / "M40 M" → X4 M F98 (233). Regular + M40i/M40d → G02.
  "bmw-x4-g02": {
    crawlFile: "haynespro-crawl-bmw-x4-g02-2026-05-23.json",
    modelId: "d_319001694",
    label: "BMW X4 (F98, G02)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // "M Competition" → X4 M F98 (not the F98 has no Competition — both M40 and M-cars exist)
      // HaynesPro uses "M Competition" label for the M-car (F98).
      if (/M Competition/.test(type)) {
        return overlaps(s, e, 2019, 2024) ? [233] : [];
      }
      const gens: number[] = [];
      if (overlaps(s, e, 2018, 2022)) gens.push(231);
      if (overlaps(s, e, 2022, 2099)) gens.push(232);
      return gens;
    },
  },
  // BMW X6 E71/E72 (1st gen, 2008-2014) — single gen. E72 = ActiveHybrid X6.
  "bmw-x6-e71": {
    crawlFile: "haynespro-crawl-bmw-x6-e71-2026-05-23.json",
    modelId: "d_102000125",
    label: "BMW X6 (E71, E72)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2008, 2014) ? [234] : [];
    },
  },
  // BMW X6 F16/F86 (2nd gen, 2014-2019) — single gen. No F86 M entries in HaynesPro listing.
  "bmw-x6-f16": {
    crawlFile: "haynespro-crawl-bmw-x6-f16-2026-05-23.json",
    modelId: "d_304000001",
    label: "BMW X6 (F16, F86)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2014, 2019) ? [235] : [];
    },
  },
  // BMW X6 F96/G06 (3rd gen, 2019-) — 4 gens: G06 pre/LCI 2023 + X6 M F96 pre/LCI 2023.
  // "M Competition" → X6 M F96. Regular (incl M50d/M50i) → G06.
  "bmw-x6-g06": {
    crawlFile: "haynespro-crawl-bmw-x6-g06-2026-05-23.json",
    modelId: "d_319004646",
    label: "BMW X6 (F96, G06)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/M Competition/.test(type)) {
        const gens: number[] = [];
        if (overlaps(s, e, 2019, 2023)) gens.push(239);
        if (overlaps(s, e, 2023, 2099)) gens.push(240);
        return gens;
      }
      const gens: number[] = [];
      if (overlaps(s, e, 2019, 2023)) gens.push(237);
      if (overlaps(s, e, 2023, 2099)) gens.push(238);
      return gens;
    },
  },
  // BMW X7 G07 (2018-) — 2 gens: pre-LCI + LCI (cutoff 2022). M60i high-trim is regular.
  "bmw-x7-g07": {
    crawlFile: "haynespro-crawl-bmw-x7-g07-2026-05-23.json",
    modelId: "d_319003513",
    label: "BMW X7 (G07)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2018, 2022)) gens.push(241);
      if (overlaps(s, e, 2022, 2099)) gens.push(242);
      return gens;
    },
  },
  // BMW 4 Series F32/F33/F36/F82/F83 (2013-2020) — 8 catalog gens.
  // M4 (S55B30A) → F82 coupe (223) + F83 convertible (224) only.
  // Regular → coupe (217/218) + convertible (219/220) + gran-coupe (221/222) × pre/LCI 2017.
  "bmw-4-f32": {
    crawlFile: "haynespro-crawl-bmw-4-f32-2026-05-23.json",
    modelId: "d_301000031",
    label: "BMW 4 (F32, F33, F36, F82, F83)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M4 family → F82 coupe + F83 convertible
      if (/^M4\b/.test(type)) {
        return overlaps(s, e, 2014, 2020) ? [223, 224] : [];
      }
      // Regular — coupe + convertible + gran-coupe, fan out per pre/LCI
      const gens: number[] = [];
      if (overlaps(s, e, 2013, 2017)) gens.push(217, 219, 221);  // F32 + F33 + F36 pre-LCI
      if (overlaps(s, e, 2017, 2020)) gens.push(218, 220, 222);  // LCI variants
      return gens;
    },
  },
  // BMW 4 Series G22/G23/G26/G82/G83 (2020-) — 5 catalog gens.
  // M4 family → G82 coupe (228) + G83 convertible (229).
  // Regular → coupe (225) + convertible (226) + gran-coupe (227, from 2021).
  // (i4 G26 BEV is in d_319009109, separately crawled.)
  "bmw-4-g22": {
    crawlFile: "haynespro-crawl-bmw-4-g22-2026-05-23.json",
    modelId: "d_319008746",
    label: "BMW 4 (G22, G23, G24, G26, G82, G83)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (/^M4\b/.test(type)) {
        return overlaps(s, e, 2021, 2099) ? [228, 229] : [];
      }
      const gens: number[] = [];
      if (overlaps(s, e, 2020, 2099)) gens.push(225, 226);  // coupe + convertible
      if (overlaps(s, e, 2021, 2099)) gens.push(227);       // Gran Coupe from 2021
      return gens;
    },
  },
  // BMW X1 E84 (1st gen, 2009-2015) — single gen, RWD-based.
  "bmw-x1-e84": {
    crawlFile: "haynespro-crawl-bmw-x1-e84-2026-05-23.json",
    modelId: "d_102000120",
    label: "BMW X1 (E84)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2009, 2015) ? [207] : [];
    },
  },
  // BMW X1 F48 (2nd gen, 2015-2022) — single gen, FWD-based.
  "bmw-x1-f48": {
    crawlFile: "haynespro-crawl-bmw-x1-f48-2026-05-23.json",
    modelId: "d_318000006",
    label: "BMW X1 (F48)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2015, 2022) ? [208] : [];
    },
  },
  // BMW X1 U11 (3rd gen, 2022-) — split ICE (X1 gen 209) vs BEV iX1 (gen 210)
  "bmw-x1-u11": {
    crawlFile: "haynespro-crawl-bmw-x1-u11-2026-05-23.json",
    modelId: "d_319017768",
    label: "BMW X1 (U11)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (!overlaps(s, e, 2022, 2099)) return [];
      return /^iX1\b/.test(type) ? [210] : [209];
    },
  },
  // BMW 2 Series F22/F23/F87 (2014-2021) — 3 gens: coupe + convertible + M2 F87.
  // M2 / M2 Competition / M2 CS → M2 F87 gen only.
  // M235i / M240i → high-trim regular, fan out to coupe+convertible.
  "bmw-2-f22": {
    crawlFile: "haynespro-crawl-bmw-2-f22-2026-05-23.json",
    modelId: "d_302000002",
    label: "BMW 2 (F22, F23, F87)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M2 family (N55B30A in early M2; S55B30A in M2 Competition/CS) → F87 coupe only
      if (/^M2\b/.test(type)) {
        return overlaps(s, e, 2016, 2021) ? [213] : [];
      }
      // Regular + M235i/M240i high-trim → coupe (211) + convertible (212)
      if (!overlaps(s, e, 2014, 2021)) return [];
      return [211, 212];
    },
  },
  // BMW 2 Series Gran Coupe F44 (2019-) — single gen, FWD.
  "bmw-2-f44": {
    crawlFile: "haynespro-crawl-bmw-2-f44-2026-05-23.json",
    modelId: "d_319004912",
    label: "BMW 2 Gran Coupe (F44)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2019, 2099) ? [214] : [];
    },
  },
  // BMW 2 Series G42/G87 (2022-) — split coupe (gen 215) vs M2 G87 (gen 216).
  "bmw-2-g42": {
    crawlFile: "haynespro-crawl-bmw-2-g42-2026-05-23.json",
    modelId: "d_319009165",
    label: "BMW 2 (G42, G87)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (!overlaps(s, e, 2022, 2099)) return [];
      return /^M2\b/.test(type) ? [216] : [215];
    },
  },
  // BMW 1 Series E87/E82/E88 (1st gen, 2004-2013) — 2 catalog gens (hatch + coupe).
  // Most engines were offered in hatch + coupe + convertible bodies — fluid specs identical.
  // Coupe-only engines (1M N54B30A) go to coupe gen only.
  "bmw-1-e87": {
    crawlFile: "haynespro-crawl-bmw-1-e87-2026-05-23.json",
    modelId: "d_830",
    label: "BMW 1 (E81, E82, E87, E88)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (!overlaps(s, e, 2004, 2013)) return [];
      // 1M / M Coupe → coupe only
      if (/Coupe|^1M\b|M Coupe/.test(type)) return [196];
      // Other engines: fan out to both hatch (195) + coupe (196)
      return [195, 196];
    },
  },
  // BMW 1 Series F20/F21 (2nd gen, 2011-2019) — hatch only. Pre/LCI split.
  "bmw-1-f20": {
    crawlFile: "haynespro-crawl-bmw-1-f20-2026-05-23.json",
    modelId: "d_102000239",
    label: "BMW 1 (F20, F21)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2011, 2015)) gens.push(197);
      if (overlaps(s, e, 2015, 2019)) gens.push(198);
      return gens;
    },
  },
  // BMW 1 Series F40 (3rd gen, 2019-2024) — single gen.
  "bmw-1-f40": {
    crawlFile: "haynespro-crawl-bmw-1-f40-2026-05-23.json",
    modelId: "d_319004645",
    label: "BMW 1 (F40)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2019, 2024) ? [199] : [];
    },
  },
  // BMW 1 Series F70 (4th gen, 2024-) — single gen.
  "bmw-1-f70": {
    crawlFile: "haynespro-crawl-bmw-1-f70-2026-05-23.json",
    modelId: "d_319022590",
    label: "BMW 1 (F70)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2024, 2099) ? [200] : [];
    },
  },
  // BMW 7 Series E65/E66 (2001-2008) — single gen (SWB E65 + LWB E66 share fluids).
  "bmw-7-e65": {
    crawlFile: "haynespro-crawl-bmw-7-e65-2026-05-23.json",
    modelId: "d_800",
    label: "BMW 7 (E65, E66, E67, E68)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2001, 2008) ? [201] : [];
    },
  },
  // BMW 7 Series F01/F02/F04 (2008-2015) — single gen.
  "bmw-7-f01": {
    crawlFile: "haynespro-crawl-bmw-7-f01-2026-05-23.json",
    modelId: "d_102000073",
    label: "BMW 7 (F01, F02, F04)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      return overlaps(s, e, 2008, 2015) ? [202] : [];
    },
  },
  // BMW 7 Series G11/G12 (2015-2022) — pre/LCI split, LCI cutoff 2019.
  "bmw-7-g11": {
    crawlFile: "haynespro-crawl-bmw-7-g11-2026-05-23.json",
    modelId: "d_317000028",
    label: "BMW 7 (G11, G12)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2015, 2019)) gens.push(203);
      if (overlaps(s, e, 2019, 2022)) gens.push(204);
      return gens;
    },
  },
  // BMW 7 Series G70 + i7 G70 (2022-) — split by BEV (i7) vs ICE (7 Series).
  // i7 motor codes start with XE2 / HA0; ICE engines are B57/B58/S68.
  "bmw-7-g70": {
    crawlFile: "haynespro-crawl-bmw-7-g70-2026-05-23.json",
    modelId: "d_319017039",
    label: "BMW 7 (G70, i7)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      if (!overlaps(s, e, 2022, 2099)) return [];
      // i7 BEV variants → gen 206
      if (/^i7\b/.test(type)) return [206];
      // ICE 7-series → gen 205
      return [205];
    },
  },
  // BMW 5 (E60, E61, M5 E60) — 5 catalog gens.
  // Gens: 179=E60-sedan, 181=E61-touring, 180=E60-LCI-sedan, 182=E61-LCI-touring, 183=M5-E60-sedan.
  // LCI cutoff: 2007.
  "bmw-5-e60": {
    crawlFile: "haynespro-crawl-bmw-5-e60-2026-05-23.json",
    modelId: "d_810",
    label: "BMW 5 (E60, E61)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M5 → E60 sedan only (V10 S85, no LCI distinction in our catalog)
      if (/^M5\b/.test(type)) {
        return overlaps(s, e, 2005, 2010) ? [183] : [];
      }
      // Regular — sedan + touring × pre/LCI
      const gens: number[] = [];
      if (overlaps(s, e, 2003, 2007)) gens.push(179, 181);
      if (overlaps(s, e, 2007, 2010)) gens.push(180, 182);
      return gens;
    },
  },
  // BMW 3 (E90, E91, E92, E93, M3) — 11 catalog gens (8 regular + 3 M3 V8).
  // Gens — regular:
  //   184=E90-sedan, 185=E90-LCI-sedan
  //   186=E91-touring, 187=E91-LCI-touring
  //   188=E92-coupe, 189=E92-LCI-coupe
  //   190=E93-convertible, 191=E93-LCI-convertible
  // Gens — M3 V8 (S65):
  //   192=M3-E90-sedan, 193=M3-E92-coupe, 194=M3-E93-convertible
  // LCI cutoffs differ per body:
  //   E90/E91 LCI: 2008
  //   E92/E93 LCI: 2010
  // E93 convertible launched 2007 (later than sedan/touring/coupe).
  "bmw-3-e90": {
    crawlFile: "haynespro-crawl-bmw-3-e90-2026-05-23.json",
    modelId: "d_900",
    label: "BMW 3 (E90, E91, E92, E93)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M3 V8 → all 3 M3 body gens (sedan/coupe/convertible) by year overlap.
      if (/^M3\b/.test(type)) {
        const gens: number[] = [];
        if (overlaps(s, e, 2007, 2011)) gens.push(192);  // M3 E90 sedan (discontinued 2011)
        if (overlaps(s, e, 2007, 2013)) gens.push(193);  // M3 E92 coupe
        if (overlaps(s, e, 2008, 2013)) gens.push(194);  // M3 E93 convertible
        return gens;
      }
      // Regular — fan-out across all 4 body types × pre/LCI per body
      const gens: number[] = [];
      // E90 sedan
      if (overlaps(s, e, 2005, 2008)) gens.push(184);
      if (overlaps(s, e, 2008, 2012)) gens.push(185);
      // E91 touring
      if (overlaps(s, e, 2005, 2008)) gens.push(186);
      if (overlaps(s, e, 2008, 2012)) gens.push(187);
      // E92 coupe (from 2006, LCI 2010)
      if (overlaps(s, e, 2006, 2010)) gens.push(188);
      if (overlaps(s, e, 2010, 2013)) gens.push(189);
      // E93 convertible (from 2007, LCI 2010)
      if (overlaps(s, e, 2007, 2010)) gens.push(190);
      if (overlaps(s, e, 2010, 2013)) gens.push(191);
      return gens;
    },
  },
  // BMW 5 (F10, F11, F18) — 5 catalog gens (4 regular + M5 F10).
  // Gens: 172=F10-sedan, 174=F11-touring, 173=F10-LCI-sedan, 175=F11-LCI-touring, 176=M5-F10-sedan
  // LCI cutoff: 2013. F18 LWB (China) skipped.
  "bmw-5-f10": {
    crawlFile: "haynespro-crawl-bmw-5-f10-2026-05-23.json",
    modelId: "d_102000140",
    label: "BMW 5 (F10, F11, F18)",
    classify: (type, years) => {
      const [s, e] = parseYears(years);
      // M5 → F10 sedan only
      if (/^M5(\s|$)/.test(type)) {
        return overlaps(s, e, 2011, 2016) ? [176] : [];
      }
      // M550 — high-trim regular 5-series (not M5)
      // Regular 5-series — sedan + touring × pre/LCI
      const gens: number[] = [];
      if (overlaps(s, e, 2010, 2013)) gens.push(172, 174);
      if (overlaps(s, e, 2013, 2017)) gens.push(173, 175);
      return gens;
    },
  },
  // BMW X5 (E70) — 2 catalog gens: pre-LCI 2006-2010 + LCI 2010-2013.
  // Gens: 177=x5-e70-suv-2006-2010, 178=x5-e70-lci-suv-2010-2013.
  // X5 M E70 (S63 engine, 2009-2013) routes into regular gen — no separate catalog gen.
  "bmw-x5-e70": {
    crawlFile: "haynespro-crawl-bmw-x5-e70-2026-05-23.json",
    modelId: "d_1000001",
    label: "BMW X5 (E70)",
    classify: (_type, years) => {
      const [s, e] = parseYears(years);
      const gens: number[] = [];
      if (overlaps(s, e, 2006, 2010)) gens.push(177);
      if (overlaps(s, e, 2010, 2013)) gens.push(178);
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
      if (e.oil && (e.oil.sump_l != null || e.oil.spec || e.oil.visc || e.oil.drain_nm != null)) {
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
