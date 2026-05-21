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
  display_name: string;
  body_type: string;
  start_year: number;
  end_year: number | null;
  layout: string | null;
  platform: string | null;
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
};
type Market = { id: number; code: string; name: string };
type Engine = {
  id: number;
  code: string;
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
  curb_weight_kg: number | null;
  max_weight_kg: number | null;
  trailer_braked_kg: number | null;
  trailer_unbraked_kg: number | null;
  drive_wheel: string | null;
  tire_size: string | null;
  rim_size: string | null;
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
    `SELECT g.id, g.model_id, g.slug, g.ordinal, g.codename, g.display_name,
            g.body_type, g.start_year, g.end_year, g.layout, g.platform,
            g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
            g.front_track_mm, g.rear_track_mm, g.fuel_tank_l, g.cargo_l,
            g.front_suspension, g.rear_suspension, g.front_brakes, g.rear_brakes
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
    `SELECT DISTINCT e.id, e.code, e.display_name, e.displacement_cc, e.fuel,
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
            t.co2_g_km, t.curb_weight_kg,
            t.max_weight_kg, t.trailer_braked_kg, t.trailer_unbraked_kg,
            t.drive_wheel, t.tire_size, t.rim_size
     FROM trims t
     LEFT JOIN markets mk        ON mk.id = t.market_id
     LEFT JOIN engines e         ON e.id  = t.engine_id
     LEFT JOIN transmissions tx  ON tx.id = t.transmission_id
     WHERE t.generation_id = ?
     ORDER BY t.hp ASC, t.name`,
    [gen.id],
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

  const heroImage = await queryOne<HeroImage>(
    `SELECT url, attribution, license, original_url, caption, width, height
     FROM images
     WHERE generation_id = ?
     ORDER BY (position = '3-4-front') DESC, trim_id IS NULL, id
     LIMIT 1`,
    [gen.id],
  );

  return {
    make,
    model,
    gen,
    markets,
    engines,
    trims,
    fluids,
    torques,
    electrical,
    bulbCount: bulbCount?.n ?? 0,
    fuseCount: fuseCount?.n ?? 0,
    partCount: partCount?.n ?? 0,
    serviceIntervals,
    heroImage,
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
  model: { id: number; slug: string; name: string };
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
  const model = await queryOne<{ id: number; slug: string; name: string }>(
    "SELECT id, slug, name FROM models WHERE slug = ? AND make_id = ? LIMIT 1",
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
    return pageMetadata({
      title: `${make.name} ${gen.display_name} ${yrs} — Specifications`,
      description: `Full specifications for the ${gen.display_name} (${make.name}, ${yrs}). Engine, performance, dimensions, fluid capacities, maintenance schedule, torque values — cross-verified.`,
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
    markets,
    engines,
    trims,
    fluids,
    torques,
    electrical,
    bulbCount,
    fuseCount,
    partCount,
    serviceIntervals,
    heroImage,
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
  const fluidsByEngineType = new Map<string, FluidSpec>();
  const fluidsGenWide: FluidSpec[] = [];
  const suppressedTypes = new Set<string>();
  for (const f of fluids) {
    if (f.engine_id) {
      fluidsByEngineType.set(`${f.engine_id}:${f.fluid_type}`, f);
    } else if (multiEngine && ENGINE_SCOPED.has(f.fluid_type)) {
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
          <span>{gen.display_name} · {yrs}</span>
        </nav>

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
            <span>Verified across {sourceCount} independent {sourceCount === 1 ? "source" : "sources"}</span>
            <span className="div"></span>
            <span className="meta">Last reviewed {reviewDate}</span>
          </div>
        </div>
      </div>

      <div className="tabs">
        <div className="tabs-inner">
          <a className="tab active" href={`/${make.slug}/${gen.slug}`}>Overview</a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/oil-capacity`}>Fluids <span className="count">{fluids.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/torque`}>Torque <span className="count">{torques.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>Maintenance <span className="count">{serviceIntervals.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/electrical`}>Electrical <span className="count">{bulbCount + fuseCount + 1}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/procedures`}>Procedures</a>
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
                      {engines.map((e, i) => {
                        const slug = e.code.replace(/[\s/]/g, "-").replace(/[^a-zA-Z0-9-]/g, "").replace(/-+/g, "-").toLowerCase();
                        return (
                          <span key={e.id}>
                            {i > 0 && " · "}
                            <a href={`/engines/${slug}`} style={{ color: "var(--accent)" }}>{e.code}</a>
                          </span>
                        );
                      })}
                    </td></tr>
                  )}
                  <tr><th>Markets</th><td>{markets.length > 0 ? markets.map((m) => m.code).join(" · ") : "Global · multi-market"}</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        {/* DIMENSIONS & CAPACITIES (gen-wide only) */}
        {(gen.length_mm || gen.wheelbase_mm || gen.fuel_tank_l) && (
          <section>
            <h2 className="section-h">Dimensions &amp; capacities</h2>
            <table className="spec-table">
              <tbody>
                {gen.length_mm && <tr><th>Length</th><td>{mmDual(gen.length_mm)}</td></tr>}
                {gen.width_mm && <tr><th>Width</th><td>{mmDual(gen.width_mm)}</td></tr>}
                {gen.height_mm && <tr><th>Height</th><td>{mmDual(gen.height_mm)}</td></tr>}
                {gen.wheelbase_mm && <tr><th>Wheelbase</th><td>{mmDual(gen.wheelbase_mm)}</td></tr>}
                {gen.front_track_mm && <tr><th>Front track</th><td>{mmDual(gen.front_track_mm)}</td></tr>}
                {gen.rear_track_mm && <tr><th>Rear track</th><td>{mmDual(gen.rear_track_mm)}</td></tr>}
                {gen.fuel_tank_l && <tr><th>Fuel tank</th><td>{litreDual(gen.fuel_tank_l)}</td></tr>}
                {gen.cargo_l && <tr><th>Cargo capacity</th><td>{litreCargoDual(gen.cargo_l)}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

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

        {/* TRIM GRID — primary "pick your car" affordance. The gen overview
            no longer renders per-trim data inline; each trim's full spec
            sheet (fluids, torques, parts, maintenance) lives on its own
            page. This is the IA pattern competitors use and matches owner
            search intent — visitors arrive looking for THEIR trim. */}
        {trims.length > 0 ? (
          <section>
            <h2 className="section-h">
              Pick your trim
              <span className="count">{trims.length} {trims.length === 1 ? "trim" : "trims"}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Each trim has its own page with full fluids, torque values,
              parts numbers and a maintenance schedule filtered to that
              engine. No data from other trims — you only see what applies
              to your car.
            </p>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
                gap: 0,
                border: "1px solid var(--rule)",
              }}
            >
              {trims.map((t) => (
                <li key={t.id} style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}>
                  <a
                    href={`/${make.slug}/${gen.slug}/${t.slug}`}
                    style={{ display: "block", padding: "12px 16px", color: "var(--ink)" }}
                  >
                    <div style={{ fontSize: 14, fontWeight: 600 }}>{t.name}</div>
                    <div className="muted" style={{ fontSize: 12, marginTop: 2 }}>
                      {[t.engine_code, t.transmission_name, t.hp ? `${t.hp} Hp` : null, t.drive_wheel]
                        .filter(Boolean).join(" · ")}
                    </div>
                  </a>
                </li>
              ))}
            </ul>
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
                const slug = e.code.replace(/[\s/]/g, "-").replace(/[^a-zA-Z0-9-]/g, "").replace(/-+/g, "-").toLowerCase();
                return (
                  <li key={e.id} style={{ borderBottom: "1px solid var(--rule)" }}>
                    <a
                      href={`/engines/${slug}`}
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
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/coolant`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="6"/><path d="M10 4v12"/></svg>
              <span>
                <span className="name">Coolant — capacity, formula, drain interval</span>
                <span className="peek">Per-engine system size and OEM-approved coolant standard</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><path d="M10 6v4l3 2" /></svg>
              <span>
                <span className="name">Maintenance schedule</span>
                <span className="peek">{serviceIntervals.length} services · normal &amp; severe duty</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/torque`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="2.5" /><path d="M10 2v3M10 15v3M2 10h3M15 10h3" /></svg>
              <span>
                <span className="name">Torque specifications</span>
                <span className="peek">{torques.length} fasteners · per-engine where applicable</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/tires`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><circle cx="10" cy="10" r="3" /></svg>
              <span>
                <span className="name">Tires &amp; pressures</span>
                <span className="peek">OE tire size · placard PSI · bolt pattern</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/electrical`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="7" width="14" height="8" /><path d="M6 7V5m8 2V5m-4 5v2" /></svg>
              <span>
                <span className="name">Battery, bulbs &amp; fuses</span>
                <span className="peek">{electrical?.battery_group ? `Group ${electrical.battery_group} · ` : ""}{bulbCount} bulbs · {fuseCount} fuses</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/procedures`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M3 5h14M3 10h14M3 15h9" /></svg>
              <span>
                <span className="name">Service procedures</span>
                <span className="peek">Oil reset · TPMS · battery · jump-start</span>
              </span>
              <span className="arrow">→</span>
            </a>
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
                    {s.url ? (
                      <a href={s.url} rel="noopener nofollow" target="_blank">{s.citation}</a>
                    ) : s.citation}
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
