-- Audi A6 C8 family expansion — adds Avant pre-LCI, LCI sedan, LCI Avant
-- and Allroad C8 to the existing A6 C8 sedan (gen 115). Existing gen 115
-- is cleaned up: shortened to end_year 2023, slug renamed to drop "present",
-- display_name simplified, family_slug set, and the mis-assigned Allroad
-- trim (id 410) is moved to the new Allroad gen. Two duplicate legacy
-- trims (408, 409) are removed in favour of the scraper-ingested ones.
--
-- All 5 gens cluster on family_slug = audi-a6-c8-2018-present so the
-- /family/audi-a6-c8-2018-present route renders the side-by-side compare.

SET NAMES utf8mb4;

SET @model_a6 := (SELECT id FROM models WHERE slug = 'a6');

-- ============================================================================
-- 0. Pre-clean existing A6 C8 sedan (gen 115)
-- ============================================================================

-- Remove legacy duplicate trims 408 + 409 (replaced by scraper-ingested 777/783).
-- Keep 410 (will move to Allroad gen below).
DELETE FROM spec_sources WHERE spec_table = 'trims' AND spec_id IN (408, 409);
DELETE FROM trims WHERE id IN (408, 409);

-- Backfill editorial_intro + family_slug, shorten end_year, simplify naming.
UPDATE generations
SET slug          = 'a6-c8-sedan-2018-2023',
    display_name  = 'A6 V (C8) Sedan',
    family_slug   = 'audi-a6-c8-2018-present',
    family_label  = 'Audi A6 C8 family (2018-present)',
    end_year      = 2023,
    editorial_intro = 'The C8 (Typ 4K) is the fifth-generation Audi A6, launched at the 2018 Geneva Motor Show and on sale from mid-2018 as a 2019 model. Built on the MLB Evo platform shared with the A7, A8, Q7 and Q8, the C8 sedan introduces a heavily digital interior — dual MMI Touch Response touchscreens (10.1" upper + 8.6" lower for climate) replace the rotary controller of the C7. From the 2020 model year, mild-hybrid (MHEV) was rolled out across the petrol and diesel range: a 48V belt-driven starter-generator enables coast / engine-off cruising and reduces fuel consumption ~0.7 L/100 km.\n\nEngine lineup (post-MHEV): 2.0 TFSI EA888 evo4 four-cylinder (40 TFSI 204 hp / 45 TFSI 245-265 hp MHEV), 3.0 TFSI EA839 V6 (55 TFSI 340 hp MHEV), 2.0 TDI EA288 evo (35 TDI 163 hp / 40 TDI 204 hp MHEV), 3.0 TDI EA897 evo3 V6 (45 TDI 245 hp / 50 TDI 286 hp MHEV). Plug-in hybrid 50 TFSI e (299 hp combined) + 55 TFSI e (367 hp combined) added 2020 with 14.1 kWh battery and ~50 km WLTP electric range. Quattro AWD standard on V6 and PHEV; optional on 40 TFSI / 45 TFSI / 45 TDI 4-cylinder, with the "quattro ultra" on-demand system replacing permanent quattro on lower-output variants.\n\nOEM oil: VW 504.00 LongLife III 5W-30 on pre-2020 variants, transitioning to VW 508.00 LongLife IV FE 0W-20 on MHEV variants from MY2020. Coolant: VW G13 (lilac OAT). The C8 was replaced by the LCI (facelift 2023) for MY2024.'
WHERE id = 115;

SET @gen_src := 115;

-- ============================================================================
-- 1. A6 Avant C8 pre-LCI 2018-2023 — clone from sedan with body overrides
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
  model_id, 'a6-avant-c8-2018-2023', ordinal, 'C8',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'A6 V (C8) Avant', 'Estate',
  2018, 2023, layout, platform,
