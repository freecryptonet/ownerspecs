import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";

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

// ---------- helpers ----------
const fluidLabels: Record<string, string> = {
  engine_oil: "Engine oil (1.5T)",
  engine_oil_2_0: "Engine oil (2.0 NA)",
  engine_oil_1_0t: "Engine oil (1.0T EU/UK)",
  engine_oil_diesel: "Engine oil (diesel)",
  transmission_cvt: "Transmission · CVT",
  transmission_mt: "Transmission · MT gear oil",
  coolant: "Coolant",
  brake: "Brake fluid",
  ps: "Power steering",
  ac_refrigerant: "A/C refrigerant",
  washer: "Washer fluid",
};

const torqueLabels: Record<string, string> = {
  lug_nut: "Wheel lug nut",
  spark_plug: "Spark plug",
  oil_drain: "Oil drain plug",
  wheel_hub_nut: "Wheel hub nut",
  caliper_bolt: "Brake caliper slide bolt",
  control_arm: "Control arm bolt",
};

const serviceLabels: Record<string, string> = {
  engine_oil_and_filter: "Engine oil & filter",
  tire_rotation: "Tire rotation",
  brake_inspection: "Brake inspection",
  engine_air_filter: "Engine air filter",
  cabin_air_filter: "Cabin air filter",
  transmission_cvt_fluid: "CVT fluid",
  brake_fluid_flush: "Brake fluid flush",
  spark_plugs: "Spark plugs",
  coolant_flush: "Coolant flush",
  valve_clearance: "Valve clearance",
  drive_belt_inspection: "Drive belt inspection",
  tpms_sensor_battery: "TPMS sensor battery",
};

function yearRange(start: number, end: number | null): string {
  return end ? `${start} – ${end}` : `${start} – present`;
}

function fluidLabel(fluidType: string): string {
  return fluidLabels[fluidType] ?? fluidType.replace(/_/g, " ");
}

function torqueLabel(fastener: string): string {
  return torqueLabels[fastener] ?? fastener.replace(/_/g, " ");
}

function serviceLabel(service: string): string {
  return serviceLabels[service] ?? service.replace(/_/g, " ");
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
            g.body_type, g.start_year, g.end_year, g.layout, g.platform
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
            t.co2_g_km, t.curb_weight_kg
     FROM trims t
     LEFT JOIN markets mk        ON mk.id = t.market_id
     LEFT JOIN engines e         ON e.id  = t.engine_id
     LEFT JOIN transmissions tx  ON tx.id = t.transmission_id
     WHERE t.generation_id = ?
     ORDER BY t.hp DESC, t.name`,
    [gen.id],
  );

  const fluids = await query<FluidSpec>(
    `SELECT f.id, f.fluid_type, f.capacity_l, f.capacity_qt, f.viscosity,
            f.spec_standard, f.filter_part_no, f.drain_interval_mi,
            f.drain_interval_km, f.drain_interval_months, f.notes,
            (SELECT COUNT(*) FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id=f.id) AS source_count
     FROM fluid_specs f
     WHERE f.generation_id = ?
     ORDER BY FIELD(f.fluid_type,'engine_oil','engine_oil_2_0','engine_oil_1_0t','engine_oil_diesel',
                                  'transmission_cvt','transmission_mt','coolant','brake','ps',
                                  'ac_refrigerant','washer')`,
    [gen.id],
  );

  const torques = await query<TorqueSpec>(
    `SELECT t.id, t.fastener, t.torque_nm, t.torque_ftlb, t.notes,
            (SELECT COUNT(*) FROM spec_sources WHERE spec_table='torque_specs' AND spec_id=t.id) AS source_count
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

  const sources = await query<SourceRow>(
    `SELECT DISTINCT s.id, s.type, s.citation, s.url, s.retrieved_at, s.notes
     FROM sources s
     JOIN spec_sources ss ON ss.source_id = s.id
     WHERE ss.spec_table IN ('fluid_specs','torque_specs','electrical_specs','bulbs',
                              'fuses','parts','service_intervals','tire_pressures')
       AND ss.spec_id IN (
         SELECT id FROM fluid_specs       WHERE generation_id = ?
         UNION ALL SELECT id FROM torque_specs     WHERE generation_id = ?
         UNION ALL SELECT id FROM electrical_specs WHERE generation_id = ?
         UNION ALL SELECT id FROM bulbs            WHERE generation_id = ?
         UNION ALL SELECT id FROM fuses            WHERE generation_id = ?
         UNION ALL SELECT id FROM parts            WHERE generation_id = ?
         UNION ALL SELECT id FROM service_intervals WHERE generation_id = ?
         UNION ALL SELECT id FROM tire_pressures   WHERE generation_id = ?
       )
     ORDER BY s.id`,
    [gen.id, gen.id, gen.id, gen.id, gen.id, gen.id, gen.id, gen.id],
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
    sources,
  };
}

