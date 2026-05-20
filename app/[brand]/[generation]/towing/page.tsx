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
import { kgDual } from "@/lib/units";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type TrimTow = {
  id: number;
  name: string;
  curb_weight_kg: number | null;
  max_weight_kg: number | null;
  trailer_braked_kg: number | null;
  trailer_unbraked_kg: number | null;
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Towing capacity & GVWR`,
    description: `Manufacturer-published towing capacity (braked + unbraked), curb weight and GVWR per trim for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/towing`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const trims = await query<TrimTow>(
    `SELECT id, name, curb_weight_kg, max_weight_kg,
            trailer_braked_kg, trailer_unbraked_kg
     FROM trims
     WHERE generation_id = ?
       AND (trailer_braked_kg IS NOT NULL
            OR trailer_unbraked_kg IS NOT NULL
            OR max_weight_kg IS NOT NULL)
     ORDER BY COALESCE(trailer_braked_kg, max_weight_kg, curb_weight_kg) DESC`,
    [gen.id],
  );

  if (trims.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "trims");
  const yrs = yearRange(gen.start_year, gen.end_year);

  const maxBraked = trims
    .map((t) => t.trailer_braked_kg)
    .filter((v): v is number => v != null)
    .reduce((a, b) => Math.max(a, b), 0);
  const maxUnbraked = trims
    .map((t) => t.trailer_unbraked_kg)
    .filter((v): v is number => v != null)
    .reduce((a, b) => Math.max(a, b), 0);

  const faqs: Array<{ q: string; a: string }> = [];
  if (maxBraked > 0) {
    faqs.push({
      q: `What is the towing capacity of the ${make.name} ${gen.display_name}?`,
      a: `Manufacturer-rated braked-trailer towing capacity on the ${gen.display_name} (${yrs}) peaks at ${kgDual(maxBraked)}, depending on trim and tow-package option.${maxUnbraked > 0 ? ` Unbraked trailer capacity is rated up to ${kgDual(maxUnbraked)}.` : ""}`,
    });
  }
  faqs.push({
    q: "Braked vs unbraked — what's the difference?",
    a: "A braked trailer has its own service brake system (electric or hydraulic, actuated from the tow vehicle). It can be heavier because braking effort is shared. An unbraked trailer relies entirely on the tow vehicle's brakes — the rated capacity is much lower (typically 750 kg in EU, ~1,000 lb in US convention). Mixing the two ratings is a common mistake.",
  });
  faqs.push({
    q: "What is GVWR and how does it relate to payload?",
    a: "GVWR (Gross Vehicle Weight Rating) is the maximum total weight of the vehicle including passengers, cargo, fuel, and the tongue load of any trailer. Payload = GVWR − curb weight. Towing capacity is a separate manufacturer rating, but the GVWR limit still applies once you load the tongue.",
  });
  const faqLd = faqJsonLd(faqs);

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
          <span>Towing</span>
        </nav>

        <div className="pagehead">
          <h1>Towing capacity &amp; GVWR</h1>
          <div className="sub">
            {make.name} {gen.display_name}
            <span className="pip"></span>
            {yrs}
            <span className="pip"></span>
            {trims.length} trim{trims.length !== 1 ? "s" : ""} rated
          </div>
          <VerifyBadge sourceCount={sources.length} reviewDate={reviewDate(sources)} />
        </div>

        <GenerationTabs active="overview" brand={make.slug} generation={gen.slug} />

        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqLd) }} />

        <main className="shell">
          {(maxBraked > 0 || maxUnbraked > 0) && (
            <section>
              <h2 className="section-h">Headline capacity (across all trims)</h2>
              <div className="answer-card">
                {maxBraked > 0 && (
                  <>
                    <div>
                      <div className="a-label">Max braked trailer</div>
                      <div className="a-big">
                        {Math.round(maxBraked).toLocaleString()}
                        <span className="u">kg</span>
                      </div>
                      <div className="a-sub">{Math.round(maxBraked * 2.20462).toLocaleString()} lb</div>
                    </div>
                  </>
                )}
                {maxUnbraked > 0 && (
                  <div>
                    <div className="a-label">Max unbraked trailer</div>
                    <div className="a-big">
                      {Math.round(maxUnbraked).toLocaleString()}
                      <span className="u">kg</span>
                    </div>
                    <div className="a-sub">{Math.round(maxUnbraked * 2.20462).toLocaleString()} lb</div>
                  </div>
                )}
              </div>
            </section>
          )}

          <section style={{ marginTop: "var(--s-7)" }}>
            <h2 className="section-h">
              Per-trim ratings <span className="count">{trims.length} trims</span>
            </h2>
            <div className="table-scroll">
              <table className="spec-table">
                <thead>
                  <tr>
                    <th>Trim</th>
                    <th>Curb weight</th>
                    <th>GVWR</th>
                    <th>Trailer (braked)</th>
                    <th>Trailer (unbraked)</th>
                  </tr>
                </thead>
                <tbody>
                  {trims.map((t) => (
                    <tr key={t.id}>
                      <th>
                        <strong style={{ color: "var(--ink)" }}>{t.name}</strong>
                      </th>
                      <td>{t.curb_weight_kg ? kgDual(t.curb_weight_kg) : "—"}</td>
                      <td>{t.max_weight_kg ? kgDual(t.max_weight_kg) : "—"}</td>
                      <td>{t.trailer_braked_kg ? kgDual(t.trailer_braked_kg) : "—"}</td>
                      <td>{t.trailer_unbraked_kg ? kgDual(t.trailer_unbraked_kg) : "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>

          <section className="faq-block" style={{ marginTop: "var(--s-7)" }}>
            <h2 className="section-h">Frequently asked</h2>
            <dl className="faq-list">
              {faqs.map((f) => (
                <div key={f.q} className="faq-item">
                  <dt>{f.q}</dt>
                  <dd>{f.a}</dd>
                </div>
              ))}
            </dl>
          </section>

          <section style={{ marginTop: "var(--s-7)" }}>
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
                  href: `/${make.slug}/${gen.slug}`,
                  name: "Generation overview",
                  peek: "Full specifications · all engines",
                },
                {
                  href: `/${make.slug}/${gen.slug}/tires`,
                  name: "Tire pressures & sizes",
                  peek: "Placard PSI · OE size",
                },
                {
                  href: `/${make.slug}/${gen.slug}/torque`,
                  name: "Torque specifications",
                  peek: "Lug nut · drain · suspension",
                },
                {
                  href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                  name: "Maintenance schedule",
                  peek: "Severe duty when towing",
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
                  <a href={l.href} style={{ color: "var(--ink)", fontWeight: 500 }}>
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
      </div>
      <SiteFooter reviewDate={reviewDate(sources)} />
    </>
  );
}
