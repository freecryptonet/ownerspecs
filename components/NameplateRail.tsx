import { query } from "@/lib/db";

type Sibling = {
  slug: string;
  codename: string | null;
  display_name: string;
  start_year: number;
  end_year: number | null;
};

/** Cross-generation navigation rail. Lists every generation of the same model
 *  with a link to each — captures full-nameplate-history SEO equity that
 *  auto-data.net does well. */
export async function NameplateRail({
  modelId,
  makeSlug,
  currentGenSlug,
  makeName,
  modelName,
}: {
  modelId: number;
  makeSlug: string;
  currentGenSlug: string;
  makeName: string;
  modelName: string;
}) {
  const sibs = await query<Sibling>(
    `SELECT slug, codename, display_name, start_year, end_year
     FROM generations
     WHERE model_id = ? AND is_active = 1
     ORDER BY start_year DESC`,
    [modelId],
  );

  if (sibs.length <= 1) return null;

  return (
    <section style={{ marginTop: "var(--s-5)" }}>
      <h2 className="section-h">
        Other {makeName} {modelName} generations
        <span className="count">{sibs.length}</span>
      </h2>
      <ul
        style={{
          listStyle: "none",
          padding: 0,
          margin: 0,
          display: "grid",
          gridTemplateColumns: "repeat(auto-fill, minmax(220px, 1fr))",
          gap: 8,
          border: "1px solid var(--rule)",
        }}
      >
        {sibs.map((s) => {
          const isCurrent = s.slug === currentGenSlug;
          const yrs = s.end_year
            ? `${s.start_year}–${s.end_year}`
            : `${s.start_year}–present`;
          return (
            <li
              key={s.slug}
              style={{
                borderRight: "1px solid var(--rule)",
                borderBottom: "1px solid var(--rule)",
              }}
            >
              {isCurrent ? (
                <div
                  style={{
                    padding: "10px 14px",
                    background: "var(--bg-alt)",
                    fontSize: 13,
                  }}
                >
                  <div
                    style={{
                      fontSize: 10,
                      fontWeight: 600,
                      letterSpacing: "0.08em",
                      textTransform: "uppercase",
                      color: "var(--accent)",
                      marginBottom: 2,
                    }}
                  >
                    Current page
                  </div>
                  <div style={{ fontWeight: 600 }}>
                    {s.codename ? `${modelName} (${s.codename})` : modelName}
                  </div>
                  <div
                    style={{
                      fontFamily: "var(--font-mono)",
                      fontSize: 11,
                      color: "var(--ink-mute)",
                    }}
                  >
                    {yrs}
                  </div>
                </div>
              ) : (
                <a
                  href={`/${makeSlug}/${s.slug}`}
                  style={{
                    display: "block",
                    padding: "10px 14px",
                    fontSize: 13,
                    color: "var(--ink)",
                  }}
                >
                  <div
                    style={{
                      fontSize: 10,
                      fontWeight: 600,
                      letterSpacing: "0.08em",
                      textTransform: "uppercase",
                      color: "var(--ink-soft)",
                      marginBottom: 2,
                    }}
                  >
                    {s.codename ?? "Generation"}
                  </div>
                  <div style={{ fontWeight: 500 }}>
                    {s.codename
                      ? `${modelName} (${s.codename})`
                      : s.display_name}
                  </div>
                  <div
                    style={{
                      fontFamily: "var(--font-mono)",
                      fontSize: 11,
                      color: "var(--ink-mute)",
                    }}
                  >
                    {yrs}
                  </div>
                </a>
              )}
            </li>
          );
        })}
      </ul>
    </section>
  );
}
