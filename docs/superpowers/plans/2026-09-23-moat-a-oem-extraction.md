# Moat A — OEM Owner-Manual/FSM Extraction: Tracer Bullet + Repeatable Workflow

> **For agentic workers:** REQUIRED SUB-SKILL: use superpowers:executing-plans (recommended, since most tasks are sequential and each depends on data verified in the previous one) to work this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. This is plan **4 of 5** in the global dual-moat decomposition (`docs/superpowers/specs/2026-09-23-global-dual-moat-design.md` §8) — it does **not** touch the render layer (that is plan 5).

**Goal:** Prove the full data pipeline from a real Ford OEM owner manual into the applied document-first schema (migration 579) by extracting a small set of high-confidence Moat-A facts for one popular US model — the **Ford F-150 (P702, 2021-2025)** — as `documents` + `spec_facts` rows that are individually verified against the source PDF and promoted to `qa_state='approved'`. Then generalize that recipe into a repeatable extraction workflow and an ordered scale-out batch for the next US/global models. **No live page, no deploy, no render-layer change** — this plan stops at approved, cited `spec_facts` rows sitting in the prod DB, ready for plan 5 to render.

**Why F-150 first:** the P702 generation is already cataloged in the DB (`generations` row seeded in mig 018), its engine-dedupe was already run (mig 122/478 — verify, don't assume, since this plan may run long after that work), and the OEM manuals are **already downloaded locally** (`manuals/ford_2021…F-150…pdf` through `manuals/ford_2025_Ford_F150_P702_OM_ENGLISH_V1.pdf`, harvested by `scripts/crawl_ford_us.py`, manufacturer-owned domain `fordservicecontent.com` → `public_link=1` eligible). That means this tracer bullet tests the *extraction and schema* step in isolation, with the *sourcing* step already solved — the cleanest possible slice.

**Architecture (data flow):**

```
manuals/ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf   (already on F:\, local-canonical)
  │  scripts/convert_manuals.py --only <pdf>
  ▼
manuals/<same>.md   (pymupdf4llm, <!--PAGE n--> markers)
  │  scripts/detect_sections.py --only <same>.md --write-db
  ▼
manual_inventory row (VPS DB) with section_map {fluids, torques, maintenance, fuses, bulbs, tire_pressures, specifications: [page ranges]}
  │  scripts/manual_query.py show <manual> <topic>          (read-only lookup, no schema writes)
  ▼
hand/agent extraction of individual facts, cross-checked against the actual page text
  │  one migration: INSERT INTO documents (...) ; INSERT INTO spec_facts (...) qa_state='pending'
  ▼
prod DB `ownerspecs`: documents row (citation, public_link=1, storage_path) + spec_facts rows (engine-scoped or gen-wide, source_document_id, market_id)
  │  verification pass: re-open the cited page, confirm value+unit match
  ▼
spec_facts.qa_state = 'approved'  ← STOPS HERE. Rendering is plan 5's job.
```

**Tech stack:** existing Python pipeline (`scripts/convert_manuals.py`, `scripts/detect_sections.py`, `scripts/manual_query.py`) unchanged — no new scripts required for the tracer bullet itself. One new SQL migration (schema-additive `fact_types` rows + the F-150 tracer data). MariaDB on the VPS (`ownerspecs` prod DB) — this plan writes directly to prod via the existing `mariadb ownerspecs < /tmp/NNN.sql` deploy path, since `documents`/`spec_facts` are unread by the live Next.js app today (no build/deploy needed, no user-facing risk).

---

## Global Constraints

- **Facts only, never verbatim text or OEM diagrams.** US OEMs (Ford included) enforce manual/FSM copyright more aggressively than EU CoC/RDW authorities (dual-moat design §2). Every extracted value is a restated fact (a number + unit + qualifier), never a copied sentence or a scanned table image.
- **Every `documents` row and every `spec_facts` row traces to real, verified data.** `source_document_id` and `market_id` are `NOT NULL` in the schema — this plan never leaves them null, and never inserts a fact "and figures out the citation later."
- **An OM citation is a CLAIM, not proof ([[feedback_om_citation_not_verification]]).** No `spec_facts` row reaches `qa_state='approved'` without a verification step that re-opens the cited page and confirms the value+unit match what is printed. The CX-90 incident (citation attached, values wrong) is exactly the failure mode this gate exists to prevent.
- **Build ONLY from data actually in the manual ([[feedback_build_only_from_shared_data]]).** If the F-150 OM doesn't publish a spec (e.g. it defers tyre pressure to the door placard), leave it out — do not fill from training-data recall, even for well-known figures.
- **Engine-scoped vs gen-wide grain is mandatory, not optional.** `engine_oil_capacity`, `oil_viscosity`, `coolant_capacity`, `torque_spark_plug` etc. get `spec_facts.engine_id` set to the correct engine row for multi-engine gens (the F-150 P702 ships 2.7 EcoBoost / 3.5 EcoBoost / 5.0 Coyote V8 / 3.0 Power Stroke diesel across its run — do not write one oil-capacity row and apply it gen-wide). Chassis-shared facts (lug-nut torque, 12V battery group, most fuses) are gen-wide (`engine_id NULL`).
- **`public_link` gating:** `1` only for the manufacturer-owned domain (`fordservicecontent.com`) per [[reference_source_link_gating]]. If a gap requires falling back to an aggregator (ManualsLib, allcarmanuals) for a fact the Ford OM doesn't cover, that document row is `public_link=0` and is **never named** in any rendered column — see next point.
- **Never name a paid/3rd-party data vendor in any column that could ever render ([[feedback_never_name_data_vendor]]).** `documents.citation` must stay vendor-neutral ("Ford F-150 Owner's Manual (2024)"); `documents.source_label` is the one column explicitly designed to be internal-only (schema comment: "internal only; may name vendor") — use it for that, never `citation` or `notes`.
- **Do not deploy, build, or touch the render layer.** No edits to `app/**`, `lib/citations.ts`, or any topic page. No `npm run build`, no `pm2 restart`. This plan's deliverable is rows in the prod DB, verified by SQL `SELECT`, not a URL that returns 200.
- **Do not drop or rewrite the legacy spec tables** (`fluid_specs`, `torque_specs`, `bulbs`, `fuses`, `tire_pressures`, `service_intervals`) — mig 579 is additive-only and the legacy-table removal is a separate, later rollout step per the mig 579 header. The F-150 P702 gen already has legacy-schema moat data (migs 018, 072, 123, 156) — treat it as a **cross-reference pointer only, not ground truth** (per the OM-citation-is-not-proof rule, those rows may themselves be uncorrected lore that merely cites an OM). Re-derive every tracer-bullet value from the actual 2024 OM PDF; do not copy a legacy row's value forward just because the topic matches.
- **Two-source preference, honestly flagged when not met.** The moat's standing rule ([[feedback_two_source_rule]]) prefers ≥2 independent sources per value. The tracer bullet may ship with a single OM edition; where that's the case, say so explicitly (do not silently claim two-source compliance) and record the second-source gap as a follow-up, per the "OM cited 2-3 years apart to catch mid-cycle spec migrations" convention (CLAUDE.md).
- **Tooling:** run all `F:\...` invocations via the PowerShell tool (Bash strips backslashes). Migrations apply via `scp -i ~/.ssh/autodtcs_key <mig>.sql root@72.62.154.119:/tmp/ && ssh ... 'mariadb ownerspecs < /tmp/<mig>.sql'` (no `db/migrations/` dir exists on the VPS). Local manual conversion/indexing needs the port-**3307** tunnel (`ssh -i ~/.ssh/autodtcs_key -L 3307:127.0.0.1:3306 -N root@72.62.154.119 &`) — **not** the `.bat` script, which points at the old shared box.

---

### Task 1: Recon — confirm the F-150 P702 identity state before touching data

**Files:** none written; this is a read-only verification pass.

- [ ] **Step 1: Confirm the generation + make rows**
  Query prod: `SELECT g.id, g.slug, g.start_year, g.end_year, m.id AS make_id, m.name FROM generations g JOIN models mo ON mo.id=g.model_id JOIN makes m ON m.id=mo.make_id WHERE g.slug LIKE '%f-150-p702%';` — record `generation_id` and `make_id` (Ford) for use in every later INSERT.

- [ ] **Step 2: Confirm engine dedupe status**
  `SELECT id, code, slug, display_name, fuel FROM engines WHERE id IN (SELECT DISTINCT engine_id FROM trims WHERE generation_id = <f150_gen_id>) OR display_name LIKE '%EcoBoost%' OR display_name LIKE '%Coyote%' OR display_name LIKE '%Power Stroke%';` Confirm there is exactly **one** row per real engine (2.7 EcoBoost, 3.5 EcoBoost, 5.0 Coyote V8, 3.0 Power Stroke diesel, if present) — mig 122/478 already deduped this gen once, but re-verify rather than trust the historical note, since new trims may have been added since. If a shadow duplicate exists, stop and dedupe first (repoint `trims`/legacy fluid/torque/service/parts rows onto the survivor) using the mig 122 pattern before proceeding — do not build new `spec_facts` on top of an ambiguous engine identity.

- [ ] **Step 3: Inventory the legacy (pre-clean-start) F-150 moat rows as a cross-reference list only**
  Pull the existing `fluid_specs` / `torque_specs` / `bulbs` / `fuses` / `tire_pressures` rows for this gen (migs 018/072/123/156) into a side note: which topics already have *a* value on file. This is used in Task 5 purely to sanity-check magnitude (does the newly-extracted value look like the same ballpark, or is something mis-read) — never as the source of truth for the new row.

- [ ] **Step 4: Pick the canonical OM edition(s)**
  From the local inventory (`manuals/ford_2021…` through `manuals/ford_2025_Ford_F150_P702_OM_ENGLISH_V1.pdf`), select the **2024 edition** as primary (mid-cycle, stable, covers the full engine lineup) and the **2021 "version 1" edition** as the secondary/cross-check edition per the "cite 2-3 years apart" convention. Record exact filenames for Task 2.

---

### Task 2: Convert + index the two OM editions (on-demand pipeline, not bulk)

**Files:**
- Create (generated by tooling, not hand-written): `manuals/ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.md`, `manuals/ford_2021-Ford-F-150-Owners-Manual-version-2_om_EN-US_10_2021.md`
- Modifies: `manual_inventory` rows on the VPS DB (via `--write-db`)

- [ ] **Step 1:** `python scripts\convert_manuals.py --only ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf` then the same for the 2021 edition. Confirm both `.md` files exist alongside their PDFs with `<!--PAGE n-->` markers.
- [ ] **Step 2:** With the port-3307 tunnel up, `python scripts\detect_sections.py --only ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.md --write-db` (and the 2021 file). Confirm `section_map` populated for at least `fluids`, `torques` or `specifications`, `maintenance`, `bulbs`, `fuses`, `tire_pressures` — note any topic the detector missed (multilingual heuristic gaps happen; fall back to a manual page skim for that topic only).
- [ ] **Step 3:** `scp` both new `.md` files to `/home/deploy/ownerspecs/manuals/` on the VPS (the hot query layer).
- [ ] **Step 4:** From the VPS, `manual_query.py show <2024-manual> fluids`, `... torques`, `... maintenance`, `... bulbs`, `... fuses`, `... tire_pressures` — capture the raw page text for each topic. This raw text is the extraction source for Task 5; do not paraphrase it into the plan doc verbatim beyond what's needed to derive facts (Feist posture applies to our own working notes too — keep only the numbers/labels you'll cite, not full page dumps, in any committed artifact).