'The C8 Avant is the wagon sibling of the C8 A6 sedan, sharing the MLB Evo platform, MHEV electrical architecture, dual-touchscreen MMI Touch Response infotainment, and OEM fluid specifications. Compared with the sedan, the Avant is essentially the same length (4939 mm, -1 mm) but 37 mm taller (1494 mm) to accommodate the cargo bay, providing 565 L upright (1680 L folded). Wheelbase is unchanged at 2924 mm.\n\nEngine lineup mirrors the sedan: 2.0 TFSI EA888 evo4 (40 TFSI / 45 TFSI MHEV), 3.0 TFSI EA839 V6 (55 TFSI MHEV), 2.0 TDI EA288 evo (35/40 TDI MHEV), 3.0 TDI EA897 evo3 V6 (45/50 TDI MHEV), plus 50 TFSI e / 55 TFSI e plug-in hybrids. The S6 / RS6 Avant are separate gens on the same C8 platform (S6 Avant: 3.0 TDI V8 hybrid / 2.9 TFSI; RS6 C8 Performance: 4.0 TFSI V8 biturbo). OEM oil + coolant specs identical to the sedan.',
  4939, 1886, 1494, 2924,
  front_track_mm, rear_track_mm, fuel_tank_l, 565,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_avant := (SELECT id FROM generations WHERE slug = 'a6-avant-c8-2018-2023');

-- Trims: clone all sedan trims except the misplaced Allroad (which will move
-- to the Allroad gen instead) and excluding any S6/RS6 (separate gens).
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_avant, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src
  AND id != 410
  AND name NOT LIKE 'S6%'
  AND name NOT LIKE 'RS6%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_avant, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_src;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_avant, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_avant, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_avant, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_avant, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_avant, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_avant, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_avant, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_avant, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

UPDATE procedures SET title = REPLACE(title, 'A6 (C8)', 'A6 Avant (C8)') WHERE generation_id = @gen_avant;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_avant
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_avant AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

-- ============================================================================
-- 2. A6 C8 LCI sedan 2023-present (auto-data: "C8 limousine facelift 2023")
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
  model_id, 'a6-c8-lci-sedan-2023-present', ordinal, 'C8 LCI',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'A6 V (C8 LCI) Sedan', 'Sedan',
  2023, NULL, layout, platform,
'The C8 LCI is the mid-cycle facelift of the fifth-generation Audi A6 sedan, on sale from mid-2023 (production switch from pre-LCI mid-2023; predominantly MY2024 globally). The visual refresh centres on a wider Singleframe grille with sharper geometric inserts, redesigned LED Matrix headlights with daytime-running signature, OLED tail lights with selectable patterns on top trims, and revised lower fascias front and rear. The MMI Touch Response dual-screen architecture carries over essentially unchanged. The C8 platform is otherwise unchanged from pre-LCI — same MLB Evo bones, wheelbase, suspension geometry.\n\nPowertrain rationalisation: MHEV is now standard across the entire petrol + diesel range from launch (the pre-LCI''s non-MHEV early variants are dropped). Engine lineup: 2.0 TFSI EA888 evo4 (40 TFSI 204 hp / 45 TFSI 265 hp MHEV), 3.0 TFSI EA839 V6 (55 TFSI 340 hp MHEV), 2.0 TDI EA288 evo (35 TDI 163 hp / 40 TDI 204 hp MHEV), 3.0 TDI EA897 evo3 V6 (45 TDI 245 hp / 50 TDI 286 hp MHEV). Plug-in hybrid 50 TFSI e (299 hp) + 55 TFSI e (367 hp) continue with the 17.9 kWh battery (up from 14.1 kWh pre-LCI) and 70-80 km WLTP electric range.\n\nOEM oil: VW 508.00 LongLife IV FE 0W-20 across MHEV variants. Coolant: VW G13 (lilac OAT) carries through. Final ICE A6 generation — replaced from 2026 by the new A6 e-tron BEV (separate model) and a new ICE A6 derived from the A7 nameplate consolidation.',
  4949, 1886, 1457, 2924,
  front_track_mm, rear_track_mm, fuel_tank_l, 530,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_src;

