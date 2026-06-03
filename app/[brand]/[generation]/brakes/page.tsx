import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { buildCitationIndex, type RenderedRow } from "@/lib/citations";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { Cites } from "@/components/Cites";
import { axleLabel, brakeTypeLabel } from "@/lib/labels";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type Brake = {
  id: number;
  axle: string;
  brake_type: string | null;
  disc_diameter_mm: string | null;
  disc_thickness_mm: string | null;
  disc_min_thickness_mm: string | null;
  pad_min_mm: string | null;
  drum_diameter_mm: string | null;
  drum_max_mm: string | null;
  notes: string | null;
};
type Alignment = {
  id: number;
  axle: string;
  camber: string | null;
  caster: string | null;
  toe: string | null;
  thrust_angle: string | null;
  notes: string | null;
};

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND (EXISTS (SELECT 1 FROM brake_specs WHERE generation_id = g.id)
         OR EXISTS (SELECT 1 FROM alignment_specs WHERE generation_id = g.id))`,
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Brake discs & wheel alignment`,
    description: `Brake disc diameter, thickness and wear limits, plus front/rear wheel alignment (camber, caster, toe) for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Restated from workshop data, cited.`,
    path: `/${base.make.slug}/${base.gen.slug}/brakes`,
    heroPath,
  });
}

