-- Lexus RX (AL20) moat fill — 4th-gen SUV, 2015-2022 global
-- Cross-verified against HaynesPro WorkshopData, Lexus OM, Toyota Genuine
-- parts catalog. 2GR-FKS 3.5 V6 + 2GR-FXS V6 hybrid (450h).

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'AL20' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Lexus RX (AL20) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/lexus/rx-al20-suv-2015-2022/hero.jpg', 'wikimedia', 'cc-by-sa-2.0',
  'Zytonits / Wikimedia Commons, CC BY-SA 2.0',
  'https://commons.wikimedia.org/wiki/File:Lexus_RX_350_1_(32583535501).jpg',
  CURDATE(), 'Lexus RX 350 (AL20)', '3-4-front', 1280, 960
FROM generations g WHERE g.id = @gen_id;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      6.10, 6.45, '0W-20', 'API SP / ILSAC GF-6 (Toyota/Lexus Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12, '2GR-FKS 3.5 V6 · 6.45 US qt with filter. 450h hybrid 2GR-FXS: 6.4 qt 0W-20.'),
  (@gen_id, NULL, 'transmission_at', 9.50, 10.04, NULL,   'Toyota WS ATF (08886-02305)',                     NULL,         60000, 96000, NULL, '8-speed AT (U880F); hybrid uses eCVT (no scheduled fluid service).'),
  (@gen_id, NULL, 'coolant',         8.30, 8.77, NULL,    'Toyota Super Long Life Coolant (pink, pre-mixed)', NULL,        100000,160000, 120, 'First replacement 10 yr / 100k mi.'),
  (@gen_id, NULL, 'rear_differential',1.10, 1.16, NULL,   'Toyota Genuine 75W-85 GL-5',                      NULL,         60000, 96000, NULL, 'AWD only.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'FMVSS 116 DOT 3',                                  NULL,         30000, 48000, 30,   'Mileage or time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.55, 0.58, NULL,    'R-1234yf · PAG oil ND-12',                        NULL,         NULL,  NULL,   NULL, '550 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       103, 76,  'M12×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'Denso SK20HR11 iridium (2GR-FKS).'),
  (@gen_id, NULL, 'oil_drain',     40,  30,  'M12×1.25; new gasket (90430-12031).'),
  (@gen_id, NULL, 'caliper_bolt',  34,  25,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 107, 79, 'Front carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'H7 / LN3 AGM', 760, 80, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'WY21W', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo',          'W5W', 2, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'ALT',  140, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'AM1',  40,  'Ignition switch'),
  (@gen_id, NULL, 'under_hood', 'ABS1', 50,  'ABS / VSC'),
  (@gen_id, NULL, 'under_hood', 'EPS',  80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'RDI',  30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'EFI MAIN', 30, 'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'IG COIL', 15, 'Ignition coils'),
  (@gen_id, NULL, 'cabin',      'METER', 7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'AUDIO', 15,  'Mark Levinson audio'),
  (@gen_id, NULL, 'cabin',      'PW-D',  25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'PW-P',  25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'A/C',   30,  'Heater blower'),
  (@gen_id, NULL, 'cabin',      'SEAT HTR', 20, 'Heated/ventilated seats');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '90919-01253',   'Toyota/Lexus', 1.10, NULL,    '2GR-FKS Denso SK20HR11'),
  (@gen_id, NULL, 'oil_filter',    '04152-YZZA1',   'Toyota/Lexus', NULL, NULL,    'Cartridge'),
  (@gen_id, NULL, 'air_filter',    '17801-0P051',   'Toyota/Lexus', NULL, NULL,    'Panel filter'),
  (@gen_id, NULL, 'cabin_filter',  '87139-0E040',   'Toyota/Lexus', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '85222-0E070',   'Toyota/Lexus', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '85242-0E020',   'Toyota/Lexus', NULL, '20 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, NULL),
  (@gen_id, NULL, 'tire_rotation',          5000,  NULL,  8000,  NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  60000, 30000, 96000, 48000, NULL, '8AT Toyota WS.'),
  (@gen_id, NULL, 'rear_differential_fluid',60000, 30000, 96000, 48000, NULL, 'AWD only.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            120000,NULL,  192000,NULL,  NULL, 'Denso SK20HR11 iridium.'),
  (@gen_id, NULL, 'coolant_flush',          100000,NULL,  160000,NULL,  120,  'Toyota Super LLC.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '235/65 R18 106V'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/65 R18 106V'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/55 R20 102V'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '235/55 R20 102V'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T155/90 D17 compact');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
