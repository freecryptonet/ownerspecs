import { query } from "@/lib/db";
import type { SourceRow } from "@/lib/generation";

/**
 * For a single generation, build a citation index used to render per-row
 * [1][2] footnotes that point into the page's Sources block.
 *
 * Page-aware. Callers pass `renderedRows` — an array of (table, id) tuples
 * the page actually renders citations for. The citation index restricts
 * byRow / sources block to those rows, so the Sources block stays in lockstep
 * with the [N] footnotes the page emits. Rows suppressed by the page (e.g.
 * legacy NULL engine_id fluids on a multi-engine gen) are correctly excluded.
 *
 * If `renderedRows` is undefined, the index falls back to every gen-scope
 * spec row (correct for the gen overview, which renders nearly everything).
 *
 * E-E-A-T differentiator: no competitor in our 2026-05-21 audit publishes
 * per-row source attribution. We do.
 */
export type CitationIndex = {
  sources: SourceRow[];
  citationsFor: (table: string, id: number) => number[];
};

export type RenderedRow = { table: string; id: number };

export async function buildCitationIndex(
  generationId: number,
  renderedRows?: RenderedRow[],
): Promise<CitationIndex> {
  // Step 1 — all public sources linked to any spec row in this gen.
  const sources = await query<SourceRow>(
    `SELECT DISTINCT s.id, s.type, s.citation, s.url, s.retrieved_at, s.notes
     FROM sources s
     JOIN spec_sources ss ON ss.source_id = s.id
     WHERE s.is_public = 1 AND (
        (ss.spec_table = 'trims'             AND ss.spec_id IN (SELECT id FROM trims              WHERE generation_id = ?)) OR
        (ss.spec_table = 'fluid_specs'       AND ss.spec_id IN (SELECT id FROM fluid_specs        WHERE generation_id = ?)) OR
        (ss.spec_table = 'torque_specs'      AND ss.spec_id IN (SELECT id FROM torque_specs       WHERE generation_id = ?)) OR
        (ss.spec_table = 'electrical_specs'  AND ss.spec_id IN (SELECT id FROM electrical_specs   WHERE generation_id = ?)) OR
        (ss.spec_table = 'bulbs'             AND ss.spec_id IN (SELECT id FROM bulbs              WHERE generation_id = ?)) OR
        (ss.spec_table = 'fuses'             AND ss.spec_id IN (SELECT id FROM fuses              WHERE generation_id = ?)) OR
        (ss.spec_table = 'parts'             AND ss.spec_id IN (SELECT id FROM parts              WHERE generation_id = ?)) OR
        (ss.spec_table = 'service_intervals' AND ss.spec_id IN (SELECT id FROM service_intervals  WHERE generation_id = ?)) OR
        (ss.spec_table = 'tire_pressures'    AND ss.spec_id IN (SELECT id FROM tire_pressures     WHERE generation_id = ?)) OR
        (ss.spec_table = 'procedures'        AND ss.spec_id IN (SELECT id FROM procedures         WHERE generation_id = ?)) OR
        (ss.spec_table = 'generations'       AND ss.spec_id = ?)
     )
     ORDER BY s.id`,
    Array(11).fill(generationId),
  );

  const positionById = new Map<number, number>();
  sources.forEach((s, i) => positionById.set(s.id, i + 1));

  // Step 2 — gen-scope public spec_sources links.
  const links = await query<{ spec_table: string; spec_id: number; source_id: number }>(
    `SELECT ss.spec_table, ss.spec_id, ss.source_id
     FROM spec_sources ss
     JOIN sources s ON s.id = ss.source_id AND s.is_public = 1
     WHERE
        (ss.spec_table = 'trims'             AND ss.spec_id IN (SELECT id FROM trims              WHERE generation_id = ?)) OR
        (ss.spec_table = 'fluid_specs'       AND ss.spec_id IN (SELECT id FROM fluid_specs        WHERE generation_id = ?)) OR
        (ss.spec_table = 'torque_specs'      AND ss.spec_id IN (SELECT id FROM torque_specs       WHERE generation_id = ?)) OR
        (ss.spec_table = 'electrical_specs'  AND ss.spec_id IN (SELECT id FROM electrical_specs   WHERE generation_id = ?)) OR
        (ss.spec_table = 'bulbs'             AND ss.spec_id IN (SELECT id FROM bulbs              WHERE generation_id = ?)) OR
        (ss.spec_table = 'fuses'             AND ss.spec_id IN (SELECT id FROM fuses              WHERE generation_id = ?)) OR
        (ss.spec_table = 'parts'             AND ss.spec_id IN (SELECT id FROM parts              WHERE generation_id = ?)) OR
        (ss.spec_table = 'service_intervals' AND ss.spec_id IN (SELECT id FROM service_intervals  WHERE generation_id = ?)) OR
        (ss.spec_table = 'tire_pressures'    AND ss.spec_id IN (SELECT id FROM tire_pressures     WHERE generation_id = ?)) OR
        (ss.spec_table = 'procedures'        AND ss.spec_id IN (SELECT id FROM procedures         WHERE generation_id = ?)) OR
        (ss.spec_table = 'generations'       AND ss.spec_id = ?)`,
    Array(11).fill(generationId),
  );

  // Restrict to (table, id) tuples the page renders citations for.
  // Without this filter a source linked to a suppressed row would leak
  // into the sources block, leaving an entry no [N] footnote references.
  let isRendered: (table: string, id: number) => boolean;
  if (renderedRows) {
    const renderedKeys = new Set(renderedRows.map((r) => `${r.table}:${r.id}`));
    isRendered = (table, id) => renderedKeys.has(`${table}:${id}`);
  } else {
    isRendered = () => true;
  }

  const byRow = new Map<string, number[]>();
  for (const l of links) {
    if (!isRendered(l.spec_table, l.spec_id)) continue;
    const pos = positionById.get(l.source_id);
    if (pos == null) continue;
    const key = `${l.spec_table}:${l.spec_id}`;
    const arr = byRow.get(key) ?? [];
    if (!arr.includes(pos)) arr.push(pos);
    byRow.set(key, arr);
  }
  for (const arr of byRow.values()) arr.sort((a, b) => a - b);

  // Only include sources with at least one citation in the rendered set.
  const citedPositions = new Set<number>();
  for (const arr of byRow.values()) for (const n of arr) citedPositions.add(n);
  const visibleSources = sources.filter((_, i) => citedPositions.has(i + 1));

  // Renumber so the visible list is 1..N contiguous.
  const oldToNew = new Map<number, number>();
  visibleSources.forEach((s, i) => {
    const oldPos = positionById.get(s.id)!;
    oldToNew.set(oldPos, i + 1);
  });
  const renumberedByRow = new Map<string, number[]>();
  for (const [k, arr] of byRow) {
    const remapped = arr.map((n) => oldToNew.get(n)).filter((n): n is number => n != null);
    if (remapped.length) renumberedByRow.set(k, remapped.sort((a, b) => a - b));
  }

  return {
    sources: visibleSources,
    citationsFor: (table, id) => renumberedByRow.get(`${table}:${id}`) ?? [],
  };
}
