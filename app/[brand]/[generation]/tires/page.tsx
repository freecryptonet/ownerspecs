import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getAllGenerationParams,
  getSourcesFor,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";

type Params = { brand: string; generation: string };

type TireRow = {
  id: number;
  position: string;
  load_condition: string;
  psi: string | null;
  kpa: number | null;
  tire_size: string | null;
  market_code: string | null;
  trim_name: string | null;
};

// positionLabels and conditionLabels imported from @/lib/labels.
// The local maps were missing "loaded" condition (used by F-150 +
// Silverado), so those rows fell through to the raw "loaded" string.
import {
  tirePositionLabels as positionLabels,
  tireConditionLabels as conditionLabels,
} from "@/lib/labels";
import { pageMetadata } from "@/lib/seo";

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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Tire pressure & size`,
    description: `Door-jamb placard tire pressures (PSI and kPa), original-equipment tire size for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/tires`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const tires = await query<TireRow>(
    `SELECT tp.id, tp.position, tp.load_condition, tp.psi, tp.kpa, tp.tire_size,
            mk.code AS market_code, t.name AS trim_name
     FROM tire_pressures tp
     LEFT JOIN markets mk ON mk.id = tp.market_id
     LEFT JOIN trims t    ON t.id  = tp.trim_id
     WHERE tp.generation_id = ?
     ORDER BY FIELD(tp.position,'front','rear','spare'),
              FIELD(tp.load_condition,'normal','max_load','winter')`,
    [gen.id],
  );

  if (tires.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "tire_pressures");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const front = tires.find((t) => t.position === "front" && t.load_condition === "normal");
  const rear = tires.find((t) => t.position === "rear" && t.load_condition === "normal");
  const spare = tires.find((t) => t.position === "spare");

  // Unique tire sizes for the size summary
  const sizes = Array.from(
    new Set(tires.map((t) => t.tire_size).filter((s): s is string => !!s)),
  );

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a>
          <span className="sep">/</span>
          <span>Tires</span>
        </nav>

        <div className="pagehead">
          <h1>Tire pressure &amp; original-equipment size</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>Values from the door-jamb placard</span>
            {base.markets.length > 0 && (
              <>
                <span className="pip"></span>
                <span>{base.markets.map((m) => m.code).join(" · ")}</span>
              </>
            )}
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
        active="specifications"
        counts={{}}
      />

      <main className="shell">
        {/* Headline pressure cards */}
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">Placard pressure · normal load</h2>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(3, 1fr)",
              gap: 16,
            }}
          >
            {[
              { label: "Front axle", row: front, note: front?.tire_size },
              { label: "Rear axle", row: rear, note: rear?.tire_size },
              { label: "Spare", row: spare, note: spare?.tire_size },
            ]
              .filter((c) => c.row)
              .map(({ label, row, note }) => (
                <div
                  key={label}
                  style={{
                    border: "1px solid var(--rule)",
                    borderLeft: "3px solid var(--accent)",
                    background: "var(--bg-alt)",
                    padding: "16px 20px",
                  }}
                >
                  <div
                    style={{
                      fontSize: 11,
                      fontWeight: 600,
                      letterSpacing: "0.08em",
                      textTransform: "uppercase",
                      color: "var(--ink-soft)",
                    }}
                  >
                    {label}
                  </div>
                  <div
                    style={{
                      marginTop: 8,
                      fontFamily: "var(--font-mono)",
                      fontSize: 28,
                      fontWeight: 600,
                      letterSpacing: "-0.01em",
                      color: "var(--ink)",
                      fontVariantNumeric: "tabular-nums",
                      lineHeight: 1,
                    }}
                  >
                    {row!.psi ? Number(row!.psi).toFixed(0) : "—"} PSI
                  </div>
                  <div
                    style={{
                      fontFamily: "var(--font-mono)",
                      fontSize: 14,
                      color: "var(--ink-soft)",
                      fontVariantNumeric: "tabular-nums",
                      marginTop: 4,
                    }}
                  >
                    {row!.kpa ? `${row!.kpa} kPa` : ""}
                  </div>
                  <div
                    style={{
                      marginTop: 8,
                      fontSize: 12,
                      color: "var(--ink-soft)",
                    }}
                  >
                    {note ?? "—"}
                    <sup className="cite">[1]</sup>
                  </div>
                </div>
              ))}
          </div>
        </section>

        {/* Full pressure table */}
        <section>
          <h2 className="section-h">
            All conditions
            <span className="count">{tires.length} rows</span>
          </h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                {["Position", "Load condition", "PSI", "kPa", "Tire size", "Market"].map(
                  (h) => (
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
                  ),
                )}
              </tr>
            </thead>
            <tbody>
              {tires.map((t) => (
                <tr key={t.id}>
                  <th>{positionLabels[t.position] ?? t.position}</th>
                  <td>{conditionLabels[t.load_condition] ?? t.load_condition}</td>
                  <td>
                    <strong>{t.psi ? Number(t.psi).toFixed(0) : "—"}</strong>
                  </td>
                  <td>{t.kpa ?? "—"}</td>
                  <td>{t.tire_size ?? "—"}</td>
                  <td>{t.market_code ?? "global"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* Sizes summary */}
        {sizes.length > 0 && (
          <section>
            <h2 className="section-h">Original-equipment tire sizes</h2>
            <table className="spec-table">
              <tbody>
                {sizes.map((s) => (
                  <tr key={s}>
                    <th>OE size</th>
                    <td>
                      <strong>{s}</strong>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
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
            }}
          >
            {[
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Wheel lug-nut torque",
                peek: "Star pattern · 4-step torque value",
              },
              {
                href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                name: "Tire rotation interval",
                peek: "Every 7,500 mi normal duty",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Full specifications · all engines",
              },
              {
                href: `/${make.slug}/${gen.slug}/electrical`,
                name: "TPMS sensor battery",
                peek: "Replacement interval 90,000 mi",
              },
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
                <a
                  href={l.href}
                  style={{ color: "var(--ink)", fontWeight: 500 }}
                >
                  {l.name}
                </a>
                <span
                  style={{
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: "var(--ink-mute)",
                    marginLeft: 12,
                  }}
                >
                  {l.peek}
                </span>
              </li>
            ))}
          </ul>
        </section>

        <SourcesBlock sources={sources} />
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
