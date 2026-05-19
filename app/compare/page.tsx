import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata: Metadata = {
  title: "Compare generations — engine, fluids, torque, maintenance",
  description:
    "Side-by-side comparison of vehicle generations: engine and performance specs, fluid capacities, torque values, maintenance intervals. Differences highlighted.",
  alternates: { canonical: "/compare" },
};

type TrimRow = {
  trim_id: number;
  trim_name: string;
  brand_slug: string;
  brand_name: string;
  model_name: string;
  gen_display_name: string;
  gen_slug: string;
  gen_codename: string | null;
  start_year: number;
  end_year: number | null;
  engine_code: string | null;
  displacement_cc: number | null;
  aspiration: string | null;
  cylinders: number | null;
  transmission_name: string | null;
  hp: number | null;
  torque_nm: number | null;
  zero_100_kmh_s: string | null;
  top_speed_kmh: number | null;
  fuel_combined_l_100km: string | null;
  co2_g_km: number | null;
  curb_weight_kg: number | null;
  max_weight_kg: number | null;
  trailer_braked_kg: number | null;
  drive_wheel: string | null;
  tire_size: string | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  fuel_tank_l: string | null;
  cargo_l: number | null;
  hero_url: string | null;
};

async function loadTrim(id: number): Promise<TrimRow | null> {
  return queryOne<TrimRow>(
    `SELECT t.id AS trim_id, t.name AS trim_name,
            mk.slug AS brand_slug, mk.name AS brand_name,
            m.name AS model_name,
            g.display_name AS gen_display_name, g.slug AS gen_slug,
            g.codename AS gen_codename, g.start_year, g.end_year,
            e.code AS engine_code, e.displacement_cc, e.aspiration, e.cylinders,
            tx.display_name AS transmission_name,
            t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh,
            t.fuel_combined_l_100km, t.co2_g_km, t.curb_weight_kg,
            t.max_weight_kg, t.trailer_braked_kg, t.drive_wheel, t.tire_size,
            g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
            g.fuel_tank_l, g.cargo_l,
            (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url
     FROM trims t
     JOIN generations g ON g.id = t.generation_id
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     LEFT JOIN engines e ON e.id = t.engine_id
     LEFT JOIN transmissions tx ON tx.id = t.transmission_id
     WHERE t.id = ?
     LIMIT 1`,
    [id],
  );
}

type TrimPickerRow = {
  trim_id: number;
  brand_name: string;
  brand_slug: string;
  display: string;
  start_year: number;
  end_year: number | null;
  hp: number | null;
  fuel_combined_l_100km: string | null;
};

async function loadAllTrimsForPicker(): Promise<TrimPickerRow[]> {
  return query<TrimPickerRow>(
    `SELECT t.id AS trim_id, mk.name AS brand_name, mk.slug AS brand_slug,
            CONCAT(mk.name, ' ', m.name, ' ', g.display_name, ' · ', t.name) AS display,
            g.start_year, g.end_year, t.hp, t.fuel_combined_l_100km
     FROM trims t
     JOIN generations g ON g.id = t.generation_id
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     ORDER BY mk.name, m.name, g.start_year DESC, t.hp DESC
     LIMIT 200`,
  );
}

// Numeric cell with diff highlighting
function diffCell(
  values: (number | null)[],
  index: number,
  format: (n: number) => string,
  betterIs: "high" | "low" = "high",
): React.ReactElement {
  const populated = values.filter((v): v is number => v !== null && v !== undefined);
  const v = values[index];
  if (v === null || v === undefined) {
    return (
      <td className="cell" style={{ color: "var(--ink-mute)" }}>
        —
      </td>
    );
  }
  if (populated.length < 2) {
    return <td className="cell">{format(v)}</td>;
  }
  const best = betterIs === "high" ? Math.max(...populated) : Math.min(...populated);
  const worst = betterIs === "high" ? Math.min(...populated) : Math.max(...populated);
  let className = "cell";
  if (v === best && best !== worst) className += " best";
  else if (v === worst && best !== worst) className += " worst";
  return <td className={className}>{format(v)}</td>;
}

function strCell(values: (string | null)[], index: number): React.ReactElement {
  const v = values[index];
  return v ? <td className="cell">{v}</td> : <td className="cell" style={{ color: "var(--ink-mute)" }}>—</td>;
}

