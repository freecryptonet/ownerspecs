import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { pageMetadata, faqJsonLd } from "@/lib/seo";
import { mmDual, kgRangeDual } from "@/lib/units";

type Params = { pair: string };

type GenRow = {
  id: number;
  brand_slug: string;
  brand_name: string;
  model_slug: string;
  model_name: string;
  gen_slug: string;
  display_name: string;
  body_type: string;
  codename: string | null;
  start_year: number;
  end_year: number | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  fuel_tank_l: string | null;
  cargo_l: number | null;
  hero_url: string | null;
};

type TrimAgg = {
  min_hp: number | null;
  max_hp: number | null;
  min_torque_nm: number | null;
  max_torque_nm: number | null;
  min_weight_kg: number | null;
  max_weight_kg: number | null;
  best_consumption: string | null;
  best_zero_100: string | null;
  trim_count: number;
  engine_codes: string;
};

type OilRow = {
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  drain_interval_mi: number | null;
};

type ServiceRow = { service: string; miles_normal: number | null };

// Curated comparison pairs. Each is a (gen_slug-A) + "-vs-" + (gen_slug-B)
// where both slugs already exist in the DB. We generateStaticParams for
// every pair listed here.
const PAIRS: Array<[string, string, string?]> = [
  // Compact sedans
  ["civic-sedan-x-2016-2021", "corolla-e170-sedan-2012-2018"],
  ["civic-fe-sedan-2022-2025", "corolla-sedan-e210-2019-2022"],
  ["civic-fe-sedan-2022-2025", "3-bm-sedan-2013-2018"],
  ["civic-fe-sedan-2022-2025", "elantra-cn7-sedan-2021-present"],
  // Mid-size sedans
  ["camry-xv70-2018-2024", "accord-cv-sedan-2023-present"],
  ["camry-xv70-2018-2024", "altima-l34-sedan-2018-2022"],
  ["accord-cv-sedan-2023-present", "altima-l34-sedan-2018-2022"],
  // Compact crossovers
  ["rav4-xa50-suv-2019-2021", "cr-v-rw-suv-2017-2022"],
  ["rav4-xa50-suv-2019-2021", "tucson-nx4-suv-2021-2024"],
  ["rav4-xa50-suv-2019-2021", "cx-5-kf-suv-2017-2024"],
  ["rav4-xa50-suv-2019-2021", "tiguan-ad1-suv-2017-2024"],
  ["tucson-nx4-suv-2021-2024", "sportage-nq5-suv-2021-2025"],
  ["cr-v-rw-suv-2017-2022", "tucson-nx4-suv-2021-2024"],
  ["cr-v-rs-suv-2023-present", "rav4-xa50-suv-2019-2021"],
  // 3-row SUVs
  ["highlander-xu70-suv-2020-2025", "pilot-yf-suv-2023-present"],
  ["highlander-xu70-suv-2020-2025", "telluride-on-suv-2020-2025"],
  ["pilot-yf-suv-2023-present", "telluride-on-suv-2020-2025"],
  ["pilot-yf-suv-2023-present", "atlas-ca-suv-2018-2023"],
  ["explorer-u625-suv-2020-2024", "highlander-xu70-suv-2020-2025"],
  // Pickups
  ["f-150-p702-pickup-2021-2025", "silverado-t1-pickup-2019-2024"],
  ["f-150-p702-pickup-2021-2025", "1500-dt-pickup-2019-2024"],
  ["silverado-t1-pickup-2019-2024", "1500-dt-pickup-2019-2024"],
  ["silverado-t1-pickup-2019-2024", "sierra-1500-t1xx-pickup-2019-2024"],
  ["tundra-xk70-pickup-2022-present", "f-150-p702-pickup-2021-2025"],
  ["tacoma-n300-pickup-2023-present", "f-150-p702-pickup-2021-2025"],
  // Luxury sedans
  ["3-series-sedan-g20-2019-2022", "c-class-sedan-w206-2022-present"],
  ["3-series-sedan-g20-2019-2022", "a4-sedan-b9-2015-2018"],
  ["c-class-sedan-w206-2022-present", "a4-sedan-b9-2015-2018"],
  ["3-series-f30-sedan-2012-2018", "3-series-sedan-g20-2019-2022"],
  ["e-class-w213-sedan-2017-2020", "3-series-sedan-g20-2019-2022"],
  // Luxury SUVs
  ["x5-g05-suv-2019-2023", "glc-x253-suv-2016-2022"],
  ["x3-g01-suv-2018-2024", "glc-x253-suv-2016-2022"],
  ["x3-g01-suv-2018-2024", "xc60-suv-2017-2024"],
  ["nx-az20-suv-2022-present", "rx-al20-suv-2015-2022"],
  ["mdx-yd4-suv-2022-2025", "pilot-yf-suv-2023-present"],
  // Wagons / AWD
  ["outback-bt-wagon-2019-2024", "forester-sk-suv-2018-2021"],
  ["outback-bt-wagon-2019-2024", "crosstrek-gt-suv-2018-2023"],
  ["forester-sk-suv-2018-2021", "rav4-xa50-suv-2019-2021"],
  // BEVs
  ["model-3-sedan-2017-2023", "model-y-suv-2020-2024"],
  ["model-y-suv-2020-2024", "ioniq-5-ne1-suv-2021-2024"],
  // Off-road
  ["wrangler-jl-suv-2018-2023", "bronco-u725-suv-2021-present"],
  ["wrangler-jl-suv-2018-2023", "grand-cherokee-wl-suv-2022-present"],
  // Full-size SUVs
  ["tahoe-t1xx-suv-2021-2024", "x5-g05-suv-2019-2023"],
];

