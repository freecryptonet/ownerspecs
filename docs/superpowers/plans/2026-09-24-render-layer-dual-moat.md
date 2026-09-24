# Render Layer — Dual-Moat (Plan 5) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Render the document-first data (`spec_facts` / `mass_homologations`, mig 579 applied 2026-09-23) on the live Next.js site, starting with ONE low-risk slice (Kia Rio `/towing`), with legacy data as a labelled fallback, behind a feature flag (`USE_SPEC_FACTS`), deployed via a parallel-build + atomic-swap procedure that never takes `.next` away from the live pm2 process.

**Design authority:** `docs/superpowers/specs/2026-09-23-global-dual-moat-design.md` §3a. This plan implements §3a's item (5) "render layer" from its Open Items list. Do not re-litigate the panel-decided points reproduced in Global Constraints below — if a task appears to conflict with one, the task is wrong, fix the task.

**Architecture summary (what we're building):**
- A pure/impure-split `lib/specFacts.ts`: pure summarization (mass-kind grouping, 40&nbsp;kg range veto, feature-flag read) + a thin DB-query shell (`getVerifiedMasses`).
- `lib/labels.ts` gains `massKindLabels` / `massKindCategory` — the project's single-source-of-truth enum-label convention (CLAUDE.md), extended to the new schema's `mass_homologations.mass_kind` vocabulary.
- `lib/citations.ts` `buildCitationIndex` gains a second citation lane: legacy `sources`/`spec_sources` (unchanged) UNIONED with new `documents` rows referenced directly via `spec_facts.source_document_id` / `mass_homologations.source_document_id` / `tyre_homologations.source_document_id`. These are two different ID spaces (`sources.id` vs `documents.id`) that must not collide when merged into one rendered `[n]` list — the merge/numbering logic is extracted into a pure, unit-tested function.
- `app/[brand]/[generation]/towing/page.tsx` becomes the flag-gated dual-read consumer: legacy `trims` query untouched; a new verified-masses branch renders when `USE_SPEC_FACTS=1` AND approved facts exist for the generation.
- Deploy: `next.config.ts` gets a `distDir` that can be overridden via `NEXT_DIST_DIR`; a new `scripts/deploy-atomic.sh` builds into the currently-inactive of two real directories (`.next-blue` / `.next-green`) and swaps a symlink (`.next -> .next-{color}`) with a single `mv -T` (atomic rename), so the live pm2 process never sees `.next` missing. This retires `rm -rf .next && npm run build` as the default path for this project (kept only as the documented emergency full-rebuild fallback).

**Tech stack:** TypeScript / Next.js 16 (existing app, no new runtime deps). Vitest for the new pure functions — **this project currently has zero test infrastructure** (`grep` of `package.json` + repo confirmed no `vitest`/`jest`/`*.test.ts`), so Task 1 bootstraps a minimal Vitest config scoped to `lib/*.ts` pure functions only. DB-touching code (`getVerifiedMasses`, `buildCitationIndex`) is not unit-tested — consistent with the existing codebase's convention (`lib/generation.ts` has no tests either) — and is instead verified by local dual-build diffing (Task 12) and prod smoke-test (Task 14).

**Ground truth as of 2026-09-24 (verified live against the prod DB — re-check before executing if this plan is picked up later):**
- Kia Rio YB generation = `generations.id = 456`, slug `rio-yb-hatchback-2018-2023`, make `kia`.
- `mass_homologations`: 80 rows, **all** `generation_id = 456`, **all** `qa_state = 'pending'`. 10 `vehicle_types` rows (ids 1–10, all `commercial_label='RIO'`, distinct `tvv_variant`/`tvv_version`/`approval_extension`), 8 mass rows each.
- Actual `DISTINCT mass_kind` values in the table: `running_order`, `max_laden_permissible`, `max_laden_technical`, `max_combination`, `tow_braked`, `tow_unbraked`, `max_axle`. **This differs from the schema-comment vocabulary in mig 579** (`actual_mass`, `tow_braked_drawbar`, `tow_braked_centre_axle`, `coupling_vertical` do not appear in real data) — code must be driven off the real `DISTINCT` values, not the comment.
- `documents.id = 1`: citation `"RDW Open Data (CC0)"`, `doc_type = 'rdw_open'`, `public_link = 1`. Every one of the 80 rows cites this single document. `source_priority.rdw_open = 90`.
- `trims` for generation 456: **0 rows**. This means `/towing` for the Kia Rio currently 404s (`if (trims.length === 0) notFound();`) — slice 1 is not "enhancing a live page," it is turning a 404 into a page, gated by the flag. No legacy data exists for this gen, so there is genuinely no reconciliation conflict for slice 1 (confirms the panel's "low-risk, no legacy conflict" call).
- `vehicle_type_id = 3` (`tvv_variant='B5P11'`, `tvv_version='M61BZ1'`) has `running_order = 1160`, which is the exact CoC-gold match recorded in memory `reference_rdw_field_semantics.md` — this is the strongest single row to cite when justifying QA approval.
- pm2 app `os` runs `npm start` → `next start` with cwd `/home/deploy/ownerspecs`, default `distDir` (`.next`). No existing blue/green or symlink layout — Task 11 bootstraps it.
- `/towing/page.tsx` currently builds its Sources block via `getSourcesFor(gen.id, "trims")`, not `buildCitationIndex`. Task 8 migrates it to `buildCitationIndex` (already page-aware, already supports the `trims` table) so both legacy and new-table citations flow through one path.

## Global Constraints

- Feature flag `USE_SPEC_FACTS` default **OFF** (unset or `"0"`). Read via `lib/specFacts.ts`'s `isSpecFactsEnabled()` — no ad-hoc `process.env` checks in page code.
- Render **only** `qa_state = 'approved'` AND cited (`source_document_id NOT NULL`, enforced by schema) facts. Never render `pending` or `rejected` rows.
- **Verified-wins-per-field, legacy is labelled fallback.** Never silently blend a verified value into a legacy row or vice versa — each rendered datapoint carries one explicit provenance (`verified` or `legacy — unverified`).
- **`/towing` and all SSG topic pages are statically generated** (`generateStaticParams`). `process.env.USE_SPEC_FACTS` is read at **build time**, not per-request. Flipping the flag requires a rebuild — it is not a runtime toggle. (This is why the atomic-swap deploy matters: it's what makes "rebuild to flip the flag" safe to run at any time, not a strictly off-peak-only operation.)
- Never `rm -rf .next` (nor otherwise remove it) while the live pm2 process is running against it. Build into a parallel directory; swap atomically (single `mv -T` rename of a symlink). No concurrent builds — the deploy script takes a lock.
- Facts-only / vendor-neutral: `documents.citation` for this slice is `"RDW Open Data (CC0)"` — already vendor-neutral and a legitimate `public_link=1` government source. No paid-vendor names anywhere in rendered output (existing sitewide rule, unaffected by this plan but re-grep on smoke test).
- `massa_ledig` / any `actual_mass`-equivalent mass_kind must **never** be labelled or rendered as "kerb weight." (Defensive: not present in the current Kia Rio data, but `massKindCategory()` must classify it `tax_only` so a future gen with that mass_kind can't regress this.)
- Every new rendered datapoint carries a provenance badge (`components/ProvenanceBadge.tsx`).
- Section-level render-gate: suppress the verified-masses section (and log why) when fewer than 3 approved+cited datapoints exist for the generation — matches the existing `notFound()` / suppress-empty-tab convention, **not** a `noindex` mechanism (per §3a correction).
- Smoke-test after every deploy: HTTP 200, expected content present, vendor-leak grep clean (existing project convention, `feedback_smoke_test_after_every_push.md`).
- Run all local Node/npm commands via the PowerShell tool for `F:\...` paths — the Bash tool strips backslashes (CLAUDE.md gotcha).

---

### Task 1: Bootstrap Vitest for `lib/` pure functions

**Files:**
- Create: `F:\projects\ownerspecs\vitest.config.ts`
- Modify: `F:\projects\ownerspecs\package.json` (add `vitest` devDependency + `"test": "vitest run"` script)

**Interfaces:** none (tooling only).

- [ ] **Step 1: Install and configure**

```powershell
cd F:\projects\ownerspecs
npm install -D vitest
```

```ts
// vitest.config.ts
import { defineConfig } from "vitest/config";
import path from "path";

export default defineConfig({
  test: {
    environment: "node",
    include: ["lib/**/*.test.ts"],
  },
  resolve: {
    alias: { "@": path.resolve(__dirname, ".") },
  },
});
```

Add to `package.json` `scripts`: `"test": "vitest run"`.

- [ ] **Step 2: Write a trivial smoke test to prove the harness works**

```ts
// lib/_vitest_smoke.test.ts  (delete after Task 2 lands a real test file — this only proves the runner works)
import { describe, it, expect } from "vitest";
describe("vitest bootstrap", () => {
  it("runs", () => expect(1 + 1).toBe(2));
});
```

- [ ] **Step 3: Run it**

Run: `cd F:\projects\ownerspecs; npm test`
Expected: 1 passed. Delete `lib/_vitest_smoke.test.ts` once Task 2's real test file exists and passes (don't leave a placeholder test in the suite).

- [ ] **Step 4: Commit**

```bash
git add vitest.config.ts package.json package-lock.json
git commit -m "chore: bootstrap Vitest for lib/ pure-function unit tests"
```

---

### Task 2: `lib/labels.ts` — mass-kind labels + presentation category

**Files:**
- Modify: `F:\projects\ownerspecs\lib\labels.ts`
- Create: `F:\projects\ownerspecs\lib\labels.test.ts`

**Interfaces:**
- Produces: `massKindLabels: Record<string,string>`, `massKindLabel(k: string): string`, `massKindCategory(k: string): "headline" | "supporting" | "tax_only"`.
- Consumes: nothing new (follows the existing `fluidLabels`/`fluidLabel` pattern already in the file, using `humanize()` as fallback).

Labels source: `reference_rdw_field_semantics.md` weight-presentation policy + the real `DISTINCT mass_kind` values confirmed against prod (see Ground Truth above).

- [ ] **Step 1: Write the failing test**

```ts
// lib/labels.test.ts
import { describe, it, expect } from "vitest";
import { massKindLabel, massKindCategory } from "./labels";

describe("massKindLabel", () => {
  it("labels the real mass_homologations vocabulary", () => {
    expect(massKindLabel("running_order")).toBe("Mass in running order (EU type-approval)");
    expect(massKindLabel("tow_braked")).toMatch(/braked trailer/i);
    expect(massKindLabel("tow_unbraked")).toMatch(/unbraked trailer/i);
    expect(massKindLabel("max_axle")).toMatch(/axle/i);
  });

  it("falls back to humanize() for an unmapped kind", () => {
    expect(massKindLabel("some_new_kind")).toBe("Some new kind");
  });
});

describe("massKindCategory", () => {
  it("classifies running_order as headline", () => {
    expect(massKindCategory("running_order")).toBe("headline");
  });

  it("classifies towing/axle/combination as supporting", () => {
    expect(massKindCategory("tow_braked")).toBe("supporting");
    expect(massKindCategory("tow_unbraked")).toBe("supporting");
    expect(massKindCategory("max_axle")).toBe("supporting");
    expect(massKindCategory("max_combination")).toBe("supporting");
    expect(massKindCategory("max_laden_permissible")).toBe("supporting");
    expect(massKindCategory("max_laden_technical")).toBe("supporting");
  });

  it("NEVER classifies an actual_mass / kerb-shaped kind as headline or supporting — tax_only guard", () => {
    // Defensive: this mass_kind doesn't exist in current data (see plan Ground Truth)
    // but a future RDW ingest could add it. It must never render as "kerb weight."
    expect(massKindCategory("actual_mass")).toBe("tax_only");
  });

  it("defaults an unknown kind to supporting, never headline or tax_only silently", () => {
    expect(massKindCategory("something_unseen")).toBe("supporting");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/labels.test.ts`
Expected: FAIL — `massKindLabel` / `massKindCategory` not exported.

- [ ] **Step 3: Write minimal implementation**

Append to `lib/labels.ts`:

```ts
// ───────────────────────── mass_homologations.mass_kind ────────────────────
// Vocabulary + presentation policy from reference_rdw_field_semantics.md
// (weight-presentation policy, panel-unanimous 2026-09-23). `category`
// controls where a value CAN render: 'headline' = the answer-card number;
// 'supporting' = the per-kind table row; 'tax_only' = NEVER the weight
// block or any towing/payload calculator — a separate "NL registration /
// road-tax" box only. Unknown kinds default to 'supporting', never
// 'headline' or silently 'tax_only', so an unseen kind degrades safely
// instead of either overclaiming or vanishing.

export const massKindLabels: Record<string, string> = {
  running_order: "Mass in running order (EU type-approval)",
  max_laden_permissible: "Permissible maximum laden mass",
  max_laden_technical: "Technically permissible maximum laden mass",
  max_combination: "Maximum mass of combination (vehicle + trailer)",
  tow_braked: "Towing capacity — braked trailer",
  tow_unbraked: "Towing capacity — unbraked trailer",
  max_axle: "Maximum axle load",
  // Defensive — not present in current data, see plan Ground Truth. If RDW-derived
  // "leeggewicht"-equivalent facts are ever ingested into this table, they land here.
  actual_mass: "Leeggewicht — RDW-derived (NL admin convention; not a manufacturer kerb)",
};

export const massKindLabel = (k: string) => massKindLabels[k] ?? humanize(k);

const MASS_KIND_HEADLINE = new Set(["running_order"]);
const MASS_KIND_TAX_ONLY = new Set(["actual_mass"]);

export function massKindCategory(k: string): "headline" | "supporting" | "tax_only" {
  if (MASS_KIND_TAX_ONLY.has(k)) return "tax_only";
  if (MASS_KIND_HEADLINE.has(k)) return "headline";
  return "supporting";
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/labels.test.ts`
Expected: PASS (6 passed).

- [ ] **Step 5: Commit**

```bash
git add lib/labels.ts lib/labels.test.ts
git commit -m "feat(labels): mass_homologations.mass_kind labels + presentation category"
```

---

### Task 3: `lib/specFacts.ts` — pure summarization core (40 kg veto, feature flag)

**Files:**
- Create: `F:\projects\ownerspecs\lib\specFacts.ts`
- Create: `F:\projects\ownerspecs\lib\specFacts.test.ts`

**Interfaces:**
- Produces: `MASS_SPAN_VETO_KG = 40`; `type MassFactRow = { id: number; vehicle_type_id: number; mass_kind: string; value_kg: number | null; source_document_id: number }`; `summarizeMassKind(rows: MassFactRow[], kind: string): MassKindSummary | null`; `summarizeAllMassKinds(rows: MassFactRow[]): MassKindSummary[]`; `type MassKindSummary = { kind: string; min: number; max: number; n: number; spanKg: number; isRange: boolean; rowIds: number[]; documentIds: number[] }`; `isSpecFactsEnabled(): boolean`; `hasEnoughVerifiedData(summaries: MassKindSummary[]): boolean` (>= 3 distinct kinds with n >= 1 — the render-gate threshold from Global Constraints).
- Consumes: nothing (pure — no `lib/db` import in this file; the DB-touching shell is Task 4).

- [ ] **Step 1: Write the failing test**

```ts
// lib/specFacts.test.ts
import { describe, it, expect, vi, afterEach } from "vitest";
import {
  MASS_SPAN_VETO_KG,
  summarizeMassKind,
  summarizeAllMassKinds,
  isSpecFactsEnabled,
  hasEnoughVerifiedData,
  type MassFactRow,
} from "./specFacts";

const row = (over: Partial<MassFactRow>): MassFactRow => ({
  id: 1, vehicle_type_id: 1, mass_kind: "running_order", value_kg: 1160,
  source_document_id: 1, ...over,
});

describe("summarizeMassKind", () => {
  it("collapses to a single value when all rows agree", () => {
    const rows = [row({ id: 1, value_kg: 1160 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order");
    expect(s).toEqual({
      kind: "running_order", min: 1160, max: 1160, n: 2, spanKg: 0,
      isRange: false, rowIds: [1, 2], documentIds: [1],
    });
  });

  it("reports a range but does NOT collapse to a misleading single number when span <= 40kg", () => {
    const rows = [row({ id: 1, value_kg: 1155 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order")!;
    expect(s.min).toBe(1155);
    expect(s.max).toBe(1160);
    expect(s.spanKg).toBe(5);
    expect(s.isRange).toBe(false); // small span: fine to show a single "up to" style number upstream
  });

  it("flags isRange=true (the 40kg veto) when span exceeds the threshold — never silently pick one value", () => {
    const rows = [row({ id: 1, value_kg: 1100 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order")!;
    expect(s.spanKg).toBe(60);
    expect(s.spanKg).toBeGreaterThan(MASS_SPAN_VETO_KG);
    expect(s.isRange).toBe(true);
  });

  it("ignores rows for a different mass_kind and null values", () => {
    const rows = [
      row({ id: 1, mass_kind: "tow_braked", value_kg: 1000 }),
      row({ id: 2, mass_kind: "running_order", value_kg: null }),
    ];
    expect(summarizeMassKind(rows, "running_order")).toBeNull();
  });

  it("returns null for an empty/absent kind", () => {
    expect(summarizeMassKind([], "running_order")).toBeNull();
  });
});

describe("summarizeAllMassKinds", () => {
  it("groups the real 7-kind Kia Rio vocabulary into 7 summaries", () => {
    const kinds = ["running_order", "max_laden_permissible", "max_laden_technical",
      "max_combination", "tow_braked", "tow_unbraked", "max_axle"];
    const rows = kinds.map((k, i) => row({ id: i + 1, mass_kind: k, value_kg: 1000 + i }));
    const summaries = summarizeAllMassKinds(rows);
    expect(summaries.map((s) => s.kind).sort()).toEqual([...kinds].sort());
  });
});

describe("hasEnoughVerifiedData", () => {
  it("requires at least 3 distinct populated mass kinds", () => {
    const two = [{ kind: "a", n: 1 }, { kind: "b", n: 1 }] as any;
    const three = [{ kind: "a", n: 1 }, { kind: "b", n: 1 }, { kind: "c", n: 1 }] as any;
    expect(hasEnoughVerifiedData(two)).toBe(false);
    expect(hasEnoughVerifiedData(three)).toBe(true);
  });
});

describe("isSpecFactsEnabled", () => {
  const ORIGINAL = process.env.USE_SPEC_FACTS;
  afterEach(() => { process.env.USE_SPEC_FACTS = ORIGINAL; });

  it("defaults OFF when unset", () => {
    delete process.env.USE_SPEC_FACTS;
    expect(isSpecFactsEnabled()).toBe(false);
  });
  it("is ON only for the literal string '1'", () => {
    process.env.USE_SPEC_FACTS = "1";
    expect(isSpecFactsEnabled()).toBe(true);
    process.env.USE_SPEC_FACTS = "true"; // deliberately NOT truthy — avoid accidental enable via any non-empty string
    expect(isSpecFactsEnabled()).toBe(false);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/specFacts.test.ts`
Expected: FAIL — module doesn't exist.

- [ ] **Step 3: Write minimal implementation**

```ts
// lib/specFacts.ts
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/specFacts.test.ts`
Expected: PASS (10 passed).

- [ ] **Step 5: Commit**

```bash
git add lib/specFacts.ts lib/specFacts.test.ts
git commit -m "feat(specFacts): pure mass-kind summarization core + 40kg range veto + feature flag"
```

---

### Task 4: `lib/specFacts.ts` — DB-facing `getVerifiedMasses()` shell

**Files:**
- Modify: `F:\projects\ownerspecs\lib\specFacts.ts`

**Interfaces:**
- Produces: `getVerifiedMasses(generationId: number): Promise<MassFactRow[]>` — queries `mass_homologations` for `qa_state = 'approved'` rows scoped to the generation. Not unit-tested (DB I/O); verified via Task 12's local build + Task 14's prod smoke test, consistent with `lib/generation.ts` having no tests.
- Consumes: `query` from `@/lib/db`; `MassFactRow` (Task 3).

- [ ] **Step 1: Write the implementation** (no failing-test step — DB shell, per Global Constraints/tech-stack note; mirrors `lib/generation.ts`'s untested query functions)

Append to `lib/specFacts.ts`:

```ts
import { query } from "@/lib/db";

/** Approved, cited masses for one generation. Market defaults to whatever
 *  is in the table for now (slice 1 is single-market NL/RDW data) —
 *  a market_id filter param is deferred to slice 2+ when a gen has
 *  multiple markets' worth of approved facts. */
export async function getVerifiedMasses(generationId: number): Promise<MassFactRow[]> {
  return query<MassFactRow>(
    `SELECT id, vehicle_type_id, mass_kind, value_kg, source_document_id
     FROM mass_homologations
     WHERE generation_id = ? AND qa_state = 'approved'
     ORDER BY vehicle_type_id, mass_kind`,
    [generationId],
  );
}
```

- [ ] **Step 2: Manual sanity check against prod (read-only, no build needed)**

Run (PowerShell, over SSH — read-only query, safe to run anytime):
```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 "mariadb ownerspecs -e \"SELECT COUNT(*) FROM mass_homologations WHERE generation_id=456 AND qa_state='approved';\""
```
Expected right now: `0` (Task 6 hasn't run yet). This just confirms the query shape is syntactically valid against the real schema before wiring it into a page — run it again after Task 6 and expect `80`.

- [ ] **Step 3: Commit**

```bash
git add lib/specFacts.ts
git commit -m "feat(specFacts): getVerifiedMasses() DB shell for the dual-read helper"
```

---

### Task 5: `lib/citations.ts` — extract pure merge/number logic (refactor, no behavior change)

**Files:**
- Modify: `F:\projects\ownerspecs\lib\citations.ts`
- Create: `F:\projects\ownerspecs\lib\citations.test.ts`

**Interfaces:**
- Produces: `type RawSource = { id: number; type: string; citation: string; url: string | null; public_link: 0 | 1; retrieved_at: string; notes: string | null }` (structurally = `SourceRow` but with a required `sourceSpace: "legacy" | "document"` tag to disambiguate the two ID spaces before merging — `sources.id` and `documents.id` both start at 1 and WILL collide if merged as raw numbers); `type RawLink = { table: string; id: number; sourceSpace: "legacy" | "document"; sourceId: number }`; `mergeAndNumberSources(rawSources: RawSource[], rawLinks: RawLink[], renderedRows?: RenderedRow[]): CitationIndex` — the pure extraction of the numbering/renumbering logic already in `buildCitationIndex`, now taking pre-fetched rows instead of querying.
- Consumes: none new (this task only refactors existing logic into a testable pure function; `buildCitationIndex` becomes a thin wrapper that fetches rows and calls it — no `documents` query yet, that's Task 6).

This is a pure refactor first (must not change current page output) so it can be tested in isolation before Task 6 adds the new document lane on top of it.

- [ ] **Step 1: Write the failing test** (exercises the CURRENT legacy-only behavior, expressed against the new pure function)

```ts
// lib/citations.test.ts
import { describe, it, expect } from "vitest";
import { mergeAndNumberSources, type RawSource, type RawLink } from "./citations";

const src = (id: number, citation: string): RawSource => ({
  id, type: "manual", citation, url: null, public_link: 0,
  retrieved_at: "2026-01-01T00:00:00.000Z", notes: null, sourceSpace: "legacy",
});

describe("mergeAndNumberSources — legacy-only (regression baseline)", () => {
  it("numbers sources 1..N in id order and maps citationsFor by rendered row", () => {
    const sources = [src(5, "Source A"), src(9, "Source B")];
    const links: RawLink[] = [
      { table: "trims", id: 100, sourceSpace: "legacy", sourceId: 5 },
      { table: "trims", id: 100, sourceSpace: "legacy", sourceId: 9 },
    ];
    const idx = mergeAndNumberSources(sources, links, [{ table: "trims", id: 100 }]);
    expect(idx.sources.map((s) => s.citation)).toEqual(["Source A", "Source B"]);
    expect(idx.citationsFor("trims", 100)).toEqual([1, 2]);
  });

  it("excludes a source with no citation in the rendered set (suppressed-row rule)", () => {
    const sources = [src(1, "Only cites a suppressed row")];
    const links: RawLink[] = [{ table: "trims", id: 200, sourceSpace: "legacy", sourceId: 1 }];
    const idx = mergeAndNumberSources(sources, links, [{ table: "trims", id: 999 }]); // 200 not rendered
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("trims", 200)).toEqual([]);
  });

  it("falls back to citing everything when renderedRows is undefined (gen-overview convention)", () => {
    const sources = [src(1, "A")];
    const links: RawLink[] = [{ table: "trims", id: 1, sourceSpace: "legacy", sourceId: 1 }];
    const idx = mergeAndNumberSources(sources, links, undefined);
    expect(idx.citationsFor("trims", 1)).toEqual([1]);
  });
});

describe("mergeAndNumberSources — legacy + document ID-space collision (the new-table case)", () => {
  it("does not collide sources.id=1 with documents.id=1 when both are cited", () => {
    const legacy: RawSource = { id: 1, type: "manual", citation: "Legacy source #1",
      url: null, public_link: 0, retrieved_at: "2026-01-01T00:00:00.000Z", notes: null, sourceSpace: "legacy" };
    const doc: RawSource = { id: 1, type: "rdw_open", citation: "RDW Open Data (CC0)",
      url: null, public_link: 1, retrieved_at: "2026-09-01T00:00:00.000Z", notes: null, sourceSpace: "document" };
    const links: RawLink[] = [
      { table: "trims", id: 10, sourceSpace: "legacy", sourceId: 1 },
      { table: "mass_homologations", id: 20, sourceSpace: "document", sourceId: 1 },
    ];
    const idx = mergeAndNumberSources([legacy, doc], links, [
      { table: "trims", id: 10 }, { table: "mass_homologations", id: 20 },
    ]);
    expect(idx.sources).toHaveLength(2); // both survive — NOT deduped as "the same id"
    expect(idx.citationsFor("trims", 10)).toEqual([1]);
    expect(idx.citationsFor("mass_homologations", 20)).toEqual([2]);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/citations.test.ts`
Expected: FAIL — `mergeAndNumberSources` not exported.

- [ ] **Step 3: Write minimal implementation** — extract the existing inline logic from `buildCitationIndex` into the new pure function, keying internally by `` `${sourceSpace}:${id}` `` instead of raw `id`, and make `buildCitationIndex` a thin wrapper.

```ts
// lib/citations.ts — replace the whole file body with:
import { query } from "@/lib/db";
import type { SourceRow } from "@/lib/generation";

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

// ── DB-facing shell (unchanged legacy behavior; Task 6 adds the document lane) ──

const LEGACY_TABLES = [
  "trims", "fluid_specs", "torque_specs", "electrical_specs", "bulbs", "fuses",
  "parts", "service_intervals", "tire_pressures", "procedures", "brake_specs",
  "alignment_specs",
] as const;

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

  return mergeAndNumberSources(rawSources, rawLinks, renderedRows);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/citations.test.ts`
Expected: PASS (4 passed).

- [ ] **Step 5: Verify no behavior change** — the refactor must produce byte-identical Sources blocks for every existing gen. Run a local build (see Task 12 for the full dual-build procedure) and diff `.next/server/app/**/oil-capacity.html` sources-list content against a pre-refactor build for 2–3 spot-check gens (e.g. `honda/civic-*`, `bmw/*`). This is a manual diff, not a script — cheap because it's only this one refactor commit.

- [ ] **Step 6: Commit**

```bash
git add lib/citations.ts lib/citations.test.ts
git commit -m "refactor(citations): extract pure mergeAndNumberSources; tag sources by ID space ahead of the documents-table lane"
```

---

### Task 6: `lib/citations.ts` — add the `documents` citation lane (spec_facts / mass_homologations / tyre_homologations)

**Files:**
- Modify: `F:\projects\ownerspecs\lib\citations.ts`
- Modify: `F:\projects\ownerspecs\lib\citations.test.ts`

**Interfaces:**
- Extends `buildCitationIndex` to also fetch `documents` rows referenced by **approved** rows in the three new tables, tag them `sourceSpace: "document"`, and pass them into `mergeAndNumberSources` alongside the legacy lane.
- New tables' rows link 1:1 to a document (`source_document_id`), not through `spec_sources` — no join table involved for this lane.

- [ ] **Step 1: Write the failing test** (integration-shaped, but still against the pure function — supply hand-built "as if fetched from documents" rows)

```ts
// append to lib/citations.test.ts
describe("mergeAndNumberSources — mass_homologations lane end-to-end shape", () => {
  it("renders one shared document citation across multiple mass_homologations rows", () => {
    const doc: RawSource = { id: 1, type: "rdw_open", citation: "RDW Open Data (CC0)",
      url: null, public_link: 1, retrieved_at: "2026-09-01T00:00:00.000Z", notes: null, sourceSpace: "document" };
    const links: RawLink[] = [
      { table: "mass_homologations", id: 1, sourceSpace: "document", sourceId: 1 },
      { table: "mass_homologations", id: 9, sourceSpace: "document", sourceId: 1 },
      { table: "mass_homologations", id: 17, sourceSpace: "document", sourceId: 1 },
    ];
    const idx = mergeAndNumberSources([doc], links, [
      { table: "mass_homologations", id: 1 }, { table: "mass_homologations", id: 9 }, { table: "mass_homologations", id: 17 },
    ]);
    expect(idx.sources).toHaveLength(1); // one document, cited by all three rows
    expect(idx.citationsFor("mass_homologations", 1)).toEqual([1]);
    expect(idx.citationsFor("mass_homologations", 17)).toEqual([1]);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/citations.test.ts`
Expected: PASS actually — this test only exercises `mergeAndNumberSources`, already implemented in Task 5. **This step confirms Task 5's pure function already generalizes correctly to the new shape with zero changes** — the only remaining work is the DB-fetch wiring in `buildCitationIndex`, which has no unit test (DB I/O). Treat this as documentation-by-test of the contract `buildCitationIndex` must satisfy, not a red step. Proceed to Step 3.

- [ ] **Step 3: Wire the new lane into `buildCitationIndex`**

```ts
// lib/citations.ts — extend buildCitationIndex (replace its body)

const DOCUMENT_TABLES = ["mass_homologations", "spec_facts", "tyre_homologations"] as const;

export async function buildCitationIndex(
  generationId: number,
  renderedRows?: RenderedRow[],
): Promise<CitationIndex> {
  const legacySources = await query<SourceRow>(/* unchanged from Task 5 */ ...);
  const legacyLinks = await query(/* unchanged from Task 5 */ ...);

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
```

Note: `DOCUMENT_TABLES` const declared for documentation/readability; the SQL above is written out explicitly (UNION ALL) rather than generated from the const, matching the existing file's style of explicit per-table clauses (see `reference_known_bug_patterns.md` — per-table compound checks, not a generated string, keeps the SQL greppable and avoids the cross-pollination bug class).

- [ ] **Step 4: Manual sanity check against prod** (read-only)

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 "mariadb ownerspecs -e \"SELECT 'mass_homologations' t, id, source_document_id FROM mass_homologations WHERE generation_id=456 AND qa_state='approved' LIMIT 3;\""
```
Expected right now: 0 rows (Task 7 QA-approves them). Confirms the UNION query is syntactically valid.

- [ ] **Step 5: Commit**

```bash
git add lib/citations.ts lib/citations.test.ts
git commit -m "feat(citations): buildCitationIndex reads documents cited by spec_facts/mass_homologations/tyre_homologations (approved-only)"
```

---

### Task 7: QA-approve the Kia Rio `mass_homologations` rows (the slice-1 data step)

**Files:**
- Create: `F:\projects\ownerspecs\db\migrations\580_qa_approve_kia_rio_masses.sql`

**Interfaces:** none — a data migration, not code.

QA criteria (document these in the migration's header comment, not just this plan — future auditors read the migration):
1. **Source-grade check:** `documents.id = 1` is `doc_type = 'rdw_open'`, `public_link = 1`, `source_priority.rdw_open = 90` — a primary-grade government source per mig 579's conflict-resolution table. ✓
2. **CoC-gold cross-check:** `vehicle_type_id = 3` (`tvv_variant='B5P11'`, `tvv_version='M61BZ1'`) `running_order = 1160` exactly matches the held Kia Rio CoC §13 value recorded in memory `reference_rdw_field_semantics.md` (the RDW data-quality harness's own worked example). ✓
3. **Range sanity:** all `running_order` values across the 10 vehicle_types fall in 1155–1160 (5 kg span — well under the 40 kg veto threshold; a real per-variant spread, not noise). All other mass_kinds are in physically plausible ranges for a B-segment hatchback (`max_laden_permissible`/`max_laden_technical` ~1600–1620, `max_combination` ~2600–2730, `tow_braked` 1000, `tow_unbraked` 450, `max_axle` 840–945). Spot-check with the query below before writing the migration.
4. **No conflicting rows:** confirm no other `documents` row conflicts with `documents.id=1` for this generation (`conflict_group IS NULL` on all 80 rows — single-source, nothing to arbitrate).

- [ ] **Step 1: Run the spot-check query** (read-only, confirms criteria 3 before writing the migration)

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 "mariadb ownerspecs -e \"SELECT mass_kind, MIN(value_kg), MAX(value_kg), COUNT(*) FROM mass_homologations WHERE generation_id=456 GROUP BY mass_kind;\""
```
Expected: 7 rows, ranges as described above. If any value is implausible (e.g. a 0 or a 5-digit kg), STOP — do not approve, file a data-quality issue instead of QA-approving bad data.

- [ ] **Step 2: Write the migration**

```sql
-- ownerspecs.com · QA-approve Kia Rio YB (gen 456) mass_homologations · migration 580 · 2026-09-24
-- Slice 1 of the dual-moat render layer (docs/superpowers/plans/2026-09-24-render-layer-dual-moat.md).
--
-- QA criteria applied (see plan Task 7 for full detail):
--   1. Source: documents.id=1 = RDW Open Data (CC0), public_link=1, source_priority.rdw_open=90 (primary-grade).
--   2. CoC-gold cross-check: vehicle_type_id=3 (B5P11/M61BZ1) running_order=1160 exactly matches the held
--      Kia Rio CoC §13 value (reference_rdw_field_semantics.md) — the RDW dq harness's own worked example.
--   3. Range sanity: all 7 mass_kind values plausible for a B-segment hatchback; running_order span
--      across all 10 vehicle_types is 5kg (1155-1160), well under the 40kg silent-wrong-merge veto.
--   4. No conflict_group set on any row — single-source, nothing to arbitrate.
--
-- This is a per-FACT-ROW approval (qa_state), independent of the render-time 40kg range-collapse
-- decision made by lib/specFacts.ts summarizeMassKind() — do not conflate the two.

UPDATE mass_homologations
SET qa_state = 'approved', qa_by = 'claude_plan5_slice1', qa_at = NOW()
WHERE generation_id = 456 AND qa_state = 'pending';
```

- [ ] **Step 3: Apply to prod DB**

```bash
scp -i ~/.ssh/autodtcs_key db/migrations/580_qa_approve_kia_rio_masses.sql root@72.62.154.119:/tmp/
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs < /tmp/580_qa_approve_kia_rio_masses.sql'
```

- [ ] **Step 4: Verify**

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 "mariadb ownerspecs -e \"SELECT qa_state, COUNT(*) FROM mass_homologations WHERE generation_id=456 GROUP BY qa_state;\""
```
Expected: `approved | 80`, no `pending` rows remain for this generation.

- [ ] **Step 5: Commit**

```bash
git add db/migrations/580_qa_approve_kia_rio_masses.sql
git commit -m "data(qa): approve Kia Rio YB mass_homologations — CoC-gold cross-checked, single RDW source, no conflicts"
```

---

### Task 8: `components/ProvenanceBadge.tsx` + CSS tokens

**Files:**
- Create: `F:\projects\ownerspecs\components\ProvenanceBadge.tsx`
- Modify: `F:\projects\ownerspecs\app\globals.css`

**Interfaces:**
- Produces: `<ProvenanceBadge kind="verified" | "legacy" citationNums?={number[]} />` — a small inline pill, distinct from the page-level `VerifyBadge` (which summarizes the WHOLE page's source count). This badge is per-datapoint, per Global Constraints ("provenance badge on every new datapoint").

- [ ] **Step 1: Write the component**

```tsx
// components/ProvenanceBadge.tsx
import { Cites } from "@/components/Cites";

/**
 * Per-datapoint provenance pill. Distinct from VerifyBadge (page-level
 * source-count summary) — this labels ONE rendered value as either a
 * document-verified fact (qa_state='approved', cited via buildCitationIndex)
 * or legacy/uncited catalogue data, per the dual-moat render layer's
 * "verified-wins-per-field with labelled legacy fallback" rule
 * (docs/superpowers/plans/2026-09-24-render-layer-dual-moat.md).
 */
export function ProvenanceBadge({
  kind,
  citationNums,
}: {
  kind: "verified" | "legacy";
  citationNums?: number[];
}) {
  return (
    <span className={`provenance-pill provenance-${kind}`}>
      {kind === "verified" ? "Verified" : "Legacy — unverified"}
      {kind === "verified" && citationNums && citationNums.length > 0 && (
        <Cites nums={citationNums} />
      )}
    </span>
  );
}
```

- [ ] **Step 2: Add CSS tokens** — append to `app/globals.css` near `.verify-badge` (reuse `--accent`/`--accent-bg`/`--ink-soft` tokens already defined there; do not invent new colors):

```css
.provenance-pill {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-family: "IBM Plex Mono", monospace;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  padding: 2px 6px;
  border-radius: 3px;
  line-height: 1.4;
}
.provenance-verified {
  color: var(--accent-deep);
  background: var(--accent-bg);
  border: 1px solid var(--accent);
}
.provenance-legacy {
  color: var(--ink-soft);
  background: var(--bg-alt);
  border: 1px solid var(--rule);
}
```

- [ ] **Step 3: Manual visual check** — no automated test for a presentational component with no logic branches worth unit-testing beyond what TypeScript already enforces (the `kind` union). Verified visually in Task 13's local dev/build pass.

- [ ] **Step 4: Commit**

```bash
git add components/ProvenanceBadge.tsx app/globals.css
git commit -m "feat(ui): ProvenanceBadge — per-datapoint verified/legacy pill"
```

---

### Task 9: `lib/seo.ts` — verified-mass JSON-LD helper

**Files:**
- Modify: `F:\projects\ownerspecs\lib\seo.ts`
- Create: `F:\projects\ownerspecs\lib\seo.test.ts`

**Interfaces:**
- Produces: `vehicleMassJsonLd(opts: { path: string; massKg: number; reviewDate: string }): object` — emits a minimal schema.org `Vehicle` fragment with a `weight` `QuantitativeValue` (`unitCode: "KGM"`, UN/CEFACT code for kilogram — matches schema.org's `QuantitativeValue.unitCode` convention already unused elsewhere in this codebase, confirmed via grep — no existing `weight`/`QuantitativeValue` JSON-LD emitted anywhere today, so there is no drift risk to reconcile against).
- Consumes: nothing new.

- [ ] **Step 1: Write the failing test**

```ts
// lib/seo.test.ts
import { describe, it, expect } from "vitest";
import { vehicleMassJsonLd } from "./seo";

describe("vehicleMassJsonLd", () => {
  it("emits a schema.org Vehicle fragment with a weight QuantitativeValue in kg", () => {
    const ld = vehicleMassJsonLd({ path: "/kia/rio-yb-hatchback-2018-2023/towing", massKg: 1160, reviewDate: "2026-09-24" });
    expect(ld["@type"]).toBe("Vehicle");
    expect(ld.weight).toEqual({ "@type": "QuantitativeValue", value: 1160, unitCode: "KGM" });
    expect(ld.url).toBe("https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing");
    expect(ld.dateModified).toBe("2026-09-24");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/seo.test.ts`
Expected: FAIL — `vehicleMassJsonLd` not exported.

- [ ] **Step 3: Write minimal implementation** — append to `lib/seo.ts`:

```ts
/** Minimal schema.org Vehicle fragment carrying the verified EU type-approval
 *  mass (mass in running order). Emitted ONLY for the headline (`running_order`)
 *  verified value, and only when the dual-read helper found approved facts —
 *  see docs/superpowers/plans/2026-09-24-render-layer-dual-moat.md Task 10.
 *  No other page currently emits a `weight` property (grepped clean 2026-09-24),
 *  so there is no cross-page schema drift to reconcile. */
export function vehicleMassJsonLd(opts: { path: string; massKg: number; reviewDate: string }) {
  return {
    "@context": "https://schema.org",
    "@type": "Vehicle",
    url: `${SITE}${opts.path}`,
    weight: { "@type": "QuantitativeValue", value: opts.massKg, unitCode: "KGM" },
    dateModified: opts.reviewDate,
  };
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd F:\projects\ownerspecs; npx vitest run lib/seo.test.ts`
Expected: PASS (1 passed).

- [ ] **Step 5: Commit**

```bash
git add lib/seo.ts lib/seo.test.ts
git commit -m "feat(seo): vehicleMassJsonLd — verified running-order mass as schema.org Vehicle.weight"
```

---

### Task 10: Feature-flag plumbing

**Files:**
- Modify: `F:\projects\ownerspecs\.env.example` (if present — check first) or note the var in `CLAUDE.md`'s env-var conventions if no `.env.example` exists.

**Interfaces:** none — this task just documents the flag; the reading side (`isSpecFactsEnabled`) already exists from Task 3.

- [ ] **Step 1: Check for `.env.example`**

Run: `Get-ChildItem F:\projects\ownerspecs\.env.example -ErrorAction SilentlyContinue` (PowerShell). If it exists, add a line:
```
# Feature flag: render document-first spec_facts/mass_homologations data (mig 579).
# Default OFF. Read at BUILD time by lib/specFacts.ts — flipping requires a rebuild
# (SSG pages read process.env at generateStaticParams/render time, not per-request).
USE_SPEC_FACTS=0
```
If no `.env.example` exists in this repo, skip creating one (don't introduce a new convention outside this plan's scope) and instead add the same explanation as a comment block at the top of `lib/specFacts.ts` (already partially present from Task 3 — extend it to mention build-time-only if not already clear).

- [ ] **Step 2: Confirm prod `.env.local` does NOT yet have the var** (so default-OFF is verified, not assumed)

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'grep -c USE_SPEC_FACTS /home/deploy/ownerspecs/.env.local || true'
```
Expected: `0`. `isSpecFactsEnabled()` returns `false` when the var is entirely absent (Task 3 test already covers this), so no action needed on prod until Task 14 explicitly turns it on.

- [ ] **Step 3: Commit** (only if `.env.example` was modified — this task may be a no-op commit-wise)

```bash
git add .env.example
git commit -m "docs(env): document USE_SPEC_FACTS feature flag (default off, build-time only)"
```

---

### Task 11: Enhance `/towing` (slice 1) — dual-read render behind the flag

**Files:**
- Modify: `F:\projects\ownerspecs\app\[brand]\[generation]\towing\page.tsx`

**Interfaces:**
- Consumes: `isSpecFactsEnabled`, `getVerifiedMasses`, `summarizeAllMassKinds`, `hasEnoughVerifiedData` (`@/lib/specFacts`); `massKindLabel`, `massKindCategory` (`@/lib/labels`); `buildCitationIndex` (`@/lib/citations`, replacing `getSourcesFor`); `ProvenanceBadge` (`@/components/ProvenanceBadge`); `vehicleMassJsonLd` (`@/lib/seo`).

This is the one task in the plan that is a page-render change, not a pure-function change — no automated test (Next.js page components in this codebase have no test harness; RSC + DB make it impractical here). Verified by Task 12 (local dual-build diff) and Task 14 (prod smoke test).

- [ ] **Step 1: Swap the Sources plumbing from `getSourcesFor` to `buildCitationIndex`**

Replace:
```ts
const sources = await getSourcesFor(gen.id, "trims");
```
with (renderedRows must reflect exactly what's rendered — legacy trims rows now, verified mass rows added in Step 2):
```ts
const renderedRows: Array<{ table: string; id: number }> = trims.map((t) => ({ table: "trims", id: t.id }));
```
…and build the citation index AFTER the verified-masses fetch (Step 2), once `renderedRows` is complete, then use `citations.sources` in place of `sources` and drop the now-unused `getSourcesFor` import (keep `reviewDate` — it still operates on a `SourceRow[]`, unchanged signature).

- [ ] **Step 2: Fetch + summarize verified masses, extend the render-gate**

```ts
import { isSpecFactsEnabled, getVerifiedMasses, summarizeAllMassKinds, hasEnoughVerifiedData } from "@/lib/specFacts";
import { massKindLabel, massKindCategory } from "@/lib/labels";
import { buildCitationIndex } from "@/lib/citations";
import { ProvenanceBadge } from "@/components/ProvenanceBadge";
import { vehicleMassJsonLd } from "@/lib/seo";

// ... inside Page(), after the existing `trims` query:

const specFactsOn = isSpecFactsEnabled();
const massRows = specFactsOn ? await getVerifiedMasses(gen.id) : [];
const massSummaries = summarizeAllMassKinds(massRows);
const hasVerifiedMasses = specFactsOn && hasEnoughVerifiedData(massSummaries);

if (!hasVerifiedMasses) {
  console.info(`[towing] suppressing verified-masses section for gen ${gen.id}: specFactsOn=${specFactsOn} datapoints=${massSummaries.length}`);
}

// CHANGED gate — was `if (trims.length === 0) notFound();`
if (trims.length === 0 && !hasVerifiedMasses) notFound();

const renderedRows: Array<{ table: string; id: number }> = [
  ...trims.map((t) => ({ table: "trims", id: t.id })),
  ...(hasVerifiedMasses ? massRows.filter((r) => massSummaries.some((s) => s.rowIds.includes(r.id))).map((r) => ({ table: "mass_homologations", id: r.id })) : []),
];
const citations = await buildCitationIndex(gen.id, renderedRows);
const sources = citations.sources; // drop-in replacement for the old getSourcesFor result
```

- [ ] **Step 3: Render the verified-masses section** — insert a new `<section>` directly after the existing `pagehead`/`GenerationTabs` block, before the legacy headline-capacity `<section>` (verified data outranks legacy in reading order, matching "verified wins"):

```tsx
{hasVerifiedMasses && (
  <section style={{ marginTop: "var(--s-5)" }}>
    <h2 className="section-h">
      Verified · EU type-approval masses
      <span className="count">{massSummaries.length} datapoints</span>
    </h2>
    <div className="table-scroll">
      <table className="spec-table">
        <thead>
          <tr><th>Mass</th><th>Value</th><th>Provenance</th></tr>
        </thead>
        <tbody>
          {massSummaries
            .filter((s) => massKindCategory(s.kind) !== "tax_only") // guardrail: tax_only kinds never render in this table
            .map((s) => (
              <tr key={s.kind}>
                <th>{massKindLabel(s.kind)}</th>
                <td>
                  {s.isRange
                    ? `${s.min.toLocaleString()}–${s.max.toLocaleString()} kg (varies by homologated variant)`
                    : `${Math.round((s.min + s.max) / 2).toLocaleString()} kg`}
                </td>
                <td>
                  <ProvenanceBadge kind="verified" citationNums={citations.citationsFor("mass_homologations", s.rowIds[0])} />
                </td>
              </tr>
            ))}
        </tbody>
      </table>
    </div>
    {trims.length === 0 && (
      <p className="soft" style={{ marginTop: 8, fontSize: 13 }}>
        No marketed-trim breakdown is catalogued yet for this generation — figures above are
        EU type-approval values verified directly against RDW registration data, independent of trim.
      </p>
    )}
  </section>
)}
```

- [ ] **Step 4: Emit the mass JSON-LD** (headline `running_order` value only, additive to the existing `faqLd` script tag):

```tsx
{hasVerifiedMasses && massSummaries.find((s) => massKindCategory(s.kind) === "headline") && (
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{
      __html: JSON.stringify(
        vehicleMassJsonLd({
          path: `/${make.slug}/${gen.slug}/towing`,
          massKg: Math.round(
            (massSummaries.find((s) => massKindCategory(s.kind) === "headline")!.min +
              massSummaries.find((s) => massKindCategory(s.kind) === "headline")!.max) / 2,
          ),
          reviewDate: reviewDate(sources),
        }),
      ),
    }}
  />
)}
```

- [ ] **Step 5: Add a FAQ entry** (guarded, additive to the existing `faqs` array before `faqJsonLd(faqs)` is built):

```ts
if (hasVerifiedMasses) {
  const headline = massSummaries.find((s) => massKindCategory(s.kind) === "headline");
  if (headline) {
    faqs.push({
      q: `What is the EU type-approval mass of the ${make.name} ${gen.display_name}?`,
      a: `Mass in running order (EU type-approval, CoC §13) is ${headline.isRange ? `between ${headline.min} and ${headline.max} kg depending on homologated variant` : `${headline.min} kg`}, verified directly against RDW open registration data.`,
    });
  }
}
```

- [ ] **Step 6: Label the legacy section explicitly when both exist** — when `trims.length > 0` AND `hasVerifiedMasses`, add a small heading note above the existing "Per-trim ratings" table: `<span className="soft" style={{fontSize:12}}>Catalogue data — legacy, not yet cross-checked against a primary document</span>` immediately under the `<h2 className="section-h">Per-trim ratings ...</h2>` line, plus a `<ProvenanceBadge kind="legacy" />` per row in that table (small addition to the existing `.map((t) => ...)`). This is the only gen-type slice 1 doesn't exercise (Rio has 0 trims) but must not be left unhandled — a future gen may have both.

- [ ] **Step 7: Commit**

```bash
git add "app/[brand]/[generation]/towing/page.tsx"
git commit -m "feat(towing): dual-read verified EU type-approval masses behind USE_SPEC_FACTS, legacy trims as labelled fallback"
```

---

### Task 12: Deploy safety — `distDir` override + parallel-build/atomic-swap script

**Files:**
- Modify: `F:\projects\ownerspecs\next.config.ts`
- Create: `F:\projects\ownerspecs\scripts\deploy-atomic.sh`
- Modify: `F:\projects\ownerspecs\CLAUDE.md` (deploy section)

**Interfaces:**
- `next.config.ts`: `distDir: process.env.NEXT_DIST_DIR || ".next"`.
- `scripts/deploy-atomic.sh`: a bash script that runs ON THE VPS (not local — this project has no CI runner; matches existing deploy pattern of scp'ing files then ssh'ing a build command).

No unit tests for a bash ops script in this repo's convention (no CI, no bash test harness). Verified by a live dry run in Task 13/14 with tight-interval curl monitoring across the swap moment.

- [ ] **Step 1: Add `distDir` to `next.config.ts`**

```ts
const nextConfig: NextConfig = {
  // Overridable so a build can target a parallel directory for the atomic-swap
  // deploy (scripts/deploy-atomic.sh) without ever touching the live `.next`
  // the running pm2 process reads from mid-build. Default unchanged so `npm
  // run build` locally / in any context that doesn't set the var behaves
  // exactly as before.
  distDir: process.env.NEXT_DIST_DIR || ".next",
  async redirects() {
    /* ...unchanged... */
  },
};
```

- [ ] **Step 2: Write the deploy script**

```bash
#!/usr/bin/env bash
# scripts/deploy-atomic.sh — parallel-build + atomic-swap deploy for ownerspecs.
# Run ON THE VPS (ssh in, or ssh '... bash /home/deploy/ownerspecs/scripts/deploy-atomic.sh').
#
# Replaces `rm -rf .next && npm run build && pm2 restart os` as the default deploy
# path. That sequence causes ~4min of live 500s because `.next` is genuinely
# absent between the rm and the build finishing (CLAUDE.md deploy-quirks section).
# This script never removes `.next` — it builds into whichever of two real
# directories (.next-blue / .next-green) is NOT the current symlink target,
# then repoints the `.next` symlink with a single atomic rename.
#
# Prerequisite (one-time, see plan Task 13): `.next` must already be a symlink
# to `.next-blue` or `.next-green`, not a real directory.
set -euo pipefail
cd /home/deploy/ownerspecs

LOCK=/tmp/ownerspecs-deploy.lock
exec 9>"$LOCK"
if ! flock -n 9; then
  echo "ERROR: another deploy is already running (lock $LOCK held). Not starting a second one." >&2
  exit 1
fi

if [ ! -L .next ]; then
  echo "ERROR: .next is not a symlink. Run the one-time bootstrap (plan Task 13) first." >&2
  exit 1
fi

CURRENT=$(readlink .next)          # e.g. ".next-blue"
if [ "$CURRENT" = ".next-blue" ]; then TARGET=".next-green"; else TARGET=".next-blue"; fi

echo "Building into $TARGET (current live: $CURRENT)..."
set -a; source .env.local; set +a
NEXT_DIST_DIR="$TARGET" npm run build 2>&1 | tee /tmp/ownerspecs-build.log
if ! grep -q "Compiled successfully" /tmp/ownerspecs-build.log; then
  echo "ERROR: build did not report success — see /tmp/ownerspecs-build.log. Aborting swap, live site untouched." >&2
  exit 1
fi
if grep -qiE "error|Type error" /tmp/ownerspecs-build.log; then
  echo "ERROR: build log contains 'error' — see /tmp/ownerspecs-build.log. Aborting swap, live site untouched." >&2
  exit 1
fi

echo "Build OK. Sanity-checking $TARGET has a BUILD_ID..."
test -f "$TARGET/BUILD_ID" || { echo "ERROR: $TARGET/BUILD_ID missing — build looks incomplete."; exit 1; }

echo "Atomic swap: .next -> $TARGET"
ln -sfn "$TARGET" .next.tmp
mv -T .next.tmp .next     # single rename() syscall — no window where .next is missing

echo "Restarting pm2 to pick up new server code..."
pm2 restart os --update-env

sleep 2
echo "Post-swap healthcheck..."
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3004/)
if [ "$CODE" != "200" ]; then
  echo "ERROR: homepage returned $CODE after swap. Rolling back to $CURRENT." >&2
  ln -sfn "$CURRENT" .next.tmp
  mv -T .next.tmp .next
  pm2 restart os --update-env
  exit 1
fi

echo "Deploy OK. Live on $TARGET. Previous build ($CURRENT) left in place for instant rollback:"
echo "  ln -sfn $CURRENT .next.tmp && mv -T .next.tmp .next && pm2 restart os --update-env"
```

- [ ] **Step 3: Update `CLAUDE.md`'s deploy section** — add a new subsection ABOVE the existing "Deploy after a code change (canonical incantation)" block:

```markdown
## Zero-downtime deploy (preferred — use this, not rm -rf .next)

`.next` is a symlink to `.next-blue` or `.next-green` (bootstrapped once, see memory
`reference_atomic_deploy_bootstrap` / plan `2026-09-24-render-layer-dual-moat.md` Task 13).
Deploy by scp'ing changed files, then:
\`\`\`bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy bash /home/deploy/ownerspecs/scripts/deploy-atomic.sh'
\`\`\`
This builds into the inactive color, verifies BUILD_ID + a post-swap homepage 200,
and swaps `.next` with a single atomic rename — the live pm2 process never sees
`.next` missing, so there is no multi-minute 500 window. Takes a lock (`/tmp/ownerspecs-deploy.lock`)
so a second concurrent invocation fails fast instead of racing. Rollback: the script
prints the exact 3-line command to swap back to the previous color instantly (no rebuild).

The OLD `rm -rf .next && npm run build && pm2 restart os` incantation below is kept
as the emergency full-rebuild fallback (e.g. if the blue/green layout itself gets
corrupted) — prefer the atomic script for all routine deploys.
```

(Leave the existing "canonical incantation" block below it, header changed to "Emergency full rebuild fallback" — don't delete institutional knowledge, relabel it.)

- [ ] **Step 4: Commit**

```bash
git add next.config.ts scripts/deploy-atomic.sh CLAUDE.md
git commit -m "feat(deploy): parallel-build + atomic-swap deploy script, retire rm -rf .next as the default path"
```

---

### Task 13: One-time bootstrap of the blue/green `.next` symlink layout on the VPS

**Files:** none (VPS filesystem operation only).

This is the one moment that still carries a small window of risk (same class as the old `rm -rf`, but a single `mv` — microseconds, not minutes) and must be done deliberately, once, before `scripts/deploy-atomic.sh` can be used.

- [ ] **Step 1: Confirm current state**

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'ls -ld /home/deploy/ownerspecs/.next'
```
Expected: a real directory, not a symlink (per Ground Truth section — confirmed 2026-09-24).

- [ ] **Step 2: Bootstrap** (off-peak; the risk window here is a single `mv` — sub-millisecond on the same filesystem, but do it deliberately anyway)

```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy bash -c "
cd /home/deploy/ownerspecs
mv .next .next-blue
ln -s .next-blue .next
"'
```

- [ ] **Step 3: Verify zero regression immediately**

```
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:3004/; ls -ld /home/deploy/ownerspecs/.next'
```
Expected: `200`, and `.next` shown as a symlink (`lrwxrwxrwx ... .next -> .next-blue`). If the homepage does NOT return 200, immediately `mv .next .next-symlink-broken; mv .next-blue .next` to revert to the pre-bootstrap state (pm2 doesn't even need a restart for this revert since it never restarted — `next start` was serving the same inode the whole time through the symlink).

- [ ] **Step 4: No commit** (VPS-only filesystem change, nothing to commit locally — note the completed bootstrap in project memory once done, per this project's convention of recording VPS-only state drift).

---

### Task 14: Local dual-build verification (flag OFF vs ON) before touching prod

**Files:** none (verification only — run against a local checkout with a tunnel or against a scratch copy; DB reads are safe/read-only either way).

**Goal:** prove, without touching prod, that (a) `USE_SPEC_FACTS=0` produces a build byte-identical in behavior to pre-plan (Kia Rio towing still 404s, every other gen's `/towing` unchanged) and (b) `USE_SPEC_FACTS=1` produces the new Rio page with no regressions elsewhere.

- [ ] **Step 1: Build with the flag OFF**

```powershell
cd F:\projects\ownerspecs
$env:USE_SPEC_FACTS = "0"
npm run build 2>&1 | Select-String "error","Compiled" | Select-Object -Last 20
Test-Path ".next\server\app\kia\rio-yb-hatchback-2018-2023\towing.html"   # expect: False (still 404s)
Remove-Item Env:\USE_SPEC_FACTS
```
Expected: build succeeds, Rio towing page absent (consistent with the pre-plan 404 — `trims.length===0 && !hasVerifiedMasses` still triggers `notFound()` because `hasVerifiedMasses` is false when the flag is off, regardless of the now-approved DB rows).

- [ ] **Step 2: Build with the flag ON**

```powershell
cd F:\projects\ownerspecs
Remove-Item -Recurse -Force .next
$env:USE_SPEC_FACTS = "1"
npm run build 2>&1 | Select-String "error","Compiled" | Select-Object -Last 20
Test-Path ".next\server\app\kia\rio-yb-hatchback-2018-2023\towing.html"   # expect: True
Get-Content ".next\server\app\kia\rio-yb-hatchback-2018-2023\towing.html" | Select-String "Verified","RDW Open Data","1160|1155|1160"
Remove-Item Env:\USE_SPEC_FACTS
```
Expected: page exists, contains "Verified · EU type-approval masses", the citation text "RDW Open Data (CC0)", and mass values in the 1155–1160 / 1600–1620 / etc. ranges confirmed in Task 7.

- [ ] **Step 3: Spot-check zero regression on 2–3 unrelated gens** — pick one gen with existing `/towing` trims data (e.g. a Ford F-150 gen) and confirm its rendered HTML is unchanged from a pre-Task-11 build (the `buildCitationIndex` swap from `getSourcesFor` must not alter its Sources block — this is what Task 5 Step 5 already partially verified for the citations refactor in isolation; this step re-confirms it end-to-end through the actual page).

- [ ] **Step 4: No commit** (verification only, nothing to commit — local `.next` output isn't tracked).

---

### Task 15: Deploy slice 1 to prod, flip the flag, smoke-test

**Files:** none (ops task).

- [ ] **Step 1: Deploy all slice-1 code with the flag still OFF** (zero-risk — proves the atomic deploy script itself works before combining it with a behavior change)

```bash
scp -i ~/.ssh/autodtcs_key next.config.ts root@72.62.154.119:/tmp/next.config.ts
scp -i ~/.ssh/autodtcs_key "lib/specFacts.ts" "lib/citations.ts" "lib/labels.ts" "lib/seo.ts" "lib/generation.ts" root@72.62.154.119:/tmp/
scp -i ~/.ssh/autodtcs_key "components/ProvenanceBadge.tsx" root@72.62.154.119:/tmp/
scp -i ~/.ssh/autodtcs_key "app/[brand]/[generation]/towing/page.tsx" root@72.62.154.119:/tmp/towing_page.tsx
scp -i ~/.ssh/autodtcs_key app/globals.css root@72.62.154.119:/tmp/
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy bash -c "
install -m 644 /tmp/next.config.ts /home/deploy/ownerspecs/next.config.ts
install -m 644 /tmp/specFacts.ts /tmp/citations.ts /tmp/labels.ts /tmp/seo.ts /tmp/generation.ts /home/deploy/ownerspecs/lib/
install -m 644 /tmp/ProvenanceBadge.tsx /home/deploy/ownerspecs/components/
install -m 644 /tmp/towing_page.tsx \"/home/deploy/ownerspecs/app/[brand]/[generation]/towing/page.tsx\"
install -m 644 /tmp/globals.css /home/deploy/ownerspecs/app/
mkdir -p /home/deploy/ownerspecs/scripts
"'
scp -i ~/.ssh/autodtcs_key scripts/deploy-atomic.sh root@72.62.154.119:/tmp/
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy install -m 755 /tmp/deploy-atomic.sh /home/deploy/ownerspecs/scripts/deploy-atomic.sh'
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy bash /home/deploy/ownerspecs/scripts/deploy-atomic.sh'
```

- [ ] **Step 2: Smoke-test flag-OFF deploy**

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing   # expect 404
curl -s -o /dev/null -w "%{http_code}\n" https://ownerspecs.com/                                          # expect 200
curl -s https://ownerspecs.com/honda/civic-sedan-x-2016-2021/towing | grep -c "spec-table"                # expect unchanged from pre-deploy (>0)
```

- [ ] **Step 3: Flip the flag and redeploy**

```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 "sudo -u deploy bash -c 'grep -q USE_SPEC_FACTS /home/deploy/ownerspecs/.env.local || echo USE_SPEC_FACTS=1 >> /home/deploy/ownerspecs/.env.local'"
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy bash /home/deploy/ownerspecs/scripts/deploy-atomic.sh'
```

- [ ] **Step 4: Smoke-test flag-ON deploy**

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing   # expect 200 now
curl -s https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing | grep -c "Verified"                 # expect >0
curl -s https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing | grep -o "RDW Open Data[^<]*"       # expect the citation text
curl -s https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing | grep -ioE "haynespro|workshopdata|mitchell|techadvisor|elsawin|alldata|autodata|auto-data|ultimatespecs" # expect NO matches — vendor-leak grep
curl -s -o /dev/null -w "%{http_code}\n" https://ownerspecs.com/honda/civic-sedan-x-2016-2021/towing     # expect 200, unchanged
```

- [ ] **Step 5: Document the kill switch** — record in project memory (new entry, e.g. `feedback_spec_facts_kill_switch.md`) exactly how to roll back:
  - **Fast (seconds, no rebuild):** if the NEW BUILD itself is broken (crashes, missing assets): `ssh ... 'sudo -u deploy bash -c "cd /home/deploy/ownerspecs && ln -sfn .next-blue .next.tmp && mv -T .next.tmp .next && pm2 restart os --update-env"'` (swap back to whichever color was live before — check `readlink .next` first if unsure which is which).
  - **Flag-based (minutes, one rebuild):** if the build is fine but the verified-mass DATA/LOGIC is wrong: remove/set `USE_SPEC_FACTS=0` in `.env.local`, run `scripts/deploy-atomic.sh` again. Safe to run anytime — the atomic swap means this rebuild causes no live 500s even though it takes ~4 min.

- [ ] **Step 6: No further commit** (deploy is an ops action; the memory-file note is written via the normal memory-write flow, not this plan).

---

### Task 16 (later — not deep-specced here): Slice 2 — F-150 `spec_facts` on existing topic pages, legacy fallback merge

**Scope note:** deliberately left as a stub per the ask ("Slice 2 as a later task") — this needs its own short spec before implementation because it introduces the harder problem slice 1 avoided: a real per-field merge between `spec_facts` (new, engine/vehicle_type-scoped) and legacy `fluid_specs`/`torque_specs`/`electrical_specs` (old, engine-scoped) on a generation that has BOTH. Do not start coding this from the bullets below without writing that follow-up spec first.

- [ ] Design a `fact_type.code` → legacy-table-and-column mapping (e.g. `engine_oil_capacity` → `fluid_specs` where `fluid_type LIKE 'engine_oil%'`, `capacity_l`) so a page can ask "for this (generation, engine), is there an approved `spec_facts` row for X; if not, fall back to the legacy row" — per-field, not per-page.
- [ ] Extend the render pattern from Task 11 (provenance badge, `hasEnoughVerifiedData` gate, `buildCitationIndex`'s already-generalized document lane) to whichever F-150 topic page(s) get spec_facts coverage first (oil-capacity is the natural pilot — smallest table, well-understood legacy shape).
- [ ] Explicitly handle the case Task 11 avoided: a value present in BOTH tables that DISAGREE (e.g. the memory-recorded F-150 coolant-capacity error) — verified must win, legacy must render as struck-through/labelled-superseded rather than silently dropped, per "labelled fallback" (not "delete legacy").
- [ ] QA-approve the relevant F-150 `spec_facts` rows via a migration (same pattern as Task 7), with F-150-specific verification criteria (this gen has NO CoC-gold cross-check available — Moat A has no CoC equivalent; criteria must instead be "matches the source OEM manual PDF, pulled and read directly" per `feedback_om_citation_not_verification.md`).
- [ ] Repeat the local dual-build verification (Task 14 pattern) and the deploy+smoke-test (Task 15 pattern) for this slice.

---

## Self-Review

**Legacy fallback (panel decision 1):** Task 11 Step 2's render-gate (`trims.length === 0 && !hasVerifiedMasses`) and Step 6 (explicit "Catalogue data — legacy" labelling + per-row `ProvenanceBadge` when both legacy and verified data exist) implement per-field verified-wins with labelled fallback for slice 1's actual shape (0 legacy trims for Rio) AND the general case (a future gen with both). Task 16 explicitly carries forward the harder same-field-disagreement case slice 1 didn't need to solve.

**Feature flag (panel decision 4 / Global Constraints):** `isSpecFactsEnabled()` (Task 3) is the single read point; strict `"1"` equality (not truthy-string) to avoid an accidental flip via a stray env value; documented as build-time-only (Task 10, Task 11 comment, Task 14's dual-build verification) rather than falsely presented as an instant runtime toggle — this was a real gap in the original ask's "kill-switch = flip the flag off" framing that the plan corrects with the actual SSG constraint, while still delivering a genuine kill switch via the atomic-swap rebuild being safe to run anytime.

**Deploy safety (panel decision 4):** Task 12 replaces `rm -rf .next` with a `distDir`-parameterized parallel build + single-rename atomic swap (Task 12), a one-time symlink bootstrap (Task 13) that acknowledges its own small residual risk window rather than hand-waving it, a lock file preventing concurrent builds (enforced in the script, not just documented discipline), a post-swap healthcheck with automatic rollback in the script itself, and a documented instant-rollback path independent of the feature flag (swap the symlink back, no rebuild). CLAUDE.md is updated (Task 12 Step 3) to make the new path the default and demote the old incantation to "emergency fallback" rather than deleting institutional knowledge.

**Citation extension (panel decision 3):** Task 5 first extracts the existing numbering logic into a pure, regression-tested function (protects the ~15,000 existing SSG pages from a silent behavior change) BEFORE Task 6 adds the new `documents`-table lane. The ID-space collision between `sources.id` and `documents.id` (both auto-increment from 1) is caught and tested explicitly (Task 5's "does not collide" test) — this was a real correctness bug the naive "just extend the allow-list" framing in the ask would have introduced if implemented literally, since the new tables don't route through `spec_sources` at all (direct `source_document_id` FK). `qa_state='approved'` filtering happens at the SQL level in Task 6's `documentRows` query, not as a post-filter — pending/rejected facts can never reach `mergeAndNumberSources` in the first place.

**Slice-1 scope (panel decision 2):** Grounded against the live DB rather than assumed — confirmed 0 legacy trims (genuinely no reconciliation conflict), the real 7-value `mass_kind` vocabulary (differs from the mig 579 schema comment — code is written against the real values), and the exact CoC-gold row used to justify Task 7's QA approval. The 40 kg range-collapse veto (design doc risk table) is implemented as a pure, tested function (`summarizeMassKind`) rather than a page-level ad hoc check, so slice 2 and any future mass-rendering page reuse it for free.

**Verification task:** Task 14 (local dual-build diff, zero prod risk) precedes Task 15 (prod deploy). Task 15 deploys with the flag OFF first as a dry run of the deploy mechanism alone, THEN flips the flag as a separate, individually-smoke-tested step — isolating "did the deploy script work" from "does the new feature work," so a failure localizes to one or the other rather than both at once.

**Placeholder scan:** no task contains an unresolved `TODO` in its code steps; Task 16 is explicitly and intentionally a stub (scoped out by the ask itself: "as a later task"), not a placeholder masquerading as complete.

**Open questions for whoever executes this plan:**
1. Task 11 Step 3's mass-value display for a non-range summary averages `(min+max)/2` when `n>1` but `!isRange` (e.g. the Rio's 1155–1160 `running_order` values) — worth a product call on whether "1158 kg" (averaged) or "up to 1,160 kg" (max) reads better to a visitor; the plan picked averaging as the more literally-honest choice but this is a UX judgment call, not a correctness one.
2. Whether `mass_homologations` rows should eventually carry a `market_id`-aware query in `getVerifiedMasses` (currently ungated by market) — deferred because the Kia Rio's 80 rows are single-market; flagged so slice 2+ doesn't silently inherit an unscoped query once multi-market data lands.
