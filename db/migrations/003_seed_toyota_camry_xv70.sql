-- ownerspecs.com · seed: Toyota Camry (XV70) 2018-2024
-- US-market headline trims + 3 engine variants. Same 4-source citation pattern as Civic.

SET NAMES utf8mb4;

-- ===================================================================
-- SOURCES
-- ===================================================================

INSERT INTO sources (type, citation, url, retrieved_at, notes) VALUES
  ('oem_manual',     'Toyota 2020 Camry Owner''s Manual',         'https://www.toyota.com/owners/resources/warranty-owners-manuals',          '2026-05-13 00:00:00', 'OEM PDF, public · MY2020 reference for the XV70 generation'),
  ('auto_data',      'Auto-Data.net — Toyota Camry VIII (XV70)',  'https://www.auto-data.net/en/toyota-camry-viii-xv70-46100',                '2026-05-12 00:00:00', 'Catalogue cross-reference · engine and performance data'),
  ('ultimatespecs',  'Ultimatespecs.com — Toyota Camry XV70',     'https://www.ultimatespecs.com/car-specs/Toyota/Camry-XV70',                '2026-05-12 00:00:00', 'Catalogue cross-reference · dimensions and weight'),
  ('haynespro',      'HaynesPro WorkshopData — Toyota Camry XV70','NULL',                                                                      '2026-05-14 00:00:00', 'Maintenance intervals, torque, fluid capacities · authenticated session');

SET @src_oem    := (SELECT id FROM sources WHERE citation LIKE 'Toyota 2020%' ORDER BY id DESC LIMIT 1);
SET @src_ad     := (SELECT id FROM sources WHERE citation LIKE 'Auto-Data.net — Toyota Camry%' ORDER BY id DESC LIMIT 1);
SET @src_us     := (SELECT id FROM sources WHERE citation LIKE 'Ultimatespecs.com — Toyota Camry%' ORDER BY id DESC LIMIT 1);
SET @src_haynes := (SELECT id FROM sources WHERE citation LIKE 'HaynesPro WorkshopData — Toyota Camry%' ORDER BY id DESC LIMIT 1);

-- ===================================================================
-- MAKE / MODEL / GENERATION
-- ===================================================================

INSERT INTO makes (slug, name, country_of_origin) VALUES ('toyota', 'Toyota', 'JP');
SET @make_id := LAST_INSERT_ID();

INSERT INTO models (make_id, slug, name) VALUES (@make_id, 'camry', 'Camry');
SET @model_id := LAST_INSERT_ID();

INSERT INTO generations
  (model_id, slug, ordinal, codename, display_name, body_type, start_year, end_year, layout, platform)
VALUES
  (@model_id, 'camry-xv70-2018-2024', 8, 'XV70', 'Camry (XV70)', 'sedan', 2018, 2024, 'FF', 'TNGA-K');
SET @gen_id := LAST_INSERT_ID();

INSERT INTO generation_markets (generation_id, market_id, start_year, end_year)
SELECT @gen_id, id, 2018, 2024 FROM markets WHERE code IN ('US','CA','EU','UK','JDM','AU');

SET @mk_us := (SELECT id FROM markets WHERE code='US');
SET @mk_eu := (SELECT id FROM markets WHERE code='EU');

-- ===================================================================
-- ENGINES
-- ===================================================================

INSERT INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('A25A-FKS', '2.5 L Dynamic Force',   2487, 'gasoline', 'NA',  'DOHC 16v Dual VVT-iE · D-4S DI+PI', 4, 87.5, 103.4, 13.00),
  ('A25A-FXS', '2.5 L hybrid Atkinson', 2487, 'hybrid',   'NA',  'DOHC 16v Atkinson · Dual VVT-i',     4, 87.5, 103.4, 14.00),
  ('2GR-FKS',  '3.5 L V6',              3456, 'gasoline', 'NA',  'DOHC 24v Dual VVT-iW · D-4S',        6, 94.0,  83.0, 11.80);

SET @eng_25  := (SELECT id FROM engines WHERE code='A25A-FKS');
SET @eng_hyb := (SELECT id FROM engines WHERE code='A25A-FXS');
SET @eng_v6  := (SELECT id FROM engines WHERE code='2GR-FKS');

-- ===================================================================
-- TRANSMISSIONS
-- ===================================================================

INSERT INTO transmissions (type, gears, display_name) VALUES
  ('AT',  8, 'Toyota UB80E · 8-speed AT'),
  ('CVT', 0, 'Toyota P710 eCVT (hybrid)');

SET @tx_8at := (SELECT id FROM transmissions WHERE display_name LIKE 'Toyota UB80E%');
SET @tx_ecvt := (SELECT id FROM transmissions WHERE display_name LIKE 'Toyota P710%');

-- ===================================================================
-- TRIMS (US-market headline)
-- ===================================================================

