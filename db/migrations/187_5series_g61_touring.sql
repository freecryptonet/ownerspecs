-- 5 Series G61 Touring (2024-present) — wagon sibling of G60 sedan (gen 128).
--
-- Auto-data range: 197-489 Hp (520d MHEV up to 550e PHEV). M5 G99 Touring
-- on a separate platform code arrives later in the run — defer to follow-up.

SET NAMES utf8mb4;

SET @gen_sedan := 128;  -- 5-series-g60-sedan-2023-present

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id,
  '5-series-g61-touring-2024-present',
  ordinal,
  'G61',
  'bmw-5-series-g60-2023-present',
  'BMW 5 Series G60 family (2023-present)',
  'G61 Touring',
  'Estate',
  2024, NULL,
  layout,
  platform,
'The G61 is the Touring (estate / wagon) sibling of the G60 sedan, launched for the 2024 model year and built alongside the G60 + i5 at BMW Group Dingolfing. It shares the CLAR-2 platform, the Curved Display + iDrive 8.5 cockpit, and the same dimensions as the G60 sedan (5060 mm long, 1900 mm wide, wheelbase 2995 mm) — the wagon body adds 25–30 mm of height for the cargo area, takes rear-air-suspension self-levelling as standard, and gives 570 L of cargo with the rear bench upright (1700 L folded).\n\nEngines mirror the G60 sedan: petrol mild-hybrid (520i / 530i — B48), petrol inline-six mild-hybrid (540i — B58 333 hp), plug-in hybrids (530e RWD / xDrive and the 550e xDrive flagship at 489 hp), and diesel mild-hybrids (520d / 540d xDrive on B47 / B57). All engines use BMW Longlife-22 FE++ engine oil from launch and BMW LC-18 coolant — identical specifications to the G60 sedan. The i5 fully-electric variant lives under the separate i5 model entry; the M5 Touring G99 will be added when the data settles.',
  5060, 1900, 1515, 2995,
  front_track_mm, rear_track_mm, fuel_tank_l, 570,
  front_suspension, 'Multi-link, self-levelling air',
  front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_sedan;

SET @gen_touring := (SELECT id FROM generations WHERE slug = '5-series-g61-touring-2024-present');

-- Clone trims (all 11 from G60 sedan — Touring lineup matches sedan)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_touring, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_sedan;

-- Clone gen-wide spec data from G60 sedan
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

-- Retitle procedures G60 → G61 to read correctly on wagon page
UPDATE procedures
SET title = REPLACE(title, '5 Series (G60)', '5 Series (G61)')
WHERE generation_id = @gen_touring;

-- Clone spec_sources
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
JOIN bulbs b_new ON b_new.generation_id = @gen_touring AND b_new.position = b_old.position AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_sedan;

-- Body-specific source
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 5 Series Touring (G61)',
   'https://www.auto-data.net/en/bmw-5-series-touring-g61-generation-9876', NOW(),
   'G61 Touring 2024+ trim list. Power range 197-489 Hp (520d MHEV through 550e xDrive PHEV).');

SET @s_ad_g61 := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-touring-g61-generation-9876');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_g61 FROM trims WHERE generation_id = @gen_touring;
