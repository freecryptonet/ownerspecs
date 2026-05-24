import type { Metadata } from "next";
import { query } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata: Metadata = {
  title: "Engine catalogue — every engine, every vehicle",
  description: "Browse every engine code in the ownerspecs catalogue. Oil capacity, OE spark plug part numbers, applications across vehicle generations — for every engine.",
  alternates: { canonical: "/engines" },
};

type EngineRow = {
  code: string;
  slug: string;
  display_name: string;
  displacement_cc: number | null;
  cylinders: number | null;
  aspiration: string | null;
  fuel: string;
  app_count: number;
  brands: string;
};

export default async function EnginesIndex() {
  const engines = await query<EngineRow>(
    `SELECT e.code, e.slug, e.display_name, e.displacement_cc, e.cylinders, e.aspiration, e.fuel,
            COUNT(DISTINCT t.generation_id) AS app_count,
            GROUP_CONCAT(DISTINCT mk.name SEPARATOR ' · ') AS brands
     FROM engines e
     JOIN trims t ON t.engine_id = e.id
     JOIN generations g ON g.id = t.generation_id AND g.is_active = 1
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE e.code IS NOT NULL AND e.code != ''
     GROUP BY e.code, e.slug, e.display_name, e.displacement_cc, e.cylinders, e.aspiration, e.fuel
     ORDER BY app_count DESC, e.code`,
  );

  // Group by brand for readability
  const multi = engines.filter((e) => e.app_count >= 2);
  const single = engines.filter((e) => e.app_count === 1);

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <span>Engines</span>
        </nav>

        <div className="pagehead">
          <h1>Engine catalogue</h1>
          <div className="sub">
            <span>{engines.length} engines documented</span>
            <span className="pip"></span>
            <span>{multi.length} multi-application</span>
          </div>
        </div>
      </div>

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">
            Multi-application engines
            <span className="count">{multi.length}</span>
          </h2>
          <p style={{ color: "var(--ink-soft)", fontSize: 13, maxWidth: 720, marginBottom: 16 }}>
            Engines shared across multiple vehicle generations. The same engine code (e.g. <code>B58B30</code>, <code>A25A-FXS</code>, <code>EA888</code>) appears in different models, so oil capacity, OE spark plug, and service intervals are aggregated here.
          </p>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
              gap: 8,
              border: "1px solid var(--rule)",
            }}
          >
            {multi.map((e) => (
              <li
                key={e.slug}
                style={{
                  borderRight: "1px solid var(--rule)",
                  borderBottom: "1px solid var(--rule)",
                }}
              >
                <a
                  href={`/engines/${e.slug}`}
                  style={{
                    display: "block",
                    padding: "12px 16px",
                    color: "var(--ink)",
                  }}
                >
                  <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)" }}>
                    {e.brands}
                  </div>
                  <div style={{ fontSize: 15, fontWeight: 600, marginTop: 2 }}>
                    <code>{e.code}</code>
                  </div>
                  <div style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)", marginTop: 2 }}>
                    {e.displacement_cc ? `${(e.displacement_cc/1000).toFixed(1)} L` : "—"} · {e.cylinders ?? "—"}-cyl {e.fuel}
                    {e.aspiration ? ` · ${e.aspiration}` : ""}
                    {" · "}
                    <strong>{e.app_count} vehicles</strong>
                  </div>
                </a>
              </li>
            ))}
          </ul>
        </section>

        <section>
          <h2 className="section-h">
            Single-application engines
            <span className="count">{single.length}</span>
          </h2>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(220px, 1fr))",
              gap: 4,
            }}
          >
            {single.map((e) => (
              <li key={e.slug}>
                <a
                  href={`/engines/${e.slug}`}
                  style={{
                    display: "block",
                    padding: "8px 12px",
                    color: "var(--ink)",
                    fontSize: 12,
                    border: "1px solid var(--rule)",
                  }}
                >
                  <code>{e.code}</code> <span style={{ color: "var(--ink-mute)", marginLeft: 4 }}>{e.brands}</span>
                </a>
              </li>
            ))}
          </ul>
        </section>
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