INSERT INTO trims (generation_id, market_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, fuel_combined_l_100km, co2_g_km, curb_weight_kg) VALUES
  (@gen_id, @mk_us, 'le',           'LE',           @eng_25,  @tx_8at,  2018, 2024, 203, 250, 7.5, 217, 7.5, 174, 1470),
  (@gen_id, @mk_us, 'se',           'SE',           @eng_25,  @tx_8at,  2018, 2024, 206, 252, 7.5, 217, 7.7, 178, 1490),
  (@gen_id, @mk_us, 'xle',          'XLE',          @eng_25,  @tx_8at,  2018, 2024, 203, 250, 7.5, 217, 7.5, 174, 1525),
  (@gen_id, @mk_us, 'xse-v6',       'XSE V6',       @eng_v6,  @tx_8at,  2018, 2024, 301, 362, 5.8, 218, 9.7, 226, 1610),
  (@gen_id, @mk_us, 'le-hybrid',    'LE Hybrid',    @eng_hyb, @tx_ecvt, 2018, 2024, 208, 221, 7.6, 217, 4.8, 110, 1583);

SET @trim_le      := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='le');
SET @trim_xse_v6  := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='xse-v6');
SET @trim_hybrid  := (SELECT id FROM trims WHERE generation_id=@gen_id AND slug='le-hybrid');

-- ===================================================================
-- FLUID SPECS
-- ===================================================================

INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
VALUES
  (@gen_id, @trim_le, @mk_us, 'engine_oil', 4.40, 4.50, '0W-16', 'API SP / ILSAC GF-6', '04152-YZZA6',
   10000, 16000, 12, 'With filter · 0W-20 acceptable substitute in cold climates · Toyota Genuine preferred');
SET @fs1 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs1, @src_oem), ('fluid_specs', @fs1, @src_haynes);

INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
VALUES
  (@gen_id, @trim_xse_v6, @mk_us, 'engine_oil_v6', 6.10, 6.40, '0W-20', 'API SP / ILSAC GF-6', '04152-31110', 10000, 16000, 12);
SET @fs2 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs2, @src_oem), ('fluid_specs', @fs2, @src_haynes);

INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
VALUES
  (@gen_id, @trim_hybrid, @mk_us, 'engine_oil_hybrid', 4.40, 4.50, '0W-16', 'API SP / ILSAC GF-6', '04152-YZZA6', 10000, 16000, 12);
SET @fs3 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs3, @src_oem), ('fluid_specs', @fs3, @src_haynes);

-- ATF (8-speed) — Toyota WS, drain-and-fill capacity
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_id, NULL, NULL, 'transmission_at', 3.60, 3.80, 'Toyota WS (World Standard)', 60000, 96000, '8-speed AT · Toyota labels as "lifetime" but most independent shops change at 60k. Total capacity ~6.6 qt.');
SET @fs4 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs4, @src_oem), ('fluid_specs', @fs4, @src_haynes);

-- Coolant
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_months)
VALUES
  (@gen_id, NULL, NULL, 'coolant', 9.10, 9.60, 'Toyota Super Long Life Coolant (SLLC) pink', 100000, 120);
SET @fs5 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs5, @src_oem), ('fluid_specs', @fs5, @src_haynes);

-- Brake fluid
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, viscosity, spec_standard, drain_interval_months)
VALUES
  (@gen_id, NULL, NULL, 'brake', 'DOT 3', 'Toyota Genuine preferred', 36);
SET @fs6 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs6, @src_oem), ('fluid_specs', @fs6, @src_haynes);

-- A/C refrigerant
INSERT INTO fluid_specs
  (generation_id, trim_id, market_id, fluid_type, capacity_l, spec_standard, notes)
VALUES
  (@gen_id, NULL, @mk_us, 'ac_refrigerant', 0.485, 'R-1234yf · PAG 46', 'Charge weight 485 g · 2018+ US-market');
SET @fs7 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('fluid_specs', @fs7, @src_oem), ('fluid_specs', @fs7, @src_haynes);

-- ===================================================================
-- ELECTRICAL
-- ===================================================================

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, NULL, '35', 640, 60, 130);
SET @es1 := LAST_INSERT_ID();
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES ('electrical_specs', @es1, @src_oem), ('electrical_specs', @es1, @src_haynes);

-- ===================================================================
-- TORQUE
-- ===================================================================

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       103, 76,  'Star pattern · 4-step torque'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'Iridium NGK ILKAR8L11 · gap pre-set, do not adjust'),
  (@gen_id, NULL, 'oil_drain',     40,  30,  'Single-use crush washer 90430-12031'),
  (@gen_id, NULL, 'wheel_hub_nut', 186, 137, 'Front and rear'),
  (@gen_id, NULL, 'caliper_bolt',  34,  25,  'Slide-pin bolt, M12');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_haynes FROM torque_specs WHERE generation_id=@gen_id;

-- ===================================================================
-- BULBS
-- ===================================================================

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'LED',  2, 1),
  (@gen_id, NULL, 'headlight_high',  '9005', 2, 0),
  (@gen_id, NULL, 'fog_front',       'H11',  2, 0),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         '921',  2, 0),
  (@gen_id, NULL, 'license_plate',   '168',  2, 0),
  (@gen_id, NULL, 'interior_dome',   '6418', 1, 0),
  (@gen_id, NULL, 'interior_map',    '6418', 2, 0),
  (@gen_id, NULL, 'glove_box',       '194',  1, 0),
  (@gen_id, NULL, 'trunk',           '194',  1, 0),
  (@gen_id, NULL, 'side_marker',     '194',  4, 0);

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id=@gen_id;

