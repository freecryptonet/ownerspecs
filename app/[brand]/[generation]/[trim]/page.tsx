import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { buildCitationIndex } from "@/lib/citations";
import { Cites } from "@/components/Cites";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { pageMetadata, breadcrumbsJsonLd } from "@/lib/seo";
import { fluidLabel, torqueLabel, serviceLabel } from "@/lib/labels";
import {
  kgDual,
  consumptionDual,
  speedDual,
  boreStrokeDual,
  displacementDual,
  mmDual,
} from "@/lib/units";

const SITE = "https://ownerspecs.com";

type Params = { brand: string; generation: string; trim: string };

type Trim = {
  id: number;
  slug: string;
  name: string;
  hp: number | null;
  torque_nm: number | null;
  zero_100_kmh_s: string | null;
  top_speed_kmh: number | null;
  fuel_combined_l_100km: string | null;
  co2_g_km: number | null;
  curb_weight_kg: number | null;
  max_weight_kg: number | null;
  trailer_braked_kg: number | null;
  trailer_unbraked_kg: number | null;
  drive_wheel: string | null;
  tire_size: string | null;
  rim_size: string | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  front_track_mm: number | null;
  rear_track_mm: number | null;
  ground_clearance_mm: number | null;
  drag_coefficient: string | null;
  turning_circle_m: string | null;
  engine_id: number | null;
  engine_code: string | null;
  engine_display: string | null;
  engine_displacement_cc: number | null;
  engine_aspiration: string | null;
  engine_cylinders: number | null;
  engine_bore_mm: string | null;
  engine_stroke_mm: string | null;
  engine_compression: string | null;
  engine_fuel: string | null;
  engine_valvetrain: string | null;
  transmission_id: number | null;
  transmission_type: string | null;
  transmission_name: string | null;
  market_code: string | null;
};

type FluidRow = {
  id: number;
  fluid_type: string;
  engine_id: number | null;
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
  drain_interval_mi: number | null;
  drain_interval_km: number | null;
  drain_interval_months: number | null;
  notes: string | null;
};
type TorqueRow = {
  id: number;
  fastener: string;
  engine_id: number | null;
  torque_nm: number | null;
  torque_ftlb: number | null;
  thread_lock: string | null;
  notes: string | null;
};
type PartRow = {
  id: number;
  part_type: string;
  engine_id: number | null;
  part_number: string;
  source_brand: string | null;
  gap_mm: string | null;
  size: string | null;
  notes: string | null;
};
type TirePressureRow = {
  id: number;
  position: string;
  load_condition: string;
  psi: string | null;
  kpa: number | null;
  tire_size: string | null;
  trim_id: number | null;
};
type ServiceIntervalRow = {
  id: number;
  service: string;
  miles_normal: number | null;
  km_normal: number | null;
  months: number | null;
  notes: string | null;
};

// Engine-scoped types — gen-wide (NULL engine_id) rows are suppressed on
// multi-engine gens to avoid showing the wrong value against this trim's engine.
const ENGINE_SCOPED_FLUIDS = new Set([
  "engine_oil",
  "engine_oil_2_0",
  "engine_oil_1_0t",
  "engine_oil_diesel",
  "coolant",
  "transmission_at",
  "transmission_mt",
  "transmission_cvt",
  "transmission_dct",
  "transmission_ecvt",
]);
const ENGINE_SCOPED_FASTENERS = new Set([
  "spark_plug",
  "oil_drain",
  "cylinder_head_bolt",
  "intake_manifold",
  "exhaust_manifold",
  "flywheel_bolt",
  "valve_cover",
  "cam_bearing_cap",
  "rod_bolt",
  "main_bearing",
]);
const ENGINE_SCOPED_PARTS = new Set([
  "spark_plug",
  "air_filter",
  "oil_filter",
  "pcv_valve",
]);

// Combustion-only specs that must NEVER appear on a battery-electric trim. The
// `fastener` strings are often raw HaynesPro text ("Spark plugs", "Fuel rail"),
// so torques are matched by keyword; services/parts/fluids by their enum key.
const COMBUSTION_FASTENER_RE =
  /spark.?plug|glow.?plug|\bfuel\b|injector|ignition.?coil|exhaust.?manifold|cylinder.?head|valve.?cover|camshaft|crankshaft|timing.?(chain|belt)|flywheel|flexplate|dual.?mass|clutch.?press|\bsump\b|engine.?oil|oil.?filter|oxygen.?sensor|nox.?sensor|knock.?sensor|in(let|take).?manifold|big.?end|main.?bearing|rod.?bolt|starter.?motor|turbo|alternator|coolant.?pump|manual.?transmission|dual.?clutch/i;
const COMBUSTION_SERVICES = new Set([
  "engine_oil_and_filter", "engine_oil_check", "oil_leak_check", "spark_plugs",
  "fuel_filter", "fuel_line_inspection", "engine_air_filter", "valve_clearance",
  "drive_belt_inspection", "drive_belt_replacement", "timing_belt_replacement",
  "exhaust_emissions_check", "transmission_at_fluid", "transmission_mt_fluid",
  "transmission_dct_fluid", "transmission_cvt_fluid",
]);
const COMBUSTION_PARTS = new Set([
  "spark_plug", "air_filter", "oil_filter", "pcv_valve", "drive_belt", "fuel_filter",
]);
const COMBUSTION_FLUIDS = new Set([
  "engine_oil", "engine_oil_2_0", "engine_oil_1_0t", "engine_oil_diesel",
  "transmission_at", "transmission_mt", "transmission_cvt", "transmission_dct", "transmission_ecvt",
]);
// Cross-fuel categorical impossibilities: a diesel has no spark plug/ignition
// coil; a petrol has no glow plug. (Gen-wide torques are often one engine's
// values leaking onto sibling trims of a multi-engine gen.)
const PETROL_IGNITION_RE = /spark.?plug|ignition.?coil/i;
const DIESEL_ONLY_RE = /glow.?plug/i;

