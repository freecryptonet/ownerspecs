# ownerspecs document-first schema — DRAFT for panel review (2026-09-23)

Implements the day-1 invariants from `CLEAN_START_PLAN_2026-09-04.md` §4.
This is a **draft**; the panel (Gemini + OpenAI + Grok) reviews it before any migration is written.

## Recap of the locked invariants (non-negotiable)

1. **Immutable canonical vehicle identity + URL**, mapped to EU type-approval: Make → Model → Generation → **Type/Variant/Version (TVV)**. Plus an **alias/kenteken lookup** layer (humans search trade names + registration, never TVV codes).
2. **Provenance NOT NULL** — `source_document_id` + `market_id` required on every fact row.
3. **Facts VERSIONED** — immutable rows + effective date; never overwritten in place.
4. **Inference PROHIBITED at the model level** — a fact with no `source_document` cannot exist.
5. (round-6) **Conflict-resolution policy** per market; **human QA sign-off gate** on fact rows before pipeline automation.

## What the primary documents actually give us (evidence base)

**Certificate of Conformity (CoC)** — the richest single doc. Real example (Kia Rio YB, VIN KNAD…656, NL-registered):

| CoC § | Field | Value | → maps to |
|---|---|---|---|
| 0.1 / 0.2 / variant / version | Make / Type / Variant / Version | KIA / YB / B5P11 / M61BZ1 | **TVV identity** |
| 0.2.1 | Commercial name | RIO | model alias |
| 0.4 | Category | M1 | vehicle_type.category |
| e-number | Type-approval | e11\*2007/46\*3777\*00 | type_approval |
| 0.10 | VIN | KNAD…656 | vehicle_instance (redacted) |
| 3 / 5 / 6 / 7 | wheelbase / L / W / H | 2580 / 4065 / 1725 / 1445 mm | dimension facts |
| 13 | mass in running order | 1160 kg | **mass fact (wedge)** |
| 16.1 / 16.2 / 16.4 | max laden / per-axle / max combo | 1620 / 945+840 / 2730 kg | mass facts (qualified) |
| 18.3 / 18.4 | towable centre-axle / unbraked | 1110 / 450 kg | **towing facts (wedge)** |
| 19 | max vertical coupling mass | 75 kg | towing fact |
| 21 / 25 / 26 / 27.1 | engine code / cc / fuel / power | G3LC / 998 / Gasoline / 88.3 kW | engine + power facts |
| 29 | max speed | 190 km/h | perf fact |
| 35 | tyre/wheel combo (primary) | 185/65R15 88H 6.0Jx15/ET46 (both axles) | **tyre homologation (wedge)** |
| 47 / 48 / 49 | Euro class / emissions / CO2+fuel | Euro 6 W / … / 107 g/km combined | emission facts |
| 52 | **Remarks — extra homologated combos + alt masses** | 195/55R16 87H 6.0Jx16/ET49; 205/45R17 88V 6.5Jx17/ET49; 13:1160; 30:track variants | **more tyre homologations + mass variants** |

Key structural takeaways:
- The **TVV (Type+Variant+Version)** is the finest homologation grain and is printed on every CoC — this is our immutable identity key.
- **§35 + §52 together yield MULTIPLE homologated tyre/wheel combos per vehicle** — the wedge is inherently multi-row, compound (size + load index + speed rating + rim width/dia + ET), per axle, and flagged primary vs optional. It deserves its own typed table.
- Masses are multi-valued and **qualified** (per-axle, per-trailer-type, alt values from §52).

