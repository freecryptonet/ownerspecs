#!/usr/bin/env tsx
/**
 * extract_phase2.ts — Pull dimensions + fluids + bulb manifest highlights
 * for the 2 Phase-2 Nissan additions (Leaf ZE1, Micra K14).
 */

import { readFileSync, writeFileSync } from "node:fs";
// @ts-expect-error
import { PDFParse } from "pdf-parse";

type Spec = {
  gen_slug: string;
  file: string;
  manual_edition: string;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  front_track_mm: number | null;
  rear_track_mm: number | null;
  fuel_tank_l: number | null;
  oil_capacity_l: number | null;
  oil_viscosity: string | null;
  oil_spec: string | null;
  coolant_spec: string | null;
  brake_fluid_spec: string | null;
  transmission_label: string | null;
  transmission_spec: string | null;
  transmission_capacity_l: number | null;
  ac_refrigerant: string | null;
  ac_refrigerant_kg: number | null;
  battery_voltage: number | null;
  engine_codes: string[];
};

function nNum(m: RegExpMatchArray | null): number | null {
  if (!m) return null;
  const s = m[1].replace(/\./g, "").replace(",", ".");
  const n = parseFloat(s);
  return isNaN(n) ? null : Math.round(n);
}
function fNum(m: RegExpMatchArray | null): number | null {
  if (!m) return null;
  const s = m[1].replace(",", ".");
  const n = parseFloat(s);
  return isNaN(n) ? null : n;
}

