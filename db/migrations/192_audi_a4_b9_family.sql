-- Audi A4 B9 family expansion — adds B9 pre-LCI Avant + B9 LCI sedan + B9
-- LCI Avant. Existing gen 24 (a4-sedan-b9-2015-2018) gets a family_slug
-- backfill so all B9 variants cluster on /family/audi-a4-b9-2015-2025.

SET NAMES utf8mb4;

SET @model_a4 := (SELECT id FROM models WHERE slug = 'a4');

-- ----------------------------------------------------------------------------
-- 0. Backfill family_slug on existing B9 pre-LCI sedan (gen 24)
-- ----------------------------------------------------------------------------
UPDATE generations
SET family_slug = 'audi-a4-b9-2015-2025',
    family_label = 'Audi A4 B9 family (2015-2025)'
WHERE id = 24;

-- ============================================================================
-- B9 pre-LCI Avant 2015-2018 — clone from gen 24 sedan with body overrides
-- ============================================================================
SET @gen_src := 24;

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, 'a4-avant-b9-2015-2018', ordinal, 'B9',
  'audi-a4-b9-2015-2025', 'Audi A4 B9 family (2015-2025)',
  'B9 Avant', 'Estate',
  2015, 2018, layout, platform,
'The B9 Avant is the wagon sibling of the B9 A4 sedan, sharing the MLB Evo platform, drivetrain lineup, and OEM-specified fluids. Compared with the sedan, the Avant is 1 mm shorter overall (4725 mm) but 15 mm taller (1442 mm) to accommodate the rear cargo area, providing 505 L upright (1510 L folded). Wheelbase is unchanged at 2820 mm.\n\nEngines mirror the sedan: petrol (1.4 TFSI / 2.0 TFSI EA888 gen 3), diesel (2.0 TDI EA288, 3.0 TDI V6), with 6-speed manual or 7-speed S tronic dual-clutch. Quattro AWD is optional on most variants and standard on 3.0 TDI V6 and 2.0 TFSI 252 hp. The S4 / RS4 Avant are separate gens (B9 S4 was sedan + Avant; RS4 was Avant-only on the B9 platform).',
  4725, 1842, 1442, 2820,
  front_track_mm, rear_track_mm, fuel_tank_l, 505,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_new := (SELECT id FROM generations WHERE slug = 'a4-avant-b9-2015-2018');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_new, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'S4%' AND name NOT LIKE 'RS4%';

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

-- ============================================================================
-- B9 LCI sedan 2019-2025 (auto-data: "B9 8W, facelift 2019")
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, 'a4-sedan-b9-lci-2019-2025', ordinal, 'B9 LCI',
  'audi-a4-b9-2015-2025', 'Audi A4 B9 family (2015-2025)',
  'B9 LCI Sedan', 'Sedan',
  2019, 2025, layout, platform,
'The B9 LCI is the mid-cycle facelift of the ninth-generation Audi A4 sedan, launched mid-2019 for the 2020 model year and built through 2025 — the final ICE A4 ever (the nameplate transitions to "A5" for the 2025+ replacement). Externally identified by the more aggressive single-frame Singleframe grille, sharper LED Matrix headlights, and the slim "boomerang" tail light signature; internally by the upgraded MMI Touch Response infotainment with the second 8.6-inch climate touchscreen replacing the rotary controller.\n\nKey powertrain change: 12V mild-hybrid (MHEV) electrical system rolled out across most petrol + diesel variants from launch, enabling coast / engine-off-cruising and a small belt-driven starter-generator. Audi also adopted a new numeric-suffix model naming (30 TDI, 35 TFSI, 40 TFSI, 45 TFSI, 50 TDI) — power output is the suffix multiplier divided by ~2.5 (e.g. "40" = ~200 PS / 150 kW class). Engines: EA288 evo 2.0 TDI four-cylinder (30/35/40 TDI), EA839 V6 3.0 TDI (50 TDI), EA888 evo 4 2.0 TFSI four-cylinder (35/40/45 TFSI MHEV). Quattro AWD optional on most variants and standard on 45 TFSI and V6.\n\nOEM oil: VW 508.00 LongLife IV FE 0W-20 (the new low-friction grade — replaces the LongLife III 5W-30 of the pre-LCI). Coolant: VW G13 (lilac OAT) carries through the entire B9 run. Fuel tank 54 L (FWD) / 58 L (quattro). Cargo 460 L upright.',
  4762, 1847, 1431, 2820,
  front_track_mm, rear_track_mm, fuel_tank_l, 460,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_lci_sedan := (SELECT id FROM generations WHERE slug = 'a4-sedan-b9-lci-2019-2025');

