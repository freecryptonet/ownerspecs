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
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };
type ProcRow = {
  id: number;
  procedure_type: string;
  slug: string;
  title: string;
  body_md: string;
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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Service procedures`,
    description: `Owner-relevant procedures for the ${base.gen.display_name} (${base.make.name}, ${yrs}) — oil-life reset, TPMS relearn, EPB service mode, jump-start, battery disconnect, jack points. Restated from owner manual and FSM.`,
    path: `/${base.make.slug}/${base.gen.slug}/procedures`,
    heroPath,
  });
}

const FIRST_LINE = (md: string): string => {
  const first = md.split(/\n+/).find((l) => l.trim() && !l.startsWith("#")) ?? "";
  return first.replace(/[*`]/g, "").trim().slice(0, 140);
};

const TYPE_GROUPS: Array<{ label: string; keys: string[] }> = [
  { label: "Service resets", keys: ["oil_life_reset", "maintenance_minder_reset", "service_reminder_reset"] },
  { label: "Calibrations", keys: ["tpms_relearn", "throttle_adapt", "steering_angle_calibration", "battery_register"] },
  { label: "Brake service", keys: ["epb_service_mode", "brake_pad_replacement", "brake_bleed"] },
  { label: "Roadside", keys: ["jump_start", "flat_tow", "spare_tire", "jack_points"] },
  { label: "Battery & electrical", keys: ["battery_disconnect_order", "battery_replacement", "key_fob_battery"] },
];

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const procs = await query<ProcRow>(
    `SELECT id, procedure_type, slug, title, body_md
     FROM procedures
     WHERE generation_id = ?
     ORDER BY FIELD(procedure_type,
       'oil_life_reset','maintenance_minder_reset','service_reminder_reset',
       'tpms_relearn','throttle_adapt','steering_angle_calibration','battery_register',
       'epb_service_mode','brake_pad_replacement','brake_bleed',
       'jump_start','flat_tow','spare_tire','jack_points',
       'battery_disconnect_order','battery_replacement','key_fob_battery'
     ), title`,
    [gen.id],
  );

  if (procs.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "procedures");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const groups = TYPE_GROUPS.map((g) => ({
    ...g,
    rows: procs.filter((p) => g.keys.includes(p.procedure_type)),
  })).filter((g) => g.rows.length > 0);

  const ungrouped = procs.filter(
    (p) => !TYPE_GROUPS.some((g) => g.keys.includes(p.procedure_type)),
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
          <span>Procedures</span>
        </nav>

        <div className="pagehead">
          <h1>Service procedures</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{procs.length} procedures documented</span>
            <span className="pip"></span>
            <span>Restated from OM / FSM</span>
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
        counts={{ procedures: procs.length }}
      />

      <main className="shell">
        {groups.map((group) => (
          <section key={group.label} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              {group.label}
              <span className="count">{group.rows.length}</span>
            </h2>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(320px, 1fr))",
                gap: 12,
              }}
            >
              {group.rows.map((p) => (
                <li
                  key={p.id}
                  style={{
                    border: "1px solid var(--rule)",
                    borderLeft: "3px solid var(--accent)",
                    background: "var(--bg-alt)",
                    padding: "14px 18px",
                  }}
                >
                  <a
                    href={`/${make.slug}/${gen.slug}/procedures/${p.slug}`}
                    style={{ color: "var(--ink)" }}
                  >
                    <div
                      style={{
                        fontSize: 11,
                        fontWeight: 600,
                        letterSpacing: "0.08em",
                        textTransform: "uppercase",
                        color: "var(--ink-soft)",
                        marginBottom: 4,
                      }}
                    >
                      {p.procedure_type.replace(/_/g, " ")}
                    </div>
                    <div
                      style={{
                        fontSize: 16,
                        fontWeight: 600,
                        lineHeight: 1.25,
                        marginBottom: 6,
                      }}
                    >
                      {p.title}
                    </div>
                    <div
                      style={{
                        fontSize: 13,
                        color: "var(--ink-soft)",
                        lineHeight: 1.45,
                      }}
                    >
                      {FIRST_LINE(p.body_md)}
                    </div>
                  </a>
                </li>
              ))}
            </ul>
          </section>
        ))}

        {ungrouped.length > 0 && (
          <section>
            <h2 className="section-h">
              Other procedures
              <span className="count">{ungrouped.length}</span>
            </h2>
            <ul style={{ listStyle: "none", padding: 0, margin: 0 }}>
              {ungrouped.map((p) => (
                <li key={p.id} style={{ padding: "8px 0" }}>
                  <a href={`/${make.slug}/${gen.slug}/procedures/${p.slug}`}>
                    {p.title}
                  </a>
                </li>
              ))}
            </ul>
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
              {
                href: `/${make.slug}/${gen.slug}/maintenance-schedule`,
                name: "Maintenance schedule",
                peek: "When each service is due",
              },
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Torque specifications",
                peek: "Wheel lug, plug, drain, suspension",
              },
              {
                href: `/${make.slug}/${gen.slug}/electrical`,
                name: "Battery, bulbs & fuses",
                peek: "Group · CCA · fuse map",
              },
              {
                href: `/${make.slug}/${gen.slug}/oil-capacity`,
                name: "Engine oil capacity",
                peek: "Drain plug · filter PN · viscosity",
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

      <SiteFooter reviewDate={rev} />
    </>
  );
}
