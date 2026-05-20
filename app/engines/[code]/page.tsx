import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { pageMetadata, faqJsonLd } from "@/lib/seo";
import { boreStrokeDual, displacementDual } from "@/lib/units";

type Params = { code: string };

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

type Application = {
  brand_slug: string;
  brand_name: string;
  model_name: string;
  gen_slug: string;
  gen_display: string;
  start_year: number;
  end_year: number | null;
  trim_count: number;
};

type FluidEntry = {
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
  drain_interval_mi: number | null;
  brand_name: string | null;
  gen_display: string | null;
  gen_slug: string | null;
  brand_slug: string | null;
};

type PartEntry = {
  part_type: string;
  part_number: string;
  source_brand: string | null;
  gap_mm: string | null;
  brand_name: string;
  brand_slug: string;
  gen_display: string;
  gen_slug: string;
};

const codeFromSlug = (slug: string) => slug.replace(/-/g, "/").toUpperCase();
const slugFromCode = (code: string) =>
  code.replace(/[\s/]/g, "-").replace(/[^a-zA-Z0-9-]/g, "").replace(/-+/g, "-").toLowerCase();

export async function generateStaticParams(): Promise<Params[]> {
  const rows = await query<{ code: string }>(
    `SELECT DISTINCT e.code
     FROM engines e
     JOIN trims t ON t.engine_id = e.id
     JOIN generations g ON g.id = t.generation_id
     WHERE g.is_active = 1 AND e.code IS NOT NULL AND e.code != ''`,
  );
  return rows.map((r) => ({ code: slugFromCode(r.code) }));
}

