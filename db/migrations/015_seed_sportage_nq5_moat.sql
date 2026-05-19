-- Kia Sportage (NQ5) moat fill — 5th-gen SUV, 2021-present global
-- Shares N3 platform with Hyundai Tucson NX4 — Smartstream G2.5 / G1.6
-- T-GDI Hybrid powertrains. Cross-verified against Kia OM, Hyundai Mobis
-- OE catalog, NGK iridium part numbers.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'NQ5' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Kia Sportage (NQ5) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/kia/sportage-nq5-suv-2021-2025/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Kia_Sportage_(NQ5)_1X7A0326.jpg',
  CURDATE(),
  'Kia Sportage (NQ5)',
  '3-4-front', 1280, 694
FROM generations g WHERE g.codename = 'NQ5';

-- Same N3 platform as Tucson NX4 — fluid/torque/electrical figures share heavily
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.50, 4.76, '0W-20', 'API SP / ILSAC GF-6 (Kia Premium Long-Life)', '26300-35505', 7500, 12000, 12, '2.5 Smartstream G2.5 GDI · 4.76 US qt with filter. 1.6 T-GDI: 3.95 qt 5W-30. HEV/PHEV: 4.0 qt 0W-20.'),
  (@gen_id, NULL, 'transmission_at', 8.00, 8.45, NULL,    'Hyundai/Kia SP-IV-RR · 00232-19052',         NULL,         100000,160000, NULL, '8AT A8MF1 on 2.5; 7-DCT on 1.6 T-GDI uses DCTF SK 7-DCT.'),
  (@gen_id, NULL, 'coolant',         7.50, 7.93, NULL,    'Kia/Hyundai LLC (pink OAT, pre-mixed)',      NULL,         120000,200000, 120, 'Pre-mixed. Do not mix with green silicate.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 (Kia genuine)',                        NULL,         30000, 48000, 30,   'Mileage or time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-1234yf · PAG oil ND-11',                   NULL,         NULL,  NULL,  NULL, 'Charge weight 500 ±15 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       127, 94,  'M12×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'NGK LZKAR6BP iridium (2.5 G2.5); ILKAR8L11 (1.6 T-GDI).'),
  (@gen_id, NULL, 'oil_drain',     35,  26,  'M14×1.5; new gasket (PN 21513-23001).'),
  (@gen_id, NULL, 'caliper_bolt',  32,  24,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 100, 74, 'Front caliper carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'H6 / LN3 AGM', 760, 80, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'PY21W', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'PY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'MAIN',     200, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'ALT',      150, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'EPS',      80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'ABS1',     40,  'ABS / ESC'),
  (@gen_id, NULL, 'under_hood', 'COOL FAN', 40,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'IGN COIL', 20,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'ECU',      25,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'CLUSTER',  7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      'AVN',      15,  'Infotainment (AVN)'),
  (@gen_id, NULL, 'cabin',      'P/WDW LH', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'P/WDW RH', 30,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'BLOWER',   40,  'Heater blower');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '18847-11070',   'Hyundai/Kia', 1.10, NULL,    '2.5 G2.5 iridium'),
  (@gen_id, NULL, 'oil_filter',    '26300-35505',   'Kia',         NULL, NULL,    'Cartridge; G2.5 / G1.6 T-GDI'),
  (@gen_id, NULL, 'air_filter',    '28113-P0100',   'Kia',         NULL, NULL,    'Panel filter NQ5'),
  (@gen_id, NULL, 'cabin_filter',  '97133-P0000',   'Kia',         NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '98350-P0000',   'Kia',         NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '98360-P0000',   'Kia',         NULL, '17 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  3750,  12000, 6000,  12, '4.76 qt 0W-20.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  100000,60000, 160000,96000, NULL, '8AT SP-IV-RR.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            100000,NULL,  160000,NULL,  NULL, 'NGK LZKAR6BP.'),
  (@gen_id, NULL, 'coolant_flush',          120000,NULL,  200000,NULL,  120,  'Kia LLC OAT.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, 'Serpentine.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '235/65 R17 104H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/65 R17 104H'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/55 R19 101V'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '235/55 R19 101V'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T155/90 D17 compact');
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
