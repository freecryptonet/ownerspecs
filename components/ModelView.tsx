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
          <div className="table-scroll">
            <table className="spec-table" style={{ width: "100%" }}>
              <tbody>
                {generations.map((g) => (
                  <tr key={g.generation_slug}>
                    <td>
                      <a
                        href={`/${make.slug}/${g.generation_slug}`}
                        style={{ color: "var(--ink)", fontWeight: 600 }}
                      >
                        {g.display_name}
                      </a>
                    </td>
                    <td style={{ fontFamily: "var(--font-mono)", fontSize: 12, whiteSpace: "nowrap" }}>
                      {g.start_year}–{g.end_year ?? "present"}
                    </td>
                    <td style={{ fontFamily: "var(--font-mono)", fontSize: 12, color: "var(--ink-mute)" }}>
                      {g.codename ?? "—"}
                    </td>
                    <td style={{ textTransform: "capitalize" }}>{g.body_type}</td>
                    <td style={{ textAlign: "right", whiteSpace: "nowrap", fontFamily: "var(--font-mono)", fontSize: 12 }}>
                      {g.trim_count} trim{g.trim_count === 1 ? "" : "s"}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
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