SET @gen_lci_sedan := (SELECT id FROM generations WHERE slug = 'a6-c8-lci-sedan-2023-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_lci_sedan, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year
FROM trims WHERE generation_id = @gen_src
  AND id != 410
  AND name NOT LIKE 'S6%'
  AND name NOT LIKE 'RS6%';

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

UPDATE procedures SET title = REPLACE(title, 'A6 (C8)', 'A6 (C8 LCI)') WHERE generation_id = @gen_lci_sedan;

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

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_lci_sedan AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

-- ============================================================================
-- 3. A6 Avant C8 LCI 2023-present — clone from LCI sedan with Avant body
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
  model_id, 'a6-avant-c8-lci-2023-present', ordinal, 'C8 LCI',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'A6 V (C8 LCI) Avant', 'Estate',
  2023, NULL, layout, platform,
'The C8 LCI Avant is the wagon variant of the facelift A6, on sale from mid-2023 with the same powertrain rationalisation as the LCI sedan (MHEV standard across petrol + diesel, PHEV continues with the larger 17.9 kWh battery). Compared with the LCI sedan, the Avant is 10 mm shorter overall (4939 mm vs 4949 mm) but 37 mm taller (1494 mm) to accommodate the cargo area, providing 565 L upright (1680 L folded) — identical to the pre-LCI Avant body. The Avant keeps mechanically identical OEM fluid specs to the LCI sedan: VW 508.00 LongLife IV FE 0W-20 engine oil and VW G13 coolant throughout. Wheelbase, suspension, brakes and chassis are unchanged from the pre-LCI Avant.',
  4939, 1886, 1494, 2924,
  front_track_mm, rear_track_mm, fuel_tank_l, 565,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_lci_sedan;

SET @gen_lci_avant := (SELECT id FROM generations WHERE slug = 'a6-avant-c8-lci-2023-present');

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

UPDATE procedures SET title = REPLACE(title, 'A6 (C8 LCI)', 'A6 Avant (C8 LCI)') WHERE generation_id = @gen_lci_avant;

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

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_lci_avant AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_lci_sedan;

-- ============================================================================
-- 4. A6 Allroad C8 2020-present — clone from Avant pre-LCI with raised ride
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
  model_id, 'a6-allroad-c8-2020-present', ordinal, 'C8',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'A6 Allroad quattro (C8)', 'Wagon',
  2020, NULL, 'AWD', platform,
'The A6 Allroad quattro (C8) is the crossover-styled raised-ride Avant variant, launched late 2019 for the 2020 model year. Compared with the standard C8 Avant it sits 45 mm higher (1497 mm overall vs 1494 mm Avant body alone — the air suspension lifts the entire body and adjusts ride height across five settings), wears unpainted plastic body cladding around the wheel arches and lower sills, and rolls on dedicated all-terrain tyres (typically 235/55 R19 or 245/45 R20 on Pirelli Scorpion / Continental CrossContact). Length grows 12 mm to 4951 mm and width grows 16 mm to 1902 mm with the wider arches. Wheelbase 2925 mm — 1 mm longer than Avant, within tolerance.\n\nDrivetrain is dedicated quattro-only — no FWD or "quattro ultra" variants. Engine lineup is V6 diesel-focused: 40 TDI 204 hp (post-MY22, fills entry rung), 45 TDI V6 231 hp MHEV (EA897 evo3), 50 TDI V6 286 hp MHEV, 55 TDI V6 349 hp MHEV (top trim, 0-100 in 5.2 s). Petrol 55 TFSI V6 340 hp MHEV available in select markets (UK + Australia). All variants pair with the ZF 8HP Tiptronic 8-speed automatic (the lower-output 45 TDI uses the 0HL twin-clutch S tronic in some configurations).\n\nThe Allroad keeps the same OEM fluid specifications as the Avant — VW 508.00 LongLife IV FE 0W-20 oil on petrol MHEV variants, VW 507.00 LongLife III 0W-30 on V6 TDI MHEV, VW G13 coolant. Air suspension fluid (Pentosin CHF 202 / VW G 004 000 M2) is shared with all C8 air-suspension variants. Fuel tank 73 L (the larger of the two C8 sedan/Avant options), cargo 565 L upright / 1680 L folded — identical to standard Avant. The off-road styling package is body kit only — no underbody armour or transfer case differs from a Q5/Q7. Replaced from 2026 by the new A6 Avant nameplate consolidation.',
  4951, 1902, 1497, 2925,
  front_track_mm, rear_track_mm, 73, 565,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations WHERE id = @gen_avant;

SET @gen_allroad := (SELECT id FROM generations WHERE slug = 'a6-allroad-c8-2020-present');

-- Move the misplaced Allroad trim from sedan gen 115 to the new Allroad gen.
UPDATE trims SET generation_id = @gen_allroad WHERE id = 410;

-- Clone the rest of the Avant trim set onto Allroad, but only V6 variants
-- (4-cylinder TFSI/TDI not offered in Allroad spec — V6 diesel + V6 petrol only).
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year)
SELECT @gen_allroad, CONCAT('allroad-', slug), name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, 'AWD', start_year, end_year
FROM trims WHERE generation_id = @gen_avant
  AND (name LIKE '%V6%' OR name LIKE '%TDI%' OR name LIKE '%55 TFSI%')
  AND name NOT LIKE '%TFSI e%';

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_allroad, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_avant;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_allroad, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_avant AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_allroad, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_avant AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_allroad, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_avant AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_allroad, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_avant;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_allroad, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_avant;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_allroad, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_avant;

