import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getSourcesFor,
  getAllGenerationParams,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { torqueLabel as fastenerLabel } from "@/lib/labels";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

type TorqueRow = {
  id: number;
  fastener: string;
  torque_nm: number | null;
  torque_ftlb: number | null;
  thread_lock: string | null;
  notes: string | null;
};

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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Torque specifications`,
    description: `Torque values for the ${base.gen.display_name} (${base.make.name}, ${yrs}) — wheel lug nuts, spark plugs, drain plug, hub nut, suspension fasteners. Both N·m and ft·lb, cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/torque`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const torques = await query<TorqueRow>(
    `SELECT id, fastener, torque_nm, torque_ftlb, thread_lock, notes
     FROM torque_specs
     WHERE generation_id = ?
     ORDER BY FIELD(fastener,
       'lug_nut','spark_plug','oil_drain','wheel_hub_nut',
       'caliper_bolt','caliper_bracket_bolt','control_arm_bolt',
       'sway_bar_link','cv_axle_nut','cylinder_head_bolt',
       'intake_manifold','exhaust_manifold','flywheel_bolt'
     ), fastener`,
    [gen.id],
  );

  if (torques.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "torque_specs");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Find lug nut + spark plug + drain as the three "everyone needs these" headline values
  const lug = torques.find((t) => t.fastener === "lug_nut");
  const plug = torques.find((t) => t.fastener === "spark_plug");
  const drain = torques.find((t) => t.fastener === "oil_drain");

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
          <span>Torque</span>
        </nav>

        <div className="pagehead">
          <h1>Torque specifications</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{torques.length} fasteners documented</span>
            <span className="pip"></span>
            <span>N·m + ft·lb both shown</span>
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
        active="torque"
        counts={{ torque: torques.length }}
      />

      <main className="shell">
        {/* The three headline values most owners actually need */}
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">Common service fasteners</h2>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(3, 1fr)",
              gap: 16,
            }}
          >
            {[
              {
                label: "Wheel lug nut",
                row: lug,
                note: "Star pattern · 4-step torque",
              },
              {
                label: "Spark plug",
                row: plug,
                note: "Anti-seize on aluminium head",
              },
              {
                label: "Oil drain plug",
                row: drain,
                note: "Single-use crush washer",
              },
            ]
              .filter((t) => t.row)
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
                    {row!.torque_nm} N·m
                  </div>
                  <div
                    style={{
                      fontFamily: "var(--font-mono)",
                      fontSize: 16,
                      color: "var(--ink-soft)",
                      fontVariantNumeric: "tabular-nums",
                      marginTop: 4,
                    }}
                  >
                    {row!.torque_ftlb} ft·lb
                  </div>
                  <div
                    style={{
                      marginTop: 8,
                      fontSize: 12,
                      color: "var(--ink-soft)",
                    }}
                  >
                    {row!.notes ?? note}
                    {sources.length > 0 && (
                      <sup className="cite">
                        {sources.map((_, i) => `[${i + 1}]`).join("")}
                      </sup>
                    )}
                  </div>
                </div>
              ))}
          </div>
        </section>

        {/* Full table */}
        <section>
          <h2 className="section-h">
            Full torque table
            <span className="count">{torques.length} fasteners</span>
          </h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                {["Fastener", "N·m", "ft·lb", "Thread lock", "Notes"].map(
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
              {torques.map((t) => (
                <tr key={t.id}>
                  <th>
                    <strong style={{ color: "var(--ink)" }}>
                      {fastenerLabel(t.fastener)}
                    </strong>
                  </th>
                  <td>
                    <strong>{t.torque_nm} N·m</strong>
                  </td>
                  <td>{t.torque_ftlb} ft·lb</td>
                  <td>{t.thread_lock ?? "—"}</td>
                  <td className="alt">{t.notes ?? "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

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
                href: `/${make.slug}/${gen.slug}/oil-capacity`,
                name: "Engine oil capacity",
                peek: "Drain plug torque + filter PN + viscosity",
              },
              {
                href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                name: "Maintenance schedule",
                peek: "When each fastener gets touched",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Engine, performance, dimensions, drivetrain",
              },
              {
                href: `/${make.slug}/${gen.slug}/tires`,
                name: "Tires & wheels",
                peek: "OE size · bolt pattern · placard PSI",
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
