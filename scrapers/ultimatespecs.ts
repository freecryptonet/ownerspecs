/**
 * Scraper for ultimatespecs.com.
 *
 * URL pattern: /car-specs/{Brand}/{numericId}/{Brand}-{Codename}-{Model}-{Trim}.html
 * Page structure: a series of <table class="content_text"> blocks, one per
 * spec section, each with rows:
 *   <td class="tabletd">Label :</td>
 *   <td class="tabletd_right">Value</td>
 *
 * Sections (h2 in `<span class="spec_title_text">`):
 *   1. Body, Model and Production details
 *   2. Engine Technical Data
 *   3. Fuel Consumption (Economy), Emissions and Range
 *   4. Performance
 *   5. Size, Dimensions, Aerodynamics and Weight
 *   6. Interior size, Dimensions
 *   7. Brakes, Tires, Steering and Suspension
 *
 * Notable quirks vs auto-data.net:
 * - Dimensions in cm (we convert to mm to match our schema)
 * - Power cell has three units: "258 PS / 254 HP / 190 kW@ 5000 rpm" —
 *   we pick the PS figure as `hp` (matches auto-data's "Hp" which is PS)
 *   and capture kW separately.
 * - Bore × stroke combined into one cell, with both metric and imperial
 *   in the same text: "82.0 x 94.6 mm3.23 x 3.72 inches"
 * - Empty/missing values render as "-" — we treat as null.
 * - No engine_oil_capacity or coolant_capacity (auto-data has those).
 * - "Curb Weight" can differ from auto-data's "Kerb Weight" by ~50-100 kg
 *   because measurement conventions differ; reconciliation should flag.
 *
 * Returns the same `AutoDataSpec` shape (renamed `TrimSpec`) so reconciliation
 * is straightforward — same fields, different sources.
 */
import * as cheerio from "cheerio";
import { fetchHtml, log, parseNumber, parsePair } from "./lib.js";
import type { AutoDataSpec } from "./auto-data.js";

/** Same shape as AutoDataSpec but with source="ultimatespecs.com". */
export type UltimateSpecsSpec = Omit<AutoDataSpec, "source"> & {
  source: "ultimatespecs.com";
};

function empty(url: string): UltimateSpecsSpec {
  return {
    source: "ultimatespecs.com",
    url,
    scraped_at: new Date().toISOString(),
    raw_label: "",
    brand: null,
    model: null,
    generation: null,
    trim_modification: null,
    body_type: null,
    start_year: null,
    end_year: null,
    doors: null,
    seats: null,
    engine: {
      code: null,
      displacement_cc: null,
      cylinders: null,
      bore_mm: null,
      stroke_mm: null,
      compression: null,
      valvetrain: null,
      aspiration: null,
      fuel: null,
      layout: null,
    },
    performance: {
      hp: null,
      kw: null,
      torque_nm: null,
      zero_100_kmh_s: null,
      top_speed_kmh: null,
      fuel_combined_l_100km: null,
      fuel_urban_l_100km: null,
      co2_g_km: null,
      emission_standard: null,
    },
    dimensions: {
      length_mm: null,
      width_mm: null,
      height_mm: null,
      wheelbase_mm: null,
      front_track_mm: null,
      rear_track_mm: null,
    },
    weight: {
      kerb_kg: null,
      max_kg: null,
      fuel_tank_l: null,
      trunk_l: null,
      trailer_braked_kg: null,
      trailer_unbraked_kg: null,
    },
    drivetrain: {
      drive_wheel: null,
      transmission: null,
      front_suspension: null,
      rear_suspension: null,
      front_brakes: null,
      rear_brakes: null,
      tire_size: null,
      wheel_rim_size: null,
    },
    fluid_hints: {
      // ultimatespecs doesn't publish these; always null for this source.
      engine_oil_capacity_l: null,
      engine_oil_spec: null,
      coolant_l: null,
    },
  };
}

