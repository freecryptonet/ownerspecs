import { SiteHeader } from "./SiteHeader";
import { SiteFooter } from "./SiteFooter";

type GenerationRow = {
  generation_slug: string;
  display_name: string;
  body_type: string;
  codename: string | null;
  start_year: number;
  end_year: number | null;
  trim_count: number;
  hero_url: string | null;
};

/** Rendered when /{brand}/{slug} resolves to a model (not a specific
 *  generation). Shows all generations of that model as a grid. */
export function ModelView({
  make,
  model,
  generations,
}: {
  make: { slug: string; name: string };
  model: { slug: string; name: string; bio?: string | null };
  generations: GenerationRow[];
}) {
  const earliest = generations[generations.length - 1]?.start_year;
  const latest = generations[0]?.end_year ?? "present";

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a>
          <span className="sep">/</span>
          <span>{model.name}</span>
        </nav>

        <div className="pagehead">
          <h1>{make.name} {model.name}</h1>
          <div className="sub">
            <span>{generations.length} generation{generations.length !== 1 ? "s" : ""}</span>
            {generations.length > 0 && (
              <>
                <span className="pip"></span>
                <span>
                  {earliest} – {latest}
                </span>
              </>
            )}
          </div>
        </div>
      </div>

      <main className="shell">
        {/* MODEL BIO — herstructureringsplan §3 Niveau 3. 100-200 word
            historical / positioning intro lifts this above a "thin hub" page.
            Renders only when content is present; paragraphs split on blank lines. */}
        {model.bio && (
          <section style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">About the {make.name} {model.name}</h2>
            <div style={{ maxWidth: "68ch" }}>
              {model.bio.split(/\n\s*\n/).map((p, i) => (
                <p key={i} style={{ marginTop: i === 0 ? 0 : "var(--s-3)" }}>
                  {p.trim()}
                </p>
              ))}
            </div>
          </section>
        )}

        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">
            All {make.name} {model.name} generations
            <span className="count">{generations.length}</span>
          </h2>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(320px, 1fr))",
              gap: 16,
            }}
          >
            {generations.map((g) => {
              const yrs = g.end_year
                ? `${g.start_year} – ${g.end_year}`
                : `${g.start_year} – present`;
              return (
                <li
                  key={g.generation_slug}
                  style={{
                    border: "1px solid var(--rule)",
                    background: "var(--bg-alt)",
                    overflow: "hidden",
                  }}
                >
                  <a
                    href={`/${make.slug}/${g.generation_slug}`}
                    style={{ color: "var(--ink)", display: "block" }}
                  >
                    {g.hero_url && (
                      <div style={{ aspectRatio: "16 / 9", overflow: "hidden" }}>
                        <img
                          src={g.hero_url}
                          alt={`${make.name} ${g.display_name}`}
                          style={{
                            width: "100%",
                            height: "100%",
                            objectFit: "cover",
                            display: "block",
                          }}
                        />
                      </div>
                    )}
                    <div style={{ padding: "14px 18px" }}>
                      <div
                        style={{
                          fontSize: 11,
                          fontWeight: 600,
                          letterSpacing: "0.08em",
                          textTransform: "uppercase",
                          color: "var(--ink-soft)",
                          marginBottom: 4,
                        }}
                      >
                        {g.codename ?? g.body_type}
                      </div>
                      <div
                        style={{
                          fontSize: 17,
                          fontWeight: 600,
                          marginBottom: 4,
                          lineHeight: 1.25,
                        }}
                      >
                        {g.display_name}
                      </div>
                      <div
                        style={{
                          fontFamily: "var(--font-mono)",
                          fontSize: 12,
                          color: "var(--ink-mute)",
                        }}
                      >
                        {yrs} · {g.body_type} · {g.trim_count} trim{g.trim_count !== 1 ? "s" : ""}
                      </div>
                    </div>
                  </a>
                </li>
              );
            })}
          </ul>
        </section>

        <section>
          <h2 className="section-h">Owner-manual data for the {model.name}</h2>
          <p style={{ maxWidth: 720, color: "var(--ink-soft)", fontSize: 14, lineHeight: 1.55 }}>
            Pick a generation above to access fluid capacities, torque values,
            maintenance schedules, fuse-box layouts, bulb manifests, tire
            pressures, OE part numbers, and step-by-step procedures (oil-life
            reset, TPMS relearn, jump-start, key fob battery, battery disconnect
            order). All cross-verified against the gen-specific owner&apos;s manual.
          </p>
        </section>
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
