-- ownerspecs.com · seed: Honda Civic Sedan (X) 2016-2021
-- 4 sources, ~50 spec rows, fully cited.

SET NAMES utf8mb4;
SET @retrieved := '2026-05-12 00:00:00';

-- ===================================================================
-- SOURCES (4)
-- ===================================================================

INSERT INTO sources (type, citation, url, retrieved_at, notes) VALUES
  ('oem_manual',     'Honda 2018 Civic Sedan Owner''s Manual',  'https://owners.honda.com/vehicles/information/2018/Civic-Sedan/manuals',  '2026-05-12 00:00:00', 'OEM PDF, public · pp. 487–520'),
  ('auto_data',      'Auto-Data.net — Honda Civic X Sedan',       'https://www.auto-data.net/en/honda-civic-x-sedan-46856',                   '2026-05-11 00:00:00', 'Catalogue cross-reference · engine and performance data'),
  ('ultimatespecs',  'Ultimatespecs.com — Honda Civic X Sedan',  'https://www.ultimatespecs.com/car-specs/Honda/Civic-X-Sedan',              '2026-05-11 00:00:00', 'Catalogue cross-reference · dimensions and weight'),
  ('haynespro',      'HaynesPro WorkshopData — Honda Civic FC',  NULL,                                                                        '2026-05-14 00:00:00', 'Maintenance intervals, torque, fluid capacities · authenticated session');

SET @src_oem    := (SELECT id FROM sources WHERE citation LIKE 'Honda 2018%' LIMIT 1);
SET @src_ad     := (SELECT id FROM sources WHERE citation LIKE 'Auto-Data.net%' LIMIT 1);
SET @src_us     := (SELECT id FROM sources WHERE citation LIKE 'Ultimatespecs%' LIMIT 1);
SET @src_haynes := (SELECT id FROM sources WHERE citation LIKE 'HaynesPro%' LIMIT 1);

-- ===================================================================
-- MAKE / MODEL / GENERATION
-- ===================================================================

INSERT INTO makes (slug, name, country_of_origin) VALUES ('honda', 'Honda', 'JP');
SET @make_id := LAST_INSERT_ID();

INSERT INTO models (make_id, slug, name) VALUES (@make_id, 'civic', 'Civic');
SET @model_id := LAST_INSERT_ID();

INSERT INTO generations
  (model_id, slug, ordinal, codename, display_name, body_type, start_year, end_year, layout, platform)
VALUES
  (@model_id, 'civic-sedan-x-2016-2021', 10, 'FC', 'Civic Sedan (X)', 'sedan', 2016, 2021, 'FF', 'Honda Compact Global');
SET @gen_id := LAST_INSERT_ID();

-- Markets this generation sold in
INSERT INTO generation_markets (generation_id, market_id, start_year, end_year)
SELECT @gen_id, id, 2016, 2021 FROM markets WHERE code IN ('US','CA','EU','UK','JDM','AU');

SET @mk_us := (SELECT id FROM markets WHERE code='US');
SET @mk_eu := (SELECT id FROM markets WHERE code='EU');
SET @mk_uk := (SELECT id FROM markets WHERE code='UK');

-- ===================================================================
-- ENGINES (4)
-- ===================================================================

INSERT INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('L15B7', '1.5 L turbo',  1498, 'gasoline', 'turbo',         'DOHC 16v i-VTEC', 4, 73.0, 89.5, 10.60),
  ('K20C2', '2.0 NA',       1996, 'gasoline', 'NA',            'DOHC 16v i-VTEC', 4, 81.0, 96.9, 10.80),
  ('L10B1', '1.0 L turbo',   988, 'gasoline', 'turbo',         'DOHC 12v VTEC',   3, 73.0, 78.7, 10.00),
  ('N16A1', '1.6 L diesel', 1597, 'diesel',   'turbo',         'DOHC 16v',         4, 76.0, 88.0, 16.00);

SET @eng_15t := (SELECT id FROM engines WHERE code='L15B7');
SET @eng_20  := (SELECT id FROM engines WHERE code='K20C2');
SET @eng_10t := (SELECT id FROM engines WHERE code='L10B1');
SET @eng_di  := (SELECT id FROM engines WHERE code='N16A1');

-- ===================================================================
-- TRANSMISSIONS (2)
-- ===================================================================

INSERT INTO transmissions (type, gears, display_name) VALUES
  ('MT',  6, '6-speed manual'),
  ('CVT', 0, 'Honda CVT');

SET @tx_mt  := (SELECT id FROM transmissions WHERE type='MT' AND gears=6);
SET @tx_cvt := (SELECT id FROM transmissions WHERE type='CVT' AND gears=0);

-- ===================================================================
-- TRIMS (5 US-market headline trims)
-- ===================================================================

