import { query } from "@/lib/db";

type RecentRow = {
  brand: string;
  generation: string;
  display_name: string;
  make_name: string;
  start_year: number;
  end_year: number | null;
  updated: string;
  source_count: number;
  spec_count: number;
};

async function getRecent() {
  return query<RecentRow>(
    `SELECT mk.slug AS brand, g.slug AS generation, g.display_name,
            mk.name AS make_name, g.start_year, g.end_year, g.updated_at AS updated,
            (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss
             WHERE ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=g.id)
                OR ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=g.id)
            ) AS source_count,
            ((SELECT COUNT(*) FROM fluid_specs WHERE generation_id=g.id)
            + (SELECT COUNT(*) FROM torque_specs WHERE generation_id=g.id)
            + (SELECT COUNT(*) FROM bulbs WHERE generation_id=g.id)
            + (SELECT COUNT(*) FROM fuses WHERE generation_id=g.id)
            + (SELECT COUNT(*) FROM service_intervals WHERE generation_id=g.id)
            + (SELECT COUNT(*) FROM tire_pressures WHERE generation_id=g.id)
            ) AS spec_count
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
     ORDER BY g.updated_at DESC
     LIMIT 8`,
  );
}

const dataCategories = [
  {
    name: "Fluids & lubricants",
    peek: "Engine oil · transmission · coolant · brake · A/C · 10 entries",
    icon: (
      <path d="M10 2v5m0 0c-2.5 1.5-4 4-4 6.5a4 4 0 0 0 8 0c0-2.5-1.5-5-4-6.5z" />
    ),
  },
  {
    name: "Maintenance schedule",
    peek: "By mileage · normal & severe duty · time-based intervals",
    icon: (
      <>
        <circle cx="10" cy="10" r="7" />
        <path d="M10 6v4l3 2" />
      </>
    ),
  },
  {
    name: "Battery & electrical",
    peek: "Group size · CCA · alternator amperage · bulb manifest",
    icon: (
      <>
        <rect x="3" y="7" width="14" height="8" />
        <path d="M6 7V5m8 2V5m-4 5v2" />
      </>
    ),
  },
  {
    name: "Torque specifications",
    peek: "Lug · plug · drain · hub · caliper · suspension fasteners",
    icon: (
      <>
        <circle cx="10" cy="10" r="2.5" />
        <path d="M10 2v3M10 15v3M2 10h3M15 10h3" />
      </>
    ),
  },
  {
    name: "Tires & wheels",
    peek: "Placard PSI · OE size · rim offset · bolt pattern",
    icon: (
      <>
        <circle cx="10" cy="10" r="7" />
        <circle cx="10" cy="10" r="3" />
      </>
    ),
  },
  {
    name: "Fuse box layout",
    peek: "Under-hood · cabin · amperage · circuit assignment",
    icon: (
      <>
        <rect x="3" y="3" width="14" height="14" />
        <path d="M3 10h14M10 3v14" />
      </>
    ),
  },
  {
    name: "Service procedures",
    peek: "Reset · jump-start · flat-tow · battery disconnect",
    icon: <path d="M3 5h14M3 10h14M3 15h9" />,
  },
  {
    name: "Towing & load",
    peek: "Braked & unbraked · payload · roof · trailer wiring",
    icon: <path d="M3 7 10 3l7 4M3 7v7l7 4 7-4V7" />,
  },
];

