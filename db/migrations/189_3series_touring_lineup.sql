-- 3 Series Touring (wagon) lineup — F31 / F31 LCI / G21 / G21 LCI.
-- Mirrors the 5-Series Touring work (migs 184, 186-188) for the smaller
-- chassis. Each Touring gen clones from its sedan sibling and overrides
-- body-specific dimensions + cargo + suspension. Family slugs match the
-- sedan family so all gens appear together under the /family/[slug] page.

SET NAMES utf8mb4;

-- Reusable cloning logic per Touring gen. The five steps are:
--   1. INSERT generation (with body overrides + family_slug)
--   2. INSERT trims  (excluding sedan-only M-variants)
--   3. INSERT gen-wide spec data (fluids/torques/parts/services/electrical/
--                                 bulbs/fuses/tire_pressures/procedures)
--   4. UPDATE procedure titles to retitle codename
--   5. INSERT spec_sources via content-matching JOINs (idempotent)
--   6. Add auto-data Touring source row + cite on trims

-- ============================================================================
-- F31 pre-LCI Touring 2012-2015 (clone from F30 sedan gen 53)
-- ============================================================================
SET @gen_src := 53;

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, '3-series-f31-touring-2012-2015', ordinal, 'F31',
  'bmw-3-series-f30-2012-2019', 'BMW 3 Series F30 family (2012-2019)',
  'F31 Touring', 'Estate', 2012, 2015,
  layout, platform,
'The F31 is the Touring (estate / wagon) sibling of the F30 sedan, sharing the sixth-generation 3 Series chassis, drivetrain lineup, and OEM-specified fluids. Compared with the sedan, the F31 is 27 mm longer (4627 mm), 18 mm taller (1434 mm), and provides 495 L of cargo with the rear bench upright (1500 L folded). Wheelbase is unchanged at 2810 mm.\n\nEngines mirror the F30 sedan exactly: petrol four-cylinder (316i, 320i, 328i — N20), petrol inline-six (335i — N55), diesel four-cylinder (316d, 318d, 320d — N47/B47), diesel inline-six (330d, 335d — N57). All pair to either ZF 6HP/8HP automatic or 6-speed manual. The M3 F80 sedan-only — Touring tops out at 335i / 335d. Fluids, torques, electrical, bulbs, fuses, tire pressures and Condition-Based Service intervals are identical to the F30 sedan.',
  4627, 1811, 1434, 2810,
  front_track_mm, rear_track_mm, fuel_tank_l, 495,
  front_suspension, 'Multi-link, with anti-roll bar',
  front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_new := (SELECT id FROM generations WHERE slug = '3-series-f31-touring-2012-2015');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_new, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'M3%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_new, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_new, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_new, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_new, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_new, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_new, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_new, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_new, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_new, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, '3 Series (F30)', '3 Series (F31)') WHERE generation_id = @gen_new;
UPDATE procedures SET title = REPLACE(title, 'F30', 'F31') WHERE generation_id = @gen_new AND title LIKE '%F30%';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_new
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_new AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 3 Series Touring (F31)',
   'https://www.auto-data.net/en/bmw-3-series-touring-f31-generation-3916', NOW(),
   'F31 Touring 2012-2015 trim list. Power 116-313 Hp. Dimensions 4627 x 1811 x 1434 mm.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-touring-f31-generation-3916')
  FROM trims WHERE generation_id = @gen_new;

-- ============================================================================
-- F31 LCI Touring 2015-2019 (clone from F30 LCI sedan gen 125)
-- ============================================================================
SET @gen_src := 125;

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, '3-series-f31-lci-touring-2015-2019', ordinal, 'F31 LCI',
  'bmw-3-series-f30-2012-2019', 'BMW 3 Series F30 family (2012-2019)',
  'F31 LCI Touring', 'Estate', 2015, 2019,
  layout, platform,
'The F31 LCI is the facelift Touring (estate / wagon) variant of the sixth-generation 3 Series, launched mid-2015 and produced through 2019. Externally identified by the revised LED headlights, slimmer kidney grille and updated tail lamps; internally by the iDrive 5.0 infotainment upgrade. Dimensions essentially unchanged from the pre-LCI F31 (4643 x 1811 x 1434 mm) with 495 L cargo upright (1500 L folded). Wheelbase 2810 mm.\n\nThe LCI run introduced the modular B-series engines that replaced the N-series block on most variants: B48 four-cylinder (320i, 330i replacing N20 328i), B58 inline-six (340i replacing N55 335i), B47 four-cylinder diesel (320d), B57 inline-six diesel (330d, 340d, 335d). Fluids, torques, electrical, bulbs, fuses, tire pressures and CBS intervals are identical to the F30 LCI sedan.',
  4643, 1811, 1434, 2810,
  front_track_mm, rear_track_mm, fuel_tank_l, 495,
  front_suspension, 'Multi-link, with anti-roll bar',
  front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_new := (SELECT id FROM generations WHERE slug = '3-series-f31-lci-touring-2015-2019');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_new, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'M3%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_new, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_new, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_new, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_new, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_new, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_new, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_new, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_new, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_new, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, '3 Series (F30)', '3 Series (F31 LCI)') WHERE generation_id = @gen_new;
