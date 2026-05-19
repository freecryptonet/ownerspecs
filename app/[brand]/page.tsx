import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

type Params = { brand: string };

type Make = {
  id: number;
  slug: string;
  name: string;
  country_of_origin: string | null;
};

type GenerationRow = {
  brand_slug: string;
  generation_slug: string;
  model_name: string;
  model_slug: string;
  display_name: string;
  body_type: string;
  codename: string | null;
  start_year: number;
  end_year: number | null;
  trim_count: number;
  hero_url: string | null;
  hero_attribution: string | null;
  updated: string;
};

async function getBrandData(brand: string) {
  const make = await queryOne<Make>(
    "SELECT id, slug, name, country_of_origin FROM makes WHERE slug = ? LIMIT 1",
    [brand],
  );
  if (!make) return null;

  const generations = await query<GenerationRow>(
    `SELECT mk.slug AS brand_slug, g.slug AS generation_slug,
            m.name AS model_name, m.slug AS model_slug,
            g.display_name, g.body_type, g.codename,
            g.start_year, g.end_year,
            (SELECT COUNT(*) FROM trims WHERE generation_id = g.id) AS trim_count,
            (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url,
            (SELECT attribution FROM images WHERE generation_id = g.id LIMIT 1) AS hero_attribution,
            g.updated_at AS updated
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE mk.id = ? AND g.is_active = 1
     ORDER BY m.name, g.start_year DESC`,
    [make.id],
  );

  // Group by model for the listing
  const byModel = generations.reduce<Record<string, GenerationRow[]>>((acc, g) => {
    (acc[g.model_name] = acc[g.model_name] || []).push(g);
    return acc;
  }, {});

  return { make, generations, byModel };
}

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>("SELECT slug AS brand FROM makes WHERE is_active = 1");
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand } = await params;
  const data = await getBrandData(brand);
  if (!data) return { title: "Not found" };
  const { make } = data;
  return {
    title: `${make.name} — Specifications, fluids, maintenance & owner-manual data`,
    description: `Complete reference for every ${make.name} generation: engine specs, fluid capacities, torque values, maintenance schedules, fuse maps. Cross-verified.`,
    alternates: { canonical: `/${make.slug}` },
  };
}

export default async function BrandPage({
  params,
}: {
  params: Promise<Params>;
}) {
  const { brand } = await params;
  const data = await getBrandData(brand);
  if (!data) notFound();
  const { make, generations, byModel } = data;

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <span>{make.name}</span>
        </nav>

        <div className="pagehead">
          <h1>{make.name}</h1>
          <div className="sub">
            {make.country_of_origin && (
              <>
                <span>Origin {make.country_of_origin}</span>
                <span className="pip"></span>
              </>
            )}
            <span>
              {generations.length} generation{generations.length === 1 ? "" : "s"}
            </span>
            <span className="pip"></span>
            <span>{Object.keys(byModel).length} models</span>
            <span className="pip"></span>
            <span>{generations.reduce((sum, g) => sum + g.trim_count, 0)} trims indexed</span>
          </div>
        </div>
      </div>

      <main className="shell">
        {Object.entries(byModel).map(([modelName, gens]) => (
          <section key={modelName} style={{ paddingTop: "var(--s-5)" }}>
            <h2 className="section-h">
              {make.name} {modelName}
              <span className="count">
                {gens.length} generation{gens.length === 1 ? "" : "s"}
              </span>
            </h2>
            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
                gap: 16,
              }}
            >
              {gens.map((g) => (
                <a
                  key={g.generation_slug}
                  href={`/${g.brand_slug}/${g.generation_slug}`}
                  style={{
                    border: "1px solid var(--rule)",
                    background: "var(--bg)",
                    color: "var(--ink)",
                    textDecoration: "none",
                    display: "block",
                  }}
                >
                  <div
                    style={{
                      aspectRatio: "4/3",
                      background:
                        "linear-gradient(135deg, #20263A, #2D3550)",
                      position: "relative",
                      overflow: "hidden",
                    }}
                  >
                    {g.hero_url ? (
                      <img
                        src={g.hero_url}
                        alt={g.display_name}
                        style={{
                          width: "100%",
                          height: "100%",
                          objectFit: "cover",
                          display: "block",
                        }}
                      />
                    ) : (
                      <svg
                        viewBox="0 0 800 600"
                        stroke="rgba(255,255,255,0.65)"
                        fill="none"
                        strokeWidth="1.5"
                        style={{
                          position: "absolute",
                          inset: 0,
                          width: "100%",
                          height: "100%",
                        }}
                      >
                        <path d="M90 410c0-32 22-52 58-52h92l72-104c12-19 30-29 56-29h190c26 0 44 10 56 29l72 104h92c36 0 58 20 58 52v52H90z" />
                        <circle cx="245" cy="462" r="48" />
                        <circle cx="775" cy="462" r="48" />
                      </svg>
                    )}
                  </div>
                  <div style={{ padding: "12px 16px" }}>
                    <div
                      style={{
                        fontSize: 14,
                        fontWeight: 600,
                        color: "var(--ink)",
                        lineHeight: 1.3,
                      }}
                    >
                      {g.display_name}
                    </div>
                    <div
                      style={{
                        fontFamily: "var(--font-mono)",
                        fontSize: 11,
                        color: "var(--ink-mute)",
                        marginTop: 4,
                      }}
                    >
                      {g.start_year} – {g.end_year ?? "present"}
                      {g.codename && ` · ${g.codename}`}
                      {" · "}
                      {g.trim_count} trim{g.trim_count === 1 ? "" : "s"}
                    </div>
                  </div>
                </a>
              ))}
            </div>
          </section>
        ))}

        {generations.length === 0 && (
          <section style={{ paddingTop: "var(--s-6)" }}>
            <p style={{ color: "var(--ink-mute)", fontSize: 14 }}>
              No {make.name} generations indexed yet. Catalogue is expanding daily.
            </p>
          </section>
        )}
      </main>

      <SiteFooter />
    </>
  );
}
