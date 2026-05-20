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

    // Conditional sub-topic pages — only emit if data exists for the gen
    const conditionalTopics: Array<{ slug: string; existsSql: string; params: string[] }> = [
      { slug: "parts", existsSql: "EXISTS (SELECT 1 FROM parts WHERE generation_id = g.id)", params: [] },
      { slug: "bulbs", existsSql: "EXISTS (SELECT 1 FROM bulbs WHERE generation_id = g.id)", params: [] },
      { slug: "fuses", existsSql: "EXISTS (SELECT 1 FROM fuses WHERE generation_id = g.id)", params: [] },
    ];
    for (const ct of conditionalTopics) {
      const eligible = await query<{ brand: string; generation: string; updated: string }>(
        `SELECT mk.slug AS brand, g.slug AS generation, g.updated_at AS updated
         FROM generations g
         JOIN models m ON m.id = g.model_id
         JOIN makes mk ON mk.id = m.make_id
         WHERE g.is_active = 1 AND ${ct.existsSql}`,
        ct.params,
      );
      for (const e of eligible) {
        pages.push({
          url: `${BASE}/${e.brand}/${e.generation}/${ct.slug}`,
          lastModified: new Date(e.updated),
          changeFrequency: "monthly",
          priority: 0.7,
        });
      }
    }

    // Per-fluid-type topic pages (only where data exists for that gen)
    const fluidTopics: Array<{ slug: string; fluidTypes: string[] }> = [
      { slug: "transmission-fluid", fluidTypes: ["transmission_at","transmission_cvt","transmission_ecvt","transmission_dct","transmission_mt"] },
      { slug: "coolant", fluidTypes: ["coolant"] },
      { slug: "brake-fluid", fluidTypes: ["brake"] },
      { slug: "ac-refrigerant", fluidTypes: ["ac_refrigerant"] },
      { slug: "differential-fluid", fluidTypes: ["front_differential","rear_differential","transfer_case","haldex_oil","gear_reducer_front","gear_reducer_rear"] },
    ];
    for (const ft of fluidTopics) {
      const placeholders = ft.fluidTypes.map(() => "?").join(",");
      const eligible = await query<{ brand: string; generation: string; updated: string }>(
        `SELECT mk.slug AS brand, g.slug AS generation, g.updated_at AS updated
         FROM generations g
         JOIN models m ON m.id = g.model_id
         JOIN makes mk ON mk.id = m.make_id
         WHERE g.is_active = 1
           AND EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = g.id AND fluid_type IN (${placeholders}))`,
        ft.fluidTypes,
      );
      for (const e of eligible) {
        pages.push({
          url: `${BASE}/${e.brand}/${e.generation}/${ft.slug}`,
          lastModified: new Date(e.updated),
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

    // Comparison pages (curated head-to-head)
    pages.push({
      url: `${BASE}/compare`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    });
    const PAIRS: Array<[string, string]> = [
      ["civic-sedan-x-2016-2021", "corolla-e170-sedan-2012-2018"],
      ["civic-fe-sedan-2022-2025", "corolla-sedan-e210-2019-2022"],
      ["civic-fe-sedan-2022-2025", "3-bm-sedan-2013-2018"],
      ["civic-fe-sedan-2022-2025", "elantra-cn7-sedan-2021-present"],
      ["camry-xv70-2018-2024", "accord-cv-sedan-2023-present"],
      ["camry-xv70-2018-2024", "altima-l34-sedan-2018-2022"],
      ["accord-cv-sedan-2023-present", "altima-l34-sedan-2018-2022"],
      ["rav4-xa50-suv-2019-2021", "cr-v-rw-suv-2017-2022"],
      ["rav4-xa50-suv-2019-2021", "tucson-nx4-suv-2021-2024"],
      ["rav4-xa50-suv-2019-2021", "cx-5-kf-suv-2017-2024"],
      ["rav4-xa50-suv-2019-2021", "tiguan-ad1-suv-2017-2024"],
      ["tucson-nx4-suv-2021-2024", "sportage-nq5-suv-2021-2025"],
      ["cr-v-rw-suv-2017-2022", "tucson-nx4-suv-2021-2024"],
      ["cr-v-rs-suv-2023-present", "rav4-xa50-suv-2019-2021"],
      ["highlander-xu70-suv-2020-2025", "pilot-yf-suv-2023-present"],
      ["highlander-xu70-suv-2020-2025", "telluride-on-suv-2020-2025"],
      ["pilot-yf-suv-2023-present", "telluride-on-suv-2020-2025"],
      ["pilot-yf-suv-2023-present", "atlas-ca-suv-2018-2023"],
      ["explorer-u625-suv-2020-2024", "highlander-xu70-suv-2020-2025"],
      ["f-150-p702-pickup-2021-2025", "silverado-t1-pickup-2019-2024"],
      ["f-150-p702-pickup-2021-2025", "1500-dt-pickup-2019-2024"],
      ["silverado-t1-pickup-2019-2024", "1500-dt-pickup-2019-2024"],
      ["silverado-t1-pickup-2019-2024", "sierra-1500-t1xx-pickup-2019-2024"],
      ["tundra-xk70-pickup-2022-present", "f-150-p702-pickup-2021-2025"],
      ["tacoma-n300-pickup-2023-present", "f-150-p702-pickup-2021-2025"],
      ["3-series-sedan-g20-2019-2022", "c-class-sedan-w206-2022-present"],
      ["3-series-sedan-g20-2019-2022", "a4-sedan-b9-2015-2018"],
      ["c-class-sedan-w206-2022-present", "a4-sedan-b9-2015-2018"],
      ["3-series-f30-sedan-2012-2018", "3-series-sedan-g20-2019-2022"],
      ["e-class-w213-sedan-2017-2020", "3-series-sedan-g20-2019-2022"],
      ["x5-g05-suv-2019-2023", "glc-x253-suv-2016-2022"],
      ["x3-g01-suv-2018-2024", "glc-x253-suv-2016-2022"],
      ["x3-g01-suv-2018-2024", "xc60-suv-2017-2024"],
      ["nx-az20-suv-2022-present", "rx-al20-suv-2015-2022"],
      ["mdx-yd4-suv-2022-2025", "pilot-yf-suv-2023-present"],
      ["outback-bt-wagon-2019-2024", "forester-sk-suv-2018-2021"],
      ["outback-bt-wagon-2019-2024", "crosstrek-gt-suv-2018-2023"],
      ["forester-sk-suv-2018-2021", "rav4-xa50-suv-2019-2021"],
      ["model-3-sedan-2017-2023", "model-y-suv-2020-2024"],
      ["model-y-suv-2020-2024", "ioniq-5-ne1-suv-2021-2024"],
      ["wrangler-jl-suv-2018-2023", "bronco-u725-suv-2021-present"],
      ["wrangler-jl-suv-2018-2023", "grand-cherokee-wl-suv-2022-present"],
      ["tahoe-t1xx-suv-2021-2024", "x5-g05-suv-2019-2023"],
      ["civic-fe-sedan-2022-2025", "accord-cv-sedan-2023-present"],
      ["camry-xv70-2018-2024", "corolla-sedan-e210-2019-2022"],
      ["highlander-xu70-suv-2020-2025", "rav4-xa50-suv-2019-2021"],
      ["3-series-sedan-g20-2019-2022", "5-series-g30-sedan-2017-2020"],
      ["x3-g01-suv-2018-2024", "x5-g05-suv-2019-2023"],
      ["tucson-nx4-suv-2021-2024", "palisade-lx2-suv-2020-2022"],
      ["sportage-nq5-suv-2021-2025", "sorento-mq4-suv-2021-present"],
      ["pilot-yf-suv-2023-present", "cr-v-rs-suv-2023-present"],
      ["mdx-yd4-suv-2022-2025", "tlx-ii-sedan-2021-2024"],
      ["silverado-t1-pickup-2019-2024", "tahoe-t1xx-suv-2021-2024"],
      ["3-sedan-bp-2020-present", "cx-5-kf-suv-2017-2024"],
      ["model-y-suv-2020-2024", "model-3-sedan-2017-2023"],
      ["odyssey-rl6-minivan-2018-2023", "sienna-xl40-minivan-2021-present"],
      ["odyssey-rl6-minivan-2018-2023", "pacifica-ru-minivan-2017-2023"],
      ["sienna-xl40-minivan-2021-present", "pacifica-ru-minivan-2017-2023"],
      ["q7-4m-suv-2015-2019", "x5-g05-suv-2019-2023"],
      ["q7-4m-suv-2015-2019", "gle-v167-suv-2019-2023"],
      ["gle-v167-suv-2019-2023", "x5-g05-suv-2019-2023"],
      ["xc90-ii-suv-2015-present", "x5-g05-suv-2019-2023"],
      ["xc90-ii-suv-2015-present", "gle-v167-suv-2019-2023"],
      ["macan-95b-suv-2014-2018", "x3-g01-suv-2018-2024"],
      ["macan-95b-suv-2014-2018", "gv70-jk1-suv-2021-present"],
      ["gv70-jk1-suv-2021-present", "x3-g01-suv-2018-2024"],
      ["ascent-wm-suv-2019-2023", "highlander-xu70-suv-2020-2025"],
      ["ascent-wm-suv-2019-2023", "pilot-yf-suv-2023-present"],
      ["cx-90-kk-suv-2024-present", "telluride-on-suv-2020-2025"],
      ["cx-90-kk-suv-2024-present", "grand-cherokee-wl-suv-2022-present"],
      ["brz-zd8-coupe-2022-present", "mx-5-nd-roadster-2015-present"],
      ["hr-v-rv3-suv-2023-present", "cr-v-rs-suv-2023-present"],
    ];
    for (const [a, b] of PAIRS) {
      pages.push({
        url: `${BASE}/compare/${a}-vs-${b}`,
        lastModified: new Date(),
        changeFrequency: "monthly",
        priority: 0.6,
      });
    }

    // Engine catalogue pages
    pages.push({
      url: `${BASE}/engines`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    });
    const engines = await query<{ code: string }>(
      `SELECT DISTINCT e.code
       FROM engines e
       JOIN trims t ON t.engine_id = e.id
       JOIN generations g ON g.id = t.generation_id
       WHERE g.is_active = 1 AND e.code IS NOT NULL AND e.code != ''`,
    );
    const slugFromCode = (code: string) =>
      code.replace(/[\s/]/g, "-").replace(/[^a-zA-Z0-9-]/g, "").replace(/-+/g, "-").toLowerCase();
    for (const e of engines) {
      pages.push({
        url: `${BASE}/engines/${slugFromCode(e.code)}`,
        lastModified: new Date(),
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