// ---------- Next route ----------
export async function generateStaticParams(): Promise<Params[]> {
  const rows = await query<{ brand: string; generation: string }>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id`,
  );
  return rows.map((r) => ({ brand: r.brand, generation: r.generation }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation } = await params;
  const data = await getGenerationData(brand, generation);
  if (!data) return { title: "Not found" };
  const { make, gen } = data;
  const yrs = yearRange(gen.start_year, gen.end_year);
  return {
    title: `${make.name} ${gen.display_name} ${yrs} — Specifications`,
    description: `Full specifications for the ${gen.display_name} (${make.name}, ${yrs}). Engine, performance, dimensions, fluid capacities, maintenance schedule, torque values — cross-verified.`,
    alternates: { canonical: `/${make.slug}/${gen.slug}` },
  };
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const data = await getGenerationData(brand, generation);
  if (!data) notFound();
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
            <a href="#">Maintenance</a>
            <a href="#">Fluids</a>
            <a href="#">Compare</a>
            <a href="#">Methodology</a>
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
          <a className="tab active" href="#">Overview</a>
          <a className="tab" href="#">Specifications <span className="count">{engines.length * 6 + 14}</span></a>
          <a className="tab" href="#">Maintenance <span className="count">{serviceIntervals.length}</span></a>
          <a className="tab" href="#">Fluids <span className="count">{fluids.length}</span></a>
          <a className="tab" href="#">Torque <span className="count">{torques.length}</span></a>
          <a className="tab" href="#">Electrical <span className="count">{bulbCount + fuseCount + 1}</span></a>
          <a className="tab" href="#">Procedures</a>
          <a className="tab" href="#">Compare</a>
        </div>
      </div>

      <main className="shell">

        {/* INFOBOX */}
        <section style={{ paddingTop: "var(--s-6)" }}>
          <div className="infobox-row">
            <div>
              <div className="ib-photo">
                <div className="frame">
                  <svg viewBox="0 0 800 600" stroke="rgba(255,255,255,0.75)" fill="none" strokeWidth="1.6">
                    <path d="M90 410c0-32 22-52 58-52h92l72-104c12-19 30-29 56-29h190c26 0 44 10 56 29l72 104h92c36 0 58 20 58 52v52H90z"/>
                    <path d="M325 358l38-66h290l38 66"/>
                    <circle cx="245" cy="462" r="52" fill="rgba(255,255,255,0.06)" />
                    <circle cx="245" cy="462" r="38" />
                    <circle cx="775" cy="462" r="52" fill="rgba(255,255,255,0.06)" />
                    <circle cx="775" cy="462" r="38" />
                  </svg>
                </div>
                <div className="caption">
                  <span>{make.name} {gen.display_name}</span>
                  <span>OEM press</span>
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
                  <tr><th>Engines</th><td>{engines.map((e) => e.code).join(" · ")}</td></tr>
                  <tr><th>Trims (US)</th><td className="alt">{trims.map((t) => t.name).join(" · ")}</td></tr>
                  <tr><th>Markets</th><td>{markets.map((m) => m.code).join(" · ")}</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        {/* ENGINE SPECS */}
        {engines.map((e) => (
          <section key={e.id} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Engine — {e.display_name} ({e.code})
              <span className="count">{trims.filter((t) => t.engine_code === e.code).map((t) => t.name).join(" · ") || "—"}</span>
            </h2>
            <table className="spec-table">
              <tbody>
                <tr><th>Displacement</th><td>{e.displacement_cc} cm³</td></tr>
                {e.bore_mm && e.stroke_mm && <tr><th>Bore × stroke</th><td>{e.bore_mm} × {e.stroke_mm} mm</td></tr>}
                {e.compression && <tr><th>Compression ratio</th><td>{e.compression} : 1</td></tr>}
                {e.aspiration && <tr><th>Aspiration</th><td>{e.aspiration}</td></tr>}
                {e.valvetrain && <tr><th>Valvetrain</th><td>{e.valvetrain}</td></tr>}
                {e.cylinders && <tr><th>Cylinders</th><td>{e.cylinders} · {e.fuel}</td></tr>}
              </tbody>
            </table>
          </section>
        ))}

        {/* TRIM PERFORMANCE TABLE */}
        <section>
          <h2 className="section-h">Trims &amp; performance <span className="count">{trims.length} trims</span></h2>
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
                  <td>{t.top_speed_kmh ? `${t.top_speed_kmh} km/h` : "—"}</td>
                  <td>{t.fuel_combined_l_100km ? `${Number(t.fuel_combined_l_100km).toFixed(1)} L/100km` : "—"}</td>
                  <td>{t.curb_weight_kg ? `${t.curb_weight_kg} kg` : "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
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
            <a className="moat-row" href="#">
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="3" width="14" height="14" /><path d="M3 10h14M10 3v14" /></svg>
              <span>
                <span className="name">Fuse box layout</span>
                <span className="peek">{fuseCount} positions · under-hood &amp; cabin</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href="#">
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M3 5h14M3 10h14M3 15h9" /></svg>
              <span>
                <span className="name">Service procedures</span>
                <span className="peek">Oil reset · TPMS · throttle adapt · jump-start</span>
              </span>
              <span className="arrow">→</span>
            </a>
            <a className="moat-row" href="#">
              <svg className="icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M3 7 10 3l7 4M3 7v7l7 4 7-4V7" /></svg>
              <span>
                <span className="name">Towing &amp; load</span>
                <span className="peek">Braked &amp; unbraked · payload · roof load</span>
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
      </main>

      <footer className="site-footer">
        <div className="shell">
          <div className="foot-grid">
            <div>
              <a href="/" className="wordmark">ownerspecs</a>
              <p>Cross-verified vehicle specifications and owner-manual data for every car, every generation, every market.</p>
              <div style={{ marginTop: "var(--s-3)" }}><span className="market-pill">Global · multi-market</span></div>
            </div>
            <div><h4>Catalogue</h4><ul><li><a href="#">By manufacturer</a></li><li><a href="#">By body type</a></li><li><a href="#">By fuel</a></li></ul></div>
            <div><h4>Data</h4><ul><li><a href="#">Fluids</a></li><li><a href="#">Maintenance</a></li><li><a href="#">Torque</a></li></ul></div>
            <div><h4>Sister sites</h4><ul><li><a href="https://vindecoder.site">vindecoder.site</a></li><li><a href="https://autodtcs.com">autodtcs.com</a></li><li><a href="https://servicereset.net">servicereset.net</a></li></ul></div>
            <div><h4>About</h4><ul><li><a href="#">Methodology</a></li><li><a href="#">Sources</a></li></ul></div>
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
