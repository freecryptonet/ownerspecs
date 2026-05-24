#!/usr/bin/env tsx
/**
 * extract_nissan_dimensions.ts — pull dimensions + fuel tank from a set of
 * Nissan NL owner manuals. Output JSON for build-mig consumption.
 *
 * Nissan EU manuals reliably contain a "Technische informatie" section
 * (chapter 9, ~last 10% of doc) with these subsections:
 *   AFMETINGEN  (dimensions: lengte/breedte/hoogte/wielbasis/spoorbreedte)
 *   Vloeistoftype Brandstof ... L  (fuel tank capacity)
 *
 * Usage:
 *   npx tsx scripts/extract_nissan_dimensions.ts > scripts/output/nissan_dims.json
 */

import { readFileSync, writeFileSync } from "node:fs";
// @ts-expect-error — pdf-parse v2 ESM types
import { PDFParse } from "pdf-parse";

// HT33 = X-Trail e-Power (T33 chassis), 0J12 = Qashqai (J12 chassis).
// HJ12 = Qashqai e-Power. 0FE0 = Ariya. 0F16 = Juke.
const MANUALS = [
  { gen_slug: "juke-f16-suv-2019-present",       file: "manuals/om24nl-0f16e1eur.pdf", model_label: "Juke (F16)" },
  { gen_slug: "ariya-fe0-suv-2022-present",      file: "manuals/om24nl-0fe0e4eur.pdf", model_label: "Ariya (FE0)" },
  { gen_slug: "qashqai-j12-suv-2021-present",    file: "manuals/om24nl-0j12e1eur.pdf", model_label: "Qashqai (J12)" },
  { gen_slug: "x-trail-t33-suv-2022-present",    file: "manuals/om24nl-ht33e1eur.pdf", model_label: "X-Trail e-Power (T33)" },
];

type Dims = {
  gen_slug: string;
  file: string;
  model_label: string;
  manual_edition: string | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  front_track_mm: number | null;
  rear_track_mm: number | null;
  fuel_tank_l: number | null;
};

function num(m: RegExpMatchArray | null): number | null {
  if (!m) return null;
  const s = m[1].replace(/\./g, "").replace(",", ".");
  const n = parseFloat(s);
  return isNaN(n) ? null : Math.round(n);
}

async function extract(file: string): Promise<Partial<Dims>> {
  const buf = readFileSync(file);
  const parser = new PDFParse({ data: buf });
  const r = await parser.getText();
  const t = r.text || "";
  // Edition code (filename uppercased)
  const edition = file.match(/(om\d{2}[a-z]{2}-[0-9a-z]+eur)\.pdf$/i)?.[1].toUpperCase() ?? null;
  // Locate AFMETINGEN block. The "AFMETINGEN" duplicated marker appears AT
  // THE END of the section (header repeated as footer in Nissan layout).
  // The data block precedes it. Format:
  //   mm (in.)
  //   Totale lengte 	4.210 (165,7)
  //   Totale breedte 	1.800 (70,9)
  //   ...
  //   AFMETINGEN	AFMETINGEN
  const afmetIdx = t.search(/AFMETINGEN\s*AFMETINGEN/);
  const afmetBlock = afmetIdx > 0 ? t.slice(Math.max(0, afmetIdx - 2000), afmetIdx) : t;
  // Fuel tank: "Brandstof 	46 L 	..." in the vloeistoffen section
  const fuelMatch = t.match(/Brandstof\s+(\d{2,3}(?:[.,]\d)?)\s*L/);
  return {
    manual_edition: edition,
    length_mm: num(afmetBlock.match(/Totale lengte\s+([\d.,]+)/)),
    width_mm: num(afmetBlock.match(/Totale breedte\s+([\d.,]+)/)),
    height_mm: num(afmetBlock.match(/Totale hoogte\s+([\d.,]+)/)),
    wheelbase_mm: num(afmetBlock.match(/Wielbasis\s+([\d.,]+)/)),
    front_track_mm: num(afmetBlock.match(/Spoorbreedte voor\s+([\d.,]+)/)),
    rear_track_mm: num(afmetBlock.match(/Spoorbreedte achter\s+([\d.,]+)/)),
    fuel_tank_l: fuelMatch ? parseFloat(fuelMatch[1].replace(",", ".")) : null,
  };
}

async function main() {
  const out: Dims[] = [];
  for (const m of MANUALS) {
    console.error(`extracting ${m.file}...`);
    const d = await extract(m.file);
    out.push({ ...m, ...d } as Dims);
  }
  writeFileSync("scripts/output/nissan_dims.json", JSON.stringify(out, null, 2));
  console.log(JSON.stringify(out, null, 2));
}
main().catch(e => { console.error(e); process.exit(1); });