export default async function Home() {
  const recent = await getRecent();
  return (
    <>
      <header className="site-header">
        <div className="site-header-inner">
          <a href="/" className="wordmark">
            ownerspecs
          </a>
          <nav className="nav-primary">
            <a href="#" className="active">
              Catalogue
            </a>
            <a href="#">Maintenance</a>
            <a href="#">Fluids</a>
            <a href="#">Compare</a>
            <a href="#">Methodology</a>
          </nav>
          <div className="search-bar">
            <svg
              width="13"
              height="13"
              viewBox="0 0 16 16"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.6"
            >
              <circle cx="7" cy="7" r="5" />
              <path d="m11 11 3 3" />
            </svg>
            <input placeholder="Make, model, VIN or part number" />
            <span className="kbd">⌘ K</span>
          </div>
        </div>
      </header>

      <main className="shell">
        <section className="hp-head">
          <h1>Vehicle specification and owner-manual reference.</h1>
          <p className="lede">
            Cross-verified data on every car sold globally since 1990 — engine
            and performance specs from manufacturer sources, plus the fluid
            capacities, torque values, maintenance schedules, fuse layouts and
            procedures most reference sites omit. Every value is cited and
            dated.
          </p>

          <div className="hp-search">
            <input placeholder="2018 Honda Civic 1.5T oil capacity, BMW G20 lug nut torque, …" />
            <button type="button">Search</button>
          </div>
          <div className="hp-search-modes">
            <span className="on">Natural language</span>
            <span>VIN</span>
            <span>Licence plate</span>
            <span>Browse catalogue</span>
          </div>

          <div className="verify-badge" style={{ marginTop: "var(--s-5)" }}>
            <svg
              width="14"
              height="14"
              viewBox="0 0 16 16"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.6"
            >
              <path d="m4 8 3 3 5-6" />
              <circle cx="8" cy="8" r="7" />
            </svg>
            <span>
              {recent.length} {recent.length === 1 ? "generation" : "generations"} indexed · catalogue expanding daily
            </span>
            <span className="div" />
            <span className="meta">Methodology below</span>
          </div>
        </section>

        <section>
          <h2 className="section-h">
            Recently published <span className="count">{recent.length} {recent.length === 1 ? "generation" : "generations"}</span>
          </h2>
          <ul
            style={{
              listStyle: "none",
              display: "grid",
              gridTemplateColumns: "repeat(2, 1fr)",
              border: "1px solid var(--rule)",
            }}
          >
            {recent.map((r) => (
              <li
                key={`${r.brand}-${r.generation}`}
                style={{
                  padding: "12px 16px",
                  borderRight: "1px solid var(--rule)",
                  borderBottom: "1px solid var(--rule)",
                  fontSize: 13,
                }}
              >
                <a
                  href={`/${r.brand}/${r.generation}`}
                  style={{ color: "var(--ink)", fontWeight: 500 }}
                >
                  {r.make_name} {r.display_name} · {r.start_year} – {r.end_year ?? "present"}
                </a>
                <span
                  style={{
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: "var(--ink-mute)",
                    marginLeft: 12,
                  }}
                >
                  {new Date(r.updated).toISOString().slice(0, 10)} · {r.source_count} sources · {r.spec_count} specs
                </span>
              </li>
            ))}
          </ul>
        </section>

        <section>
          <h2 className="section-h">
            Owner-manual data <span className="count">8 categories</span>
          </h2>
          <div className="moat-list">
            {dataCategories.map((c) => (
              <a className="moat-row" href="#" key={c.name}>
                <svg
                  className="icon"
                  viewBox="0 0 20 20"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.5"
                >
                  {c.icon}
                </svg>
                <span>
                  <span className="name">{c.name}</span>
                  <span className="peek">{c.peek}</span>
                </span>
                <span className="arrow">→</span>
              </a>
            ))}
          </div>
        </section>

        <section>
          <h2 className="section-h">Methodology</h2>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr",
              gap: "var(--s-6)",
              fontSize: "13px",
              color: "var(--ink-soft)",
              lineHeight: 1.55,
            }}
          >
            <div>
              <h3 style={{ color: "var(--ink)", marginBottom: "var(--s-2)" }}>
                Multi-source verification
              </h3>
              Every published value is corroborated against at least two
              independent sources — manufacturer service literature,
              factory-authorised workshop databases, OEM service bulletins.
              Discrepancies above ±5% are flagged for human review before
              publication.
            </div>
            <div>
              <h3 style={{ color: "var(--ink)", marginBottom: "var(--s-2)" }}>
                Date-stamped
              </h3>
              Every record carries a retrieval date and source attribution.
              When manufacturers revise a specification — typically via service
              bulletin — the prior value is preserved and the change date
              recorded.
            </div>
            <div>
              <h3 style={{ color: "var(--ink)", marginBottom: "var(--s-2)" }}>
                Market-aware
              </h3>
              Specifications often differ between US, EU, JDM and other markets
              for the same nameplate. Where a difference exists, the page
              surfaces all variants rather than presenting a single global
              figure.
            </div>
          </div>
        </section>
      </main>

      <footer className="site-footer">
        <div className="shell">
          <div className="foot-grid">
            <div>
              <a href="/" className="wordmark">
                ownerspecs
              </a>
              <p>
                Cross-verified vehicle specifications and owner-manual data for
                every car, every generation, every market.
              </p>
              <div style={{ marginTop: "var(--s-3)" }}>
                <span className="market-pill">Global · multi-market</span>
              </div>
            </div>
            <div>
              <h4>Catalogue</h4>
              <ul>
                <li>
                  <a href="#">By manufacturer</a>
                </li>
                <li>
                  <a href="#">By body type</a>
                </li>
                <li>
                  <a href="#">By fuel</a>
                </li>
                <li>
                  <a href="#">By market</a>
                </li>
              </ul>
            </div>
            <div>
              <h4>Data</h4>
              <ul>
                <li>
                  <a href="#">Fluids</a>
                </li>
                <li>
                  <a href="#">Maintenance</a>
                </li>
                <li>
                  <a href="#">Torque</a>
                </li>
                <li>
                  <a href="#">Electrical</a>
                </li>
              </ul>
            </div>
            <div>
              <h4>Sister sites</h4>
              <ul>
                <li>
                  <a href="https://vindecoder.site">vindecoder.site</a>
                </li>
                <li>
                  <a href="https://autodtcs.com">autodtcs.com</a>
                </li>
                <li>
                  <a href="https://servicereset.net">servicereset.net</a>
                </li>
              </ul>
            </div>
            <div>
              <h4>About</h4>
              <ul>
                <li>
                  <a href="#">Methodology</a>
                </li>
                <li>
                  <a href="#">Sources</a>
                </li>
                <li>
                  <a href="#">Contact</a>
                </li>
              </ul>
            </div>
          </div>
          <div className="foot-bottom">
            <span>© 2026 ownerspecs · v0.1</span>
            <span>Indexing in progress · summer 2026</span>
          </div>
        </div>
      </footer>
    </>
  );
}
