-- 5 Series G31 Touring (pre-LCI) — wagon sibling of G30 sedan (gen 81).
--
-- Body-specific overrides vs G30 sedan:
-- - Length 4962 mm (sedan 4936) — slightly longer rear overhang
-- - Height 1498 mm (sedan 1479) — taller for cargo area
-- - Cargo 570-1700 L (sedan 530 L) — wagon-defining feature
-- - Width 1868 mm + wheelbase 2975 mm — UNCHANGED from sedan
--
-- Drivetrain, fluids, procedures, tire pressures — all identical to G30 sedan
-- because the Touring uses the same B47/B48/B57/B58/N63 engines, same ZF 8HP
-- gearbox, same EPB and cooling architecture. We clone all of these from the
-- sedan gen (id 81) and only override the body-specific dimensions + cargo +
-- weight. Trims also clone from G30 sedan minus the M5 (which was sedan-only
-- F90 chassis), adding the M550d which was available on Touring but not US
-- sedan.

SET NAMES utf8mb4;

SET @model_id := (SELECT id FROM models WHERE slug = '5-series');
SET @gen_sedan := (SELECT id FROM generations WHERE slug = '5-series-g30-sedan-2017-2020');

-- ----------------------------------------------------------------------------
-- 1. New G31 Touring gen
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
  '5-series-g31-touring-2017-2020',
  ordinal,
  'G31',
  'G31 Touring',
  'Estate',
  2017, 2020,
  layout,
  platform,
'The G31 is the Touring (estate / wagon) sibling of the G30 sedan, sharing the seventh-generation 5 Series chassis, drivetrain lineup, and OEM-specified fluids while adding a load-area body with a self-levelling rear air suspension (option on most variants, standard on diesel six-cylinder + M550d) and a panoramic glass roof option. Compared with the sedan, the Touring is 26 mm longer (4962 mm), 19 mm taller (1498 mm), and provides 570 L of cargo with the rear bench upright (1700 L folded). Wheelbase is unchanged at 2975 mm.\n\nEngines mirror the G30 sedan: petrol four-cylinder (520i, 530i), petrol inline-six (540i — B58 340 hp), petrol-electric plug-in hybrid (530e iPerformance), diesel four-cylinder (520d / 520d MHEV / 525d), diesel inline-six (530d / 540d xDrive / M550d xDrive 400 hp). The M5 F90 was sedan-only, so the Touring tops out at the M550d xDrive 400 hp tri-turbo diesel. All variants pair to the BMW-built ZF GA8HP-50Z 8-speed automatic.\n\nFluids, torques, electrical, bulbs, fuses, and Condition-Based Service intervals are identical to the G30 sedan. Maintenance procedures (engine oil level via iDrive, vacuum-fill cooling, EPB service mode, ZF 8HP fluid drain) carry verbatim from the sedan workshop manual.',
  4962, 1868, 1498, 2975,
  front_track_mm, rear_track_mm, fuel_tank_l, 570,
  front_suspension, 'Multi-link, self-levelling air',
  front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_sedan;

SET @gen_touring := (SELECT id FROM generations WHERE slug = '5-series-g31-touring-2017-2020');

-- ----------------------------------------------------------------------------
-- 2. Clone trims from sedan (excluding M5 which was F90 sedan-only)
-- ----------------------------------------------------------------------------
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT
  @gen_touring,
  slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims
WHERE generation_id = @gen_sedan
  AND name NOT LIKE 'M5%';

-- ----------------------------------------------------------------------------
-- 3. Clone gen-wide spec data (fluids/procedures/etc.) from sedan
-- ----------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_touring, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_sedan;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_touring, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_touring, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_touring, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_touring, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_sedan;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_touring, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_sedan;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_touring, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_sedan;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_touring, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_sedan AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_touring, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_sedan;

-- Retitle procedures from "5 Series (G30)" to "5 Series (G31)" so the
-- Touring page reads correctly (lesson learned from G60 contamination).
UPDATE procedures
SET title = REPLACE(title, '5 Series (G30)', '5 Series (G31)')
WHERE generation_id = @gen_touring;

-- ----------------------------------------------------------------------------
-- 4. Clone spec_sources for fluids/procedures/bulbs/torques/tires
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_touring
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_touring AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = @gen_touring
                AND b_new.position = b_old.position
                AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = @gen_touring
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.torque_nm <=> t_old.torque_nm)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_sedan AND t_old.engine_id IS NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = @gen_touring
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = @gen_sedan AND tp_old.trim_id IS NULL;

-- ----------------------------------------------------------------------------
-- 5. New body-specific source for Touring lineup verification
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 5 Series Touring (G31)',
   'https://www.auto-data.net/en/bmw-5-series-touring-g31-generation-5336', NOW(),
   'G31 Touring 2017-2020 trim list + body-specific dimensions (4962 x 1868 x 1498 mm, cargo 570-1700 L).');

SET @s_ad_g31 := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-touring-g31-generation-5336');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_g31 FROM trims WHERE generation_id = @gen_touring;
