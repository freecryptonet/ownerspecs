import { notFound } from "next/navigation";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { buildCitationIndex } from "@/lib/citations";
import { Cites } from "./Cites";
import { SiteHeader } from "./SiteHeader";
import { SiteFooter } from "./SiteFooter";
import { GenerationTabs } from "./GenerationTabs";
import { VerifyBadge } from "./VerifyBadge";
import { faqJsonLd, datasetJsonLd, breadcrumbsJsonLd } from "@/lib/seo";

type Row = {
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
  engine_id: number | null;
  engine_code: string | null;
  engine_display: string | null;
  engine_displacement_cc: number | null;
};

type EngineLite = { id: number; code: string };
type TrimLite = { id: number; hp: number | null; engine_id: number | null };

export type FluidTopicConfig = {
  slug: string;
  label: string;
  h1: string;
  fluidTypes: string[];
  buildFaq(args: {
    make: string;
    gen: string;
    yrs: string;
    primary: Row | undefined;
    all: Row[];
  }): Array<{ q: string; a: string }>;
  lede(args: { make: string; gen: string; yrs: string }): string;
};

// Engine-scoped fluid types: a NULL engine_id on a multi-engine gen for these
// types is provisional and must be suppressed rather than rendered as a
// single value across all trims (the E-E-A-T bug behind the whole rebuild).
const ENGINE_SCOPED = new Set([
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

const PRETTY_FLUID: Record<string, string> = {
  engine_oil: "Engine oil",
  transmission_at: "Automatic transmission",
  transmission_cvt: "CVT",
  transmission_ecvt: "Hybrid eCVT",
  transmission_mt: "Manual transmission",
  transmission_dct: "DCT / DSG",
  coolant: "Coolant",
  brake: "Brake fluid",
  ac_refrigerant: "A/C refrigerant",
  power_steering: "Power steering",
  haldex_oil: "Haldex (AWD coupling)",
  front_differential: "Front differential",
  rear_differential: "Rear differential",
  transfer_case: "Transfer case",
  gear_reducer_front: "Front motor gearbox",
  gear_reducer_rear: "Rear motor gearbox",
  washer_fluid: "Washer fluid",
};

function fmtCap(l: string | null, qt: string | null): string {
  if (!l && !qt) return "—";
  if (l && qt) return `${Number(qt).toFixed(2)} qt · ${Number(l).toFixed(2)} L`;
  if (l) return `${Number(l).toFixed(2)} L`;
  return `${Number(qt).toFixed(2)} qt`;
}

export async function FluidTopicPage({
  brand,
  generation,
  config,
}: {
  brand: string;
  generation: string;
  config: FluidTopicConfig;
}) {
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;
  const yrs = yearRange(gen.start_year, gen.end_year);

  const placeholders = config.fluidTypes.map(() => "?").join(",");

  // Resolve engine via direct f.engine_id OR via f.trim_id → t.engine_id.
  // Order by engine displacement so V6 < V8 < SC reads top to bottom.
  const rows = await query<Row>(
    `SELECT f.id, f.fluid_type,
            f.capacity_l, f.capacity_qt, f.viscosity, f.spec_standard,
            f.filter_part_no, f.drain_interval_mi, f.drain_interval_km,
            f.drain_interval_months, f.notes,
            COALESCE(e_direct.id, e_via_trim.id)                  AS engine_id,
            COALESCE(e_direct.code, e_via_trim.code)              AS engine_code,
            COALESCE(e_direct.display_name, e_via_trim.display_name) AS engine_display,
            COALESCE(e_direct.displacement_cc, e_via_trim.displacement_cc) AS engine_displacement_cc
     FROM fluid_specs f
     LEFT JOIN trims t            ON t.id  = f.trim_id
     LEFT JOIN engines e_direct   ON e_direct.id   = f.engine_id
     LEFT JOIN engines e_via_trim ON e_via_trim.id = t.engine_id
     WHERE f.generation_id = ? AND f.fluid_type IN (${placeholders})
     ORDER BY FIELD(f.fluid_type, ${placeholders}),
              (COALESCE(e_direct.displacement_cc, e_via_trim.displacement_cc) IS NULL) ASC,
              COALESCE(e_direct.displacement_cc, e_via_trim.displacement_cc) ASC,
              f.id`,
    [gen.id, ...config.fluidTypes, ...config.fluidTypes],
  );

  if (rows.length === 0) notFound();

  // Signals for multi-engine detection (same heuristic as the gen page):
  //   1) DB has >1 distinct engine for this gen (via trims)
  //   2) trims with different HP suggest multiple engines even if engine_id NULL
  //   3) some fluid row is already engine-scoped (the gen has been split)
  const engineList = await query<EngineLite>(
    `SELECT DISTINCT e.id, e.code
     FROM engines e JOIN trims t ON t.engine_id = e.id
     WHERE t.generation_id = ?`,
    [gen.id],
  );
  const trimList = await query<TrimLite>(
    `SELECT id, hp, engine_id FROM trims WHERE generation_id = ?`,
    [gen.id],
  );
  const distinctHps = new Set(trimList.map((t) => t.hp).filter((h): h is number => h != null));
  const someRowScoped = rows.some((r) => r.engine_id != null);
  const multiEngine = engineList.length > 1 || distinctHps.size > 1 || someRowScoped;

  // Split rows into rendered + suppressed.
  const rendered: Row[] = [];
  const suppressedTypes = new Set<string>();
  for (const r of rows) {
    if (r.engine_id == null && multiEngine && ENGINE_SCOPED.has(r.fluid_type)) {
      suppressedTypes.add(r.fluid_type);
    } else {
      rendered.push(r);
    }
  }
  const provisionalSuppressed = suppressedTypes.size;

  // Citation index restricted to rows this page actually renders (post-
  // suppression). Keeps the Sources block in lockstep with [N] footnotes.
  const citations = await buildCitationIndex(
    gen.id,
    rendered.map((r) => ({ table: "fluid_specs", id: r.id })),
  );
  const sources = citations.sources;
  const rev = reviewDate(sources);

  // Cross-vehicle engine matches — herstructureringsplan §4. Links to OTHER
  // generations that share an engine with this gen, pointing at their SAME
  // topic page (config.slug). Engine-scoped fluids (oil, coolant, trans)
  // share values across vehicles with the same engine, so this routes the
  // SEO signal of "N55 oil capacity" / "B58 coolant" topical queries.
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
  const crossByEngine = new Map<string, CrossEngineGen[]>();
  for (const c of crossEngineGens) {
    if (!crossByEngine.has(c.engine_code)) crossByEngine.set(c.engine_code, []);
    crossByEngine.get(c.engine_code)!.push(c);
  }

  const primary = rendered[0] ?? rows[0];
  const faqs = config.buildFaq({
    make: make.name,
    gen: gen.display_name,
    yrs,
    primary,
    all: rendered,
  });

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
              topic: { label: config.label, path: `/${make.slug}/${gen.slug}/${config.slug}` },
            }),
            datasetJsonLd({
              name: `${make.name} ${gen.display_name} ${yrs} — ${config.label}`,
              description: `Per-engine ${config.label.toLowerCase()} comparison for the ${make.name} ${gen.display_name} (${yrs}). Cross-verified across multiple sources, per-row citations.`,
              path: `/${make.slug}/${gen.slug}/${config.slug}`,
              reviewDate: rev,
              variables: [
                { name: "Capacity", unitText: "L / US qt" },
                { name: "Viscosity / specification" },
                { name: "Service interval", unitText: "miles / km / months" },
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
          <span>{config.label}</span>
        </nav>

        <div className="pagehead">
          <h1>{config.h1}</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>
              {rendered.length} engine {rendered.length === 1 ? "variant" : "variants"} compared
            </span>
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
            {config.lede({ make: make.name, gen: gen.display_name, yrs })}
          </p>
        </section>

        <section>
          <h2 className="section-h">
            {config.label} by engine
            <span className="count">
              {rendered.length} {rendered.length === 1 ? "row" : "rows"}
            </span>
          </h2>
          <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
            One row per engine variant. Each row links to the cross-verified sources used.
            {provisionalSuppressed > 0 && (
              <>
                {" "}
                <strong style={{ color: "var(--ink-soft)" }}>
                  {provisionalSuppressed === 1 ? "One row" : `${provisionalSuppressed} rows`}{" "}
                  ({[...suppressedTypes].map((t) => PRETTY_FLUID[t] ?? t).join(", ")}){" "}
                  {provisionalSuppressed === 1 ? "is" : "are"} pending per-engine verification
                  and {provisionalSuppressed === 1 ? "has been" : "have been"} suppressed rather than
                  displayed as one value across {trimList.length} {trimList.length === 1 ? "trim" : "trims"}.
                </strong>
              </>
            )}
          </p>
          {rendered.length > 0 ? (
            <div className="table-scroll">
              <table className="spec-table">
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>
                    {["Engine / location", "Capacity", "Viscosity / spec", "Filter PN", "Service interval", "Notes"].map((h) => (
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
                  {rendered.map((r) => {
                    const cap = fmtCap(r.capacity_l, r.capacity_qt);
                    const spec = [r.viscosity, r.spec_standard].filter(Boolean).join(" · ") || "—";
                    const interval = r.drain_interval_mi
                      ? `${r.drain_interval_mi.toLocaleString()} mi${r.drain_interval_km ? ` / ${r.drain_interval_km.toLocaleString()} km` : ""}`
                      : r.drain_interval_months
                        ? `${r.drain_interval_months} months`
                        : "—";
                    const engineLabel = r.engine_id
                      ? (r.engine_display || r.engine_code || `engine #${r.engine_id}`)
                      : (PRETTY_FLUID[r.fluid_type] ?? r.fluid_type);
                    const showFluidTag = config.fluidTypes.length > 1 || !r.engine_id;
                    return (
                      <tr key={r.id}>
                        <th style={{ whiteSpace: "nowrap" }}>
                          <strong style={{ color: "var(--ink)" }}>{engineLabel}</strong>
                          {showFluidTag && r.engine_id && (
                            <span className="alt" style={{ display: "block", fontSize: 11, fontWeight: 400 }}>
                              {PRETTY_FLUID[r.fluid_type] ?? r.fluid_type}
                            </span>
                          )}
                          <Cites nums={citations.citationsFor("fluid_specs", r.id)} />
                        </th>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}>{cap}</td>
                        <td>{spec}</td>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}>{r.filter_part_no ?? "—"}</td>
                        <td className="tnum" style={{ whiteSpace: "nowrap" }}>{interval}</td>
                        <td className="alt">{r.notes ?? "—"}</td>
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
                  <dd style={{ margin: 0, color: "var(--ink-soft)", fontSize: 13, lineHeight: 1.55 }}>
                    {f.a}
                  </dd>
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
              Engines shared with other vehicles. {config.label} values are identical
              because they are engine-scoped specs — only the chassis differs.
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
                          href={`/${g.brand_slug}/${g.gen_slug}/${config.slug}`}
                          style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                        >
                          <div style={{ fontWeight: 500 }}>
                            {g.brand_name} {g.gen_display}
                          </div>
                          <div className="muted" style={{ fontSize: 11, marginTop: 2, fontFamily: "var(--font-mono)" }}>
                            {gyrs} · {config.label.toLowerCase()} →
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
              { href: `/${make.slug}/${gen.slug}/oil-capacity`, name: "Engine oil capacity", peek: "Capacity · viscosity · filter PN" },
              { href: `/${make.slug}/${gen.slug}/coolant`, name: "Coolant", peek: "Type · capacity · service interval" },
              { href: `/${make.slug}/${gen.slug}/transmission-fluid`, name: "Transmission fluid", peek: "ATF · CVT · DCT · manual" },
              { href: `/${make.slug}/${gen.slug}/torque`, name: "Torque specifications", peek: "Per-engine and gen-wide fasteners" },
              { href: `/${make.slug}/${gen.slug}/maintenance-schedule`, name: "Maintenance schedule", peek: "When each fluid is serviced" },
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
