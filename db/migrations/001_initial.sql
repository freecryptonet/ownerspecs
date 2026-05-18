-- ownerspecs.com schema · v0.1 · 2026-05-18
-- Engineering Reference data model.
-- Naming: snake_case singular for ENUMs, plural for table names.
-- All tables InnoDB, utf8mb4, with FK constraints.
-- market_id is nullable across spec tables: NULL = global default, non-NULL = per-market override.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- IDENTITY TABLES
-- ===================================================================

CREATE TABLE IF NOT EXISTS makes (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug            VARCHAR(64)  NOT NULL,
  name            VARCHAR(128) NOT NULL,
  country_of_origin CHAR(2)    NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_makes_slug (slug),
  KEY ix_makes_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS models (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  make_id         INT UNSIGNED NOT NULL,
  slug            VARCHAR(96)  NOT NULL,
  name            VARCHAR(128) NOT NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_models_make_slug (make_id, slug),
  KEY ix_models_name (name),
  CONSTRAINT fk_models_make FOREIGN KEY (make_id) REFERENCES makes(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS generations (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  model_id        INT UNSIGNED NOT NULL,
  slug            VARCHAR(128) NOT NULL,
  ordinal         TINYINT UNSIGNED NULL,           -- 1, 2, 3 … (Civic gen 10)
  codename        VARCHAR(48)  NULL,                -- "FC", "G20", "E36"
  display_name    VARCHAR(160) NOT NULL,            -- "Civic Sedan (X)"
  body_type       VARCHAR(48)  NOT NULL,            -- "sedan", "hatchback"…
  start_year      SMALLINT UNSIGNED NOT NULL,
  end_year        SMALLINT UNSIGNED NULL,           -- NULL = present
  layout          VARCHAR(16)  NULL,                -- "FF", "FR", "MR", "RR", "4WD"
  platform        VARCHAR(96)  NULL,
  predecessor_id  INT UNSIGNED NULL,
  successor_id    INT UNSIGNED NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_generations_model_slug (model_id, slug),
  KEY ix_generations_years (start_year, end_year),
  KEY ix_generations_predecessor (predecessor_id),
  KEY ix_generations_successor (successor_id),
  CONSTRAINT fk_generations_model FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS markets (
  id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code            VARCHAR(8)   NOT NULL,            -- "US", "EU", "UK", "JDM", "AU", "RoW"
  name            VARCHAR(64)  NOT NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uk_markets_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS generation_markets (
  generation_id   INT UNSIGNED NOT NULL,
  market_id       SMALLINT UNSIGNED NOT NULL,
  local_name      VARCHAR(160) NULL,                -- if model sells under different name
  start_year      SMALLINT UNSIGNED NULL,
  end_year        SMALLINT UNSIGNED NULL,
  PRIMARY KEY (generation_id, market_id),
  KEY ix_gen_markets_market (market_id),
  CONSTRAINT fk_gen_markets_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_gen_markets_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS engines (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code            VARCHAR(48)  NOT NULL,            -- "L15B7", "K20C1"
  display_name    VARCHAR(96)  NOT NULL,            -- "1.5 L turbo"
  displacement_cc SMALLINT UNSIGNED NULL,
  fuel            VARCHAR(16)  NOT NULL,            -- "gasoline", "diesel", "electric", "hybrid"
  aspiration      VARCHAR(16)  NULL,                -- "NA", "turbo", "supercharged"
  valvetrain      VARCHAR(48)  NULL,
  cylinders       TINYINT UNSIGNED NULL,
  bore_mm         DECIMAL(5,2) NULL,
  stroke_mm       DECIMAL(5,2) NULL,
  compression     DECIMAL(4,2) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_engines_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS transmissions (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  type            VARCHAR(16)  NOT NULL,            -- "MT", "AT", "CVT", "DCT", "AMT", "EV"
  gears           TINYINT UNSIGNED NULL,
  display_name    VARCHAR(96)  NULL,                -- "6-speed manual"
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS trims (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  market_id       SMALLINT UNSIGNED NULL,           -- NULL = global trim
  slug            VARCHAR(96)  NOT NULL,
  name            VARCHAR(128) NOT NULL,            -- "Sport", "EX-T", "Touring"
  engine_id       INT UNSIGNED NULL,
  transmission_id INT UNSIGNED NULL,
  start_year      SMALLINT UNSIGNED NULL,
  end_year        SMALLINT UNSIGNED NULL,
  hp              SMALLINT UNSIGNED NULL,
  torque_nm       SMALLINT UNSIGNED NULL,
  zero_100_kmh_s  DECIMAL(4,1) NULL,
  top_speed_kmh   SMALLINT UNSIGNED NULL,
  fuel_combined_l_100km DECIMAL(4,1) NULL,
  co2_g_km        SMALLINT UNSIGNED NULL,
  curb_weight_kg  SMALLINT UNSIGNED NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_trims_gen_market_slug (generation_id, market_id, slug),
  KEY ix_trims_engine (engine_id),
  KEY ix_trims_transmission (transmission_id),
  CONSTRAINT fk_trims_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_trims_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT,
  CONSTRAINT fk_trims_engine FOREIGN KEY (engine_id) REFERENCES engines(id) ON DELETE RESTRICT,
  CONSTRAINT fk_trims_transmission FOREIGN KEY (transmission_id) REFERENCES transmissions(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- OWNER-MANUAL DATA TABLES (the moat)
-- All spec tables carry market_id nullable so per-market overrides coexist with global defaults.
-- ===================================================================

CREATE TABLE IF NOT EXISTS fluid_specs (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  fluid_type      VARCHAR(32) NOT NULL,             -- "engine_oil", "cvt", "atf", "coolant", "brake", "ps", "diff_f", "diff_r", "ac_refrigerant", "washer"
  capacity_l      DECIMAL(6,2) NULL,
  capacity_qt     DECIMAL(6,2) NULL,
  viscosity       VARCHAR(24)  NULL,                -- "0W-20", "DOT 3"
  spec_standard   VARCHAR(96)  NULL,                -- "API SP", "Honda HCF-2", "R-1234yf"
  filter_part_no  VARCHAR(48)  NULL,
  drain_interval_km   INT UNSIGNED NULL,
  drain_interval_mi   INT UNSIGNED NULL,
  drain_interval_months SMALLINT UNSIGNED NULL,
  notes           VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY ix_fluid_specs_gen (generation_id),
  KEY ix_fluid_specs_trim (trim_id),
  KEY ix_fluid_specs_type (fluid_type),
  CONSTRAINT fk_fluid_specs_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_fluid_specs_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_fluid_specs_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS electrical_specs (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  battery_group   VARCHAR(24)  NULL,
  cca             SMALLINT UNSIGNED NULL,
  ah              SMALLINT UNSIGNED NULL,
  alternator_amps SMALLINT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY ix_electrical_specs_gen (generation_id),
  CONSTRAINT fk_electrical_specs_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_electrical_specs_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_electrical_specs_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS torque_specs (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  fastener        VARCHAR(64)  NOT NULL,            -- "lug_nut", "spark_plug", "oil_drain", "caliper_bolt"…
  torque_nm       SMALLINT UNSIGNED NULL,
  torque_ftlb     SMALLINT UNSIGNED NULL,
  thread_lock     VARCHAR(48)  NULL,                -- "loctite_blue", "none"
  notes           VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY ix_torque_specs_gen_fastener (generation_id, fastener),
  CONSTRAINT fk_torque_specs_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_torque_specs_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_torque_specs_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bulbs (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  market_id       SMALLINT UNSIGNED NULL,
  position        VARCHAR(48)  NOT NULL,            -- "headlight_low", "headlight_high", "fog_front", "brake", "interior_dome"…
  bulb_code       VARCHAR(24)  NOT NULL,            -- "H11", "9005", "194", "7440"
  quantity        TINYINT UNSIGNED NOT NULL DEFAULT 1,
  led_from_factory TINYINT(1)  NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY ix_bulbs_gen (generation_id),
  CONSTRAINT fk_bulbs_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_bulbs_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS fuses (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  market_id       SMALLINT UNSIGNED NULL,
  location        VARCHAR(24)  NOT NULL,            -- "under_hood", "cabin", "trunk"
  position        VARCHAR(16)  NOT NULL,            -- "F1", "A12"
  amperage        SMALLINT UNSIGNED NULL,
  circuit_name    VARCHAR(128) NULL,                -- "ECU main", "ABS pump"
  is_relay        TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uk_fuses_gen_loc_pos (generation_id, market_id, location, position),
  CONSTRAINT fk_fuses_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_fuses_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS parts (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  part_type       VARCHAR(48)  NOT NULL,            -- "spark_plug", "air_filter", "cabin_filter", "oil_filter", "wiper_front", "wiper_rear", "drive_belt"
  part_number     VARCHAR(96)  NOT NULL,
  source_brand    VARCHAR(48)  NULL,                -- "NGK", "Denso", "Mahle", "OEM"
  gap_mm          DECIMAL(4,2) NULL,                -- for spark plugs
  size            VARCHAR(48)  NULL,                -- "26 in" for wipers
  notes           VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY ix_parts_gen_type (generation_id, part_type),
  CONSTRAINT fk_parts_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_parts_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_parts_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS service_intervals (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  service         VARCHAR(96)  NOT NULL,            -- "engine_oil", "cvt_fluid", "spark_plugs", "coolant", "brake_fluid"…
  miles_normal    INT UNSIGNED NULL,
  miles_severe    INT UNSIGNED NULL,
  km_normal       INT UNSIGNED NULL,
  km_severe       INT UNSIGNED NULL,
  months          SMALLINT UNSIGNED NULL,
  ordinal_severe  TINYINT UNSIGNED NULL,            -- which scheduled visit (1, 2, 3…)
  notes           VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY ix_service_intervals_gen (generation_id),
  CONSTRAINT fk_service_intervals_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_service_intervals_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_service_intervals_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tire_pressures (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  position        VARCHAR(16)  NOT NULL,            -- "front", "rear", "spare"
  load_condition  VARCHAR(24)  NOT NULL DEFAULT 'normal',  -- "normal", "max_load", "winter"
  psi             DECIMAL(4,1) NULL,
  kpa             SMALLINT UNSIGNED NULL,
  tire_size       VARCHAR(48)  NULL,                -- "215/55 R16 93H"
  PRIMARY KEY (id),
  KEY ix_tire_pressures_gen (generation_id),
  CONSTRAINT fk_tire_pressures_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_tire_pressures_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_tire_pressures_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS procedures (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  market_id       SMALLINT UNSIGNED NULL,
  procedure_type  VARCHAR(48)  NOT NULL,            -- "oil_reset", "tpms_relearn", "throttle_adapt", "jump_start"…
  slug            VARCHAR(96)  NOT NULL,
  title           VARCHAR(255) NOT NULL,
  body_md         MEDIUMTEXT   NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_procedures_gen_slug (generation_id, market_id, slug),
  CONSTRAINT fk_procedures_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_procedures_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- PROVENANCE
-- Every spec value must trace to ≥2 sources via spec_sources.
-- ===================================================================

CREATE TABLE IF NOT EXISTS sources (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  type            VARCHAR(32)  NOT NULL,            -- "oem_manual", "haynespro", "alldata", "auto_data", "ultimatespecs", "tsb", "wikimedia"
  citation        VARCHAR(255) NOT NULL,
  url             VARCHAR(512) NULL,
  retrieved_at    DATETIME     NOT NULL,
  notes           VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY ix_sources_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Polymorphic association: which spec_table + spec_id is backed by which source(s)
CREATE TABLE IF NOT EXISTS spec_sources (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  spec_table      VARCHAR(32)  NOT NULL,            -- "fluid_specs", "torque_specs", "trims"…
  spec_id         INT UNSIGNED NOT NULL,
  source_id       INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_spec_sources (spec_table, spec_id, source_id),
  KEY ix_spec_sources_table_id (spec_table, spec_id),
  KEY ix_spec_sources_source (source_id),
  CONSTRAINT fk_spec_sources_source FOREIGN KEY (source_id) REFERENCES sources(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS images (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id   INT UNSIGNED NOT NULL,
  trim_id         INT UNSIGNED NULL,
  market_id       SMALLINT UNSIGNED NULL,
  url             VARCHAR(512) NOT NULL,            -- our CDN URL after rehosting
  source          VARCHAR(64)  NOT NULL,            -- "toyota_newsroom", "wikimedia", "flickr_cc"
  license         VARCHAR(48)  NOT NULL,            -- "cc-by-sa-4.0", "oem-editorial", "cc-by-2.0"
  attribution     VARCHAR(255) NULL,
  original_url    VARCHAR(512) NULL,
  download_date   DATE         NOT NULL,
  caption         VARCHAR(255) NULL,
  position        VARCHAR(32)  NULL,                -- "3-4-front", "side", "rear", "dash", "interior"
  width           SMALLINT UNSIGNED NULL,
  height          SMALLINT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY ix_images_gen (generation_id),
  CONSTRAINT fk_images_generation FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_images_trim FOREIGN KEY (trim_id) REFERENCES trims(id) ON DELETE CASCADE,
  CONSTRAINT fk_images_market FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- SEED DATA — markets
-- ===================================================================

INSERT INTO markets (code, name) VALUES
  ('US',  'United States'),
  ('CA',  'Canada'),
  ('EU',  'European Union'),
  ('UK',  'United Kingdom'),
  ('JDM', 'Japan (domestic)'),
  ('AU',  'Australia / New Zealand'),
  ('RoW', 'Rest of world')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET FOREIGN_KEY_CHECKS = 1;
