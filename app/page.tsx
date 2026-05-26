import { query } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

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

type BrandRow = {
  slug: string;
  name: string;
  country_of_origin: string | null;
  gen_count: number;
  trim_count: number;
};

async function getBrands() {
  return query<BrandRow>(
    `SELECT mk.slug, mk.name, mk.country_of_origin,
            (SELECT COUNT(*) FROM generations g JOIN models m ON m.id=g.model_id
             WHERE m.make_id=mk.id AND g.is_active=1) AS gen_count,
            (SELECT COUNT(*) FROM trims t JOIN generations g ON g.id=t.generation_id
             JOIN models m ON m.id=g.model_id WHERE m.make_id=mk.id) AS trim_count
     FROM makes mk WHERE mk.is_active=1
     ORDER BY mk.name`,
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
    name: "Parts & consumables",
    peek: "Wiper blades · filters · spark plugs · OE part numbers",
    icon: (
      <>
        <circle cx="10" cy="10" r="3" />
        <path d="M10 1v3M10 16v3M1 10h3M16 10h3M4 4l1.5 1.5M14.5 14.5 16 16M16 4l-1.5 1.5M5.5 14.5 4 16" />
      </>
    ),
  },
  {
    name: "Towing & load",
    peek: "Braked & unbraked · payload · roof · trailer wiring",
    icon: <path d="M3 7 10 3l7 4M3 7v7l7 4 7-4V7" />,
  },
];

type Stats = {
  generations: number;
  makes: number;
  models: number;
  trims: number;
  procedures: number;
};

async function getStats(): Promise<Stats> {
  const row = await query<Stats>(
    `SELECT
      (SELECT COUNT(*) FROM generations WHERE is_active=1) AS generations,
      (SELECT COUNT(*) FROM makes WHERE is_active=1) AS makes,
      (SELECT COUNT(DISTINCT m.id) FROM models m JOIN generations g ON g.model_id=m.id WHERE g.is_active=1) AS models,
      (SELECT COUNT(*) FROM trims t JOIN generations g ON g.id=t.generation_id WHERE g.is_active=1) AS trims,
      (SELECT COUNT(*) FROM procedures p JOIN generations g ON g.id=p.generation_id WHERE g.is_active=1) AS procedures`,
  );
  return row[0] ?? { generations: 0, makes: 0, models: 0, trims: 0, procedures: 0 };
}

export default async function Home() {
  const [recent, brands, stats] = await Promise.all([getRecent(), getBrands(), getStats()]);
  return (
    <>
      <SiteHeader />

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

          <form action="/search" method="get" className="hp-search" role="search">
            <input
              type="search"
              name="q"
              autoComplete="off"
              aria-label="Search ownerspecs catalogue"
              placeholder="2018 Honda Civic 1.5T oil capacity, BMW G20 lug nut torque, …"
            />
            <button type="submit">Search</button>
          </form>
          <div className="hp-search-modes">
            <span className="on">Natural language</span>
            <a href="/engines" style={{ color: "inherit", textDecoration: "none" }}>
              <span>Engine code</span>
            </a>
            <a href="/compare" style={{ color: "inherit", textDecoration: "none" }}>
              <span>Compare</span>
            </a>
            <a href="#brands" style={{ color: "inherit", textDecoration: "none" }}>
              <span>Browse catalogue</span>
            </a>
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
              {stats.generations} generations · {stats.makes} makes · {stats.trims} trims · {stats.procedures} procedures indexed
            </span>
            <span className="div" />
            <span className="meta">Cross-verified · cited · dated</span>
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

        <section id="brands">
          <h2 className="section-h">
            Browse by manufacturer <span className="count">{brands.length} indexed</span>
          </h2>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(180px, 1fr))",
              gap: 0,
              border: "1px solid var(--rule)",
              background: "var(--rule)",
            }}
          >
            {brands.map((b) => (
              <a
                key={b.slug}
                href={`/${b.slug}`}
                style={{
                  background: "var(--bg)",
                  padding: "16px 20px",
                  textDecoration: "none",
                  color: "var(--ink)",
                  outline: "1px solid var(--rule)",
                  outlineOffset: "-0.5px",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  gap: 8,
                  transition: "background 80ms",
                }}
              >
                <span style={{ fontSize: 14, fontWeight: 600 }}>{b.name}</span>
                <span
                  style={{
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: "var(--ink-mute)",
                    fontVariantNumeric: "tabular-nums",
                    fontWeight: 400,
                  }}
                >
                  {b.gen_count} gen{b.gen_count === 1 ? "" : "s"} · {b.trim_count}{" "}
                  trim{b.trim_count === 1 ? "" : "s"}
                </span>
              </a>
            ))}
          </div>
        </section>

        <section id="owner-manual-data">
          <h2 className="section-h">
            Owner-manual data <span className="count">9 categories</span>
          </h2>
          <div className="moat-list">
            {dataCategories.map((c) => (
              <a className="moat-row" href="/#brands" key={c.name}>
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

        <section id="methodology">
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

      <SiteFooter />
    </>
  );
}
