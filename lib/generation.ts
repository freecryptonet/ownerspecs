import { query, queryOne } from "@/lib/db";

export type Make = {
  id: number;
  slug: string;
  name: string;
  country_of_origin: string | null;
};

export type Model = {
  id: number;
  make_id: number;
  slug: string;
  name: string;
};

export type Generation = {
  id: number;
  model_id: number;
  slug: string;
  ordinal: number | null;
  codename: string | null;
  display_name: string;
  body_type: string;
  start_year: number;
  end_year: number | null;
  layout: string | null;
  platform: string | null;
};

export type Market = { id: number; code: string; name: string };

export type SourceRow = {
  id: number;
  type: string;
  citation: string;
  url: string | null;
  retrieved_at: string;
  notes: string | null;
};

export type GenerationBase = {
  make: Make;
  model: Model;
  gen: Generation;
  markets: Market[];
};

/** Resolve (brand-slug, generation-slug) → make + model + generation + markets. Null if not found. */
export async function getGenerationBase(
  brand: string,
  generation: string,
): Promise<GenerationBase | null> {
  const make = await queryOne<Make>(
    "SELECT id, slug, name, country_of_origin FROM makes WHERE slug = ? LIMIT 1",
    [brand],
  );
  if (!make) return null;

  const gen = await queryOne<Generation>(
    `SELECT g.id, g.model_id, g.slug, g.ordinal, g.codename, g.display_name,
            g.body_type, g.start_year, g.end_year, g.layout, g.platform
     FROM generations g
     JOIN models m ON m.id = g.model_id
     WHERE g.slug = ? AND m.make_id = ?
     LIMIT 1`,
    [generation, make.id],
  );
  if (!gen) return null;

  const model = await queryOne<Model>(
    "SELECT id, make_id, slug, name FROM models WHERE id = ? LIMIT 1",
    [gen.model_id],
  );
  if (!model) return null;

  const markets = await query<Market>(
    `SELECT mk.id, mk.code, mk.name
     FROM markets mk
     JOIN generation_markets gm ON gm.market_id = mk.id
     WHERE gm.generation_id = ?
     ORDER BY FIELD(mk.code, 'US','CA','EU','UK','JDM','AU','RoW')`,
    [gen.id],
  );

  return { make, model, gen, markets };
}

/** Sources that back any spec belonging to this generation, across all spec tables. */
export async function getGenerationSources(
  generationId: number,
): Promise<SourceRow[]> {
  return query<SourceRow>(
    `SELECT DISTINCT s.id, s.type, s.citation, s.url, s.retrieved_at, s.notes
     FROM sources s
     JOIN spec_sources ss ON ss.source_id = s.id
     WHERE ss.spec_table IN ('fluid_specs','torque_specs','electrical_specs','bulbs',
                              'fuses','parts','service_intervals','tire_pressures')
       AND ss.spec_id IN (
         SELECT id FROM fluid_specs       WHERE generation_id = ?
         UNION ALL SELECT id FROM torque_specs     WHERE generation_id = ?
         UNION ALL SELECT id FROM electrical_specs WHERE generation_id = ?
         UNION ALL SELECT id FROM bulbs            WHERE generation_id = ?
         UNION ALL SELECT id FROM fuses            WHERE generation_id = ?
         UNION ALL SELECT id FROM parts            WHERE generation_id = ?
         UNION ALL SELECT id FROM service_intervals WHERE generation_id = ?
         UNION ALL SELECT id FROM tire_pressures   WHERE generation_id = ?
       )
     ORDER BY s.id`,
    [
      generationId,
      generationId,
      generationId,
      generationId,
      generationId,
      generationId,
      generationId,
      generationId,
    ],
  );
}

/** Sources that back rows in a single spec table for this generation. */
export async function getSourcesFor(
  generationId: number,
  specTable: string,
): Promise<SourceRow[]> {
  return query<SourceRow>(
    `SELECT DISTINCT s.id, s.type, s.citation, s.url, s.retrieved_at, s.notes
     FROM sources s
     JOIN spec_sources ss ON ss.source_id = s.id
     WHERE ss.spec_table = ?
       AND ss.spec_id IN (SELECT id FROM ${specTable} WHERE generation_id = ?)
     ORDER BY s.id`,
    [specTable, generationId],
  );
}

/** All (brand-slug, generation-slug) pairs in the DB — for generateStaticParams. */
export async function getAllGenerationParams(): Promise<
  Array<{ brand: string; generation: string }>
> {
  return query<{ brand: string; generation: string }>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1`,
  );
}

export function yearRange(start: number, end: number | null): string {
  return end ? `${start} – ${end}` : `${start} – present`;
}

export function reviewDate(sources: SourceRow[]): string {
  const max = sources
    .map((s) => s.retrieved_at)
    .sort()
    .reverse()[0];
  return max ? new Date(max).toISOString().slice(0, 10) : "";
}
