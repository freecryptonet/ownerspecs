import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getSourcesFor,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { bulbLabel } from "@/lib/labels";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type Bulb = {
  id: number;
  position: string;
  bulb_code: string;
  quantity: number;
  led_from_factory: number;
};

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND EXISTS (SELECT 1 FROM bulbs WHERE generation_id = g.id)`,
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Bulb sizes (headlight, brake, turn, interior)`,
    description: `Complete bulb manifest for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Headlight, brake, turn, fog, reverse, and interior bulb sizes — LED-from-factory positions flagged.`,
    path: `/${base.make.slug}/${base.gen.slug}/bulbs`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const bulbs = await query<Bulb>(
    `SELECT id, position, bulb_code, quantity, led_from_factory
     FROM bulbs WHERE generation_id = ?
     ORDER BY FIELD(position,
       'headlight_low','headlight_high','headlight_led','fog_front','fog_rear',
       'drl','turn_front','turn_side_mirror',
       'brake_tail','brake_chmsl','reverse','turn_rear',
       'license_plate',
       'interior_dome','interior_map','trunk','glove_box','cargo_lamp','bed_lamp','frunk'
     ), position`,
    [gen.id],
  );

  if (bulbs.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "bulbs");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Group by category for separate tables
  const exterior = bulbs.filter((b) =>
    /headlight|fog|drl|turn_front|turn_side|license_plate/.test(b.position),
  );
  const rear = bulbs.filter((b) =>
    /brake|reverse|turn_rear/.test(b.position),
  );
  const interior = bulbs.filter((b) =>
    /interior|trunk|glove|cargo|bed|frunk/.test(b.position),
  );

  const lowBeam = bulbs.find((b) => b.position === "headlight_low");
  const highBeam = bulbs.find((b) => b.position === "headlight_high");
  const brake = bulbs.find((b) => b.position === "brake_tail");
  const reverse = bulbs.find((b) => b.position === "reverse");

  const faqs: Array<{ q: string; a: string }> = [];
  if (lowBeam) {
    faqs.push({
      q: `What low-beam headlight bulb does the ${make.name} ${gen.display_name} use?`,
      a: `Low beam on the ${make.name} ${gen.display_name} (${yrs}) is ${lowBeam.bulb_code}${lowBeam.led_from_factory ? " (LED from factory on most trims — not user-replaceable)" : ""}. Two bulbs total (one per side).`,
    });
  }
  if (highBeam && highBeam.bulb_code !== lowBeam?.bulb_code) {
    faqs.push({
      q: `What high-beam bulb does the ${make.name} ${gen.display_name} use?`,
      a: `High beam is ${highBeam.bulb_code}${highBeam.led_from_factory ? " LED" : ""} on the ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  if (brake) {
    faqs.push({
      q: `What brake light bulb does the ${make.name} ${gen.display_name} use?`,
      a: `Combined brake/tail bulb is ${brake.bulb_code}${brake.led_from_factory ? " (LED from factory)" : ""}. Two bulbs total.`,
    });
  }
  if (reverse) {
    faqs.push({
      q: `What reverse light bulb does the ${make.name} ${gen.display_name} use?`,
      a: `Reverse bulb is ${reverse.bulb_code}${reverse.led_from_factory ? " (LED)" : ""}. Common upgrade target — most owners switch to a 6000K LED 921 or W16W.`,
    });
  }

  const renderTable = (rows: Bulb[]) => (
    <table className="spec-table">
      <thead style={{ background: "var(--bg-alt)" }}>
        <tr>
          {["Position", "Bulb code / type", "Qty", "Notes"].map((h) => (
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
        {rows.map((b) => (
          <tr key={b.id}>
            <th>
              <strong style={{ color: "var(--ink)" }}>{bulbLabel(b.position)}</strong>
            </th>
            <td><code>{b.bulb_code}</code></td>
            <td>{b.quantity}</td>
            <td className="alt">
              {b.led_from_factory ? "Factory LED — sealed unit on most trims" : "User-replaceable"}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );

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
          <span>Bulbs</span>
        </nav>

        <div className="pagehead">
          <h1>Bulb sizes & manifest</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{bulbs.length} positions documented</span>
          </div>
          <VerifyBadge sourceCount={sources.length} reviewDate={rev} scope="across" />
        </div>
      </div>

      <GenerationTabs brand={make.slug} generation={gen.slug} active="electrical" />

      <main className="shell">
        {exterior.length > 0 && (
          <section style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Exterior — front
              <span className="count">{exterior.length}</span>
            </h2>
            {renderTable(exterior)}
          </section>
        )}

        {rear.length > 0 && (
          <section>
            <h2 className="section-h">
              Exterior — rear
              <span className="count">{rear.length}</span>
            </h2>
            {renderTable(rear)}
          </section>
        )}

        {interior.length > 0 && (
          <section>
            <h2 className="section-h">
              Interior
              <span className="count">{interior.length}</span>
            </h2>
            {renderTable(interior)}
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
              { href: `/${make.slug}/${gen.slug}/fuses`, name: "Fuse box layout", peek: "Under-hood + cabin positions" },
              { href: `/${make.slug}/${gen.slug}/electrical`, name: "Battery & alternator", peek: "Group · CCA · Ah · alt amps" },
              { href: `/${make.slug}/${gen.slug}/parts`, name: "OE part numbers", peek: "Plugs · filters · wipers" },
              { href: `/${make.slug}/${gen.slug}`, name: "Generation overview", peek: "Full specifications" },
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