async function findEngine(slug: string): Promise<Engine | null> {
  // Slug-to-code is lossy (case + separators); search all engines case-insensitively
  const rows = await query<Engine>(
    `SELECT id, code, display_name, displacement_cc, fuel, aspiration,
            valvetrain, cylinders, bore_mm, stroke_mm, compression
     FROM engines`,
  );
  return rows.find((e) => slugFromCode(e.code) === slug) ?? null;
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { code } = await params;
  const engine = await findEngine(code);
  if (!engine) return { title: "Engine not found" };
  return pageMetadata({
    title: `${engine.code} ${engine.display_name} — Engine specifications, oil capacity, applications`,
    description: `Specifications for the ${engine.code} engine (${engine.display_name}): ${engine.displacement_cc ? `${(engine.displacement_cc/1000).toFixed(1)} L, ` : ""}${engine.cylinders ?? "—"}-cyl ${engine.fuel}${engine.aspiration ? ` ${engine.aspiration}` : ""}. Oil capacity, viscosity, OE filter and spark-plug part numbers across every vehicle this engine appears in.`,
    path: `/engines/${code}`,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { code } = await params;
  const engine = await findEngine(code);
  if (!engine) notFound();

  // Applications (where this engine is used)
  const apps = await query<Application>(
    `SELECT mk.slug AS brand_slug, mk.name AS brand_name,
            m.name AS model_name,
            g.slug AS gen_slug, g.display_name AS gen_display,
            g.start_year, g.end_year,
            (SELECT COUNT(*) FROM trims WHERE generation_id = g.id AND engine_id = ?) AS trim_count
     FROM trims t
     JOIN generations g ON g.id = t.generation_id
     JOIN models m      ON m.id = g.model_id
     JOIN makes mk      ON mk.id = m.make_id
     WHERE t.engine_id = ? AND g.is_active = 1
     GROUP BY mk.slug, mk.name, m.name, g.slug, g.display_name, g.start_year, g.end_year
     ORDER BY g.start_year DESC`,
    [engine.id, engine.id],
  );

  // Aggregated oil fluid data (each gen with this engine)
  const oilEntries = await query<FluidEntry>(
    `SELECT f.capacity_l, f.capacity_qt, f.viscosity, f.spec_standard,
            f.filter_part_no, f.drain_interval_mi,
            mk.name AS brand_name, mk.slug AS brand_slug,
            g.display_name AS gen_display, g.slug AS gen_slug
     FROM fluid_specs f
     JOIN generations g ON g.id = f.generation_id
     JOIN models m      ON m.id = g.model_id
     JOIN makes mk      ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND f.fluid_type = 'engine_oil'
       AND g.id IN (SELECT DISTINCT generation_id FROM trims WHERE engine_id = ?)
     GROUP BY g.id
     ORDER BY g.start_year DESC`,
    [engine.id],
  );

  // Spark plug + oil filter parts across all gens using this engine
  const partEntries = await query<PartEntry>(
    `SELECT p.part_type, p.part_number, p.source_brand, p.gap_mm,
            mk.name AS brand_name, mk.slug AS brand_slug,
            g.display_name AS gen_display, g.slug AS gen_slug
     FROM parts p
     JOIN generations g ON g.id = p.generation_id
     JOIN models m      ON m.id = g.model_id
     JOIN makes mk      ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND p.part_type IN ('spark_plug','oil_filter','oil_filter_v6','air_filter')
       AND g.id IN (SELECT DISTINCT generation_id FROM trims WHERE engine_id = ?)
     ORDER BY p.part_type, g.start_year DESC`,
    [engine.id],
  );

  const primaryOil = oilEntries[0];

  const faqs: Array<{ q: string; a: string }> = [];
  if (primaryOil?.capacity_qt && primaryOil?.capacity_l) {
    faqs.push({
      q: `What is the oil capacity of the ${engine.code} engine?`,
      a: `The ${engine.code} (${engine.display_name}) engine holds ${Number(primaryOil.capacity_qt).toFixed(1)} US qt (${Number(primaryOil.capacity_l).toFixed(1)} L) with a new filter.${primaryOil.viscosity ? ` Manufacturer-specified viscosity is ${primaryOil.viscosity}.` : ""}`,
    });
  }
  if (primaryOil?.spec_standard) {
    faqs.push({
      q: `What oil specification does the ${engine.code} engine use?`,
      a: `${primaryOil.spec_standard}${primaryOil.viscosity ? ` viscosity ${primaryOil.viscosity}` : ""}. Using a non-spec oil can cause LSPI on direct-injection turbo engines and accelerated cam-chain wear.`,
    });
  }
  if (apps.length >= 2) {
    faqs.push({
      q: `Which vehicles use the ${engine.code} engine?`,
      a: `The ${engine.code} appears in ${apps.length} vehicle generations: ${apps.slice(0, 5).map((a) => `${a.brand_name} ${a.gen_display}`).join("; ")}${apps.length > 5 ? `; and ${apps.length - 5} more` : ""}.`,
    });
  }
  const sparkPlug = partEntries.find((p) => p.part_type === "spark_plug");
  if (sparkPlug) {
    faqs.push({
      q: `What spark plug fits the ${engine.code} engine?`,
      a: `OE spark plug for the ${engine.code} is ${sparkPlug.part_number}${sparkPlug.source_brand ? ` (${sparkPlug.source_brand})` : ""}${sparkPlug.gap_mm ? `, gap ${sparkPlug.gap_mm} mm` : ""}.`,
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
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href="/engines">Engines</a><span className="sep">/</span>
          <span>{engine.code}</span>
        </nav>

        <div className="pagehead">
          <h1>{engine.code} <span style={{ color: "var(--ink-mute)", fontWeight: 400 }}>— {engine.display_name}</span></h1>
          <div className="sub">
            <span>
              {engine.displacement_cc ? `${(engine.displacement_cc/1000).toFixed(1)} L` : "—"}
            </span>
            <span className="pip"></span>
            <span>{engine.cylinders ?? "—"}-cylinder {engine.fuel}</span>
            {engine.aspiration && <><span className="pip"></span><span>{engine.aspiration}</span></>}
            <span className="pip"></span>
            <span>{apps.length} vehicle{apps.length !== 1 ? "s" : ""} use this engine</span>
          </div>
        </div>
      </div>

      <main className="shell">
        {/* Engine specifications */}
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">Engine specifications</h2>
          <table className="spec-table">
            <tbody>
              <tr><th>Engine code</th><td><strong>{engine.code}</strong></td></tr>
              <tr><th>Display name</th><td className="alt">{engine.display_name}</td></tr>
              <tr><th>Displacement</th><td>{displacementDual(engine.displacement_cc)}</td></tr>
              {engine.bore_mm && engine.stroke_mm && (
                <tr><th>Bore × stroke</th><td>{boreStrokeDual(engine.bore_mm, engine.stroke_mm)}</td></tr>
              )}
              {engine.compression && <tr><th>Compression ratio</th><td>{engine.compression} : 1</td></tr>}
              {engine.aspiration && <tr><th>Aspiration</th><td>{engine.aspiration}</td></tr>}
              {engine.valvetrain && <tr><th>Valvetrain</th><td>{engine.valvetrain}</td></tr>}
              <tr><th>Cylinders / fuel</th><td>{engine.cylinders ?? "—"} · {engine.fuel}</td></tr>
            </tbody>
          </table>
        </section>

        {/* Applications */}
        <section>
          <h2 className="section-h">
            Vehicles using this engine
            <span className="count">{apps.length}</span>
          </h2>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))",
              gap: 8,
              border: "1px solid var(--rule)",
            }}
          >
            {apps.map((a) => (
              <li
                key={`${a.brand_slug}-${a.gen_slug}`}
                style={{
                  borderRight: "1px solid var(--rule)",
                  borderBottom: "1px solid var(--rule)",
                }}
              >
                <a
                  href={`/${a.brand_slug}/${a.gen_slug}`}
                  style={{
                    display: "block",
                    padding: "12px 16px",
                    color: "var(--ink)",
                  }}
                >
                  <div style={{ fontWeight: 600, fontSize: 14 }}>
                    {a.brand_name} {a.gen_display}
                  </div>
                  <div
                    style={{
                      fontFamily: "var(--font-mono)",
                      fontSize: 11,
                      color: "var(--ink-mute)",
                      marginTop: 2,
                    }}
                  >
                    {a.start_year} – {a.end_year ?? "present"} · {a.trim_count} trim{a.trim_count !== 1 ? "s" : ""}
                  </div>
                </a>
              </li>
            ))}
          </ul>
        </section>

        {/* Oil capacity across applications */}
        {oilEntries.length > 0 && (
          <section>
            <h2 className="section-h">
              Engine oil capacity by application
              <span className="count">{oilEntries.length}</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Application", "Capacity", "Viscosity", "Spec", "Drain"].map((h) => (
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
                {oilEntries.map((o, i) => (
                  <tr key={i}>
                    <th>
                      <a
                        href={`/${o.brand_slug}/${o.gen_slug}`}
                        style={{ color: "var(--ink)", fontWeight: 600 }}
                      >
                        {o.brand_name} {o.gen_display}
                      </a>
                    </th>
                    <td>
                      <strong>
                        {o.capacity_qt && o.capacity_l
                          ? `${Number(o.capacity_qt).toFixed(1)} qt · ${Number(o.capacity_l).toFixed(1)} L`
                          : "—"}
                      </strong>
                    </td>
                    <td>{o.viscosity ?? "—"}</td>
                    <td>{o.spec_standard ?? "—"}</td>
                    <td>{o.drain_interval_mi ? `${o.drain_interval_mi.toLocaleString()} mi` : "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

        {/* Parts */}
        {partEntries.length > 0 && (
          <section>
            <h2 className="section-h">
              OE part numbers for this engine
              <span className="count">{partEntries.length}</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Part", "Number", "Brand", "Application"].map((h) => (
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
                {partEntries.map((p, i) => (
                  <tr key={i}>
                    <th>{p.part_type.replace(/_/g, " ")}</th>
                    <td>
                      <code
                        style={{
                          fontFamily: "var(--font-mono)",
                          background: "var(--bg-alt)",
                          padding: "2px 6px",
                        }}
                      >
                        {p.part_number}
                      </code>
                      {p.gap_mm && (
                        <span style={{ fontSize: 11, color: "var(--ink-mute)", marginLeft: 8 }}>
                          gap {p.gap_mm} mm
                        </span>
                      )}
                    </td>
                    <td>{p.source_brand ?? "—"}</td>
                    <td className="alt">
                      <a
                        href={`/${p.brand_slug}/${p.gen_slug}`}
                        style={{ color: "var(--ink-soft)" }}
                      >
                        {p.brand_name} {p.gen_display}
                      </a>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
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
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
