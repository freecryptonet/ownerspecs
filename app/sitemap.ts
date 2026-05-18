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

    const topics = ["oil-capacity", "maintenance-schedule", "torque"];

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
  } catch (e) {
    // DB unavailable during build → fall back to homepage-only sitemap
    console.error("sitemap DB query failed:", e);
  }

  return pages;
}
