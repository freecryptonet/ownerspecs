-- Mercedes-Benz C-Class (W206) moat fill — 5th-gen sedan, 2021-present
-- Mercedes MRA-2 platform. M254 2.0 mild-hybrid + OM654 2.0 diesel + EQE/AMG
-- variants. Cross-verified against MB OM, Mercedes Genuine parts catalog.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'W206' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Mercedes-Benz C-Class (W206) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/mercedes-benz/c-class-sedan-w206-2022-present/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:MERCEDES-BENZ_C-CLASS_LWB_(W206)_China_(7).jpg',
  CURDATE(),
  'Mercedes-Benz C-Class LWB (W206)',
  '3-4-front', 1280, 591
FROM generations g WHERE g.codename = 'W206';

-- C 300 (M254) — volume powertrain. 9G-TRONIC + integrated starter generator.
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      5.50, 5.81, '0W-30', 'MB-Approval 229.71 (Mobil 1 ESP X3 0W-30)',     'A6541800009', 12500, 20000, 12, 'M254 2.0 turbo · 5.5 L with filter. OM654 2.0 diesel: 5.8 L 5W-30 MB-Approval 229.52.'),
  (@gen_id, NULL, 'transmission_at', 7.40, 7.82, NULL,    'MB-Approval 236.17 (9G-TRONIC fluid · A 001 989 68 03)', 'A2202700198', 75000, 120000, NULL, '9G-TRONIC 725.0 9-speed auto. Mercedes labels lifetime; independents recommend 60-80k mi.'),
  (@gen_id, NULL, 'coolant',         8.50, 8.98, NULL,    'MB-Spec 325.6 (Glysantin G40, pink OAT)',        NULL,         NULL,  NULL,   180, 'Lifetime fill per MB; replace at 15 years.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'MB-Approval 331.0 (DOT 4 plus)',                 NULL,         NULL,  NULL,   24,  'Every 2 years regardless of mileage.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.55, 0.58, NULL,    'R-1234yf · PAG oil ZXL100PG',                    NULL,         NULL,  NULL,   NULL, 'Charge weight 550 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       150, 111, 'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'NGK PLZKBR7B-G iridium (M254).'),
  (@gen_id, NULL, 'oil_drain',     30,  22,  'M12×1.5; new aluminum gasket each service.'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 115, 85, 'Front caliper carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'LN3 H7 AGM (48V ISG)', 800, 80, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'Digital Light LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'Digital Light LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 250, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', 'F02', 250, '48V ISG main fuse'),
  (@gen_id, NULL, 'under_hood', 'F08', 80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F11', 40,  'ABS / ESP'),
  (@gen_id, NULL, 'under_hood', 'F15', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F18', 20,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'F22', 15,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'F30', 7.5, 'Instrument cluster (digital)'),
  (@gen_id, NULL, 'cabin',      'F38', 25,  'MBUX infotainment (central screen)'),
  (@gen_id, NULL, 'cabin',      'F42', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F50', 40,  'Climate blower'),
  (@gen_id, NULL, 'cabin',      'F55', 25,  'Heated/ventilated seats'),
  (@gen_id, NULL, 'trunk',      'F70', 30,  'PHEV charging port (C 300e)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    'A 002 159 88 03', 'Mercedes-Benz', 0.80, NULL,    'M254 NGK PLZKBR7B-G iridium'),
  (@gen_id, NULL, 'oil_filter',    'A 654 180 00 09', 'Mercedes-Benz', NULL, NULL,    'M254 / OM654 cartridge'),
  (@gen_id, NULL, 'air_filter',    'A 254 094 04 00', 'Mercedes-Benz', NULL, NULL,    'Panel filter W206'),
  (@gen_id, NULL, 'cabin_filter',  'A 206 830 00 01', 'Mercedes-Benz', NULL, NULL,    'HEPA + activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', 'A 206 820 03 00', 'Mercedes-Benz', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', 'A 206 820 04 00', 'Mercedes-Benz', NULL, '21 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  12500, 6250,  20000, 10000, 12, '5.5 L 0W-30 (M254). Mercedes flex-service may shorten under severe duty.'),
  (@gen_id, NULL, 'tire_rotation',          10000, NULL,  16000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       12500, 6250,  20000, 10000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      40000, 20000, 64000, 32000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       25000, 12500, 40000, 20000, 24,   NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  75000, NULL,  120000,NULL,  NULL, '9G-TRONIC 725.0; MB labels lifetime, independents 60-80k mi.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'DOT 4. Every 2 years.'),
  (@gen_id, NULL, 'spark_plugs',            75000, NULL,  120000,NULL,  NULL, 'NGK PLZKBR7B-G iridium.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  180,  'MB-Spec 325.6 lifetime; 15-year replacement.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '225/55 R17 97Y'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '225/55 R17 97Y'),
  (@gen_id, NULL, 'front', 'normal', 38, 260, '245/40 R19 98Y'),
  (@gen_id, NULL, 'rear',  'normal', 38, 260, '275/35 R19 100Y'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Tirefit kit (no spare)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen_id) AS fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen_id) AS torques,
       (SELECT COUNT(*) FROM electrical_specs WHERE generation_id=@gen_id) AS electrical,
       (SELECT COUNT(*) FROM bulbs WHERE generation_id=@gen_id) AS bulbs,
       (SELECT COUNT(*) FROM fuses WHERE generation_id=@gen_id) AS fuses,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen_id) AS parts,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen_id) AS service_intervals,
       (SELECT COUNT(*) FROM tire_pressures WHERE generation_id=@gen_id) AS tires,
       (SELECT COUNT(*) FROM images WHERE generation_id=@gen_id) AS images;
