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
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type Part = {
  id: number;
  part_type: string;
  part_number: string;
  source_brand: string | null;
  gap_mm: string | null;
  size: string | null;
  notes: string | null;
};

const PART_LABEL: Record<string, string> = {
  spark_plug: "Spark plug",
  oil_filter: "Oil filter",
  oil_filter_v6: "Oil filter (V6)",
  air_filter: "Engine air filter",
  cabin_filter: "Cabin air filter",
  wiper_front_d: "Wiper blade — driver",
  wiper_front_p: "Wiper blade — passenger",
  wiper_rear: "Wiper blade — rear",
  brake_pad_front: "Brake pads — front",
  brake_pad_rear: "Brake pads — rear",
  key_card: "Key card",
  mobile_connect: "Mobile connector",
};

const GROUPS: Array<{ label: string; keys: string[] }> = [
  { label: "Ignition", keys: ["spark_plug"] },
  { label: "Filters", keys: ["oil_filter", "oil_filter_v6", "air_filter", "cabin_filter"] },
  { label: "Wipers", keys: ["wiper_front_d", "wiper_front_p", "wiper_rear"] },
  { label: "Brakes", keys: ["brake_pad_front", "brake_pad_rear"] },
  { label: "Accessories", keys: ["key_card", "mobile_connect"] },
];

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND EXISTS (SELECT 1 FROM parts WHERE generation_id = g.id)`,
  );
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — OE part numbers (filters, plugs, wipers)`,
    description: `OEM part numbers for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Oil filter, air filter, cabin filter, spark plug, wiper blade sizes — Genuine catalog references.`,
    path: `/${base.make.slug}/${base.gen.slug}/parts`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const parts = await query<Part>(
    `SELECT id, part_type, part_number, source_brand, gap_mm, size, notes
     FROM parts WHERE generation_id = ?
     ORDER BY FIELD(part_type,
       'spark_plug',
       'oil_filter','oil_filter_v6','air_filter','cabin_filter',
       'wiper_front_d','wiper_front_p','wiper_rear',
       'brake_pad_front','brake_pad_rear'
     ), part_number`,
    [gen.id],
  );

  if (parts.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "parts");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const groups = GROUPS.map((g) => ({
    ...g,
    rows: parts.filter((p) => g.keys.includes(p.part_type)),
  })).filter((g) => g.rows.length > 0);

  const ungrouped = parts.filter(
    (p) => !GROUPS.some((g) => g.keys.includes(p.part_type)),
  );

  // FAQ from highest-volume parts
  const sparkPlug = parts.find((p) => p.part_type === "spark_plug");
  const oilFilter = parts.find((p) => p.part_type === "oil_filter");
  const airFilter = parts.find((p) => p.part_type === "air_filter");
  const cabinFilter = parts.find((p) => p.part_type === "cabin_filter");
  const wiperD = parts.find((p) => p.part_type === "wiper_front_d");

  const faqs: Array<{ q: string; a: string }> = [];
  if (sparkPlug) {
    faqs.push({
      q: `What spark plug does the ${make.name} ${gen.display_name} use?`,
      a: `OE spark plug for the ${make.name} ${gen.display_name} (${yrs}) is ${sparkPlug.part_number}${sparkPlug.source_brand ? ` (${sparkPlug.source_brand})` : ""}${sparkPlug.gap_mm ? `, gapped to ${sparkPlug.gap_mm} mm` : ""}.${sparkPlug.notes ? ` ${sparkPlug.notes}` : ""}`,
    });
  }
  if (oilFilter) {
    faqs.push({
      q: `What is the oil filter part number for the ${make.name} ${gen.display_name}?`,
      a: `OE oil filter part number is ${oilFilter.part_number}${oilFilter.source_brand ? ` (${oilFilter.source_brand})` : ""} for the ${make.name} ${gen.display_name} (${yrs}).${oilFilter.notes ? ` ${oilFilter.notes}` : ""}`,
    });
  }
  if (airFilter) {
    faqs.push({
      q: `What is the air filter part number for the ${make.name} ${gen.display_name}?`,
      a: `OE engine air filter part number is ${airFilter.part_number}${airFilter.source_brand ? ` (${airFilter.source_brand})` : ""} for the ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  if (cabinFilter) {
    faqs.push({
      q: `What cabin filter fits the ${make.name} ${gen.display_name}?`,
      a: `OE cabin air filter part number is ${cabinFilter.part_number}${cabinFilter.source_brand ? ` (${cabinFilter.source_brand})` : ""}${cabinFilter.notes ? ` — ${cabinFilter.notes.toLowerCase()}` : ""} for the ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  if (wiperD) {
    faqs.push({
      q: `What size wiper blades fit the ${make.name} ${gen.display_name}?`,
      a: `Driver-side wiper blade is ${wiperD.size ?? "—"}${parts.find((p) => p.part_type === "wiper_front_p") ? `, passenger side is ${parts.find((p) => p.part_type === "wiper_front_p")?.size ?? "—"}` : ""}. OE Genuine part numbers shown in the table.`,
    });
  }

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
          <span>Parts</span>
        </nav>

        <div className="pagehead">
          <h1>OE part numbers</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{parts.length} parts documented</span>
            <span className="pip"></span>
            <span>Genuine catalog references</span>
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
        active="overview"
      />

      <main className="shell">
        {groups.map((group) => (
          <section key={group.label} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              {group.label}
              <span className="count">{group.rows.length}</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Part", "Genuine part #", "Brand", "Size / gap", "Notes"].map((h) => (
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
                {group.rows.map((p) => (
                  <tr key={p.id}>
                    <th>
                      <strong style={{ color: "var(--ink)" }}>
                        {PART_LABEL[p.part_type] ?? p.part_type}
                      </strong>
                    </th>
                    <td>
                      <code
                        style={{
                          fontFamily: "var(--font-mono)",
                          fontSize: 13,
                          background: "var(--bg-alt)",
                          padding: "2px 6px",
                          borderRadius: 2,
                        }}
                      >
                        {p.part_number}
                      </code>
                    </td>
                    <td>{p.source_brand ?? "—"}</td>
                    <td>{p.gap_mm ? `${p.gap_mm} mm gap` : p.size ?? "—"}</td>
                    <td className="alt">{p.notes ?? "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        ))}

        {ungrouped.length > 0 && (
          <section>
            <h2 className="section-h">Other</h2>
            <table className="spec-table">
              <tbody>
                {ungrouped.map((p) => (
                  <tr key={p.id}>
                    <th>{PART_LABEL[p.part_type] ?? p.part_type}</th>
                    <td><code>{p.part_number}</code></td>
                    <td>{p.source_brand ?? "—"}</td>
                    <td className="alt">{p.notes ?? "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        )}

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
                  <dd style={{ margin: 0, color: "var(--ink-soft)", fontSize: 13, lineHeight: 1.55 }}>{f.a}</dd>
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
              { href: `/${make.slug}/${gen.slug}/oil-capacity`, name: "Engine oil & filter", peek: "Capacity · viscosity · filter PN" },
              { href: `/${make.slug}/${gen.slug}/electrical`, name: "Bulbs & fuses", peek: "Battery group · alternator · fuse map" },
              { href: `/${make.slug}/${gen.slug}/maintenance-schedule`, name: "Maintenance schedule", peek: "When each part is replaced" },
              { href: `/${make.slug}/${gen.slug}/torque`, name: "Torque specifications", peek: "Spark plug · drain plug · caliper" },
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
