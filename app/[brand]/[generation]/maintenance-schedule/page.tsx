import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getSourcesFor,
  getAllGenerationParams,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { serviceLabel } from "@/lib/labels";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type ServiceRow = {
  id: number;
  service: string;
  miles_normal: number | null;
  miles_severe: number | null;
  km_normal: number | null;
  km_severe: number | null;
  months: number | null;
  notes: string | null;
  engine_id: number | null;
};

// serviceLabel imported from @/lib/labels

export async function generateStaticParams(): Promise<Params[]> {
  return getAllGenerationParams();
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Maintenance schedule`,
    description: `Full maintenance schedule for the ${base.gen.display_name} (${base.make.name}, ${yrs}) — engine oil, filters, brake fluid, spark plugs, timing belt and coolant intervals in km and miles, cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/maintenance-schedule`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const services = await query<ServiceRow>(
    `SELECT id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes, engine_id
     FROM service_intervals
     WHERE generation_id = ?
     ORDER BY COALESCE(miles_normal, miles_severe, 999999), service`,
    [gen.id],
  );

  if (services.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "service_intervals");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Cross-vehicle engine matches — herstructureringsplan §4. Engine-scoped
  // service items (spark plug interval, timing belt, accessory belt, valve
  // adjustment) carry the same value across vehicles with the same engine.
  const distinctEngineIds = [
    ...new Set(services.map((s) => s.engine_id).filter((id): id is number => id != null)),
  ];
  type CrossEngineGen = {
    engine_id: number;
    engine_code: string;
    engine_display: string | null;
    brand_slug: string;
    brand_name: string;
    model_name: string;
    gen_slug: string;
    gen_display: string;
    start_year: number;
    end_year: number | null;
  };
  const crossEngineGens: CrossEngineGen[] =
    distinctEngineIds.length > 0
      ? await query<CrossEngineGen>(
          `SELECT DISTINCT e.id AS engine_id, e.code AS engine_code, e.display_name AS engine_display,
                  mk.slug AS brand_slug, mk.name AS brand_name, mdl.name AS model_name,
                  g.slug AS gen_slug, g.display_name AS gen_display,
                  g.start_year, g.end_year
           FROM trims t
           JOIN engines e         ON e.id = t.engine_id
           JOIN generations g     ON g.id = t.generation_id
           JOIN models mdl        ON mdl.id = g.model_id
           JOIN makes mk          ON mk.id = mdl.make_id
           WHERE t.engine_id IN (${distinctEngineIds.map(() => "?").join(",")})
             AND t.generation_id != ?
             AND g.is_active = 1
           ORDER BY e.code, g.start_year DESC
           LIMIT 24`,
          [...distinctEngineIds, gen.id],
        )
      : [];
  const crossByEngine = new Map<string, CrossEngineGen[]>();
  for (const c of crossEngineGens) {
    if (!crossByEngine.has(c.engine_code)) crossByEngine.set(c.engine_code, []);
    crossByEngine.get(c.engine_code)!.push(c);
  }

  // Native unit: EU gens store round km (÷5000) with non-round mile conversions;
  // US gens store round miles (÷2500). Pick whichever is "rounder" so the
  // by-distance matrix uses harmonious milestones (15k/30k/45k… not 12k/19k/25k).
  const mileageRows = services.filter((s) => s.km_normal != null || s.miles_normal != null);
  const kmRound = mileageRows.filter((s) => s.km_normal != null && s.km_normal % 5000 === 0).length;
  const milesRound = mileageRows.filter((s) => s.miles_normal != null && s.miles_normal % 2500 === 0).length;
  const unit: "km" | "mi" = kmRound > milesRound ? "km" : "mi";
  const distNormal = (s: ServiceRow) => (unit === "km" ? s.km_normal : s.miles_normal);
  const distOther = (s: ServiceRow) => (unit === "km" ? s.miles_normal : s.km_normal);
  const distCap = unit === "km" ? 250000 : 150000;

  // Build column headers from the native-unit normal-duty intervals
  const milestones = Array.from(
    new Set(
      services
        .map(distNormal)
        .filter((m): m is number => m !== null && m <= distCap),
    ),
  ).sort((a, b) => a - b);

  const oilSvc = services.find((s) => s.service === "engine_oil_and_filter");
  const plugSvc = services.find((s) => s.service === "spark_plugs");
  const brakeSvc = services.find((s) => s.service === "brake_fluid_flush");

  const distPhrase = (s: ServiceRow) => {
    const dn = distNormal(s);
    const other = distOther(s);
    if (dn == null) return s.months ? `${s.months} months` : "";
    return `${dn.toLocaleString()} ${unit}${other ? ` (${other.toLocaleString()} ${unit === "km" ? "mi" : "km"})` : ""}${s.months ? ` / ${s.months} months` : ""}`;
  };

  const faqs: Array<{ q: string; a: string }> = [];
  if (oilSvc && (distNormal(oilSvc) != null || oilSvc.months)) {
    faqs.push({
      q: `How often should the ${make.name} ${gen.display_name} get an oil change?`,
      a: `The ${make.name} ${gen.display_name} (${yrs}) needs an engine oil + filter change every ${distPhrase(oilSvc)} under normal duty.${oilSvc.notes ? ` ${oilSvc.notes}` : ""}`,
    });
  }
  if (plugSvc && distNormal(plugSvc) != null) {
    faqs.push({
      q: `When do the spark plugs need replacement on the ${make.name} ${gen.display_name}?`,
      a: `Spark plug replacement is due at ${distPhrase(plugSvc)} on the ${make.name} ${gen.display_name} (${yrs}).${plugSvc.notes ? ` ${plugSvc.notes}` : ""}`,
    });
  }
  if (brakeSvc?.months) {
    faqs.push({
      q: `How often does the ${make.name} ${gen.display_name} brake fluid need flushing?`,
      a: `Brake fluid flush interval is every ${brakeSvc.months} months on the ${make.name} ${gen.display_name} (${yrs}).${brakeSvc.notes ? ` ${brakeSvc.notes}` : ""}`,
    });
  }
  if (services.length > 0) {
    faqs.push({
      q: `What's in the maintenance schedule for the ${make.name} ${gen.display_name}?`,
      a: `The official maintenance schedule for the ${make.name} ${gen.display_name} (${yrs}) covers ${services.length} services across distance and time intervals — engine oil & filter, air and cabin filters, brake fluid, spark plugs or fuel filter, timing/drive belt and coolant. Intervals are given in ${unit === "km" ? "kilometres" : "miles"} and months.`,
    });
  }

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
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a>
          <span className="sep">/</span>
          <span>Maintenance schedule</span>
        </nav>

        <div className="pagehead">
          <h1>Maintenance schedule</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{services.length} services · 0 – 150,000 mi</span>
            {base.markets.length > 0 && (
              <>
                <span className="pip"></span>
                <span>{base.markets.map((m) => m.code).join(" · ")}</span>
              </>
            )}
          </div>
          <VerifyBadge
            sourceCount={sources.length}
            reviewDate={rev}
            scope="across"
          />
          <div
            style={{
              marginTop: 16,
              display: "flex",
              gap: 12,
              alignItems: "center",
              flexWrap: "wrap",
            }}
          >
            <span
              style={{
                fontSize: 12,
                fontWeight: 600,
                letterSpacing: "0.06em",
                textTransform: "uppercase",
                color: "var(--ink-soft)",
              }}
            >
              Duty schedule
            </span>
            <div className="duty-toggle" role="group">
              <button aria-pressed="true">Normal duty</button>
              <button>Severe duty</button>
            </div>
          </div>
        </div>
      </div>

      <GenerationTabs
        brand={make.slug}
        generation={gen.slug}
        active="maintenance"
        counts={{ maintenance: services.length }}
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">
            Service schedule
            <span className="count">
              {services.length} services · intervals in {unit === "km" ? "km" : "miles"}
            </span>
          </h2>
          <div className="table-scroll">
          <table className="maint-table">
            <thead>
              <tr>
                <th>Service</th>
                <th style={{ textAlign: "left", whiteSpace: "nowrap" }}>Interval</th>
                {milestones.map((m) => (
                  <th key={m} className="miles">
                    {m >= 1000 ? `${m / 1000}k` : m}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {services
                .filter((s) => distNormal(s) != null)
                .map((s) => {
                  const dn = distNormal(s)!;
                  const other = distOther(s);
                  return (
                  <tr key={s.id}>
                    <td className="svc">
                      {serviceLabel(s.service)}
                      {s.notes && (
                        <span
                          className="muted"
                          style={{ fontSize: 12, marginLeft: 8 }}
                        >
                          · {s.notes}
                        </span>
                      )}
                    </td>
                    <td style={{ whiteSpace: "nowrap", fontFamily: "var(--font-mono)", fontSize: 12 }}>
                      {dn.toLocaleString()} {unit}
                      {other ? ` / ${other.toLocaleString()} ${unit === "km" ? "mi" : "km"}` : ""}
                      {s.months ? ` · ${s.months} mo` : ""}
                    </td>
                    {milestones.map((m) => {
                      const due = m % dn === 0;
                      return (
                        <td key={m} className="dot">
                          {due && <span className="filled" />}
                        </td>
                      );
                    })}
                  </tr>
                  );
                })}
            </tbody>
          </table>
          </div>

          <div
            style={{
              marginTop: 16,
              padding: "12px 16px",
              background: "var(--bg-alt)",
              border: "1px solid var(--rule)",
              fontSize: 12,
              color: "var(--ink-soft)",
              lineHeight: 1.55,
            }}
          >
            <strong style={{ color: "var(--ink)", fontWeight: 600 }}>
              Severe duty
            </strong>{" "}
            applies when most operation involves stop-and-go traffic, ambient
            temperatures below −10 °C, prolonged idling, dusty environments, or
            repeated short trips under 8 km in cold weather. Toggle the duty
            switch above to see the accelerated schedule.<sup className="cite">[1]</sup>
          </div>
        </section>

        {/* Time-based services (months, no mileage) */}
        {services.some((s) => s.months && !s.miles_normal) && (
          <section>
            <h2 className="section-h">Time-based services</h2>
            <table className="spec-table">
              <tbody>
                {services
                  .filter((s) => s.months && !s.miles_normal)
                  .map((s) => (
                    <tr key={s.id}>
                      <th>{serviceLabel(s.service)}</th>
                      <td>
                        Every {s.months} months
                        {s.notes && (
                          <span className="alt"> · {s.notes}</span>
                        )}
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
          </section>
        )}

        {crossByEngine.size > 0 && (
          <section>
            <h2 className="section-h">
              Same engine, other vehicles
              <span className="count">{crossEngineGens.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Engines shared with other vehicles. Engine-scoped service intervals
              (spark plugs, timing belt, valve adjustment) are identical because
              they depend on the engine, not the chassis.
            </p>
            {Array.from(crossByEngine.entries()).map(([engineCode, gens]) => (
              <div key={engineCode} style={{ marginBottom: 12 }}>
                <div
                  style={{
                    fontSize: 11,
                    fontWeight: 600,
                    letterSpacing: "0.08em",
                    textTransform: "uppercase",
                    color: "var(--ink-soft)",
                    marginBottom: 6,
                    fontFamily: "var(--font-mono)",
                  }}
                >
                  {engineCode}
                  {gens[0].engine_display && (
                    <span style={{ color: "var(--ink-mute)", marginLeft: 8, fontWeight: 400, textTransform: "none", letterSpacing: 0 }}>
                      {gens[0].engine_display}
                    </span>
                  )}
                </div>
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
                  {gens.map((g) => {
                    const gyrs = g.end_year
                      ? `${g.start_year}–${g.end_year}`
                      : `${g.start_year}–present`;
                    return (
                      <li
                        key={`${g.brand_slug}/${g.gen_slug}`}
                        style={{ borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)" }}
                      >
                        <a
                          href={`/${g.brand_slug}/${g.gen_slug}/maintenance-schedule`}
                          style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                        >
                          <div style={{ fontWeight: 500 }}>
                            {g.brand_name} {g.gen_display}
                          </div>
                          <div className="muted" style={{ fontSize: 11, marginTop: 2, fontFamily: "var(--font-mono)" }}>
                            {gyrs} · maintenance →
                          </div>
                        </a>
                      </li>
                    );
                  })}
                </ul>
              </div>
            ))}
          </section>
        )}

        <section>
          <h2 className="section-h">Related</h2>
          <ul
            style={{
              listStyle: "none",
              display: "grid",
              gridTemplateColumns: "repeat(2, 1fr)",
              border: "1px solid var(--rule)",
            }}
          >
            {[
              {
                href: `/${make.slug}/${gen.slug}/oil-capacity`,
                name: "Engine oil capacity & viscosity",
                peek: "Every engine variant · filter PN · drain torque",
              },
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Torque specifications",
                peek: "Lug nuts · spark plug · drain plug · hub nut",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Engine, performance, dimensions, drivetrain",
              },
              {
                href: `/${make.slug}/${gen.slug}/procedures`,
                name: "Service procedures",
                peek: "Oil reset · TPMS · battery · jump-start",
              },
              {
                href: `/guides/severe-duty-vs-normal-duty`,
                name: "Severe duty vs normal duty",
                peek: "When the shorter schedule applies to your car",
              },
            ].map((l) => (
              <li
                key={l.name}
                style={{
                  padding: "12px 16px",
                  borderRight: "1px solid var(--rule)",
                  borderBottom: "1px solid var(--rule)",
                  fontSize: 13,
                }}
              >
                <a
                  href={l.href}
                  style={{ color: "var(--ink)", fontWeight: 500 }}
                >
                  {l.name}
                </a>
                <span
                  style={{
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: "var(--ink-mute)",
                    marginLeft: 12,
                  }}
                >
                  {l.peek}
                </span>
              </li>
            ))}
          </ul>
        </section>

        <SourcesBlock sources={sources} />
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
