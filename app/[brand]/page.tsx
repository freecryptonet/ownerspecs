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
            <div className="table-scroll">
              <table className="spec-table" style={{ width: "100%" }}>
                <tbody>
                  {gens.map((g) => (
                    <tr key={g.generation_slug}>
                      <td>
                        <a
                          href={`/${g.brand_slug}/${g.generation_slug}`}
                          style={{ color: "var(--ink)", fontWeight: 600 }}
                        >
                          {g.display_name}
                        </a>
                      </td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 12, whiteSpace: "nowrap" }}>
                        {g.start_year}–{g.end_year ?? "present"}
                      </td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 12, color: "var(--ink-mute)" }}>
                        {g.codename ?? "—"}
                      </td>
                      <td style={{ textTransform: "capitalize" }}>{g.body_type}</td>
                      <td style={{ textAlign: "right", whiteSpace: "nowrap", fontFamily: "var(--font-mono)", fontSize: 12 }}>
                        {g.trim_count} trim{g.trim_count === 1 ? "" : "s"}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
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