async function extract(file: string, gen_slug: string): Promise<Spec> {
  const buf = readFileSync(file);
  const parser = new PDFParse({ data: buf });
  const r = await parser.getText();
  const t = r.text || "";
  const edition = file.match(/(om\d{2}[a-z]{2}-[0-9a-z]+eur)\.pdf$/i)?.[1].toUpperCase() ?? "?";
  // Dimensions block (AFMETINGEN marker appears AT END of section)
  const afmIdx = t.search(/AFMETINGEN\s*AFMETINGEN/);
  const dimBlock = afmIdx > 0 ? t.slice(Math.max(0, afmIdx - 2200), afmIdx) : "";
  // Fluid section: starts with "9 Technische informatie" or similar
  const fluidIdx = t.search(/Inhoudsmaten en[\s\S]{0,40}vloeistoffen/);
  const fluidBlock = fluidIdx > 0 ? t.slice(fluidIdx, fluidIdx + 8000) : t.slice(900000, 980000);

  // Engine codes (model designation appears in MOTOR table block)
  const engineCodes = [...t.matchAll(/Model\s+([A-Z0-9+]{4,12})\s*\n+\s*Type\s+(?:Benzine|Diesel|Elektromotor)/g)].map(m => m[1]);

  // Fuel tank
  const tankM = t.match(/Brandstof\s+(\d{2,3}(?:[.,]\d)?)\s*L/);
  // Oil capacity (with filter)
  const oilCapM = fluidBlock.match(/Met vervanging\s*\n?\s*oliefilter\s+(\d[\.,]\d)\s*L/);
  // Oil viscosity / spec
  const oilViscM = fluidBlock.match(/SAE\s+(\d+W-\d+)/);
  const oilSpecM = fluidBlock.match(/(?:ACEA|API|NISSAN[^\n]{1,80}?Synthetic[^\n]{0,40}5W-30 C3|ILSAC)[^\n]{0,80}/);
  const coolM = fluidBlock.match(/(NISSAN Genuine Engine Coolant L\d{3}[A-Z]?|NISSAN[^\n]{0,40}Coolant[^\n]{0,30})/);
  const brakeM = fluidBlock.match(/(NISSAN[^\n]{0,30}Brake Fluid[^\n]{0,40}|DOT\s*4[^\n]{0,40})/);
  // Transmission
  let transLabel: string | null = null, transSpec: string | null = null, transCap: number | null = null;
  const transRe = /(Automatische \(DCT\) transmissievloeistof|Hybride transmissievloeistof|Transmissievloeistof|Tandwielreductiekast olie|Differentieelolie|Reductiekast olie)\s+(\d[\.,]\d)\s*L[\s\S]{0,200}?(?:NISSAN[^\n]{0,80}|Genuine[^\n]{0,80}|Originele[^\n]{0,80})?/;
  const tm = fluidBlock.match(transRe);
  if (tm) {
    transLabel = tm[1].trim();
    transCap = fNum([tm[0], tm[2]] as unknown as RegExpMatchArray);
    const specM = fluidBlock.slice(tm.index! + tm[0].length).match(/^\s*\*\s*Origineel\s+([^\n]{2,80})|^\s*\*\s*([A-Z][^\n]{4,80})/);
    if (specM) transSpec = (specM[1] || specM[2] || "").trim();
  }

  // A/C refrigerant
  const acM = fluidBlock.match(/(HFO?-?1234yf|R1234yf|R134a)[\s\S]{0,80}?(\d[\.,]\d{1,3})\s*kg/);
  const acRefrig = acM ? acM[1] : null;
  const acKg = acM ? fNum([acM[0], acM[2]] as unknown as RegExpMatchArray) : null;

  // Battery voltage (12V for ICE, hybrid; HV battery for BEV is different)
  const battM = t.match(/(\d{3,4})\s*V\s+(?:Lithium|Li-Ion|nominale)/i);
  const batteryVoltage = battM ? parseInt(battM[1], 10) : null;

  return {
    gen_slug,
    file,
    manual_edition: edition,
    length_mm: nNum(dimBlock.match(/Totale lengte\s+([\d.,]+)/)),
    width_mm: nNum(dimBlock.match(/Totale breedte(?:\s+exclusief\s+spie[-\s]*gels)?\s+([\d.,]+)/)),
    height_mm: nNum(dimBlock.match(/Totale hoogte(?:\s+exclusief\s+an[-\s]*tenne)?\s+([\d.,]+)/)),
    wheelbase_mm: nNum(dimBlock.match(/Wielbasis\s+([\d.,]+)/)),
    front_track_mm: nNum(dimBlock.match(/Spoorbreedte\s*\n?\s*v[öo][öo]r[^\d]*([\d.,]+)/)),
    rear_track_mm: nNum(dimBlock.match(/Spoorbreedte\s*\n?\s*achter[^\d]*([\d.,]+)/)),
    fuel_tank_l: tankM ? parseFloat(tankM[1].replace(",", ".")) : null,
    oil_capacity_l: oilCapM ? parseFloat(oilCapM[1].replace(",", ".")) : null,
    oil_viscosity: oilViscM?.[1] ?? null,
    oil_spec: oilSpecM?.[0]?.trim() ?? null,
    coolant_spec: coolM?.[1]?.trim() ?? null,
    brake_fluid_spec: brakeM?.[1]?.trim() ?? null,
    transmission_label: transLabel,
    transmission_spec: transSpec,
    transmission_capacity_l: transCap,
    ac_refrigerant: acRefrig,
    ac_refrigerant_kg: acKg,
    battery_voltage: batteryVoltage,
    engine_codes: engineCodes,
  };
}

async function main() {
  const inputs = [
    { file: "manuals/om23nl-0ze1e0eur.pdf", gen_slug: "leaf-ze1-hatchback-2018-2024" },
    { file: "manuals/om21nl-0k14e0eur.pdf", gen_slug: "micra-k14-hatchback-2017-2024" },
  ];
  const out: Spec[] = [];
  for (const i of inputs) {
    console.error(`extracting ${i.file}...`);
    out.push(await extract(i.file, i.gen_slug));
  }
  writeFileSync("scripts/output/phase2_specs.json", JSON.stringify(out, null, 2));
  console.log(JSON.stringify(out, null, 2));
}
main().catch(e => { console.error(e); process.exit(1); });
