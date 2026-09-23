-- ⚠️⚠️  DO NOT APPLY YET — awaits Plan 2 (RDW-lane productionization).  ⚠️⚠️
-- NOT applied to the prod DB as of 2026-09-23. Do NOT run this against `ownerspecs`
-- until the RDW/CoC ingest is ready; a final CoC gap-check (Tim's next batch) may still
-- adjust it. Any "run all new *.sql" deploy step MUST skip this file until then.
--
-- ownerspecs.com · document-first schema · migration 579 · 2026-09-23
-- Implements CLEAN_START_PLAN_2026-09-04 §4 day-1 invariants + panel-reviewed
-- decisions in SCHEMA_DESIGN_2026-09-23.md (REVISED DECISIONS section is authoritative).
--
-- ADDITIVE ONLY. Does NOT drop the contaminated legacy spec tables — that happens
-- later in the rollout (410 old pages only AFTER the NL wedge cluster is live).
--
-- Invariants enforced here:
--   1. Immutable TVV identity, key excludes mutable facts (engine) + approval extension.
--   2. Provenance NOT NULL: source_document_id + market_id on every fact row.
--   3. Facts versioned: valid_from/valid_to (NULL=current) + supersedes_id + change_set_id.
--   4. No inferred facts: every fact traces to a document_field (raw capture).
--   5. Conflict resolution via source_priority; human QA via qa_state.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 0. GLOBAL market sentinel (for true physical constants; market_id is NOT NULL on facts)
-- ===================================================================
INSERT INTO markets (code, name) VALUES ('GLOBAL', 'Global (market-independent)')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ===================================================================
-- 1. IDENTITY — TVV leaf + alias + instance (extends existing makes/models/generations)
-- ===================================================================

-- The EU type-approval leaf. FINEST identity = full approval (base+EXTENSION) + variant + version.
-- Panel-corrected 2026-09-23 on real RDW data: same variant+version under different approval
-- EXTENSIONS carry different masses (F5P41/M52AZ1 = 1104 kg under *04 vs 1127 kg under *06) →
-- the extension IS part of the key. Key excludes engine (a fact, §21). RDW field mapping:
-- tvv_type=`type`, tvv_variant=`variant`/codevarianttgk, tvv_version=`uitvoering`/codeuitvoeringtgk.
CREATE TABLE IF NOT EXISTS vehicle_types (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id      INT UNSIGNED NOT NULL,           -- resolved via approval_base→gen alias; rolls up for routing
  category           VARCHAR(8)  NULL,                -- 0.4  M1, N1…
  approval_base      VARCHAR(64) NOT NULL DEFAULT '', -- "e11*2007/46*3777" (in key)
  approval_extension VARCHAR(8)  NOT NULL DEFAULT '', -- "00".."20" (IN KEY — carries spec revisions)
  tvv_type           VARCHAR(32) NOT NULL DEFAULT '', -- 0.2  "YB"
  tvv_variant        VARCHAR(48) NOT NULL DEFAULT '', -- "B5P11"
  tvv_version        VARCHAR(48) NOT NULL DEFAULT '', -- "M61BZ1"
  -- groups the SAME car approved under different e-country numbers (e11-UK/e5-SE/e4-NL) for
  -- market-delta display — a GROUPING key only; NEVER silently merge across e-countries.
  market_twin_key    VARCHAR(112) NOT NULL DEFAULT '',-- normalized "variant|version"
  approval_note      VARCHAR(255) NULL,               -- prior-approval lineage (i20 GB §52)
  approval_market_id SMALLINT UNSIGNED NULL,          -- e-country of the approval (e11=UK, e4=NL…)
  commercial_label   VARCHAR(160) NULL,               -- "Rio 1.0 T-GDi" as marketed
  created_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_tvv (approval_base, approval_extension, tvv_variant, tvv_version),
  KEY ix_vt_gen (generation_id),
  KEY ix_vt_twin (market_twin_key),
  CONSTRAINT fk_vt_gen FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE RESTRICT,
  CONSTRAINT fk_vt_appmkt FOREIGN KEY (approval_market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Alias/lookup so humans find the car by trade name / sales code (NOT by TVV code).
-- Kenteken -> TVV is derived from RDW open data at query time, NOT stored here (privacy).
CREATE TABLE IF NOT EXISTS vehicle_aliases (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  alias_kind      VARCHAR(16)  NOT NULL,              -- 'trade_name' | 'sales_code'
  alias_text      VARCHAR(160) NOT NULL,             -- "Golf 8 1.5 eTSI R-Line"
  market_id       SMALLINT UNSIGNED NULL,            -- trade names are market-scoped (T3 fix)
  generation_id   INT UNSIGNED NULL,
  vehicle_type_id INT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY ix_alias_text (alias_text),
  KEY ix_alias_gen (generation_id),
  CONSTRAINT fk_alias_mkt FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT,
  CONSTRAINT fk_alias_gen FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_alias_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- The real registered car a document describes. Internal audit only; VIN redacted, never published.
CREATE TABLE IF NOT EXISTS vehicle_instances (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
  vehicle_type_id    INT UNSIGNED NULL,
  vin_sha256         CHAR(64) NULL,                  -- hashed; never store/print raw VIN
  vin_masked         VARCHAR(20) NULL,              -- "KNAD…656" for internal disambiguation
  market_id          SMALLINT UNSIGNED NULL,
  first_registration DATE NULL,
  manufacture_date   DATE NULL,                      -- §0.11 date of manufacture (Sportage, i20 BC3, Nissan)
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_vi_vin (vin_sha256),
  KEY ix_vi_vt (vehicle_type_id),
  CONSTRAINT fk_vi_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE SET NULL,
  CONSTRAINT fk_vi_mkt FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- 2. PROVENANCE — documents (the root) + document_fields (raw verbatim capture)
-- ===================================================================

CREATE TABLE IF NOT EXISTS documents (
  id                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  doc_type            VARCHAR(24) NOT NULL,          -- coc|type_plate|vin_plate|owner_manual|workshop_manual|fsm|tsb|refrigerant_label|component_photo|oem_portal|other
  provenance_kind     VARCHAR(20) NOT NULL,          -- first_party_photo|first_party_scan|oem_portal|aggregator|wikimedia_stock|other
  -- subject (nullable — a manual is gen-wide; a CoC is instance/TVV-specific)
  vehicle_instance_id INT UNSIGNED NULL,
  vehicle_type_id     INT UNSIGNED NULL,
  generation_id       INT UNSIGNED NULL,
  make_id             INT UNSIGNED NULL,
  market_id           SMALLINT UNSIGNED NULL,        -- CoC is market-registered
  -- citation / links
  issuing_authority   VARCHAR(128) NULL,             -- "KMC", approval authority
  citation            VARCHAR(255) NOT NULL,         -- vendor-neutral display string
  source_label        VARCHAR(64)  NULL,             -- internal only; may name vendor
  original_url        VARCHAR(512) NULL,
  public_link         TINYINT(1)  NOT NULL DEFAULT 0,-- link-gating: 1 only for OEM/NHTSA/EPA
  license             VARCHAR(48)  NULL,             -- for wikimedia_stock: 'cc-by-sa-4.0'
  attribution         VARCHAR(255) NULL,             -- mandatory credit string for stock media
  -- storage
  storage_path        VARCHAR(512) NULL,            -- F:\…\*.pdf / *.md / photo path
  file_sha256         CHAR(64) NULL,
  page_count          SMALLINT UNSIGNED NULL,
  -- edition / effectivity
  edition             VARCHAR(64) NULL,
  model_year          SMALLINT UNSIGNED NULL,
  effective_date      DATE NULL,                     -- issue/approval date
  retrieved_at        DATETIME NOT NULL,
  notes               VARCHAR(512) NULL,
  created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_doc_type (doc_type),
  KEY ix_doc_vt (vehicle_type_id),
  KEY ix_doc_gen (generation_id),
  KEY ix_doc_sha (file_sha256),
  CONSTRAINT fk_doc_vi   FOREIGN KEY (vehicle_instance_id) REFERENCES vehicle_instances(id) ON DELETE SET NULL,
  CONSTRAINT fk_doc_vt   FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE SET NULL,
  CONSTRAINT fk_doc_gen  FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE SET NULL,
  CONSTRAINT fk_doc_make FOREIGN KEY (make_id) REFERENCES makes(id) ON DELETE SET NULL,
  CONSTRAINT fk_doc_mkt  FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Raw verbatim capture of each source field (esp. CoC §-numbered rows incl. tokenized §52).
-- The ground truth every derived fact points back to (invariant 4 + §52 traceability, trap T4).
CREATE TABLE IF NOT EXISTS document_fields (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  document_id   INT UNSIGNED NOT NULL,
  field_no      VARCHAR(16)  NULL,                   -- CoC field number: '13','16.1','35','52'
  raw_label     VARCHAR(255) NULL,                   -- multilingual label as printed ("Omschrijving")
  raw_value     TEXT         NULL,                   -- verbatim value incl. full §52 token string
  page_no       SMALLINT UNSIGNED NULL,
  source_span   VARCHAR(64)  NULL,                   -- char offset / bbox ref into the artifact
  created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_df_doc (document_id),
  KEY ix_df_field (document_id, field_no),
  CONSTRAINT fk_df_doc FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- 3. CONFLICT-RESOLUTION AUTHORITY (decided before ingest)
-- ===================================================================
CREATE TABLE IF NOT EXISTS source_priority (
  doc_type   VARCHAR(24)     NOT NULL,
  priority   SMALLINT UNSIGNED NOT NULL,             -- higher wins on conflict
  PRIMARY KEY (doc_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- rdw_open = the NL registration authority's open data: primary-grade for MASSES (it has no tyre data),
-- 90 = just below the manufacturer CoC/type-plate (100). Two-lane wedge, panel-endorsed 2026-09-23.
-- NB: for NL masses the RDW *registered* value is legally leading; when RDW and CoC disagree, keep BOTH
-- (conflict_group) and render labelled ("RDW registered" vs "CoC homologation"), don't silently drop.
INSERT INTO source_priority (doc_type, priority) VALUES
  ('coc', 100), ('type_plate', 100), ('vin_plate', 95),
  ('rdw_open', 90),
  ('workshop_manual', 80), ('owner_manual', 70), ('fsm', 60),
  ('refrigerant_label', 55), ('component_photo', 50),
  ('tsb', 40), ('oem_portal', 40), ('other', 10)
ON DUPLICATE KEY UPDATE priority = VALUES(priority);

-- ===================================================================
-- 4. FACTS — controlled vocab + unified scalar table + two typed wedge tables
-- ===================================================================

CREATE TABLE IF NOT EXISTS fact_types (
  id            SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code          VARCHAR(48) NOT NULL,                -- 'dim_length','engine_code','engine_oil_capacity','co2_combined'…
  category      VARCHAR(24) NOT NULL,                -- 'dimension','powertrain','fluid','torque','emission','electrical','performance','service'
  default_unit  VARCHAR(16) NULL,                    -- 'mm','l','Nm','g/km'
  value_kind    VARCHAR(8)  NOT NULL DEFAULT 'num',  -- 'num' | 'text'
  PRIMARY KEY (id),
  UNIQUE KEY uk_fact_types_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed the fact vocabulary (G2 fix: empty fact_types FK-blocks every spec_facts insert).
-- Covers every scalar the 8 CoCs yield + the core manual (2nd-layer) specs. Extend via INSERT IGNORE later.
-- Qualifier conventions (stored in spec_facts.qualifier): axle:1|2 · gear:1..8 · cycle:nedc|wltp · phase:low|medium|high|extra_high|combined|weighted_combined · trip:complete|urban · rpm:<n> · kind:<family> · condition:normal|severe · tyre:<size>
INSERT INTO fact_types (code, category, default_unit, value_kind) VALUES
  -- construction / dimensions
  ('num_axles','construction',NULL,'text'), ('powered_axles','construction',NULL,'text'),
  ('dim_length','dimension','mm','num'), ('dim_width','dimension','mm','num'),
  ('dim_height','dimension','mm','num'), ('dim_wheelbase','dimension','mm','num'),
  ('dim_axle_spacing','dimension','mm','num'), ('dim_axle_track','dimension','mm','num'),
  -- powertrain
  ('engine_code','powertrain',NULL,'text'), ('engine_manufacturer','powertrain',NULL,'text'),
  ('working_principle','powertrain',NULL,'text'), ('cylinders','powertrain',NULL,'text'),
  ('engine_capacity','powertrain','cm3','num'), ('fuel_type','powertrain',NULL,'text'),
  ('fuel_mode','powertrain',NULL,'text'), ('is_pure_electric','powertrain',NULL,'text'),
  ('is_hybrid_electric','powertrain',NULL,'text'),
  ('max_net_power','powertrain','kW','num'), ('max_power_rpm','powertrain','min-1','text'),
  ('electric_motor_power','powertrain','kW','num'), ('electric_motor_hourly_power','powertrain','kW','num'),
  ('electric_motor_30min_power','powertrain','kW','num'),
  ('electric_range','powertrain','km','num'), ('electric_consumption','powertrain','Wh/km','num'),
  ('gearbox_type','powertrain',NULL,'text'), ('gearbox_ratio','powertrain',NULL,'num'),
  ('final_drive_ratio','powertrain',NULL,'num'), ('total_gear_ratio','powertrain',NULL,'num'),
  -- performance / bodywork
  ('max_speed','performance','km/h','num'),
  ('body_code','bodywork',NULL,'text'), ('doors','bodywork',NULL,'text'), ('seats','bodywork',NULL,'num'),
  -- emission
  ('euro_class','emission',NULL,'text'), ('emission_regulation','emission',NULL,'text'),
  ('co2','emission','g/km','num'), ('fuel_consumption','emission','l/100km','num'),
  ('co_emission','emission','mg/km','num'), ('thc_emission','emission','mg/km','num'),
  ('nmhc_emission','emission','mg/km','num'), ('nox_emission','emission','mg/km','num'),
  ('pm_emission','emission','mg/km','num'), ('smoke_coefficient','emission','m-1','num'),
  ('sound_stationary','emission','dB(A)','num'), ('sound_drive_by','emission','dB(A)','num'),
  ('rde_nox','emission','mg/km','num'), ('rde_pn','emission','#/km','num'),
  ('deviation_factor','emission',NULL,'num'), ('verification_factor','emission',NULL,'num'),
  ('eco_innovation_code','emission',NULL,'text'), ('eco_innovation_co2_saving','emission','g/km','num'),
  ('test_mass','emission','kg','num'), ('frontal_area','emission','m2','num'),
  ('road_load_f0','emission','N','num'), ('road_load_f1','emission','N/(km/h)','num'),
  ('road_load_f2','emission','N/(km/h)2','num'), ('driving_cycle_class','emission',NULL,'text'),
  ('family_identifier','emission',NULL,'text'),
  -- chassis
  ('trailer_brake_connection','chassis',NULL,'text'),
  -- fluid (manual 2nd layer)
  ('engine_oil_capacity','fluid','l','num'), ('oil_viscosity','fluid',NULL,'text'),
  ('oil_spec_standard','fluid',NULL,'text'), ('coolant_capacity','fluid','l','num'),
  ('brake_fluid_spec','fluid',NULL,'text'), ('transmission_fluid_capacity','fluid','l','num'),
  ('ac_refrigerant_type','fluid',NULL,'text'), ('ac_refrigerant_amount','fluid','g','num'),
  -- torque / electrical / service
  ('torque_lug_nut','torque','Nm','num'), ('torque_spark_plug','torque','Nm','num'),
  ('torque_oil_drain','torque','Nm','num'),
  ('battery_group','electrical',NULL,'text'), ('battery_cca','electrical','A','num'),
  ('battery_ah','electrical','Ah','num'),
  ('service_interval_oil','service','km','num')
ON DUPLICATE KEY UPDATE category = VALUES(category);

-- Unified scalar facts (dimensions, emissions, engine attrs, fluids, torques, service).
-- Masses/towing and tyres are NOT here — they are the typed wedge tables below.
CREATE TABLE IF NOT EXISTS spec_facts (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
  -- scope: rolls up to a generation for routing; narrow with vehicle_type/engine when known
  generation_id      INT UNSIGNED NOT NULL,
  vehicle_type_id    INT UNSIGNED NULL,              -- set when TVV-specific (CoC)
  engine_id          INT UNSIGNED NULL,              -- set when engine-specific (manual)
  fact_type_id       SMALLINT UNSIGNED NOT NULL,
  qualifier          VARCHAR(48) NULL,               -- 'cycle:wltp','phase:combined','condition:severe'
  value_num          DECIMAL(12,3) NULL,
  value_text         VARCHAR(255) NULL,
  unit               VARCHAR(16) NULL,
  is_primary         TINYINT(1) NOT NULL DEFAULT 1,   -- 0 = sanctioned §52 alternate (height/track/power override)
  -- provenance (invariants 2 & 4) — NOT NULL
  market_id          SMALLINT UNSIGNED NOT NULL,
  source_document_id INT UNSIGNED NOT NULL,
  document_field_id  INT UNSIGNED NULL,              -- raw-capture trace (invariant 4)
  -- versioning (invariant 3): valid_to IS NULL == current
  valid_from         DATE NOT NULL,
  valid_to           DATE NULL,
  supersedes_id      INT UNSIGNED NULL,
  change_set_id      INT UNSIGNED NULL,
  conflict_group     INT UNSIGNED NULL,
  -- QA gate (invariant 5): render only 'approved'
  qa_state           VARCHAR(10) NOT NULL DEFAULT 'pending',  -- pending|approved|rejected
  extracted_by       VARCHAR(32) NULL,
  qa_by              VARCHAR(32) NULL,
  qa_at              DATETIME NULL,
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_sf_scope (generation_id, fact_type_id, market_id, valid_to),
  KEY ix_sf_vt (vehicle_type_id),
  KEY ix_sf_qa (qa_state),
  CONSTRAINT fk_sf_gen  FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_sf_vt   FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE CASCADE,
  CONSTRAINT fk_sf_eng  FOREIGN KEY (engine_id) REFERENCES engines(id) ON DELETE RESTRICT,
  CONSTRAINT fk_sf_ft   FOREIGN KEY (fact_type_id) REFERENCES fact_types(id) ON DELETE RESTRICT,
  CONSTRAINT fk_sf_mkt  FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT,
  CONSTRAINT fk_sf_doc  FOREIGN KEY (source_document_id) REFERENCES documents(id) ON DELETE RESTRICT,
  CONSTRAINT fk_sf_df   FOREIGN KEY (document_field_id) REFERENCES document_fields(id) ON DELETE SET NULL,
  CONSTRAINT fk_sf_sup  FOREIGN KEY (supersedes_id) REFERENCES spec_facts(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- THE WEDGE #1 — homologated tyre/wheel combos (CoC §35 primary + every §52 remark combo).
CREATE TABLE IF NOT EXISTS tyre_homologations (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id      INT UNSIGNED NOT NULL,          -- for routing
  vehicle_type_id    INT UNSIGNED NOT NULL,
  market_id          SMALLINT UNSIGNED NOT NULL,
  axle               VARCHAR(8) NOT NULL DEFAULT 'both',  -- 'front'|'rear'|'both'|'1'|'2' (staggered/EV)
  is_primary         TINYINT(1) NOT NULL,            -- §35 = 1 primary; §52 remark = 0 optional
  tyre_size          VARCHAR(32) NOT NULL,           -- '185/65R15'
  load_index         VARCHAR(8)  NULL,               -- '88'
  speed_rating       VARCHAR(4)  NULL,               -- 'H'
  rim                VARCHAR(24) NULL,               -- '6.0Jx15' (verbatim, incl. '16x6 1/2J')
  et_mm              DECIMAL(5,1) NULL,              -- 46 (decimal: Sportage §35 primary is ET43.5)
  rrc_class          VARCHAR(4)  NULL,               -- §35 rolling-resistance/energy class 'C'
  tyre_co2_category  VARCHAR(8)  NULL,               -- §35 tyre CO2 category 'C1'
  conditions         VARCHAR(255) NULL,              -- §52 note "not with Electronic Parking Brake"
  source_document_id INT UNSIGNED NOT NULL,
  document_field_id  INT UNSIGNED NULL,
  valid_from         DATE NOT NULL,
  valid_to           DATE NULL,
  supersedes_id      INT UNSIGNED NULL,
  conflict_group     INT UNSIGNED NULL,
  qa_state           VARCHAR(10) NOT NULL DEFAULT 'pending',
  qa_by              VARCHAR(32) NULL,
  qa_at              DATETIME NULL,
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_th_scope (generation_id, market_id, valid_to),
  KEY ix_th_vt (vehicle_type_id),
  CONSTRAINT fk_th_gen FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_th_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE CASCADE,
  CONSTRAINT fk_th_mkt FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT,
  CONSTRAINT fk_th_doc FOREIGN KEY (source_document_id) REFERENCES documents(id) ON DELETE RESTRICT,
  CONSTRAINT fk_th_df  FOREIGN KEY (document_field_id) REFERENCES document_fields(id) ON DELETE SET NULL,
  CONSTRAINT fk_th_sup FOREIGN KEY (supersedes_id) REFERENCES tyre_homologations(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- THE WEDGE #2 — masses & towing (CoC §13/§16/§18/§19 + §52 mass overrides).
CREATE TABLE IF NOT EXISTS mass_homologations (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id      INT UNSIGNED NOT NULL,
  vehicle_type_id    INT UNSIGNED NOT NULL,
  market_id          SMALLINT UNSIGNED NOT NULL,
  mass_kind          VARCHAR(28) NOT NULL,           -- running_order|actual_mass|max_laden|max_axle|max_combination|tow_braked_drawbar|tow_braked_centre_axle|tow_unbraked|coupling_vertical
  axle_index         TINYINT UNSIGNED NULL,          -- for max_axle: 1 or 2
  value_kg           SMALLINT UNSIGNED NULL,
  is_primary         TINYINT(1) NOT NULL DEFAULT 1,  -- §16/§18 primary; §52 alt = 0
  conditions         VARCHAR(255) NULL,
  source_document_id INT UNSIGNED NOT NULL,
  document_field_id  INT UNSIGNED NULL,
  valid_from         DATE NOT NULL,
  valid_to           DATE NULL,
  supersedes_id      INT UNSIGNED NULL,
  conflict_group     INT UNSIGNED NULL,
  qa_state           VARCHAR(10) NOT NULL DEFAULT 'pending',
  qa_by              VARCHAR(32) NULL,
  qa_at              DATETIME NULL,
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_mh_scope (generation_id, market_id, valid_to),
  KEY ix_mh_vt (vehicle_type_id),
  CONSTRAINT fk_mh_gen FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_mh_vt  FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE CASCADE,
  CONSTRAINT fk_mh_mkt FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT,
  CONSTRAINT fk_mh_doc FOREIGN KEY (source_document_id) REFERENCES documents(id) ON DELETE RESTRICT,
  CONSTRAINT fk_mh_df  FOREIGN KEY (document_field_id) REFERENCES document_fields(id) ON DELETE SET NULL,
  CONSTRAINT fk_mh_sup FOREIGN KEY (supersedes_id) REFERENCES mass_homologations(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- 5. MEDIA — link the existing images table to its source document
-- ===================================================================
ALTER TABLE images
  ADD COLUMN document_id INT UNSIGNED NULL AFTER trim_id,
  ADD KEY ix_images_document (document_id),
  ADD CONSTRAINT fk_images_document FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE SET NULL;

-- Hybrid grain (panel 2026-09-23): trims stay trade-name/powertrain scaffolding (hub table +
-- Tier-3 URLs); vehicle_types is the document-verified grain. This nullable link lets a catalog
-- trim resolve to its TVV so document-verified mass/tyre facts surface on the existing trim/hub UI.
ALTER TABLE trims
  ADD COLUMN vehicle_type_id INT UNSIGNED NULL AFTER generation_id,
  ADD KEY ix_trims_vehicle_type (vehicle_type_id),
  ADD CONSTRAINT fk_trims_vehicle_type FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE SET NULL;

SET FOREIGN_KEY_CHECKS = 1;
