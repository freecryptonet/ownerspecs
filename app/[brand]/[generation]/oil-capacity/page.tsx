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
import { pageMetadata, breadcrumbsJsonLd, techArticleJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type OilRow = {
  id: number;
  fluid_type: string;
  market_code: string | null;
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
  drain_interval_mi: number | null;
  drain_interval_km: number | null;
  drain_interval_months: number | null;
  notes: string | null;
  trim_name: string | null;
  engine_code: string | null;
  engine_display: string | null;
};

function rowLabel(o: { engine_display: string | null; trim_name: string | null; fluid_type: string }): string {
  if (o.engine_display && o.trim_name) return `${o.engine_display} — ${o.trim_name}`;
  if (o.engine_display) return o.engine_display;
  if (o.trim_name) return o.trim_name;
  return "All engines · generation-wide";
}

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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Engine oil capacity & viscosity`,
    description: `Engine oil capacity, viscosity grade, oil filter part number and drain interval for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Every engine variant, every market. Cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/oil-capacity`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const oils = await query<OilRow>(
    `SELECT f.id, f.fluid_type, mk.code AS market_code, f.capacity_l, f.capacity_qt,
            f.viscosity, f.spec_standard, f.filter_part_no, f.drain_interval_mi,
            f.drain_interval_km, f.drain_interval_months, f.notes,
            t.name AS trim_name, e.code AS engine_code, e.display_name AS engine_display
     FROM fluid_specs f
     LEFT JOIN markets mk ON mk.id = f.market_id
     LEFT JOIN trims t    ON t.id  = f.trim_id
     LEFT JOIN engines e  ON e.id  = t.engine_id
     WHERE f.generation_id = ?
       AND f.fluid_type LIKE 'engine_oil%'
     ORDER BY FIELD(f.fluid_type, 'engine_oil', 'engine_oil_2_0', 'engine_oil_1_0t', 'engine_oil_diesel'),
              -- prefer fully-populated rows over scraper leftovers when duplicates exist
              (f.viscosity IS NULL) ASC, (f.spec_standard IS NULL) ASC, (f.filter_part_no IS NULL) ASC`,
    [gen.id],
  );

  if (oils.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "fluid_specs");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Primary answer = first row (typically the highest-volume trim)
  const primary = oils[0];

  // Service-bulletin / dilution warning if any oil row has notes mentioning dilution or severe-duty interval revision
  const bulletinRow = oils.find(
    (o) => o.notes && /dilution|severe|cold-climate/i.test(o.notes),
  );

  return (
    <>
      <SiteHeader />

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
          <span>Engine oil</span>
        </nav>

        <div className="pagehead">
          <h1>Engine oil capacity &amp; viscosity</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{oils.length} engine {oils.length === 1 ? "variant" : "variants"}</span>
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
        </div>
      </div>

      <GenerationTabs
        brand={make.slug}
        generation={gen.slug}
        active="fluids"
        counts={{}}
      />

      <main className="shell">
        {/* ANSWER CARD — primary engine variant */}
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">{rowLabel(primary)}</h2>
          <div className="answer-card">
            <div>
              <div className="a-label">Capacity with new filter</div>
              <div className="a-big">
                {primary.capacity_qt && Number(primary.capacity_qt).toFixed(1)}
                <span className="u">
                  US qt · {primary.capacity_l && Number(primary.capacity_l).toFixed(1)} L
                </span>
              </div>
              <div className="a-sub">
                {primary.viscosity}
                {primary.spec_standard && ` · ${primary.spec_standard}`}
                {primary.notes && primary.notes.length < 80 && ` · ${primary.notes}`}
                {sources.length > 0 && (
                  <sup className="cite">
                    {sources.map((_, i) => `[${i + 1}]`).join("")}
                  </sup>
                )}
              </div>
            </div>
            <table className="ib-table" style={{ border: 0 }}>
              <tbody>
                <tr>
                  <th>With new filter</th>
                  <td>
                    {primary.capacity_qt} US qt · {primary.capacity_l} L
                  </td>
                </tr>
                <tr>
                  <th>Viscosity grade</th>
                  <td>{primary.viscosity}</td>
                </tr>
                <tr>
                  <th>Specification</th>
                  <td>{primary.spec_standard}</td>
                </tr>
                {primary.drain_interval_mi && (
                  <tr>
                    <th>Drain interval (normal)</th>
                    <td>
                      {primary.drain_interval_mi.toLocaleString()} mi ·{" "}
                      {primary.drain_interval_km?.toLocaleString()} km
                    </td>
                  </tr>
                )}
                {primary.drain_interval_months && (
                  <tr>
                    <th>Time-based</th>
                    <td>{primary.drain_interval_months} months</td>
                  </tr>
                )}
                {primary.filter_part_no && (
                  <tr>
                    <th>Filter part number</th>
                    <td>{primary.filter_part_no}</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* ALL ENGINES MATRIX */}
        <section>
          <h2 className="section-h">
            All engines · oil capacity matrix
            <span className="count">{oils.length} variants</span>
          </h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                {[
                  "Engine",
                  "Market",
                  "With filter",
                  "Viscosity",
                  "Spec.",
                  "Filter PN",
                  "Drain interval",
                ].map((h) => (
                  <th
                    key={h}
                    style={{
                      fontSize: 11,
                      fontWeight: 600,
                      letterSpacing: "0.08em",
                      textTransform: "uppercase",
                      color: "var(--ink-soft)",
                      textAlign: "left",
                      padding: "8px 12px",
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {oils.map((o) => (
                <tr key={o.id}>
                  <th>
                    <strong style={{ color: "var(--ink)" }}>{rowLabel(o)}</strong>
                  </th>
                  <td>{o.market_code ?? "global"}</td>
                  <td>
                    <strong>
                      {o.capacity_qt && Number(o.capacity_qt).toFixed(1)} qt
                    </strong>
                    <span className="alt">
                      {" "}
                      · {o.capacity_l && Number(o.capacity_l).toFixed(1)} L
                    </span>
                  </td>
                  <td>{o.viscosity}</td>
                  <td>{o.spec_standard}</td>
                  <td>{o.filter_part_no ?? "—"}</td>
                  <td>
                    {o.drain_interval_mi
                      ? `${o.drain_interval_mi.toLocaleString()} mi`
                      : o.drain_interval_months
                        ? `${o.drain_interval_months} months`
                        : "—"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* SERVICE BULLETIN (conditional) */}
        {bulletinRow && (
          <section>
            <h2 className="section-h">Service-bulletin notes</h2>
            <div
              style={{
                background: "var(--warn-bg)",
                border: "1px solid var(--warn)",
                borderLeft: "3px solid var(--warn)",
                padding: "16px 20px",
                fontSize: 13,
                lineHeight: 1.55,
                display: "grid",
                gridTemplateColumns: "auto 1fr",
                gap: 16,
                alignItems: "start",
              }}
            >
              <svg
                width="20"
                height="20"
                viewBox="0 0 20 20"
                fill="none"
                stroke="var(--warn)"
                strokeWidth="1.6"
                style={{ marginTop: 2 }}
              >
                <path d="M10 3v7" />
                <circle cx="10" cy="14" r="1" />
                <circle cx="10" cy="10" r="8" />
              </svg>
              <div>
                <p>{bulletinRow.notes}</p>
                <p style={{ marginTop: 8, color: "var(--ink-soft)" }}>
                  If the dipstick reads above the upper mark or the oil smells
                  of fuel, the affected VIN range and updated drain interval
                  likely applies. Dealer reprogramming is free under the
                  manufacturer revision.
                </p>
              </div>
            </div>
          </section>
        )}

        {/* RELATED — quick links back into the cluster */}
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
                href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                name: "Full maintenance schedule",
                peek: "By-mileage · normal & severe duty",
              },
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Torque specifications",
                peek: "Drain plug 30 ft·lb · 5 fasteners total",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Full specifications · all engines",
              },
              {
                href: `/${make.slug}/${gen.slug}#fluids-all`,
                name: "All fluids · other lubricants",
                peek: "CVT · coolant · brake · A/C refrigerant",
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
