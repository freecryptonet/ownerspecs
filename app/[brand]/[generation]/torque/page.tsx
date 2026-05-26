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
import { torqueLabel as fastenerLabel } from "@/lib/labels";
import { pageMetadata, breadcrumbsJsonLd, datasetJsonLd, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type TorqueRow = {
  id: number;
  fastener: string;
  engine_id: number | null;
  engine_code: string | null;
  engine_display: string | null;
  torque_nm: number | null;
  torque_ftlb: number | null;
  thread_lock: string | null;
  notes: string | null;
};

type EngineLite = { id: number };
type TrimLite = { id: number; hp: number | null; engine_id: number | null };

// Fasteners whose value genuinely changes by engine — spark plug torque,
// oil drain torque, head/cam/manifold bolts. NULL engine_id on a multi-engine
// gen for these is provisional and gets suppressed.
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Torque specifications`,
    description: `Torque values for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Wheel lug nuts, spark plug, oil drain, suspension fasteners. N·m + ft·lb, per-engine where applicable, per-row sources.`,
    path: `/${base.make.slug}/${base.gen.slug}/torque`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;
  const yrs = yearRange(gen.start_year, gen.end_year);

  const torques = await query<TorqueRow>(
    `SELECT ts.id, ts.fastener, ts.engine_id,
            e.code AS engine_code, e.display_name AS engine_display,
            ts.torque_nm, ts.torque_ftlb, ts.thread_lock, ts.notes
     FROM torque_specs ts
     LEFT JOIN engines e ON e.id = ts.engine_id
     WHERE ts.generation_id = ?
     ORDER BY FIELD(ts.fastener,
       'lug_nut','spark_plug','oil_drain','wheel_hub_nut',
       'caliper_bolt','caliper_bracket_bolt','control_arm_bolt',
       'sway_bar_link','cv_axle_nut','cylinder_head_bolt',
       'intake_manifold','exhaust_manifold','flywheel_bolt',
       'valve_cover','cam_bearing_cap','rod_bolt','main_bearing'
     ),
     (e.displacement_cc IS NULL) ASC,
     e.displacement_cc ASC,
     ts.fastener`,
    [gen.id],
  );

  if (torques.length === 0) notFound();

  // Multi-engine detection (same heuristic as gen and fluid topic pages).
  const engineList = await query<EngineLite & { fuel: string | null }>(
    `SELECT DISTINCT e.id, e.fuel FROM engines e JOIN trims t ON t.engine_id = e.id WHERE t.generation_id = ?`,
    [gen.id],
  );
  // Fuel-aware suppression: a gen with no diesel engine cannot have glow plugs;
  // one with no petrol cannot have spark plugs/ignition coils. Bulk-ingested
  // gen-wide torques are a model's whole-family aggregate, so these wrong-fuel
  // rows leak onto single-fuel gens (e.g. glow plugs on the petrol-only M3 F80).
  // engines.fuel is unnormalised (petrol / Petrol / gasoline / diesel / Diesel /
  // electric) — match case-insensitively and treat gasoline as petrol.
  const genFuelStr = engineList.map((e) => (e.fuel ?? "").toLowerCase()).join(",");
  const hasPetrol = /petrol|gasoline/.test(genFuelStr);
  const hasDiesel = /diesel/.test(genFuelStr);
  const DIESEL_ONLY_RE = /glow.?plug/i;
  const PETROL_IGNITION_RE = /spark.?plug|ignition.?coil/i;
  const wrongFuelFastener = (f: string) =>
    (!hasDiesel && DIESEL_ONLY_RE.test(f)) || (!hasPetrol && PETROL_IGNITION_RE.test(f));
  const trimList = await query<TrimLite>(
    `SELECT id, hp, engine_id FROM trims WHERE generation_id = ?`,
    [gen.id],
  );
  const distinctHps = new Set(trimList.map((t) => t.hp).filter((h): h is number => h != null));
  const someRowScoped = torques.some((t) => t.engine_id != null);
  const multiEngine = engineList.length > 1 || distinctHps.size > 1 || someRowScoped;

  const rendered: TorqueRow[] = [];
  const suppressedFasteners = new Set<string>();
  for (const t of torques) {
    if (wrongFuelFastener(t.fastener)) {
      // Categorically impossible for this gen's fuel mix — drop silently
      // (it's contamination, not a legitimately-suppressed engine-scoped row).
      continue;
    }
    if (t.engine_id == null && multiEngine && ENGINE_SCOPED_FASTENERS.has(t.fastener)) {
      suppressedFasteners.add(t.fastener);
    } else {
      rendered.push(t);
    }
  }
  const provisionalSuppressed = suppressedFasteners.size;

  const citations = await buildCitationIndex(
    gen.id,
    rendered.map((r) => ({ table: "torque_specs", id: r.id })),
  );
  const sources = citations.sources;
  const rev = reviewDate(sources);

  // Cross-vehicle engine matches — herstructureringsplan §4. Engine-scoped
  // fasteners (spark plug, oil drain, head bolt) carry the same torque value
  // across vehicles with the same engine, so this routes engine-code topical
  // SEO ("N55 spark plug torque", "B58 head bolt sequence").
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

  // FAQ — only emit single-value answers for fasteners that are truly gen-wide
  // (i.e. found in `rendered` with engine_id = NULL on a multi-engine gen the
  // suppression filter approved, meaning the fastener type ISN'T engine-scoped).
  // For engine-scoped fasteners (spark plug, oil drain, head bolt) we either
  // emit a "varies by engine" answer or skip the question entirely.
  const findGenWide = (fastener: string) =>
    rendered.find((t) => t.fastener === fastener && t.engine_id == null);
  const findAny = (fastener: string) =>
    rendered.filter((t) => t.fastener === fastener);

  const faqs: Array<{ q: string; a: string }> = [];
  const lug = findGenWide("lug_nut");
  if (lug) {
    faqs.push({
      q: `What is the wheel lug nut torque for the ${make.name} ${gen.display_name}?`,
      a: `Tighten the wheel lug nuts to ${lug.torque_nm} N·m (${lug.torque_ftlb} ft·lb) in a star pattern on the ${make.name} ${gen.display_name} (${yrs}).${lug.notes ? ` ${lug.notes}` : ""}`,
    });
  }
  const plugRows = findAny("spark_plug");
  if (plugRows.length === 1 && plugRows[0]) {
    const p = plugRows[0];
    faqs.push({
      q: `What is the spark plug torque for the ${make.name} ${gen.display_name}?`,
      a: `Spark plug torque on the ${make.name} ${gen.display_name} (${yrs}) is ${p.torque_nm} N·m (${p.torque_ftlb} ft·lb)${p.engine_display ? ` on the ${p.engine_display}` : ""}.${p.notes ? ` ${p.notes}` : ""}`,
    });
  } else if (plugRows.length > 1) {
    const values = plugRows.map((p) => `${p.engine_display ?? p.engine_code ?? "—"}: ${p.torque_nm} N·m`).join("; ");
    faqs.push({
      q: `What is the spark plug torque for the ${make.name} ${gen.display_name}?`,
      a: `Spark plug torque differs by engine on the ${make.name} ${gen.display_name} (${yrs}): ${values}. See the per-engine table on this page for the value matching your engine code.`,
    });
  }
  const drainRows = findAny("oil_drain");
  if (drainRows.length === 1 && drainRows[0]) {
    const d = drainRows[0];
    faqs.push({
      q: `What is the oil drain plug torque for the ${make.name} ${gen.display_name}?`,
      a: `Oil drain plug torque on the ${make.name} ${gen.display_name} (${yrs}) is ${d.torque_nm} N·m (${d.torque_ftlb} ft·lb) with a new crush washer.${d.notes ? ` ${d.notes}` : ""}`,
    });
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
              topic: { label: "Torque", path: `/${make.slug}/${gen.slug}/torque` },
            }),
            datasetJsonLd({
              name: `${make.name} ${gen.display_name} ${yrs} — Torque specifications`,
              description: `Torque values for the ${make.name} ${gen.display_name} (${yrs}). Per-engine where engine-scoped (spark plug, drain plug), gen-wide otherwise (lug nut, suspension). Per-row sources.`,
              path: `/${make.slug}/${gen.slug}/torque`,
              reviewDate: rev,
              variables: [
                { name: "Torque", unitText: "N·m / ft·lb" },
                { name: "Thread lock" },
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
          <span>Torque</span>
        </nav>

        <div className="pagehead">
          <h1>Torque specifications</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{rendered.length} {rendered.length === 1 ? "fastener" : "fasteners"} documented</span>
            <span className="pip"></span>
            <span>N·m + ft·lb both shown</span>
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
        active="torque"
        counts={{ torque: rendered.length }}
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <p style={{ maxWidth: 720, color: "var(--ink-soft)", fontSize: 14, lineHeight: 1.55 }}>
            Manufacturer-spec torque values for the {make.name} {gen.display_name} ({yrs}).
            Gen-wide fasteners (lug nut, suspension, caliper) are listed once;
            engine-scoped fasteners (spark plug, oil drain, head bolt) get one row per engine variant.
            Click any row to inspect its source citations.
          </p>
        </section>

        <section>
          <h2 className="section-h">
            Full torque table
            <span className="count">{rendered.length} {rendered.length === 1 ? "row" : "rows"}</span>
          </h2>
          <p className="muted" style={{ fontSize: 12, marginBottom: 8 }}>
            Engine column shows &ldquo;All engines&rdquo; when the value is verified gen-wide.
            {provisionalSuppressed > 0 && (
              <>
                {" "}
                <strong style={{ color: "var(--ink-soft)" }}>
                  {provisionalSuppressed === 1 ? "One fastener" : `${provisionalSuppressed} fasteners`}
                  {" "}({[...suppressedFasteners].map(fastenerLabel).join(", ")}){" "}
                  {provisionalSuppressed === 1 ? "has" : "have"} engine-scoped torque values
                  but no per-engine row in the database. Suppressed rather than displayed as one
                  value across {engineList.length || trimList.length} different engines.
                </strong>
              </>
            )}
          </p>
          {rendered.length > 0 ? (
            <div className="table-scroll">
              <table className="spec-table">
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>
                    {["Fastener", "Engine", "N·m", "ft·lb", "Thread lock", "Notes"].map((h) => (
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
                  {rendered.map((t) => (
                    <tr key={t.id}>
                      <th>
                        <strong style={{ color: "var(--ink)" }}>{fastenerLabel(t.fastener)}</strong>
                        <Cites nums={citations.citationsFor("torque_specs", t.id)} />
                      </th>
                      <td style={{ whiteSpace: "nowrap" }}>
                        {t.engine_id ? (t.engine_display || t.engine_code) : <span className="alt">All engines</span>}
                      </td>
                      <td className="tnum"><strong>{t.torque_nm} N·m</strong></td>
                      <td className="tnum">{t.torque_ftlb} ft·lb</td>
                      <td>{t.thread_lock ?? "—"}</td>
                      <td className="alt">{t.notes ?? "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <p style={{ fontSize: 13, color: "var(--ink-soft)", padding: "16px 0" }}>
              No verified torque values for this generation yet.
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
              Engines shared with other vehicles. Engine-scoped torque values
              (spark plug, oil drain, head bolt) are identical because they depend
              on the engine, not the chassis.
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
                          href={`/${g.brand_slug}/${g.gen_slug}/torque`}
                          style={{ display: "block", padding: "10px 14px", fontSize: 13, color: "var(--ink)" }}
                        >
                          <div style={{ fontWeight: 500 }}>
                            {g.brand_name} {g.gen_display}
                          </div>
                          <div className="muted" style={{ fontSize: 11, marginTop: 2, fontFamily: "var(--font-mono)" }}>
                            {gyrs} · torque values →
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
              { href: `/${make.slug}/${gen.slug}/oil-capacity`, name: "Engine oil capacity", peek: "Drain plug torque + filter PN + viscosity" },
              { href: `/${make.slug}/${gen.slug}/maintenance-schedule`, name: "Maintenance schedule", peek: "When each fastener gets touched" },
              { href: `/${make.slug}/${gen.slug}/tires`, name: "Tires & wheels", peek: "OE size · bolt pattern · placard PSI" },
              { href: `/${make.slug}/${gen.slug}`, name: "Generation overview", peek: "Engine, performance, dimensions, drivetrain" },
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