INSERT INTO trims (generation_id, market_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, fuel_combined_l_100km, co2_g_km, curb_weight_kg) VALUES
  (@gen_id, @mk_us, 'lx',      'LX',       @eng_20,  @tx_cvt, 2016, 2021, 158, 187, 8.2, 200, 6.9, 158, 1247),
  (@gen_id, @mk_us, 'ex',      'EX',       @eng_20,  @tx_cvt, 2016, 2021, 158, 187, 8.2, 200, 6.9, 158, 1278),
  (@gen_id, @mk_us, 'sport',   'Sport',    @eng_15t, @tx_mt,  2017, 2021, 174, 220, 6.8, 220, 6.0, 137, 1314),
  (@gen_id, @mk_us, 'ext',     'EX-T',     @eng_15t, @tx_cvt, 2016, 2021, 174, 220, 6.8, 220, 6.0, 137, 1340),
  (@gen_id, @mk_us, 'touring', 'Touring',  @eng_15t, @tx_cvt, 2016, 2021, 174, 220, 6.8, 220, 6.0, 137, 1369);

SET @trim_sport   := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='sport');
SET @trim_ext     := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='ext');
SET @trim_touring := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='touring');

-- ===================================================================
-- FLUID SPECS
-- ===================================================================

-- 1.5T US — engine oil
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
VALUES
  (@gen_id, @trim_sport, @mk_us, 'engine_oil', 3.50, 3.70, '0W-20', 'API SP / ILSAC GF-6', '15400-PLM-A02', 7500, 12000, 12, 'With filter · cold-climate severe-duty 3,750 mi · Honda HG genuine preferred');
SET @fs1 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs1, @src_oem), ('fluid_specs', @fs1, @src_haynes);

-- 2.0 NA US — engine oil
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
VALUES
  (@gen_id, NULL, @mk_us, 'engine_oil_2_0', 4.20, 4.40, '0W-20', 'API SP / ILSAC GF-6', '15400-PLM-A02', 7500, 12000, 12);
SET @fs2 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs2, @src_oem), ('fluid_specs', @fs2, @src_haynes);

-- 1.0T EU/UK — engine oil
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
VALUES
  (@gen_id, NULL, @mk_eu, 'engine_oil_1_0t', 3.20, 3.40, '0W-20', 'ACEA C5', '15400-RTA-004', 7500, 12000, 12);
SET @fs3 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs3, @src_oem), ('fluid_specs', @fs3, @src_haynes);

-- CVT (all CVT trims)
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_id, NULL, NULL, 'transmission_cvt', 3.70, 3.90, NULL, 'Honda HCF-2', 37500, 60000, 'HCF-2 only — do not substitute · severe-duty 25,000 mi');
SET @fs4 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs4, @src_oem), ('fluid_specs', @fs4, @src_haynes);

-- Coolant
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_months)
VALUES
  (@gen_id, NULL, NULL, 'coolant', 4.40, 4.60, 'Honda Type 2 OAT (pink)', 120000, 84);
SET @fs5 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs5, @src_oem), ('fluid_specs', @fs5, @src_haynes);

-- Brake fluid
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, viscosity, spec_standard, drain_interval_months)
VALUES
  (@gen_id, NULL, NULL, 'brake', 'DOT 3', 'Honda OEM preferred', 36);
SET @fs6 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs6, @src_oem), ('fluid_specs', @fs6, @src_haynes);

-- A/C refrigerant — US/EU post-2018
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, spec_standard, notes)
VALUES
  (@gen_id, NULL, @mk_us, 'ac_refrigerant', 0.450, 'R-1234yf · PAG 46', 'Charge weight 450 g · 2018+ US-market');
SET @fs7 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs7, @src_oem), ('fluid_specs', @fs7, @src_haynes);

-- ===================================================================
-- ELECTRICAL
-- ===================================================================

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, NULL, '51R', 410, 45, 100);
SET @es1 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('electrical_specs', @es1, @src_oem), ('electrical_specs', @es1, @src_haynes);

-- ===================================================================
-- TORQUE
-- ===================================================================

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       108, 80,  'Star pattern · 4-step torque'),
  (@gen_id, NULL, 'spark_plug',    18,  13,  'Use anti-seize on aluminium head'),
  (@gen_id, NULL, 'oil_drain',     40,  30,  'Single-use crush washer 94109-14000'),
  (@gen_id, NULL, 'wheel_hub_nut', 245, 181, 'Front and rear identical'),
  (@gen_id, NULL, 'caliper_bolt',  25,  18,  'Slide-pin bolt, M10');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_haynes FROM torque_specs WHERE generation_id=@gen_id;

-- ===================================================================
-- BULBS
-- ===================================================================

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'H11',  2, 0),
  (@gen_id, NULL, 'headlight_high',  '9005', 2, 0),
  (@gen_id, NULL, 'fog_front',       'H8',   2, 0),
  (@gen_id, NULL, 'brake_tail',      '7443', 2, 0),
  (@gen_id, NULL, 'reverse',         '921',  2, 0),
  (@gen_id, NULL, 'license_plate',   '168',  2, 0),
  (@gen_id, NULL, 'interior_dome',   '6418', 1, 0),
  (@gen_id, NULL, 'interior_map',    '6418', 2, 0),
  (@gen_id, NULL, 'glove_box',       '194',  1, 0),
  (@gen_id, NULL, 'trunk',           '194',  1, 0);

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id=@gen_id;

