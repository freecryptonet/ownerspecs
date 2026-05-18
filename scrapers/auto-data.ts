/**
 * Scraper for auto-data.net.
 *
 * URL pattern: /en/{slug}-{numeric-id}  where slug is brand-model-generation-trim.
 * Page structure: <h3>Category</h3> + <dl><dt>Label</dt><dd>Value</dd>…</dl>
 *
 * We extract:
 * - General: brand, model, generation, modification (full trim name),
 *   years, body, doors, seats, powertrain
 * - Engine: code, displacement, bore/stroke, compression, valvetrain,
 *   aspiration, fuel
 * - Performance: power, torque, 0-100, top speed, fuel consumption
 *   (urban/extra/combined), CO2, fuel type
 * - Dimensions: length, width, height, wheelbase, track, overhangs
 * - Capacities: fuel tank, trunk, kerb weight, max weight, trailer loads
 * - Drivetrain: drive wheels, transmission, suspension, brakes, tires,
 *   wheel rims
 *
 * We DO NOT extract:
 * - Images (sourced separately, per provenance rules)
 * - Editorial/marketing text
 * - The site's category labels verbatim — we map to our own
 *
 * Each call returns one trim's data. To assemble a generation, call multiple
 * times for the different trims and merge by engine code.
 */
import * as cheerio from "cheerio";
import { fetchHtml, log, parseNumber, parsePair } from "./lib.js";

export type AutoDataSpec = {
  source: "auto-data.net";
  url: string;
  scraped_at: string;
  raw_label: string; // e.g. "BMW 3 Series Sedan (G20) 330i 258 HP"
  brand: string | null;
  model: string | null;
  generation: string | null; // "3 Series Sedan (G20)"
  trim_modification: string | null; // "330i 258 HP Steptronic"
  body_type: string | null;
  start_year: number | null;
  end_year: number | null; // null = present
  doors: number | null;
  seats: number | null;
  engine: {
    code: string | null;
    displacement_cc: number | null;
    cylinders: number | null;
    bore_mm: number | null;
    stroke_mm: number | null;
    compression: number | null;
    valvetrain: string | null;
    aspiration: string | null;
    fuel: string | null;
    layout: string | null;
  };
  performance: {
    hp: number | null;
    kw: number | null;
    torque_nm: number | null;
    zero_100_kmh_s: number | null;
    top_speed_kmh: number | null;
    fuel_combined_l_100km: number | null;
    fuel_urban_l_100km: number | null;
    co2_g_km: number | null;
    emission_standard: string | null;
  };
  dimensions: {
    length_mm: number | null;
    width_mm: number | null;
    height_mm: number | null;
    wheelbase_mm: number | null;
    front_track_mm: number | null;
    rear_track_mm: number | null;
  };
  weight: {
    kerb_kg: number | null;
    max_kg: number | null;
    fuel_tank_l: number | null;
    trunk_l: number | null;
    trailer_braked_kg: number | null;
    trailer_unbraked_kg: number | null;
  };
  drivetrain: {
    drive_wheel: string | null;
    transmission: string | null; // "8-speed automatic"
    front_suspension: string | null;
    rear_suspension: string | null;
    front_brakes: string | null;
    rear_brakes: string | null;
    tire_size: string | null;
    wheel_rim_size: string | null;
  };
  fluid_hints: {
    // auto-data has these on some pages; sparse / often missing
    engine_oil_capacity_l: number | null;
    engine_oil_spec: string | null;
    coolant_l: number | null;
  };
};

/** Empty skeleton — all fields nullable. */
function empty(url: string): AutoDataSpec {
  return {
    source: "auto-data.net",
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
      engine_oil_capacity_l: null,
      engine_oil_spec: null,
      coolant_l: null,
    },
  };
}

/**
 * Parse the trim page HTML. The scaffold collects every <dt>/<dd> pair into a
 * flat map keyed by the normalised label, then we cherry-pick known fields.
 *
 * Labels are normalised: lowercased, punctuation stripped. This insulates us
 * from minor wording changes on their side.
 */
