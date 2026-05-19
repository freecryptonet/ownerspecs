-- Sibling/new nameplate batch: Civic FE (sib of FC), Mazda 3 BM (sib of BP),
-- Corolla E170 (sib of E210), 3 Series F30 (sib of G20), Ford Explorer U625,
-- Chevrolet Equinox L1U. First four activate the NameplateRail by giving
-- each model a 2nd generation. Last two extend catalog breadth into top
-- US 3-row SUV and compact SUV segments. Restated from each gen's OEM OM.

SET NAMES utf8mb4;

-- =====================================================================
-- HONDA CIVIC FE (XI Sedan) 2022-2025 — gen 50, sibling of FC X (gen 1)
-- =====================================================================
SET @gen := 50;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Honda Civic XI (FE) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Honda Civic XI (FE) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Honda Civic XI (FE) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/honda/civic-fe-sedan-2022-2025/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:HONDA_CIVIC_SEDAN_(FE,FL)_China.jpg',
    CURDATE(), 'Honda Civic Sedan (FE)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       3.40, 3.60, '0W-20', 'API SP / ILSAC GF-6A',                  '15400-PLM-A02', 7500, 12000, 12, '1.5T L15CA · 3.6 qt. 2.0L L20A: 4.0 qt 0W-20. Si 1.5T: same. Type R FL5 2.0T: 4.3 qt 0W-30.'),
  (@gen, NULL, 'transmission_cvt', 3.30, 3.49, NULL,    'Honda Genuine HCF-2 CVT Fluid',         NULL,            90000, 144000,NULL, 'CVT on 1.5T / 2.0L. Si manual: MTF-3 (1.7 L). Type R: HMF-3 (2.0 L).'),
  (@gen, NULL, 'coolant',          5.40, 5.71, NULL,    'Honda Type 2 LLC (blue)',                NULL,            NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',            NULL, NULL, 'DOT 3', 'Honda DOT 3 (or DOT 4)',                 NULL,            NULL,  NULL,  36,   'Every 3 years.'),
  (@gen, NULL, 'ac_refrigerant',   0.50, 0.53, NULL,    'R-1234yf · PAG46',                        NULL,            NULL,  NULL,  NULL, '500 ±25 g R-1234yf.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'NGK DILZKAR7L11GS iridium.'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 36,  27,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   109, 80,  'Front carrier-to-knuckle.');
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
  (@gen, NULL, 'engine_bay', '2',  30,  'ABS / VSA control'),
  (@gen, NULL, 'engine_bay', '3',  50,  'EPS'),
  (@gen, NULL, 'engine_bay', '5',  50,  'IG1 main'),
  (@gen, NULL, 'engine_bay', '11', 20,  'Left headlight LED'),
  (@gen, NULL, 'engine_bay', '12', 20,  'Right headlight LED'),
  (@gen, NULL, 'engine_bay', '13', 15,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', '20', 30,  'Cooling fan'),
  (@gen, NULL, 'cabin',      '1',  20,  '12V outlet'),
  (@gen, NULL, 'cabin',      '2',  15,  'Multimedia'),
  (@gen, NULL, 'cabin',      '5',  30,  'Wiper'),
  (@gen, NULL, 'cabin',      '8',  20,  'Heated seats'),
  (@gen, NULL, 'cabin',      '12', 15,  'Moonroof'),
  (@gen, NULL, 'cabin',      '15', 20,  'Driver power seat');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12290-64A-A01', 'NGK (Honda OE)', 1.10, NULL,    'DILZKAR7L11GS · 1.5T'),
  (@gen, NULL, 'oil_filter',    '15400-PLM-A02', 'Honda Genuine',  NULL, NULL,    'Spin-on; fits 1.5T and 2.0L'),
  (@gen, NULL, 'air_filter',    '17220-64A-A00', 'Honda Genuine',  NULL, NULL,    'Engine air filter (FE)'),
  (@gen, NULL, 'cabin_filter',  '80292-T20-A41', 'Honda Genuine',  NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '76622-T20-A02', 'Honda Genuine',  NULL, '26 in', 'Driver beam'),
  (@gen, NULL, 'wiper_front_p', '76632-T20-A02', 'Honda Genuine',  NULL, '19 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500,  3750,  12000, 6000,  12, 'Honda MM A1.'),
  (@gen, NULL, 'tire_rotation',         7500,  3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      15000, 7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000, 15000, 24000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_cvt_fluid',60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'spark_plugs',           105000,60000, 168000,96000, NULL, NULL),
  (@gen, NULL, 'coolant_flush',         120000,60000, 192000,96000, 120, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '215/55 R16 (LX / Sport)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '215/55 R16 (LX / Sport)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '235/40 R18 (Touring)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '235/40 R18 (Touring)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/80 D16 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- MAZDA 3 III BM Sedan 2013-2018 — gen 51, sibling of BP (gen 10)
-- =====================================================================
SET @gen := 51;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Mazda 3 III (BM) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mazda 3 III (BM) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Mazda 3 III (BM) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/mazda/3-bm-sedan-2013-2018/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons / Flickr CC contributor',
    'https://commons.wikimedia.org/wiki/File:2014_Mazda_3_Sedan_(BM)_2.0_SkyActiv_(CBU)_4-door_sedan_(19680560286).jpg',
    CURDATE(), '2014 Mazda 3 Sedan (BM) 2.0 SkyActiv', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       4.30, 4.54, '0W-20', 'API SN / ILSAC GF-5 (or 5W-30)', 'PE01-14-302A', 7500, 12000, 12, '2.0L Skyactiv-G PE-VPS · 4.54 qt with filter. 2.5L PY-VPS: 4.71 qt 0W-20. 1.5L P5-VPS: 3.81 qt. 2.2L SH diesel: 5.4 qt 0W-30.'),
  (@gen, NULL, 'transmission_at', 6.60, 6.97, NULL,    'Mazda ATF FZ',                    NULL,           NULL,  NULL,  NULL, 'SkyActiv-Drive 6-speed AT. Mazda labels lifetime; recommend service at 60k mi.'),
  (@gen, NULL, 'transmission_mt', 1.85, 1.96, NULL,    'Mazda Gear Oil 75W-90 GL-4',      NULL,           60000, 96000, NULL, 'SkyActiv-MT 6-speed manual.'),
  (@gen, NULL, 'coolant',         7.40, 7.82, NULL,    'Mazda Long-life Coolant FL22 (green)', NULL,      NULL,  NULL,  NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Mazda Genuine Brake Fluid DOT 3',  NULL,           NULL,  NULL,  24,   'Every 2 years.'),
  (@gen, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-134a · PAG oil (pre-2018) / R-1234yf (2018+)', NULL, NULL, NULL, NULL, '500 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           108, 80,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        20,  15,  'NGK ILTR5A-13G iridium.'),
  (@gen, NULL, 'oil_drain',         33,  24,  'M14×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 33,  24,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   90,  66,  'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '35 (Q-85 EFB)', 580, 65, 110);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H11 (LED upper trim)', 2, 0),
  (@gen, NULL, 'headlight_high', 'H9 (LED upper trim)',  2, 0),
  (@gen, NULL, 'fog_front',      'H11', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     '7443', 2, 0),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '20', 30,  'ABS pump motor'),
  (@gen, NULL, 'engine_bay', '21', 30,  'ABS solenoid'),
  (@gen, NULL, 'engine_bay', '26', 40,  'EPS'),
  (@gen, NULL, 'engine_bay', '32', 30,  'Front blower'),
  (@gen, NULL, 'engine_bay', '33', 30,  'Heated rear window'),
  (@gen, NULL, 'engine_bay', '41', 15,  'Engine ECU'),
  (@gen, NULL, 'engine_bay', '45', 15,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', '48', 25,  'Headlight'),
  (@gen, NULL, 'cabin',      '1',  10,  'Audio'),
  (@gen, NULL, 'cabin',      '4',  20,  'Driver power window'),
  (@gen, NULL, 'cabin',      '5',  20,  'Passenger power window'),
  (@gen, NULL, 'cabin',      '7',  15,  'Front 12V'),
  (@gen, NULL, 'cabin',      '12', 7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    'PE5R-18-110',  'NGK (Mazda OE)', 0.80, NULL,   'ILTR5A-13G iridium · Skyactiv-G'),
  (@gen, NULL, 'oil_filter',    'PE01-14-302A', 'Mazda Genuine',  NULL, NULL,   'Spin-on; Skyactiv-G'),
  (@gen, NULL, 'air_filter',    'PE07-13-3A0',  'Mazda Genuine',  NULL, NULL,   'Engine air filter (BM)'),
  (@gen, NULL, 'cabin_filter',  'KD45-61-J6X',  'Mazda Genuine',  NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', 'BHN1-67-330',  'Mazda Genuine',  NULL, '24 in', 'Driver beam'),
  (@gen, NULL, 'wiper_front_p', 'BHN1-67-340',  'Mazda Genuine',  NULL, '18 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500, 5000,  12000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         7500, 5000,  12000, 8000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      15000,7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000,15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000,7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'spark_plugs',           75000,40000, 120000,64000, NULL, NULL),
  (@gen, NULL, 'coolant_flush',         120000,60000,192000,96000, 120, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL, NULL,  NULL,  NULL,  24, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '205/60 R16 (Sport / Touring)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '205/60 R16 (Sport / Touring)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '215/45 R18 (Grand Touring)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '215/45 R18 (Grand Touring)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/70 D16 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- TOYOTA COROLLA E170 2012-2018 — gen 52, sibling of E210 (gen 11)
-- =====================================================================
SET @gen := 52;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota Corolla XI (E170) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota Corolla XI (E170) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Toyota Corolla XI (E170) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/toyota/corolla-e170-sedan-2012-2018/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2013-2016_Toyota_Corolla_(ZRE172R)_SX_sedan_(2018-09-17)_02.jpg',
    CURDATE(), '2013-2016 Toyota Corolla (E170)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       4.20, 4.44, '0W-20', 'API SN / ILSAC GF-5', '04152-YZZA1', 10000, 16000, 12, '1.8L 2ZR-FE · 4.4 qt. 1.6L 1ZR-FE: 3.7 qt. 1.4L 1ND-TV diesel: 4.8 qt 5W-30.'),
  (@gen, NULL, 'transmission_at', 4.00, 4.23, NULL,    'Toyota ATF WS',         NULL,         60000, 96000, NULL, '6-speed (S180) or CVT (K313).'),
  (@gen, NULL, 'coolant',         5.50, 5.81, NULL,    'Toyota SLLC (pink)',     NULL,         100000,160000,NULL, NULL),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Toyota DOT 3',           NULL,         NULL,  NULL,  36,   NULL),
  (@gen, NULL, 'ac_refrigerant',  0.45, 0.48, NULL,    'R-134a · PAG46',          NULL,         NULL,  NULL,  NULL, '450 ±25 g R-134a (pre-2017 model years).');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           103, 76,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        18,  13,  'Denso FK20HR11.'),
  (@gen, NULL, 'oil_drain',         40,  30,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 34,  25,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   107, 79,  'Front carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '35 (LB2)', 470, 45, 100);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H11', 2, 0),
  (@gen, NULL, 'headlight_high', '9005 (HB3)', 2, 0),
  (@gen, NULL, 'fog_front',      'H16 (PSX24W)', 2, 0),
  (@gen, NULL, 'drl',            'LED (facelift 2016)', 2, 1),
  (@gen, NULL, 'turn_front',     '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     '7443', 2, 0),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'AM1',     50,  'Ignition switch'),
  (@gen, NULL, 'engine_bay', 'EFI MAIN',30,  'Engine fuel injection'),
  (@gen, NULL, 'engine_bay', 'HEAD',    25,  'Headlight'),
  (@gen, NULL, 'engine_bay', 'ABS',     40,  'ABS pump'),
  (@gen, NULL, 'engine_bay', 'RDI FAN', 30,  'Cooling fan'),
  (@gen, NULL, 'engine_bay', 'HORN',    10,  'Horn'),
  (@gen, NULL, 'cabin',      'AUDIO',   15,  'Audio'),
  (@gen, NULL, 'cabin',      'PWR OUT', 20,  '12V power outlet'),
  (@gen, NULL, 'cabin',      'DOME',    10,  'Interior lights'),
  (@gen, NULL, 'cabin',      'WIPER',   30,  'Wiper motor'),
  (@gen, NULL, 'cabin',      'P/WIN D', 25,  'Driver power window'),
  (@gen, NULL, 'cabin',      'OBD',     7.5, 'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '90919-01253',   'Denso (Toyota OE)', 0.80, NULL,   'FK20HR11 · 1.8L 2ZR-FE'),
  (@gen, NULL, 'oil_filter',    '04152-YZZA1',   'Toyota Genuine',    NULL, NULL,   'Cartridge'),
  (@gen, NULL, 'air_filter',    '17801-0T040',   'Toyota Genuine',    NULL, NULL,   'Engine air filter (E170)'),
  (@gen, NULL, 'cabin_filter',  '87139-YZZ20',   'Toyota Genuine',    NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '85212-02020',   'Toyota Genuine',    NULL, '26 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '85222-02020',   'Toyota Genuine',    NULL, '14 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         5000,  5000,  8000,  8000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'spark_plugs',           120000,60000, 192000,96000, NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '195/65 R15 (L / LE)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '195/65 R15 (L / LE)'),
  (@gen, NULL, 'front', 'normal', 32, 220, '205/55 R16 (S / SE)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '205/55 R16 (S / SE)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/70 D15 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- BMW 3 SERIES F30 SEDAN 2012-2018 — gen 53, sibling of G20 (gen 6)
-- =====================================================================
SET @gen := 53;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'BMW 3 Series (F30) Service Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'BMW 3 Series (F30) Service Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'BMW 3 Series (F30) Service Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/bmw/3-series-f30-sedan-2012-2018/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons / Flickr CC, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:BMW_3_Series_F30_(10631701463).jpg',
    CURDATE(), 'BMW 3 Series (F30)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',       6.50, 6.87, '0W-30', 'BMW Longlife-04 (LL-04)', '11428583898', 10000, 16000, 12, '2.0L N20 turbo (328i 2012-15) / B48 (330i 2016-18) · 5.0 qt. 3.0L N55 (335i / 340i): 6.9 qt. 2.0L N47 diesel (320d EU): 5.3 qt.'),
  (@gen, NULL, 'transmission_at', 7.00, 7.40, NULL,    'ZF Lifeguard 8',          NULL,         100000,160000,NULL, 'ZF 8HP — BMW "lifetime"; service at 60k mi.'),
  (@gen, NULL, 'transmission_mt', 1.70, 1.80, NULL,    'BMW MTF-LT-2',             NULL,         NULL,  NULL,  NULL, 'ZF GS6 6-speed manual (320i, 328i base trims).'),
  (@gen, NULL, 'coolant',         8.50, 9.00, NULL,    'BMW HT-12 (blue)',          NULL,         NULL,  NULL,  NULL, 'Lifetime per BMW.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 4', 'BMW DOT 4 LV',              NULL,         NULL,  NULL,  24,   'Every 2 years.'),
  (@gen, NULL, 'ac_refrigerant',  0.61, 0.65, NULL,    'R-134a (pre-2017) / R-1234yf (2017+)', NULL, NULL, NULL, NULL, '610 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',              120, 89,  'M14×1.25; star pattern.'),
  (@gen, NULL, 'spark_plug',           23,  17,  'NGK ILZKBR7B-8G (N20) / ILZKAR8H10SG (B48).'),
  (@gen, NULL, 'oil_drain',            25,  18,  'M22×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin',    28,  21,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',      110, 81,  'Front carrier.'),
  (@gen, NULL, 'wheel_hub_nut',        140, 103, 'Plus 90° on driveshaft nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'H7 AGM (90)', 800, 90, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H7 (HID/LED opt)', 2, 0),
  (@gen, NULL, 'headlight_high', 'H7', 2, 0),
  (@gen, NULL, 'fog_front',      'H8', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'PY24W', 2, 0),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'W16W', 2, 0),
  (@gen, NULL, 'turn_rear',      'PY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen, NULL, 'trunk',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'cabin', 'F101', 30,  'Driver power window/lock'),
  (@gen, NULL, 'cabin', 'F102', 30,  'Passenger power window/lock'),
  (@gen, NULL, 'cabin', 'F125', 25,  'Head unit / iDrive'),
  (@gen, NULL, 'cabin', 'F128', 20,  'Heated front seats'),
  (@gen, NULL, 'cabin', 'F134', 30,  'Powered trunk'),
  (@gen, NULL, 'cabin', 'F140', 20,  'Heated rear seats'),
  (@gen, NULL, 'cabin', 'F154', 10,  'OBD-II'),
  (@gen, NULL, 'cabin', 'F176', 15,  'Rear camera'),
  (@gen, NULL, 'engine_bay', 'F01', 250, 'Battery main'),
  (@gen, NULL, 'engine_bay', 'F02', 175, 'Alternator output'),
  (@gen, NULL, 'engine_bay', 'F04', 50,  'Engine cooling fan'),
  (@gen, NULL, 'engine_bay', 'F11', 30,  'Trailer (when equipped)'),
  (@gen, NULL, 'engine_bay', 'F23', 25,  'Headlight LED driver');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12120037244',  'NGK (BMW OE)',  0.80, NULL,    'ILZKBR7B-8G · N20'),
  (@gen, NULL, 'spark_plug',    '12120040551',  'NGK (BMW OE)',  0.80, NULL,    'ILZKAR8H10SG · B48 (LCI 2016+)'),
  (@gen, NULL, 'oil_filter',    '11428583898',  'BMW Genuine',   NULL, NULL,    'Cartridge; N20 / B48'),
  (@gen, NULL, 'air_filter',    '13717636542',  'BMW Genuine',   NULL, NULL,    'Engine air filter'),
  (@gen, NULL, 'cabin_filter',  '64119237554',  'BMW Genuine',   NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '61617200822',  'BMW Genuine',   NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '61617242147',  'BMW Genuine',   NULL, '19 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, 'BMW CBS.'),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 100000,60000, 160000,96000, NULL, 'ZF 8HP.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, NULL),
  (@gen, NULL, 'spark_plugs',           60000, NULL,  96000, NULL,  NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '225/50 R17 (320i / 328i base)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '255/45 R17 (rear stagger)'),
  (@gen, NULL, 'front', 'normal', 32, 220, '225/45 R18 (M-Sport)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '255/40 R18 (M-Sport rear)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'Run-flat — no spare provided');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- FORD EXPLORER U625 (VI) 2020-2024 — gen 54, new model
-- =====================================================================
SET @gen := 54;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Ford Explorer (U625) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Ford Explorer (U625) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Ford Explorer (U625) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/ford/explorer-u625-suv-2020-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2020_Ford_Explorer_ST,_12.5.19.jpg',
    CURDATE(), '2020 Ford Explorer ST (U625)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          6.10, 6.45, '5W-30', 'API SP / Ford WSS-M2C961-A1',           'FL-500S',     10000, 16000, 12, '2.3L EcoBoost I4 · 5.5 qt. 3.0L EcoBoost V6 (ST/Platinum): 6.4 qt 5W-30. 3.3L V6 hybrid (HC3Z): 6.0 qt 5W-20.'),
  (@gen, NULL, 'transmission_at',     12.5, 13.2, NULL,    'Mercon LV ATF',                         NULL,          60000, 96000, NULL, '10R60 10-speed automatic.'),
  (@gen, NULL, 'transfer_case',       1.30, 1.37, NULL,    'Mercon LV (Intelligent 4WD coupling)',  NULL,          60000, 96000, NULL, '4WD only.'),
  (@gen, NULL, 'rear_differential',   1.20, 1.27, NULL,    'Motorcraft SAE 75W-85 GL-5',             NULL,          60000, 96000, NULL, 'Open or LSD rear. LSD: add friction modifier.'),
  (@gen, NULL, 'coolant',             14.0, 14.8, NULL,    'Motorcraft Yellow Antifreeze (WSS-M97B44-D2)', NULL,    NULL,  NULL,  NULL, 'Initial 100k mi / 6 yr.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Motorcraft DOT 3',                       NULL,          NULL,  NULL,  36,   NULL),
  (@gen, NULL, 'ac_refrigerant',      0.85, 0.90, NULL,    'R-1234yf · PAG46',                        NULL,          NULL,  NULL,  NULL, '850 ±30 g R-1234yf.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           203, 150, 'M14×1.5; star pattern (heavier than Mustang S550 due to BoF-style mass).'),
  (@gen, NULL, 'spark_plug',        15,  11,  '2.3L EcoBoost / 3.0L EcoBoost · NGK iridium.'),
  (@gen, NULL, 'oil_drain',         27,  20,  'M14×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 27,  20,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   180, 133, 'Front carrier.'),
  (@gen, NULL, 'diff_fill_plug',    30,  22,  'Rear diff fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'H7 AGM (94R)', 800, 80, 220);
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
  (@gen, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', '1',  40,  'PCM main feed'),
  (@gen, NULL, 'engine_bay', '4',  30,  'Electric cooling fan'),
  (@gen, NULL, 'engine_bay', '10', 30,  'Trailer accessory'),
  (@gen, NULL, 'engine_bay', '14', 30,  '4WD transfer case actuator'),
  (@gen, NULL, 'engine_bay', '18', 25,  'Headlight LH'),
  (@gen, NULL, 'engine_bay', '19', 25,  'Headlight RH'),
  (@gen, NULL, 'engine_bay', '23', 20,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', '32', 15,  'Ignition coils'),
  (@gen, NULL, 'cabin',      '1',  20,  'Front 12V'),
  (@gen, NULL, 'cabin',      '5',  25,  'Sliding rear window'),
  (@gen, NULL, 'cabin',      '8',  15,  'Sync 4 multimedia'),
  (@gen, NULL, 'cabin',      '12', 15,  '2nd row heated seats'),
  (@gen, NULL, 'cabin',      '20', 10,  'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    'CYFS-12Y-2',  'Motorcraft (Ford OE)', 1.30, NULL,    '2.3L EcoBoost'),
  (@gen, NULL, 'spark_plug',    'CYFS-12F-5',  'Motorcraft (Ford OE)', 0.80, NULL,    '3.0L EcoBoost V6 ST'),
  (@gen, NULL, 'oil_filter',    'FL-500S',     'Motorcraft (Ford OE)', NULL, NULL,    'Spin-on; 2.3L / 3.0L EcoBoost / 3.3L hybrid'),
  (@gen, NULL, 'air_filter',    'FA-1925',     'Motorcraft (Ford OE)', NULL, NULL,    'Engine air filter (U625)'),
  (@gen, NULL, 'cabin_filter',  'FP-87',       'Motorcraft (Ford OE)', NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', 'LB5Z-17528-A','Ford Genuine',         NULL, '26 in', 'Driver beam'),
  (@gen, NULL, 'wiper_front_p', 'LB5Z-17528-B','Ford Genuine',         NULL, '21 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, 'Ford IOLM-adaptive.'),
  (@gen, NULL, 'tire_rotation',         7500,  7500,  12000, 12000, NULL, NULL),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      20000, 10000, 32000, 16000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 150000,75000, 240000,120000,NULL, '10R60 — Ford long interval; aggressive use halves it.'),
  (@gen, NULL, 'transfer_case_fluid',   60000, 30000, 96000, 48000, NULL, '4WD only.'),
  (@gen, NULL, 'rear_diff_oil',         60000, 30000, 96000, 48000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, NULL),
  (@gen, NULL, 'spark_plugs',           100000,60000, 160000,96000, NULL, NULL),
  (@gen, NULL, 'coolant_flush',         100000,50000, 160000,80000, 72, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '255/65 R18 (Base / XLT)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '255/65 R18 (Base / XLT)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '255/55 R20 (Limited / ST)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '255/55 R20 (Limited / ST)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '275/45 R21 (Platinum)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '275/45 R21 (Platinum)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T175/85 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- CHEVROLET EQUINOX L1U (III) 2017-2021 — gen 55, new model
-- =====================================================================
SET @gen := 55;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Chevrolet Equinox (L1U) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Chevrolet Equinox (L1U) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Chevrolet Equinox (L1U) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/chevrolet/equinox-l1u-suv-2017-2021/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Chevrolet_Equinox_(third_generation)_1X7A6226.jpg',
    CURDATE(), 'Chevrolet Equinox III (L1U)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          4.30, 4.54, '5W-30', 'API SP / dexos1 Gen 3',                  'PF63E',       7500, 12000, 12, '1.5L LYX turbo · 4.54 qt. 2.0L LTG turbo: 5.0 qt 5W-30. 1.6L LH7 diesel: 4.5 qt 5W-30.'),
  (@gen, NULL, 'transmission_at',     7.40, 7.82, NULL,    'Dexron HP (6AT) / Dexron VI (9AT)',      NULL,          60000, 96000, NULL, '6T45 6-speed (early) or 9T50 9-speed (2018+ 2.0T).'),
  (@gen, NULL, 'transfer_case',       0.40, 0.42, NULL,    'GM PTU fluid (88862471)',                 NULL,          75000, 120000,NULL, 'AWD only — Power Transfer Unit and disconnecting rear coupling.'),
  (@gen, NULL, 'rear_differential',   0.45, 0.48, NULL,    'GM SAE 75W-90 GL-5',                       NULL,          75000, 120000,NULL, 'AWD rear coupling.'),
  (@gen, NULL, 'coolant',             7.60, 8.03, NULL,    'Dex-Cool (orange)',                        NULL,          150000,240000,NULL, 'Initial 150k mi / 5 yr.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'GM DOT 3',                                 NULL,          NULL,  NULL,  60,   '5-year service interval per OM.'),
  (@gen, NULL, 'ac_refrigerant',      0.65, 0.69, NULL,    'R-134a · PAG (pre-2019) / R-1234yf (2019+)', NULL,         NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           190, 140, 'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        20,  15,  'AC Delco 41-114 iridium (1.5T) / 41-103 (2.0T).'),
  (@gen, NULL, 'oil_drain',         25,  18,  'M14×1.5; new gasket each change.'),
  (@gen, NULL, 'caliper_slide_pin', 30,  22,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   90,  66,  'Front carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '47 (H5) AGM', 650, 60, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  '9012 (HIR2)', 2, 0),
  (@gen, NULL, 'headlight_high', '9005 (HB3)', 2, 0),
  (@gen, NULL, 'fog_front',      'H11', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     '7443', 2, 0),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F1',  60,  'ABS pump'),
  (@gen, NULL, 'engine_bay', 'F4',  40,  'Engine cooling fan'),
  (@gen, NULL, 'engine_bay', 'F8',  30,  'Front blower'),
  (@gen, NULL, 'engine_bay', 'F14', 30,  'AWD coupling'),
  (@gen, NULL, 'engine_bay', 'F18', 25,  'Headlight LH'),
  (@gen, NULL, 'engine_bay', 'F19', 25,  'Headlight RH'),
  (@gen, NULL, 'engine_bay', 'F23', 20,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', 'F35', 15,  'PCM'),
  (@gen, NULL, 'engine_bay', 'F38', 10,  'Horn'),
  (@gen, NULL, 'cabin',      'IP1', 20,  'Driver power lock/window'),
  (@gen, NULL, 'cabin',      'IP8', 15,  'Infotainment'),
  (@gen, NULL, 'cabin',      'IP12',15,  'Heated seats'),
  (@gen, NULL, 'cabin',      'IP20',20,  'Front 12V'),
  (@gen, NULL, 'cabin',      'IP22',10,  'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12671659', 'ACDelco (GM OE)', 1.10, NULL,   '41-114 iridium · 1.5T LYX'),
  (@gen, NULL, 'spark_plug',    '12698554', 'ACDelco (GM OE)', 1.10, NULL,   '41-103 iridium · 2.0T LTG'),
  (@gen, NULL, 'oil_filter',    'PF63E',    'ACDelco (GM OE)', NULL, NULL,   'Spin-on; 1.5T / 2.0T'),
  (@gen, NULL, 'air_filter',    '23295790', 'ACDelco (GM OE)', NULL, NULL,   'Engine air filter (Equinox III)'),
  (@gen, NULL, 'cabin_filter',  '23321737', 'ACDelco (GM OE)', NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '84571726', 'GM Genuine',      NULL, '24 in', 'Driver'),
  (@gen, NULL, 'wiper_front_p', '84571727', 'GM Genuine',      NULL, '18 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500, 4000,  12000, 6400,  12, 'GM Oil-Life System adaptive.'),
  (@gen, NULL, 'tire_rotation',         7500, 7500,  12000, 12000, NULL, NULL),
  (@gen, NULL, 'brake_inspection',      10000,5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     45000,22500, 72000, 36000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      22500,11250, 36000, 18000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 150000,75000,240000,120000,NULL, '6T45 / 9T50 — adaptive Dexron VI.'),
  (@gen, NULL, 'transfer_case_fluid',   75000,37500, 120000,60000, NULL, 'AWD only.'),
  (@gen, NULL, 'rear_diff_oil',         75000,37500, 120000,60000, NULL, 'AWD only.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL, NULL,  NULL,  NULL,  60, '5 years per OM.'),
  (@gen, NULL, 'spark_plugs',           97500,60000, 156000,96000, NULL, NULL),
  (@gen, NULL, 'coolant_flush',         150000,75000,240000,120000,NULL, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '225/65 R17 (L / LS)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '225/65 R17 (L / LS)'),
  (@gen, NULL, 'front', 'normal', 36, 250, '235/55 R18 (LT)'),
  (@gen, NULL, 'rear',  'normal', 36, 250, '235/55 R18 (LT)'),
  (@gen, NULL, 'front', 'normal', 36, 250, '235/50 R19 (Premier)'),
  (@gen, NULL, 'rear',  'normal', 36, 250, '235/50 R19 (Premier)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/70 D16 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

SELECT '6-sibling batch complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id BETWEEN 50 AND 55) AS fluids,
  (SELECT COUNT(*) FROM torque_specs WHERE generation_id BETWEEN 50 AND 55) AS torques,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id BETWEEN 50 AND 55) AS bulbs,
  (SELECT COUNT(*) FROM fuses WHERE generation_id BETWEEN 50 AND 55) AS fuses,
  (SELECT COUNT(*) FROM parts WHERE generation_id BETWEEN 50 AND 55) AS parts;