---

### Task 3: Extend the `fact_types` vocabulary (additive) — bulbs, fuses, tyre pressure are missing

**Files:**
- Create: `db/migrations/580_moat_a_fact_types_extension.sql`

Mig 579's seeded `fact_types` covers dimension/powertrain/emission/fluid/torque/electrical(battery only)/service(oil interval only) — it has **no codes for bulbs, fuses, or tyre pressure**, all three of which Moat A needs. This is expected (579 was scoped to the CoC/RDW wedge) and additive extension is explicitly anticipated by the 579 header ("CoC-specific tables may still get an additive follow-up (580)... the applied base is stable and additive").

- [ ] **Step 1:** Draft the additive `INSERT IGNORE INTO fact_types` block. Illustrative shape (finalize exact codes/units during Task 5 once the real OM units are known — Ford may publish PSI, not kPa):

  ```sql
  INSERT INTO fact_types (code, category, default_unit, value_kind) VALUES
    ('tire_pressure', 'chassis', 'kPa', 'num'),          -- qualifier: axle:1|2 (front|rear), load:normal|full
    ('bulb_spec', 'electrical', NULL, 'text'),           -- qualifier: position:low_beam|high_beam|front_turn|tail_stop|reverse|license_plate
    ('fuse_spec', 'electrical', 'A', 'num'),             -- qualifier: box:engine|cabin ; value_text carries the circuit label
    ('service_interval_tire_rotation', 'service', 'mi', 'num'),
    ('service_interval_brake_fluid', 'service', 'mi', 'num'),
    ('service_interval_spark_plug', 'service', 'mi', 'num'),
    ('service_interval_cabin_filter', 'service', 'mi', 'num')
  ON DUPLICATE KEY UPDATE category = VALUES(category);
  ```
  Reuse the existing qualifier convention documented in the mig 579 comment (`axle:1|2`, `condition:normal|severe`) rather than inventing a new vocabulary — front=`axle:1`, rear=`axle:2` matches the existing convention even though it's borrowed from the axle-count context.