const splitPair = (slug: string): [string, string] | null => {
  // Split on -vs- (resilient to gen slugs that contain dashes)
  const idx = slug.indexOf("-vs-");
  if (idx === -1) return null;
  return [slug.slice(0, idx), slug.slice(idx + 4)];
};

async function getGenData(slug: string): Promise<GenRow | null> {
  return await queryOne<GenRow>(
    `SELECT g.id, mk.slug AS brand_slug, mk.name AS brand_name,
            m.slug AS model_slug, m.name AS model_name,
            g.slug AS gen_slug, g.display_name, g.body_type, g.codename,
            g.start_year, g.end_year,
            g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
            g.fuel_tank_l, g.cargo_l,
            (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.slug = ? AND g.is_active = 1 LIMIT 1`,
    [slug],
  );
}

async function getTrimAgg(genId: number): Promise<TrimAgg> {
  const row = await queryOne<TrimAgg>(
    `SELECT MIN(hp) AS min_hp, MAX(hp) AS max_hp,
            MIN(torque_nm) AS min_torque_nm, MAX(torque_nm) AS max_torque_nm,
            MIN(curb_weight_kg) AS min_weight_kg, MAX(curb_weight_kg) AS max_weight_kg,
            MIN(fuel_combined_l_100km) AS best_consumption,
            MIN(zero_100_kmh_s) AS best_zero_100,
            COUNT(*) AS trim_count,
            (SELECT GROUP_CONCAT(DISTINCT code SEPARATOR ', ') FROM engines WHERE id IN
              (SELECT DISTINCT engine_id FROM trims WHERE generation_id = ? AND engine_id IS NOT NULL)
            ) AS engine_codes
     FROM trims WHERE generation_id = ?`,
    [genId, genId],
  );
  return (
    row ?? {
      min_hp: null, max_hp: null, min_torque_nm: null, max_torque_nm: null,
      min_weight_kg: null, max_weight_kg: null,
      best_consumption: null, best_zero_100: null, trim_count: 0, engine_codes: "",
    }
  );
}

async function getOil(genId: number): Promise<OilRow | null> {
  return queryOne<OilRow>(
    `SELECT capacity_l, capacity_qt, viscosity, drain_interval_mi
     FROM fluid_specs WHERE generation_id = ? AND fluid_type = 'engine_oil' LIMIT 1`,
    [genId],
  );
}

async function getServices(genId: number): Promise<ServiceRow[]> {
  return query<ServiceRow>(
    `SELECT service, miles_normal FROM service_intervals
     WHERE generation_id = ? AND service IN ('engine_oil_and_filter','spark_plugs','brake_fluid_flush','transmission_at_fluid','coolant_flush')`,
    [genId],
  );
}

