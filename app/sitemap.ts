import type { MetadataRoute } from "next";
import { query } from "@/lib/db";

const BASE = "https://ownerspecs.com";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const pages: MetadataRoute.Sitemap = [
    {
      url: BASE,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 1.0,
    },
  ];

  try {
    const generations = await query<{ brand: string; generation: string; updated: string }>(
      `SELECT mk.slug AS brand, g.slug AS generation,
              GREATEST(g.updated_at, mk.updated_at, m.updated_at) AS updated
       FROM generations g
       JOIN models m ON m.id = g.model_id
       JOIN makes mk ON mk.id = m.make_id
       WHERE g.is_active = 1`,
    );

    const topics = [
      "oil-capacity",
      "maintenance-schedule",
      "torque",
      "electrical",
      "tires",
      "procedures",
    ];

    for (const g of generations) {
      pages.push({
        url: `${BASE}/${g.brand}/${g.generation}`,
        lastModified: new Date(g.updated),
        changeFrequency: "monthly",
        priority: 0.8,
      });
      for (const topic of topics) {
        pages.push({
          url: `${BASE}/${g.brand}/${g.generation}/${topic}`,
          lastModified: new Date(g.updated),
          changeFrequency: "monthly",
          priority: 0.7,
        });
      }
    }

    const trims = await query<{ brand: string; generation: string; trimSlug: string; updated: string }>(
      "SELECT mk.slug AS brand, g.slug AS generation, t.slug AS trimSlug, g.updated_at AS updated " +
      "FROM trims t " +
      "JOIN generations g ON g.id = t.generation_id " +
      "JOIN models m ON m.id = g.model_id " +
      "JOIN makes mk ON mk.id = m.make_id " +
      "WHERE g.is_active = 1",
    );
    for (const t of trims) {
      pages.push({
        url: `${BASE}/${t.brand}/${t.generation}/${t.trimSlug}`,
        lastModified: new Date(t.updated),
        changeFrequency: "monthly",
        priority: 0.6,
      });
    }

    const procs = await query<{ brand: string; generation: string; procSlug: string; updated: string }>(
      "SELECT mk.slug AS brand, g.slug AS generation, p.slug AS procSlug, g.updated_at AS updated " +
      "FROM procedures p " +
      "JOIN generations g ON g.id = p.generation_id " +
      "JOIN models m ON m.id = g.model_id " +
      "JOIN makes mk ON mk.id = m.make_id " +
      "WHERE g.is_active = 1",
    );
    for (const p of procs) {
      pages.push({
        url: `${BASE}/${p.brand}/${p.generation}/procedures/${p.procSlug}`,
        lastModified: new Date(p.updated),
        changeFrequency: "monthly",
        priority: 0.5,
      });
    }
  } catch (e) {
    // DB unavailable during build → fall back to homepage-only sitemap
    console.error("sitemap DB query failed:", e);
  }

  return pages;
}
