import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getAllGenerationParams,
  getSourcesFor,
  yearRange,
  reviewDate,
  type SourceRow,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { bulbLabel, fuseLocationLabel } from "@/lib/labels";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

type Electrical = {
  battery_group: string | null;
  cca: number | null;
  ah: number | null;
  alternator_amps: number | null;
};
type Bulb = {
  id: number;
  position: string;
  bulb_code: string;
  quantity: number;
  led_from_factory: number;
};
type Fuse = {
  id: number;
  location: string;
  position: string;
  amperage: string | null;
  circuit_name: string | null;
  is_relay: number;
};

// bulbLabel imported from @/lib/labels — covers drl / frunk / cargo /
// cargo_bed which were missing from the previous hand-maintained map.

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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Battery, bulbs & fuses`,
    description: `Battery group, CCA, alternator, full bulb manifest, fuse box layout for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Cross-verified, cited.`,
    path: `/${base.make.slug}/${base.gen.slug}/electrical`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const [electrical, bulbs, fuses, srcEl, srcBulb, srcFuse] = await Promise.all([
    queryOne<Electrical>(
      `SELECT battery_group, cca, ah, alternator_amps
       FROM electrical_specs WHERE generation_id = ? LIMIT 1`,
      [gen.id],
    ),
    query<Bulb>(
      `SELECT id, position, bulb_code, quantity, led_from_factory
       FROM bulbs WHERE generation_id = ?
       ORDER BY FIELD(position,'headlight_low','headlight_high','fog_front','fog_rear',
                                'brake_tail','reverse','turn_front','turn_rear',
                                'license_plate','side_marker',
                                'interior_dome','interior_map','glove_box','trunk'),
                position`,
      [gen.id],
    ),
    query<Fuse>(
      `SELECT id, location, position, amperage, circuit_name, is_relay
       FROM fuses WHERE generation_id = ?
       ORDER BY FIELD(location,'under_hood','cabin','trunk'),
                LENGTH(position), position`,
      [gen.id],
    ),
    getSourcesFor(gen.id, "electrical_specs"),
    getSourcesFor(gen.id, "bulbs"),
    getSourcesFor(gen.id, "fuses"),
  ]);

  if (!electrical && bulbs.length === 0 && fuses.length === 0) notFound();

  // Union of sources from all 3 tables on this page
  const sourcesMap = new Map<number, SourceRow>();
  for (const s of [...srcEl, ...srcBulb, ...srcFuse]) sourcesMap.set(s.id, s);
  const sources = [...sourcesMap.values()].sort((a, b) => a.id - b.id);
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Group fuses by location for separate tables
  const fuseGroups = fuses.reduce<Record<string, Fuse[]>>((acc, f) => {
    (acc[f.location] = acc[f.location] || []).push(f);
    return acc;
  }, {});

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
          <span>Electrical</span>
        </nav>

        <div className="pagehead">
          <h1>Battery, bulbs &amp; fuses</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{bulbs.length} bulb positions · {fuses.length} fuse positions</span>
            {electrical?.battery_group && (
              <>
                <span className="pip"></span>
                <span>Battery group {electrical.battery_group}</span>
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
        active="electrical"
        counts={{ electrical: bulbs.length + fuses.length + 1 }}
      />

      <main className="shell">
        {/* BATTERY + ALTERNATOR */}
        {electrical && (
          <section style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">Battery &amp; charging system</h2>
            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(4, 1fr)",
                gap: 16,
              }}
            >
              {[
                {
                  label: "Battery group",
                  value: electrical.battery_group ? `BCI ${electrical.battery_group}` : "—",
                  unit: "",
                },
                {
                  label: "Cold cranking amps",
                  value: electrical.cca?.toString() ?? "—",
                  unit: "CCA",
                },
                {
                  label: "Capacity",
                  value: electrical.ah?.toString() ?? "—",
                  unit: "Ah",
                },
                {
                  label: "Alternator output",
                  value: electrical.alternator_amps?.toString() ?? "—",
                  unit: "A",
                },
              ].map((c) => (
                <div
                  key={c.label}
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
                    {c.label}
                  </div>
                  <div
                    style={{
                      marginTop: 8,
                      fontFamily: "var(--font-mono)",
                      fontSize: 24,
                      fontWeight: 600,
                      letterSpacing: "-0.01em",
                      color: "var(--ink)",
                      fontVariantNumeric: "tabular-nums",
                      lineHeight: 1,
                      display: "flex",
                      alignItems: "baseline",
                      gap: 6,
                    }}
                  >
                    {c.value}
                    {c.unit && (
                      <span
                        style={{
                          fontFamily: "Inter, sans-serif",
                          fontSize: 14,
                          fontWeight: 400,
                          color: "var(--ink-mute)",
                        }}
                      >
                        {c.unit}
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* BULBS */}
        {bulbs.length > 0 && (
          <section>
            <h2 className="section-h">
              Bulb manifest
              <span className="count">{bulbs.length} positions</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Position", "Bulb code", "Qty", "Factory LED"].map((h) => (
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
                {bulbs.map((b) => (
                  <tr key={b.id}>
                    <th>{bulbLabel(b.position)}</th>
                    <td>
                      <strong>{b.bulb_code}</strong>
                    </td>
                    <td>{b.quantity}×</td>
                    <td>{b.led_from_factory ? "Yes" : "No"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

        {/* FUSES — one table per location */}
        {Object.entries(fuseGroups).map(([location, rows]) => (
          <section key={location}>
            <h2 className="section-h">
              Fuse box · {location.replace(/_/g, " ")}
              <span className="count">{rows.length} positions</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Position", "Amperage", "Circuit", "Type"].map((h) => (
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
                {rows.map((f) => (
                  <tr key={f.id}>
                    <th>
                      <strong>{f.position}</strong>
                    </th>
                    <td>{f.amperage ? `${f.amperage} A` : "—"}</td>
                    <td className="alt">{f.circuit_name ?? "—"}</td>
                    <td>{f.is_relay ? "Relay" : "Fuse"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        ))}

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
                peek: "Viscosity · capacity · drain interval",
              },
              {
                href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                name: "Maintenance schedule",
                peek: "TPMS battery interval · 90,000 mi",
              },
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Torque specifications",
                peek: "Battery hold-down · ground strap",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Full specifications · all engines",
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
