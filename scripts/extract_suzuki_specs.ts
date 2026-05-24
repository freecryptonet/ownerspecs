#!/usr/bin/env tsx
/**
 * extract_suzuki_specs.ts — Pull the SPECIFICATIES section text from
 * each of the 11 Suzuki Phase-3 manuals. Outputs raw spec-block text
 * per gen for hand-curation into mig 357.
 *
 * Suzuki Dutch manuals put the spec table in chapter 11 ("SPECIFICATIES")
 * with anchor "ITEM: aanbevolen brandstof / smeermiddelen en inhoud".
 * Engine code lines follow "Modellen met <CODE>-motor".
 */

import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
// @ts-expect-error
import { PDFParse } from "pdf-parse";

const MANUALS = [
  { gen_slug: "across-ax10-suv-2020-present",         file: "manuals/Gebruikershandleiding_Suzuki_ACROSS_99011-53ZM3-25D-compressed.pdf" },
  { gen_slug: "baleno-wb-hatchback-2015-2022",        file: "manuals/Gebruikershandleiding_Baleno_2018.pdf" },
  { gen_slug: "celerio-lf-hatchback-2014-2017",       file: "manuals/Gebruikershandleiding_Celerio_2018_compressed.pdf" },
  { gen_slug: "fronx-ytb-suv-2023-present",           file: "manuals/Fronx_YTB_99011M74T07-01E_OM_20-Mar-25.pdf" },
  { gen_slug: "ignis-mf-hatchback-2016-present",      file: "manuals/Ignis_2022_compressed.pdf" },
  { gen_slug: "jimny-jb64-suv-2018-present",          file: "manuals/Jimny_2022_compressed.pdf" },
  { gen_slug: "s-cross-jy-suv-2013-2021",             file: "manuals/Gebruikershandleiding_S-Cross_2021-min.pdf" },
  { gen_slug: "s-cross-yed-suv-2022-present",         file: "manuals/Scross_24MC_WEB_99011U63TD0-25D-compressed.pdf" },
  { gen_slug: "swace-sx10-wagon-2020-present",        file: "manuals/Gebruikershandleiding_Suzuki_SWACE_99011-54ZM3-25D-min.pdf" },
  { gen_slug: "swift-az-hatchback-2017-2024",         file: "manuals/Gebruikershandleiding_Swift_2021-min.pdf" },
  { gen_slug: "vitara-ly-suv-2015-present",           file: "manuals/Vitara_2024MC_WEB_99011U74SE0-25D_compressed.pdf" },
];

async function extract(file: string) {
  const buf = readFileSync(file);
  const parser = new PDFParse({ data: buf });
  const r = await parser.getText();
  const t = r.text || "";

  // Anchor on the spec-table header. Suzuki uses multiple Dutch variants:
  //   "aanbevolen brandstof / smeermiddelen en inhoud (ongeveer)"  (Vitara, S-Cross)
  //   "Aanbevolen brandstof / smeermiddelen en hoeveelheden (ongeveer)"  (Jimny)
  //   "ONDERWERP: Aanbevolen brandstof"  (Jimny TOC)
  // Try the most-specific patterns first.
  const re = /(aanbevolen brandstof[^\n]{0,60}(?:smeermiddelen|olie)[^\n]{0,80}(?:inhoud|hoeveelheden)[^\n]{0,40}\(ongeveer\))/i;
  let anchor = t.search(re);
  let block = "";
  if (anchor > 0) {
    block = t.slice(anchor, anchor + 4000);
  } else {
    // Fallback: find "Brandstof <numeric> L" pattern in last 25% of doc
    const m = t.slice(Math.floor(t.length * 0.55)).match(/Brandstof[^\n]{0,30}\d{2,3}\s*[Ll]\b/);
    if (m) {
      anchor = Math.floor(t.length * 0.55) + (m.index || 0);
      block = t.slice(Math.max(0, anchor - 200), anchor + 4000);
    }
  }

  // Try to also pull a few section snippets for completeness
  const fuelTank = t.match(/Brandstof\s+[^\n]{0,50}(\d{2,3})\s*l\b/);
  const engines = [...t.matchAll(/Modellen met\s+([A-Z][A-Z0-9-]{2,8})[-‐]?motor/g)].map(m => m[1]);

  return {
    chars: t.length,
    anchor_pos: anchor,
    fuel_tank_l: fuelTank ? parseFloat(fuelTank[1]) : null,
    engine_codes_seen: [...new Set(engines)],
    block,
  };
}

async function main() {
  mkdirSync("scripts/output/suzuki_specs", { recursive: true });
  const summary: any[] = [];
  for (const m of MANUALS) {
    console.error(`extracting ${m.gen_slug}...`);
    const out = await extract(m.file);
    summary.push({
      gen_slug: m.gen_slug,
      file: m.file,
      chars: out.chars,
      anchor_pos: out.anchor_pos,
      fuel_tank_l: out.fuel_tank_l,
      engine_codes_seen: out.engine_codes_seen,
      block_chars: out.block.length,
    });
    // Dump block as separate file per gen for hand-reading
    writeFileSync(`scripts/output/suzuki_specs/${m.gen_slug}.txt`, out.block);
  }
  writeFileSync("scripts/output/suzuki_specs/summary.json", JSON.stringify(summary, null, 2));
  console.log(JSON.stringify(summary, null, 2));
}
main().catch(e => { console.error(e); process.exit(1); });