export function parseAutoDataTrim(url: string, html: string): AutoDataSpec {
  const $ = cheerio.load(html);
  const out = empty(url);

  // h1 / title is the trim name
  out.raw_label = $("h1").first().text().trim() || $("title").text().trim();

  // Collect every <th>/<td> pair from the spec tables.
  // The table layout: <table class="cardetailsout car2"><caption><h3>Category</h3></caption>
  //   <tr><th>Label</th><td>Metric value <span class="val2">Imperial</span></td></tr>
  // We strip the imperial conversion (span.val2) so the value is the metric figure only.
  const fields = new Map<string, string>();
  $("table.cardetailsout").each((_, table) => {
    $(table)
      .find("tr")
      .each((_, tr) => {
        const $tr = $(tr);
        const labelEl = $tr.find("th").first();
        const valueEl = $tr.find("td").first();
        if (!labelEl.length || !valueEl.length) return;

        const label = labelEl.text().replace(/\s+/g, " ").trim();
        // Clone the <td>, drop the imperial conversion spans, then read text.
        const $valueClone = valueEl.clone();
        $valueClone.find("span.val2").remove();
        // Also drop "log in to see" login-gate placeholders
        $valueClone.find("a[href*='/login']").remove();
        $valueClone.find("img.datalock").remove();
        const value = $valueClone.text().replace(/\s+/g, " ").trim();

        if (label) fields.set(normalize(label), value);
      });
  });

  // ----- General -----
  out.brand = fields.get("brand") || null;
  out.model = fields.get("model") || null;
  out.generation = fields.get("generation") || null;
  out.trim_modification =
    fields.get("modification engine") ||
    fields.get("modification") ||
    null;
  out.body_type = fields.get("body type") || null;
  out.doors = parseNumber(fields.get("number of doors") ?? fields.get("doors"));
  out.seats = parseNumber(fields.get("number of seats") ?? fields.get("seats"));

  const startStr = fields.get("start of production");
  const endStr = fields.get("end of production");
  out.start_year = parseNumber(startStr?.match(/\d{4}/)?.[0]);
  // "End of production: 2022 year" → 2022. Missing/empty → still in production.
  if (endStr && /\d{4}/.test(endStr)) {
    out.end_year = parseNumber(endStr.match(/\d{4}/)?.[0]);
  } else {
    out.end_year = null;
  }

  // ----- Engine -----
  const eng = out.engine;
  eng.code = fields.get("engine model code") || fields.get("engine code") || null;
  eng.displacement_cc = parseNumber(fields.get("engine displacement"));
  eng.cylinders = parseNumber(fields.get("number of cylinders"));
  eng.compression = parseNumber(fields.get("compression ratio"));
  eng.valvetrain = fields.get("valvetrain") || null;
  eng.aspiration = fields.get("engine aspiration") || null;
  eng.fuel = fields.get("fuel type") || null;
  eng.layout = fields.get("engine layout") || fields.get("engine configuration") || null;

  const bore = parseNumber(fields.get("cylinder bore"));
  const stroke = parseNumber(fields.get("piston stroke"));
  // Auto-data sometimes packs as "73.0 mm × 89.5 mm" in one field
  const bs = parsePair(fields.get("bore × stroke") ?? fields.get("bore stroke"));
  eng.bore_mm = bore ?? (bs ? bs[0] : null);
  eng.stroke_mm = stroke ?? (bs ? bs[1] : null);

  // ----- Performance -----
  const perf = out.performance;
  // Power "258 hp @ 5000-6500 rpm" — first number is hp
  perf.hp = parseNumber(fields.get("power")?.match(/\d+(?:\.\d+)?\s*hp/i)?.[0]) ?? null;
  if (perf.hp === null) {
    // Try without unit anchor — first integer wins
    perf.hp = parseNumber(fields.get("power")?.match(/^\D*(\d+)/)?.[1]);
  }
  perf.kw = parseNumber(fields.get("power")?.match(/(\d+)\s*kw/i)?.[1]);
  perf.torque_nm = parseNumber(fields.get("torque")?.match(/(\d+)\s*nm/i)?.[1]) ??
    parseNumber(fields.get("torque")?.match(/^\D*(\d+)/)?.[1]);

  perf.zero_100_kmh_s = parseNumber(
    fields.get("acceleration 0 100 km h")?.match(/(\d+(?:\.\d+)?)/)?.[1],
  );
  perf.top_speed_kmh = parseNumber(
    fields.get("maximum speed")?.match(/(\d+)/)?.[1],
  );

  // Their label is "Fuel consumption (economy) - urban/combined" — normalises to
  // "fuel consumption economy urban". Be defensive with multiple shapes.
  perf.fuel_combined_l_100km = parseNumber(
    fields.get("fuel consumption economy combined") ??
      fields.get("fuel consumption combined"),
  );
  perf.fuel_urban_l_100km = parseNumber(
    fields.get("fuel consumption economy urban") ??
      fields.get("fuel consumption urban"),
  );
  perf.co2_g_km = parseNumber(fields.get("co2 emissions")?.match(/(\d+)/)?.[1]);
  perf.emission_standard = fields.get("emission standard") || null;

  // ----- Dimensions -----
  const dim = out.dimensions;
  dim.length_mm = parseNumber(fields.get("length"));
  dim.width_mm = parseNumber(fields.get("width"));
  dim.height_mm = parseNumber(fields.get("height"));
  dim.wheelbase_mm = parseNumber(fields.get("wheelbase"));
  dim.front_track_mm = parseNumber(fields.get("front track"));
  dim.rear_track_mm = parseNumber(fields.get("rear track"));

  // ----- Weight & capacities -----
  const w = out.weight;
  w.kerb_kg = parseNumber(fields.get("kerb weight"));
  w.max_kg = parseNumber(fields.get("max weight"));
  w.fuel_tank_l = parseNumber(fields.get("fuel tank capacity"));
  // Trunk has multiple variants: "minimum", "maximum", or just "trunk space"
  w.trunk_l =
    parseNumber(fields.get("trunk boot space minimum")) ??
    parseNumber(fields.get("trunk space minimum")) ??
    parseNumber(fields.get("trunk space"));
  w.trailer_braked_kg = parseNumber(
    fields.get("permitted trailer load with brakes 12") ??
      fields.get("permitted trailer load with brakes"),
  );
  w.trailer_unbraked_kg = parseNumber(
    fields.get("permitted trailer load without brakes"),
  );

  // ----- Drivetrain -----
  const dt = out.drivetrain;
  dt.drive_wheel = fields.get("drive wheel") || null;
  dt.transmission =
    fields.get("number of gears type") ||
    fields.get("number of gears and type of gearbox") ||
    null;
  dt.front_suspension = fields.get("front suspension") || null;
  dt.rear_suspension = fields.get("rear suspension") || null;
  dt.front_brakes = fields.get("front brakes") || null;
  dt.rear_brakes = fields.get("rear brakes") || null;
  dt.tire_size = fields.get("tires size") || null;
  dt.wheel_rim_size = fields.get("wheel rims size") || null;

  // ----- Fluid hints (often empty on auto-data) -----
  const f = out.fluid_hints;
  f.engine_oil_capacity_l = parseNumber(fields.get("engine oil capacity"));
  f.engine_oil_spec = fields.get("engine oil specification") || null;
  f.coolant_l = parseNumber(fields.get("coolant"));

  return out;
}

function normalize(label: string): string {
  return label
    .toLowerCase()
    .replace(/[(),./\\]/g, " ")
    .replace(/[-_]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

/**
 * High-level: scrape one trim URL end-to-end (fetch + parse).
 */
export async function scrapeAutoDataTrim(url: string): Promise<AutoDataSpec> {
  log("auto-data", `GET ${url}`);
  const html = await fetchHtml(url);
  const parsed = parseAutoDataTrim(url, html);
  log("auto-data", `parsed: ${parsed.raw_label}`);
  return parsed;
}
