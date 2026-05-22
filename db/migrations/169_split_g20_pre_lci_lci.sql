-- G20 LCI gen split per herstructureringsplan Fase 1.1, same workflow as
-- F30 split (migrations 161 + 162). The G20 LCI launched in mid-2022 for
-- the 2023 model year with a curved iDrive 8 display, revised front-end
-- LEDs, and a new coolant specification (BMW LC-18, replacing G48).
--
-- Current `3-series-sedan-g20-2019-2022` is correctly scoped as G20 pre-LCI
-- (no rename needed — the slug already reflects the pre-LCI period).
-- This migration creates a new `3-series-sedan-g20-lci-2022-present` gen
-- for the LCI variant and duplicates gen-wide spec rows.
--
-- Lessons from F30 split (migrations 161 + 162) applied:
-- - Use schema-correct column names from the start: tire_pressures has
--   no `notes` column; bulbs has `quantity` not `count`; fuses has
--   `location` / `position` / `circuit_name` / `is_relay`; images has
--   NOT NULL `source` / `license` / `download_date`; procedures has
--   `tools_required` + `common_mistakes`.
-- - Duplicate spec_sources via JOIN on content-matching keys.
-- - Add 301-redirect entries in next.config.ts in same commit.
--
-- Pre-LCI trim handling: NO trims move. All 23 trims currently on the
-- 2019-2022 gen are pre-LCI variants (320e PHEV 2021-2022, 330e 2019-2022,
-- 330d MHEV 2020-2022, 330d 2019-2020, M340i/M340d). LCI gen starts with
-- 0 trims; G20 LCI-specific variants get seeded in a follow-up migration.

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-2019-2022');

-- ----------------------------------------------------------------------------
-- 1. Insert new G20 LCI gen with editorial intro
-- ----------------------------------------------------------------------------
INSERT INTO generations (
  model_id, slug, ordinal, codename, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id,
  '3-series-sedan-g20-lci-2022-present',
  ordinal,
  'G20 LCI',
  'G20 LCI',
  body_type,
  2022,
  NULL,
  layout,
  platform,
'The G20 LCI (Life Cycle Impulse) is the mid-cycle refresh of the seventh-generation 3 Series, launched mid-2022 for the 2023 model year and continuing into the late 2020s before the G50 successor. The LCI is identified externally by the redesigned front and rear lights with revised LED signatures, a slightly altered front bumper and a wider single-frame kidney grille; internally by the curved BMW Curved Display housing the digital cluster and iDrive 8 / iDrive 8.5 infotainment that replaced the pre-LCI dual-screen layout.

The petrol lineup carries forward the modular B-series engines from pre-LCI (B48 2.0-litre four in 320i / 330i, B58 3.0-litre inline-six in M340i) with revised tuning. The 330e plug-in hybrid continues with the same B48 + electric motor combination. Diesel variants (B47 in 318d / 320d, B57 in M340d) remain available outside North America; BMW does not sell G20 diesel in the US. The LCI also rolled out new OEM lubricant specifications: BMW Longlife-17 FE+ (and from MY2026 the Longlife-22 FE++ low-friction grade) for petrol, and a new BMW LC-18 coolant specification replacing the long-running G48 HOAT formula. Production continues at BMW Group plants in Munich, Regensburg and San Luis Potosí (Mexico) for North-American supply.',
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_pre;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-lci-2022-present');

-- ----------------------------------------------------------------------------
-- 2. Duplicate gen-wide spec data (engine_id NULL fluid_specs / torque_specs
--    / parts / service_intervals) onto LCI gen
-- ----------------------------------------------------------------------------
INSERT INTO fluid_specs (
  generation_id, fluid_type, engine_id, trim_id, market_id,
  capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no,
  drain_interval_mi, drain_interval_km, drain_interval_months, notes
)
SELECT
  @gen_lci, fluid_type, engine_id, trim_id, market_id,
  capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no,
  drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs
WHERE generation_id = @gen_pre AND engine_id IS NULL;

INSERT INTO torque_specs (
  generation_id, fastener, engine_id, trim_id,
  torque_nm, torque_ftlb, thread_lock, notes
)
SELECT
  @gen_lci, fastener, engine_id, trim_id,
  torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs
WHERE generation_id = @gen_pre AND engine_id IS NULL;

INSERT INTO parts (
  generation_id, part_type, engine_id, trim_id,
  part_number, source_brand, gap_mm, size, notes
)
SELECT
  @gen_lci, part_type, engine_id, trim_id,
  part_number, source_brand, gap_mm, size, notes
FROM parts
WHERE generation_id = @gen_pre AND engine_id IS NULL;

INSERT INTO service_intervals (
  generation_id, service, engine_id, trim_id,
  miles_normal, miles_severe, km_normal, km_severe, months, notes
)
SELECT
  @gen_lci, service, engine_id, trim_id,
  miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals
WHERE generation_id = @gen_pre AND engine_id IS NULL;

-- electrical_specs (gen-wide)
INSERT INTO electrical_specs (
  generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps
)
SELECT @gen_lci, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_pre;

-- bulbs (gen-wide; G20 LCI keeps the all-LED layout from pre-LCI)
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_lci, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_pre;

-- fuses (gen-wide)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_lci, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_pre;

-- tire_pressures (gen-wide, trim_id NULL)
INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_lci, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- images (hero shared between pre-LCI and LCI on launch — the LCI gets its
--  own hero image when a 2023+ specific image is added later)
INSERT INTO images (
  generation_id, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
)
SELECT
  @gen_lci, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
FROM images WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- procedures (G20 LCI shares same procedures as pre-LCI; battery / oil-level /
--  jacking / CBS reset are mechanically identical between pre-LCI and LCI)
INSERT INTO procedures (
  generation_id, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
)
SELECT
  @gen_lci, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- 3. Copy spec_sources by JOINing on content-matching keys (same pattern as
--    F30 split mig 161 step 5)
-- ----------------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_lci
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_pre AND f_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = @gen_lci
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.engine_id <=> t_old.engine_id)
                       AND (t_new.torque_nm <=> t_old.torque_nm)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_pre AND t_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = @gen_lci
                AND b_new.position = b_old.position
                AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_pre;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = @gen_lci
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = @gen_pre AND tp_old.trim_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_lci AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_pre;
