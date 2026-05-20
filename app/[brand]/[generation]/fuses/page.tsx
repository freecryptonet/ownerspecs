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
import { fuseLocationLabel } from "@/lib/labels";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type Fuse = {
  id: number;
  location: string;
  position: string;
  amperage: string | null;
  circuit_name: string | null;
};

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND EXISTS (SELECT 1 FROM fuses WHERE generation_id = g.id)`,
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Fuse box layout & amperage`,
    description: `Complete fuse box layout for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Under-hood and cabin positions, amperage ratings, and circuit names — restated from owner manual.`,
    path: `/${base.make.slug}/${base.gen.slug}/fuses`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const fuses = await query<Fuse>(
    `SELECT id, location, position, amperage, circuit_name
     FROM fuses WHERE generation_id = ?
     ORDER BY FIELD(location,'engine_bay','under_hood','cabin','frunk','trunk'),
              LENGTH(position), position`,
    [gen.id],
  );

  if (fuses.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "fuses");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Group by location
  const groups = fuses.reduce<Record<string, Fuse[]>>((acc, f) => {
    (acc[f.location] = acc[f.location] || []).push(f);
    return acc;
  }, {});

  const fuelPump = fuses.find((f) => /fuel\s*pump/i.test(f.circuit_name ?? ""));
  const cigarLighter = fuses.find((f) => /cigar|12v|power outlet|accessory/i.test(f.circuit_name ?? ""));
  const obd = fuses.find((f) => /obd|diagnostic/i.test(f.circuit_name ?? ""));
  const audio = fuses.find((f) => /audio|multimedia|radio|head unit|infotainment/i.test(f.circuit_name ?? ""));

  const faqs: Array<{ q: string; a: string }> = [];
  if (fuelPump) {
    faqs.push({
      q: `Which fuse is the fuel pump on the ${make.name} ${gen.display_name}?`,
      a: `The fuel pump fuse is position ${fuelPump.position} in the ${fuseLocationLabel(fuelPump.location).toLowerCase()} fuse box, rated at ${fuelPump.amperage} A on the ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  if (cigarLighter) {
    faqs.push({
      q: `Which fuse controls the 12V power outlet / cigar lighter on the ${make.name} ${gen.display_name}?`,
      a: `Position ${cigarLighter.position}${cigarLighter.location ? ` in the ${fuseLocationLabel(cigarLighter.location).toLowerCase()} fuse box` : ""}, ${cigarLighter.amperage} A on the ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  if (obd) {
    faqs.push({
      q: `Which fuse protects the OBD-II port on the ${make.name} ${gen.display_name}?`,
      a: `OBD-II port fuse is position ${obd.position} at ${obd.amperage} A. If the port is dead but the car runs, this is the first fuse to check.`,
    });
  }
  if (audio) {
    faqs.push({
      q: `Which fuse controls the radio / multimedia on the ${make.name} ${gen.display_name}?`,
      a: `${audio.circuit_name} fuse is position ${audio.position}, ${audio.amperage} A. ${make.name} ${gen.display_name} (${yrs}).`,
    });
  }
  faqs.push({
    q: `How many fuses does the ${make.name} ${gen.display_name} have?`,
    a: `${fuses.length} fuse positions documented across ${Object.keys(groups).length} fuse box${Object.keys(groups).length > 1 ? "es" : ""} (${Object.keys(groups).map((k) => fuseLocationLabel(k).toLowerCase()).join(", ")}) on the ${make.name} ${gen.display_name} (${yrs}).`,
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
          <span>Fuses</span>
        </nav>

        <div className="pagehead">
          <h1>Fuse box layout & amperage</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{fuses.length} fuse positions</span>
          </div>
          <VerifyBadge sourceCount={sources.length} reviewDate={rev} scope="across" />
        </div>
      </div>

      <GenerationTabs brand={make.slug} generation={gen.slug} active="electrical" />

      <main className="shell">
        {Object.entries(groups).map(([location, rows]) => (
          <section key={location} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              {fuseLocationLabel(location)} fuse box
              <span className="count">{rows.length}</span>
            </h2>
            <table className="spec-table">
              <thead style={{ background: "var(--bg-alt)" }}>
                <tr>
                  {["Position", "Amperage", "Circuit"].map((h) => (
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
                      <strong style={{ color: "var(--ink)" }}>{f.position}</strong>
                    </th>
                    <td>
                      <strong>{f.amperage} A</strong>
                    </td>
                    <td className="alt">{f.circuit_name ?? "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        ))}

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
              { href: `/${make.slug}/${gen.slug}/bulbs`, name: "Bulb manifest", peek: "Headlight, brake, turn, interior sizes" },
              { href: `/${make.slug}/${gen.slug}/electrical`, name: "Battery & alternator", peek: "Group · CCA · Ah · alt amps" },
              { href: `/${make.slug}/${gen.slug}/procedures`, name: "Service procedures", peek: "Battery disconnect · jump-start" },
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
