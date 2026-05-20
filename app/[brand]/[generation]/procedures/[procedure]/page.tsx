import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
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
import { pageMetadata } from "@/lib/seo";
import { renderMarkdown } from "@/lib/markdown";

type Params = { brand: string; generation: string; procedure: string };
type ProcRow = {
  id: number;
  procedure_type: string;
  slug: string;
  title: string;
  body_md: string;
  tools_required: string | null;
  common_mistakes: string | null;
};
type SiblingRow = { slug: string; title: string; procedure_type: string };

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    "SELECT mk.slug AS brand, g.slug AS generation, p.slug AS `procedure` " +
    "FROM procedures p " +
    "JOIN generations g ON g.id = p.generation_id " +
    "JOIN models m      ON m.id = g.model_id " +
    "JOIN makes mk      ON mk.id = m.make_id",
  );
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation, procedure } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const proc = await queryOne<ProcRow>(
    `SELECT id, procedure_type, slug, title, body_md, tools_required, common_mistakes
     FROM procedures WHERE generation_id = ? AND slug = ? LIMIT 1`,
    [base.gen.id, procedure],
  );
  if (!proc) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${proc.title} — ${base.make.name} ${base.gen.display_name} ${yrs}`,
    description: `${proc.title} procedure for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Step-by-step, restated from the owner manual and factory service information.`,
    path: `/${base.make.slug}/${base.gen.slug}/procedures/${proc.slug}`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation, procedure } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const proc = await queryOne<ProcRow>(
    `SELECT id, procedure_type, slug, title, body_md, tools_required, common_mistakes
     FROM procedures WHERE generation_id = ? AND slug = ? LIMIT 1`,
    [gen.id, procedure],
  );
  if (!proc) notFound();

  const siblings = await query<SiblingRow>(
    `SELECT slug, title, procedure_type
     FROM procedures
     WHERE generation_id = ? AND slug != ?
     ORDER BY FIELD(procedure_type,
       'oil_life_reset','maintenance_minder_reset','service_reminder_reset',
       'tpms_relearn','throttle_adapt','steering_angle_calibration','battery_register',
       'epb_service_mode','brake_pad_replacement','brake_bleed',
       'jump_start','flat_tow','spare_tire','jack_points',
       'battery_disconnect_order','battery_replacement','key_fob_battery'
     ), title
     LIMIT 8`,
    [gen.id, procedure],
  );

  const sources = await getSourcesFor(gen.id, "procedures");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const bodyHtml = renderMarkdown(proc.body_md);

  // Extract step text from the markdown body (numbered list items under
  // "## Procedure" / "## Steps" headings, or any ordered list). Each list
  // item becomes a HowToStep in the JSON-LD payload.
  const lines = proc.body_md.replace(/\r\n/g, "\n").split("\n");
  const steps: string[] = [];
  let inOl = false;
  for (const raw of lines) {
    const line = raw.trim();
    const olm = line.match(/^(\d+)\.\s+(.+)$/);
    if (olm) {
      steps.push(olm[2].replace(/\*\*([^*]+)\*\*/g, "$1").replace(/`([^`]+)`/g, "$1").trim());
      inOl = true;
    } else if (inOl && !line) {
      inOl = false;
    }
  }

  const howToJsonLd = {
    "@context": "https://schema.org",
    "@type": "HowTo",
    name: `${proc.title}`,
    description: `${proc.title} for the ${make.name} ${gen.display_name} (${yrs}). Restated from owner manual and factory service information.`,
    totalTime: "PT5M",
    supply: [],
    tool: [],
    step: steps.slice(0, 12).map((text, idx) => ({
      "@type": "HowToStep",
      position: idx + 1,
      text,
    })),
    vehicleAtRisk: {
      "@type": "Vehicle",
      name: `${make.name} ${gen.display_name}`,
      brand: { "@type": "Brand", name: make.name },
      model: model.name,
      modelDate: yrs,
    },
  };

  return (
    <>
      <SiteHeader />

      {steps.length > 0 && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(howToJsonLd) }}
        />
      )}

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
          <a href={`/${make.slug}/${gen.slug}/procedures`}>Procedures</a>
          <span className="sep">/</span>
          <span>{proc.title}</span>
        </nav>

        <div className="pagehead">
          <h1>{proc.title}</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span style={{ textTransform: "capitalize" }}>
              {proc.procedure_type.replace(/_/g, " ")}
            </span>
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
        active="procedures"
      />

      <main className="shell">
        <article
          className="procedure-body"
          style={{ paddingTop: "var(--s-5)", maxWidth: 760 }}
          dangerouslySetInnerHTML={{ __html: bodyHtml }}
        />

        {proc.tools_required && (
          <section style={{ maxWidth: 760 }}>
            <h2 className="section-h">Tools required</h2>
            <div
              style={{
                background: "var(--bg-alt)",
                border: "1px solid var(--rule)",
                borderLeft: "3px solid var(--accent)",
                padding: "14px 18px",
                fontSize: 13,
                lineHeight: 1.6,
                whiteSpace: "pre-wrap",
                color: "var(--ink-soft)",
              }}
            >
              {proc.tools_required}
            </div>
          </section>
        )}

        {proc.common_mistakes && (
          <section style={{ maxWidth: 760 }}>
            <h2 className="section-h">Common mistakes &amp; how to avoid them</h2>
            <div
              style={{
                background: "#fffaf3",
                border: "1px solid #f3e5c1",
                borderLeft: "3px solid #d97706",
                padding: "14px 18px",
                fontSize: 13,
                lineHeight: 1.6,
                whiteSpace: "pre-wrap",
                color: "var(--ink)",
              }}
            >
              {proc.common_mistakes}
            </div>
          </section>
        )}

        {siblings.length > 0 && (
          <section>
            <h2 className="section-h">Other procedures for this generation</h2>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
                gap: 8,
              }}
            >
              {siblings.map((s) => (
                <li key={s.slug}>
                  <a
                    href={`/${make.slug}/${gen.slug}/procedures/${s.slug}`}
                    style={{
                      display: "block",
                      padding: "10px 14px",
                      border: "1px solid var(--rule)",
                      color: "var(--ink)",
                      fontSize: 13,
                    }}
                  >
                    <span
                      style={{
                        fontSize: 10,
                        fontWeight: 600,
                        letterSpacing: "0.08em",
                        textTransform: "uppercase",
                        color: "var(--ink-soft)",
                        display: "block",
                        marginBottom: 2,
                      }}
                    >
                      {s.procedure_type.replace(/_/g, " ")}
                    </span>
                    {s.title}
                  </a>
                </li>
              ))}
            </ul>
          </section>
        )}

        <SourcesBlock sources={sources} />
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