export async function generateStaticParams(): Promise<Params[]> {
  return PAIRS.map(([a, b]) => ({ pair: `${a}-vs-${b}` }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { pair } = await params;
  const split = splitPair(pair);
  if (!split) return { title: "Not found" };
  const [a, b] = split;
  const [gA, gB] = await Promise.all([getGenData(a), getGenData(b)]);
  if (!gA || !gB) return { title: "Not found" };
  return pageMetadata({
    title: `${gA.brand_name} ${gA.model_name} vs ${gB.brand_name} ${gB.model_name} — Side-by-side specs`,
    description: `Detailed side-by-side comparison of the ${gA.brand_name} ${gA.display_name} (${gA.start_year}-${gA.end_year ?? "present"}) and ${gB.brand_name} ${gB.display_name} (${gB.start_year}-${gB.end_year ?? "present"}). Engine, performance, dimensions, fuel economy, maintenance, fluid capacities, OE part numbers.`,
    path: `/compare/${pair}`,
    heroPath: gA.hero_url ?? gB.hero_url,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { pair } = await params;
  const split = splitPair(pair);
  if (!split) notFound();
  const [a, b] = split;

  const [gA, gB] = await Promise.all([getGenData(a), getGenData(b)]);
  if (!gA || !gB) notFound();

  const [tA, tB, oA, oB, sA, sB] = await Promise.all([
    getTrimAgg(gA.id),
    getTrimAgg(gB.id),
    getOil(gA.id),
    getOil(gB.id),
    getServices(gA.id),
    getServices(gB.id),
  ]);

  const yrA = gA.end_year ? `${gA.start_year} – ${gA.end_year}` : `${gA.start_year} – present`;
  const yrB = gB.end_year ? `${gB.start_year} – ${gB.end_year}` : `${gB.start_year} – present`;

  const findSvc = (rows: ServiceRow[], k: string) =>
    rows.find((r) => r.service === k)?.miles_normal ?? null;

  // FAQ from real differences
  const faqs: Array<{ q: string; a: string }> = [];
  if (tA.max_hp && tB.max_hp) {
    const winner = tA.max_hp > tB.max_hp ? "A" : "B";
    const winG = winner === "A" ? gA : gB;
    const losG = winner === "A" ? gB : gA;
    const winHp = winner === "A" ? tA.max_hp : tB.max_hp;
    const losHp = winner === "A" ? tB.max_hp : tA.max_hp;
    faqs.push({
      q: `Which has more horsepower, the ${gA.brand_name} ${gA.model_name} or the ${gB.brand_name} ${gB.model_name}?`,
      a: `The ${winG.brand_name} ${winG.model_name} leads with up to ${winHp} hp on its top trim, compared with ${losHp} hp on the ${losG.brand_name} ${losG.model_name}. Base-trim figures will be closer.`,
    });
  }
  if (gA.length_mm && gB.length_mm) {
    const longer = gA.length_mm > gB.length_mm ? "A" : "B";
    const lG = longer === "A" ? gA : gB;
    const sG = longer === "A" ? gB : gA;
    const diff = Math.abs(gA.length_mm - gB.length_mm);
    faqs.push({
      q: `Which is bigger, the ${gA.brand_name} ${gA.model_name} or the ${gB.brand_name} ${gB.model_name}?`,
      a: `The ${lG.brand_name} ${lG.model_name} is ${diff} mm longer (${(diff/25.4).toFixed(1)} in) than the ${sG.brand_name} ${sG.model_name}.`,
    });
  }
  if (oA?.capacity_qt && oB?.capacity_qt) {
    faqs.push({
      q: `What's the engine oil capacity difference between the ${gA.brand_name} ${gA.model_name} and ${gB.brand_name} ${gB.model_name}?`,
      a: `${gA.brand_name} ${gA.model_name}: ${Number(oA.capacity_qt).toFixed(1)} US qt${oA.viscosity ? ` of ${oA.viscosity}` : ""}. ${gB.brand_name} ${gB.model_name}: ${Number(oB.capacity_qt).toFixed(1)} US qt${oB.viscosity ? ` of ${oB.viscosity}` : ""}.`,
    });
  }
  const oilA = findSvc(sA, "engine_oil_and_filter");
  const oilB = findSvc(sB, "engine_oil_and_filter");
  if (oilA && oilB) {
    faqs.push({
      q: `How do the maintenance schedules compare?`,
      a: `${gA.brand_name} ${gA.model_name} oil interval: every ${oilA.toLocaleString()} miles. ${gB.brand_name} ${gB.model_name}: every ${oilB.toLocaleString()} miles. ${oilA === oilB ? "Identical normal-duty intervals." : oilA > oilB ? `${gA.brand_name} runs the longer interval; ${gB.brand_name} is slightly more frequent.` : `${gB.brand_name} runs the longer interval.`}`,
    });
  }

  const Card = ({ gen, trim, oil }: { gen: GenRow; trim: TrimAgg; oil: OilRow | null }) => (
    <div style={{ border: "1px solid var(--rule)", background: "var(--bg-alt)" }}>
      {gen.hero_url && (
        <div style={{ aspectRatio: "16 / 9", overflow: "hidden" }}>
          <img
            src={gen.hero_url}
            alt={`${gen.brand_name} ${gen.display_name}`}
            style={{ width: "100%", height: "100%", objectFit: "cover" }}
          />
        </div>
      )}
      <div style={{ padding: "14px 18px" }}>
        <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)" }}>
          {gen.brand_name} {gen.codename ? `· ${gen.codename}` : ""}
        </div>
        <h3 style={{ fontSize: 18, fontWeight: 600, marginTop: 4 }}>
          <a href={`/${gen.brand_slug}/${gen.gen_slug}`} style={{ color: "var(--ink)" }}>
            {gen.model_name} {gen.display_name}
          </a>
        </h3>
        <div style={{ fontFamily: "var(--font-mono)", fontSize: 12, color: "var(--ink-mute)", marginTop: 2 }}>
          {gen.end_year ? `${gen.start_year}–${gen.end_year}` : `${gen.start_year}–present`} · {gen.body_type}
        </div>
      </div>
    </div>
  );

  const cmpRow = (label: string, a: React.ReactNode, b: React.ReactNode) => (
    <tr>
      <th style={{ width: "30%" }}>{label}</th>
      <td><strong>{a}</strong></td>
      <td><strong>{b}</strong></td>
    </tr>
  );

  return (
    <>
      <SiteHeader />

      {faqs.length >= 2 && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(faqs)) }}
        />
      )}

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href="/compare">Compare</a><span className="sep">/</span>
          <span>{gA.brand_name} {gA.model_name} vs {gB.brand_name} {gB.model_name}</span>
        </nav>

        <div className="pagehead">
          <h1>{gA.brand_name} {gA.model_name} vs {gB.brand_name} {gB.model_name}</h1>
          <div className="sub">
            <span>{gA.brand_name} {gA.display_name} ({yrA})</span>
            <span className="pip"></span>
            <span>{gB.brand_name} {gB.display_name} ({yrB})</span>
          </div>
        </div>
      </div>

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
            <Card gen={gA} trim={tA} oil={oA} />
            <Card gen={gB} trim={tB} oil={oB} />
          </div>
        </section>

        <section>
          <h2 className="section-h">Engine &amp; performance</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                <th></th>
                <th>{gA.brand_name} {gA.model_name}</th>
                <th>{gB.brand_name} {gB.model_name}</th>
              </tr>
            </thead>
            <tbody>
              {cmpRow("Engines",
                tA.engine_codes || "—",
                tB.engine_codes || "—")}
              {cmpRow("Horsepower",
                tA.min_hp != null && tA.max_hp != null
                  ? tA.min_hp === tA.max_hp ? `${tA.min_hp} hp` : `${tA.min_hp}–${tA.max_hp} hp`
                  : "—",
                tB.min_hp != null && tB.max_hp != null
                  ? tB.min_hp === tB.max_hp ? `${tB.min_hp} hp` : `${tB.min_hp}–${tB.max_hp} hp`
                  : "—")}
              {cmpRow("Torque",
                tA.min_torque_nm != null && tA.max_torque_nm != null
                  ? `${tA.min_torque_nm}–${tA.max_torque_nm} N·m`
                  : "—",
                tB.min_torque_nm != null && tB.max_torque_nm != null
                  ? `${tB.min_torque_nm}–${tB.max_torque_nm} N·m`
                  : "—")}
              {cmpRow("Best 0–100 km/h",
                tA.best_zero_100 ? `${tA.best_zero_100} s` : "—",
                tB.best_zero_100 ? `${tB.best_zero_100} s` : "—")}
              {cmpRow("Best fuel economy",
                tA.best_consumption ? `${tA.best_consumption} L/100km` : "—",
                tB.best_consumption ? `${tB.best_consumption} L/100km` : "—")}
              {cmpRow("Trim count",
                tA.trim_count,
                tB.trim_count)}
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Dimensions &amp; weight</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                <th></th>
                <th>{gA.brand_name} {gA.model_name}</th>
                <th>{gB.brand_name} {gB.model_name}</th>
              </tr>
            </thead>
            <tbody>
              {cmpRow("Length",        mmDual(gA.length_mm),    mmDual(gB.length_mm))}
              {cmpRow("Width",         mmDual(gA.width_mm),     mmDual(gB.width_mm))}
              {cmpRow("Height",        mmDual(gA.height_mm),    mmDual(gB.height_mm))}
              {cmpRow("Wheelbase",     mmDual(gA.wheelbase_mm), mmDual(gB.wheelbase_mm))}
              {cmpRow("Curb weight",
                tA.min_weight_kg && tA.max_weight_kg ? kgRangeDual(tA.min_weight_kg, tA.max_weight_kg) : "—",
                tB.min_weight_kg && tB.max_weight_kg ? kgRangeDual(tB.min_weight_kg, tB.max_weight_kg) : "—")}
              {cmpRow("Fuel tank",
                gA.fuel_tank_l ? `${Number(gA.fuel_tank_l).toFixed(0)} L` : "—",
                gB.fuel_tank_l ? `${Number(gB.fuel_tank_l).toFixed(0)} L` : "—")}
              {cmpRow("Cargo capacity",
                gA.cargo_l ? `${gA.cargo_l} L` : "—",
                gB.cargo_l ? `${gB.cargo_l} L` : "—")}
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Maintenance &amp; fluids</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                <th></th>
                <th>{gA.brand_name} {gA.model_name}</th>
                <th>{gB.brand_name} {gB.model_name}</th>
              </tr>
            </thead>
            <tbody>
              {cmpRow("Engine oil capacity",
                oA?.capacity_qt && oA?.capacity_l ? `${Number(oA.capacity_qt).toFixed(1)} qt · ${Number(oA.capacity_l).toFixed(1)} L` : "—",
                oB?.capacity_qt && oB?.capacity_l ? `${Number(oB.capacity_qt).toFixed(1)} qt · ${Number(oB.capacity_l).toFixed(1)} L` : "—")}
              {cmpRow("Oil viscosity",       oA?.viscosity ?? "—", oB?.viscosity ?? "—")}
              {cmpRow("Oil interval",
                oilA ? `${oilA.toLocaleString()} mi` : "—",
                oilB ? `${oilB.toLocaleString()} mi` : "—")}
              {cmpRow("Spark plug interval",
                findSvc(sA,"spark_plugs") ? `${findSvc(sA,"spark_plugs")?.toLocaleString()} mi` : "—",
                findSvc(sB,"spark_plugs") ? `${findSvc(sB,"spark_plugs")?.toLocaleString()} mi` : "—")}
              {cmpRow("Transmission ATF interval",
                findSvc(sA,"transmission_at_fluid") ? `${findSvc(sA,"transmission_at_fluid")?.toLocaleString()} mi` : "—",
                findSvc(sB,"transmission_at_fluid") ? `${findSvc(sB,"transmission_at_fluid")?.toLocaleString()} mi` : "—")}
              {cmpRow("Coolant flush",
                findSvc(sA,"coolant_flush") ? `${findSvc(sA,"coolant_flush")?.toLocaleString()} mi` : "—",
                findSvc(sB,"coolant_flush") ? `${findSvc(sB,"coolant_flush")?.toLocaleString()} mi` : "—")}
            </tbody>
          </table>
        </section>

        {faqs.length > 0 && (
          <section>
            <h2 className="section-h">Frequently asked</h2>
            <dl>
              {faqs.map((f) => (
                <div key={f.q} style={{ borderTop: "1px solid var(--rule)", padding: "14px 0" }}>
                  <dt style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>{f.q}</dt>
                  <dd style={{ margin: 0, color: "var(--ink-soft)", fontSize: 13, lineHeight: 1.55 }}>{f.a}</dd>
                </div>
              ))}
            </dl>
          </section>
        )}

        <section>
          <h2 className="section-h">Drill into either vehicle</h2>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(2, 1fr)",
              gap: 8,
            }}
          >
            <li>
              <a
                href={`/${gA.brand_slug}/${gA.gen_slug}`}
                style={{ display: "block", padding: "12px 16px", border: "1px solid var(--rule)", color: "var(--ink)" }}
              >
                <strong>{gA.brand_name} {gA.model_name}</strong> — Full spec sheet, fluids, torque, electrical, procedures
              </a>
            </li>
            <li>
              <a
                href={`/${gB.brand_slug}/${gB.gen_slug}`}
                style={{ display: "block", padding: "12px 16px", border: "1px solid var(--rule)", color: "var(--ink)" }}
              >
                <strong>{gB.brand_name} {gB.model_name}</strong> — Full spec sheet, fluids, torque, electrical, procedures
              </a>
            </li>
          </ul>
        </section>
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
