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

/** A fetched source row tagged with which ID space it came from — `sources.id`
 *  and `documents.id` are independent auto-increment spaces that WILL collide
 *  (both start at 1) if merged by raw id. Every consumer of this module must
 *  tag rows before merging. */
export type RawSource = SourceRow & { sourceSpace: "legacy" | "document" };
export type RawLink = { table: string; id: number; sourceSpace: "legacy" | "document"; sourceId: number };

/**
 * Pure: given already-fetched sources + links (+ optional page-rendered-row
 * filter), produce the final numbered CitationIndex. Extracted from the
 * original buildCitationIndex inline logic (2026-05) so it is unit-tested;
 * behavior for legacy-only inputs is unchanged (see citations.test.ts
 * regression-baseline cases).
 */
export function mergeAndNumberSources(
  rawSources: RawSource[],
  rawLinks: RawLink[],
  renderedRows?: RenderedRow[],
): CitationIndex {
  const key = (s: { sourceSpace: "legacy" | "document"; id: number }) => `${s.sourceSpace}:${s.id}`;

  const positionByKey = new Map<string, number>();
  rawSources.forEach((s, i) => positionByKey.set(key(s), i + 1));

  let isRendered: (table: string, id: number) => boolean;
  if (renderedRows) {
    const renderedKeys = new Set(renderedRows.map((r) => `${r.table}:${r.id}`));
    isRendered = (table, id) => renderedKeys.has(`${table}:${id}`);
  } else {
    isRendered = () => true;
  }

  const byRow = new Map<string, number[]>();
  for (const l of rawLinks) {
    if (!isRendered(l.table, l.id)) continue;
    const pos = positionByKey.get(`${l.sourceSpace}:${l.sourceId}`);
    if (pos == null) continue;
    const rowKey = `${l.table}:${l.id}`;
    const arr = byRow.get(rowKey) ?? [];
    if (!arr.includes(pos)) arr.push(pos);
    byRow.set(rowKey, arr);
  }
  for (const arr of byRow.values()) arr.sort((a, b) => a - b);

  const citedPositions = new Set<number>();
  for (const arr of byRow.values()) for (const n of arr) citedPositions.add(n);
  const visibleSources = rawSources.filter((_, i) => citedPositions.has(i + 1));

  const oldToNew = new Map<number, number>();
  visibleSources.forEach((s, i) => {
    const oldPos = positionByKey.get(key(s))!;
    oldToNew.set(oldPos, i + 1);
  });
  const renumberedByRow = new Map<string, number[]>();
  for (const [k, arr] of byRow) {
    const remapped = arr.map((n) => oldToNew.get(n)).filter((n): n is number => n != null);
    if (remapped.length) renumberedByRow.set(k, remapped.sort((a, b) => a - b));
  }

  return {
    sources: visibleSources.map(({ sourceSpace, ...s }) => s),
    citationsFor: (table, id) => renumberedByRow.get(`${table}:${id}`) ?? [],
  };
}

// ── DB-facing shell ──

const LEGACY_TABLES = [
  "trims", "fluid_specs", "torque_specs", "electrical_specs", "bulbs", "fuses",
  "parts", "service_intervals", "tire_pressures", "procedures", "brake_specs",
  "alignment_specs",
] as const;

/** Document-first tables (mig 579) that cite `documents.id` directly via
 *  `source_document_id` — no `spec_sources` join table involved for this
 *  lane. Only `qa_state = 'approved'` rows are ever fetched. */
const DOCUMENT_TABLES = ["mass_homologations", "spec_facts", "tyre_homologations"] as const;

export async function buildCitationIndex(
  generationId: number,
  renderedRows?: RenderedRow[],
): Promise<CitationIndex> {
  const legacySources = await query<SourceRow>(
    `SELECT DISTINCT s.id, s.type, s.citation, s.url, s.public_link, s.retrieved_at, s.notes
     FROM sources s
     JOIN spec_sources ss ON ss.source_id = s.id
     WHERE s.is_public = 1 AND (
        ${LEGACY_TABLES.map((t) => `(ss.spec_table = '${t}' AND ss.spec_id IN (SELECT id FROM ${t} WHERE generation_id = ?))`).join(" OR ")}
        OR (ss.spec_table = 'generations' AND ss.spec_id = ?)
     )
     ORDER BY s.id`,
    Array(LEGACY_TABLES.length + 1).fill(generationId),
  );

  const legacyLinks = await query<{ spec_table: string; spec_id: number; source_id: number }>(
    `SELECT ss.spec_table, ss.spec_id, ss.source_id
     FROM spec_sources ss
     JOIN sources s ON s.id = ss.source_id AND s.is_public = 1
     WHERE
        ${LEGACY_TABLES.map((t) => `(ss.spec_table = '${t}' AND ss.spec_id IN (SELECT id FROM ${t} WHERE generation_id = ?))`).join(" OR ")}
        OR (ss.spec_table = 'generations' AND ss.spec_id = ?)`,
    Array(LEGACY_TABLES.length + 1).fill(generationId),
  );

  const rawSources: RawSource[] = legacySources.map((s) => ({ ...s, sourceSpace: "legacy" as const }));
  const rawLinks: RawLink[] = legacyLinks.map((l) => ({
    table: l.spec_table, id: l.spec_id, sourceSpace: "legacy" as const, sourceId: l.source_id,
  }));

  // ── document lane — direct FK, no join table, approved rows only ──
  const documentRows = await query<{ table_name: string; id: number; source_document_id: number }>(
    `SELECT 'mass_homologations' AS table_name, id, source_document_id
       FROM mass_homologations WHERE generation_id = ? AND qa_state = 'approved'
     UNION ALL
     SELECT 'spec_facts' AS table_name, id, source_document_id
       FROM spec_facts WHERE generation_id = ? AND qa_state = 'approved'
     UNION ALL
     SELECT 'tyre_homologations' AS table_name, id, source_document_id
       FROM tyre_homologations WHERE generation_id = ? AND qa_state = 'approved'`,
    [generationId, generationId, generationId],
  );
  const docIds = Array.from(new Set(documentRows.map((r) => r.source_document_id)));
  const documents = docIds.length
    ? await query<{ id: number; doc_type: string; citation: string; original_url: string | null; public_link: 0 | 1; retrieved_at: string; notes: string | null }>(
        `SELECT id, doc_type, citation, original_url, public_link, retrieved_at, notes
         FROM documents WHERE id IN (${docIds.map(() => "?").join(",")})`,
        docIds,
      )
    : [];

  rawSources.push(
    ...documents.map((d) => ({
      id: d.id, type: d.doc_type, citation: d.citation, url: d.original_url,
      public_link: d.public_link, retrieved_at: d.retrieved_at, notes: d.notes,
      sourceSpace: "document" as const,
    })),
  );
  rawLinks.push(
    ...documentRows.map((r) => ({
      table: r.table_name, id: r.id, sourceSpace: "document" as const, sourceId: r.source_document_id,
    })),
  );

  return mergeAndNumberSources(rawSources, rawLinks, renderedRows);
}
