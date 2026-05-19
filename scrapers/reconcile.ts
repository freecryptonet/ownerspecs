/**
 * Reconcile two TrimSpec records (auto-data + ultimatespecs) into one merged
 * record + a list of warnings.
 *
 * Pure function. No I/O.
 *
 * Field policy:
 * - Both null → merged null
 * - Exactly one source has a value → take it; record both sources where they
 *   agreed-by-absence is meaningful (we don't — only the source that provided
 *   the value is cited)
 * - Both populated, numbers within tolerance → take primary source's value;
 *   both sources cited
 * - Both populated, numbers DISAGREE beyond tolerance → keep both values,
 *   merged uses primary source value with a warning recorded
 * - Both populated, strings → semantic comparison: if they parse to the same
 *   meaning ("RWD" ≡ "Rear wheel drive", "Petrol" ≡ "Petrol (Gasoline)"),
 *   prefer the more descriptive value; otherwise prefer primary, log warning
 *
 * Primary source policy: auto-data.net is primary by default because its
 * field naming + structure is closer to the OEM service-manual conventions
 * (DIN kerb weight, codename'd generations, exact production years). For
 * fields ultimatespecs covers better (kw, valvetrain, rear_track, trailer_braked),
 * we explicitly take ultimatespecs.
 */
import type { AutoDataSpec } from "./auto-data.js";
import type { UltimateSpecsSpec } from "./ultimatespecs.js";

export type TrimSpec = AutoDataSpec | UltimateSpecsSpec;

export type Warning = {
  field: string;
  auto_data: unknown;
  ultimatespecs: unknown;
  delta_pct?: number;
  note: string;
};

export type SourceUsage = Record<string, ("auto-data.net" | "ultimatespecs.com")[]>;

export type Reconciled = {
  /** Merged record. Keeps `source` field as null since it's now multi-sourced. */
  merged: Omit<TrimSpec, "source"> & { source: null };
  /** Which sources actually provided which fields, for spec_sources insertion. */
  sources: SourceUsage;
  /** Disagreements above tolerance, for human review. */
  warnings: Warning[];
  /** Scraped URLs, so the orchestrator can store provenance. */
  urls: { autoData: string | null; ultimatespecs: string | null };
};

/** Tolerance for numeric agreement. ±5% by default — empirically matches how
 *  different test conventions deviate (NEDC vs WLTP fuel; DIN vs driver-included
 *  kerb weight). Tighter would cause false positives. */
const TOLERANCE_PCT = 5;

/** Fields where ultimatespecs is preferred when both have values (better coverage). */
const PREFER_ULTIMATESPECS = new Set([
  "engine.valvetrain",
  "performance.kw",
  "dimensions.rear_track_mm",
  "weight.trailer_braked_kg",
]);

/** String similarity: are these two strings "equivalent" semantically? */
function stringsAgree(a: string, b: string): boolean {
  if (!a || !b) return false;
  const norm = (s: string) =>
    s
      .toLowerCase()
      .replace(/[(),./\\]/g, " ")
      .replace(/\s+/g, " ")
      .trim();
  const na = norm(a);
  const nb = norm(b);
  if (na === nb) return true;
  // Substring containment (handles "Petrol" vs "Petrol (Gasoline)")
  if (na.includes(nb) || nb.includes(na)) return true;
  // Common abbreviations
  const ABBREVIATIONS: Array<[RegExp, string]> = [
    [/\brwd\b/g, "rear wheel drive"],
    [/\bfwd\b/g, "front wheel drive"],
    [/\b4wd\b/g, "all wheel drive"],
    [/\bawd\b/g, "all wheel drive"],
  ];
  let na2 = na;
  let nb2 = nb;
  for (const [re, full] of ABBREVIATIONS) {
    na2 = na2.replace(re, full);
    nb2 = nb2.replace(re, full);
  }
  return na2 === nb2 || na2.includes(nb2) || nb2.includes(na2);
}

/** Numbers agree within TOLERANCE_PCT. Both null → false (handled upstream). */
function numbersAgree(a: number, b: number): boolean {
  if (a === b) return true;
  if (a === 0 || b === 0) return Math.abs(a - b) < 0.001;
  const delta = Math.abs(a - b) / Math.max(Math.abs(a), Math.abs(b));
  return delta * 100 <= TOLERANCE_PCT;
}

