/**
 * NHTSA vPIC API wrapper.
 *
 * Why this is a privileged source
 * -------------------------------
 * vPIC data is government-published, manufacturer-filed (FMVSS reporting),
 * public-domain, no-API-key, commercial-use OK. For ownerspecs it's the
 * cheapest authoritative 2nd source on:
 *   - exterior dimensions (length/width/height/wheelbase, track width)
 *   - curb weight per trim variant
 *   - engine displacement, cylinders, HP, fuel type
 *   - transmission style + speed count
 *   - drive type, body class, GVWR class
 *
 * It does NOT cover: fluids, torques, bulbs, fuses, OE part numbers,
 * intervals, procedures, or EU-exclusive trims. Pair it with HaynesPro
 * / OEM manuals for the rest.
 *
 * Two endpoints we use:
 *   1. GetCanadianVehicleSpecifications — year/make/model lookup, returns
 *      per-trim curb weight + chassis dimensions in cm. No VIN needed.
 *   2. DecodeVinValuesExtended — VIN-based, returns full structured
 *      attribute set (engine, trans, drive, trim, plant, MSRP, ...).
 *
 * Polite by default: ≥250 ms between requests. NHTSA's automated rate
 * control will silently 403 you if you go faster.
 */

const NHTSA_BASE = "https://vpic.nhtsa.dot.gov/api/vehicles";
const NHTSA_USER_AGENT =
  process.env.SCRAPER_USER_AGENT ??
  "ownerspecs-bot/0.1 (+https://ownerspecs.com; research crawler; contact timgvk@gmail.com)";
const NHTSA_MIN_DELAY_MS = Number(process.env.NHTSA_MIN_DELAY_MS ?? 300);

let lastRequestAt = 0;

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function politeWait(): Promise<void> {
  const since = Date.now() - lastRequestAt;
  if (since < NHTSA_MIN_DELAY_MS) {
    await sleep(NHTSA_MIN_DELAY_MS - since);
  }
  lastRequestAt = Date.now();
}

async function nhtsaFetch<T>(path: string): Promise<T> {
  await politeWait();
  const url = `${NHTSA_BASE}${path}${path.includes("?") ? "&" : "?"}format=JSON`;
  const res = await fetch(url, {
    headers: { "User-Agent": NHTSA_USER_AGENT, Accept: "application/json" },
  });
  if (!res.ok) {
    throw new Error(`NHTSA ${res.status} on ${url}`);
  }
  return (await res.json()) as T;
}

// ───────────────────── GetCanadianVehicleSpecifications ─────────────────────

export type CanadianSpec = {
  Make?: string;
  Model?: string;
  MYR?: string; // 2-digit year as string ("15" = 2015)
  // dimensions in cm (strings)
  OL?: string; // overall length
  OW?: string; // overall width
  OH?: string; // overall height
  WB?: string; // wheelbase
  TWF?: string; // track width front
  TWR?: string; // track width rear
  CW?: string; // curb weight kg
  WD?: string; // weight distribution
};

type NhtsaSpecPair = { Name: string; Value: string };
type NhtsaResultRow = { Specs: NhtsaSpecPair[] };
type CanadianResp = { Count: number; Message: string; Results: NhtsaResultRow[] };

/** Flatten the {Name, Value} pair array into a typed record. */
function flatten(row: NhtsaResultRow): CanadianSpec {
  const out: Record<string, string> = {};
  for (const p of row.Specs ?? []) {
    if (p.Name && p.Value != null && p.Value !== "") out[p.Name] = p.Value;
  }
  return out as CanadianSpec;
}

/**
 * Returns per-variant Canadian Vehicle Specifications for a (year, make, model).
 * One row per documented variant.
 */
export async function getCanadianSpecs(
  year: number,
  make: string,
  model: string,
): Promise<CanadianSpec[]> {
  const q = new URLSearchParams({
    Year: String(year),
    Make: make,
    Model: model,
    units: "Metric",
  });
  const data = await nhtsaFetch<CanadianResp>(
    `/GetCanadianVehicleSpecifications/?${q}`,
  );
  return (data.Results ?? []).map(flatten);
}

// ───────────────────────────── DecodeVin ─────────────────────────────

