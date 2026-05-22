import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getAllGenerationParams,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { buildCitationIndex } from "@/lib/citations";
import { Cites } from "@/components/Cites";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { pageMetadata, breadcrumbsJsonLd, datasetJsonLd, faqJsonLd } from "@/lib/seo";

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
  engine_id: number | null;
  engine_code: string | null;
  engine_display: string | null;
};

type EngineLite = { id: number };
type TrimLite = { id: number; hp: number | null; engine_id: number | null };

const ENGINE_OIL_TYPES = ["engine_oil", "engine_oil_2_0", "engine_oil_1_0t", "engine_oil_diesel"];

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
    description: `Engine oil capacity, viscosity grade, oil filter part number and drain interval for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Per-engine comparison, cross-verified, per-row sources.`,
    path: `/${base.make.slug}/${base.gen.slug}/oil-capacity`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;
  const yrs = yearRange(gen.start_year, gen.end_year);

  const oils = await query<OilRow>(
    `SELECT f.id, f.fluid_type, mk.code AS market_code, f.capacity_l, f.capacity_qt,
            f.viscosity, f.spec_standard, f.filter_part_no, f.drain_interval_mi,
            f.drain_interval_km, f.drain_interval_months, f.notes,
            t.name AS trim_name,
            COALESCE(e_direct.id, e_via_trim.id)                  AS engine_id,
            COALESCE(e_direct.code, e_via_trim.code)              AS engine_code,
            COALESCE(e_direct.display_name, e_via_trim.display_name) AS engine_display
     FROM fluid_specs f
     LEFT JOIN markets mk         ON mk.id = f.market_id
     LEFT JOIN trims t            ON t.id  = f.trim_id
     LEFT JOIN engines e_direct   ON e_direct.id   = f.engine_id
     LEFT JOIN engines e_via_trim ON e_via_trim.id = t.engine_id
     WHERE f.generation_id = ?
       AND f.fluid_type IN (${ENGINE_OIL_TYPES.map(() => "?").join(",")})
     ORDER BY FIELD(f.fluid_type, 'engine_oil', 'engine_oil_2_0', 'engine_oil_1_0t', 'engine_oil_diesel'),
              (COALESCE(e_direct.displacement_cc, e_via_trim.displacement_cc) IS NULL) ASC,
              COALESCE(e_direct.displacement_cc, e_via_trim.displacement_cc) ASC,
              f.id`,
    [gen.id, ...ENGINE_OIL_TYPES],
  );

  if (oils.length === 0) notFound();

  // Multi-engine detection — same heuristic as gen + FluidTopicPage.
  const engineList = await query<EngineLite>(
    `SELECT DISTINCT e.id FROM engines e JOIN trims t ON t.engine_id = e.id WHERE t.generation_id = ?`,
    [gen.id],
  );
  const trimList = await query<TrimLite>(
    `SELECT id, hp, engine_id FROM trims WHERE generation_id = ?`,
    [gen.id],
  );
  const distinctHps = new Set(trimList.map((t) => t.hp).filter((h): h is number => h != null));
  const someRowScoped = oils.some((r) => r.engine_id != null);
  const multiEngine = engineList.length > 1 || distinctHps.size > 1 || someRowScoped;

  const rendered: OilRow[] = [];
  let suppressedCount = 0;
  for (const r of oils) {
    if (r.engine_id == null && multiEngine) {
      suppressedCount++;
    } else {
      rendered.push(r);
    }
  }

  const citations = await buildCitationIndex(
    gen.id,
    rendered.map((r) => ({ table: "fluid_specs", id: r.id })),
  );
  const sources = citations.sources;
  const rev = reviewDate(sources);

  // Cross-vehicle engine matches — herstructureringsplan §4 "Same N55B30A engine?
  // Zie ook BMW 5 Series F10 535i oil capacity". For every engine_id present on
  // this gen's oil rows, list other generations that share the engine and link
  // directly to THEIR oil-capacity page. Drives engine-code topical SEO.
  const distinctEngineIds = [
    ...new Set(rendered.map((r) => r.engine_id).filter((id): id is number => id != null)),
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
  // Group cross-vehicle matches by engine so the visitor sees "N55B30A: BMW 535i, X3 35i" not a flat list.
  const crossByEngine = new Map<string, CrossEngineGen[]>();
  for (const c of crossEngineGens) {
    const key = c.engine_code;
    if (!crossByEngine.has(key)) crossByEngine.set(key, []);
    crossByEngine.get(key)!.push(c);
  }

  // Service-bulletin / dilution warning (kept) — pull from any rendered row
  const bulletinRow = rendered.find(
    (o) => o.notes && /dilution|severe|cold-climate/i.test(o.notes),
  );

  // FAQ — guarded for multi-engine: only emit "what is X" if we have a clear
  // single value (un-suppressed primary row). Otherwise emit a "varies by engine"
  // answer that lists the range, so we never lie via JSON-LD.
  const primary = rendered[0];
  const faqs: Array<{ q: string; a: string }> = [];
  if (primary && rendered.length === 1) {
    if (primary.capacity_qt && primary.capacity_l) {
      faqs.push({
        q: `What is the oil capacity of the ${make.name} ${gen.display_name}?`,
        a: `The ${make.name} ${gen.display_name} (${yrs}) holds ${Number(primary.capacity_qt).toFixed(1)} US qt (${Number(primary.capacity_l).toFixed(1)} L) of engine oil with a new filter${primary.engine_display ? ` on the ${primary.engine_display}` : ""}.`,
      });
    }
    if (primary.viscosity) {
      faqs.push({
        q: `What oil viscosity does the ${make.name} ${gen.display_name} use?`,
        a: `${primary.viscosity}${primary.spec_standard ? `, meeting ${primary.spec_standard}` : ""} is the manufacturer-specified viscosity for the ${make.name} ${gen.display_name} (${yrs}).`,
      });
    }
    if (primary.filter_part_no) {
      faqs.push({
        q: `What oil filter fits the ${make.name} ${gen.display_name}?`,
        a: `The OE oil filter part number for the ${make.name} ${gen.display_name} (${yrs}) is ${primary.filter_part_no}${primary.engine_code ? ` on the ${primary.engine_code} engine` : ""}.`,
      });
    }
    if (primary.drain_interval_mi) {
      faqs.push({
        q: `How often should the oil be changed on the ${make.name} ${gen.display_name}?`,
        a: `The manufacturer-recommended oil change interval for the ${make.name} ${gen.display_name} (${yrs}) is ${primary.drain_interval_mi.toLocaleString()} miles${primary.drain_interval_km ? ` / ${primary.drain_interval_km.toLocaleString()} km` : ""}${primary.drain_interval_months ? ` or ${primary.drain_interval_months} months, whichever comes first` : ""}.`,
      });
    }
  } else if (rendered.length > 1) {
    const caps = rendered.map((r) => r.capacity_l).filter((c): c is string => c != null).map(Number);
    const viscs = [...new Set(rendered.map((r) => r.viscosity).filter(Boolean))];
    if (caps.length >= 2) {
      const min = Math.min(...caps), max = Math.max(...caps);
      faqs.push({
        q: `What is the oil capacity of the ${make.name} ${gen.display_name}?`,
        a: `Oil capacity varies by engine on the ${make.name} ${gen.display_name} (${yrs}): from ${min.toFixed(1)} L on the smallest engine to ${max.toFixed(1)} L on the largest. See the per-engine table on this page for the exact value for your trim.`,
      });
    }
    if (viscs.length === 1 && viscs[0]) {
      faqs.push({
        q: `What oil viscosity does the ${make.name} ${gen.display_name} use?`,
        a: `${viscs[0]} is shared across every engine on the ${make.name} ${gen.display_name} (${yrs}).`,
      });
    } else if (viscs.length > 1) {
      faqs.push({
        q: `What oil viscosity does the ${make.name} ${gen.display_name} use?`,
        a: `Multiple viscosities apply across the ${make.name} ${gen.display_name} (${yrs}) lineup: ${viscs.join(", ")}. The per-engine table on this page maps each viscosity to the correct engine.`,
      });
    }
  }

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
              topic: { label: "Engine oil", path: `/${make.slug}/${gen.slug}/oil-capacity` },
            }),
            datasetJsonLd({
              name: `${make.name} ${gen.display_name} ${yrs} — Engine oil capacity`,
              description: `Per-engine oil capacity, viscosity, OEM specification, filter PN and drain interval for the ${make.name} ${gen.display_name} (${yrs}). Cross-verified, per-row sources.`,
              path: `/${make.slug}/${gen.slug}/oil-capacity`,
              reviewDate: rev,
              variables: [
                { name: "Capacity with new filter", unitText: "L / US qt" },
                { name: "Viscosity grade" },
                { name: "OEM specification" },
                { name: "Filter part number" },
                { name: "Drain interval", unitText: "miles / km / months" },
              ],
            }),
            ...(faqs.length >= 2 ? [faqJsonLd(faqs)] : []),
          ]),
        }}
      />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a><span className="sep">/</span>
          <span>Engine oil</span>
        </nav>

        <div className="pagehead">
          <h1>Engine oil capacity &amp; viscosity</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{rendered.length} engine {rendered.length === 1 ? "variant" : "variants"} compared</span>
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
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <p style={{ maxWidth: 720, color: "var(--ink-soft)", fontSize: 14, lineHeight: 1.55 }}>
            Oil capacity, viscosity grade, OEM specification, and filter part number for every engine variant of the {make.name} {gen.display_name} ({yrs}).
            Click any row to inspect its source citations. Capacity figures are the dry-fill value with a new filter.
          </p>
        </section>

        <section>
          <h2 className="section-h">
            Oil capacity by engine
            <span className="count">{rendered.length} {rendered.length === 1 ? "row" : "rows"}</span>
          </h2>
          <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
            One row per engine variant. Per-row footnotes link to the sources used.
            {suppressedCount > 0 && (
              <>
                {" "}
                <strong style={{ color: "var(--ink-soft)" }}>
                  {suppressedCount} {suppressedCount === 1 ? "legacy row is" : "legacy rows are"}{" "}
                  flagged as &ldquo;all engines&rdquo; in the database. {suppressedCount === 1 ? "It has" : "They have"}{" "}
                  been suppressed rather than displayed against {trimList.length} different trims, because
                  oil capacity changes with engine displacement.
                </strong>
              </>
            )}
          </p>
          {rendered.length > 0 ? (
            <div className="table-scroll">
              <table className="spec-table">
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>
                    {["Engine", "Capacity (w/ filter)", "Viscosity", "Spec", "Filter PN", "Drain interval"].map((h) => (
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
                          whiteSpace: "nowrap",
                        }}
                      >
                        {h}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {rendered.map((o) => {
                    const cap = o.capacity_qt && o.capacity_l
                      ? `${Number(o.capacity_qt).toFixed(1)} qt · ${Number(o.capacity_l).toFixed(1)} L`
                      : o.capacity_l ? `${Number(o.capacity_l).toFixed(1)} L` : "—";
                    const interval = o.drain_interval_mi
                      ? `${o.drain_interval_mi.toLocaleString()} mi${o.drain_interval_km ? ` / ${o.drain_interval_km.toLocaleString()} km` : ""}`
                      : o.drain_interval_months
                        ? `${o.drain_interval_months} months`
                        : "—";
                    const engineLabel = o.engine_id
                      ? (o.engine_display || o.engine_code || `engine #${o.engine_id}`)
                      : "All engines";
                    return (
                      <tr key={o.id}>
                        <th style={{ whiteSpace: "nowrap" }}>
                          <strong style={{ color: "var(--ink)" }}>{engineLabel}</strong>
                          <Cites nums={citations.citationsFor("fluid_specs", o.id)} />
                        </th>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}><strong>{cap}</strong></td>
                        <td style={{ whiteSpace: "nowrap" }}>{o.viscosity ?? "—"}</td>
                        <td>{o.spec_standard ?? "—"}</td>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}>{o.filter_part_no ?? "—"}</td>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}>{interval}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          ) : (
            <p style={{ fontSize: 13, color: "var(--ink-soft)", padding: "16px 0" }}>
              Per-engine data is pending verification — see the note above. The{" "}
              <a href={`/${make.slug}/${gen.slug}`} style={{ color: "var(--accent)" }}>
                generation overview
              </a>{" "}
              is the most complete page until each engine variant has its own confirmed source.
            </p>
          )}
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
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="var(--warn)" strokeWidth="1.6" style={{ marginTop: 2 }}>
                <path d="M10 3v7" />
                <circle cx="10" cy="14" r="1" />
                <circle cx="10" cy="10" r="8" />
              </svg>
              <div>
                <p>{bulletinRow.notes}</p>
                <p style={{ marginTop: 8, color: "var(--ink-soft)" }}>
                  Affects {bulletinRow.engine_display ?? "the affected engine variant"}.
                  If the dipstick reads above the upper mark or the oil smells of fuel,
                  the affected VIN range and updated drain interval likely applies.
                  Dealer reprogramming is free under the manufacturer revision.
                </p>
              </div>
            </div>
          </section>
        )}

        {faqs.length > 0 && (
          <section>
            <h2 className="section-h">
              Frequently asked
              <span className="count">{faqs.length}</span>
            </h2>
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

        {crossByEngine.size > 0 && (
          <section>
            <h2 className="section-h">
              Same engine, other vehicles
              <span className="count">{crossEngineGens.length}</span>
            </h2>
            <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
              Engines shared with other vehicles in our catalogue. Oil capacity and viscosity
              are identical because they are engine-scoped specs — only the chassis differs.
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
                          href={`/${g.brand_slug}/${g.gen_slug}/oil-capacity`}
                          style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                        >
                          <div style={{ fontWeight: 500 }}>
                            {g.brand_name} {g.gen_display}
                          </div>
                          <div className="muted" style={{ fontSize: 11, marginTop: 2, fontFamily: "var(--font-mono)" }}>
                            {gyrs} · oil capacity →
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
              padding: 0,
              margin: 0,
            }}
          >
            {[
              { href: `/${make.slug}/${gen.slug}/coolant`, name: "Coolant", peek: "Type · capacity · service interval" },
              { href: `/${make.slug}/${gen.slug}/transmission-fluid`, name: "Transmission fluid", peek: "ATF · CVT · DCT · manual" },
              { href: `/${make.slug}/${gen.slug}/brake-fluid`, name: "Brake fluid", peek: "DOT spec · flush interval" },
              { href: `/${make.slug}/${gen.slug}/torque`, name: "Torque", peek: "Drain plug · spark plug · per-engine" },
              { href: `/${make.slug}/${gen.slug}/maintenance-schedule`, name: "Full maintenance schedule", peek: "By-mileage · normal & severe duty" },
              { href: `/${make.slug}/${gen.slug}`, name: "Generation overview", peek: "All variants side-by-side" },
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
                <a href={l.href} style={{ color: "var(--ink)", fontWeight: 500 }}>{l.name}</a>
                <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)", marginLeft: 12 }}>
                  {l.peek}
                </span>
              </li>
            ))}
          </ul>
        </section>

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
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
