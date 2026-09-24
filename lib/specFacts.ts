/**
 * Dual-read helper for the document-first schema (mig 579). Pure
 * summarization logic lives here with no `lib/db` import so it is
 * deterministically unit-tested; the DB-facing shell that fetches rows
 * is `getVerifiedMasses()` at the bottom of this file (Task 4) — kept in
 * the same file (not split) because it's the only consumer of these types
 * and callers (pages) need one import.
 *
 * Feature flag: USE_SPEC_FACTS. Read ONLY through isSpecFactsEnabled() —
 * do not inline process.env checks in page code. Pages using this in a
 * statically-generated route (generateStaticParams) read the flag at
 * BUILD time, not per-request — see plan Global Constraints.
 */

export const MASS_SPAN_VETO_KG = 40;

export type MassFactRow = {
  id: number;
  vehicle_type_id: number;
  mass_kind: string;
  value_kg: number | null;
  source_document_id: number;
};

export type MassKindSummary = {
  kind: string;
  min: number;
  max: number;
  n: number;
  spanKg: number;
  /** true when spanKg > MASS_SPAN_VETO_KG — render as a labelled range,
   *  never collapse to one number (the "silent wrong-merge" guardrail
   *  from the design doc's risk table). */
  isRange: boolean;
  rowIds: number[];
  documentIds: number[];
};

export function summarizeMassKind(rows: MassFactRow[], kind: string): MassKindSummary | null {
  const matching = rows.filter((r) => r.mass_kind === kind && r.value_kg != null);
  if (matching.length === 0) return null;
  const values = matching.map((r) => r.value_kg as number);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const spanKg = max - min;
  return {
    kind,
    min,
    max,
    n: matching.length,
    spanKg,
    isRange: spanKg > MASS_SPAN_VETO_KG,
    rowIds: matching.map((r) => r.id),
    documentIds: Array.from(new Set(matching.map((r) => r.source_document_id))).sort((a, b) => a - b),
  };
}

export function summarizeAllMassKinds(rows: MassFactRow[]): MassKindSummary[] {
  const kinds = Array.from(new Set(rows.map((r) => r.mass_kind)));
  return kinds
    .map((k) => summarizeMassKind(rows, k))
    .filter((s): s is MassKindSummary => s != null);
}

/** Render-gate threshold: suppress a section with fewer than 3 approved
 *  + cited datapoints (Global Constraints / design §3a publish-CI rule). */
export function hasEnoughVerifiedData(summaries: Array<{ kind: string; n: number }>): boolean {
  return summaries.filter((s) => s.n > 0).length >= 3;
}

/** Feature flag. Deliberately strict-equals "1" — no truthy-string coercion,
 *  so a stray USE_SPEC_FACTS=true or =yes in an env file doesn't silently
 *  flip production. */
export function isSpecFactsEnabled(): boolean {
  return process.env.USE_SPEC_FACTS === "1";
}