const AXLE_ORDER = (a: string) => (a === "front" ? 0 : 1);
const fmt = (v: string | null, unit: string) =>
  v != null && String(v).trim() !== "" ? `${Number(v) % 1 === 0 ? Number(v) : Number(v).toFixed(1)} ${unit}` : null;

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const [brakes, alignment] = await Promise.all([
    query<Brake>(
      `SELECT id, axle, brake_type, disc_diameter_mm, disc_thickness_mm,
              disc_min_thickness_mm, pad_min_mm, drum_diameter_mm, drum_max_mm, notes
       FROM brake_specs WHERE generation_id = ?`,
      [gen.id],
    ),
    query<Alignment>(
      `SELECT id, axle, camber, caster, toe, thrust_angle, notes
       FROM alignment_specs WHERE generation_id = ?`,
      [gen.id],
    ),
  ]);

  if (brakes.length === 0 && alignment.length === 0) notFound();

  brakes.sort((a, b) => AXLE_ORDER(a.axle) - AXLE_ORDER(b.axle));
  alignment.sort((a, b) => AXLE_ORDER(a.axle) - AXLE_ORDER(b.axle));

  const renderedRows: RenderedRow[] = [
    ...brakes.map((b) => ({ table: "brake_specs", id: b.id })),
    ...alignment.map((a) => ({ table: "alignment_specs", id: a.id })),
  ];
  const citations = await buildCitationIndex(gen.id, renderedRows);
  const sources = citations.sources;
  const mergeCites = (table: string, ids: number[]) =>
    [...new Set(ids.flatMap((id) => citations.citationsFor(table, id)))].sort((a, b) => a - b);
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const frontDisc = brakes.find((b) => b.axle === "front" && b.disc_diameter_mm);
  const faqs: Array<{ q: string; a: string }> = [];
  if (frontDisc?.disc_min_thickness_mm) {
    faqs.push({
      q: `What is the minimum brake disc thickness on the ${make.name} ${gen.display_name}?`,
      a: `The front brake disc on the ${make.name} ${gen.display_name} (${yrs}) has a wear limit of ${fmt(frontDisc.disc_min_thickness_mm, "mm")}${frontDisc.disc_thickness_mm ? `, from a new thickness of ${fmt(frontDisc.disc_thickness_mm, "mm")}` : ""}. Below the wear limit the disc must be replaced.`,
    });
  }
  if (frontDisc?.disc_diameter_mm) {
    faqs.push({
      q: `What size are the front brake discs on the ${make.name} ${gen.display_name}?`,
      a: `Front brake discs on the ${make.name} ${gen.display_name} (${yrs}) measure ${fmt(frontDisc.disc_diameter_mm, "mm")} in diameter.`,
    });
  }
  const frontAlign = alignment.find((a) => a.axle === "front");
  if (frontAlign?.toe || frontAlign?.camber) {
    faqs.push({
      q: `What are the wheel alignment specs for the ${make.name} ${gen.display_name}?`,
      a: `Front-axle setting on the ${make.name} ${gen.display_name} (${yrs}): ${[frontAlign.camber && `camber ${frontAlign.camber}`, frontAlign.caster && `caster ${frontAlign.caster}`, frontAlign.toe && `toe ${frontAlign.toe}`].filter(Boolean).join(", ")}.`,
    });
  }

  const th = (h: string) => (
    <th key={h} style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)", textAlign: "left", padding: "8px 12px" }}>{h}</th>
  );

  return (
    <>
      <SiteHeader />

      {faqs.length >= 2 && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(faqs)) }} />
      )}

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a><span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a><span className="sep">/</span>
          <span>Brakes</span>
        </nav>

        <div className="pagehead">
          <h1>Brake discs &amp; wheel alignment</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            {brakes.length > 0 && (<><span className="pip"></span><span>{brakes.length} axle{brakes.length !== 1 ? "s" : ""} of brake data</span></>)}
            {alignment.length > 0 && (<><span className="pip"></span><span>alignment geometry</span></>)}
          </div>
          <VerifyBadge sourceCount={sources.length} reviewDate={rev} scope="across" />
        </div>
      </div>

      <GenerationTabs brand={make.slug} generation={gen.slug} active="brakes" counts={{ brakes: brakes.length + alignment.length }} />

      <main className="shell">
        {brakes.length > 0 && (
          <section style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              Brake discs &amp; wear limits
              <span className="count">{brakes.length} axle{brakes.length !== 1 ? "s" : ""}</span>
              <Cites nums={mergeCites("brake_specs", brakes.map((b) => b.id))} />
            </h2>
            <p style={{ fontSize: 13, color: "var(--ink-soft)", marginBottom: 12, maxWidth: "70ch" }}>
              Disc diameter, new thickness and the manufacturer&apos;s minimum (wear) thickness. Replace a disc once it
              reaches the wear limit; replace pads before they reach the friction-material minimum.
            </p>
            <div className="table-scroll">
              <table className="spec-table">
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>{["Axle", "Type", "Diameter", "New thickness", "Min thickness", "Min pad", "Notes"].map(th)}</tr>
                </thead>
                <tbody>
                  {brakes.map((b) => (
                    <tr key={b.id}>
                      <th><strong>{axleLabel(b.axle)}</strong></th>
                      <td>{b.brake_type ? brakeTypeLabel(b.brake_type) : "—"}</td>
                      <td>{fmt(b.disc_diameter_mm, "mm") ?? fmt(b.drum_diameter_mm, "mm") ?? "—"}</td>
                      <td>{fmt(b.disc_thickness_mm, "mm") ?? "—"}</td>
                      <td>{fmt(b.disc_min_thickness_mm, "mm") ?? fmt(b.drum_max_mm, "mm (max)") ?? "—"}</td>
                      <td>{fmt(b.pad_min_mm, "mm") ?? "—"}</td>
                      <td className="alt" style={{ fontSize: 12 }}>{b.notes ?? "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}

        {alignment.length > 0 && (
          <section>
            <h2 className="section-h">
              Wheel alignment
              <span className="count">{alignment.length} axle{alignment.length !== 1 ? "s" : ""}</span>
              <Cites nums={mergeCites("alignment_specs", alignment.map((a) => a.id))} />
            </h2>
            <p style={{ fontSize: 13, color: "var(--ink-soft)", marginBottom: 12, maxWidth: "70ch" }}>
              Factory wheel-geometry settings. Values are the manufacturer&apos;s nominal setting with tolerance as published.
            </p>
            <div className="table-scroll">
              <table className="spec-table">
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>{["Axle", "Camber", "Caster", "Toe", "Thrust angle", "Notes"].map(th)}</tr>
                </thead>
                <tbody>
                  {alignment.map((a) => (
                    <tr key={a.id}>
                      <th><strong>{axleLabel(a.axle)}</strong></th>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 13 }}>{a.camber ?? "—"}</td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 13 }}>{a.caster ?? "—"}</td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 13 }}>{a.toe ?? "—"}</td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 13 }}>{a.thrust_angle ?? "—"}</td>
                      <td className="alt" style={{ fontSize: 12 }}>{a.notes ?? "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}

        <section>
          <h2 className="section-h">Related</h2>
          <ul style={{ listStyle: "none", display: "grid", gridTemplateColumns: "repeat(2, 1fr)", border: "1px solid var(--rule)", padding: 0, margin: 0 }}>
            {[
              { href: `/${make.slug}/${gen.slug}/torque`, name: "Torque specs", peek: "Caliper · carrier · wheel bolt" },
              { href: `/${make.slug}/${gen.slug}/brake-fluid`, name: "Brake fluid", peek: "Spec · capacity · interval" },
              { href: `/${make.slug}/${gen.slug}/parts`, name: "OE part numbers", peek: "Discs · pads · sensors" },
              { href: `/${make.slug}/${gen.slug}`, name: "Generation overview", peek: "Full specifications" },
            ].map((l) => (
              <li key={l.name} style={{ padding: "12px 16px", borderRight: "1px solid var(--rule)", borderBottom: "1px solid var(--rule)", fontSize: 13 }}>
                <a href={l.href} style={{ color: "var(--ink)", fontWeight: 500 }}>{l.name}</a>
                <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--ink-mute)", marginLeft: 12 }}>{l.peek}</span>
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