function fmtCap(l: string | null, qt: string | null): string {
  if (!l && !qt) return "—";
  if (l && qt) return `${Number(qt).toFixed(1)} qt · ${Number(l).toFixed(1)} L`;
  if (l) return `${Number(l).toFixed(1)} L`;
  return `${Number(qt).toFixed(1)} qt`;
}

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    "SELECT mk.slug AS brand, g.slug AS generation, t.slug AS `trim` " +
    "FROM trims t " +
    "JOIN generations g ON g.id = t.generation_id " +
    "JOIN models m      ON m.id = g.model_id " +
    "JOIN makes mk      ON mk.id = m.make_id " +
    "WHERE g.is_active = 1",
  );
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation, trim } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };

  const trimRow = await queryOne<Trim>(
    `SELECT t.id, t.slug, t.name, t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh, t.fuel_combined_l_100km
     FROM trims t WHERE t.generation_id = ? AND t.slug = ? LIMIT 1`,
    [base.gen.id, trim],
  );
  if (!trimRow) return { title: "Not found" };

  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);

  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${trimRow.name} ${yrs} — Specifications`,
    description: `Complete spec sheet for the ${base.make.name} ${base.gen.display_name} ${trimRow.name} (${yrs}). ${trimRow.hp ? `${trimRow.hp} hp, ` : ""}fluids, torques, parts, tire pressures and maintenance schedule for this specific engine. Cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/${trimRow.slug}`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation, trim } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const trimRow = await queryOne<Trim>(
    `SELECT
       t.id, t.slug, t.name, t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh,
       t.fuel_combined_l_100km, t.co2_g_km, t.curb_weight_kg, t.max_weight_kg,
       t.trailer_braked_kg, t.trailer_unbraked_kg, t.drive_wheel, t.tire_size, t.rim_size,
       t.length_mm, t.width_mm, t.height_mm, t.wheelbase_mm, t.front_track_mm, t.rear_track_mm,
       t.ground_clearance_mm, t.drag_coefficient, t.turning_circle_m,
       t.engine_id,
       e.code AS engine_code, e.display_name AS engine_display, e.displacement_cc AS engine_displacement_cc,
       e.aspiration AS engine_aspiration, e.cylinders AS engine_cylinders,
       e.bore_mm AS engine_bore_mm, e.stroke_mm AS engine_stroke_mm, e.compression AS engine_compression,
       e.fuel AS engine_fuel, e.valvetrain AS engine_valvetrain,
       t.transmission_id, tr.type AS transmission_type, tr.display_name AS transmission_name,
       mk2.code AS market_code
     FROM trims t
     LEFT JOIN engines e        ON e.id  = t.engine_id
     LEFT JOIN transmissions tr ON tr.id = t.transmission_id
     LEFT JOIN markets mk2      ON mk2.id = t.market_id
     WHERE t.generation_id = ? AND t.slug = ? LIMIT 1`,
    [gen.id, trim],
  );
  if (!trimRow) notFound();

  const yrs = yearRange(gen.start_year, gen.end_year);

  // Sibling trims for the bottom nav. No LIMIT — herstructureringsplan §4
  // calls for the full list (competitors render 20-35+ siblings per page) so
  // every variant in the gen is one click away. Pulls minimal columns to keep
  // the row hint useful without ballooning the SELECT.
  const siblings = await query<{
    slug: string;
    name: string;
    hp: number | null;
    engine_code: string | null;
  }>(
    `SELECT t.slug, t.name, t.hp, e.code AS engine_code
     FROM trims t
     LEFT JOIN engines e ON e.id = t.engine_id
     WHERE t.generation_id = ? AND t.slug != ?
     ORDER BY t.hp ASC, t.name`,
    [gen.id, trim],
  );

  // Common-engine cross-vehicle suggestions — herstructureringsplan §4 "common-engine
  // block": on each trim page, list other vehicles in the catalogue that use the same
  // engine_id (e.g. BMW 335i F30 N55 → BMW 535i F10, X3 35i F25). Skipped when the
  // trim has no engine_id or no cross-vehicle matches exist.
  const commonEngineTrims = trimRow.engine_id
    ? await query<{
        brand_slug: string;
        brand_name: string;
        gen_slug: string;
        gen_display: string;
        gen_start: number;
        gen_end: number | null;
        trim_slug: string;
        trim_name: string;
        hp: number | null;
      }>(
        `SELECT mk.slug AS brand_slug, mk.name AS brand_name,
                g.slug AS gen_slug, g.display_name AS gen_display,
                g.start_year AS gen_start, g.end_year AS gen_end,
                t.slug AS trim_slug, t.name AS trim_name, t.hp
         FROM trims t
         JOIN generations g ON g.id = t.generation_id
         JOIN models mdl    ON mdl.id = g.model_id
         JOIN makes mk      ON mk.id = mdl.make_id
         WHERE t.engine_id = ?
           AND t.generation_id != ?
           AND g.is_active = 1
         ORDER BY mk.name, g.start_year DESC, t.hp ASC
         LIMIT 12`,
        [trimRow.engine_id, gen.id],
      )
    : [];

  // Multi-engine signal for the data-grain rule (mirrors gen + topic pages).
  const engineList = await query<{ id: number }>(
    `SELECT DISTINCT e.id FROM engines e JOIN trims t ON t.engine_id = e.id WHERE t.generation_id = ?`,
    [gen.id],
  );
  const trimList = await query<{ hp: number | null }>(
    `SELECT hp FROM trims WHERE generation_id = ?`,
    [gen.id],
  );
  const distinctHps = new Set(trimList.map((t) => t.hp).filter((h): h is number => h != null));
  const multiEngine = engineList.length > 1 || distinctHps.size > 1;

  // FLUIDS for this trim's engine: matching engine_id OR truly gen-wide rows.
  // Engine-scoped NULL rows on multi-engine gens are filtered out.
  const fluidsAll = await query<FluidRow>(
    `SELECT id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard,
            filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
     FROM fluid_specs
     WHERE generation_id = ?
       AND (engine_id = ? OR engine_id IS NULL)
     ORDER BY FIELD(fluid_type,
       'engine_oil','engine_oil_2_0','engine_oil_1_0t','engine_oil_diesel',
       'coolant',
       'transmission_at','transmission_mt','transmission_cvt','transmission_dct','transmission_ecvt',
       'transfer_case','differential_front','differential_rear',
       'brake','ps','ac_refrigerant','washer'),
       id`,
    [gen.id, trimRow.engine_id],
  );
  // Match a transmission_* fluid row against the trim's actual transmission
  // type so e.g. a 6MT Civic Sport doesn't show CVT fluid data, and a CVT
  // EX-T doesn't show MT fluid data. Mapping is fluid_type → transmissions.type.
  const TRANS_FLUID_TYPE: Record<string, string> = {
    transmission_at: "AT",
    transmission_mt: "MT",
    transmission_cvt: "CVT",
    transmission_dct: "DCT",
    transmission_ecvt: "eCVT",
  };
  const trimTransType = trimRow.transmission_type;
  const transmissionFluidMismatch = (fluidType: string) => {
    const expected = TRANS_FLUID_TYPE[fluidType];
    if (!expected) return false; // not a transmission fluid row
    if (!trimTransType) return false; // trim has no known transmission — show all
    // Toyota hybrids use CVT type for eCVT; allow eCVT fluid on CVT trims.
    if (expected === "eCVT" && trimTransType === "CVT") return false;
    if (expected === "CVT" && trimTransType === "eCVT") return false;
    return expected !== trimTransType;
  };
  // Battery-electric trim: hard-suppress every combustion-only spec. A BEV has no
  // spark plugs, fuel system, exhaust, engine oil, etc. — showing them destroys trust.
  // engines.fuel is unnormalised (petrol/Petrol/gasoline/diesel/Diesel/electric).
  const fuelNorm = (trimRow.engine_fuel ?? "").toLowerCase();
  const isEV = fuelNorm === "electric";
  const isDiesel = fuelNorm.includes("diesel");
  const isPetrol = fuelNorm.includes("petrol") || fuelNorm.includes("gasoline");

  const fluids = fluidsAll.filter(
    (f) =>
      !(f.engine_id == null && multiEngine && ENGINE_SCOPED_FLUIDS.has(f.fluid_type)) &&
      !transmissionFluidMismatch(f.fluid_type) &&
      !(isEV && COMBUSTION_FLUIDS.has(f.fluid_type)),
  );

  const torquesAll = await query<TorqueRow>(
    `SELECT id, fastener, engine_id, torque_nm, torque_ftlb, thread_lock, notes
     FROM torque_specs
     WHERE generation_id = ?
       AND (engine_id = ? OR engine_id IS NULL)
     ORDER BY FIELD(fastener,
       'lug_nut','spark_plug','oil_drain','wheel_hub_nut',
       'caliper_bolt','caliper_bracket_bolt','control_arm_bolt',
       'sway_bar_link','cv_axle_nut','cylinder_head_bolt',
       'intake_manifold','exhaust_manifold','flywheel_bolt',
       'valve_cover','cam_bearing_cap','rod_bolt','main_bearing'),
     fastener`,
    [gen.id, trimRow.engine_id],
  );
  const torques = torquesAll.filter(
    (t) =>
      !(t.engine_id == null && multiEngine && ENGINE_SCOPED_FASTENERS.has(t.fastener)) &&
      !(isEV && COMBUSTION_FASTENER_RE.test(t.fastener)) &&
      !(isDiesel && PETROL_IGNITION_RE.test(t.fastener)) &&
      !(isPetrol && DIESEL_ONLY_RE.test(t.fastener)),
  );

  const partsAll = await query<PartRow>(
    `SELECT id, part_type, engine_id, part_number, source_brand, gap_mm, size, notes
     FROM parts
     WHERE generation_id = ?
       AND (engine_id = ? OR engine_id IS NULL)
     ORDER BY FIELD(part_type,
       'oil_filter','air_filter','cabin_filter','spark_plug','pcv_valve',
       'wiper_front','wiper_rear','drive_belt'),
     part_type`,
    [gen.id, trimRow.engine_id],
  );
  const parts = partsAll.filter(
    (p) =>
      !(p.engine_id == null && multiEngine && ENGINE_SCOPED_PARTS.has(p.part_type)) &&
      !(isEV && COMBUSTION_PARTS.has(p.part_type)),
  );

  // Tire pressures: rows tied to this trim, OR rows tied to no trim (gen-wide
  // placard) which fall back when the trim has no specific row.
  const tirePressures = await query<TirePressureRow>(
    `SELECT id, position, load_condition, psi, kpa, tire_size, trim_id
     FROM tire_pressures
     WHERE generation_id = ?
       AND (trim_id = ? OR trim_id IS NULL)
     ORDER BY (trim_id = ?) DESC,
              FIELD(position,'front','rear','spare'),
              FIELD(load_condition,'normal','max_load','winter')`,
    [gen.id, trimRow.id, trimRow.id],
  );

  // Service intervals — filtered to this trim's engine. NULL engine_id rows
  // are gen-wide (tire rotation, brake fluid flush, etc.) and apply to every
  // trim. Engine-scoped rows (spark plugs, timing belt, accessory drive belt)
  // appear only on the matching engine's trim. Matches the trim-focused IA:
  // visitors only see schedule items that apply to their car.
  const serviceIntervalsAll = await query<ServiceIntervalRow>(
    `SELECT id, service, miles_normal, km_normal, months, notes
     FROM service_intervals
     WHERE generation_id = ?
       AND (engine_id IS NULL OR engine_id = ?)
     ORDER BY COALESCE(miles_normal, miles_severe, 999999)`,
    [gen.id, trimRow.engine_id ?? 0],
  );
  const serviceIntervals = serviceIntervalsAll.filter(
    (s) =>
      !(isEV && COMBUSTION_SERVICES.has(s.service)) &&
      !(!isPetrol && s.service === "spark_plugs") &&
      !(isPetrol && s.service === "fuel_filter"),
  );

  // Citation index restricted to rows this trim's page actually renders
  // (post-suppression + post-trim-engine-filter). Includes service_intervals
  // (currently gen-wide on the schema) so maintenance citations resolve.
  const citations = await buildCitationIndex(gen.id, [
    ...fluids.map((r) => ({ table: "fluid_specs", id: r.id })),
    ...torques.map((r) => ({ table: "torque_specs", id: r.id })),
    ...parts.map((r) => ({ table: "parts", id: r.id })),
    ...tirePressures.map((r) => ({ table: "tire_pressures", id: r.id })),
    ...serviceIntervals.map((r) => ({ table: "service_intervals", id: r.id })),
  ]);
  const sources = citations.sources;
  const rev = reviewDate(sources);

  const heroImage = await queryOne<{
    url: string;
    caption: string | null;
    attribution: string | null;
    original_url: string | null;
    width: number | null;
    height: number | null;
  }>(
    `SELECT url, caption, attribution, original_url, width, height
     FROM images WHERE generation_id = ?
     ORDER BY (position = '3-4-front') DESC, trim_id IS NULL, id
     LIMIT 1`,
    [gen.id],
  );

  // JSON-LD: full Car schema (ultimatespecs pattern — strongest among competitors).
  const carJsonLd = {
    "@context": "https://schema.org",
    "@type": "Car",
    name: `${make.name} ${gen.display_name} ${trimRow.name}`,
    brand: { "@type": "Brand", name: make.name },
    model: model.name,
    modelDate: yrs,
    bodyType: gen.body_type,
    vehicleConfiguration: trimRow.engine_code ?? gen.codename ?? undefined,
    image: heroImage ? `${SITE}${heroImage.url}` : undefined,
    url: `${SITE}/${make.slug}/${gen.slug}/${trim}`,
    ...(trimRow.engine_displacement_cc && {
      vehicleEngine: {
        "@type": "EngineSpecification",
        name: trimRow.engine_display ?? trimRow.engine_code ?? undefined,
        engineDisplacement: { "@type": "QuantitativeValue", value: trimRow.engine_displacement_cc, unitText: "cm³" },
        ...(trimRow.engine_cylinders && {
          cylinder: { "@type": "QuantitativeValue", value: trimRow.engine_cylinders },
        }),
        ...(trimRow.hp && { enginePower: { "@type": "QuantitativeValue", value: trimRow.hp, unitText: "hp" } }),
        ...(trimRow.torque_nm && { torque: { "@type": "QuantitativeValue", value: trimRow.torque_nm, unitText: "N·m" } }),
        ...(trimRow.engine_fuel && { fuelType: trimRow.engine_fuel }),
      },
    }),
    ...(trimRow.drive_wheel && { driveWheelConfiguration: trimRow.drive_wheel }),
    ...(trimRow.curb_weight_kg && {
      weight: { "@type": "QuantitativeValue", value: trimRow.curb_weight_kg, unitText: "kg" },
    }),
    ...(trimRow.top_speed_kmh && {
      speed: { "@type": "QuantitativeValue", value: trimRow.top_speed_kmh, unitText: "km/h" },
    }),
    ...(trimRow.fuel_combined_l_100km && {
      fuelConsumption: { "@type": "QuantitativeValue", value: Number(trimRow.fuel_combined_l_100km), unitText: "L/100km" },
    }),
    ...(trimRow.market_code && { vehicleSpecialUsage: trimRow.market_code }),
  };

  const engineMissingNote = !trimRow.engine_id && multiEngine;

  return (
    <>
      <SiteHeader />

      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify([
            breadcrumbsJsonLd({
              brand: make,
              model,
              gen,
              topic: { label: trimRow.name, path: `/${make.slug}/${gen.slug}/${trim}` },
            }),
            carJsonLd,
          ]),
        }}
      />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a><span className="sep">/</span>
          <span>{trimRow.name}</span>
        </nav>

        <div className="pagehead">
          <h1>{make.name} {gen.display_name} {trimRow.name}</h1>
          <div className="sub">
            <span>{yrs}</span>
            <span className="pip"></span>
            {trimRow.hp && <><span>{trimRow.hp} hp</span><span className="pip"></span></>}
            {trimRow.engine_code && <><span>{trimRow.engine_code}</span><span className="pip"></span></>}
            <span>{trimRow.transmission_name ?? "—"}</span>
            {trimRow.drive_wheel && <><span className="pip"></span><span>{trimRow.drive_wheel}</span></>}
          </div>
          <VerifyBadge
            sourceCount={sources.length}
            reviewDate={rev}
            scope="across"
          />
        </div>
      </div>

      <GenerationTabs
        brand={make.slug}
        generation={gen.slug}
        active="overview"
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 24 }}>
            <div>
              {heroImage ? (
                <img
                  src={heroImage.url}
                  alt={heroImage.caption ?? `${make.name} ${gen.display_name} ${trimRow.name}`}
                  style={{ width: "100%", display: "block", border: "1px solid var(--rule)" }}
                />
              ) : null}
              {heroImage?.attribution && (
                <p style={{ fontSize: 11, color: "var(--ink-mute)", marginTop: 4 }}>
                  Photo: {heroImage.attribution} — generation reference; this trim shown for context.
                </p>
              )}
            </div>

            <table className="ib-table">
              <caption>Trim identity</caption>
              <tbody>
                <tr><th>Trim</th><td className="alt">{trimRow.name}</td></tr>
                {trimRow.engine_code && <tr><th>Engine code</th><td>{trimRow.engine_code}</td></tr>}
                {trimRow.engine_display && <tr><th>Engine</th><td className="alt">{trimRow.engine_display}</td></tr>}
                {trimRow.transmission_name && <tr><th>Transmission</th><td>{trimRow.transmission_name}</td></tr>}
                {trimRow.drive_wheel && <tr><th>Drive</th><td className="alt">{trimRow.drive_wheel}</td></tr>}
                {trimRow.market_code && <tr><th>Market</th><td>{trimRow.market_code}</td></tr>}
                <tr><th>Generation</th><td className="alt">{gen.display_name} ({yrs})</td></tr>
              </tbody>
            </table>
          </div>

          {engineMissingNote && (
            <p
              className="muted"
              style={{
                marginTop: 12,
                padding: "10px 14px",
                background: "var(--bg-alt)",
                border: "1px solid var(--rule)",
                borderLeft: "3px solid var(--warn, #c0822a)",
                fontSize: 12,
                color: "var(--ink-soft)",
              }}
            >
              <strong>Engine wiring incomplete:</strong> this trim is not yet mapped to a specific engine
              in our database. Engine-scoped fluids, torques and parts (oil capacity, spark plug torque,
              filter PNs) cannot be filtered to this exact engine and are not shown below. Truly gen-wide
              values (brake fluid, A/C refrigerant, lug nut torque) are still displayed. See the{" "}
              <a href={`/${make.slug}/${gen.slug}`} style={{ color: "var(--accent)" }}>
                generation comparison
              </a>{" "}
              for an at-a-glance view of all variants.
            </p>
          )}
        </section>

        {/* PERFORMANCE */}
        <section>
          <h2 className="section-h">Performance</h2>
          <table className="spec-table">
            <tbody>
              {trimRow.hp && <tr><th>Horsepower</th><td>{trimRow.hp} hp</td></tr>}
              {trimRow.torque_nm && <tr><th>Torque</th><td>{trimRow.torque_nm} N·m · {Math.round(trimRow.torque_nm * 0.737562)} lb·ft</td></tr>}
              {trimRow.zero_100_kmh_s && <tr><th>0-100 km/h (0-62 mph)</th><td>{trimRow.zero_100_kmh_s} s</td></tr>}
              {trimRow.top_speed_kmh && <tr><th>Top speed</th><td>{speedDual(trimRow.top_speed_kmh)}</td></tr>}
              {trimRow.fuel_combined_l_100km && <tr><th>Fuel (combined)</th><td>{consumptionDual(trimRow.fuel_combined_l_100km)}</td></tr>}
              {trimRow.co2_g_km && <tr><th>CO₂ emissions</th><td>{trimRow.co2_g_km} g/km · WLTP combined</td></tr>}
            </tbody>
          </table>
        </section>

        {/* ENGINE BLOCK */}
        {trimRow.engine_displacement_cc && (
          <section>
            <h2 className="section-h">Engine — {trimRow.engine_display ?? trimRow.engine_code}</h2>
            <table className="spec-table">
              <tbody>
                <tr><th>Displacement</th><td>{displacementDual(trimRow.engine_displacement_cc)}</td></tr>
                {trimRow.engine_bore_mm && trimRow.engine_stroke_mm && (
                  <tr><th>Bore × stroke</th><td>{boreStrokeDual(trimRow.engine_bore_mm, trimRow.engine_stroke_mm)}</td></tr>
                )}
                {trimRow.engine_compression && <tr><th>Compression</th><td>{trimRow.engine_compression} : 1</td></tr>}
                {trimRow.engine_aspiration && <tr><th>Aspiration</th><td>{trimRow.engine_aspiration}</td></tr>}
                {trimRow.engine_valvetrain && <tr><th>Valvetrain</th><td>{trimRow.engine_valvetrain}</td></tr>}
                {trimRow.engine_cylinders && (
                  <tr><th>Cylinders</th><td>{trimRow.engine_cylinders} · {trimRow.engine_fuel ?? "—"}</td></tr>
                )}
              </tbody>
            </table>
          </section>
        )}

        {/* DIMENSIONS — herstructureringsplan Fase 1.3. Renders the trim's own
            measurements when present (M-package width, xDrive height, etc.); falls
            back to the gen-level value with a "generation-typical" note so that the
            section is always informative even before trim-level data is scraped. */}
        {((trimRow.length_mm || trimRow.width_mm || trimRow.height_mm || trimRow.wheelbase_mm ||
          trimRow.ground_clearance_mm || trimRow.drag_coefficient || trimRow.turning_circle_m) ||
          (gen.length_mm || gen.width_mm || gen.height_mm || gen.wheelbase_mm)) && (() => {
          const trimHasOwn =
            trimRow.length_mm != null ||
            trimRow.width_mm != null ||
            trimRow.height_mm != null ||
            trimRow.wheelbase_mm != null;
          const dimRow = (label: string, trimV: number | null, genV: number | null) => {
            const v = trimV ?? genV;
            if (v == null) return null;
            const isFallback = trimV == null && genV != null;
            return (
              <tr>
                <th>{label}</th>
                <td>
                  {mmDual(v)}
                  {isFallback && trimHasOwn && (
                    <span className="muted" style={{ marginLeft: 8, fontSize: 11 }}>
                      generation-typical
                    </span>
                  )}
                </td>
              </tr>
            );
          };
          return (
            <section>
              <h2 className="section-h">Dimensions</h2>
              <table className="spec-table">
                <tbody>
                  {dimRow("Length", trimRow.length_mm, gen.length_mm)}
                  {dimRow("Width", trimRow.width_mm, gen.width_mm)}
                  {dimRow("Height", trimRow.height_mm, gen.height_mm)}
                  {dimRow("Wheelbase", trimRow.wheelbase_mm, gen.wheelbase_mm)}
                  {dimRow("Front track", trimRow.front_track_mm, gen.front_track_mm)}
                  {dimRow("Rear track", trimRow.rear_track_mm, gen.rear_track_mm)}
                  {trimRow.ground_clearance_mm && (
                    <tr><th>Ground clearance</th><td>{mmDual(trimRow.ground_clearance_mm)}</td></tr>
                  )}
                  {trimRow.drag_coefficient && (
                    <tr><th>Drag coefficient</th><td>Cd {trimRow.drag_coefficient}</td></tr>
                  )}
                  {trimRow.turning_circle_m && (
                    <tr><th>Turning circle</th><td>{Number(trimRow.turning_circle_m).toFixed(1)} m (curb to curb)</td></tr>
                  )}
                </tbody>
              </table>
            </section>
          );
        })()}

        {/* WEIGHT + TOWING */}
        {(trimRow.curb_weight_kg || trimRow.trailer_braked_kg) && (
          <section>
            <h2 className="section-h">Weight &amp; towing</h2>
            <table className="spec-table">
              <tbody>
                {trimRow.curb_weight_kg && <tr><th>Curb weight</th><td>{kgDual(trimRow.curb_weight_kg)}</td></tr>}
                {trimRow.max_weight_kg && <tr><th>Max gross weight</th><td>{kgDual(trimRow.max_weight_kg)}</td></tr>}
                {trimRow.trailer_braked_kg && <tr><th>Trailer (braked)</th><td>{kgDual(trimRow.trailer_braked_kg)}</td></tr>}
                {trimRow.trailer_unbraked_kg && <tr><th>Trailer (unbraked)</th><td>{kgDual(trimRow.trailer_unbraked_kg)}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

        {/* WHEELS + OE tire size */}
        {(trimRow.tire_size || trimRow.rim_size) && (
          <section>
            <h2 className="section-h">Wheels &amp; tires</h2>
            <table className="spec-table">
              <tbody>
                {trimRow.tire_size && <tr><th>OE tire size</th><td>{trimRow.tire_size}</td></tr>}
                {trimRow.rim_size && <tr><th>OE rim size</th><td>{trimRow.rim_size}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

        {/* FLUIDS — for THIS trim's engine */}
        {fluids.length > 0 && (
          <section>
            <h2 className="section-h">
              Fluids for this trim
              <span className="count">{fluids.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Engine-specific fluids (oil, coolant, transmission) match this trim&apos;s
              {trimRow.engine_display ? ` ${trimRow.engine_display}` : " engine"}.
              Brake fluid, A/C refrigerant and washer fluid apply to the whole generation.
            </p>
            <table className="spec-table">
              <tbody>
                {fluids.map((f) => {
                  const cap = fmtCap(f.capacity_l, f.capacity_qt);
                  const grade = [f.viscosity, f.spec_standard].filter(Boolean).join(" · ");
                  const interval = f.drain_interval_mi
                    ? ` · ${f.drain_interval_mi.toLocaleString()} mi`
                    : f.drain_interval_months
                      ? ` · ${f.drain_interval_months} mo`
                      : "";
                  return (
                    <tr key={f.id}>
                      <th>
                        {fluidLabel(f.fluid_type)}
                        <Cites nums={citations.citationsFor("fluid_specs", f.id)} />
                      </th>
                      <td>
                        {cap}{grade ? ` · ${grade}` : ""}{interval}
                        {f.filter_part_no && <span className="alt"> · filter {f.filter_part_no}</span>}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </section>
        )}

        {/* TORQUES — for THIS trim's engine + gen-wide fasteners */}
        {torques.length > 0 && (
          <section>
            <h2 className="section-h">
              Torque specifications
              <span className="count">{torques.length} {torques.length === 1 ? "fastener" : "fasteners"}</span>
            </h2>
            <table className="spec-table">
              <tbody>
                {torques.map((t) => (
                  <tr key={t.id}>
                    <th>
                      {torqueLabel(t.fastener)}
                      <Cites nums={citations.citationsFor("torque_specs", t.id)} />
                    </th>
                    <td>
                      {t.torque_nm} N·m · {t.torque_ftlb} ft·lb
                      {t.thread_lock && <span className="alt"> · {t.thread_lock}</span>}
                      {t.notes && <span className="alt"> · {t.notes}</span>}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

        {/* PARTS — oil filter PN, spark plug PN, air filter PN */}
        {parts.length > 0 && (
          <section>
            <h2 className="section-h">
              OEM part numbers
              <span className="count">{parts.length}</span>
            </h2>
            <table className="spec-table">
              <tbody>
                {parts.map((p) => (
                  <tr key={p.id}>
                    <th>
                      {p.part_type.replace(/_/g, " ").replace(/\b\w/g, (c) => c.toUpperCase())}
                      <Cites nums={citations.citationsFor("parts", p.id)} />
                    </th>
                    <td>
                      <strong>{p.part_number}</strong>
                      {p.source_brand && <span className="alt"> · {p.source_brand}</span>}
                      {p.gap_mm && <span className="alt"> · gap {p.gap_mm} mm</span>}
                      {p.size && <span className="alt"> · {p.size}</span>}
                      {p.notes && <span className="alt"> · {p.notes}</span>}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

        {/* TIRE PRESSURES */}
        {tirePressures.length > 0 && (
          <section>
            <h2 className="section-h">
              Tire pressures (placard)
              <span className="count">{tirePressures.length}</span>
            </h2>
            <table className="spec-table">
              <tbody>
                {tirePressures.map((p) => (
                  <tr key={p.id}>
                    <th>
                      {p.position[0].toUpperCase() + p.position.slice(1)}
                      {p.load_condition !== "normal" && <span className="alt"> · {p.load_condition.replace(/_/g, " ")}</span>}
                      <Cites nums={citations.citationsFor("tire_pressures", p.id)} />
                    </th>
                    <td>
                      {p.psi ? `${Number(p.psi).toFixed(0)} psi` : "—"}
                      {p.kpa && <span className="alt"> · {p.kpa} kPa</span>}
                      {p.tire_size && <span className="alt"> · {p.tire_size}</span>}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

        {/* MAINTENANCE */}
        {serviceIntervals.length > 0 && (
          <section>
            <h2 className="section-h">
              Maintenance schedule (normal duty)
              <span className="count">{serviceIntervals.length} services</span>
            </h2>
            <table className="spec-table">
              <tbody>
                {serviceIntervals.map((s) => {
                  const interval = s.miles_normal
                    ? `${s.miles_normal.toLocaleString()} mi${s.km_normal ? ` · ${s.km_normal.toLocaleString()} km` : ""}`
                    : s.months
                      ? `${s.months} months`
                      : "—";
                  return (
                    <tr key={s.id}>
                      <th>
                        {serviceLabel(s.service)}
                        <Cites nums={citations.citationsFor("service_intervals", s.id)} />
                      </th>
                      <td>{interval}{s.notes && <span className="alt"> · {s.notes}</span>}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </section>
        )}

        {/* COMPARE CTA — herstructureringsplan §5 "Vergelijk-CTA: Vergelijk 320i met 320d".
            Picks the sibling closest in HP to this trim so the side-by-side is meaningful
            (comparing a 184 hp trim against a 450 hp trim has little purchase intent). */}
        {(() => {
          if (!trimRow.hp || siblings.length === 0) return null;
          const closest = siblings
            .filter((s) => s.hp != null)
            .map((s) => ({ s, delta: Math.abs((s.hp as number) - (trimRow.hp as number)) }))
            .sort((x, y) => x.delta - y.delta)[0];
          if (!closest) return null;
          const compareHref = `/compare/trims/${make.slug}/${gen.slug}/${
            // Canonical pair order: lower-HP trim first (matches generateStaticParams).
            (closest.s.hp as number) < (trimRow.hp as number)
              ? `${closest.s.slug}/vs/${make.slug}/${gen.slug}/${trim}`
              : `${trim}/vs/${make.slug}/${gen.slug}/${closest.s.slug}`
          }`;
          return (
            <section>
              <div
                style={{
                  border: "1px solid var(--rule)",
                  background: "var(--bg-alt)",
                  padding: "14px 18px",
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  gap: 12,
                  flexWrap: "wrap",
                }}
              >
                <div>
                  <div
                    style={{
                      fontSize: 11,
                      fontWeight: 600,
                      letterSpacing: "0.08em",
                      textTransform: "uppercase",
                      color: "var(--ink-soft)",
                      marginBottom: 2,
                    }}
                  >
                    Side-by-side
                  </div>
                  <div style={{ fontSize: 14 }}>
                    Compare <strong>{trimRow.name}</strong> with <strong>{closest.s.name}</strong>
                    <span className="muted" style={{ marginLeft: 8, fontSize: 12 }}>
                      ({trimRow.hp} hp vs {closest.s.hp} hp)
                    </span>
                  </div>
                </div>
                <a
                  href={compareHref}
                  style={{
                    fontSize: 13,
                    padding: "8px 14px",
                    border: "1px solid var(--accent)",
                    color: "var(--accent)",
                    whiteSpace: "nowrap",
                  }}
                >
                  Compare →
                </a>
              </div>
            </section>
          );
        })()}

        {/* OTHER TRIMS */}
        {siblings.length > 0 && (
          <section>
            <h2 className="section-h">
              Other {make.name} {gen.display_name} trims
              <span className="count">{siblings.length}</span>
            </h2>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))",
                gap: 8,
                border: "1px solid var(--rule)",
              }}
            >
              {siblings.map((s) => (
                <li key={s.slug} style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}>
                  <a
                    href={`/${make.slug}/${gen.slug}/${s.slug}`}
                    style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                  >
                    <div style={{ fontWeight: 500 }}>{s.name}</div>
                    {(s.engine_code || s.hp) && (
                      <div className="muted" style={{ fontSize: 11, marginTop: 2 }}>
                        {[s.engine_code, s.hp ? `${s.hp} hp` : null].filter(Boolean).join(" · ")}
                      </div>
                    )}
                  </a>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* COMMON-ENGINE CROSS-VEHICLE BLOCK — herstructureringsplan §4 "common-engine
            block": other vehicles in the catalogue that share this trim's engine.
            Drives long-tail SEO on engine-code queries ("N55 specs", "B58 oil capacity"). */}
        {commonEngineTrims.length > 0 && (
          <section>
            <h2 className="section-h">
              Other vehicles with the {trimRow.engine_code ?? trimRow.engine_display ?? "same"} engine
              <span className="count">{commonEngineTrims.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Same engine, different car. Fluids, torques and parts that are engine-scoped
              (oil capacity, spark plug PN, coolant) are identical across these.
            </p>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(260px, 1fr))",
                gap: 0,
                border: "1px solid var(--rule)",
              }}
            >
              {commonEngineTrims.map((c) => {
                const cyrs = c.gen_end
                  ? `${c.gen_start}–${c.gen_end}`
                  : `${c.gen_start}–present`;
                return (
                  <li
                    key={`${c.brand_slug}/${c.gen_slug}/${c.trim_slug}`}
                    style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}
                  >
                    <a
                      href={`/${c.brand_slug}/${c.gen_slug}/${c.trim_slug}`}
                      style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                    >
                      <div
                        style={{
                          fontSize: 10,
                          fontWeight: 600,
                          letterSpacing: "0.08em",
                          textTransform: "uppercase",
                          color: "var(--ink-soft)",
                          marginBottom: 2,
                        }}
                      >
                        {c.brand_name}
                      </div>
                      <div style={{ fontWeight: 500 }}>
                        {c.gen_display} {c.trim_name}
                      </div>
                      <div
                        className="muted"
                        style={{
                          fontFamily: "var(--font-mono)",
                          fontSize: 11,
                          marginTop: 2,
                        }}
                      >
                        {cyrs}{c.hp ? ` · ${c.hp} hp` : ""}
                      </div>
                    </a>
                  </li>
                );
              })}
            </ul>
          </section>
        )}

        {/* TOPIC PAGES */}
        <section>
          <h2 className="section-h">Compare across all engines</h2>
          <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
            Side-by-side comparison pages for the {gen.display_name} lineup.
          </p>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(220px, 1fr))",
              gap: 8,
              border: "1px solid var(--rule)",
            }}
          >
            {[
              { key: "oil-capacity", label: "Engine oil — by engine" },
              { key: "coolant", label: "Coolant — by engine" },
              { key: "transmission-fluid", label: "Transmission fluid" },
              { key: "torque", label: "Torque specifications" },
              { key: "maintenance-schedule", label: "Maintenance schedule" },
              { key: "electrical", label: "Electrical (battery, bulbs, fuses)" },
              { key: "tires", label: "Tires & pressures" },
              { key: "procedures", label: "Service procedures" },
            ].map((t) => (
              <li key={t.key} style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}>
                <a
                  href={`/${make.slug}/${gen.slug}/${t.key}`}
                  style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                >
                  {t.label}
                </a>
              </li>
            ))}
          </ul>
        </section>

        {/* SOURCES */}
        {sources.length > 0 && (
          <section className="sources-block">
            <h3>Sources</h3>
            <ol className="sources-list">
              {sources.map((s, i) => (
                <li key={s.id} id={`src-${i + 1}`}>
                  <span>
                    <span className="who">
                      {s.public_link === 1 && s.url ? (
                        <a href={s.url} rel="nofollow noopener noreferrer" target="_blank">{s.citation}</a>
                      ) : <cite>{s.citation}</cite>}
                    </span>
                    {s.notes && <span className="what">{s.notes}</span>}
                  </span>
                  <span className="when">
                    Retrieved {new Date(s.retrieved_at).toISOString().slice(0, 10)}
                  </span>
                </li>
              ))}
            </ol>
          </section>
        )}
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
