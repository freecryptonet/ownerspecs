import type { Metadata } from "next";
import { query } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

type Params = { q?: string };

type GenHit = {
  brand_slug: string;
  brand_name: string;
  model_slug: string;
  model_name: string;
  gen_slug: string;
  gen_display: string;
  codename: string | null;
  body_type: string;
  start_year: number;
  end_year: number | null;
  hero_url: string | null;
};

type TrimHit = {
  brand_slug: string;
  gen_slug: string;
  gen_display: string;
  trim_slug: string;
  trim_name: string;
  hp: number | null;
};

type ProcHit = {
  brand_slug: string;
  gen_slug: string;
  gen_display: string;
  proc_slug: string;
  proc_title: string;
};

export const metadata: Metadata = {
  title: "Search",
  description: "Search across every make, model, generation, trim, and service procedure in the ownerspecs catalogue.",
  alternates: { canonical: "/search" },
};

const yrs = (s: number, e: number | null) =>
  e ? `${s} – ${e}` : `${s} – present`;

export default async function SearchPage({
  searchParams,
}: {
  searchParams: Promise<Params>;
}) {
  const params = await searchParams;
  const q = (params.q ?? "").trim();

  let gens: GenHit[] = [];
  let trims: TrimHit[] = [];
  let procs: ProcHit[] = [];

  if (q.length >= 1) {
    const like = `%${q}%`;
    gens = await query<GenHit>(
      `SELECT mk.slug AS brand_slug, mk.name AS brand_name,
              m.slug AS model_slug, m.name AS model_name,
              g.slug AS gen_slug, g.display_name AS gen_display,
              g.codename, g.body_type, g.start_year, g.end_year,
              (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url
       FROM generations g
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE g.is_active = 1
         AND (mk.name LIKE ? OR m.name LIKE ? OR g.display_name LIKE ?
              OR g.codename LIKE ? OR g.slug LIKE ?)
       ORDER BY g.start_year DESC
       LIMIT 24`,
      [like, like, like, like, like],
    );
    trims = await query<TrimHit>(
      `SELECT mk.slug AS brand_slug, g.slug AS gen_slug, g.display_name AS gen_display,
              t.slug AS trim_slug, t.name AS trim_name, t.hp
       FROM trims t
       JOIN generations g ON g.id = t.generation_id
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE g.is_active = 1
         AND t.name LIKE ?
       ORDER BY t.hp DESC
       LIMIT 20`,
      [like],
    );
    procs = await query<ProcHit>(
      `SELECT mk.slug AS brand_slug, g.slug AS gen_slug, g.display_name AS gen_display,
              p.slug AS proc_slug, p.title AS proc_title
       FROM procedures p
       JOIN generations g ON g.id = p.generation_id
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE g.is_active = 1
         AND p.title LIKE ?
       LIMIT 20`,
      [like],
    );
  }

  const total = gens.length + trims.length + procs.length;

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <span>Search{q && ` · "${q}"`}</span>
        </nav>

        <div className="pagehead">
          <h1>Search</h1>
          <div className="sub">
            {q ? (
              <>
                <span>Query: <strong>{q}</strong></span>
                <span className="pip"></span>
                <span>{total} result{total !== 1 ? "s" : ""}</span>
              </>
            ) : (
              <span>Type a make, model, generation, codename, trim, or procedure</span>
            )}
          </div>
        </div>
      </div>

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <form action="/search" method="get" style={{ display: "flex", gap: 8, marginBottom: 24 }}>
            <input
              type="search"
              name="q"
              defaultValue={q}
              autoFocus
              placeholder="e.g. BMW G20, Civic FC, RAV4 hybrid, oil reset"
              style={{
                flex: 1,
                padding: "12px 16px",
                fontSize: 14,
                border: "1px solid var(--rule)",
                background: "var(--bg-alt)",
                color: "var(--ink)",
              }}
            />
            <button
              type="submit"
              style={{
                padding: "12px 20px",
                fontSize: 13,
                fontWeight: 600,
                background: "var(--accent)",
                color: "white",
                border: "none",
                cursor: "pointer",
              }}
            >
              Search
            </button>
          </form>

          {q && total === 0 && (
            <p style={{ color: "var(--ink-soft)", fontSize: 14 }}>
              No matches for <strong>{q}</strong>. Try a different make, model, or
              chassis code — e.g. <em>G20</em>, <em>Civic</em>, <em>RAV4 hybrid</em>,
              <em> i-MMD</em>, <em>oil reset</em>.
            </p>
          )}

          {gens.length > 0 && (
            <>
              <h2 className="section-h">
                Generations
                <span className="count">{gens.length}</span>
              </h2>
              <ul
                style={{
                  listStyle: "none",
                  padding: 0,
                  margin: 0,
                  display: "grid",
                  gridTemplateColumns: "repeat(auto-fill, minmax(320px, 1fr))",
                  gap: 12,
                  marginBottom: 32,
                }}
              >
                {gens.map((g) => (
                  <li
                    key={g.gen_slug}
                    style={{
                      border: "1px solid var(--rule)",
                      background: "var(--bg-alt)",
                      overflow: "hidden",
                    }}
                  >
                    <a
                      href={`/${g.brand_slug}/${g.gen_slug}`}
                      style={{ color: "var(--ink)", display: "block" }}
                    >
                      {g.hero_url && (
                        <div style={{ aspectRatio: "16 / 9", overflow: "hidden" }}>
                          <img
                            src={g.hero_url}
                            alt={`${g.brand_name} ${g.gen_display}`}
                            style={{ width: "100%", height: "100%", objectFit: "cover" }}
                          />
                        </div>
                      )}
                      <div style={{ padding: "12px 16px" }}>
                        <div
                          style={{
                            fontSize: 11,
                            fontWeight: 600,
                            letterSpacing: "0.08em",
                            textTransform: "uppercase",
                            color: "var(--ink-soft)",
                          }}
                        >
                          {g.brand_name} · {g.codename ?? g.body_type}
                        </div>
                        <div style={{ fontSize: 15, fontWeight: 600, lineHeight: 1.25, marginTop: 4 }}>
                          {g.gen_display}
                        </div>
                        <div
                          style={{
                            fontFamily: "var(--font-mono)",
                            fontSize: 11,
                            color: "var(--ink-mute)",
                            marginTop: 2,
                          }}
                        >
                          {yrs(g.start_year, g.end_year)}
                        </div>
                      </div>
                    </a>
                  </li>
                ))}
              </ul>
            </>
          )}

          {trims.length > 0 && (
            <>
              <h2 className="section-h">
                Trims
                <span className="count">{trims.length}</span>
              </h2>
              <ul style={{ listStyle: "none", padding: 0, margin: 0, marginBottom: 32 }}>
                {trims.map((t) => (
                  <li key={`${t.gen_slug}-${t.trim_slug}`} style={{ padding: "8px 0" }}>
                    <a
                      href={`/${t.brand_slug}/${t.gen_slug}/${t.trim_slug}`}
                      style={{ color: "var(--ink)", fontSize: 14 }}
                    >
                      <strong>{t.trim_name}</strong>
                      <span style={{ color: "var(--ink-soft)", fontSize: 12, marginLeft: 8 }}>
                        — {t.gen_display}
                        {t.hp ? ` · ${t.hp} hp` : ""}
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </>
          )}

          {procs.length > 0 && (
            <>
              <h2 className="section-h">
                Procedures
                <span className="count">{procs.length}</span>
              </h2>
              <ul style={{ listStyle: "none", padding: 0, margin: 0, marginBottom: 32 }}>
                {procs.map((p) => (
                  <li key={`${p.gen_slug}-${p.proc_slug}`} style={{ padding: "8px 0" }}>
                    <a
                      href={`/${p.brand_slug}/${p.gen_slug}/procedures/${p.proc_slug}`}
                      style={{ color: "var(--ink)", fontSize: 14 }}
                    >
                      <strong>{p.proc_title}</strong>
                      <span style={{ color: "var(--ink-soft)", fontSize: 12, marginLeft: 8 }}>
                        — {p.gen_display}
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </>
          )}
        </section>
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
