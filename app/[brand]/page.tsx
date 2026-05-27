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

type ModelRow = {
  model_slug: string;
  model_name: string;
  gen_count: number;
  first_year: number;
  last_end: number;
  has_current: number;
  trim_count: number;
  bodies: string | null;
};

async function getBrandData(brand: string) {
  const make = await queryOne<Make>(
    "SELECT id, slug, name, country_of_origin FROM makes WHERE slug = ? LIMIT 1",
    [brand],
  );
  if (!make) return null;

  const models = await query<ModelRow>(
    `SELECT m.slug AS model_slug, m.name AS model_name,
            COUNT(g.id) AS gen_count,
            MIN(g.start_year) AS first_year,
            MAX(COALESCE(g.end_year, 0)) AS last_end,
            MAX(CASE WHEN g.end_year IS NULL THEN 1 ELSE 0 END) AS has_current,
            (SELECT COUNT(*) FROM trims t JOIN generations g2 ON t.generation_id = g2.id
              WHERE g2.model_id = m.id AND g2.is_active = 1) AS trim_count,
            (SELECT GROUP_CONCAT(DISTINCT body_type ORDER BY body_type SEPARATOR ', ')
              FROM generations WHERE model_id = m.id AND is_active = 1) AS bodies
     FROM models m
     JOIN generations g ON g.model_id = m.id AND g.is_active = 1
     WHERE m.make_id = ?
     GROUP BY m.id, m.slug, m.name
     ORDER BY m.name`,
    [make.id],
  );

  const totalGens = models.reduce((s, m) => s + m.gen_count, 0);
  const totalTrims = models.reduce((s, m) => s + m.trim_count, 0);
  return { make, models, totalGens, totalTrims };
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
    description: `Complete reference for every ${make.name} model and generation: engine specs, fluid capacities, torque values, maintenance schedules, fuse maps. Cross-verified.`,
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
  const { make, models, totalGens, totalTrims } = data;

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
            <span>{models.length} model{models.length === 1 ? "" : "s"}</span>
            <span className="pip"></span>
            <span>{totalGens} generation{totalGens === 1 ? "" : "s"}</span>
            <span className="pip"></span>
            <span>{totalTrims} trims indexed</span>
          </div>
        </div>
      </div>

      <main className="shell">
        {models.length > 0 ? (
          <section style={{ paddingTop: "var(--s-5)" }}>
            <div className="table-scroll">
              <table className="spec-table" style={{ width: "100%" }}>
                <thead style={{ background: "var(--bg-alt)" }}>
                  <tr>
                    <th>Model</th>
                    <th>Generations</th>
                    <th>Years</th>
                    <th>Body</th>
                    <th style={{ textAlign: "right" }}>Trims</th>
                  </tr>
                </thead>
                <tbody>
                  {models.map((m) => (
                    <tr key={m.model_slug}>
                      <td>
                        <a
                          href={`/${make.slug}/${m.model_slug}`}
                          style={{ color: "var(--ink)", fontWeight: 600 }}
                        >
                          {make.name} {m.model_name}
                        </a>
                      </td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 12 }}>
                        {m.gen_count}
                      </td>
                      <td style={{ fontFamily: "var(--font-mono)", fontSize: 12, whiteSpace: "nowrap" }}>
                        {m.first_year}–{m.has_current ? "present" : m.last_end}
                      </td>
                      <td style={{ textTransform: "capitalize" }}>{m.bodies ?? "—"}</td>
                      <td style={{ textAlign: "right", fontFamily: "var(--font-mono)", fontSize: 12, whiteSpace: "nowrap" }}>
                        {m.trim_count}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        ) : (
          <section style={{ paddingTop: "var(--s-6)" }}>
            <p style={{ color: "var(--ink-mute)", fontSize: 14 }}>
              No {make.name} models indexed yet. Catalogue is expanding daily.
            </p>
          </section>
        )}
      </main>

      <SiteFooter />
    </>
  );
}