export default async function ComparePage({
  searchParams,
}: {
  searchParams: Promise<{ a?: string; b?: string; c?: string }>;
}) {
  const { a, b, c } = await searchParams;
  const ids = [a, b, c]
    .filter((x): x is string => !!x)
    .map((x) => parseInt(x, 10))
    .filter((n) => Number.isFinite(n));

  // Picker mode — no trim IDs selected
  if (ids.length === 0) {
    const picker = await loadAllTrimsForPicker();
    // Group by brand for nicer rendering
    const byBrand = picker.reduce<Record<string, TrimPickerRow[]>>((acc, t) => {
      (acc[t.brand_name] = acc[t.brand_name] || []).push(t);
      return acc;
    }, {});

    return (
      <>
        <SiteHeader />
        <main className="shell">
          <nav className="crumb">
            <a href="/">Catalogue</a>
            <span className="sep">/</span>
            <span>Compare</span>
          </nav>
          <div className="pagehead">
            <h1>Compare</h1>
            <div className="sub">
              <span>Pick 2 or 3 trims to put side-by-side</span>
              <span className="pip"></span>
              <span>{picker.length} trims indexed</span>
            </div>
          </div>

          <section style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Available trims <span className="count">{picker.length}</span>
            </h2>
            <p style={{ fontSize: 13, color: "var(--ink-soft)", marginBottom: 16, maxWidth: "60ch" }}>
              Open the comparison by clicking 2 or 3 trim names. We&apos;ll build the URL with up to three trim IDs
              and render a side-by-side spec table with the differences highlighted.
            </p>
            {Object.entries(byBrand).map(([brand, rows]) => (
              <div key={brand} style={{ marginBottom: "var(--s-6)" }}>
                <h3
                  style={{
                    fontSize: 13,
                    fontWeight: 600,
                    color: "var(--ink-soft)",
                    textTransform: "uppercase",
                    letterSpacing: "0.06em",
                    marginBottom: 8,
                  }}
                >
                  {brand} <span className="muted">({rows.length})</span>
                </h3>
                <ul
                  style={{
                    listStyle: "none",
                    border: "1px solid var(--rule)",
                    fontSize: 13,
                  }}
                >
                  {rows.map((r) => (
                    <li
                      key={r.trim_id}
                      style={{
                        padding: "8px 14px",
                        borderBottom: "1px solid var(--rule)",
                        display: "grid",
                        gridTemplateColumns: "1fr 100px 100px 80px",
                        gap: 12,
                        alignItems: "baseline",
                      }}
                    >
                      <a href={`/compare?a=${r.trim_id}`} style={{ color: "var(--ink)", fontWeight: 500 }}>
                        {r.display}
                      </a>
                      <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)" }}>
                        {r.start_year}–{r.end_year ?? "now"}
                      </span>
                      <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)" }}>
                        {r.hp ? `${r.hp} hp` : ""}
                      </span>
                      <a
                        href={`/compare?a=${r.trim_id}`}
                        style={{
                          fontFamily: "var(--font-mono)",
                          fontSize: 11,
                          color: "var(--accent)",
                          textAlign: "right",
                        }}
                      >
                        Add →
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </section>
        </main>
        <SiteFooter />
      </>
    );
  }

  // Comparison mode — load each trim
  const trims = (await Promise.all(ids.map(loadTrim))).filter((t): t is TrimRow => t !== null);
  if (trims.length === 0) {
    return (
      <>
        <SiteHeader />
        <main className="shell">
          <div className="pagehead">
            <h1>No trims found</h1>
            <p>
              <a className="link" href="/compare">
                Back to picker
              </a>
            </p>
          </div>
        </main>
        <SiteFooter />
      </>
    );
  }

  return (
    <>
      <SiteHeader />
      <main className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href="/compare">Compare</a>
          <span className="sep">/</span>
          <span>{trims.length} trims</span>
        </nav>

        <div className="pagehead">
          <h1>{trims.map((t) => `${t.brand_name} ${t.trim_name}`).join(" · ")}</h1>
          <div className="sub">
            <span>{trims.length} trims compared</span>
            <span className="pip"></span>
            <span>Best value highlighted green · worst muted</span>
            {trims.length < 3 && (
              <>
                <span className="pip"></span>
                <a className="link" href="/compare">
                  Add another →
                </a>
              </>
            )}
          </div>
        </div>

        <div className="compare-head" style={{ gridTemplateColumns: `180px repeat(${trims.length}, 1fr)` }}>
          <div></div>
          {trims.map((t) => (
            <div key={t.trim_id}>
              <div className="ch-photo">
                {t.hero_url ? (
                  <img
                    src={t.hero_url}
                    alt={`${t.brand_name} ${t.model_name}`}
                    style={{
                      width: "100%",
                      height: "100%",
                      objectFit: "cover",
                      display: "block",
                    }}
                  />
                ) : (
                  <svg
                    viewBox="0 0 400 250"
                    stroke="rgba(255,255,255,0.7)"
                    fill="none"
                    strokeWidth="1.2"
                  >
                    <path d="M40 180c0-15 10-25 28-25h45l28-42c5-7 12-10 22-10h80c10 0 17 3 22 10l28 42h45c18 0 28 10 28 25v25H40z" />
                    <circle cx="110" cy="200" r="20" fill="rgba(255,255,255,0.08)" />
                    <circle cx="290" cy="200" r="20" fill="rgba(255,255,255,0.08)" />
                  </svg>
                )}
              </div>
              <div className="ch-name">
                <a
                  href={`/${t.brand_slug}/${t.gen_slug}`}
                  style={{ color: "var(--ink)" }}
                >
                  {t.brand_name} {t.model_name}
                </a>
              </div>
              <div className="ch-sub">
                {t.start_year}–{t.end_year ?? "now"}
                {t.gen_codename && ` · ${t.gen_codename}`}
              </div>
              <div className="ch-sub" style={{ marginTop: 4, fontStyle: "italic" }}>
                {t.trim_name}
              </div>
            </div>
          ))}
        </div>

        <table className="compare-table">
          <tbody>
            <tr className="cat-row">
              <td colSpan={trims.length + 1}>Engine</td>
            </tr>
            <tr>
              <td className="label">Code</td>
              {trims.map((t, i) => strCell(trims.map((x) => x.engine_code), i))}
            </tr>
            <tr>
              <td className="label">Displacement</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.displacement_cc), i, (n) => `${n} cm³`),
              )}
            </tr>
            <tr>
              <td className="label">Cylinders</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.cylinders), i, (n) => `${n}`),
              )}
            </tr>
            <tr>
              <td className="label">Aspiration</td>
              {trims.map((t, i) => strCell(trims.map((x) => x.aspiration), i))}
            </tr>
            <tr>
              <td className="label">Transmission</td>
              {trims.map((t, i) => strCell(trims.map((x) => x.transmission_name), i))}
            </tr>
            <tr>
              <td className="label">Drive wheel</td>
              {trims.map((t, i) => strCell(trims.map((x) => x.drive_wheel), i))}
            </tr>

            <tr className="cat-row">
              <td colSpan={trims.length + 1}>Performance</td>
            </tr>
            <tr>
              <td className="label">Power</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.hp), i, (n) => `${n} hp`),
              )}
            </tr>
            <tr>
              <td className="label">Torque</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.torque_nm), i, (n) => `${n} N·m`),
              )}
            </tr>
            <tr>
              <td className="label">0 – 100 km/h</td>
              {trims.map((t, i) =>
                diffCell(
                  trims.map((x) => (x.zero_100_kmh_s ? Number(x.zero_100_kmh_s) : null)),
                  i,
                  (n) => `${n.toFixed(1)} s`,
                  "low",
                ),
              )}
            </tr>
            <tr>
              <td className="label">Top speed</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.top_speed_kmh), i, (n) => `${n} km/h`),
              )}
            </tr>
            <tr>
              <td className="label">Fuel · combined</td>
              {trims.map((t, i) =>
                diffCell(
                  trims.map((x) =>
                    x.fuel_combined_l_100km ? Number(x.fuel_combined_l_100km) : null,
                  ),
                  i,
                  (n) => `${n.toFixed(1)} L/100 km`,
                  "low",
                ),
              )}
            </tr>
            <tr>
              <td className="label">CO₂</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.co2_g_km), i, (n) => `${n} g/km`, "low"),
              )}
            </tr>

            <tr className="cat-row">
              <td colSpan={trims.length + 1}>Dimensions &amp; weight</td>
            </tr>
            <tr>
              <td className="label">Length</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.length_mm), i, (n) => `${n} mm`),
              )}
            </tr>
            <tr>
              <td className="label">Width</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.width_mm), i, (n) => `${n} mm`),
              )}
            </tr>
            <tr>
              <td className="label">Height</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.height_mm), i, (n) => `${n} mm`),
              )}
            </tr>
            <tr>
              <td className="label">Wheelbase</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.wheelbase_mm), i, (n) => `${n} mm`),
              )}
            </tr>
            <tr>
              <td className="label">Curb weight</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.curb_weight_kg), i, (n) => `${n} kg`, "low"),
              )}
            </tr>
            <tr>
              <td className="label">Cargo</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.cargo_l), i, (n) => `${n} L`),
              )}
            </tr>
            <tr>
              <td className="label">Fuel tank</td>
              {trims.map((t, i) =>
                diffCell(
                  trims.map((x) => (x.fuel_tank_l ? Number(x.fuel_tank_l) : null)),
                  i,
                  (n) => `${n.toFixed(0)} L`,
                ),
              )}
            </tr>
            <tr>
              <td className="label">Max towing (braked)</td>
              {trims.map((t, i) =>
                diffCell(trims.map((x) => x.trailer_braked_kg), i, (n) => `${n} kg`),
              )}
            </tr>
            <tr>
              <td className="label">Tire size</td>
              {trims.map((t, i) => strCell(trims.map((x) => x.tire_size), i))}
            </tr>
          </tbody>
        </table>
      </main>
      <SiteFooter />
    </>
  );
}