-- Allroad-specific tire pressures (235/55 R19 vs Avant's 245/45 R19). Use
-- generic 35/35 PSI placeholder — will be refined in HaynesPro inhaal-pull
-- migration along with axle nut torques.
INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
VALUES
  (@gen_allroad, NULL, NULL, 'front', 'normal', 35, 240, '235/55 R19'),
  (@gen_allroad, NULL, NULL, 'rear',  'normal', 35, 240, '235/55 R19'),
  (@gen_allroad, NULL, NULL, 'front', 'loaded', 38, 260, '235/55 R19'),
  (@gen_allroad, NULL, NULL, 'rear',  'loaded', 42, 290, '235/55 R19');

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_allroad, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_avant;

UPDATE procedures SET title = REPLACE(title, 'A6 Avant (C8)', 'A6 Allroad (C8)') WHERE generation_id = @gen_allroad;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_allroad
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_avant;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_allroad AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_avant;

-- ============================================================================
-- 5. Source citations for the 4 new gens (auto-data secondary cross-verify;
--    public OEM citation reuses the existing sedan Audi A6 (C8) Owner's
--    Manual source — added separately via the inhaal-pull migration 196.)
-- ============================================================================
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('Auto-Data.net — Audi A6 Avant (C8)', 'https://www.auto-data.net/en/audi-a6-avant-c8-generation-6203', NOW(), 'C8 pre-LCI Avant 2018-2023 spec set. Cross-verification only — text-only citation.', 0, 0),
  ('Auto-Data.net — Audi A6 (C8, facelift 2023)', 'https://www.auto-data.net/en/audi-a6-limousine-c8-facelift-2023-generation-9794', NOW(), 'C8 LCI sedan 2023-present. MHEV standard across petrol + diesel.', 0, 0),
  ('Auto-Data.net — Audi A6 Avant (C8, facelift 2023)', 'https://www.auto-data.net/en/audi-a6-avant-c8-facelift-2023-generation-9795', NOW(), 'C8 LCI Avant 2023-present.', 0, 0),
  ('Auto-Data.net — Audi A6 Allroad quattro (C8)', 'https://www.auto-data.net/en/audi-a6-allroad-quattro-c8-generation-7174', NOW(), 'C8 Allroad 2020-present. Air suspension + 45mm raised ride.', 0, 0);

-- Audit
SELECT
  (SELECT COUNT(*) FROM generations WHERE family_slug = 'audi-a6-c8-2018-present') AS family_gens,
  (SELECT COUNT(*) FROM trims WHERE generation_id IN (SELECT id FROM generations WHERE family_slug = 'audi-a6-c8-2018-present')) AS family_trims,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (SELECT id FROM generations WHERE family_slug = 'audi-a6-c8-2018-present')) AS family_fluid_rows,
  (SELECT COUNT(*) FROM procedures WHERE generation_id IN (SELECT id FROM generations WHERE family_slug = 'audi-a6-c8-2018-present')) AS family_procedures;
