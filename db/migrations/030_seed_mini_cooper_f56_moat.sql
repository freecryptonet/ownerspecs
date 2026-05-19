-- Mini Cooper (F56) moat fill — 3rd-gen 3-door hatchback, 2014-2018
-- Cross-verified against startmycar.com fuse-box (2017 Cooper, 75 positions
-- extracted live), HaynesPro WorkshopData, Mini OM, Mini Genuine parts catalog.
-- UKL platform shared with BMW X1 F48. Engines: B38A12 1.2 / B38A15 1.5 turbo
-- 3-cyl, B46A20 / B48A20 2.0 turbo 4-cyl (Cooper S / JCW), B37C15 1.5 diesel.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'F56' AND display_name LIKE 'Cooper%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Mini Cooper (F56) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/mini/cooper-f56-hatchback-2014-2018/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2021_Mini_Hatch_(F56)_John_Cooper_Works_1X7A0150.jpg',
  CURDATE(), '2021 Mini Hatch (F56) John Cooper Works', '3-4-front', 1280, 813
FROM generations g WHERE g.id = @gen_id;

-- 1.5 B38A15 turbo 3-cyl (Cooper) — volume powertrain
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.25, 4.50, '0W-30', 'BMW Longlife-12 FE (LL-12 FE) / API SN+',     '11428583898', 10000, 16000, 12, '1.5 B38 turbo · 4.5 US qt with filter. 2.0 B46/B48 (Cooper S/JCW): 5.2 qt 0W-30 LL-12 FE. 1.5 B37 diesel: 4.0 qt 0W-30 LL-04.'),
  (@gen_id, NULL, 'transmission_at', 6.50, 6.87, NULL,    'Aisin AW-1 ATF (BMW 83 22 2 152 426)',          NULL,         100000,160000, NULL, '6-speed auto (1.5 N18); 7-speed DCT (2.0 B48 Cooper S/JCW Steptronic). Mini labels lifetime.'),
  (@gen_id, NULL, 'transmission_mt', 1.65, 1.74, NULL,    'BMW MTF-LT-3 (83 22 0 309 031)',                NULL,         60000, 96000,  NULL, '6-speed Getrag GS6 manual gearbox.'),
  (@gen_id, NULL, 'coolant',         6.20, 6.55, NULL,    'BMW HT-12 (blue, pre-mixed, 81 22 2 357 506)', NULL,         NULL,  NULL,   NULL, 'Lifetime fill per Mini/BMW.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'BMW DOT 4 LV (83 13 0 437 779)',                NULL,         NULL,  NULL,   24,   'Every 2 years.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-1234yf · PAG oil PAG46',                       NULL,         NULL,  NULL,   NULL, '500 ±20 g; EU 2017+ R-1234yf, US 2018+.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       140, 103, 'M14×1.25; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    28,  21,  'NGK ILZKAR8H8S iridium (B38/B48 BMW-spec).'),
  (@gen_id, NULL, 'oil_drain',     25,  18,  'M12×1.5; new aluminum gasket.'),
  (@gen_id, NULL, 'caliper_bolt',  30,  22,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 110, 81, 'Front carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'LN2 H6 AGM', 580, 70, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'H7 (LED Matrix opt)', 2, 0),
  (@gen_id, NULL, 'headlight_high', 'H7 (LED Matrix opt)', 2, 0),
  (@gen_id, NULL, 'fog_front',      'H8', 2, 0),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'PY24W', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED (Union Jack opt 2018+)', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'PY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — REAL DATA from startmycar.com /mini/cooper/info/fusebox/2017
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'cabin',      '31', 50,  'Heated Windscreen Relay'),
  (@gen_id, NULL, 'cabin',      '32', 40,  'Body Domain Controller'),
  (@gen_id, NULL, 'cabin',      '34', 40,  'Blower Output Stage'),
  (@gen_id, NULL, 'cabin',      '35', 50,  'Body Domain Controller (secondary)'),
  (@gen_id, NULL, 'cabin',      '37', 5,   'Parking Brake Button'),
  (@gen_id, NULL, 'cabin',      '44', 20,  'Right Headlight'),
  (@gen_id, NULL, 'cabin',      '47', 20,  'Left Headlight'),
  (@gen_id, NULL, 'cabin',      '51', 5,   'Base Plate Fan'),
  (@gen_id, NULL, 'cabin',      '55', 4,   'Reversing Camera / Parking Assistant'),
  (@gen_id, NULL, 'cabin',      '61', 20,  'Headunit (Radio / Navigation)'),
  (@gen_id, NULL, 'cabin',      '65', 20,  'Front Cigarette Lighter (12V power socket)'),
  (@gen_id, NULL, 'cabin',      '66', 20,  'Electric Fuel Pump Control Electronics'),
  (@gen_id, NULL, 'cabin',      '72', 5,   'Electric Fan Cut-Out Relay'),
  (@gen_id, NULL, 'cabin',      '73', 10,  'Driver Seat Backrest (Valve Block)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '12120039664', 'Mini/BMW', 0.80, NULL,    'B38/B48 NGK ILZKAR8H8S iridium'),
  (@gen_id, NULL, 'oil_filter',    '11428583898', 'Mini/BMW', NULL, NULL,    'Cartridge; B38 1.5 / B46 2.0'),
  (@gen_id, NULL, 'air_filter',    '13718580428', 'Mini/BMW', NULL, NULL,    'Panel filter F56'),
  (@gen_id, NULL, 'cabin_filter',  '64119237555', 'Mini/BMW', NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '61617242147', 'Mini',     NULL, '22 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '61617242148', 'Mini',     NULL, '18 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, 'BMW CBS — Mini Connected push.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  100000,60000, 160000,96000, NULL, '6AT Aisin AW-1.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'BMW DOT 4 LV.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK ILZKAR8H8S.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'BMW HT-12 lifetime fill.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '175/65 R15 84T'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '175/65 R15 84T'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '195/55 R16 87V (Cooper)'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '195/55 R16 87V (Cooper)'),
  (@gen_id, NULL, 'front', 'normal', 38, 260, '205/40 R18 86W (JCW)'),
  (@gen_id, NULL, 'rear',  'normal', 38, 260, '205/40 R18 86W (JCW)'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Run-flat — no spare provided');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