function normalize(label: string): string {
  return label
    .toLowerCase()
    .replace(/[(),./\\]/g, " ")
    .replace(/[-_]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

/** Pull the first number followed by `unit` in `text`. */
function numberBefore(text: string | null | undefined, unit: RegExp): number | null {
  if (!text) return null;
  const re = new RegExp(`(-?\\d+(?:\\.\\d+)?)\\s*${unit.source}`, "i");
  const m = text.match(re);
  return m ? Number(m[1]) : null;
}

/** Treat "-" or empty as null. */
function clean(value: string | undefined): string | null {
  if (!value) return null;
  const t = value.trim();
  if (!t || t === "-") return null;
  return t;
}

export function parseUltimateSpecsTrim(url: string, html: string): UltimateSpecsSpec {
  const $ = cheerio.load(html);
  const out = empty(url);

  // Page <title> is "BMW G20 3 Series 330i Specs, Performance, Comparisons"
  // — strip the boilerplate suffix.
  const title = $("title").first().text().trim();
  out.raw_label = title.replace(/\s+Specs,?\s+Performance,?\s+Comparisons\s*$/i, "").trim();

  // Collect every label/value pair from content_text tables.
  const fields = new Map<string, string>();
  $("table.content_text tr").each((_, tr) => {
    const $tr = $(tr);
    const tds = $tr.find("td").toArray();
    if (tds.length < 2) return;
    const labelCell = tds.find((td) => $(td).attr("class")?.includes("tabletd") && !$(td).attr("class")?.includes("tabletd_right"));
    const valueCell = tds.find((td) => $(td).attr("class")?.includes("tabletd_right"));
    if (!labelCell || !valueCell) return;
    const rawLabel = $(labelCell).text().replace(/\s+/g, " ").trim().replace(/\s*:\s*$/, "");
    const rawValue = $(valueCell).text().replace(/\s+/g, " ").trim();
    if (rawLabel && rawValue) fields.set(normalize(rawLabel), rawValue);
  });

  // ----- General -----
  // ultimatespecs doesn't expose make/model/generation as separate cells the
  // way auto-data does; instead, the H1/title carries everything. We parse it.
  // Title format: "BMW G20 3 Series 330i" → brand="BMW", model="3 Series",
  // codename in slug, trim="330i"
  // Most reliable: take the page H1 / title and the "Generation" cell.
  const genRow = fields.get("generation");
  out.generation = clean(genRow);

  // brand/model/trim_modification: from the raw title
  // The title we kept is "BMW G20 3 Series 330i" — first word brand, last words trim
  const titleParts = out.raw_label.split(/\s+/).filter(Boolean);
  out.brand = titleParts[0] ?? null;
  // Best-effort model extraction: between brand and the trim suffix. Without
  // a robust mapping table we leave model null; reconciliation can derive it
  // from auto-data's explicit "Model" field.
  out.model = null;
  out.trim_modification = out.raw_label || null;

  out.body_type = clean(fields.get("body"));
  out.doors = parseNumber(fields.get("num of doors"));
  out.seats = parseNumber(fields.get("num of seats"));

  // Years often missing from this site — leave null
  out.start_year = parseNumber(fields.get("year of car production")) ?? null;
  out.end_year = null;

  // ----- Engine -----
  const eng = out.engine;
  eng.code = clean(fields.get("engine code"));
  eng.displacement_cc = parseNumber(fields.get("engine displacement"));
  // "Engine type - Number of cylinders" → "Inline 4" → we want just the 4
  eng.cylinders = parseNumber(fields.get("engine type number of cylinders"));
  const bs = fields.get("bore x stroke");
  // Format: "82.0 x 94.6 mm3.23 x 3.72 inches" — split on "mm" to keep the metric pair.
  if (bs) {
    const metricPart = bs.split(/mm/i)[0] ?? bs;
    const pair = parsePair(metricPart);
    if (pair) {
      [eng.bore_mm, eng.stroke_mm] = pair;
    }
  }
  eng.compression = parseNumber(fields.get("compression ratio"));
  eng.valvetrain = clean(fields.get("number of valves"));
  eng.aspiration = clean(fields.get("aspiration"));
  eng.fuel = clean(fields.get("fuel type"));
  // Their "Engine Alignment" + "Engine Position" combine to layout
  const alignment = clean(fields.get("engine alignment"));
  const position = clean(fields.get("engine position"));
  eng.layout = [position, alignment].filter(Boolean).join(", ") || null;

  // ----- Performance -----
  const perf = out.performance;
  // "Horsepower" cell: "258 PS / 254 HP / 190 kW@ 5000 rpm"
  // We pick PS (matches German OEM and what auto-data's "Hp" actually is)
  // and capture kW separately.
  const power = fields.get("horsepower");
  perf.hp = numberBefore(power, /PS/i);
  perf.kw = numberBefore(power, /kW/i);
  // If PS missing, fall back to HP
  if (perf.hp === null) perf.hp = numberBefore(power, /HP/i);

  perf.torque_nm = numberBefore(fields.get("maximum torque"), /Nm/i);
  perf.zero_100_kmh_s = parseNumber(fields.get("acceleration 0 to 100 km h 0 to 62 mph"));
  if (perf.zero_100_kmh_s === null) {
    perf.zero_100_kmh_s = parseNumber(fields.get("acceleration 0 to 100 km h"));
  }
  perf.top_speed_kmh = numberBefore(fields.get("top speed"), /km\s*\/?\s*h/i);

  perf.fuel_combined_l_100km = numberBefore(
    fields.get("fuel consumption economy combined nedc") ??
      fields.get("fuel consumption economy combined") ??
      fields.get("fuel consumption combined nedc") ??
      fields.get("fuel consumption combined"),
    /L\s*\/?\s*100/i,
  );
  perf.fuel_urban_l_100km = numberBefore(
    fields.get("fuel consumption economy city nedc") ??
      fields.get("fuel consumption economy city") ??
      fields.get("fuel consumption city nedc") ??
      fields.get("fuel consumption city"),
    /L\s*\/?\s*100/i,
  );
  perf.co2_g_km = parseNumber(fields.get("co2 emissions"));
  perf.emission_standard = clean(fields.get("emission standard"));

  // ----- Dimensions (cm → mm) -----
  const cmToMm = (v: number | null) => (v === null ? null : Math.round(v * 10));
  const dim = out.dimensions;
  dim.length_mm = cmToMm(parseNumber(fields.get("length")));
  dim.width_mm = cmToMm(parseNumber(fields.get("width")));
  dim.height_mm = cmToMm(parseNumber(fields.get("height")));
  dim.wheelbase_mm = cmToMm(parseNumber(fields.get("wheelbase")));
  dim.front_track_mm = cmToMm(parseNumber(fields.get("front axle")));
  dim.rear_track_mm = cmToMm(parseNumber(fields.get("rear axle")));

  // ----- Weight -----
  const w = out.weight;
  w.kerb_kg = numberBefore(fields.get("curb weight"), /kg/i);
  w.max_kg = numberBefore(fields.get("max weight"), /kg/i);
  w.fuel_tank_l = numberBefore(fields.get("fuel tank capacity"), /L/i);
  w.trunk_l = numberBefore(fields.get("trunk boot capacity"), /L/i);
  w.trailer_braked_kg = numberBefore(fields.get("max towing capacity weight"), /kg/i);
  w.trailer_unbraked_kg = null; // ultimatespecs doesn't publish unbraked

  // ----- Drivetrain -----
  const dt = out.drivetrain;
  dt.drive_wheel = clean(fields.get("drive wheels traction drivetrain"));
  // Their cell concatenates "8 speed Sequential Automatic Transmission Relations1st Gear Ratio: 2nd …"
  // Strip everything from "Relations" or "Gear Ratio:" onwards.
  const txRaw = clean(fields.get("transmission gearbox number of speeds"));
  dt.transmission = txRaw
    ? txRaw.replace(/\s*(Relations|Gear Ratio).*$/i, "").trim() || null
    : null;
  dt.front_suspension = clean(fields.get("front suspension"));
  dt.rear_suspension = clean(fields.get("rear suspension"));
  // Brake cells: "Vented Discs(- mm / - inches)" when dims unknown — drop the placeholder.
  const cleanBrake = (s: string | null) =>
    s ? s.replace(/\(-?\s*(mm|inches)?[^)]*\)/gi, "").trim() || null : null;
  dt.front_brakes = cleanBrake(clean(fields.get("front brakes disc dimensions")));
  dt.rear_brakes = cleanBrake(clean(fields.get("rear brakes disc dimensions")));
  // ultimatespecs publishes tire size in the "Tyres - Rims dimensions" cells,
  // but it's actually the tire size, not the rim. Front and rear are usually
  // identical for non-staggered cars; capture front; leave wheel_rim_size null.
  dt.tire_size = clean(fields.get("front tyres rims dimensions"));
  dt.wheel_rim_size = null;

  return out;
}

/** High-level: fetch and parse one trim URL. */
export async function scrapeUltimateSpecsTrim(url: string): Promise<UltimateSpecsSpec> {
  log("ultimatespecs", `GET ${url}`);
  const html = await fetchHtml(url);
  const parsed = parseUltimateSpecsTrim(url, html);
  log("ultimatespecs", `parsed: ${parsed.raw_label}`);
  return parsed;
}
