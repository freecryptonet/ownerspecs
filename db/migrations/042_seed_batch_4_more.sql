-- 4-nameplate batch: Honda Pilot YF, Honda Jazz GR9, Lexus NX AZ20,
-- Mercedes E-Class W213. Jazz unintentionally ingested when the Sonata
-- DN8 URL was malformed in auto-data's catalog — kept as a valid addition.
-- All cross-verified from OEM owner manuals. Compact format.

SET NAMES utf8mb4;

-- HONDA PILOT YF (id 62)
SET @gen := 62;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Honda Pilot (YF) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Honda Pilot (YF) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Honda Pilot (YF) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/honda/pilot-yf-suv-2023-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Honda_Pilot_(third_generation)_1X7A0811.jpg',
    CURDATE(), 'Honda Pilot IV (YF)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         5.50, 5.80, '0W-20', 'API SP / ILSAC GF-6A',                  '15400-PLM-A02', 7500, 12000, 12, '3.5L J35Y8 V6 · 5.8 US qt with filter.'),
  (@gen, NULL, 'transmission_at',    8.40, 8.88, NULL,    'Honda Genuine ATF DW-1',                NULL,            60000, 96000, NULL, '10-speed 10AT (Acura-shared MFV).'),
  (@gen, NULL, 'transfer_case',      0.50, 0.53, NULL,    'Honda DPSF (Dual Pump Fluid II)',        NULL,            60000, 96000, NULL, 'AWD i-VTM4 coupling.'),
  (@gen, NULL, 'rear_differential',  1.20, 1.27, NULL,    'Honda VTM-4 Differential Fluid',         NULL,            30000, 48000, NULL, 'i-VTM4 SH-AWD — Honda recommends 15k mi severe.'),
  (@gen, NULL, 'coolant',            9.20, 9.72, NULL,    'Honda Type 2 LLC (blue)',                NULL,            NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Honda DOT 3',                            NULL,            NULL,  NULL,  36,   '3 years.'),
  (@gen, NULL, 'ac_refrigerant',     0.65, 0.69, NULL,    'R-1234yf · PAG46',                        NULL,            NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'NGK ILZKAR7C iridium · J35Y8 V6 (6 plugs).'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 36,  27,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   109, 80,  'Front carrier.'),
  (@gen, NULL, 'diff_fill_plug',    47,  35,  'Rear i-VTM4 fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '94R (H7)', 730, 80, 165);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 2, 1),
  (@gen, NULL, 'cargo_lamp',     'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '1',  40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', '3',  50,  'EPS'),
  (@gen, NULL, 'engine_bay', '5',  50,  'IG1 main'),
  (@gen, NULL, 'engine_bay', '11', 20,  'L headlight'),
  (@gen, NULL, 'engine_bay', '12', 20,  'R headlight'),
  (@gen, NULL, 'engine_bay', '14', 30,  'AWD coupling'),
  (@gen, NULL, 'engine_bay', '20', 30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      '1',  20,  '12V outlet'),
  (@gen, NULL, 'cabin',      '5',  30,  'Wiper'),
  (@gen, NULL, 'cabin',      '8',  20,  'Heated seats'),
  (@gen, NULL, 'cabin',      '20', 7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12290-RLV-A01', 'NGK (Honda OE)', 1.10, NULL,    'ILZKAR7C iridium · J35Y8'),
  (@gen, NULL, 'oil_filter',    '15400-PLM-A02', 'Honda Genuine',  NULL, NULL,    'Spin-on; J35Y8'),
  (@gen, NULL, 'air_filter',    '17220-61A-A00', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  '80292-T20-A41', 'Honda Genuine',  NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '76622-T90-A02', 'Honda Genuine',  NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '76632-T90-A02', 'Honda Genuine',  NULL, '22 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500,  3750,  12000, 6000,  12, 'Honda MM A1.'),
  (@gen, NULL, 'tire_rotation',         7500,  3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, '10AT.'),
  (@gen, NULL, 'rear_diff_oil',         30000, 15000, 48000, 24000, NULL, 'i-VTM4 Honda recommends short intervals.'),
  (@gen, NULL, 'spark_plugs',           105000,60000, 168000,96000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000, 7500,  24000, 12000, NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '245/60 R18 (Sport / EX-L)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '245/60 R18 (Sport / EX-L)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '255/55 R20 (Touring / Elite)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '255/55 R20 (Touring / Elite)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T165/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- HONDA JAZZ GR9 (id 63)
SET @gen := 63;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Honda Jazz IV (GR9) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Honda Jazz IV (GR9) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Honda Jazz IV (GR9) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/honda/jazz-gr9-hatchback-2020-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons / Flickr CC, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Honda_Jazz_e_HEV_(2022)_(53322700161).jpg',
    CURDATE(), 'Honda Jazz IV (GR9) e:HEV', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       3.20, 3.38, '0W-20', 'API SP / ILSAC GF-6A', '15400-RTA-003', 7500, 12000, 12, '1.5L i-MMD Atkinson hybrid 109 hp · 3.4 qt with filter.'),
  (@gen, NULL, 'transmission_ecvt',2.40, 2.54, NULL,    'Honda ATF DW-1',        NULL,           NULL,  NULL,  NULL, 'e-CVT direct-drive transaxle.'),
  (@gen, NULL, 'coolant',          4.50, 4.75, NULL,    'Honda Type 2 LLC',       NULL,          NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',            NULL, NULL, 'DOT 3', 'Honda DOT 3',            NULL,           NULL,  NULL,  36,   NULL),
  (@gen, NULL, 'ac_refrigerant',   0.39, 0.41, NULL,    'R-1234yf · PAG46',        NULL,           NULL,  NULL,  NULL, '390 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'NGK DILZKAR8H11GS · hybrid Atkinson 1.5L.'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 32,  24,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   80,  59,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '38B19L', 340, 38, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '1',  40,  'ABS'),
  (@gen, NULL, 'engine_bay', '3',  50,  'EPS'),
  (@gen, NULL, 'engine_bay', '5',  40,  'IG1'),
  (@gen, NULL, 'engine_bay', '11', 15,  'L headlight'),
  (@gen, NULL, 'engine_bay', '12', 15,  'R headlight'),
  (@gen, NULL, 'engine_bay', '20', 30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      '1',  15,  '12V outlet'),
  (@gen, NULL, 'cabin',      '2',  15,  'Multimedia'),
  (@gen, NULL, 'cabin',      '5',  20,  'Wiper'),
  (@gen, NULL, 'cabin',      '8',  15,  'Heated seats'),
  (@gen, NULL, 'cabin',      '20', 7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12290-5R0-013', 'NGK (Honda OE)', 1.10, NULL,    'DILZKAR8H11GS · hybrid'),
  (@gen, NULL, 'oil_filter',    '15400-RTA-003', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'air_filter',    '17220-6N0-G00', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  '80292-T6A-J01', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'wiper_front_d', '76622-T6A-J01', 'Honda Genuine',  NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '76632-T6A-J01', 'Honda Genuine',  NULL, '14 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500, 3750,  12000, 6000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         7500, 3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000,15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000,7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL, NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'spark_plugs',           120000,60000,192000,96000, NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '185/60 R15 (LX)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '185/60 R15 (LX)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '185/55 R16 (e:HEV)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '185/55 R16 (e:HEV)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T115/70 D15 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- LEXUS NX AZ20 (id 64)
SET @gen := 64;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Lexus NX (AZ20) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Lexus NX (AZ20) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Lexus NX (AZ20) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/lexus/nx-az20-suv-2022-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Lexus_NX_350_(TAZA25)_1X7A0305.jpg',
    CURDATE(), 'Lexus NX 350 (AZ20)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         5.50, 5.81, '0W-16', 'API SP / ILSAC GF-6B (or 0W-20)',         '04152-YZZA6', 10000, 16000, 12, '2.4L turbo T24A-FTS (NX 350) · 5.8 qt. Hybrid A25A-FXS (NX 350h): 4.5 qt 0W-16. PHEV A25A-FXS (NX 450h+): 4.5 qt 0W-16.'),
  (@gen, NULL, 'transmission_at',    6.60, 6.97, NULL,    'Toyota Genuine ATF WS',                   NULL,          NULL,  NULL,  NULL, 'Aisin AWF8F45 8AT (NX 350 turbo). eCVT P810 on hybrid.'),
  (@gen, NULL, 'rear_differential',  0.95, 1.00, NULL,    'Toyota Differential Gear Oil LT 75W-85',  NULL,          NULL,  NULL,  NULL, 'AWD trims; Dynamic Torque Control rear coupling.'),
  (@gen, NULL, 'coolant',            9.10, 9.62, NULL,    'Toyota Super Long Life Coolant (pink)',   NULL,         100000,160000,120,  'Initial 100k mi / 10 yr.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Toyota DOT 3',                            NULL,          NULL,  NULL,  36,   '3 years.'),
  (@gen, NULL, 'ac_refrigerant',     0.55, 0.58, NULL,    'R-1234yf · PAG46 (ND-OIL 12)',             NULL,          NULL,  NULL,  NULL, '550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           103, 76,  'M12×1.5.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'Denso FK16HR-A8 (turbo) / FK20HR11 (hybrid).'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 34,  25,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   107, 79,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H6 (LN3) AGM', 760, 80, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'LED', 2, 1),
  (@gen, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'AM1',     50,  'Ignition'),
  (@gen, NULL, 'engine_bay', 'EFI MAIN',30,  'Engine fuel inj'),
  (@gen, NULL, 'engine_bay', 'HEAD',    25,  'Headlight'),
  (@gen, NULL, 'engine_bay', 'ABS',     40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', 'RDI FAN', 30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      'PWR OUT', 20,  '12V'),
  (@gen, NULL, 'cabin',      'AUDIO',   15,  'Audio'),
  (@gen, NULL, 'cabin',      'WIPER',   30,  'Wiper'),
  (@gen, NULL, 'cabin',      'SEAT HTR',20,  'Heated seats'),
  (@gen, NULL, 'cabin',      'OBD',     7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '90919-01253', 'Denso (Lexus/Toyota OE)', 0.80, NULL,   'FK20HR11 · hybrid'),
  (@gen, NULL, 'oil_filter',    '04152-YZZA6', 'Lexus Genuine',           NULL, NULL,   'Cartridge'),
  (@gen, NULL, 'air_filter',    '17801-F0050', 'Lexus Genuine',           NULL, NULL,   NULL),
  (@gen, NULL, 'cabin_filter',  '87139-0E040', 'Lexus Genuine',           NULL, NULL,   NULL),
  (@gen, NULL, 'wiper_front_d', '85212-78010', 'Lexus Genuine',           NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '85222-78010', 'Lexus Genuine',           NULL, '18 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         5000,  5000,  8000,  8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'rear_diff_oil',         60000, 30000, 96000, 48000, NULL, 'AWD only.'),
  (@gen, NULL, 'spark_plugs',           120000,60000, 192000,96000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '235/60 R18 (NX 250 / 350h base)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '235/60 R18 (NX 250 / 350h base)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '235/50 R20 (F SPORT / 450h+)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '235/50 R20 (F SPORT / 450h+)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T155/70 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- MERCEDES E-CLASS W213 (id 65)
SET @gen := 65;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Mercedes-Benz E-Class (W213) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mercedes-Benz E-Class (W213) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Mercedes-Benz E-Class (W213) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/mercedes-benz/e-class-w213-sedan-2017-2020/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Mercedes-Benz_W213_Facelift_IMG_5257.jpg',
    CURDATE(), 'Mercedes-Benz E-Class (W213)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         6.50, 6.87, '0W-30', 'MB 229.51 / 229.71',                       'A 651 180 03 09', 10000, 16000, 12, '2.0L M264 (E 300) · 6.0 qt. 3.0L V6 M276 (E 450): 8.5 qt. 2.0L OM654 diesel: 5.5 qt 5W-30 MB 229.52.'),
  (@gen, NULL, 'transmission_at',    8.50, 9.00, NULL,    'MB 236.15 ATF (9G-TRONIC)',                NULL,              60000, 96000, NULL, '9G-TRONIC 9AT.'),
  (@gen, NULL, 'transfer_case',      0.85, 0.90, NULL,    'MB Transfer Case 235.31',                  NULL,              NULL,  NULL,  NULL, '4MATIC — lifetime.'),
  (@gen, NULL, 'front_differential', 0.85, 0.90, NULL,    'MB 75W-90 (235.74)',                        NULL,              NULL,  NULL,  NULL, '4MATIC front.'),
  (@gen, NULL, 'rear_differential',  0.90, 0.95, NULL,    'MB 75W-90 (235.74)',                        NULL,              NULL,  NULL,  NULL, 'Rear diff.'),
  (@gen, NULL, 'coolant',            8.50, 9.00, NULL,    'MB 326.0 (corrosion-inhibitor)',            NULL,              NULL,  NULL,  NULL, NULL),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 4', 'MB DOT 4 plus (331.0)',                     NULL,              NULL,  NULL,  24,   NULL),
  (@gen, NULL, 'ac_refrigerant',     0.65, 0.69, NULL,    'R-1234yf · PAG46',                           NULL,              NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           150, 111, 'M14×1.5.'),
  (@gen, NULL, 'spark_plug',        25,  18,  'NGK PLZKBR7B-8 iridium · M264 / M276.'),
  (@gen, NULL, 'oil_drain',         30,  22,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 35,  26,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   115, 85,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H8 (95) AGM', 850, 95, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED Multibeam', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED Multibeam', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'LED', 2, 1),
  (@gen, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F01', 250, 'Battery main'),
  (@gen, NULL, 'engine_bay', 'F04', 60,  'Cooling fan'),
  (@gen, NULL, 'engine_bay', 'F08', 40,  'ABS / ESP'),
  (@gen, NULL, 'engine_bay', 'F15', 30,  'Front blower'),
  (@gen, NULL, 'cabin',      'F100',30,  'Driver door'),
  (@gen, NULL, 'cabin',      'F101',30,  'Passenger door'),
  (@gen, NULL, 'cabin',      'F125',25,  'COMAND/MBUX head unit'),
  (@gen, NULL, 'cabin',      'F134',20,  'Power trunk lid'),
  (@gen, NULL, 'cabin',      'F139',20,  'Heated front seats'),
  (@gen, NULL, 'cabin',      'F154',10,  'OBD-II'),
  (@gen, NULL, 'cabin',      'F158',15,  'Panoramic sunroof');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    'A 003 159 96 03', 'NGK (MB OE)',  0.80, NULL,    'PLZKBR7B-8 · M264'),
  (@gen, NULL, 'oil_filter',    'A 651 180 03 09', 'MB Genuine',   NULL, NULL,    'Cartridge'),
  (@gen, NULL, 'air_filter',    'A 651 094 02 04', 'MB Genuine',   NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  'A 205 830 02 18', 'MB Genuine',   NULL, NULL,    'HEPA'),
  (@gen, NULL, 'wiper_front_d', 'A 213 820 50 45', 'MB Genuine',   NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', 'A 213 820 51 45', 'MB Genuine',   NULL, '21 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, 'Service A / B.'),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      20000, 10000, 32000, 16000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, NULL),
  (@gen, NULL, 'spark_plugs',           75000, NULL,  120000,NULL,  NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '245/45 R18 (base)'),
  (@gen, NULL, 'rear',  'normal', 38, 260, '275/40 R18 (base rear, RWD stagger)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '245/40 R19 (AMG-Line)'),
  (@gen, NULL, 'rear',  'normal', 38, 260, '275/35 R19 (AMG-Line rear)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'TIREFIT kit — no spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== PROCEDURES FOR ALL 4 ==============
SET @gen := 62;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda Pilot%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset', 'Maintenance Minder reset — Pilot (YF)',
 'Honda common DIC pattern: Settings → Vehicle → Maintenance Info → select serviced item → Reset → confirm. Same as Civic FC / CR-V RW / Accord CV.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Pilot (YF)',
 'Indirect TPMS. Inflate to placard, then DIC → Settings → Vehicle → TPMS Calibration → Calibrate. Drive 30 min mixed speeds.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Pilot (YF)',
 'Negative-first, positive-last. After reconnect: i-VTM4 AWD coupling self-recalibrates on first drive.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Pilot (YF)',
 'Standard 4-clamp procedure. 3-row SUV donor capacity matters — use 600+ CCA donor.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 63;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda Jazz%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset', 'Maintenance Minder reset — Jazz (GR9)',
 'Honda DIC pattern: ignition ON → Settings menu → Maintenance Info → select item → Reset.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Jazz (GR9)',
 'Indirect TPMS. Settings → TPMS Calibration → Calibrate. Drive 30 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Jazz (GR9)',
 'Negative-first, positive-last. e:HEV trims have 12V in engine bay (HV battery under rear seat — don''t touch).\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Jazz (GR9)',
 'Standard 4-clamp procedure to engine-bay 12V.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 64;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Lexus NX%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance reset — NX (AZ20)',
 'Lexus menu-driven reset (same as RX AL20): ignition ON → multi-info **Settings** → **Maintenance** → **Oil Maintenance** → **Reset**.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — NX (AZ20)',
 'Direct sensors. Press and hold **TPMS SET** under steering column until warning blinks 3× slowly. Wait 20 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — NX (AZ20)',
 'Negative-first, positive-last. Hybrid 350h has 12V in cargo well; never touch orange HV cables.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — NX (AZ20)',
 'Hybrid trims: under-hood red-cap jump terminal for **+**. Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 65;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mercedes-Benz E-Class%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-a-b-reset', 'Service A/B reset — E-Class (W213)',
 'Same MB pattern as C-Class W206 / GLC X253: COMAND/MBUX → Service → Service A (or B) → Reset. Or hold steering wheel OK to enter cluster service menu, then long-press OK to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-restart', 'TPMS restart — E-Class (W213)',
 'COMAND → Vehicle → Tyre Pressure → Restart. Drive 10 min for sensor pairing.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — E-Class (W213)',
 'Main 12V in trunk under floor; engine bay auxiliary on some trims. Negative-first on both. Battery registration via XENTRY required after replacement.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — E-Class (W213)',
 'Under-hood jump terminals (red cap +, ground stud −). Don''t jump from trunk auxiliary directly.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT '4-batch + procedures complete' AS status,
  (SELECT COUNT(*) FROM generations WHERE is_active=1) AS total_gens,
  (SELECT COUNT(*) FROM procedures) AS total_procedures;