function deltaPct(a: number, b: number): number {
  if (a === b) return 0;
  if (a === 0 || b === 0) return Infinity;
  return Math.round((Math.abs(a - b) / Math.max(Math.abs(a), Math.abs(b))) * 1000) / 10;
}

/** Merge a single field. Returns the merged value and which sources contributed. */
function mergeField(
  path: string,
  aVal: unknown,
  uVal: unknown,
  warnings: Warning[],
): { value: unknown; sources: ("auto-data.net" | "ultimatespecs.com")[] } {
  // Both null → null, no sources
  if (aVal == null && uVal == null) return { value: null, sources: [] };
  // Only one has it → take it, single source
  if (aVal == null) return { value: uVal, sources: ["ultimatespecs.com"] };
  if (uVal == null) return { value: aVal, sources: ["auto-data.net"] };

  // Both populated
  if (typeof aVal === "number" && typeof uVal === "number") {
    if (numbersAgree(aVal, uVal)) {
      // Both agree → primary value, both sources
      return { value: aVal, sources: ["auto-data.net", "ultimatespecs.com"] };
    }
    // Disagree → warning, pick by preference
    const prefer = PREFER_ULTIMATESPECS.has(path) ? uVal : aVal;
    warnings.push({
      field: path,
      auto_data: aVal,
      ultimatespecs: uVal,
      delta_pct: deltaPct(aVal, uVal),
      note: `numbers disagree by ${deltaPct(aVal, uVal)}% — kept ${
        PREFER_ULTIMATESPECS.has(path) ? "ultimatespecs" : "auto-data"
      }`,
    });
    return { value: prefer, sources: ["auto-data.net", "ultimatespecs.com"] };
  }

  if (typeof aVal === "string" && typeof uVal === "string") {
    if (stringsAgree(aVal, uVal)) {
      // Prefer the more descriptive one (longer, generally)
      const value = aVal.length >= uVal.length ? aVal : uVal;
      return { value, sources: ["auto-data.net", "ultimatespecs.com"] };
    }
    warnings.push({
      field: path,
      auto_data: aVal,
      ultimatespecs: uVal,
      note: "strings don't agree — kept auto-data",
    });
    return { value: aVal, sources: ["auto-data.net", "ultimatespecs.com"] };
  }

  // Type mismatch — keep primary
  return { value: aVal, sources: ["auto-data.net"] };
}

/** Walk both objects in parallel, mergeField every leaf. */
function mergeDeep(
  prefix: string,
  a: Record<string, unknown> | null,
  u: Record<string, unknown> | null,
  warnings: Warning[],
  sources: SourceUsage,
): Record<string, unknown> {
  const result: Record<string, unknown> = {};
  const keys = new Set<string>([
    ...Object.keys(a ?? {}),
    ...Object.keys(u ?? {}),
  ]);
  for (const key of keys) {
    const path = prefix ? `${prefix}.${key}` : key;
    const aVal = a?.[key];
    const uVal = u?.[key];
    // Recurse into plain objects (not arrays, not null)
    if (
      aVal !== null &&
      typeof aVal === "object" &&
      !Array.isArray(aVal) &&
      uVal !== null &&
      typeof uVal === "object" &&
      !Array.isArray(uVal)
    ) {
      result[key] = mergeDeep(
        path,
        aVal as Record<string, unknown>,
        uVal as Record<string, unknown>,
        warnings,
        sources,
      );
      continue;
    }
    const { value, sources: srcs } = mergeField(path, aVal, uVal, warnings);
    result[key] = value;
    if (srcs.length > 0) sources[path] = srcs;
  }
  return result;
}

export function reconcile(
  autoData: AutoDataSpec,
  ultimatespecs: UltimateSpecsSpec,
): Reconciled {
  const warnings: Warning[] = [];
  const sources: SourceUsage = {};

  const merged = mergeDeep("", autoData as unknown as Record<string, unknown>,
    ultimatespecs as unknown as Record<string, unknown>, warnings, sources);

  // Strip non-data fields that shouldn't be reconciled
  delete merged.source;
  delete merged.url;
  delete merged.scraped_at;

  return {
    merged: {
      ...(merged as Omit<TrimSpec, "source">),
      source: null,
    },
    sources,
    warnings,
    urls: {
      autoData: autoData.url,
      ultimatespecs: ultimatespecs.url,
    },
  };
}