export type VinDecode = {
  ModelYear: string;
  Make: string;
  Model: string;
  Trim: string;
  Series: string;
  BodyClass: string;
  DriveType: string;
  EngineCylinders: string;
  EngineHP: string;
  DisplacementCC: string;
  FuelTypePrimary: string;
  EngineConfiguration: string;
  TransmissionStyle: string;
  TransmissionSpeeds: string;
  GVWR: string;
  Doors: string;
  Seats: string;
  Manufacturer: string;
  PlantCity: string;
  PlantCountry: string;
  BasePrice: string;
  WheelBaseShort: string;
  ABS: string;
  ESC: string;
  TPMS: string;
};

type VinResp = { Count: number; Message: string; Results: Partial<VinDecode>[] };

export async function decodeVin(vin: string, modelYear?: number): Promise<Partial<VinDecode>> {
  const q = new URLSearchParams();
  if (modelYear) q.set("modelyear", String(modelYear));
  const data = await nhtsaFetch<VinResp>(
    `/DecodeVinValuesExtended/${encodeURIComponent(vin)}/?${q}`,
  );
  return data.Results?.[0] ?? {};
}

export async function decodeVinBatch(
  vins: Array<{ vin: string; modelYear?: number }>,
): Promise<Partial<VinDecode>[]> {
  if (vins.length === 0) return [];
  if (vins.length > 50) {
    throw new Error("DecodeVinValuesBatch: 50 VINs per request max");
  }
  await politeWait();
  const data = `data=${encodeURIComponent(
    vins.map((v) => `${v.vin}, ${v.modelYear ?? ""}`).join(";"),
  )}`;
  const res = await fetch(`${NHTSA_BASE}/DecodeVINValuesBatch/?format=JSON`, {
    method: "POST",
    headers: {
      "User-Agent": NHTSA_USER_AGENT,
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json",
    },
    body: data,
  });
  if (!res.ok) throw new Error(`NHTSA batch ${res.status}`);
  const json = (await res.json()) as VinResp;
  return json.Results ?? [];
}

// ─────────────────────── Helpers: normalize for diff ───────────────────────

/** cm → mm (NHTSA Canadian Specs returns cm). Returns null on bad input. */
export function cmToMm(s: string | undefined | null): number | null {
  if (s == null) return null;
  const n = Number(s);
  if (!Number.isFinite(n) || n <= 0) return null;
  return Math.round(n * 10);
}

/** Aggregated per-gen dimensions across NHTSA variants. */
export type AggregatedDims = {
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  curb_weight_kg_min: number | null;
  curb_weight_kg_max: number | null;
  variant_count: number;
};

/**
 * Aggregate a set of NHTSA spec rows down to a single "gen-level" summary.
 * Body dimensions should be identical across trims (it's the same chassis);
 * curb weight varies by trim, so we return min/max.
 */
export function aggregate(specs: CanadianSpec[]): AggregatedDims {
  const lengths = specs.map((s) => cmToMm(s.OL)).filter((n): n is number => n != null);
  const widths = specs.map((s) => cmToMm(s.OW)).filter((n): n is number => n != null);
  const heights = specs.map((s) => cmToMm(s.OH)).filter((n): n is number => n != null);
  const wbs = specs.map((s) => cmToMm(s.WB)).filter((n): n is number => n != null);
  const weights = specs
    .map((s) => (s.CW ? Number(s.CW) : null))
    .filter((n): n is number => n != null && Number.isFinite(n));
  const mode = <T extends number>(arr: T[]): T | null => {
    if (arr.length === 0) return null;
    const counts = new Map<T, number>();
    for (const v of arr) counts.set(v, (counts.get(v) ?? 0) + 1);
    return [...counts.entries()].sort((a, b) => b[1] - a[1])[0][0];
  };
  return {
    length_mm: mode(lengths),
    width_mm: mode(widths),
    height_mm: mode(heights),
    wheelbase_mm: mode(wbs),
    curb_weight_kg_min: weights.length ? Math.round(Math.min(...weights)) : null,
    curb_weight_kg_max: weights.length ? Math.round(Math.max(...weights)) : null,
    variant_count: specs.length,
  };
}