-- LCI sedan trims (numeric naming + MHEV from launch)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_lci_sedan, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src AND name NOT LIKE 'S4%' AND name NOT LIKE 'RS4%';

-- Clone gen-wide spec data from pre-LCI B9 (most fluid/torque specs carry over)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_lci_sedan, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_lci_sedan, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_lci_sedan, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_lci_sedan, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_lci_sedan, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_lci_sedan, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_lci_sedan, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_lci_sedan, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_lci_sedan, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, 'A4 (B9)', 'A4 (B9 LCI)') WHERE generation_id = @gen_lci_sedan;
UPDATE procedures SET title = REPLACE(title, 'B9 (2015-2018)', 'B9 LCI (2019-2025)') WHERE generation_id = @gen_lci_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_lci_sedan
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

-- ============================================================================
-- B9 LCI Avant 2019-2024 (clone from LCI sedan with body overrides)
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id, 'a4-avant-b9-lci-2019-2024', ordinal, 'B9 LCI',
  'audi-a4-b9-2015-2025', 'Audi A4 B9 family (2015-2025)',
  'B9 LCI Avant', 'Estate',
  2019, 2024, layout, platform,
'The B9 LCI Avant is the wagon variant of the facelift A4, sharing the LCI sedan''s mild-hybrid (MHEV) electrical system, EA288 evo / EA888 evo 4 / EA839 V6 engine lineup, and updated MMI Touch Response infotainment. Compared with the LCI sedan, the Avant is the same length (4762 mm) but 29 mm taller (1460 mm) to accommodate the cargo area, providing 495 L upright (1495 L folded). The Avant also keeps mechanically identical OEM fluid specs to the sedan — VW 508.00 LongLife IV FE 0W-20 engine oil (4.5 L for 2.0 TFSI, 5.4 L for 3.0 TDI V6) and VW G13 coolant throughout.',
  4762, 1847, 1460, 2820,
  front_track_mm, rear_track_mm, fuel_tank_l, 495,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_lci_sedan;

SET @gen_lci_avant := (SELECT id FROM generations WHERE slug = 'a4-avant-b9-lci-2019-2024');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_lci_avant, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_lci_sedan;

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_lci_avant, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_lci_sedan;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_lci_avant, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_lci_sedan AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_lci_avant, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_lci_sedan AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_lci_avant, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_lci_sedan AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_lci_avant, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_lci_sedan;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_lci_avant, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_lci_sedan;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_lci_avant, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_lci_sedan;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_lci_avant, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_lci_sedan AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_lci_avant, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_lci_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_lci_avant
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_lci_sedan;

-- ============================================================================
-- Body-specific source citations
-- ============================================================================
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — Audi A4 Avant (B9 8W)', 'https://www.auto-data.net/en/audi-a4-avant-b9-8w-generation-4620', NOW(), 'B9 pre-LCI Avant 2015-2018 spec set.'),
  ('Auto-Data.net — Audi A4 (B9 8W, facelift 2019)', 'https://www.auto-data.net/en/audi-a4-b9-8w-facelift-2019-generation-7119', NOW(), 'B9 LCI sedan 2019-2025. MHEV across petrol + diesel from launch. New numeric trim naming (30/35/40/45/50 TFSI/TDI).'),
  ('Auto-Data.net — Audi A4 Avant (B9 8W, facelift 2019)', 'https://www.auto-data.net/en/audi-a4-avant-b9-8w-facelift-2019-generation-7120', NOW(), 'B9 LCI Avant 2019-2024.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_new AND s.url = 'https://www.auto-data.net/en/audi-a4-avant-b9-8w-generation-4620';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_lci_sedan AND s.url = 'https://www.auto-data.net/en/audi-a4-b9-8w-facelift-2019-generation-7119';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_lci_avant AND s.url = 'https://www.auto-data.net/en/audi-a4-avant-b9-8w-facelift-2019-generation-7120';