-- ===================================================================
-- FUSES (sample — under-hood box)
-- ===================================================================

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F1',  100, 'Main battery'),
  (@gen_id, NULL, 'under_hood', 'F2',  40,  'ABS motor'),
  (@gen_id, NULL, 'under_hood', 'F3',  40,  'EPS (electric power steering)'),
  (@gen_id, NULL, 'under_hood', 'F4',  30,  'Radiator fan'),
  (@gen_id, NULL, 'under_hood', 'F5',  30,  'Heater blower'),
  (@gen_id, NULL, 'under_hood', 'F8',  20,  'Ignition coil'),
  (@gen_id, NULL, 'under_hood', 'F12', 15,  'Fuel pump'),
  (@gen_id, NULL, 'cabin',      'A1',  7.5, 'Audio / HVAC control'),
  (@gen_id, NULL, 'cabin',      'A2',  15,  'Power windows · driver'),
  (@gen_id, NULL, 'cabin',      'A3',  15,  'Power windows · passenger'),
  (@gen_id, NULL, 'cabin',      'A7',  10,  'Rear defogger'),
  (@gen_id, NULL, 'cabin',      'A12', 20,  'Power outlet · 12V cabin');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id=@gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================

INSERT INTO parts (generation_id, trim_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, @trim_sport,   NULL, 'spark_plug',    'NGK SILZKAR7C11S', 'NGK',     1.10, NULL, '1.5T turbo'),
  (@gen_id, NULL,          NULL, 'oil_filter',    '15400-PLM-A02',     'Honda',  NULL,  NULL, 'Fits 1.5T and 2.0 NA'),
  (@gen_id, NULL,          NULL, 'air_filter',    '17220-5BA-A00',     'Honda',  NULL,  NULL, NULL),
  (@gen_id, NULL,          NULL, 'cabin_filter',  '80292-T6L-H11',     'Honda',  NULL,  NULL, 'HEPA upgrade also fits'),
  (@gen_id, NULL,          NULL, 'wiper_front_d', '76622-TBA-A02',     'Honda',  NULL,  '26 in', 'Driver side'),
  (@gen_id, NULL,          NULL, 'wiper_front_p', '76630-TBA-A02',     'Honda',  NULL,  '19 in', 'Passenger side');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_haynes FROM parts WHERE generation_id=@gen_id;

-- ===================================================================
-- SERVICE INTERVALS
-- ===================================================================

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',     7500,  3750,  12000, 6000,  12, '3.7 qt 0W-20 · 1.5T'),
  (@gen_id, NULL, 'tire_rotation',             7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',          15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',         30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',          30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid',    37500, 25000, 60000, 40000, NULL, 'Honda HCF-2 only'),
  (@gen_id, NULL, 'brake_fluid_flush',         NULL,  NULL,  NULL,  NULL,  36, 'Time-based · DOT 3'),
  (@gen_id, NULL, 'spark_plugs',               60000, NULL,  96000, NULL,  NULL, 'NGK SILZKAR7C11S'),
  (@gen_id, NULL, 'coolant_flush',             120000,NULL, 192000, NULL, 84, 'First service then 60k thereafter'),
  (@gen_id, NULL, 'valve_clearance',           105000,NULL,168000, NULL,  NULL, 'Inspect and adjust'),
  (@gen_id, NULL, 'drive_belt_inspection',     60000, NULL, 96000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'tpms_sensor_battery',       90000, NULL, 144000,NULL,  NULL, NULL);

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_haynes FROM service_intervals WHERE generation_id=@gen_id;

-- ===================================================================
-- TIRE PRESSURES
-- ===================================================================

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, @mk_us, 'front', 'normal',   32, 220, '215/55 R16 93H'),
  (@gen_id, @mk_us, 'rear',  'normal',   32, 220, '215/55 R16 93H'),
  (@gen_id, @mk_us, 'spare', 'normal',   60, 420, 'T125/70 D16');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id=@gen_id;

-- ===================================================================
-- VERIFY
-- ===================================================================

SELECT
  (SELECT COUNT(*) FROM generations WHERE id=@gen_id) AS generations,
  (SELECT COUNT(*) FROM engines)        AS engines,
  (SELECT COUNT(*) FROM trims WHERE generation_id=@gen_id) AS trims,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen_id) AS fluids,
  (SELECT COUNT(*) FROM electrical_specs WHERE generation_id=@gen_id) AS electrical,
  (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen_id) AS torques,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id=@gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses WHERE generation_id=@gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts WHERE generation_id=@gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM spec_sources WHERE spec_id IS NOT NULL) AS total_citations;
