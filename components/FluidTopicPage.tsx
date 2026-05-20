import { notFound } from "next/navigation";
import { query, queryOne } from "@/lib/db";
import {
  getGenerationBase,
  getSourcesFor,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "./SiteHeader";
import { SiteFooter } from "./SiteFooter";
import { GenerationTabs } from "./GenerationTabs";
import { VerifyBadge } from "./VerifyBadge";
import { SourcesBlock } from "./SourcesBlock";
import { faqJsonLd } from "@/lib/seo";

type Row = {
  id: number;
  fluid_type: string;
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
  filter_part_no: string | null;
  drain_interval_mi: number | null;
  drain_interval_km: number | null;
  drain_interval_months: number | null;
  notes: string | null;
};

export type FluidTopicConfig = {
  /** Slug segment for the URL: "transmission-fluid", "coolant", etc. */
  slug: string;
  /** Human-readable section name (page title etc.) */
  label: string;
  /** Heading shown as the H1. */
  h1: string;
  /** SQL fluid_type values to include. */
  fluidTypes: string[];
  /** A specific Q/A bank used to build FAQ schema + visible FAQ. */
  buildFaq(args: {
    make: string;
    gen: string;
    yrs: string;
    primary: Row | undefined;
    all: Row[];
  }): Array<{ q: string; a: string }>;
  /** Short user-facing paragraph at the top. */
  lede(args: { make: string; gen: string; yrs: string }): string;
};

const PRETTY_FLUID: Record<string, string> = {
  transmission_at: "Automatic transmission",
  transmission_cvt: "CVT",
  transmission_ecvt: "Hybrid eCVT",
  transmission_mt: "Manual transmission",
  transmission_dct: "DCT / DSG",
  coolant: "Coolant",
  brake: "Brake fluid",
  ac_refrigerant: "A/C refrigerant",
  power_steering: "Power steering",
  haldex_oil: "Haldex (AWD coupling)",
  front_differential: "Front differential",
  rear_differential: "Rear differential",
  transfer_case: "Transfer case",
  gear_reducer_front: "Front motor gearbox",
  gear_reducer_rear: "Rear motor gearbox",
  washer_fluid: "Washer fluid",
};

export async function FluidTopicPage({
  brand,
  generation,
  config,
}: {
  brand: string;
  generation: string;
  config: FluidTopicConfig;
}) {
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;
  const yrs = yearRange(gen.start_year, gen.end_year);

  const placeholders = config.fluidTypes.map(() => "?").join(",");
  const rows = await query<Row>(
    `SELECT id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard,
            filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
     FROM fluid_specs
     WHERE generation_id = ? AND fluid_type IN (${placeholders})
     ORDER BY FIELD(fluid_type, ${placeholders})`,
    [gen.id, ...config.fluidTypes, ...config.fluidTypes],
  );

  if (rows.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "fluid_specs");
  const rev = reviewDate(sources);
  const primary = rows[0];

  const faqs = config.buildFaq({
    make: make.name,
    gen: gen.display_name,
    yrs,
    primary,
    all: rows,
  });

  return (
    <>
      <SiteHeader />

      {faqs.length >= 2 && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(faqs)) }}
        />
      )}

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a><span className="sep">/</span>
          <span>{config.label}</span>
        </nav>

        <div className="pagehead">
          <h1>{config.h1}</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{rows.length} {rows.length === 1 ? "entry" : "entries"} documented</span>
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
        active="fluids"
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <p style={{ maxWidth: 720, color: "var(--ink-soft)", fontSize: 14, lineHeight: 1.55 }}>
            {config.lede({ make: make.name, gen: gen.display_name, yrs })}
          </p>
        </section>

        <section>
          <h2 className="section-h">
            Specifications
            <span className="count">{rows.length}</span>
          </h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr>
                {["Fluid / location", "Capacity", "Viscosity / spec", "Service interval", "Notes"].map((h) => (
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
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const cap = r.capacity_qt && r.capacity_l
                  ? `${Number(r.capacity_qt).toFixed(2)} qt · ${Number(r.capacity_l).toFixed(2)} L`
                  : r.capacity_l ? `${Number(r.capacity_l).toFixed(2)} L`
                  : "—";
                const spec = [r.viscosity, r.spec_standard].filter(Boolean).join(" · ") || "—";
                const interval = r.drain_interval_mi
                  ? `${r.drain_interval_mi.toLocaleString()} mi / ${r.drain_interval_km?.toLocaleString() ?? "—"} km`
                  : r.drain_interval_months
                  ? `${r.drain_interval_months} months`
                  : "—";
                return (
                  <tr key={r.id}>
                    <th>
                      <strong style={{ color: "var(--ink)" }}>
                        {PRETTY_FLUID[r.fluid_type] ?? r.fluid_type}
                      </strong>
                    </th>
                    <td><strong>{cap}</strong></td>
                    <td>{spec}</td>
                    <td>{interval}</td>
                    <td className="alt">{r.notes ?? "—"}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </section>

        {faqs.length > 0 && (
          <section>
            <h2 className="section-h">
              Frequently asked
              <span className="count">{faqs.length}</span>
            </h2>
            <dl>
              {faqs.map((f) => (
                <div key={f.q} style={{ borderTop: "1px solid var(--rule)", padding: "14px 0" }}>
                  <dt style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>{f.q}</dt>
                  <dd style={{ margin: 0, color: "var(--ink-soft)", fontSize: 13, lineHeight: 1.55 }}>
                    {f.a}
                  </dd>
                </div>
              ))}
            </dl>
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
              padding: 0,
              margin: 0,
            }}
          >
            {[
              { href: `/${make.slug}/${gen.slug}/oil-capacity`, name: "Engine oil capacity", peek: "Capacity · viscosity · filter PN" },
              { href: `/${make.slug}/${gen.slug}/maintenance-schedule`, name: "Maintenance schedule", peek: "When each fluid is serviced" },
              { href: `/${make.slug}/${gen.slug}/torque`, name: "Torque specifications", peek: "Drain plug · diff fill · transfer-case" },
              { href: `/${make.slug}/${gen.slug}`, name: "Generation overview", peek: "Engine · performance · dimensions" },
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
                <a href={l.href} style={{ color: "var(--ink)", fontWeight: 500 }}>{l.name}</a>
                <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)", marginLeft: 12 }}>
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