-- ===================================================================
-- FUSES (sample)
-- ===================================================================

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F1',  120, 'Alternator main'),
  (@gen_id, NULL, 'under_hood', 'F2',  60,  'ABS motor'),
  (@gen_id, NULL, 'under_hood', 'F3',  50,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F4',  40,  'Radiator fan'),
  (@gen_id, NULL, 'under_hood', 'F8',  20,  'Ignition coil'),
  (@gen_id, NULL, 'under_hood', 'F11', 15,  'Fuel pump'),
  (@gen_id, NULL, 'under_hood', 'F12', 10,  'ECU power'),
  (@gen_id, NULL, 'cabin',      'B1',  7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'B2',  10,  'Audio'),
  (@gen_id, NULL, 'cabin',      'B5',  20,  'Power window · driver'),
  (@gen_id, NULL, 'cabin',      'B6',  20,  'Power window · passenger'),
  (@gen_id, NULL, 'cabin',      'B9',  30,  'Heater blower'),
  (@gen_id, NULL, 'cabin',      'B12', 15,  'Sunroof');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id=@gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================

INSERT INTO parts (generation_id, trim_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, @trim_le,      NULL, 'spark_plug',    'NGK ILKAR8L11',  'NGK',     1.10, NULL, '2.5 NA · iridium'),
  (@gen_id, @trim_xse_v6,  NULL, 'spark_plug',    'DENSO FK20HR11', 'DENSO',   1.10, NULL, '3.5 V6 · 6× iridium'),
  (@gen_id, NULL,          NULL, 'oil_filter',    '04152-YZZA6',     'Toyota', NULL,  NULL, 'Cartridge type · 2.5 NA + hybrid'),
  (@gen_id, NULL,          NULL, 'oil_filter_v6', '04152-31110',     'Toyota', NULL,  NULL, '3.5 V6 only'),
  (@gen_id, NULL,          NULL, 'air_filter',    '17801-0P051',     'Toyota', NULL,  NULL, '2.5 NA + hybrid'),
  (@gen_id, NULL,          NULL, 'cabin_filter',  '87139-0E040',     'Toyota', NULL,  NULL, NULL),
  (@gen_id, NULL,          NULL, 'wiper_front_d', '85222-06180',     'Toyota', NULL,  '26 in', 'Driver side'),
  (@gen_id, NULL,          NULL, 'wiper_front_p', '85222-06170',     'Toyota', NULL,  '18 in', 'Passenger side');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_haynes FROM parts WHERE generation_id=@gen_id;

-- ===================================================================
-- SERVICE INTERVALS
-- ===================================================================

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',     10000, 5000,  16000, 8000,  12, '4.5 qt 0W-16 (2.5) · 6.4 qt 0W-20 (V6)'),
  (@gen_id, NULL, 'tire_rotation',             5000,  NULL,  8000,  NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',          10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',         30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',          30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',     60000, 30000, 96000, 48000, NULL, 'Toyota labels lifetime; independents change at 60k'),
  (@gen_id, NULL, 'brake_fluid_flush',         NULL,  NULL,  NULL,  NULL,  36, 'Time-based · DOT 3'),
  (@gen_id, NULL, 'spark_plugs',               120000, NULL, 192000, NULL, NULL, 'NGK ILKAR8L11 · iridium'),
  (@gen_id, NULL, 'coolant_flush',             100000, NULL, 160000, NULL, 120, 'First service then 50k thereafter'),
  (@gen_id, NULL, 'drive_belt_inspection',     60000,  NULL, 96000,  NULL, NULL, NULL),
  (@gen_id, NULL, 'tpms_sensor_battery',       100000, NULL, 160000, NULL, NULL, NULL);

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id=@gen_id;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_haynes FROM service_intervals WHERE generation_id=@gen_id;

-- ===================================================================
-- TIRE PRESSURES
-- ===================================================================

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, @mk_us, 'front', 'normal',   35, 240, '215/55 R17 94V'),
  (@gen_id, @mk_us, 'rear',  'normal',   33, 230, '215/55 R17 94V'),
  (@gen_id, @mk_us, 'spare', 'normal',   60, 420, 'T155/70 D17 compact');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id=@gen_id;

-- ===================================================================
-- VERIFY
-- ===================================================================

SELECT
  (SELECT COUNT(*) FROM generations WHERE id=@gen_id) AS generations,
  (SELECT COUNT(*) FROM trims WHERE generation_id=@gen_id) AS trims,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen_id) AS fluids,
  (SELECT COUNT(*) FROM electrical_specs WHERE generation_id=@gen_id) AS electrical,
  (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen_id) AS torques,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id=@gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses WHERE generation_id=@gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts WHERE generation_id=@gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures WHERE generation_id=@gen_id) AS tires,
  (SELECT COUNT(*) FROM spec_sources) AS total_citations;
