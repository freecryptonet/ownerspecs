import { Fragment } from "react";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { buildCitationIndex } from "@/lib/citations";
import { Cites } from "@/components/Cites";
import { NameplateRail } from "@/components/NameplateRail";
import {
  mmDual,
  kgDual,
  litreDual,
  litreCargoDual,
  consumptionDual,
  speedDual,
  boreStrokeDual,
  displacementDual,
} from "@/lib/units";
import { fluidLabel, torqueLabel, serviceLabel } from "@/lib/labels";
import { pageMetadata, breadcrumbsJsonLd, vehicleJsonLd } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

type Params = { brand: string; generation: string };

// ---------- types ----------
type Make = { id: number; slug: string; name: string; country_of_origin: string | null };
type Model = { id: number; make_id: number; slug: string; name: string };
type Generation = {
  id: number;
  model_id: number;
  slug: string;
  ordinal: number | null;
  codename: string | null;
  family_slug: string | null;
  family_label: string | null;
  display_name: string;
  body_type: string;
  start_year: number;
  end_year: number | null;
  layout: string | null;
  platform: string | null;
  editorial_intro: string | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  front_track_mm: number | null;
  rear_track_mm: number | null;
  fuel_tank_l: string | null;
  cargo_l: number | null;
  front_suspension: string | null;
  rear_suspension: string | null;
  front_brakes: string | null;
  rear_brakes: string | null;
  oem_manual_url: string | null;
  oem_manual_pdf_size_mb: string | null;
  oem_manual_year_referenced: number | null;
  oem_manual_source_id: number | null;
  oem_manual_verified_at: Date | string | null;
};
type FamilySibling = {
  id: number;
  slug: string;
  codename: string | null;
  body_type: string;
  start_year: number;
  end_year: number | null;
  model_slug: string;
  model_name: string;
  make_slug: string;
};
type Market = { id: number; code: string; name: string };
type Engine = {
  id: number;
  code: string;
  slug: string;
  display_name: string;
  displacement_cc: number | null;
  fuel: string;
  aspiration: string | null;
  valvetrain: string | null;
  cylinders: number | null;
  bore_mm: string | null;
  stroke_mm: string | null;
  compression: string | null;
};
type Trim = {
  id: number;
  slug: string;
  name: string;
  market_code: string | null;
  engine_id: number | null;
  engine_code: string | null;
  transmission_name: string | null;
  hp: number | null;
  torque_nm: number | null;
  zero_100_kmh_s: string | null;
  top_speed_kmh: number | null;
  fuel_combined_l_100km: string | null;
  co2_g_km: number | null;
  battery_kwh_usable: string | null;
  battery_kwh_total: string | null;
  range_epa_km: number | null;
  range_wltp_km: number | null;
  dc_charge_kw: number | null;
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
};
type FluidSpec = {
  id: number;
  fluid_type: string;
  engine_id: number | null;
  engine_code: string | null;
  engine_display_name: string | null;
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
type TorqueSpec = {
  id: number;
  fastener: string;
  engine_id: number | null;
  torque_nm: number | null;
  torque_ftlb: number | null;
  notes: string | null;
};
type Electrical = {
  battery_group: string | null;
  cca: number | null;
  ah: number | null;
  alternator_amps: number | null;
};
type ServiceInterval = {
  id: number;
  service: string;
  miles_normal: number | null;
  km_normal: number | null;
  months: number | null;
};
type HeroImage = {
  url: string;
  attribution: string | null;
  license: string;
  original_url: string | null;
  caption: string | null;
  width: number | null;
  height: number | null;
};

// ---------- helpers ----------
function yearRange(start: number, end: number | null): string {
  return end ? `${start} – ${end}` : `${start} – present`;
}

function fmtCap(l: string | null, qt: string | null): string {
  if (!l && !qt) return "—";
  if (l && qt) return `${Number(qt).toFixed(1)} qt · ${Number(l).toFixed(1)} L`;
  if (l) return `${Number(l).toFixed(1)} L`;
  return `${Number(qt).toFixed(1)} qt`;
}

// ---------- data ----------
async function getGenerationData(brand: string, generation: string) {
  const make = await queryOne<Make>(
    "SELECT id, slug, name, country_of_origin FROM makes WHERE slug = ? LIMIT 1",
    [brand],
  );
  if (!make) return null;

  const gen = await queryOne<Generation & { model_id: number }>(
    `SELECT g.id, g.model_id, g.slug, g.ordinal, g.codename, g.family_slug, g.family_label, g.display_name,
            g.body_type, g.start_year, g.end_year, g.layout, g.platform,
            g.editorial_intro,
            g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
            g.front_track_mm, g.rear_track_mm, g.fuel_tank_l, g.cargo_l,
            g.front_suspension, g.rear_suspension, g.front_brakes, g.rear_brakes,
            g.oem_manual_url, g.oem_manual_pdf_size_mb, g.oem_manual_year_referenced,
            g.oem_manual_source_id, g.oem_manual_verified_at
     FROM generations g
     JOIN models m ON m.id = g.model_id
     WHERE g.slug = ? AND m.make_id = ?
     LIMIT 1`,
    [generation, make.id],
  );
  if (!gen) return null;

  const model = await queryOne<Model>(
    "SELECT id, make_id, slug, name FROM models WHERE id = ? LIMIT 1",
    [gen.model_id],
  );
  if (!model) return null;

  const markets = await query<Market>(
    `SELECT mk.id, mk.code, mk.name
     FROM markets mk
     JOIN generation_markets gm ON gm.market_id = mk.id
     WHERE gm.generation_id = ?
     ORDER BY FIELD(mk.code, 'US','CA','EU','UK','JDM','AU','RoW')`,
    [gen.id],
  );

  const engines = await query<Engine>(
    `SELECT DISTINCT e.id, e.code, e.slug, e.display_name, e.displacement_cc, e.fuel,
            e.aspiration, e.valvetrain, e.cylinders, e.bore_mm, e.stroke_mm, e.compression
     FROM engines e
     JOIN trims t ON t.engine_id = e.id
     WHERE t.generation_id = ?
     ORDER BY e.displacement_cc ASC`,
    [gen.id],
  );

  const trims = await query<Trim>(
    `SELECT t.id, t.slug, t.name, mk.code AS market_code,
            t.engine_id, e.code AS engine_code,
            tx.display_name AS transmission_name, t.hp, t.torque_nm,
            t.zero_100_kmh_s, t.top_speed_kmh, t.fuel_combined_l_100km,
            t.co2_g_km,
            t.battery_kwh_usable, t.battery_kwh_total, t.range_epa_km, t.range_wltp_km, t.dc_charge_kw,
            t.curb_weight_kg,
            t.max_weight_kg, t.trailer_braked_kg, t.trailer_unbraked_kg,
            t.drive_wheel, t.tire_size, t.rim_size,
            t.length_mm, t.width_mm, t.height_mm, t.wheelbase_mm
     FROM trims t
     LEFT JOIN markets mk        ON mk.id = t.market_id
     LEFT JOIN engines e         ON e.id  = t.engine_id
     LEFT JOIN transmissions tx  ON tx.id = t.transmission_id
     WHERE t.generation_id = ?
     ORDER BY t.hp ASC, t.name`,
    [gen.id],
  );

  // EV gens swap the Fuel/CO₂/Oil comparison columns for Range/Battery/DC kW.
  const genIsEV = trims.some(
    (t) => t.battery_kwh_usable != null || t.range_epa_km != null || t.range_wltp_km != null,
  );

  const fluids = await query<FluidSpec>(
    `SELECT f.id, f.fluid_type, f.engine_id,
            e.code AS engine_code, e.display_name AS engine_display_name,
            f.capacity_l, f.capacity_qt, f.viscosity,
            f.spec_standard, f.filter_part_no, f.drain_interval_mi,
            f.drain_interval_km, f.drain_interval_months, f.notes
     FROM fluid_specs f
     LEFT JOIN engines e ON e.id = f.engine_id
     WHERE f.generation_id = ?
     ORDER BY FIELD(f.fluid_type,'engine_oil','coolant',
                                  'transmission_at','transmission_mt','transmission_cvt','transmission_dct',
                                  'transfer_case','differential_front','differential_rear',
                                  'brake','ps','ac_refrigerant','washer'),
              e.displacement_cc IS NULL, e.displacement_cc ASC, f.id`,
    [gen.id],
  );

  const torques = await query<TorqueSpec>(
    `SELECT t.id, t.fastener, t.engine_id, t.torque_nm, t.torque_ftlb, t.notes
     FROM torque_specs t
     WHERE t.generation_id = ?
     ORDER BY FIELD(t.fastener,'lug_nut','spark_plug','oil_drain','wheel_hub_nut','caliper_bolt')`,
    [gen.id],
  );

  const electrical = await queryOne<Electrical>(
    `SELECT battery_group, cca, ah, alternator_amps
     FROM electrical_specs WHERE generation_id = ? LIMIT 1`,
    [gen.id],
  );

  const bulbCount = await queryOne<{ n: number }>(
    "SELECT COUNT(*) AS n FROM bulbs WHERE generation_id = ?",
    [gen.id],
  );

  const fuseCount = await queryOne<{ n: number }>(
    "SELECT COUNT(*) AS n FROM fuses WHERE generation_id = ?",
    [gen.id],
  );

  const partCount = await queryOne<{ n: number }>(
    "SELECT COUNT(*) AS n FROM parts WHERE generation_id = ?",
    [gen.id],
  );

  const serviceIntervals = await query<ServiceInterval>(
    `SELECT id, service, miles_normal, km_normal, months
     FROM service_intervals
     WHERE generation_id = ?
     ORDER BY COALESCE(miles_normal, miles_severe, 999999)`,
    [gen.id],
  );

  const tireCount = await queryOne<{ n: number }>(
    "SELECT COUNT(*) AS n FROM tire_pressures WHERE generation_id = ?",
    [gen.id],
  );

  const procCount = await queryOne<{ n: number }>(
    "SELECT COUNT(*) AS n FROM procedures WHERE generation_id = ?",
    [gen.id],
  );

  const heroImage = await queryOne<HeroImage>(
    `SELECT url, attribution, license, original_url, caption, width, height
     FROM images
     WHERE generation_id = ?
     ORDER BY (position = '3-4-front') DESC, trim_id IS NULL, id
     LIMIT 1`,
    [gen.id],
  );

  // Other bodystyles of the same model that overlap in production years —
  // herstructureringsplan §3 Niveau 4: "Looking for the Touring? F31 (2012-2015)".
  // Year overlap: their start <= our end (or our end is open) AND their end >= our start.
  const bodystyleSiblings = await query<{
    slug: string;
    codename: string | null;
    display_name: string;
    body_type: string;
    start_year: number;
    end_year: number | null;
  }>(
    `SELECT slug, codename, display_name, body_type, start_year, end_year
     FROM generations
     WHERE model_id = ?
       AND id != ?
       AND body_type != ?
       AND is_active = 1
       AND (? IS NULL OR start_year <= ?)
       AND (end_year IS NULL OR end_year >= ?)
     ORDER BY start_year DESC`,
    [gen.model_id, gen.id, gen.body_type, gen.end_year, gen.end_year, gen.start_year],
  );

  // Family siblings — gens sharing the same chassis platform across body/M
  // variants and pre-LCI/LCI splits. Drives the "related gens" disambiguator
  // and a link to the family umbrella page at /family/<family_slug>.
  const familySiblings = gen.family_slug
    ? await query<FamilySibling>(
        `SELECT g.id, g.slug, g.codename, g.body_type, g.start_year, g.end_year,
                m.slug AS model_slug, m.name AS model_name, mk.slug AS make_slug
         FROM generations g
         JOIN models m ON m.id = g.model_id
         JOIN makes  mk ON mk.id = m.make_id
         WHERE g.family_slug = ? AND g.id != ?
         ORDER BY g.start_year, m.slug, g.body_type`,
        [gen.family_slug, gen.id],
      )
    : [];

  return {
    make,
    model,
    gen,
    genIsEV,
    markets,
    engines,
    trims,
    fluids,
    torques,
    electrical,
    bulbCount: bulbCount?.n ?? 0,
    fuseCount: fuseCount?.n ?? 0,
    partCount: partCount?.n ?? 0,
    tireCount: tireCount?.n ?? 0,
    procCount: procCount?.n ?? 0,
    serviceIntervals,
    heroImage,
    bodystyleSiblings,
    familySiblings,
  };
}

// ---------- Next route ----------
export async function generateStaticParams(): Promise<Params[]> {
  const genRows = await query<{ brand: string; generation: string }>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id`,
  );
  const modelRows = await query<{ brand: string; generation: string }>(
    `SELECT mk.slug AS brand, m.slug AS generation
     FROM models m
     JOIN makes mk ON mk.id = m.make_id
     JOIN generations g ON g.model_id = m.id AND g.is_active = 1
     GROUP BY mk.slug, m.slug`,
  );
  return [...genRows, ...modelRows].map((r) => ({ brand: r.brand, generation: r.generation }));
}

type ModelData = {
  make: { id: number; slug: string; name: string };
  model: { id: number; slug: string; name: string; bio: string | null };
  generations: Array<{
    generation_slug: string;
    display_name: string;
    body_type: string;
    codename: string | null;
    start_year: number;
    end_year: number | null;
    trim_count: number;
    hero_url: string | null;
  }>;
};

async function getModelData(brand: string, modelSlug: string): Promise<ModelData | null> {
  const make = await queryOne<{ id: number; slug: string; name: string }>(
    "SELECT id, slug, name FROM makes WHERE slug = ? LIMIT 1",
    [brand],
  );
  if (!make) return null;
  const model = await queryOne<{ id: number; slug: string; name: string; bio: string | null }>(
    "SELECT id, slug, name, bio FROM models WHERE slug = ? AND make_id = ? LIMIT 1",
    [modelSlug, make.id],
  );
  if (!model) return null;
  const generations = await query<ModelData["generations"][number]>(
    `SELECT g.slug AS generation_slug, g.display_name, g.body_type, g.codename,
            g.start_year, g.end_year,
            (SELECT COUNT(*) FROM trims WHERE generation_id = g.id) AS trim_count,
            (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url
     FROM generations g
     WHERE g.model_id = ? AND g.is_active = 1
     ORDER BY g.start_year DESC`,
    [model.id],
  );
  if (generations.length === 0) return null;
  return { make, model, generations };
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation } = await params;
  const data = await getGenerationData(brand, generation);
  if (data) {
    const { make, gen, heroImage } = data;
    const yrs = yearRange(gen.start_year, gen.end_year);
    const hasManual = !!gen.oem_manual_url;
    return pageMetadata({
      title: hasManual
        ? `${make.name} ${gen.display_name} ${yrs} — Owner's Manual & Specifications`
        : `${make.name} ${gen.display_name} ${yrs} — Specifications`,
      description: hasManual
        ? `Owner's manual PDF and full specifications for the ${gen.display_name} (${make.name}, ${yrs}). Direct link to the official ${make.name} manual plus engine, fluid capacities, maintenance schedule, torque values — cross-verified.`
        : `Full specifications for the ${gen.display_name} (${make.name}, ${yrs}). Engine, performance, dimensions, fluid capacities, maintenance schedule, torque values — cross-verified.`,
      path: `/${make.slug}/${gen.slug}`,
      heroPath: heroImage?.url,
    });
  }
  const modelData = await getModelData(brand, generation);
  if (!modelData) return { title: "Not found" };
  const { make, model, generations } = modelData;
  const earliest = generations[generations.length - 1]?.start_year;
  const latest = generations[0]?.end_year ?? "present";
  return {
    title: `${make.name} ${model.name} — Every generation, fluids, torque, maintenance`,
    description: `Reference for every ${make.name} ${model.name} generation (${earliest ?? "—"}–${latest}). Engine specs, fluid capacities, service intervals, torque values, electrical, procedures. Cross-verified.`,
    alternates: { canonical: `/${make.slug}/${model.slug}` },
  };
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const data = await getGenerationData(brand, generation);
  if (!data) {
    const modelData = await getModelData(brand, generation);
    if (modelData) {
      const { ModelView } = await import("@/components/ModelView");
      return (
        <ModelView
          make={modelData.make}
          model={modelData.model}
          generations={modelData.generations}
        />
      );
    }
    notFound();
  }
  const {
    make,
    model,
    gen,
    genIsEV,
    markets,
    engines,
    trims,
    fluids,
    torques,
    electrical,
    bulbCount,
    fuseCount,
    partCount,
    tireCount,
    procCount,
    serviceIntervals,
    heroImage,
    bodystyleSiblings,
    familySiblings,
  } = data;

  const yrs = yearRange(gen.start_year, gen.end_year);

  // Split fluids into per-engine (engine_id != NULL) and gen-wide (NULL).
  // STRUCTURE.md §data-grain enforcement: engine-scoped fluid types
  // (engine_oil, coolant, transmission_*) MUST NOT render as gen-wide
  // when the gen has more than one engine. A NULL engine_id row on such
  // a type is "provisional" — pending per-engine backfill — and a single
  // displayed number would be wrong for ~75% of trims (the bug that
  // motivated the entire restructure).
  const ENGINE_SCOPED = new Set([
    "engine_oil",
    "coolant",
    "transmission_at",
    "transmission_mt",
    "transmission_cvt",
    "transmission_dct",
  ]);
  // `multiEngine` decides whether engine-scoped fluids can safely render as
  // gen-wide. It fires on three signals because a gen may be multi-engine in
  // reality even when trim→engine wiring is incomplete in the DB:
  //   1) the engines query already returned >1 (clean signal)
  //   2) trims have differing HP values (catalog signal, even with NULL engine_id)
  //   3) any fluid_specs row is already engine-scoped (the gen has been split,
  //      so leftover NULL rows are legacy and must be suppressed)
  const distinctHps = new Set(trims.map((t) => t.hp).filter((h): h is number => h != null));
  const someFluidScoped = fluids.some((f) => f.engine_id != null);
  const multiEngine = engines.length > 1 || distinctHps.size > 1 || someFluidScoped;
  // Per-engine coverage signal: a gen-wide row is only "provisional" if a
  // per-engine row exists for the same fluid_type. Without that, the gen-
  // wide row is the only data we have and IS the chassis-level value
  // (matches the matching change in components/FluidTopicPage.tsx).
  const perEngineCoverage = new Set<string>();
  for (const f of fluids) {
    if (f.engine_id) perEngineCoverage.add(f.fluid_type);
  }
  const fluidsByEngineType = new Map<string, FluidSpec>();
  const fluidsGenWide: FluidSpec[] = [];
  const suppressedTypes = new Set<string>();
  for (const f of fluids) {
    if (f.engine_id) {
      fluidsByEngineType.set(`${f.engine_id}:${f.fluid_type}`, f);
    } else if (
      multiEngine &&
      ENGINE_SCOPED.has(f.fluid_type) &&
      perEngineCoverage.has(f.fluid_type)
    ) {
      suppressedTypes.add(f.fluid_type);
    } else {
      fluidsGenWide.push(f);
    }
  }
  const provisionalSuppressed = suppressedTypes.size;

  // Citation index restricted to the rows we actually render. Per-engine
  // fluids picked up via the variant comparison are referenced through
  // trimFluid; gen-wide fluids via fluidsGenWide; torques + service intervals
  // render directly. Trim rows themselves are cited in the comparison.
  const renderedFluidIds = new Set<number>();
  for (const f of fluidsGenWide) renderedFluidIds.add(f.id);
  for (const f of fluidsByEngineType.values()) renderedFluidIds.add(f.id);
  const citations = await buildCitationIndex(gen.id, [
    ...trims.map((t) => ({ table: "trims" as const, id: t.id })),
    ...[...renderedFluidIds].map((id) => ({ table: "fluid_specs" as const, id })),
    ...torques.map((t) => ({ table: "torque_specs" as const, id: t.id })),
    ...serviceIntervals.map((s) => ({ table: "service_intervals" as const, id: s.id })),
  ]);
  const sources = citations.sources;
  const sourceCount = sources.length;
  const reviewDate = sources
    .map((s) => s.retrieved_at)
    .sort()
    .reverse()[0]
    ?.toString()
    .slice(0, 10);

  const trimFluid = (trimEngineId: number | null, fluidType: string): FluidSpec | undefined => {
    if (!trimEngineId) return undefined;
    return fluidsByEngineType.get(`${trimEngineId}:${fluidType}`);
  };

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a><span className="sep">/</span>
          {gen.family_slug && (
            <>
              <a href={`/family/${gen.family_slug}`}>{gen.family_label || gen.codename + " family"}</a>
              <span className="sep">/</span>
            </>
          )}
          <span>{gen.display_name} · {yrs}</span>
        </nav>

        {familySiblings && familySiblings.length > 0 && (
          <div style={{
            border: "1px solid var(--rule)",
            borderRadius: 8,
            padding: "10px 14px",
            background: "var(--surface-soft, #fafafa)",
            margin: "0 0 18px",
            fontSize: 13,
            display: "flex",
            flexWrap: "wrap",
            alignItems: "center",
            gap: 12,
          }}>
            <strong style={{ fontSize: 12, textTransform: "uppercase", letterSpacing: 0.4, color: "var(--ink-soft)" }}>Related on same chassis</strong>
            {familySiblings.map((s) => (
              <a key={s.id} href={`/${s.make_slug}/${s.slug}`} style={{
                fontSize: 13,
                padding: "2px 8px",
                border: "1px solid var(--rule)",
                borderRadius: 4,
                textDecoration: "none",
                color: "inherit",
                whiteSpace: "nowrap",
              }}>
                {s.codename} {s.body_type} · {s.start_year}{s.end_year ? `–${s.end_year}` : "–present"}
              </a>
            ))}
            {gen.family_slug && (
              <a href={`/family/${gen.family_slug}`} style={{
                fontSize: 13,
                color: "var(--ink-soft)",
                marginLeft: "auto",
              }}>
                Family overview →
              </a>
            )}
          </div>
        )}

        <div className="pagehead">
          <h1>{make.name} {gen.display_name} — {yrs}</h1>
          <div className="sub">
            {gen.ordinal && (<><span>{gen.ordinal}th generation{gen.codename ? ` · codename ${gen.codename}` : ""}</span><span className="pip"></span></>)}
            <span>{gen.body_type[0].toUpperCase() + gen.body_type.slice(1)} · {model.name}</span>
            {gen.layout && (<><span className="pip"></span><span>{gen.layout === "FF" ? "Front-engine, front-wheel-drive" : gen.layout}</span></>)}
            {markets.length > 0 && (<><span className="pip"></span><span>Sold in {markets.map((m) => m.code).join(" · ")}</span></>)}
          </div>
          <div className="verify-badge">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6">
              <path d="m4 8 3 3 5-6" />
              <circle cx="8" cy="8" r="7" />
            </svg>
            <span>{sourceCount > 0 ? `Verified across ${sourceCount} independent ${sourceCount === 1 ? "source" : "sources"}` : "Catalogue data · owner-manual data in progress"}</span>
            <span className="div"></span>
            <span className="meta">Last reviewed {reviewDate}</span>
          </div>
        </div>
      </div>

      <div className="tabs">
        <div className="tabs-inner">
          <a className="tab active" href={`/${make.slug}/${gen.slug}`}>Overview</a>
          {(fluids.some(f => f.fluid_type === "engine_oil") || fluids.some(f => f.fluid_type === "coolant")) && (
            <a className="tab" href={`/${make.slug}/${gen.slug}/${fluids.some(f => f.fluid_type === "engine_oil") ? "oil-capacity" : "coolant"}`}>Fluids <span className="count">{fluids.length}</span></a>
          )}
          {torques.length > 0 && (
            <a className="tab" href={`/${make.slug}/${gen.slug}/torque`}>Torque <span className="count">{torques.length}</span></a>
          )}
          {serviceIntervals.length > 0 && (
            <a className="tab" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>Maintenance <span className="count">{serviceIntervals.length}</span></a>
          )}
          {(electrical || bulbCount > 0 || fuseCount > 0) && (
            <a className="tab" href={`/${make.slug}/${gen.slug}/electrical`}>Electrical <span className="count">{bulbCount + fuseCount + (electrical ? 1 : 0)}</span></a>
          )}
          {procCount > 0 && (
            <a className="tab" href={`/${make.slug}/${gen.slug}/procedures`}>Procedures</a>
          )}
        </div>
      </div>

      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify([
            breadcrumbsJsonLd({ brand: make, model, gen }),
            vehicleJsonLd({ brand: make, model, gen, heroPath: heroImage?.url }),
          ]),
        }}
      />

      <main className="shell">

        {/* INFOBOX */}
        <section style={{ paddingTop: "var(--s-6)" }}>
          <div className="infobox-row">
            <div>
              <div className="ib-photo">
                <div className="frame">
                  {heroImage ? (
                    <img
                      src={heroImage.url}
                      alt={heroImage.caption ?? `${make.name} ${gen.display_name}`}
                      width={heroImage.width ?? 1280}
                      height={heroImage.height ?? 800}
                      style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                        display: "block",
                      }}
                    />
                  ) : (
                    <svg viewBox="0 0 800 600" stroke="rgba(255,255,255,0.75)" fill="none" strokeWidth="1.6">
                      <path d="M90 410c0-32 22-52 58-52h92l72-104c12-19 30-29 56-29h190c26 0 44 10 56 29l72 104h92c36 0 58 20 58 52v52H90z"/>
                      <path d="M325 358l38-66h290l38 66"/>
                      <circle cx="245" cy="462" r="52" fill="rgba(255,255,255,0.06)" />
                      <circle cx="245" cy="462" r="38" />
                      <circle cx="775" cy="462" r="52" fill="rgba(255,255,255,0.06)" />
                      <circle cx="775" cy="462" r="38" />
                    </svg>
                  )}
                </div>
                <div className="caption">
                  <span>{heroImage?.caption ?? `${make.name} ${gen.display_name}`}</span>
                  <span style={{ fontSize: 11, color: "var(--ink-mute)" }}>
                    {heroImage ? (
                      heroImage.original_url ? (
                        <a
                          href={heroImage.original_url}
                          rel="noopener nofollow"
                          target="_blank"
                          style={{ color: "var(--ink-mute)" }}
                        >
                          Photo: {heroImage.attribution}
                        </a>
                      ) : (
                        <>Photo: {heroImage.attribution}</>
                      )
                    ) : (
                      "OEM press"
                    )}
                  </span>
                </div>
              </div>
            </div>

            <div>
              <table className="ib-table">
                <caption>Vehicle identification</caption>
                <tbody>
                  <tr><th>Manufacturer</th><td className="alt">{make.name}</td></tr>
                  <tr><th>Model</th><td className="alt">{model.name}</td></tr>
                  {(gen.ordinal || gen.codename) && (
                    <tr><th>Generation</th><td>{gen.ordinal ? `${gen.ordinal}th${gen.codename ? ` (${gen.codename})` : ""}` : gen.codename}</td></tr>
                  )}
                  <tr><th>Production</th><td>{gen.start_year} – {gen.end_year ?? "present"}</td></tr>
                  <tr><th>Body</th><td className="alt">{gen.body_type}</td></tr>
                  {gen.layout && <tr><th>Layout</th><td>{gen.layout}</td></tr>}
                  {gen.platform && <tr><th>Platform</th><td className="alt">{gen.platform}</td></tr>}
                  {engines.length > 0 && (
                    <tr><th>Engines</th><td>
                      {engines.map((e, i) => (
                        <span key={e.id}>
                          {i > 0 && " · "}
                          <a href={`/engines/${e.slug}`} style={{ color: "var(--accent)" }}>{e.code}</a>
                        </span>
                      ))}
                    </td></tr>
                  )}
                  <tr><th>Markets</th><td>{markets.length > 0 ? markets.map((m) => m.code).join(" · ") : "Global · multi-market"}</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        {gen.oem_manual_url && (
          <section aria-labelledby="oem-manual-h" style={{ marginTop: "var(--s-5)" }}>
            <h2 className="section-h" id="oem-manual-h">Download Owner&apos;s Manual</h2>
            <div className="answer-card" style={{ display: "flex", gap: "var(--s-4)", alignItems: "flex-start", flexWrap: "wrap" }}>
              <div style={{ flex: "1 1 280px", minWidth: 0 }}>
                <p style={{ marginTop: 0, marginBottom: "var(--s-2)" }}>
                  Official PDF, hosted by {make.name}. {gen.oem_manual_year_referenced
                    ? `${gen.oem_manual_year_referenced} model-year edition`
                    : "Manufacturer edition"}{gen.oem_manual_pdf_size_mb ? ` · ${gen.oem_manual_pdf_size_mb} MB` : ""}.
                </p>
                <p style={{ marginTop: 0, marginBottom: 0, color: "var(--ink-2)", fontSize: "var(--fs-1)" }}>
                  This document is the manufacturer&apos;s reference for every fluid capacity, torque value,
                  service interval and warning indicator in the {gen.codename ?? "this"} {model.name}. We link
                  directly to the OEM hosting — nothing is republished here.
                </p>
              </div>
              <a
                href={gen.oem_manual_url}
                target="_blank"
                rel="noopener noreferrer"
                aria-label={`Download ${make.name} ${model.name} owner's manual (PDF)`}
                style={{
                  flex: "0 0 auto",
                  whiteSpace: "nowrap",
                  display: "inline-block",
                  padding: "10px 18px",
                  background: "var(--accent)",
                  color: "#fff",
                  border: "1px solid var(--accent)",
                  textDecoration: "none",
                  fontWeight: 600,
                  fontSize: "14px",
                  letterSpacing: "0.01em",
                }}
              >
                Download PDF ↗
              </a>
            </div>
          </section>
        )}

        {/* EDITORIAL INTRO — herstructureringsplan §3 Niveau 4 #2: per-gen
            E-E-A-T overview (history, market differences, facelift notes).
            Renders only when present so we never publish empty sections.
            Paragraphs split on blank lines so authors can compose multi-para
            text without HTML. */}
        {gen.editorial_intro && (
          <section>
            <h2 className="section-h">About this generation</h2>
            <div style={{ maxWidth: "68ch" }}>
              {gen.editorial_intro.split(/\n\s*\n/).map((p, i) => (
                <p key={i} style={{ marginTop: i === 0 ? 0 : "var(--s-3)" }}>
                  {p.trim()}
                </p>
              ))}
            </div>
          </section>
        )}

        {/* DIMENSIONS & CAPACITIES — herstructureringsplan Fase 1.3: when trims
            disagree on a dimension (e.g. M-package width vs base width, xDrive
            height vs RWD height) render the range and link to the trim page for
            the exact value. Falls back to the gen-level value when all trims
            agree or trim-level data is missing. */}
        {(gen.length_mm || gen.wheelbase_mm || gen.fuel_tank_l) && (() => {
          const dimRange = (
            getter: (t: Trim) => number | null,
            genValue: number | null,
          ): { display: string | null; varies: boolean } => {
            const values = trims
              .map(getter)
              .filter((v): v is number => v != null);
            if (values.length === 0) {
              return { display: genValue != null ? mmDual(genValue) : null, varies: false };
            }
            const min = Math.min(...values);
            const max = Math.max(...values);
            if (min === max) {
              return { display: mmDual(min), varies: false };
            }
            return { display: `${min}–${max} mm`, varies: true };
          };
          const lengthR = dimRange((t) => t.length_mm, gen.length_mm);
          const widthR  = dimRange((t) => t.width_mm,  gen.width_mm);
          const heightR = dimRange((t) => t.height_mm, gen.height_mm);
          const wheelR  = dimRange((t) => t.wheelbase_mm, gen.wheelbase_mm);
          const anyVaries = [lengthR, widthR, heightR, wheelR].some((r) => r.varies);
          const dimCell = (r: { display: string | null; varies: boolean }) =>
            r.display == null ? null : (
              <td>
                {r.display}
                {r.varies && (
                  <span className="muted" style={{ marginLeft: 8, fontSize: 11 }}>
                    varies by trim
                  </span>
                )}
              </td>
            );
          return (
            <section>
              <h2 className="section-h">Dimensions &amp; capacities</h2>
              {anyVaries && (
                <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
                  Some dimensions vary across trims in this generation (option packages,
                  drivetrain, wheel size). See the trim page for the exact value of your variant.
                </p>
              )}
              <table className="spec-table">
                <tbody>
                  {lengthR.display && <tr><th>Length</th>{dimCell(lengthR)}</tr>}
                  {widthR.display  && <tr><th>Width</th>{dimCell(widthR)}</tr>}
                  {heightR.display && <tr><th>Height</th>{dimCell(heightR)}</tr>}
                  {wheelR.display  && <tr><th>Wheelbase</th>{dimCell(wheelR)}</tr>}
                  {gen.front_track_mm && <tr><th>Front track</th><td>{mmDual(gen.front_track_mm)}</td></tr>}
                  {gen.rear_track_mm  && <tr><th>Rear track</th><td>{mmDual(gen.rear_track_mm)}</td></tr>}
                  {gen.fuel_tank_l    && <tr><th>Fuel tank</th><td>{litreDual(gen.fuel_tank_l)}</td></tr>}
                  {gen.cargo_l        && <tr><th>Cargo capacity</th><td>{litreCargoDual(gen.cargo_l)}</td></tr>}
                </tbody>
              </table>
            </section>
          );
        })()}

        {/* DRIVETRAIN & CHASSIS (gen-wide) */}
        {(gen.front_suspension || gen.front_brakes) && (
          <section>
            <h2 className="section-h">Drivetrain &amp; chassis</h2>
            <table className="spec-table">
              <tbody>
                {gen.layout && <tr><th>Layout</th><td>{gen.layout}</td></tr>}
                {gen.front_suspension && <tr><th>Front suspension</th><td>{gen.front_suspension}</td></tr>}
                {gen.rear_suspension && <tr><th>Rear suspension</th><td>{gen.rear_suspension}</td></tr>}
                {gen.front_brakes && <tr><th>Front brakes</th><td>{gen.front_brakes}</td></tr>}
                {gen.rear_brakes && <tr><th>Rear brakes</th><td>{gen.rear_brakes}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

        {/* VARIANT COMPARISON TABLE — STRUCTURE.md §Tier 1 + herstructureringsplan §3 Niveau 4.
            One row per trim with the perf-spec key fields side-by-side. This is the
            "middle-tier SEO machine" — ranked on "{model} {gen-code} specs" queries.
            Plain SSR table for now; filter chips (fuel/trans/drive) can come later
            when data widens past ~15 trims/gen and they actually matter. */}
        {trims.length > 0 ? (
          <section>
            <h2 className="section-h">
              Pick your trim — compare all variants
              <span className="count">{trims.length} {trims.length === 1 ? "trim" : "trims"}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Side-by-side specs for every {gen.display_name} variant. Click a row for
              the full spec sheet (fluids, torques, parts, maintenance) filtered to that
              engine.
            </p>
            <div style={{ overflowX: "auto", border: "1px solid var(--rule)" }}>
              <table className="spec-table" style={{ minWidth: 900, borderCollapse: "collapse", width: "100%", whiteSpace: "nowrap" }}>
                <thead>
                  <tr style={{ background: "var(--bg-alt)", borderBottom: "1px solid var(--rule)" }}>
                    <th style={{ textAlign: "left", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Trim</th>
                    <th style={{ textAlign: "left", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Engine</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Hp</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Torque</th>
                    <th style={{ textAlign: "left", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Trans</th>
                    <th style={{ textAlign: "left", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Drive</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>0-100</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>Top</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>{genIsEV ? "Range" : "Fuel"}</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>{genIsEV ? "Battery" : "CO₂"}</th>
                    <th style={{ textAlign: "right", padding: "10px 12px", fontSize: 11, letterSpacing: "0.06em", textTransform: "uppercase" }}>{genIsEV ? "DC kW" : "Oil"}</th>
                  </tr>
                </thead>
                <tbody>
                  {(() => {
                    // Group trims that share the same base nameplate + engine + hp
                    // (e.g. 335i (306 Hp) manual / Steptronic / xDrive / xDrive
                    // Steptronic) so the table shows ONE header row per
                    // powertrain with sub-rows for each transmission / drive
                    // variant. Avoids the visual "duplicate rows" impression that
                    // Tim flagged 2026-05-22.
                    const baseName = (n: string) =>
                      n
                        .replace(/\s+xDrive\s+Steptronic\s*$/i, "")
                        .replace(/\s+Steptronic\s*$/i, "")
                        .replace(/\s+xDrive\s*$/i, "");
                    const variantSuffix = (n: string, base: string) =>
                      n.slice(base.length).trim() || "Base · manual RWD";
                    // Compact the verbose transmission display_name
                    // ("6 gears, manual transmission" -> "6-spd manual") so the
                    // Trans column doesn't need to hog table width.
                    const compactTrans = (n: string | null) => {
                      if (!n) return "—";
                      const g = n.match(/(\d+)\s*gear/i)?.[1];
                      const ty = /DCT/i.test(n)
                        ? "DCT"
                        : /CVT/i.test(n)
                          ? "CVT"
                          : /manual/i.test(n)
                            ? "manual"
                            : /automatic|auto/i.test(n)
                              ? "auto"
                              : "";
                      return g ? `${g}-spd${ty ? " " + ty : ""}` : ty || n;
                    };
                    type Group = { base: string; rep: Trim; rows: Trim[] };
                    const groups: Group[] = [];
                    const gmap = new Map<string, Group>();
                    for (const t of trims) {
                      const key = `${baseName(t.name)}|${t.hp ?? ""}|${t.engine_code ?? ""}`;
                      let g = gmap.get(key);
                      if (!g) {
                        g = { base: baseName(t.name), rep: t, rows: [] };
                        gmap.set(key, g);
                        groups.push(g);
                      }
                      g.rows.push(t);
                    }
                    return groups.map((g, gi) => {
                      const oilFluid = trimFluid(g.rep.engine_id, "engine_oil");
                      const oilCap = oilFluid
                        ? fmtCap(oilFluid.capacity_l, oilFluid.capacity_qt)
                        : "—";
                      if (g.rows.length === 1) {
                        const t = g.rows[0];
                        return (
                          <tr key={`g-${gi}`} style={{ borderBottom: "1px solid var(--rule)" }}>
                            <td style={{ padding: "10px 12px", fontWeight: 600 }}>
                              <a href={`/${make.slug}/${gen.slug}/${t.slug}`} style={{ color: "var(--accent)" }}>
                                {t.name}
                              </a>
                            </td>
                            <td style={{ padding: "10px 12px", fontFamily: '"IBM Plex Mono", monospace', fontSize: 12 }}>{t.engine_code ?? "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.hp ?? "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.torque_nm ? `${t.torque_nm} N·m` : "—"}</td>
                            <td style={{ padding: "10px 12px", fontSize: 12 }}>{compactTrans(t.transmission_name)}</td>
                            <td style={{ padding: "10px 12px", fontSize: 12 }}>{t.drive_wheel ?? "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.zero_100_kmh_s ? `${t.zero_100_kmh_s} s` : "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.top_speed_kmh ? `${t.top_speed_kmh} km/h` : "—"}</td>
                            {genIsEV ? (
                              <>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{(t.range_epa_km ?? t.range_wltp_km) ? `${t.range_epa_km ?? t.range_wltp_km} km` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{(t.battery_kwh_usable ?? t.battery_kwh_total) ? `${t.battery_kwh_usable ?? t.battery_kwh_total} kWh` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 12 }}>{t.dc_charge_kw ? `${t.dc_charge_kw} kW` : "—"}</td>
                              </>
                            ) : (
                              <>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.fuel_combined_l_100km ? `${t.fuel_combined_l_100km} L/100` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{t.co2_g_km ? `${t.co2_g_km} g/km` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 12 }}>{oilCap}</td>
                              </>
                            )}
                          </tr>
                        );
                      }
                      // Multi-variant group: header row + sub-rows
                      const rep = g.rep;
                      return (
                        <Fragment key={`g-${gi}`}>
                          <tr style={{ borderTop: gi === 0 ? "none" : "2px solid var(--rule)", borderBottom: "1px solid var(--rule)", background: "var(--bg-alt)" }}>
                            <td style={{ padding: "10px 12px", fontWeight: 600 }}>
                              {g.base}
                              <span className="muted" style={{ marginLeft: 8, fontSize: 11, fontWeight: 400 }}>
                                — {g.rows.length} variants
                              </span>
                            </td>
                            <td style={{ padding: "10px 12px", fontFamily: '"IBM Plex Mono", monospace', fontSize: 12 }}>{rep.engine_code ?? "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{rep.hp ?? "—"}</td>
                            <td style={{ padding: "10px 12px", textAlign: "right" }}>{rep.torque_nm ? `${rep.torque_nm} N·m` : "—"}</td>
                            <td colSpan={4} style={{ padding: "10px 12px", fontSize: 11, color: "var(--ink-mute)" }}>
                              variants below ↓
                            </td>
                            {genIsEV ? (
                              <>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{(rep.range_epa_km ?? rep.range_wltp_km) ? `${rep.range_epa_km ?? rep.range_wltp_km} km` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{(rep.battery_kwh_usable ?? rep.battery_kwh_total) ? `${rep.battery_kwh_usable ?? rep.battery_kwh_total} kWh` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 12 }}>{rep.dc_charge_kw ? `${rep.dc_charge_kw} kW` : "—"}</td>
                              </>
                            ) : (
                              <>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{rep.fuel_combined_l_100km ? `${rep.fuel_combined_l_100km} L/100` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right" }}>{rep.co2_g_km ? `${rep.co2_g_km} g/km` : "—"}</td>
                                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 12 }}>{oilCap}</td>
                              </>
                            )}
                          </tr>
                          {g.rows.map((t) => (
                            <tr key={`v-${t.id}`} style={{ borderBottom: "1px solid var(--rule)" }}>
                              <td style={{ padding: "8px 12px 8px 28px", fontSize: 13 }}>
                                <a href={`/${make.slug}/${gen.slug}/${t.slug}`} style={{ color: "var(--accent)" }}>
                                  ↳ {variantSuffix(t.name, g.base)}
                                </a>
                              </td>
                              <td colSpan={3}></td>
                              <td style={{ padding: "8px 12px", fontSize: 12 }}>{compactTrans(t.transmission_name)}</td>
                              <td style={{ padding: "8px 12px", fontSize: 12 }}>{t.drive_wheel ?? "—"}</td>
                              <td style={{ padding: "8px 12px", textAlign: "right" }}>{t.zero_100_kmh_s ? `${t.zero_100_kmh_s} s` : "—"}</td>
                              <td style={{ padding: "8px 12px", textAlign: "right" }}>{t.top_speed_kmh ? `${t.top_speed_kmh} km/h` : "—"}</td>
                              <td colSpan={3}></td>
                            </tr>
                          ))}
                        </Fragment>
                      );
                    });
                  })()}
                </tbody>
              </table>
            </div>
          </section>
        ) : null}

        {/* AVAILABLE ENGINES — catalogue listing (no spec values; trim
            pages own those). Each row links to the gen-spanning engine
            catalogue page at /engines/{code}. */}
        {engines.length > 0 && (
          <section>
            <h2 className="section-h">
              Available engines
              <span className="count">{engines.length}</span>
            </h2>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                border: "1px solid var(--rule)",
              }}
            >
              {engines.map((e) => {
                return (
                  <li key={e.id} style={{ borderBottom: "1px solid var(--rule)" }}>
                    <a
                      href={`/engines/${e.slug}`}
                      style={{
                        display: "grid",
                        gridTemplateColumns: "140px 1fr auto",
                        gap: 16,
                        alignItems: "center",
                        padding: "10px 16px",
                        color: "var(--ink)",
                      }}
                    >
                      <span style={{ fontFamily: '"IBM Plex Mono", monospace', fontWeight: 600, color: "var(--accent)" }}>
                        {e.code}
                      </span>
                      <span>
                        <span style={{ fontSize: 13 }}>{e.display_name}</span>
                        <span className="muted" style={{ fontSize: 12, marginLeft: 8 }}>
                          {[
                            e.displacement_cc ? `${(e.displacement_cc / 1000).toFixed(1)} L` : null,
                            e.cylinders ? `${e.cylinders}-cyl` : null,
                            e.fuel,
                            e.aspiration && e.aspiration !== "NA" ? e.aspiration : null,
                          ].filter(Boolean).join(" · ")}
                        </span>
                      </span>
                      <span className="muted" style={{ fontSize: 12 }}>→ Engine catalogue</span>
                    </a>
                  </li>
                );
              })}
            </ul>
          </section>
        )}

        {/* GEN-WIDE FLUIDS — only those that genuinely apply to every engine
            (brake, AC refrigerant, washer, etc.). Per-engine fluids live in
            the variant comparison table above and on each trim's deep page. */}
        {fluidsGenWide.length > 0 && (
          <section>
            <h2 className="section-h">
              Gen-wide fluids
              <span className="count">{fluidsGenWide.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Same value across every engine in this generation. Engine-specific fluids
              (oil, coolant, transmission) are shown per trim in the comparison above and
              on each trim&apos;s page.
            </p>
            <table className="spec-table">
              <tbody>
                {fluidsGenWide.map((f) => {
                  const cap = fmtCap(f.capacity_l, f.capacity_qt);
                  const grade = [f.viscosity, f.spec_standard].filter(Boolean).join(" · ");
                  return (
                    <tr key={f.id}>
                      <th>{fluidLabel(f.fluid_type)}</th>
                      <td>
                        {cap}{grade ? ` · ${grade}` : ""}
                        {f.filter_part_no && <span className="alt"> · filter {f.filter_part_no}</span>}
                        <Cites nums={citations.citationsFor("fluid_specs", f.id)} />
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </section>
        )}

        {/* MOAT GRID — Tier 2 topic page links */}
        <section>
          <h2 className="section-h">
            Owner-manual data
            <span className="count">
              {fluids.length + torques.length + bulbCount + fuseCount + partCount + serviceIntervals.length + 1} entries · cross-verified
            </span>
          </h2>
          <div className="moat-list">
            {/* Tile suppression mirrors each topic page's own notFound() guard,
               so we never link from the gen hub to a topic that would 404. */}
            {fluids.some(f => f.fluid_type === "engine_oil") ? (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/oil-capacity`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M10 2v5m0 0c-2.5 1.5-4 4-4 6.5a4 4 0 0 0 8 0c0-2.5-1.5-5-4-6.5z" />
                </svg>
                <span>
                  <span className="name">Engine oil — capacity, viscosity, spec, filter</span>
                  <span className="peek">Per-engine comparison across all {engines.length} engines</span>
                </span>
                <span className="arrow">→</span>
              </a>
            ) : fluids.some(f => f.fluid_type === "coolant") ? (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/coolant`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M10 2v5m0 0c-2.5 1.5-4 4-4 6.5a4 4 0 0 0 8 0c0-2.5-1.5-5-4-6.5z" />
                </svg>
                <span>
                  <span className="name">HV battery + motor coolant — capacity, spec, change interval</span>
                  <span className="peek">Long-life coolant for the high-voltage system (no engine oil on this BEV)</span>
                </span>
                <span className="arrow">→</span>
              </a>
            ) : null}
            {fluids.some(f => f.fluid_type === "coolant") && fluids.some(f => f.fluid_type === "engine_oil") && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/coolant`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="6"/><path d="M10 4v12"/></svg>
                <span>
                  <span className="name">Coolant — capacity, formula, drain interval</span>
                  <span className="peek">Per-engine system size and OEM-approved coolant standard</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {serviceIntervals.length > 0 && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><path d="M10 6v4l3 2" /></svg>
                <span>
                  <span className="name">Maintenance schedule</span>
                  <span className="peek">{serviceIntervals.length} services · normal &amp; severe duty</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {torques.length > 0 && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/torque`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="2.5" /><path d="M10 2v3M10 15v3M2 10h3M15 10h3" /></svg>
                <span>
                  <span className="name">Torque specifications</span>
                  <span className="peek">{torques.length} fasteners · per-engine where applicable</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {tireCount > 0 && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/tires`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><circle cx="10" cy="10" r="3" /></svg>
                <span>
                  <span className="name">Tires &amp; pressures</span>
                  <span className="peek">OE tire size · placard PSI · bolt pattern</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {(electrical || bulbCount > 0 || fuseCount > 0) && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/electrical`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="7" width="14" height="8" /><path d="M6 7V5m8 2V5m-4 5v2" /></svg>
                <span>
                  <span className="name">Battery, bulbs &amp; fuses</span>
                  <span className="peek">{electrical?.battery_group ? `Group ${electrical.battery_group} · ` : ""}{bulbCount} bulbs · {fuseCount} fuses</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {partCount > 0 && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/parts`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="3" /><path d="M10 1v3M10 16v3M1 10h3M16 10h3M4 4l1.5 1.5M14.5 14.5 16 16M16 4l-1.5 1.5M5.5 14.5 4 16" /></svg>
                <span>
                  <span className="name">Service parts &amp; consumables</span>
                  <span className="peek">{partCount} parts · wiper, filter &amp; OE part numbers</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
            {procCount > 0 && (
              <a className="moat-row" href={`/${make.slug}/${gen.slug}/procedures`}>
                <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M3 5h14M3 10h14M3 15h9" /></svg>
                <span>
                  <span className="name">Service procedures</span>
                  <span className="peek">Oil reset · TPMS · battery · jump-start</span>
                </span>
                <span className="arrow">→</span>
              </a>
            )}
          </div>
        </section>

        {/* SOURCES — numbered, referenced by [n] footnotes throughout */}
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

        {/* BODYSTYLE SIBLINGS — herstructureringsplan §3 Niveau 4: "Looking for the
            Touring? F31 (2012-2015)". Other generations of the same model that
            overlap in production years with a different body type. Distinct from
            NameplateRail (which lists all generations across time) — this targets
            the visitor who is on the wrong bodystyle of the right era. */}
        {bodystyleSiblings.length > 0 && (
          <section style={{ marginTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Looking for a different body style?
              <span className="count">{bodystyleSiblings.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Same era of the {model.name} in another body type.
            </p>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))",
                gap: 0,
                border: "1px solid var(--rule)",
              }}
            >
              {bodystyleSiblings.map((b) => {
                const byrs = b.end_year
                  ? `${b.start_year}–${b.end_year}`
                  : `${b.start_year}–present`;
                return (
                  <li
                    key={b.slug}
                    style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}
                  >
                    <a
                      href={`/${make.slug}/${b.slug}`}
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
                        {b.body_type}{b.codename ? ` · ${b.codename}` : ""}
                      </div>
                      <div style={{ fontWeight: 500 }}>{b.display_name}</div>
                      <div
                        style={{
                          fontFamily: "var(--font-mono)",
                          fontSize: 11,
                          color: "var(--ink-mute)",
                        }}
                      >
                        {byrs}
                      </div>
                    </a>
                  </li>
                );
              })}
            </ul>
          </section>
        )}

        <NameplateRail
          modelId={model.id}
          makeSlug={make.slug}
          currentGenSlug={gen.slug}
          makeName={make.name}
          modelName={model.name}
        />
      </main>

      <SiteFooter reviewDate={reviewDate} />
    </>
  );
}
