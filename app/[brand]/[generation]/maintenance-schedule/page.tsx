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
import { serviceLabel } from "@/lib/labels";
import { pageMetadata, faqJsonLd } from "@/lib/seo";

type Params = { brand: string; generation: string };

type ServiceRow = {
  id: number;
  service: string;
  miles_normal: number | null;
  miles_severe: number | null;
  km_normal: number | null;
  km_severe: number | null;
  months: number | null;
  notes: string | null;
};

// serviceLabel imported from @/lib/labels

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
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Maintenance schedule`,
    description: `Full maintenance schedule for the ${base.gen.display_name} (${base.make.name}, ${yrs}), normal and severe-duty intervals. Every service from 7,500 to 150,000 miles, cross-verified.`,
    path: `/${base.make.slug}/${base.gen.slug}/maintenance-schedule`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const services = await query<ServiceRow>(
    `SELECT id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes
     FROM service_intervals
     WHERE generation_id = ?
     ORDER BY COALESCE(miles_normal, miles_severe, 999999), service`,
    [gen.id],
  );

  if (services.length === 0) notFound();

  const sources = await getSourcesFor(gen.id, "service_intervals");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  // Build column headers from union of normal-duty mileages
  const milestones = Array.from(
    new Set(
      services
        .map((s) => s.miles_normal)
        .filter((m): m is number => m !== null && m <= 120000),
    ),
  ).sort((a, b) => a - b);

  const oilSvc = services.find((s) => s.service === "engine_oil_and_filter");
  const plugSvc = services.find((s) => s.service === "spark_plugs");
  const brakeSvc = services.find((s) => s.service === "brake_fluid_flush");

  const faqs: Array<{ q: string; a: string }> = [];
  if (oilSvc?.miles_normal) {
    faqs.push({
      q: `How often should the ${make.name} ${gen.display_name} get an oil change?`,
      a: `The ${make.name} ${gen.display_name} (${yrs}) needs an engine oil + filter change every ${oilSvc.miles_normal.toLocaleString()} miles (${oilSvc.km_normal?.toLocaleString() ?? "—"} km) under normal duty${oilSvc.miles_severe ? `, or every ${oilSvc.miles_severe.toLocaleString()} miles under severe duty` : ""}.`,
    });
  }
  if (plugSvc?.miles_normal) {
    faqs.push({
      q: `When do the spark plugs need replacement on the ${make.name} ${gen.display_name}?`,
      a: `Spark plug replacement is due at ${plugSvc.miles_normal.toLocaleString()} miles (${plugSvc.km_normal?.toLocaleString() ?? "—"} km) on the ${make.name} ${gen.display_name} (${yrs}).${plugSvc.notes ? ` ${plugSvc.notes}` : ""}`,
    });
  }
  if (brakeSvc?.months) {
    faqs.push({
      q: `How often does the ${make.name} ${gen.display_name} brake fluid need flushing?`,
      a: `Brake fluid flush interval is every ${brakeSvc.months} months on the ${make.name} ${gen.display_name} (${yrs}).${brakeSvc.notes ? ` ${brakeSvc.notes}` : ""}`,
    });
  }
  if (services.length > 0) {
    faqs.push({
      q: `What's in the maintenance schedule for the ${make.name} ${gen.display_name}?`,
      a: `The official maintenance schedule for the ${make.name} ${gen.display_name} (${yrs}) covers ${services.length} services across mileage and time intervals, including oil, tire rotation, brake inspection, filter changes, transmission fluid, spark plugs and coolant. Severe-duty intervals are halved.`,
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
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a>
          <span className="sep">/</span>
          <span>Maintenance schedule</span>
        </nav>

        <div className="pagehead">
          <h1>Maintenance schedule</h1>
          <div className="sub">
            <span>{make.name} {gen.display_name} · {yrs}</span>
            <span className="pip"></span>
            <span>{services.length} services · 0 – 150,000 mi</span>
            {base.markets.length > 0 && (
              <>
                <span className="pip"></span>
                <span>{base.markets.map((m) => m.code).join(" · ")}</span>
              </>
            )}
          </div>
          <VerifyBadge
            sourceCount={sources.length}
            reviewDate={rev}
            scope="across"
          />
          <div
            style={{
              marginTop: 16,
              display: "flex",
              gap: 12,
              alignItems: "center",
              flexWrap: "wrap",
            }}
          >
            <span
              style={{
                fontSize: 12,
                fontWeight: 600,
                letterSpacing: "0.06em",
                textTransform: "uppercase",
                color: "var(--ink-soft)",
              }}
            >
              Duty schedule
            </span>
            <div className="duty-toggle" role="group">
              <button aria-pressed="true">Normal duty</button>
              <button>Severe duty</button>
            </div>
          </div>
        </div>
      </div>

      <GenerationTabs
        brand={make.slug}
        generation={gen.slug}
        active="maintenance"
        counts={{ maintenance: services.length }}
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <h2 className="section-h">
            By-mileage table
            <span className="count">
              {services.length} services across {milestones.length} milestones
            </span>
          </h2>
          <table className="maint-table">
            <thead>
              <tr>
                <th>Service</th>
                {milestones.map((m) => (
                  <th key={m} className="miles">
                    {m >= 1000 ? `${m / 1000}k` : m}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {services.map((s) => (
                <tr key={s.id}>
                  <td className="svc">
                    {serviceLabel(s.service)}
                    {s.notes && (
                      <span
                        className="muted"
                        style={{ fontSize: 12, marginLeft: 8 }}
                      >
                        · {s.notes}
                      </span>
                    )}
                  </td>
                  {milestones.map((m) => {
                    const due = !!s.miles_normal && m % s.miles_normal === 0;
                    return (
                      <td key={m} className="dot">
                        {due && <span className="filled" />}
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>

          <div
            style={{
              marginTop: 16,
              padding: "12px 16px",
              background: "var(--bg-alt)",
              border: "1px solid var(--rule)",
              fontSize: 12,
              color: "var(--ink-soft)",
              lineHeight: 1.55,
            }}
          >
            <strong style={{ color: "var(--ink)", fontWeight: 600 }}>
              Severe duty
            </strong>{" "}
            applies when most operation involves stop-and-go traffic, ambient
            temperatures below −10 °C, prolonged idling, dusty environments, or
            repeated short trips under 8 km in cold weather. Toggle the duty
            switch above to see the accelerated schedule.<sup className="cite">[1]</sup>
          </div>
        </section>

        {/* Time-based services (months, no mileage) */}
        {services.some((s) => s.months && !s.miles_normal) && (
          <section>
            <h2 className="section-h">Time-based services</h2>
            <table className="spec-table">
              <tbody>
                {services
                  .filter((s) => s.months && !s.miles_normal)
                  .map((s) => (
                    <tr key={s.id}>
                      <th>{serviceLabel(s.service)}</th>
                      <td>
                        Every {s.months} months
                        {s.notes && (
                          <span className="alt"> · {s.notes}</span>
                        )}
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
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
            }}
          >
            {[
              {
                href: `/${make.slug}/${gen.slug}/oil-capacity`,
                name: "Engine oil capacity & viscosity",
                peek: "Every engine variant · filter PN · drain torque",
              },
              {
                href: `/${make.slug}/${gen.slug}/torque`,
                name: "Torque specifications",
                peek: "Lug nuts · spark plug · drain plug · hub nut",
              },
              {
                href: `/${make.slug}/${gen.slug}`,
                name: "Generation overview",
                peek: "Engine, performance, dimensions, drivetrain",
              },
              {
                href: `/${make.slug}/${gen.slug}/procedures`,
                name: "Service procedures",
                peek: "Oil reset · TPMS · battery · jump-start",
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
