import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { getGenerationSources } from "@/lib/generation";
import { NameplateRail } from "@/components/NameplateRail";
import {
  mmDual,
  kgDual,
  kgRangeDual,
  litreDual,
  litreCargoDual,
  consumptionDual,
  speedDual,
  boreStrokeDual,
  displacementDual,
} from "@/lib/units";
import { fluidLabel, torqueLabel, serviceLabel } from "@/lib/labels";
import { pageMetadata, breadcrumbsJsonLd, vehicleJsonLd } from "@/lib/seo";

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
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
  drain_interval_mi: number | null;
  drain_interval_km: number | null;
  drain_interval_months: number | null;
  notes: string | null;
  source_count: number;
};
type TorqueSpec = {
  id: number;
  fastener: string;
  torque_nm: number | null;
  torque_ftlb: number | null;
  notes: string | null;
  source_count: number;
};
type Electrical = {
  battery_group: string | null;
  cca: number | null;
  ah: number | null;
  alternator_amps: number | null;
};
type ServiceInterval = {
  service: string;
  miles_normal: number | null;
  km_normal: number | null;
  months: number | null;
};
type SourceRow = {
  id: number;
  type: string;
  citation: string;
  url: string | null;
  retrieved_at: string;
  notes: string | null;
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

// fluidLabel, torqueLabel, serviceLabel are imported from @/lib/labels

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
     ORDER BY e.displacement_cc DESC`,
    [gen.id],
  );

  const trims = await query<Trim>(
    `SELECT t.id, t.slug, t.name, mk.code AS market_code, e.code AS engine_code,
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
     ORDER BY t.hp DESC, t.name`,
    [gen.id],
  );

  // source_count counts DISTINCT PUBLIC sources only (is_public=1).
  // Internal cross-verification sources (auto_data, ultimatespecs, haynespro)
  // are kept in spec_sources for audit but never rendered, so they must
  // not inflate the citation badge — otherwise a row with 1 visible
  // source displayed as [1][2]...[11].
  const fluids = await query<FluidSpec>(
    `SELECT f.id, f.fluid_type, f.capacity_l, f.capacity_qt, f.viscosity,
            f.spec_standard, f.filter_part_no, f.drain_interval_mi,
            f.drain_interval_km, f.drain_interval_months, f.notes,
            (SELECT COUNT(DISTINCT ss.source_id)
               FROM spec_sources ss JOIN sources s ON s.id = ss.source_id
               WHERE ss.spec_table='fluid_specs' AND ss.spec_id=f.id AND s.is_public=1) AS source_count
     FROM fluid_specs f
     WHERE f.generation_id = ?
     ORDER BY FIELD(f.fluid_type,'engine_oil','engine_oil_2_0','engine_oil_1_0t','engine_oil_diesel',
                                  'transmission_cvt','transmission_mt','coolant','brake','ps',
                                  'ac_refrigerant','washer')`,
    [gen.id],
  );

  const torques = await query<TorqueSpec>(
    `SELECT t.id, t.fastener, t.torque_nm, t.torque_ftlb, t.notes,
            (SELECT COUNT(DISTINCT ss.source_id)
               FROM spec_sources ss JOIN sources s ON s.id = ss.source_id
               WHERE ss.spec_table='torque_specs' AND ss.spec_id=t.id AND s.is_public=1) AS source_count
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
    `SELECT service, miles_normal, km_normal, months
     FROM service_intervals
     WHERE generation_id = ?
     ORDER BY COALESCE(miles_normal, miles_severe, 999999)`,
    [gen.id],
  );

  // Hero image — prefer 3/4-front for this generation; trim-specific if available,
  // else generation-level. NULL if no image yet (page falls back to SVG silhouette).
  const heroImage = await queryOne<HeroImage>(
    `SELECT url, attribution, license, original_url, caption, width, height
     FROM images
     WHERE generation_id = ?
     ORDER BY (position = '3-4-front') DESC, trim_id IS NULL, id
     LIMIT 1`,
    [gen.id],
  );

  // PUBLIC SOURCES ONLY — internal cross-verification sources (auto_data,
  // ultimatespecs, haynespro) are kept in the DB for provenance but filtered
  // out of the rendered Sources block. See sources.is_public.
  const sources = await getGenerationSources(gen.id);

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
    sources,
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
  // Also emit a static param for every (brand, model) pair so that the
  // model-index page (e.g. /honda/civic) is prerendered.
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
  // Fall through to model-index metadata
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
    // Maybe it's a model slug, not a generation slug
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
    sources,
    heroImage,
  } = data;

  const yrs = yearRange(gen.start_year, gen.end_year);
  const sourceCount = sources.length;
  const reviewDate = sources
    .map((s) => s.retrieved_at)
    .sort()
    .reverse()[0]
    ?.toString()
    .slice(0, 10);

  // Top-line key numbers for the moat-row peeks
  const oil = fluids.find((f) => f.fluid_type === "engine_oil");
  const cvt = fluids.find((f) => f.fluid_type === "transmission_cvt");
  const coolant = fluids.find((f) => f.fluid_type === "coolant");
  const lug = torques.find((t) => t.fastener === "lug_nut");
  const oilService = serviceIntervals.find((s) => s.service === "engine_oil_and_filter");

  return (
    <>
      <header className="site-header">
        <div className="site-header-inner">
          <a href="/" className="wordmark">ownerspecs</a>
          <nav className="nav-primary">
            <a href="/" className="active">Catalogue</a>
            <a href="/#owner-manual-data">Maintenance</a>
            <a href="/#owner-manual-data">Fluids</a>
            <a href="/compare">Compare</a>
            <a href="/#methodology">Methodology</a>
          </nav>
          <div className="search-bar">
            <svg width="13" height="13" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6">
              <circle cx="7" cy="7" r="5" />
              <path d="m11 11 3 3" />
            </svg>
            <input placeholder="Make, model, VIN or part number" />
            <span className="kbd">⌘ K</span>
          </div>
        </div>
      </header>

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
          <a className="tab" href={`/${make.slug}/${gen.slug}#specifications`}>Specifications <span className="count">{engines.length * 6 + 14}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>Maintenance <span className="count">{serviceIntervals.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/oil-capacity`}>Fluids <span className="count">{fluids.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/torque`}>Torque <span className="count">{torques.length}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/electrical`}>Electrical <span className="count">{bulbCount + fuseCount + 1}</span></a>
          <a className="tab" href={`/${make.slug}/${gen.slug}/procedures`}>Procedures</a>
          <a className="tab" href="/compare">Compare</a>
        </div>
      </div>

      {/* JSON-LD: Vehicle + BreadcrumbList for SERP rich-results */}
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
                  <tr><th>Generation</th><td>{gen.ordinal ? `${gen.ordinal}th (${gen.codename ?? "—"})` : gen.codename}</td></tr>
                  <tr><th>Production</th><td>{gen.start_year} – {gen.end_year ?? "present"}</td></tr>
                  <tr><th>Body</th><td className="alt">{gen.body_type}</td></tr>
                  <tr><th>Layout</th><td>{gen.layout}</td></tr>
                  {gen.platform && <tr><th>Platform</th><td className="alt">{gen.platform}</td></tr>}
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
                  <tr><th>Trims (US)</th><td className="alt">{trims.map((t) => t.name).join(" · ")}</td></tr>
                  <tr><th>Markets</th><td>{markets.length > 0 ? markets.map((m) => m.code).join(" · ") : "Global · multi-market"}</td></tr>
                  {gen.wheelbase_mm && <tr><th>Wheelbase</th><td>{mmDual(gen.wheelbase_mm)}</td></tr>}
                  {gen.length_mm && <tr><th>Length</th><td>{mmDual(gen.length_mm)}</td></tr>}
                  {gen.width_mm && <tr><th>Width</th><td>{mmDual(gen.width_mm)}</td></tr>}
                  {gen.height_mm && <tr><th>Height</th><td>{mmDual(gen.height_mm)}</td></tr>}
                  {trims.length > 0 && trims.some(t => t.curb_weight_kg) && (
                    <tr><th>Curb weight</th><td>
                      {(() => {
                        const ws = trims.map(t => t.curb_weight_kg).filter((w): w is number => w !== null);
                        if (ws.length === 0) return "—";
                        const min = Math.min(...ws), max = Math.max(...ws);
                        return kgRangeDual(min, max);
                      })()}
                    </td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </section>

        {/* ENGINE SPECS */}
        {engines.map((e) => {
          const slug = e.code.replace(/[\s/]/g, "-").replace(/[^a-zA-Z0-9-]/g, "").replace(/-+/g, "-").toLowerCase();
          return (
          <section key={e.id} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Engine — {e.display_name} (<a href={`/engines/${slug}`} style={{ color: "var(--accent)" }}>{e.code}</a>)
              <span className="count">{trims.filter((t) => t.engine_code === e.code).map((t) => t.name).join(" · ") || "—"}</span>
            </h2>
            <table className="spec-table">
              <tbody>
                <tr><th>Displacement</th><td>{displacementDual(e.displacement_cc)}</td></tr>
                {e.bore_mm && e.stroke_mm && <tr><th>Bore × stroke</th><td>{boreStrokeDual(e.bore_mm, e.stroke_mm)}</td></tr>}
                {e.compression && <tr><th>Compression ratio</th><td>{e.compression} : 1</td></tr>}
                {e.aspiration && <tr><th>Aspiration</th><td>{e.aspiration}</td></tr>}
                {e.valvetrain && <tr><th>Valvetrain</th><td>{e.valvetrain}</td></tr>}
                {e.cylinders && <tr><th>Cylinders</th><td>{e.cylinders} · {e.fuel}</td></tr>}
              </tbody>
            </table>
          </section>
          );
        })}

        {/* DIMENSIONS & CAPACITIES */}
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

        {/* DRIVETRAIN & CHASSIS */}
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

        {/* TRIM PERFORMANCE TABLE */}
        <section>
          <h2 className="section-h">Trims &amp; performance <span className="count">{trims.length} trims</span></h2>
          <div className="table-scroll">
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Trim</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Engine</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Transmission</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>HP</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Nm</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>0-100</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Top</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Fuel</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Weight</th>
                <th style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>Drive</th>
              </tr>
            </thead>
            <tbody>
              {trims.map((t) => (
                <tr key={t.id}>
                  <th><strong style={{ color: "var(--ink)" }}>{t.name}</strong></th>
                  <td>{t.engine_code}</td>
                  <td>{t.transmission_name}</td>
                  <td>{t.hp} hp</td>
                  <td>{t.torque_nm} Nm</td>
                  <td>{t.zero_100_kmh_s ? `${Number(t.zero_100_kmh_s).toFixed(1)} s` : "—"}</td>
                  <td>{t.top_speed_kmh ? speedDual(t.top_speed_kmh) : "—"}</td>
                  <td>{t.fuel_combined_l_100km ? consumptionDual(t.fuel_combined_l_100km) : "—"}</td>
                  <td>{t.curb_weight_kg ? kgDual(t.curb_weight_kg) : "—"}</td>
                  <td>{t.drive_wheel ?? "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
          </div>
        </section>

        {/* FLUIDS */}
        <section>
          <h2 className="section-h">Fluid capacities &amp; specifications <span className="count">{fluids.length} fluids</span></h2>
          <table className="spec-table">
            <tbody>
              {fluids.map((f) => {
                const cap = f.capacity_qt && f.capacity_l
                  ? `${Number(f.capacity_qt).toFixed(1)} qt · ${Number(f.capacity_l).toFixed(1)} L`
                  : f.capacity_l ? `${Number(f.capacity_l).toFixed(1)} L` : "—";
                const grade = [f.viscosity, f.spec_standard].filter(Boolean).join(" · ");
                return (
                  <tr key={f.id}>
                    <th>{fluidLabel(f.fluid_type)}</th>
                    <td>
                      {cap}{grade ? ` · ${grade}` : ""}
                      {f.filter_part_no && <span className="alt"> · filter {f.filter_part_no}</span>}
                      {f.source_count > 0 && (
                        <sup className="cite">[{Array.from({ length: f.source_count }, (_, i) => i + 1).join("][")}]</sup>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </section>

        {/* TORQUE */}
        <section>
          <h2 className="section-h">Torque specifications <span className="count">{torques.length} fasteners</span></h2>
          <table className="spec-table">
            <tbody>
              {torques.map((t) => (
                <tr key={t.id}>
                  <th>{torqueLabel(t.fastener)}</th>
                  <td>
                    {t.torque_nm} N·m · {t.torque_ftlb} ft·lb
                    {t.notes && <span className="alt"> · {t.notes}</span>}
                    {t.source_count > 0 && (
                      <sup className="cite">[{Array.from({ length: t.source_count }, (_, i) => i + 1).join("][")}]</sup>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* ELECTRICAL */}
        {electrical && (
          <section>
            <h2 className="section-h">Electrical</h2>
            <table className="spec-table">
              <tbody>
                {electrical.battery_group && <tr><th>Battery group</th><td>BCI {electrical.battery_group}{electrical.cca && ` · ${electrical.cca} CCA`}{electrical.ah && ` · ${electrical.ah} Ah`}</td></tr>}
                {electrical.alternator_amps && <tr><th>Alternator</th><td>{electrical.alternator_amps} A</td></tr>}
                <tr><th>Bulb manifest</th><td>{bulbCount} bulb positions documented</td></tr>
                <tr><th>Fuse positions</th><td>{fuseCount} positions across under-hood &amp; cabin boxes</td></tr>
              </tbody>
            </table>
          </section>
        )}

        {/* MAINTENANCE SCHEDULE SUMMARY */}
        <section>
          <h2 className="section-h">Maintenance schedule (normal duty) <span className="count">{serviceIntervals.length} services</span></h2>
          <table className="spec-table">
            <tbody>
              {serviceIntervals.map((s, i) => {
                const interval = s.miles_normal
                  ? `${s.miles_normal.toLocaleString()} mi`
                  : s.months
                    ? `${s.months} months`
                    : "—";
                return (
                  <tr key={i}>
                    <th>{serviceLabel(s.service)}</th>
                    <td>{interval}{s.km_normal && s.miles_normal ? ` · ${s.km_normal.toLocaleString()} km` : ""}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </section>

        {/* MOAT GRID */}
        <section>
          <h2 className="section-h">Owner-manual data <span className="count">{fluids.length + torques.length + bulbCount + fuseCount + partCount + serviceIntervals.length + 1} entries · cross-verified</span></h2>
          <div className="moat-list">
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/oil-capacity`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
                <path d="M10 2v5m0 0c-2.5 1.5-4 4-4 6.5a4 4 0 0 0 8 0c0-2.5-1.5-5-4-6.5z" />
              </svg>
              <span>
                <span className="name">Fluids &amp; lubricants</span>
                <span className="peek">{oil ? `Oil ${Number(oil.capacity_qt).toFixed(1)} qt · ${oil.viscosity}` : "—"}{cvt ? ` · CVT ${Number(cvt.capacity_qt).toFixed(1)} qt` : ""}{coolant ? ` · coolant ${Number(coolant.capacity_qt).toFixed(1)} qt` : ""}</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/maintenance-schedule`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><path d="M10 6v4l3 2" /></svg>
              <span>
                <span className="name">Maintenance schedule</span>
                <span className="peek">{serviceIntervals.length} services · normal &amp; severe duty{oilService?.miles_normal ? ` · oil ${oilService.miles_normal.toLocaleString()} mi` : ""}</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/electrical`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="7" width="14" height="8" /><path d="M6 7V5m8 2V5m-4 5v2" /></svg>
              <span>
                <span className="name">Battery &amp; electrical</span>
                <span className="peek">{electrical?.battery_group ? `Group ${electrical.battery_group} · ${electrical.cca} CCA` : "—"} · {bulbCount} bulbs · {fuseCount} fuses</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/torque`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="2.5" /><path d="M10 2v3M10 15v3M2 10h3M15 10h3" /></svg>
              <span>
                <span className="name">Torque specifications</span>
                <span className="peek">{lug ? `Lug ${lug.torque_ftlb} ft·lb` : ""}{torques.length > 0 ? ` · ${torques.length} fasteners` : "—"}</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/tires`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><circle cx="10" cy="10" r="7" /><circle cx="10" cy="10" r="3" /></svg>
              <span>
                <span className="name">Tires &amp; wheels</span>
                <span className="peek">Placard PSI · OE tire size · bolt pattern</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href={`/${make.slug}/${gen.slug}/electrical`}>
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="3" width="14" height="14" /><path d="M3 10h14M10 3v14" /></svg>
              <span>
                <span className="name">Fuse box layout</span>
                <span className="peek">{fuseCount} positions · under-hood &amp; cabin</span>
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

        {/* SOURCES */}
        <section className="sources-block">
          <h3>Sources</h3>
          <ol className="sources-list">
            {sources.map((s) => (
              <li key={s.id}>
                <span>
                  <span className="who">{s.citation}</span>
                  {s.notes && <span className="what">{s.notes}</span>}
                </span>
                <span className="when">
                  Retrieved {new Date(s.retrieved_at).toISOString().slice(0, 10)}
                </span>
              </li>
            ))}
          </ol>
        </section>

        <NameplateRail
          modelId={model.id}
          makeSlug={make.slug}
          currentGenSlug={gen.slug}
          makeName={make.name}
          modelName={model.name}
        />
      </main>

      <footer className="site-footer">
        <div className="shell">
          <div className="foot-grid">
            <div>
              <a href="/" className="wordmark">ownerspecs</a>
              <p>Cross-verified vehicle specifications and owner-manual data for every car, every generation, every market.</p>
              <div style={{ marginTop: "var(--s-3)" }}><span className="market-pill">Global · multi-market</span></div>
            </div>
            <div><h4>Catalogue</h4><ul><li><a href="/#brands">By manufacturer</a></li><li><a href="/#brands">By body type</a></li><li><a href="/#brands">By fuel</a></li></ul></div>
            <div><h4>Data</h4><ul><li><a href="/#owner-manual-data">Fluids</a></li><li><a href="/#owner-manual-data">Maintenance</a></li><li><a href="/#owner-manual-data">Torque</a></li></ul></div>
            <div><h4>Sister sites</h4><ul><li><a href="https://vindecoder.site">vindecoder.site</a></li><li><a href="https://autodtcs.com">autodtcs.com</a></li><li><a href="https://servicereset.net">servicereset.net</a></li></ul></div>
            <div><h4>About</h4><ul><li><a href="/#methodology">Methodology</a></li><li><a href="/#methodology">Sources</a></li></ul></div>
          </div>
          <div className="foot-bottom">
            <span>© 2026 ownerspecs · v0.1</span>
            <span>Page last reviewed {reviewDate}</span>
          </div>
        </div>
      </footer>
    </>
  );
}
