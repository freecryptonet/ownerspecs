-- Skoda Octavia (Mk4) moat fill — 4th-gen liftback, 2020-2025 global
-- Shares MQB Evo platform with VW Golf Mk8. EA211 evo + EA288 evo engines.
-- Cross-verified against HaynesPro WorkshopData, Skoda OM, VW Group parts catalog.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'Mk4' AND display_name LIKE 'Octavia%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Skoda Octavia (Mk4) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/skoda/octavia-mk4-liftback-2020-2025/hero.jpg', 'wikimedia', 'cc-by-4.0',
  'Harvey Bold / Wikimedia Commons, CC BY 4.0',
  'https://commons.wikimedia.org/wiki/File:2020_Skoda_Octavia_vRS_Challenge_TSI.jpg',
  CURDATE(), '2020 Skoda Octavia vRS (Mk4)', '3-4-front', 1280, 633
FROM generations g WHERE g.id = @gen_id;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.30, 4.55, '0W-20', 'VW 508 00 (shared with Golf Mk8 EA211 evo)',         '04E115561H', 18000, 30000, 24, '1.5 TSI EA211 evo · 4.3 L. 2.0 TSI EA888 (vRS): 5.7 L 0W-20 VW 508 00.'),
  (@gen_id, NULL, 'transmission_dsg',1.90, 2.01, NULL,    'VW G 052 529 A2 (DQ381 wet)',                        'O2E398029',  37500, 60000, 60,  '7-speed DSG wet. DQ200 dry on 1.0 TSI = lifetime fill.'),
  (@gen_id, NULL, 'coolant',         7.20, 7.61, NULL,    'VW G 13 (purple, pre-mixed)',                        NULL,         NULL,  NULL,   NULL, 'Lifetime fill.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'VW TL 766-Z (DOT 4 LV)',                             NULL,         NULL,  NULL,   36,   'Every 3 years.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.45, 0.48, NULL,    'R-1234yf · PAG oil PAG46',                           NULL,         NULL,  NULL,   NULL, '450 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       120, 89,  'M14×1.5.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'NGK PFR7S8EG double iridium.'),
  (@gen_id, NULL, 'oil_drain',     30,  22,  'M14×1.5; new aluminum gasket.'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 190, 140, 'Front carrier-to-knuckle — replace once.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'LN3 H7 AGM', 760, 80, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo',          'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'SC1',  500, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', 'SC2',  150, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'SC3',  80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'SC4',  50,  'ABS'),
  (@gen_id, NULL, 'under_hood', 'SC10', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'SC15', 15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'SC18', 15,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'SB5',  7.5, 'Virtual cockpit'),
  (@gen_id, NULL, 'cabin',      'SB8',  15,  'Infotainment MIB3'),
  (@gen_id, NULL, 'cabin',      'SD25', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'SD30', 30,  'Heater blower'),
  (@gen_id, NULL, 'trunk',      'SE5',  20,  'PHEV charging port (iV only)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '04E905614C',     'Skoda/VW', 0.80, NULL,    '1.5 TSI EA211 evo iridium'),
  (@gen_id, NULL, 'oil_filter',    '04E115561H',     'Skoda/VW', NULL, NULL,    'Cartridge (shared with Golf Mk8)'),
  (@gen_id, NULL, 'air_filter',    '5Q0129620E',     'Skoda/VW', NULL, NULL,    'Panel filter MQB Evo'),
  (@gen_id, NULL, 'cabin_filter',  '5WA819644',      'Skoda/VW', NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '5H1955425',      'Skoda/VW', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '5H1955426',      'Skoda/VW', NULL, '19 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  18000, 9000,  30000, 15000, 24, 'Skoda LongLife.'),
  (@gen_id, NULL, 'tire_rotation',          10000, NULL,  16000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       18000, 9000,  30000, 15000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      36000, 18000, 60000, 30000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       18000, NULL,  30000, NULL,  24,   NULL),
  (@gen_id, NULL, 'transmission_dsg_fluid', 37500, NULL,  60000, NULL,  60,   'DQ381 wet only.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  36,   'Every 3 years.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK PFR7S8EG.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'VW G 13 lifetime fill.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '205/55 R16 91H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '205/55 R16 91H'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '225/40 R18 92Y'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '225/40 R18 92Y'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Tirefit kit (no spare)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