- [ ] **Step 2:** Do not apply this migration standalone — fold it as the first block of the Task 5 tracer-bullet migration (one migration file, two logical sections: schema extension then data) so `fact_types` and their first consumers land atomically and reviewers see why each code was added.

---

### Task 4: Create the `documents` rows for both OM editions

**Files:** (part of the same migration as Task 5 — see Task 5 Step 1)

- [ ] **Step 1:** Confirm/derive the values needed for the `documents` INSERT: `file_sha256` (compute locally, e.g. `certutil -hashfile <pdf> SHA256` via PowerShell, or reuse the hash `detect_sections.py --write-db` already computed and stored on the `manual_inventory` row — pull it from there instead of re-hashing), `page_count` (same source), `original_url` (the `fordservicecontent.com` PDF URL — recoverable from `scripts/crawl_ford_us.py`'s naming convention or the crawler's own log/manifest if one exists; if not recorded, reconstruct via the crawler's URL pattern documented in its own header comment), `model_year` (2024 and 2021 respectively), `retrieved_at` (use the file's original download date if tracked, else `NOW()` with a note that retrieval predates this migration).
- [ ] **Step 2:** Confirm the `US` market row exists: `SELECT id FROM markets WHERE code='US';` (the `markets` table and its `US`/`EU`/`UK`/`JDM`/`AU`/`RoW` codes are a pre-existing convention from mig 001, not something this plan invents — if `US` is missing, `INSERT IGNORE INTO markets (code, name) VALUES ('US','United States');` as a one-line prerequisite, not a redesign).
- [ ] **Step 3:** Insert one `documents` row per edition. Template (fill placeholders from Steps 1-2 and Task 1's `generation_id`/`make_id`):

  ```sql
  INSERT INTO documents
    (doc_type, provenance_kind, generation_id, make_id, market_id,
     citation, source_label, original_url, public_link,
     storage_path, file_sha256, page_count, edition, model_year, retrieved_at, notes)
  VALUES
    ('owner_manual', 'oem_portal', @f150_gen, @ford_make, @us_market,
     'Ford F-150 Owner''s Manual (2024)', NULL, '<fordservicecontent.com PDF URL>', 1,
     'manuals/ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf', '<sha256>', <pages>,
     'version 1', 2024, '<retrieved date>', NULL);
  -- repeat for the 2021 edition
  ```
  Note `source_label` is left `NULL` here deliberately — there is no 3rd-party vendor to hide for a direct-OEM PDF; the column exists for the aggregator-fallback case, not this one.

---

### Task 5: Extract and insert the tracer-bullet `spec_facts` (pending)

**Files:**
- Create: `db/migrations/580_moat_a_f150_tracer_bullet.sql` (contains Task 3's fact_types block + Task 4's documents rows + this task's spec_facts rows, as one atomic migration)

**Fact set for the tracer bullet** (deliberately small — prove the pipeline, not exhaustive coverage):

| fact_type | grain | source page (2024 OM) | notes |
|---|---|---|---|
| `engine_oil_capacity` + `oil_viscosity` | per engine (2.7 EcoBoost, 3.5 EcoBoost, 5.0 Coyote — whichever the 2024 OM's capacities table lists) | `fluids`/`specifications` section | 3 engines × 2 facts = up to 6 rows |
| `coolant_capacity` | per engine if the OM publishes it per-engine, else flag gen-wide with a note in the plan (not in `notes` — `spec_facts` has no notes column; track the caveat in the migration's SQL comment) | same section | |
| `torque_lug_nut` | gen-wide (`engine_id NULL`) | `torques`/`specifications` | wheel/lug-nut torque is chassis-wide on the F-150 |
| `bulb_spec` × 4-6 | gen-wide | `bulbs` | low beam, high beam, front turn signal, tail/stop, reverse — whichever the OM's bulb table actually lists (skip any position that's LED-only-no-bulb-code, per the CX-90 LED lesson — don't invent a halogen code) |
| `fuse_spec` × 3-5 | gen-wide | `fuses` | pick the highest-value circuits per [[feedback_gen_completion_checklist]]'s "5 most-commonly-blown" guidance (radio, accessory power, headlights, A/C, IOD) — only if the OM's interior fuse panel legend covers them; the F-150 may defer full fuse tables to the FSM, in which case insert fewer and note the gap |
| `tire_pressure` × 2 | gen-wide (or per-trim if the OM varies by tyre/load) | `tire_pressures`/placard reference | front (`axle:1`) + rear (`axle:2`) at standard load; per [[reference_us_om_gaps]] many US OMs defer this to the door placard — if the F-150 OM does too, this fact type is legitimately empty for the tracer bullet and that's an honest finding, not a failure |

- [ ] **Step 1:** For each row, cross-check the raw page text captured in Task 2 Step 4 against the value before writing the INSERT — this is the extraction itself, not a separate step; do not write a value into the migration that you haven't already read off the actual page text.
- [ ] **Step 2:** Write every row with `qa_state='pending'`, `market_id=@us_market`, `source_document_id` = the 2024-edition `documents.id` from Task 4, `engine_id` set per the grain table above (NULL for gen-wide facts, the correct engine's `id` from Task 1 Step 2 for engine-scoped facts), `valid_from` = the OM's model-year start date (e.g. `'2023-06-01'` if that's when the 2024 MY OM took effect — use the edition's `model_year` as a reasonable proxy if an exact effective date isn't printed), `qualifier` set per the convention (e.g. `'position:low_beam'`, `'axle:1'`).
- [ ] **Step 3:** Where the 2021 edition confirms the *same* value (the two-source check), do not insert a duplicate `spec_facts` row — instead note the corroboration in the verification pass (Task 6) so the single `qa_state='approved'` row is backed by two documents having been checked, without double-counting facts. If the 2021 and 2024 editions **disagree** (a genuine mid-cycle spec revision, the exact scenario this convention exists to catch), insert **both** as separate rows with non-overlapping `valid_from`/`valid_to` — this is the versioning invariant (`valid_to IS NULL == current`) working as designed, not an error.
- [ ] **Step 4:** Apply the migration to prod: `scp` to `/tmp/580_...sql` on the VPS, then `ssh ... 'mariadb ownerspecs < /tmp/580_...sql'`. Confirm success with `SELECT COUNT(*) FROM spec_facts WHERE source_document_id IN (@doc_2024, @doc_2021);` matching the expected row count.

---

### Task 6: Verification pass — promote `pending` → `approved`

**Files:** none new; this is a `UPDATE spec_facts` step plus a short verification note kept in the migration's trailing SQL comment (not a separate doc).

- [ ] **Step 1:** For every `spec_facts` row inserted in Task 5, re-open the cited page (via `manual_query.py show <manual> <topic>` again, fresh, not from memory of Task 5's extraction) and confirm the value + unit printed matches the row exactly. This is the operational answer to [[feedback_om_citation_not_verification]] — the row already claims a citation; this step is what makes the claim true.
- [ ] **Step 2:** For any mismatch found, correct the `spec_facts` row (or delete it if the OM genuinely doesn't support the claimed value) **before** approving anything — never approve a row you know is wrong "to keep moving."
- [ ] **Step 3:** For rows that check out: `UPDATE spec_facts SET qa_state='approved', qa_by='<agent-or-name>', qa_at=NOW() WHERE id IN (...);`
- [ ] **Step 4:** Record the honest tally: how many of the tracer-bullet rows reached `approved` vs how many were dropped/corrected/left `pending` (e.g. because a second source never showed up). This tally is the deliverable that proves (or disproves) the pipeline — report it back to Tim rather than only reporting "done."

---

### Task 7: Render-readiness check (still no deploy)

**Files:** none — read-only queries only.

- [ ] **Step 1:** `SELECT COUNT(*) FROM spec_facts WHERE generation_id=@f150_gen AND qa_state='approved';` — confirm it clears the "≥3 cited datapoints" render-gate threshold the dual-moat design (§3a) specifies for plan 5's eventual publish rule. This is a sanity check that the tracer bullet, if plan 5 existed today, would actually be renderable — not an implementation of that gate.
- [ ] **Step 2:** Confirm (by reading, not editing) that `lib/citations.ts`'s `buildCitationIndex` allow-list does **not** yet include `documents`/`spec_facts` — this is expected and is explicitly plan 5's task per the dual-moat design §3a. Note it here so plan 5 doesn't have to rediscover it.
- [ ] **Step 3:** Do not run `npm run build`, do not `pm2 restart os`, do not touch any file under `app/`. The tracer bullet's success criterion is the `SELECT` in Step 1 returning ≥3, not a URL returning 200.

---

### Task 8: Generalize the extraction workflow (reference doc, not code)

**Files:**
- Create: `docs/superpowers/specs/2026-09-23-moat-a-extraction-workflow.md` (a short reference, distilled from Tasks 1-6, for reuse on every subsequent model)

- [ ] **Step 1:** Write the generalized per-(model, generation, manual) recipe as a table: `fact_type → OM section key (per detect_sections.py's 7 keys) → typical grain rule (engine-scoped vs gen-wide) → verification requirement`. This is the F-150 table above, generalized (remove F-150-specific page numbers, keep the section-key → grain-rule mapping, which is model-independent).
- [ ] **Step 2:** Capture the F-150-specific lesson explicitly: **before per-engine backfill on any multi-engine US pickup/SUV gen, re-run the shadow-engine dedupe check** (Task 1 Step 2's query pattern) — the CLAUDE.md note about F-150/Silverado/Tahoe/Escalade shadow engine rows is a recurring trap on this class of vehicle, not a one-time fix.
- [ ] **Step 3:** Capture the "legacy-schema rows are a pointer, not ground truth" lesson (Task 1 Step 3) as a standing instruction for every future gen that already has pre-clean-start `fluid_specs`/`torque_specs`/etc. rows.

---

### Task 9: Scale-out ordering — the next batch of US/global models

**Files:**
- Modify (append a section to): `docs/superpowers/specs/2026-09-23-moat-a-extraction-workflow.md`

- [ ] **Step 1:** Query the catalog for which high-search-volume US/global models already have a `generations` row (so Moat A extraction can start immediately) vs which don't (catalog creation is a separate, out-of-scope prerequisite — flag, don't block this plan on it):
  `SELECT mk.name, mo.name, g.slug, g.start_year, g.end_year FROM generations g JOIN models mo ON mo.id=g.model_id JOIN makes mk ON mk.id=mo.make_id WHERE mo.name IN ('F-150','Silverado','RAV4','Camry','Civic','CR-V','Ram 1500','Explorer','Grand Cherokee','Corolla','Accord','Tahoe','Escalade') ORDER BY mk.name, mo.name;`
- [ ] **Step 2:** For each candidate, mark **GO** (manual already crawled + gen cataloged) / **BLOCKED-portal** (US OEM login-walled, needs Playwright-per-gen or ManualsLib internal-only fallback per [[feedback_convert_on_demand_not_bulk]]) / **BLOCKED-catalog** (gen doesn't exist yet) using the existing manual-pipeline landscape:
  - **GO immediately:** F-150 (this plan), Silverado/Tahoe/GMC (GM US Solr portal, 1,379 PDFs already crawled), Ram 1500 (Mopar US, 694 PDFs already crawled).
  - **BLOCKED-portal (US direct-login, no clean equivalent):** Camry/Corolla/RAV4 (Toyota US walled — the `series-mapper` catalog endpoint helps enumerate but not fetch PDFs; per-gen Playwright or ManualsLib internal-only), Civic/CR-V/Accord (Honda US walled → `mygarage.honda.com`, same fallback), CX-5/other Mazda US (use the already-crawled **Mazda CA** OM as a same-language equivalent, `sources.notes` flagged "Canadian-market OM").
  - **BLOCKED-catalog:** anything not yet in `generations` — flag for a separate catalog-add pass, not this plan.
- [ ] **Step 3:** Produce the ordered table (priority = search-volume proxy × sourcing ease) as the closing section of the workflow doc. Suggested order: F-150 (done) → Silverado/Ram 1500 (GO, high volume, both crawled) → Grand Cherokee (Mopar, GO) → then re-assess Toyota/Honda once a per-gen Playwright recipe exists (their US search volume is highest but sourcing cost is also highest).

---

### Task 10: Dependency flag — Plan 5 owns render, and one open design question for it

**Files:** none — this is a note for the plan record, not an implementation step.

- [ ] **Step 1:** State explicitly (in the workflow doc's closing section) that Plan 4's output is `spec_facts` rows with `qa_state='approved'` — nothing more. Getting from there to a live, indexable URL requires plan 5: extending `buildCitationIndex`'s allow-list to `documents`/`spec_facts`, deciding the render home (existing `/[brand]/[generation]/[topic]` tree vs a new path), enforcing the render-gate (`notFound()` below N cited datapoints, not `noindex`), and the actual `npm run build` + deploy.
- [ ] **Step 2:** Flag one open question explicitly for plan 5, discovered by this plan: the F-150 P702 gen **already renders live topic pages today** from the legacy schema (`fluid_specs`/`torque_specs`/`bulbs`/`fuses` — migs 018/072/123/156). Plan 5 will need to decide whether Moat-A `spec_facts` **replace** those pages' data source, **supplement** them (both render, oldest/least-verified superseded), or **coexist** until a full legacy-to-document-first migration. Plan 4 deliberately does not answer this — it only surfaces it, per its own "no render layer" constraint.

---

## Self-Review

**Tracer bullet covered:** Tasks 1-7 take one real Ford OM PDF through convert → index → extract → insert → verify → approve, end to end, with an explicit engine-dedupe recon step (Task 1) and an explicit "legacy rows are not ground truth" guard (Task 1 Step 3) — both drawn from prior incidents in this exact codebase (mig 122 dedupe, the CX-90 citation-is-not-proof lesson).

**Provenance:** every `documents` and `spec_facts` row template in Tasks 4-5 carries `source_document_id`, `market_id`, `public_link` set deliberately, and (for engine-scoped facts) `engine_id` — matching the mig 579 invariants verbatim, not a paraphrase of them.

**QA gate:** Task 6 makes `pending → approved` a real re-verification against the source page, not a rubber stamp, and requires an honest tally rather than a blanket "done" — directly operationalizing [[feedback_om_citation_not_verification]] instead of merely citing it.

**Legal:** facts-only extraction is stated in Global Constraints and reiterated per-fact-type in Task 5's table (e.g. explicitly rejecting inventing a bulb code the OM doesn't list); vendor-neutrality and `public_link` gating are called out with the exact columns (`citation` vs `source_label`) that have leaked in past incidents on this project.

**Render dependency:** Task 10 states the boundary explicitly and surfaces one concrete open question (legacy-vs-document-first coexistence for F-150's already-live pages) for plan 5 to resolve, rather than silently deciding it here.

**Scope discipline:** this plan does not write a new crawler (Ford's already exists and has already downloaded the needed PDFs), does not redesign the schema (only an additive `fact_types` extension, explicitly anticipated by the mig 579 header), and does not touch the render layer (Task 7 is read-only verification that the data *would* clear plan 5's future gate, not an implementation of that gate).
