-- Mitsubishi Outlander (GN) moat fill — 4th-gen SUV, 2022-2025 global
-- Cross-verified against HaynesPro WorkshopData (Mitsubishi → Outlander 2022+),
-- Mitsubishi OM, Nissan Mobis parts catalog (PR25DD shared with Altima L34),
-- Mitsubishi Genuine parts catalog. CMF-CD platform shared with Nissan Rogue T33.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'GN' AND display_name LIKE 'Outlander%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Mitsubishi Outlander (GN) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/mitsubishi/outlander-gn-suv-2022-2025/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'MercurySable99 / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2022_Mitsubishi_Outlander_SE_S-AWC,_07-29-2022.jpg',
  CURDATE(),
  '2022 Mitsubishi Outlander SE S-AWC (GN)',
  '3-4-front', 1280, 802
FROM generations g WHERE g.codename = 'GN' AND g.display_name LIKE 'Outlander%';

-- 2.5 PR25DD (Nissan-sourced) — main petrol. 2.4 4B12 PHEV figures noted.
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.70, 4.95, '0W-20', 'API SP / ILSAC GF-6 (Mitsubishi Genuine 0W-20)', '1230A209', 7500, 12000, 12, '2.5 PR25DD (Nissan-shared) · 4.95 US qt with filter. 2.4 4B12 PHEV: 4.3 qt 5W-30.'),
  (@gen_id, NULL, 'transmission_cvt',5.20, 5.50, NULL,    'Nissan NS-3 / Mitsubishi Genuine CVT-J4',     NULL,         60000, 96000, NULL, 'Xtronic JF016E CVT (PR25DD). PHEV uses single-speed reducer + dual motors (no CVT).'),
  (@gen_id, NULL, 'coolant',         8.50, 8.98, NULL,    'Mitsubishi Super Long Life Coolant (pink)',   NULL,         105000,168000, 84,  'First replacement at 7 yr / 105k mi.'),
  (@gen_id, NULL, 'rear_differential',0.65,0.69, NULL,    'API GL-5 75W-90 (Mitsubishi Genuine)',        NULL,         60000, 96000, NULL, 'S-AWC only.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 (Mitsubishi Genuine)',                  NULL,         30000, 48000, 30,   'Mileage or time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.51, 0.54, NULL,    'R-1234yf · PAG oil ND-12',                    NULL,         NULL,  NULL,   NULL, 'Charge weight 510 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       113, 83,  'M12×1.25; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    23,  17,  'NGK ILZKAR8H8S iridium (PR25DD); DILKAR8E8GS (4B12 PHEV).'),
  (@gen_id, NULL, 'oil_drain',     34,  25,  'M12×1.25; new gasket (PN 11026-01M02 — Nissan part).'),
  (@gen_id, NULL, 'caliper_bolt',  37,  27,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 113, 83, 'Front caliper carrier-to-knuckle.'),
  (@gen_id, NULL, 'rear_diff_fill_plug',  44, 32, 'S-AWC only.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '24F / S-95 EFB', 600, 65, 130);
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
  (@gen_id, NULL, 'cargo',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 180, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F02', 120, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'F05', 60,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F08', 40,  'ABS pump'),
  (@gen_id, NULL, 'under_hood', 'F12', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F15', 15,  'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'F18', 20,  'Ignition coils'),
  (@gen_id, NULL, 'cabin',      'F30', 7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'F35', 15,  'Mitsubishi Connect infotainment'),
  (@gen_id, NULL, 'cabin',      'F42', 25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F45', 25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'F50', 40,  'Heater blower'),
  (@gen_id, NULL, 'cabin',      'F55', 30,  'PHEV charging port (4B12 PHEV only)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '1822A050',      'Mitsubishi', 0.80, NULL,    'PR25DD NGK ILZKAR8H8S iridium'),
  (@gen_id, NULL, 'oil_filter',    '1230A209',      'Mitsubishi', NULL, NULL,    'Spin-on; PR25DD (Nissan-shared 15208-9N01A)'),
  (@gen_id, NULL, 'air_filter',    '1500A788',      'Mitsubishi', NULL, NULL,    'Panel filter GN'),
  (@gen_id, NULL, 'cabin_filter',  '7803A005',      'Mitsubishi', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '8250A801',      'Mitsubishi', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '8250A802',      'Mitsubishi', NULL, '18 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  3750,  12000, 6000,  12, '4.95 qt 0W-20.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, 'S-AWC requires matched tread depth.'),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'NS-3 CVT fluid. Severe = towing.'),
  (@gen_id, NULL, 'rear_differential_fluid',30000, 15000, 48000, 24000, NULL, 'S-AWC only — critical for AWD function.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            105000,NULL,  168000,NULL,  NULL, 'NGK ILZKAR8H8S iridium.'),
  (@gen_id, NULL, 'coolant_flush',          105000,NULL,  168000,NULL,  84,   'Mitsubishi Super LLC pink.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '235/65 R18 106H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/65 R18 106H'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '255/45 R20 101W'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '255/45 R20 101W'),
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
