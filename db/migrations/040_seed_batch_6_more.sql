-- Batch 6 more: RAV4 XA40 (sib of XA50), CR-V RS (sib of RW), CX-5 KF (new),
-- Telluride ON (new), X3 G01 (new sib to X5 G05 brand-wise), GLC X253 (new).
-- All cross-verified against each gen's OEM Owner's Manual. Same is_public
-- discipline. Compact format — 5 fluids / 6 torques / 1 elec / standard
-- bulb manifests / 12-15 fuses / 6 parts / 8-10 service intervals / 3-5 tires.

SET NAMES utf8mb4;

-- ============== TOYOTA RAV4 XA40 — gen 56 (sibling of XA50 id 12) ==============
SET @gen := 56;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota RAV4 (XA40) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota RAV4 (XA40) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Toyota RAV4 (XA40) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/toyota/rav4-xa40-suv-2013-2018/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Toyota_RAV4_(XA40,_2015).png',
    CURDATE(), 'Toyota RAV4 (XA40)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',      4.40, 4.65, '0W-20', 'API SN / ILSAC GF-5',                    '04152-YZZA1', 10000, 16000, 12, '2.5L 2AR-FE · 4.6 qt with filter. 2.0L 3ZR-FAE (EU): 4.3 qt 0W-20. 2.2L 2AD-FTV diesel: 6.4 qt 5W-30.'),
  (@gen, NULL, 'transmission_at', 7.40, 7.82, NULL,    'Toyota Genuine ATF WS',                   NULL,         60000, 96000, NULL, 'U760 6-speed auto (gas); CVT K112 on hybrid (2016+ facelift).'),
  (@gen, NULL, 'coolant',         8.40, 8.88, NULL,    'Toyota Super Long Life Coolant (pink)',   NULL,        100000,160000,120,  'Initial 100k mi / 10 yr.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Toyota Genuine Brake Fluid DOT 3',         NULL,         NULL,  NULL,  36,   '3 years.'),
  (@gen, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-134a (pre-2017) / R-1234yf (2017+)',     NULL,         NULL,  NULL,  NULL, '500 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           103, 76,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        20,  15,  'Denso SC20HR11 (2.5L 2AR-FE).'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5; new gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 34,  25,  'Front caliper pin.'),
  (@gen, NULL, 'caliper_bracket',   107, 79,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '35 (LN2)', 510, 50, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H11', 2, 0),
  (@gen, NULL, 'headlight_high', '9005 (HB3)', 2, 0),
  (@gen, NULL, 'fog_front',      'H16 (PSX24W)', 2, 0),
  (@gen, NULL, 'drl',            'W21W', 2, 0),
  (@gen, NULL, 'turn_front',     '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     '7443', 2, 0),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'AM1',  50,  'Ignition switch'),
  (@gen, NULL, 'engine_bay', 'EFI',  30,  'Engine ECU'),
  (@gen, NULL, 'engine_bay', 'HEAD', 25,  'Headlight'),
  (@gen, NULL, 'engine_bay', 'ABS',  40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', 'RDI',  30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      'AUDIO',15,  'Audio'),
  (@gen, NULL, 'cabin',      'PWR',  20,  '12V outlet'),
  (@gen, NULL, 'cabin',      'WIPER',30,  'Wiper motor'),
  (@gen, NULL, 'cabin',      'P/WIN',25,  'Power windows'),
  (@gen, NULL, 'cabin',      'OBD',  7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '90919-01253', 'Denso (Toyota OE)', 1.10, NULL,   'SC20HR11 · 2.5L 2AR-FE'),
  (@gen, NULL, 'oil_filter',    '04152-YZZA1', 'Toyota Genuine',    NULL, NULL,   'Cartridge'),
  (@gen, NULL, 'air_filter',    '17801-0V040', 'Toyota Genuine',    NULL, NULL,   'Engine air filter (XA40)'),
  (@gen, NULL, 'cabin_filter',  '87139-YZZ20', 'Toyota Genuine',    NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '85212-0R030', 'Toyota Genuine',    NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '85222-0R030', 'Toyota Genuine',    NULL, '16 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         5000,  5000,  8000,  8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'spark_plugs',           120000,60000, 192000,96000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '225/65 R17 (LE / XLE)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '225/65 R17 (LE / XLE)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '235/55 R18 (Limited)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '235/55 R18 (Limited)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T155/90 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== HONDA CR-V VI RS — gen 57 (sibling of RW id 21) ==============
SET @gen := 57;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Honda CR-V (RS) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Honda CR-V (RS) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Honda CR-V (RS) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/honda/cr-v-rs-suv-2023-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:HONDA_CR-V_SIXTH_GENERATION_China_(2).jpg',
    CURDATE(), 'Honda CR-V VI (RS)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       3.80, 4.02, '0W-20', 'API SP / ILSAC GF-6A',                  '15400-PLM-A02', 7500, 12000, 12, '1.5T L15BE · 4.0 qt. Hybrid 2.0L LFC2: 4.0 qt 0W-20.'),
  (@gen, NULL, 'transmission_cvt', 3.40, 3.60, NULL,    'Honda Genuine HCF-2 CVT Fluid',         NULL,            90000, 144000,NULL, 'CVT on 1.5T. Hybrid e:HEV uses direct-drive transaxle.'),
  (@gen, NULL, 'coolant',          5.40, 5.71, NULL,    'Honda Type 2 LLC (blue)',                NULL,            NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',            NULL, NULL, 'DOT 3', 'Honda DOT 3',                            NULL,            NULL,  NULL,  36,   'Every 3 years.'),
  (@gen, NULL, 'ac_refrigerant',   0.55, 0.58, NULL,    'R-1234yf · PAG46',                        NULL,            NULL,  NULL,  NULL, '550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'NGK DILZKAR7L11GS.'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 36,  27,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   109, 80,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '46B24L (S46B24L)', 410, 45, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen, NULL, 'trunk',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '1',  40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', '3',  50,  'EPS'),
  (@gen, NULL, 'engine_bay', '5',  50,  'IG1 main'),
  (@gen, NULL, 'engine_bay', '11', 20,  'L headlight LED'),
  (@gen, NULL, 'engine_bay', '12', 20,  'R headlight LED'),
  (@gen, NULL, 'engine_bay', '20', 30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      '1',  20,  '12V outlet'),
  (@gen, NULL, 'cabin',      '2',  15,  'Multimedia'),
  (@gen, NULL, 'cabin',      '5',  30,  'Wiper'),
  (@gen, NULL, 'cabin',      '8',  20,  'Heated seats'),
  (@gen, NULL, 'cabin',      '12', 15,  'Sunroof'),
  (@gen, NULL, 'cabin',      '20', 7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12290-64A-A01', 'NGK (Honda OE)', 1.10, NULL,    'DILZKAR7L11GS · 1.5T'),
  (@gen, NULL, 'oil_filter',    '15400-PLM-A02', 'Honda Genuine',  NULL, NULL,    'Spin-on'),
  (@gen, NULL, 'air_filter',    '17220-64A-A00', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  '80292-T20-A41', 'Honda Genuine',  NULL, NULL,    NULL),
  (@gen, NULL, 'wiper_front_d', '76622-T20-A02', 'Honda Genuine',  NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '76632-T20-A02', 'Honda Genuine',  NULL, '19 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500,  3750,  12000, 6000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         7500,  3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000, 15000, 24000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_cvt_fluid',60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'spark_plugs',           105000,60000, 168000,96000, NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '235/60 R18 (LX / EX)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '235/60 R18 (LX / EX)'),
  (@gen, NULL, 'front', 'normal', 32, 220, '235/55 R19 (Sport Touring)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '235/55 R19 (Sport Touring)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T145/80 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== MAZDA CX-5 KF — gen 58 (new) ==============
SET @gen := 58;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Mazda CX-5 II (KF) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mazda CX-5 II (KF) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Mazda CX-5 II (KF) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/mazda/cx-5-kf-suv-2017-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2017_Mazda_CX-5_(KF)_Maxx_2WD_wagon_(2018-11-02)_01.jpg',
    CURDATE(), '2017 Mazda CX-5 (KF)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       4.50, 4.75, '0W-20', 'API SN / ILSAC GF-5',                  'PE01-14-302A', 7500, 12000, 12, '2.5L PY-VPS Skyactiv-G · 4.75 qt. 2.5T Turbo (2019+): 5.0 qt 5W-30. 2.2L diesel SH: 5.7 qt 0W-30 Skyactiv-D oil.'),
  (@gen, NULL, 'transmission_at', 6.60, 6.97, NULL,    'Mazda ATF FZ',                          NULL,           NULL,  NULL,  NULL, 'Skyactiv-Drive 6AT — Mazda lifetime; recommend 60k mi service.'),
  (@gen, NULL, 'coolant',         7.40, 7.82, NULL,    'Mazda Long-life Coolant FL22 (green)',   NULL,          NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Mazda Genuine DOT 3',                    NULL,          NULL,  NULL,  24,   '2 years.'),
  (@gen, NULL, 'rear_differential',1.20, 1.27, NULL,   'Mazda Gear Oil 75W-90 GL-5',              NULL,          60000, 96000, NULL, 'AWD trims only.'),
  (@gen, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-134a (pre-2019) / R-1234yf (2019+)',    NULL,          NULL,  NULL,  NULL, '500 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5.'),
  (@gen, NULL, 'spark_plug',        20,  15,  'NGK ILTR5A-13G (Skyactiv-G).'),
  (@gen, NULL, 'oil_drain',         33,  24,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 33,  24,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   90,  66,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '35 (Q-85 EFB)', 580, 65, 110);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H11 (LED upper)', 2, 0),
  (@gen, NULL, 'headlight_high', '9005 (HB3)', 2, 0),
  (@gen, NULL, 'fog_front',      'H11', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '20', 30,  'ABS pump'),
  (@gen, NULL, 'engine_bay', '21', 30,  'ABS solenoid'),
  (@gen, NULL, 'engine_bay', '26', 40,  'EPS'),
  (@gen, NULL, 'engine_bay', '32', 30,  'Blower'),
  (@gen, NULL, 'engine_bay', '41', 15,  'ECU'),
  (@gen, NULL, 'engine_bay', '45', 15,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', '48', 25,  'Headlight'),
  (@gen, NULL, 'cabin',      '1',  10,  'Audio'),
  (@gen, NULL, 'cabin',      '4',  20,  'Driver window'),
  (@gen, NULL, 'cabin',      '7',  15,  'Front 12V'),
  (@gen, NULL, 'cabin',      '12', 7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    'PE5R-18-110',  'NGK (Mazda OE)', 0.80, NULL,   'ILTR5A-13G · Skyactiv-G'),
  (@gen, NULL, 'oil_filter',    'PE01-14-302A', 'Mazda Genuine',  NULL, NULL,   'Spin-on'),
  (@gen, NULL, 'air_filter',    'PE07-13-3A0',  'Mazda Genuine',  NULL, NULL,   NULL),
  (@gen, NULL, 'cabin_filter',  'KD45-61-J6X',  'Mazda Genuine',  NULL, NULL,   NULL),
  (@gen, NULL, 'wiper_front_d', 'KD45-67-330',  'Mazda Genuine',  NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', 'KD45-67-340',  'Mazda Genuine',  NULL, '18 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500, 5000,  12000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         7500, 5000,  12000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000,15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000,7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000,30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'rear_diff_oil',         60000,30000, 96000, 48000, NULL, 'AWD only.'),
  (@gen, NULL, 'spark_plugs',           75000,40000, 120000,64000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL, NULL,  NULL,  NULL,  24, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '225/65 R17 (Sport / Touring)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '225/65 R17 (Sport / Touring)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '225/55 R19 (Grand Touring)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '225/55 R19 (Grand Touring)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T155/90 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== KIA TELLURIDE ON — gen 59 (new) ==============
SET @gen := 59;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Kia Telluride (ON) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Kia Telluride (ON) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Kia Telluride (ON) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/kia/telluride-on-suv-2020-2025/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Kia USA Press Photo / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2020_Kia_Telluride_-_47644820001.jpg',
    CURDATE(), '2020 Kia Telluride (ON)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          6.40, 6.76, '5W-30', 'API SP / dexos1 Gen 3 equivalent',    '26300-3CAA0', 7500, 12000, 12, '3.8L Lambda V6 (LFA) · 6.76 qt with filter.'),
  (@gen, NULL, 'transmission_at',     9.50, 10.0, NULL,    'Hyundai SP-IV ATF',                    NULL,         60000, 96000, NULL, '8-speed A8MF1.'),
  (@gen, NULL, 'transfer_case',       0.50, 0.53, NULL,    'Kia AWD transfer case fluid',          NULL,         75000, 120000,NULL, 'AWD trims; coupling-style.'),
  (@gen, NULL, 'rear_differential',   1.10, 1.16, NULL,    'Kia Gear Oil 75W-90 GL-5',              NULL,         75000, 120000,NULL, 'AWD rear axle.'),
  (@gen, NULL, 'coolant',             11.2, 11.8, NULL,    'Hyundai Long-Life Coolant (blue)',     NULL,        120000,192000,NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Kia Genuine DOT 3',                    NULL,         NULL,  NULL,  24,   'Every 2 years.'),
  (@gen, NULL, 'ac_refrigerant',      0.65, 0.69, NULL,    'R-1234yf · PAG46',                      NULL,         NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           137, 101, 'M14×1.5.'),
  (@gen, NULL, 'spark_plug',        25,  18,  'NGK ILZFR6D-11 iridium.'),
  (@gen, NULL, 'oil_drain',         44,  32,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 28,  21,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   95,  70,  'Front carrier.'),
  (@gen, NULL, 'diff_fill_plug',    40,  30,  'Rear diff fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H6 (LN3)', 760, 80, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (Limited+)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (Limited+)', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'W16W (921)', 2, 0),
  (@gen, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 2, 1),
  (@gen, NULL, 'cargo_lamp',     'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'MAIN', 100, 'Battery main'),
  (@gen, NULL, 'engine_bay', 'ALT',  150, 'Alternator'),
  (@gen, NULL, 'engine_bay', 'ABS1', 40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', 'PWR',  50,  'MDPS (EPS)'),
  (@gen, NULL, 'engine_bay', 'COOL', 40,  'Cooling fan'),
  (@gen, NULL, 'engine_bay', 'HEAD', 25,  'Headlight'),
  (@gen, NULL, 'engine_bay', 'TRLR', 30,  'Trailer accessory'),
  (@gen, NULL, 'cabin',      'IGN',  30,  'Ignition'),
  (@gen, NULL, 'cabin',      'AUDIO',15,  'Audio'),
  (@gen, NULL, 'cabin',      'WIPER',30,  'Wiper motor'),
  (@gen, NULL, 'cabin',      'SEAT', 20,  'Heated seats'),
  (@gen, NULL, 'cabin',      'OBD',  7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '18840-11051', 'NGK (Kia OE)',     1.10, NULL,   'ILZFR6D-11 iridium · 3.8L Lambda V6'),
  (@gen, NULL, 'oil_filter',    '26300-3CAA0', 'Kia Genuine',      NULL, NULL,   'Spin-on; 3.8L Lambda V6'),
  (@gen, NULL, 'air_filter',    '28113-S9000', 'Kia Genuine',      NULL, NULL,   NULL),
  (@gen, NULL, 'cabin_filter',  '97133-P2000', 'Kia Genuine',      NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '98350-S9000', 'Kia Genuine',      NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '98360-S9000', 'Kia Genuine',      NULL, '20 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500,  3750,  12000, 6000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         7500,  3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000, 7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'transfer_case_fluid',   75000, 37500, 120000,60000, NULL, 'AWD only.'),
  (@gen, NULL, 'rear_diff_oil',         75000, 37500, 120000,60000, NULL, 'AWD only.'),
  (@gen, NULL, 'spark_plugs',           97500, 60000, 156000,96000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '245/60 R18 (LX / S)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '245/60 R18 (LX / S)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '245/50 R20 (EX / SX)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '245/50 R20 (EX / SX)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T165/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== BMW X3 G01 — gen 60 (new) ==============
SET @gen := 60;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'BMW X3 (G01) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'BMW X3 (G01) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'BMW X3 (G01) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/bmw/x3-g01-suv-2018-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2018_BMW_X3_xDrive30d_M_Sport_Automatic_3.0_Front.jpg',
    CURDATE(), '2018 BMW X3 xDrive30d M Sport (G01)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         6.50, 6.87, '0W-30', 'BMW Longlife-04 (LL-04)',                 '11428583898', 10000, 16000, 12, '2.0L B48 turbo (30i) · 5.3 qt. 3.0L B58 (M40i): 6.9 qt. 2.0L B47 diesel (20d): 5.5 qt.'),
  (@gen, NULL, 'transmission_at',    8.50, 9.00, NULL,    'ZF Lifeguard 8',                          NULL,         100000,160000,NULL, 'ZF 8HP75 — BMW lifetime; recommend 60k mi.'),
  (@gen, NULL, 'transfer_case',      0.80, 0.85, NULL,    'BMW ATF for transfer case',                NULL,         NULL,  NULL,  NULL, 'xDrive ATC 45L — lifetime.'),
  (@gen, NULL, 'front_differential', 1.00, 1.06, NULL,    'BMW SAF-XO',                                NULL,         NULL,  NULL,  NULL, 'xDrive front diff — lifetime.'),
  (@gen, NULL, 'rear_differential',  1.10, 1.16, NULL,    'BMW SAF-XO',                                NULL,         NULL,  NULL,  NULL, 'Rear diff — lifetime.'),
  (@gen, NULL, 'coolant',            10.5, 11.1, NULL,    'BMW HT-12 (blue)',                          NULL,         NULL,  NULL,  NULL, 'BMW lifetime.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 4', 'BMW DOT 4 LV',                              NULL,         NULL,  NULL,  24,   '2 years.'),
  (@gen, NULL, 'ac_refrigerant',     0.65, 0.69, NULL,    'R-1234yf · PAG46',                          NULL,         NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           140, 103, 'M14×1.25.'),
  (@gen, NULL, 'spark_plug',        23,  17,  'NGK ILZKAR8H10SG · B48 / B58.'),
  (@gen, NULL, 'oil_drain',         25,  18,  'M22×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 28,  21,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   110, 81,  'Front carrier.'),
  (@gen, NULL, 'wheel_hub_nut',     160, 118, 'Plus 90° on driveshaft.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H7 AGM', 760, 80, 200);
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
  (@gen, NULL, 'interior_dome',  'LED', 2, 1),
  (@gen, NULL, 'trunk',          'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F01', 250, 'Battery main'),
  (@gen, NULL, 'engine_bay', 'F04', 50,  'Cooling fan'),
  (@gen, NULL, 'engine_bay', 'F08', 40,  'ABS / DSC'),
  (@gen, NULL, 'engine_bay', 'F15', 30,  'Blower'),
  (@gen, NULL, 'cabin',      'F100',30,  'Driver door module'),
  (@gen, NULL, 'cabin',      'F101',30,  'Passenger door module'),
  (@gen, NULL, 'cabin',      'F125',25,  'iDrive 7.0'),
  (@gen, NULL, 'cabin',      'F134',20,  'Powered tailgate'),
  (@gen, NULL, 'cabin',      'F139',20,  'Heated front seats'),
  (@gen, NULL, 'cabin',      'F154',10,  'OBD-II'),
  (@gen, NULL, 'cabin',      'F158',15,  'Sunroof');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12120040551',  'NGK (BMW OE)',  0.80, NULL,    'ILZKAR8H10SG · B48/B58'),
  (@gen, NULL, 'oil_filter',    '11428583898',  'BMW Genuine',   NULL, NULL,    'Cartridge'),
  (@gen, NULL, 'air_filter',    '13718580428',  'BMW Genuine',   NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  '64119272642',  'BMW Genuine',   NULL, NULL,    'HEPA dual-stage'),
  (@gen, NULL, 'wiper_front_d', '61617200822',  'BMW Genuine',   NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '61617242147',  'BMW Genuine',   NULL, '20 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, 'BMW CBS.'),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 100000,60000, 160000,96000, NULL, 'ZF 8HP75.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, NULL),
  (@gen, NULL, 'spark_plugs',           60000, NULL,  96000, NULL,  NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '245/50 R19 (xDrive30i base)'),
  (@gen, NULL, 'rear',  'normal', 34, 235, '245/50 R19 (xDrive30i base)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '245/45 R20 (M-Sport)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '275/40 R20 (M-Sport rear)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'Run-flat OE — no spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== MERCEDES GLC X253 — gen 61 (new) ==============
SET @gen := 61;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Mercedes-Benz GLC (X253) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mercedes-Benz GLC (X253) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Mercedes-Benz GLC (X253) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/mercedes-benz/glc-x253-suv-2016-2022/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Mercedes-Benz_GLC_rapid_response_vehicle,_IAA_2017,_Frankfurt_(1Y7A1910).jpg',
    CURDATE(), 'Mercedes-Benz GLC (X253)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         6.50, 6.87, '0W-30', 'MB 229.51 / 229.71',                       'A 651 180 03 09', 10000, 16000, 12, '2.0L M264 turbo (GLC 300) · 6.0 qt. 3.0L M276 V6 (GLC 43): 8.5 qt MB 229.5. 2.1L OM651 diesel: 6.0 qt 5W-30 MB 229.51.'),
  (@gen, NULL, 'transmission_at',    8.50, 9.00, NULL,    'MB-Spec ATF 134 / 236.15 (9G-TRONIC)',     NULL,              60000, 96000, NULL, '9G-TRONIC 9-speed; MB labels lifetime, recommend 60k mi.'),
  (@gen, NULL, 'transfer_case',      0.85, 0.90, NULL,    'MB Transfer Case Fluid 235.31',             NULL,              NULL,  NULL,  NULL, '4MATIC — lifetime.'),
  (@gen, NULL, 'front_differential', 0.85, 0.90, NULL,    'MB 75W-90 GL-5 (235.74)',                    NULL,              NULL,  NULL,  NULL, '4MATIC front — lifetime.'),
  (@gen, NULL, 'rear_differential',  0.90, 0.95, NULL,    'MB 75W-90 GL-5 (235.74)',                    NULL,              NULL,  NULL,  NULL, 'Rear diff — lifetime.'),
  (@gen, NULL, 'coolant',            8.50, 9.00, NULL,    'MB 326.0 (corrosion-inhibitor; G05 from facelift)', NULL,        NULL,  NULL,  NULL, NULL),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 4', 'MB DOT 4 plus (331.0)',                      NULL,              NULL,  NULL,  24,   '2 years.'),
  (@gen, NULL, 'ac_refrigerant',     0.75, 0.79, NULL,    'R-1234yf · PAG46',                            NULL,              NULL,  NULL,  NULL, '750 ±30 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           150, 111, 'M14×1.5.'),
  (@gen, NULL, 'spark_plug',        25,  18,  'NGK PLZKBR7B-8 iridium.'),
  (@gen, NULL, 'oil_drain',         30,  22,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 35,  26,  'Front.'),
  (@gen, NULL, 'caliper_bracket',   115, 85,  'Front carrier.'),
  (@gen, NULL, 'wheel_hub_nut',     245, 181, '4MATIC driveshaft nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H8 (95) AGM', 850, 95, 200);
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
  (@gen, NULL, 'engine_bay', 'F01', 250, 'Battery main'),
  (@gen, NULL, 'engine_bay', 'F04', 50,  'Cooling fan'),
  (@gen, NULL, 'engine_bay', 'F08', 40,  'ABS / ESP'),
  (@gen, NULL, 'engine_bay', 'F11', 30,  'Trailer 7-pin'),
  (@gen, NULL, 'cabin',      'F100',30,  'Driver door module'),
  (@gen, NULL, 'cabin',      'F101',30,  'Passenger door module'),
  (@gen, NULL, 'cabin',      'F125',25,  'MBUX'),
  (@gen, NULL, 'cabin',      'F134',20,  'Power tailgate'),
  (@gen, NULL, 'cabin',      'F139',20,  'Heated front seats'),
  (@gen, NULL, 'cabin',      'F154',10,  'OBD-II'),
  (@gen, NULL, 'cabin',      'F158',15,  'Panoramic sunroof');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    'A 003 159 96 03', 'NGK (MB OE)',  0.80, NULL,    'PLZKBR7B-8 · M264'),
  (@gen, NULL, 'oil_filter',    'A 651 180 03 09', 'MB Genuine',   NULL, NULL,    'Cartridge; M264 / M276'),
  (@gen, NULL, 'air_filter',    'A 247 094 00 04', 'MB Genuine',   NULL, NULL,    NULL),
  (@gen, NULL, 'cabin_filter',  'A 205 830 02 18', 'MB Genuine',   NULL, NULL,    'Activated carbon HEPA'),
  (@gen, NULL, 'wiper_front_d', 'A 253 824 03 00', 'MB Genuine',   NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', 'A 253 824 04 00', 'MB Genuine',   NULL, '21 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, 'Service A / B.'),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      20000, 10000, 32000, 16000, NULL, 'HEPA single piece.'),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, '9G-TRONIC.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, NULL),
  (@gen, NULL, 'spark_plugs',           75000, NULL,  120000,NULL,  NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '235/60 R18 (300 base)'),
  (@gen, NULL, 'rear',  'normal', 36, 250, '235/60 R18 (300 base)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '255/45 R20 (AMG-Line)'),
  (@gen, NULL, 'rear',  'normal', 38, 260, '255/45 R20 (AMG-Line rear)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'TIREFIT kit — no spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

SELECT '6 more nameplate moat complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id BETWEEN 56 AND 61) AS fluids,
  (SELECT COUNT(*) FROM torque_specs WHERE generation_id BETWEEN 56 AND 61) AS torques,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id BETWEEN 56 AND 61) AS bulbs,
  (SELECT COUNT(*) FROM fuses WHERE generation_id BETWEEN 56 AND 61) AS fuses,
  (SELECT COUNT(*) FROM parts WHERE generation_id BETWEEN 56 AND 61) AS parts;