**Other primary docs (from servicereset's `photo_library/` + ownerspecs `manuals/`):**
- First-party **component photos** keyed by kenteken (`HK-054-G/…`) and by component (`fuse_box`, `engine_id_plate`, `refrig_label`, `cluster`, `epb`, `obd_port`) — each is evidence for a spec (refrigerant label → AC charge; engine plate → engine code).
- **Owner / workshop manuals + FSM** — the existing `manuals/` corpus (PDF local, `.md` on VPS, `section_map` JSON) via crawlers (Mopar/Hyundai/Mazda CA/Nissan/GM/…). 2nd-layer moat (oil grade, intervals, torques).

---

## Proposed schema

### Layer A — Immutable identity (keep + extend existing)

Keep `makes`, `models`, `generations`, `markets` as-is (they're identity-grain, uncontaminated). **Add** the TVV leaf + alias + instance layers:

```sql
-- The EU type-approval leaf: the finest homologation identity. Facts from a CoC attach here.
CREATE TABLE vehicle_types (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  generation_id      INT UNSIGNED NOT NULL,          -- rolls up for SEO/routing
  category           VARCHAR(8)  NULL,               -- M1, N1…
  tvv_type           VARCHAR(32) NOT NULL,           -- 0.2  "YB"
  tvv_variant        VARCHAR(48) NULL,               -- "B5P11"
  tvv_version        VARCHAR(48) NULL,               -- "M61BZ1"
  type_approval_no   VARCHAR(64) NULL,               -- "e11*2007/46*3777*00"
  approval_market_id SMALLINT UNSIGNED NULL,         -- where approved
  engine_id          INT UNSIGNED NULL,              -- resolved engine (code G3LC)
  commercial_label   VARCHAR(160) NULL,              -- "Rio 1.0 T-GDi" as marketed
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_tvv (type_approval_no, tvv_type, tvv_variant, tvv_version),
  KEY ix_vt_gen (generation_id),
  CONSTRAINT fk_vt_gen FOREIGN KEY (generation_id) REFERENCES generations(id)
);

-- Alias/kenteken lookup so humans find the car by trade name or registration, not TVV code.
CREATE TABLE vehicle_aliases (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alias_kind      VARCHAR(16) NOT NULL,   -- 'trade_name' | 'kenteken_pattern' | 'sales_code'
  alias_text      VARCHAR(160) NOT NULL,  -- "Golf 8 1.5 eTSI R-Line" / plate-derived key
  generation_id   INT UNSIGNED NULL,
  vehicle_type_id INT UNSIGNED NULL,
  KEY ix_alias_text (alias_text),
  CONSTRAINT fk_alias_gen FOREIGN KEY (generation_id) REFERENCES generations(id),
  CONSTRAINT fk_alias_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id)
);

-- The real registered car a document describes. VIN redacted; internal audit only, never published.
CREATE TABLE vehicle_instances (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  vehicle_type_id    INT UNSIGNED NULL,
  vin_sha256         CHAR(64) NULL,        -- hashed, never store/print raw VIN
  vin_masked         VARCHAR(20) NULL,     -- "KNAD…656" for internal disambiguation
  market_id          SMALLINT UNSIGNED NULL,
  first_registration DATE NULL,
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_vi_vt FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id)
);
```

### Layer B — Documents (the provenance root; invariants 2 + 4)

Unifies CoC, type/VIN plate, owner/workshop manual, FSM, TSB, refrigerant label, component photo, OEM portal page.

```sql
CREATE TABLE documents (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  doc_type          VARCHAR(24) NOT NULL,   -- coc|type_plate|vin_plate|owner_manual|workshop_manual|fsm|tsb|refrigerant_label|component_photo|oem_portal|other
  -- subject (nullable — a manual is model/gen-wide; a CoC is instance/TVV-specific)
  vehicle_instance_id INT UNSIGNED NULL,
  vehicle_type_id   INT UNSIGNED NULL,
  generation_id     INT UNSIGNED NULL,
  make_id           INT UNSIGNED NULL,
  market_id         SMALLINT UNSIGNED NULL, -- CoC is market-registered
  -- provenance
  provenance_kind   VARCHAR(20) NOT NULL,   -- first_party_photo|first_party_scan|oem_portal|aggregator|other
  issuing_authority VARCHAR(128) NULL,      -- "KMC", approval authority
  citation          VARCHAR(255) NOT NULL,  -- vendor-neutral display string
  source_label      VARCHAR(64)  NULL,      -- internal, may name vendor
  original_url      VARCHAR(512) NULL,
  public_link       TINYINT(1) NOT NULL DEFAULT 0,  -- link-gating (OEM/NHTSA/EPA only = 1)
  -- storage
  storage_path      VARCHAR(512) NULL,      -- F:\…\*.pdf / *.md / photo path
  file_sha256       CHAR(64) NULL,
  page_count        SMALLINT UNSIGNED NULL,
  -- edition / effectivity
  edition           VARCHAR(64) NULL,
  model_year        SMALLINT UNSIGNED NULL,
  effective_date    DATE NULL,              -- issue/approval date
  retrieved_at      DATETIME NOT NULL,
  notes             VARCHAR(512) NULL,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_doc_type (doc_type),
  KEY ix_doc_vt (vehicle_type_id),
  KEY ix_doc_gen (generation_id),
  CONSTRAINT fk_doc_vi  FOREIGN KEY (vehicle_instance_id) REFERENCES vehicle_instances(id),
  CONSTRAINT fk_doc_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id),
  CONSTRAINT fk_doc_gen FOREIGN KEY (generation_id) REFERENCES generations(id)
);
```

### Layer C — Facts (invariants 2 + 3 + 4)

**Proposal: hybrid.** A unified `spec_facts` for scalar specs (the long tail) + one typed table for the wedge structure that is inherently compound & multi-row.

```sql
-- Controlled vocabulary of fact types (replaces scattered enum strings; label lives in lib/labels.ts).
CREATE TABLE fact_types (
  id            SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code          VARCHAR(48) NOT NULL UNIQUE,   -- 'mass_running_order','mass_max_laden','tow_braked','engine_oil_capacity','oil_viscosity','co2_combined'…
  category      VARCHAR(24) NOT NULL,          -- 'mass','towing','dimension','fluid','torque','emission','electrical','performance','service'
  default_unit  VARCHAR(16) NULL,              -- 'kg','mm','l','Nm','g/km'
  value_kind    VARCHAR(8)  NOT NULL           -- 'num' | 'text'
);

CREATE TABLE spec_facts (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  -- scope: always rolls up to a generation for routing; narrow with vehicle_type/engine when known
  generation_id      INT UNSIGNED NOT NULL,
  vehicle_type_id    INT UNSIGNED NULL,        -- set when the fact is TVV-specific (from a CoC)
  engine_id          INT UNSIGNED NULL,        -- set when engine-specific (from a manual)
  fact_type_id       SMALLINT UNSIGNED NOT NULL,
  qualifier          VARCHAR(48) NULL,         -- 'axle:1','trailer:centre_axle','condition:severe','circuit:cooling'
  value_num          DECIMAL(12,3) NULL,
  value_text         VARCHAR(255) NULL,
  unit               VARCHAR(16) NULL,
  -- provenance (invariants 2 & 4) — NOT NULL
  market_id          SMALLINT UNSIGNED NOT NULL,   -- GLOBAL sentinel market for true physical constants
  source_document_id INT UNSIGNED NOT NULL,
  -- versioning (invariant 3)
  effective_from     DATE NOT NULL,
  supersedes_id      INT UNSIGNED NULL,
  is_current         TINYINT(1) NOT NULL DEFAULT 1,
  -- QA gate (round-6)
  extracted_by       VARCHAR(32) NULL,         -- 'claude' | operator id
  verified_by        VARCHAR(32) NULL,         -- human sign-off; NULL = not yet cleared
  verified_at        DATETIME NULL,
  conflict_group     INT UNSIGNED NULL,        -- ties rows that disagree for the same (scope,fact_type,market)
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_sf_scope (generation_id, fact_type_id, market_id, is_current),
  KEY ix_sf_vt (vehicle_type_id),
  CONSTRAINT fk_sf_gen  FOREIGN KEY (generation_id) REFERENCES generations(id),
  CONSTRAINT fk_sf_vt   FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id),
  CONSTRAINT fk_sf_ft   FOREIGN KEY (fact_type_id) REFERENCES fact_types(id),
  CONSTRAINT fk_sf_mkt  FOREIGN KEY (market_id) REFERENCES markets(id),
  CONSTRAINT fk_sf_doc  FOREIGN KEY (source_document_id) REFERENCES documents(id),
  CONSTRAINT fk_sf_sup  FOREIGN KEY (supersedes_id) REFERENCES spec_facts(id)
);

-- THE WEDGE — inherently compound + multi-row per vehicle (CoC §35 + every §52 remark combo).
CREATE TABLE tyre_homologations (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  vehicle_type_id    INT UNSIGNED NOT NULL,
  generation_id      INT UNSIGNED NOT NULL,       -- for routing
  market_id          SMALLINT UNSIGNED NOT NULL,
  axle               VARCHAR(8) NOT NULL DEFAULT 'both',  -- 'front'|'rear'|'both'|'1'|'2'
  is_primary         TINYINT(1) NOT NULL,         -- §35 = primary; §52 remark = optional
  tyre_size          VARCHAR(32) NOT NULL,        -- '185/65R15'
  load_index         VARCHAR(8)  NULL,            -- '88'
  speed_rating       VARCHAR(4)  NULL,            -- 'H'
  rim                VARCHAR(24) NULL,            -- '6.0Jx15'
  et_mm              SMALLINT NULL,               -- 46
  conditions         VARCHAR(255) NULL,           -- §52 conditional note e.g. "not with Electronic Parking Brake"
  source_document_id INT UNSIGNED NOT NULL,
  effective_from     DATE NOT NULL,
  is_current         TINYINT(1) NOT NULL DEFAULT 1,
  verified_by        VARCHAR(32) NULL,
  KEY ix_th_scope (generation_id, market_id, is_current),
  KEY ix_th_vt (vehicle_type_id),
  CONSTRAINT fk_th_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id),
  CONSTRAINT fk_th_gen FOREIGN KEY (generation_id) REFERENCES generations(id),
  CONSTRAINT fk_th_mkt FOREIGN KEY (market_id) REFERENCES markets(id),
  CONSTRAINT fk_th_doc FOREIGN KEY (source_document_id) REFERENCES documents(id)
);
```

### Layer D — Images (first-party photo moat)

Keep `images`, add `document_id` FK so an evidence photo (refrigerant label, engine plate) is both a rendered gallery image AND a citable document.

### Conflict resolution (round-6)

- A **`source_priority`** rank per (doc_type, market): CoC/type-plate > OEM workshop manual > OEM owner manual > FSM > aggregator.
- When two `is_current` facts share (scope, fact_type, market), the higher-priority document's fact renders; the loser stays (immutable) with `is_current=0` and a shared `conflict_group`. UI can show "sources disagree" where it matters.

### Migration/rollout stance

- **New tables are additive.** The old contaminated spec tables (`fluid_specs`, `torque_specs`, …) are NOT migrated into `spec_facts` — they're wiped per the clean-start plan. The render layer switches to reading `spec_facts` + `tyre_homologations` + `vehicle_types`.
- 410 the ~15k old pages only AFTER the NL wedge cluster is live (plan §5).

---

## Open questions for the panel

1. **Fact storage: hybrid (unified `spec_facts` + typed `tyre_homologations`) vs. fully typed tables vs. fully EAV?** Is the hybrid the right cut, or should masses/towing/emissions also get typed tables? Where's the line?
2. **Scope modelling:** three nullable FKs (generation/vehicle_type/engine) with generation NOT NULL for routing — acceptable, or model scope as (subject_kind, subject_id)? Trade-off: FK integrity vs flexibility.
3. **`market_id` NOT NULL with a GLOBAL sentinel** for physical constants — clean, or a footgun? Alternative: nullable market_id = global (the old convention).
4. **Versioning:** immutable rows + `effective_from` + `supersedes_id` + `is_current` flag — sufficient? Or full bitemporal (valid_from/valid_to + tx time)? Is `is_current` denormalization worth the update cost vs. computing latest at query time?
5. **VIN handling:** hash + masked tail in an internal-only `vehicle_instances` — enough for GDPR/Feist posture, or drop raw VIN entirely and keep only the TVV link?
6. **TVV uniqueness:** is `(type_approval_no, type, variant, version)` a safe natural key, given approval numbers get extensions (…\*00, …\*01) across facelifts? Should the extension be a separate column?
7. **Kenteken lookup:** derive kenteken→TVV from RDW open data at query time (don't store individuals' plates) vs. a stored `vehicle_aliases` mapping — privacy + freshness trade-off.
8. **QA gate:** is a `verified_by`/`verified_at` pair on each fact + a "render only verified" switch the right mechanism, or should unverified facts live in a separate staging table entirely?
9. **Raw-capture layer:** should we store a verbatim structured capture of each CoC (a `document_fields` table: CoC field number `13`/`35`/`52`, raw multilingual label, raw value string) as immutable ground-truth **from which `spec_facts` are derived** — strengthening invariant 4 (no inferred facts) and giving an audit trail for the tokenized §52 remarks? Or is the transcribed `.md` artifact (referenced by `documents.storage_path`) sufficient, parsing straight into facts? Trade-off: audit rigor + re-parseability vs. table sprawl.

Note: §49 ships **both NEDC and WLTP** tables on newer CoCs → represented as `spec_facts` rows distinguished by `qualifier='cycle:nedc'` vs `'cycle:wltp'` (and phase: low/medium/high/extra_high/combined).

---

## REVISED DECISIONS (post-panel, 2026-09-23) — this section is authoritative for the migration

Panel (Gemini + OpenAI + Grok, `--synthesize`) = **conditional approve**. The hybrid cut (thin `spec_facts` + typed wedge tables) is endorsed by all three. Four day-1 traps must be fixed before the migration; wedge gets a second typed table; a raw-capture layer is added.

### Panel answers to the 9 open questions (resolved)
1. **Fact storage** → HYBRID confirmed, and **extend it**: masses/towing get their OWN typed table too (`mass_homologations`), not `spec_facts` qualifiers. `spec_facts` keeps only true scalars (dimensions, emissions, engine attributes, fluids, torques, service). Compound multi-row wedge never goes in EAV.
2. **Scope** → three nullable FKs with `generation_id` NOT NULL for routing: KEEP. (No subject_kind/subject_id polymorphism — FK integrity wins.)
3. **market_id NOT NULL + GLOBAL sentinel** → KEEP (NOT NULL enforces invariant 2). Physical constants use the GLOBAL market row.
4. **Versioning** → `valid_from` + `valid_to` (NULL = current) + `supersedes_id` + `change_set_id`. Drop the `is_current` boolean; "current" = `valid_to IS NULL`. (Bitemporal-lite; full tx-time deferred.)
5. **VIN** → hash + masked tail in internal-only `vehicle_instances`: KEEP (GDPR/Feist-safe). Never publish.
6. **TVV uniqueness** → **FIXED (trap T2):** natural key = `(generation_id, tvv_type, tvv_variant, tvv_version)`, all NOT NULL (empty string, not NULL, for absent variant/version so MariaDB UNIQUE holds). Approval number is an **attribute**, split into `approval_base` (`e11*2007/46*3777`) + `approval_extension` (`00`) — extensions change across facelifts while the TVV is stable, so they must not be in the key.
7. **Kenteken lookup** → derive kenteken→TVV from **RDW open data at query time**; do NOT store individuals' plates. `vehicle_aliases` holds trade-name + sales-code mappings only. **Product truth (Gemini blind-spot):** RDW does NOT record §52 alternate tyre combos, so the kenteken tool covers only the primary combo — **physical CoC ingest stays mandatory for the full wedge.**
8. **QA gate** → `qa_state` ENUM('pending','approved','rejected') + `qa_by` + `qa_at` on every fact table; render only `approved`. (Preferred over a separate staging table.)
9. **Raw-capture layer** → **YES (trap T4):** add `document_fields` — verbatim CoC field capture (`coc_field_no`, `raw_label`, `raw_value`, `page_no`, `source_span`). Every `spec_facts`/`tyre_homologations`/`mass_homologations` row references its originating `document_field_id`. This is the ground truth invariant 4 demands and gives §52 remarks a court/QA-defensible trace.

### Day-1 traps fixed
- **T1 — engine is a FACT, not identity.** REMOVE `engine_id` from `vehicle_types`. The engine code (CoC §21 "G3LC") is a `spec_facts` row (`fact_type='engine_code'`) with its own `source_document_id`; the `engines` entity is resolved from that verified fact, never stored bare on the identity row (that would be an inferred fact — invariant 4 violation).
- **T2 — TVV key** (see Q6 above).
- **T3 — `vehicle_aliases` needs `market_id`.** Trade names are market-scoped ("Rio" trims differ NL vs UK).
- **T4 — §52 traceability** (see Q9 raw-capture above).

### Source-authority ranking (decided BEFORE ingest — panel blind-spot)
`source_priority` (highest → lowest), used by conflict resolution when two `approved`, currently-valid facts collide on (scope, fact_type, market):
`CoC / type-plate (100) > OEM workshop manual (80) > OEM owner manual (70) > FSM (60) > aggregator (30) > RDW-derived (20)`.
Loser rows stay immutable (`valid_to` set, shared `conflict_group`); the winner renders.

### Gap-check against all 8 CoCs (2026-09-23) — applied to migration 579

The schema was overfit to the Kia Rio baseline. Validating against the other 7 (2 more diesels, an EV-framework Sportage on `e4*2018/858`, a fully-Dutch Mazda, an axle-keyed Nissan) surfaced fixes, now **folded into mig 579**:

- **et_mm → DECIMAL(5,1)** — Sportage §35 *primary* combo is `ET43.5`; SMALLINT would truncate a real value. (was a hard blocker)
- **`fact_types` seeded** — an empty vocab FK-blocks every `spec_facts` insert; mig 579 now seeds the full CoC + core-manual vocabulary. (was a hard blocker)
- **`mass_kind='actual_mass'`** added (CoC §13.2 — present on 7/8; the Rio lacked it, hence the miss).
- **`spec_facts.is_primary`** added — §52 also sanctions *alternate scalars* (height §7, axle track §30, power §27.1), not only tyres/masses. Premise "§52 = tyres+masses only" was wrong.
- **`tyre_homologations.rrc_class` + `tyre_co2_category`** added (§35 per-combo homologation attrs).
- **`vehicle_instances.manufacture_date`** (§0.11) + **`vehicle_types.approval_note`** (prior-approval lineage) added.

Confirmed non-issues: no staggered tyres in the 8 (front/rear headroom unused but kept); >3 combos fine (Tucson = 6 rows); fractional rims (`16x6 1/2J`) kept verbatim in `rim`; framework-year variety (`2001/116`, `2007/46`, `2018/858`) absorbed by `approval_base`.

**Pipeline task (NOT a schema blocker): §52 has ≥3 dialects.** Hyundai/Kia use `field:value*` tokens; Mazda is free prose ("… and … as option" + advisory text); Nissan is an axle-keyed mini-table with an extra equipment flag; Toyota's §52 is empty. `document_fields.raw_value` (TEXT) captures all verbatim, but the extraction/derivation step needs a **per-brand §52 parser** or the wedge won't populate from Mazda/Nissan. Owned by the extraction pipeline (build-order step 2), not this migration.

**Verdict after fixes: GO.** The identity/provenance/versioning core held across all 8; the failures were one column type, the empty vocab, and the oversimplified §52 model — all resolved.

## Two-lane wedge (panel-endorsed, 2026-09-23) — DECIDED

Panel (Gemini + OpenAI + Grok, `--synthesize`) = **unanimous: adopt a two-lane wedge.** Pure CoC-first (~50 cars) cannot hit the ≥100 clicks/day kill-switch in 6 months; RDW gives breadth, CoC gives un-copyable depth.

- **RDW lane (breadth):** NL national registration authority's open data — per-VIN/per-type masses & towing for the whole NL fleet, free, official. Ingested as `documents` with `doc_type='rdw_open'`, `provenance_kind='official_open_data'`, `source_priority=90`. **Prototype-validated coverage (2026-09-23):** running-order/kerb/max/technical-max mass, towing braked+unbraked, train weight (all per-VIN modal, `m9d7-ebf2`), per-axle max load + track width + driven/steered/braked flags (per-type, `xhyb-w7xt`), dimensions/top-speed (per-type, `byxc-wwua`). **RDW does NOT provide, so these stay CoC-only (the moat):** (1) tyre/wheel homologation §35/§52 (confirmed 3×); (2) **tow-ball load / kogeldruk §19 — populated on only 2 of 2.8M M1 rows in RDW `byxc-wwua`.** So the CoC-exclusive layer is now TWO fields: tyres + kogeldruk.
- **CoC lane (depth):** homologated tyre/wheel combos §35/§52 — the unique layer nobody (not even RDW) publishes. `source_priority=100`.

**Guardrails (moat holds IFF all three, per panel Q2):**
1. **Tyres stay CoC-only.** RDW never sources a tyre fact.
2. **No competitor-catalog scraping** — ever (Feist posture unchanged).
3. **Per-fact provenance is labelled** in the UI: "RDW registered" vs "CoC §35/§52 homologation". Never blur which lane a value came from.

**Thin-content rule (panel Q3 — mandatory):** NEVER ship masses-only URLs. One canonical model/generation page carries RDW masses + CoC tyres where present + a visible "tyres: awaiting CoC" state. True stubs get `noindex`. Lanes join on one URL or the page isn't published. (Consistent with the clean-start "one canonical page + per-market overrides" rule.)

**Biggest risk (all three panelists) — RDW data pollution + wrong type-approval↔model joins.** RDW is full of importer administrative errors (e.g. towing mass wrongly 0 kg on parallel imports); a wrong join puts the wrong mass on the wrong car. Either destroys "verified" authority faster than any volume shortfall — "you miss the gate on quality, not volume."
→ **Validation/outlier detection is day-1 mandatory, not later:**
  - Cross-check every RDW fact against the cohort min/median/max ranges in kentekenfeiten `content\modellen\*.json`; a value outside range → `qa_state='flagged'` (a 4th documented state alongside pending/approved/rejected; VARCHAR(10) already holds it), routed to a human review queue. Render only `approved`.
  - The type-approval↔model join uses the curated `curatie\generatie-curatie.tsv` mapping, not a naive base-only match (one approval base spans many engines/variants).

**Conflict-resolution UX (panel Q4 blind-spot) — to design:** when RDW and CoC disagree on a mass for the same (TVV, market), keep BOTH rows (shared `conflict_group`, loser `valid_to` set) and render both labelled — for a NL owner the RDW *registered* value is legally leading, so it shows prominently, with the CoC homologation value shown alongside. Do NOT silently pick one.

**Bootstrap now (panel Q5 = yes):** port `euTypeApproval.ts` (from vindecoder's orphaned worktree — 30 country codes + 5 directive eras) into the identity layer, and seed `vehicle_aliases`/identity from the 2,600 curated mappings — feature-flagged, right after the schema is applied. Not premature; identity unlocks both lanes.

## TVV identity grain — CORRECTED on real RDW data (panel, 2026-09-23)

The RDW masses-lane prototype produced real data that **corrects the earlier T2/Q6 decision** ("approval number is an attribute, NOT in the key"). Panel-unanimous revision:

**Validation first (it works):** cross-check of the held Kia Rio CoC (`e11*2007/46*3777*00` / B5P11 / M61BZ1) against 27,790 NL-registered Rios → the exact TVV (n=200) matches the CoC on **all 5 masses, delta 0**; the modal+agreement guard caught 1 corrupt RDW row (tow-braked 1620 vs 1110, 259:1). RDW = CoC on the exact TVV, and pollution detection works.

**Finding A — the approval EXTENSION carries spec meaning.** Same variant+version `F5P41/M52AZ1` under `*04` → 1104 kg running-order vs `*06` → 1127 kg. So (type, variant, version) alone is NOT unique for masses.
→ **`vehicle_types` key is now `(approval_base, approval_extension, tvv_variant, tvv_version)`** — the extension is IN the key. (Migration 579 updated.)

**Finding B — same variant, multiple market approval numbers.** `B5P11` is NL-registered under `e11*…*3777` (UK), `e5*…*1077` (SE), `e4*…*1299` (NL).
→ Each `(full-approval, variant, version)` = a distinct `vehicle_type`; a `market_twin_key` (normalized `variant|version`) GROUPS them for market-delta display. **CoC↔RDW join = full approval + variant + version; fallback (variant, version) ONLY with a market-flag + confidence — never silently merge across e-countries** (that's the biggest risk: wrong-spec published on a wrong-approval merge).

**Publishing grain (panel Q3):** NOT one page per TVV (228 TVVs for one Rio generation → thin-content penalty). Publish at **marketed trim / engine (variant) level**: hero = the dominant TVV (with n + agreement), a mass **range** across sibling TVVs beneath it, and an expandable per-TVV table; a kenteken/TVV selector surfaces the exact per-car value. ~10 pages/generation, non-thin AND accurate.

**Fact-selection rule (panel Q4):** per TVV, take the **modal** mass over all NL VINs + store the **agreement ratio**; publish only when **n ≥ 10 AND agreement ≥ 0.80**, else `qa_state='flagged'` (unverified). Don't blindly include imports where origin is separable. (Prototype `scripts/rdw_masses_prototype.py` implements this.)

**Known gap (panel blind-spot): parallel imports.** Imported/individually-approved vehicles often carry an incomplete TVV in RDW (empty variant/uitvoering) → they fall outside the strict key, yet used-car buyers need them most. Handle with a per-generation catch-all bucket + explicit "individually approved / TVV incomplete" state; do not force-merge them into a real TVV.

## Clustering RDW TVVs → marketed trims at scale (panel, 2026-09-23)

Breadth test (VW Golf VII, NL 2012–2020): 147,928 cars → **5,397 distinct TVVs**; 2,142 publishable (n≥10 & agree≥0.80) covering 91% of the fleet; long tail (<10 VINs) = 60% of TVVs but only 9% of fleet; incomplete-TVV/import bucket ≈1%. Can't publish 2,142 pages → cluster to ~10–15 marketed trims. Panel ruling:

- **Clustering key:** primary = **motorcode + transmission + body (`inrichting`)**; fallback = **displacement + power + fuel + transmission + body** when motorcode is missing. Require an exact motorcode match before merging. (Reject: variant-code prefix — too messy for VW; cc/power-only — merges different masses; mass-signature — circular.) Motorcode from RDW `4by9-ammk`; transmission from `7rjk-eycs`; power/fuel from `8ys7-d773`.
- **Mass-span VETO (the biggest-risk guardrail):** if within a proposed cluster `max(mass) − min(mass) > 40 kg`, do NOT publish a single trim mass — split further (by build-period/model-year) or fall back to per-TVV. Silent wrong-merges from per-brand motorcode conventions are the #1 risk.
- **Presentation:** hero = the dominant TVV's modal mass (+ n, agreement, % coverage); beneath it an explicit **min–max range labelled as spread** ("1235–1340 kg depending on options"), never as an estimate; always an expandable per-TVV table + a kenteken/VIN lookup that returns the exact per-car value. Range + exact-lookup together preserve the document-verified promise.
- **Long tail (<10 VINs):** not indexable as own pages; reachable via kenteken/VIN lookup + the per-TVV table; folded into a cluster only if motorcode+transmission+body match AND within the 40 kg veto.
- **Incomplete-TVV / import bucket:** a per-generation "individually imported / type-approval incomplete" section, excluded from trim pages and the index, reachable via kenteken lookup with an explanation. Never inside a cluster range.
- **Facelift/year blind spot:** the same motorcode can gain mass across a facelift / the WLTP-2018 cutover → add build-period/model-year as a split signal whenever the 40 kg veto trips.
- **Data-quality precondition:** before trusting this at scale, audit RDW motorcode + transmission completeness per brand/year (transmission `7rjk-eycs` is often empty/miscoded on imports and early years).

### Net table list for the migration
Identity: **keep** `makes` `models` `generations` `markets`; **add** `vehicle_types` (no engine_id, fixed key), `vehicle_aliases` (+market_id), `vehicle_instances`.
Provenance: **add** `documents`, `document_fields` (raw capture).
Facts: **add** `fact_types`, `spec_facts` (valid_from/valid_to/change_set/qa), `tyre_homologations`, `mass_homologations`. Add `source_priority` lookup.
Media: **keep** `images` (+ `document_id` FK).
**Wipe** (clean-start): the contaminated old spec tables (`fluid_specs`, `torque_specs`, `parts`, `bulbs`, `fuses`, `electrical_specs`, `service_intervals`, `tire_pressures`, `procedures`, `sources`, `spec_sources`) — but only per the plan's rollout order (410 old pages AFTER the NL wedge cluster is live).

## Provenance tiers to model (confirmed from servicereset)

`documents.provenance_kind` must cover three distinct legal/attribution regimes:
1. **first_party_photo** — Tim's own car photos (plate-blur mandatory, source folder named by kenteken, no third-party attribution).
2. **oem_document** (first_party_scan / oem_portal) — CoC PDFs, owner/workshop manuals, FSM. Facts-only extraction, vendor-neutral citation, `public_link` per link-gating policy.
3. **wikimedia_stock** — exterior tiles; **mandatory** author + licence + source string (CC BY / BY-SA), rendered as a visible credit.