UPDATE procedures SET title = REPLACE(title, 'F30 LCI', 'F31 LCI') WHERE generation_id = @gen_new AND title LIKE '%F30 LCI%';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_new
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_new AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 3 Series Touring (F31 LCI, Facelift 2015)',
   'https://www.auto-data.net/en/bmw-3-series-touring-f31-lci-facelift-2015-generation-4511', NOW(),
   'F31 LCI Touring 2015-2019 trim list. Power 116-326 Hp. Dimensions 4643 x 1811 x 1434 mm.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-touring-f31-lci-facelift-2015-generation-4511')
  FROM trims WHERE generation_id = @gen_new;

-- ============================================================================
-- G21 Touring 2019-2022 (clone from G20 sedan gen 6)
-- ============================================================================
SET @gen_src := 6;

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, '3-series-g21-touring-2019-2022', ordinal, 'G21',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G21 Touring', 'Estate', 2019, 2022,
  layout, platform,
'The G21 is the Touring (estate / wagon) sibling of the G20 sedan, sharing the seventh-generation 3 Series chassis, drivetrain lineup, and OEM-specified fluids. Compared with the sedan, the G21 is 4 mm longer (4713 mm), 11 mm taller (1445 mm), and provides 500 L of cargo upright (1510 L folded). Wheelbase is unchanged at 2851 mm.\n\nEngines mirror the G20 sedan: petrol four-cylinder (320i / 330i — B48), petrol inline-six (M340i — B58 with xDrive), petrol-electric plug-in hybrid (330e iPerformance), diesel four-cylinder (318d / 320d — B47), diesel inline-six (330d / M340d — B57). The M3 G80 was sedan-only, so the Touring tops out at the M340i 374 hp. Fluids, torques, electrical, bulbs, fuses, tire pressures and Condition-Based Service intervals are identical to the G20 sedan.',
  4713, 1827, 1445, 2851,
  front_track_mm, rear_track_mm, fuel_tank_l, 500,
  front_suspension, 'Multi-link, with anti-roll bar',
  front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_new := (SELECT id FROM generations WHERE slug = '3-series-g21-touring-2019-2022');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_new, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'M3%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_new, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_new, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_new, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_new, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_new, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_new, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_new, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_new, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_new, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, '3 Series (G20)', '3 Series (G21)') WHERE generation_id = @gen_new;
UPDATE procedures SET title = REPLACE(title, '(G20)', '(G21)') WHERE generation_id = @gen_new AND title LIKE '%(G20)%';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_new
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_new AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 3 Series Touring (G21)',
   'https://www.auto-data.net/en/bmw-3-series-touring-g21-generation-7173', NOW(),
   'G21 Touring 2019-2022 trim list. Power 122-374 Hp. Dimensions 4713 x 1827 x 1445 mm.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-touring-g21-generation-7173')
  FROM trims WHERE generation_id = @gen_new;

-- ============================================================================
-- G21 LCI Touring 2022-present (clone from G20 LCI sedan gen 126)
-- ============================================================================
SET @gen_src := 126;

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, '3-series-g21-lci-touring-2022-present', ordinal, 'G21 LCI',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G21 LCI Touring', 'Estate', 2022, NULL,
  layout, platform,
'The G21 LCI is the facelift Touring of the seventh-generation 3 Series, launched mid-2022 for the 2023 model year. Externally identified by the redesigned LED headlights, larger single-frame kidney grille and revised tail lamps; internally by the BMW Curved Display with iDrive 8 / iDrive 8.5. Dimensions essentially unchanged from the pre-LCI G21 (4714 x 1827 x 1448 mm) with 500 L cargo upright (1510 L folded). Wheelbase 2851 mm.\n\nPowertrain mirrors the G20 LCI sedan: petrol mild-hybrid (318i / 320i / 330i — B48 with 48V from MY2023), petrol-electric plug-in hybrid (330e xDrive), petrol inline-six MHEV (M340i — B58 374 hp), diesel mild-hybrid (318d / 320d / 330d — B47/B57 with 48V). The M3 G80 remains sedan-only — Touring tops out at M340i. LCI run introduced new OEM lubricant specs (BMW Longlife-17 FE+ then Longlife-22 FE++ from MY2026) and BMW LC-18 coolant replacing G48.',
  4714, 1827, 1448, 2851,
  front_track_mm, rear_track_mm, fuel_tank_l, 500,
  front_suspension, 'Multi-link, with anti-roll bar',
  front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_new := (SELECT id FROM generations WHERE slug = '3-series-g21-lci-touring-2022-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_new, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'M3%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_new, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_new, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_new, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_new, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_new, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_new, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_new, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_new, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_new, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, '3 Series (G20)', '3 Series (G21 LCI)') WHERE generation_id = @gen_new;
UPDATE procedures SET title = REPLACE(title, 'G20 LCI', 'G21 LCI') WHERE generation_id = @gen_new AND title LIKE '%G20 LCI%';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_new
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_new AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW 3 Series Touring (G21 LCI, facelift 2022)',
   'https://www.auto-data.net/en/bmw-3-series-touring-g21-lci-facelift-2022-generation-8880', NOW(),
   'G21 LCI Touring 2022-present trim list. Power 150-392 Hp. Dimensions 4714 x 1827 x 1448 mm.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-touring-g21-lci-facelift-2022-generation-8880')
  FROM trims WHERE generation_id = @gen_new;
