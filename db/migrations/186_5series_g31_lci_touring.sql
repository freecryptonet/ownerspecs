-- 5 Series G31 LCI Touring (2020-2024) — Touring sibling of G30 LCI sedan
-- (gen 127). Same wagon-vs-sedan body deltas as the pre-LCI Touring (mig 184).
--
-- Production: BMW Dingolfing 2020-2024 (one year longer than the sedan run
-- because the Touring continued briefly into 2024 while the G60 sedan came
-- online mid-2023 and the G61 Touring not until 2024).

SET NAMES utf8mb4;

SET @model_id := (SELECT id FROM models WHERE slug = '5-series');
SET @gen_sedan := 127;  -- 5-series-g30-lci-sedan-2020-2023

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
  '5-series-g31-lci-touring-2020-2024',
  ordinal,
  'G31 LCI',
  'bmw-5-series-g30-2017-2024',
  'BMW 5 Series G30 family (2017-2024)',
  'G31 LCI Touring',
  'Estate',
  2020, 2024,
  layout,
  platform,
'The G31 LCI is the facelift Touring (estate / wagon) sibling of the G30 LCI sedan, launched mid-2020 for the 2021 model year and produced through 2024 — running about a year longer than the sedan because the G61 Touring did not launch until model year 2024. Externally it shares the LCI''s larger single-frame kidney grille, slimmer LED headlights and revised tail lamps; internally, the BMW Live Cockpit Professional with iDrive 7 is standard. Dimensions are essentially unchanged from the pre-LCI G31 (4963 x 1868 x 1498 mm), but cargo capacity stays at the wagon-defining 570 L upright / 1700 L rear-folded.\n\nThe powertrain lineup mirrors the G30 LCI sedan with the same B-series engines plus mild-hybrid 48V rollout: petrol 520i / 530i (B48) and 540i MHEV (B58), petrol-electric 530e PHEV xDrive (B48 + electric, 292 hp combined), diesel 520d / 530d / 540d (B47 / B57 with MHEV from MY2021). The M5 / M5 Competition / M5 CS remain sedan-only (F90 platform); the Touring tops out at the diesel 540d xDrive 340 hp.\n\nFluids, torques, electrical, bulbs, fuses, tire pressures and Condition-Based Service intervals are identical to the G30 LCI sedan including the late-cycle BMW LC-18 coolant (introduced MY2023). Vehicles built MY2021-2022 retain BMW G48 HOAT — refer to the engine bay label for the build-specific spec.',
  4963, 1868, 1498, 2975,
  front_track_mm, rear_track_mm, fuel_tank_l, 570,
  front_suspension, 'Multi-link, self-levelling air',
  front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_sedan;

SET @gen_touring := (SELECT id FROM generations WHERE slug = '5-series-g31-lci-touring-2020-2024');

-- Clone trims (no M5 on Touring)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_touring, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims
WHERE generation_id = @gen_sedan
  AND name NOT LIKE 'M5%';

-- Clone gen-wide spec data from sedan
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

-- Retitle procedures G30 → G31 LCI
UPDATE procedures
SET title = REPLACE(title, '5 Series (G30)', '5 Series (G31 LCI)')
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

-- Body-specific source row
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 5 Series Touring (G31 LCI, facelift 2020)',
   'https://www.auto-data.net/en/bmw-5-series-touring-g31-lci-facelift-2020-generation-7812', NOW(),
   'G31 LCI Touring 2020-2024 trim list + body-specific dimensions (4963 x 1868 x 1498 mm, cargo 570-1700 L).');

SET @s_ad_lci := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-touring-g31-lci-facelift-2020-generation-7812');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_lci FROM trims WHERE generation_id = @gen_touring;

-- Add the G31 LCI to the G30 family backfill (mig 185 didn't include it yet)
-- — already covered by the family_slug/family_label set on INSERT above.
