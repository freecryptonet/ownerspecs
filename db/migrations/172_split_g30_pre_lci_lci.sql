-- G30 LCI gen split per herstructureringsplan Fase 1.1, same workflow as
-- F30 split (mig 161/162) + G20 LCI split (mig 169). The G30 LCI launched
-- mid-2020 for the 2021 model year with revised LED headlights, the curved
-- iDrive 7 display, and new oil/coolant specifications introduced
-- progressively through MY2023.
--
-- Current `5-series-g30-sedan-2017-2020` correctly scoped to pre-LCI period.
-- This migration creates `5-series-g30-lci-sedan-2020-present` for the LCI
-- variant (2020 mid-year onwards through MY2023, last year before G60).

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '5-series-g30-sedan-2017-2020');

-- ----------------------------------------------------------------------------
-- 1. Insert new G30 LCI gen with editorial intro
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
  '5-series-g30-lci-sedan-2020-2023',
  ordinal,
  'G30 LCI',
  'G30 LCI',
  body_type,
  2020,
  2023,
  layout,
  platform,
'The G30 LCI (Life Cycle Impulse) is the mid-cycle refresh of the seventh-generation 5 Series, launched mid-2020 for the 2021 model year and produced through 2023 before the G60 successor took over. The LCI is identified externally by larger single-frame kidney grilles, slimmer LED headlights (with optional Iconic Glow illuminated kidneys for the first time on a 5), and revised tail lamps with darker tinting. Inside, the LCI ships the BMW Live Cockpit Professional with iDrive 7 as standard.

The powertrain lineup carries forward the modular B-series engines with revised tunes and a broader mild-hybrid 48V rollout. Petrol: 530i (B48), 540i (B58 333 hp with 48V MHEV), M550i xDrive (N63 523 hp). Diesel: 520d / 530d / 540d (B47 / B57 with MHEV from MY2021), M550d discontinued late pre-LCI. Plug-in hybrids: 530e iPerformance with B48 + electric (252 hp combined) and the new 545e xDrive launched 2020 pairing the B58 inline-six with an electric motor for 389 hp combined — one of the most powerful plug-in 5 Series ever.

OEM specifications introduced during the LCI run: BMW Longlife-17 FE+ engine oil for late-cycle petrol engines (MY2023 narrows the suitable list further to LL-01 FE / LL-17 FE+), and new BMW LC-18 coolant from MY2023 replacing the G48 HOAT formula used since the E60 era. Production continues at BMW Group plants in Dingolfing (Germany) and San Luis Potosí (Mexico).',
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_pre;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '5-series-g30-lci-sedan-2020-2023');

-- ----------------------------------------------------------------------------
-- 2. Duplicate gen-wide spec data (schema-correct columns from G20 LCI lessons)
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

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_lci, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_pre;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_lci, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_pre;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_lci, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_pre;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_lci, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_pre AND trim_id IS NULL;

INSERT INTO images (
  generation_id, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
)
SELECT
  @gen_lci, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
FROM images WHERE generation_id = @gen_pre AND trim_id IS NULL;

INSERT INTO procedures (
  generation_id, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
)
SELECT
  @gen_lci, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- 3. Copy spec_sources via content-matching JOIN
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
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_lci AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_pre;
