-- Toyota Highlander (XU70) moat fill — 4th-gen 3-row SUV, 2020-2025
-- TNGA-K platform (shared with Camry XV70). Engines: A25A-FXS 2.5L hybrid
-- (243 hp combined, eCVT, all years), 2GR-FKS 3.5L V6 (295 hp, 8AT, 2020-2022),
-- T24A-FTS 2.4L turbo (265 hp, 8AT, 2023+ facelift).
-- Cross-verified against Toyota 2022 Highlander OM, 2023 facelift Quick Reference
-- Guide, and Toyota Service Information for TNGA-K platform.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'XU70' AND display_name LIKE 'Highlander%' LIMIT 1);

INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota Highlander (XU70) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota Highlander (XU70) Owner''s Manual');
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Toyota Highlander (XU70) Owner''s Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/toyota/highlander-xu70-suv-2020-2025/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Toyota_Highlander_Hybrid_(XU70)_1X7A6356.jpg',
  CURDATE(), 'Toyota Highlander Hybrid (XU70)', '3-4-front', 1280, 720
FROM generations g WHERE g.id = @gen_id;

-- Engines: 2.5L hybrid (A25A-FXS), 3.5L V6 (2GR-FKS, MY20-22), 2.4T (T24A-FTS, MY23+)
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.30, 4.50, '0W-16', 'API SP / ILSAC GF-6B (0W-20 acceptable)',    '04152-YZZA6', 10000, 16000, 12, '2.5L A25A-FXS hybrid · 4.5 US qt with filter. V6 2GR-FKS: 6.4 qt 0W-20. 2.4T T24A-FTS (2023+): 5.7 qt 0W-16.'),
  (@gen_id, NULL, 'transmission_at', 6.60, 6.97, NULL,    'Toyota Genuine ATF WS',                       NULL,          NULL,  NULL,   NULL, 'Aisin AWF8F45 8-speed (V6 2020-2022; 2.4T 2023+). "Fill for life" per Toyota; severe-duty drain-and-fill 60k mi recommended.'),
  (@gen_id, NULL, 'transmission_ecvt', 4.20, 4.44, NULL,  'Toyota Genuine ATF WS',                       NULL,          NULL,  NULL,   NULL, 'Hybrid eCVT (P810) — no torque converter. Toyota WS only.'),
  (@gen_id, NULL, 'coolant',         9.10, 9.62, NULL,    'Toyota Super Long Life Coolant (SLLC, pink)', NULL,          NULL,  NULL,   NULL, 'Initial change 100k mi / 10 yr, then 50k mi / 5 yr. Hybrid inverter loop separate (~2.5 L same SLLC).'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Toyota Genuine Brake Fluid DOT 3 (or DOT 4)', NULL,          NULL,  NULL,   36,   'Inspect 30k mi; replace 3 yr per dealer.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.55, 0.58, NULL,    'R-1234yf · PAG oil ND-OIL 12',                NULL,          NULL,  NULL,   NULL, '550 ±25 g R-1234yf (US/EU 2020+).'),
  (@gen_id, NULL, 'rear_differential', 0.95, 1.00, NULL,  'Toyota Differential Gear Oil LT 75W-85 GL-5', NULL,          NULL,  NULL,   NULL, 'AWD trims only — Dynamic Torque Control AWD coupling rear unit.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',              103, 76,  'M12×1.5; star pattern; re-torque after 100 mi.'),
  (@gen_id, NULL, 'spark_plug',           18,  13,  'Denso FK20HR11 (hybrid 2.5) / SC20HR11 (V6) / FK16HR-A8 (2.4T).'),
  (@gen_id, NULL, 'oil_drain',            40,  30,  'M14×1.5; new aluminum gasket each change.'),
  (@gen_id, NULL, 'caliper_slide_pin',    34,  25,  'Front floating caliper guide pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 107, 79,  'Front carrier-to-knuckle (TNGA-K standard).'),
  (@gen_id, NULL, 'oil_filter_housing',   25,  18,  'Cartridge housing — A25A-FXS upper.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'H6 (LN3) AGM', 760, 80, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'turn_side_mirror','LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_chmsl',    'LED', 1, 1),
  (@gen_id, NULL, 'reverse',        'W16W (921)', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED / W5W', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'W5W (T10)', 1, 0),
  (@gen_id, NULL, 'glove_box',      'W5W (T10)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — derived from Toyota 2022 Highlander OM section 6-3 (engine compartment) and 6-4 (instrument panel)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'engine_bay', 'AM1',     50,  'Power source (ignition switch)'),
  (@gen_id, NULL, 'engine_bay', 'AM2',     30,  'Power source (ECU-B, IG2)'),
  (@gen_id, NULL, 'engine_bay', 'EFI MAIN',30,  'Engine fuel injection / ignition (V6/2.4T)'),
  (@gen_id, NULL, 'engine_bay', 'HEAD LH', 25,  'Left headlight'),
  (@gen_id, NULL, 'engine_bay', 'HEAD RH', 25,  'Right headlight'),
  (@gen_id, NULL, 'engine_bay', 'ABS NO.1',40,  'ABS / Vehicle Stability Control'),
  (@gen_id, NULL, 'engine_bay', 'ABS NO.2',30,  'ABS motor'),
  (@gen_id, NULL, 'engine_bay', 'RDI FAN', 30,  'Engine cooling fan (hybrid)'),
  (@gen_id, NULL, 'engine_bay', 'STOP',    20,  'Brake light circuit'),
  (@gen_id, NULL, 'engine_bay', 'HORN',    10,  'Horn'),
  (@gen_id, NULL, 'cabin',      'PWR OUTLET', 20, 'Front 12V accessory socket'),
  (@gen_id, NULL, 'cabin',      'CIG',     15,  'Cigarette lighter (where equipped)'),
  (@gen_id, NULL, 'cabin',      'ECU-IG1', 10,  'Engine / hybrid ECU'),
  (@gen_id, NULL, 'cabin',      'AUDIO',   15,  'Audio/multimedia head unit'),
  (@gen_id, NULL, 'cabin',      'DOME',    10,  'Interior lights'),
  (@gen_id, NULL, 'cabin',      'WIPER',   30,  'Front wiper motor'),
  (@gen_id, NULL, 'cabin',      'RR WIP',  15,  'Rear wiper motor'),
  (@gen_id, NULL, 'cabin',      'SEAT HTR',20,  'Heated seats (Limited+)'),
  (@gen_id, NULL, 'cabin',      'PWR DR L',25,  'Left power door / window'),
  (@gen_id, NULL, 'cabin',      'PWR DR R',25,  'Right power door / window');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '90919-01298',   'Denso (Toyota OE)',  0.80, NULL,    'Denso FK20HR11 — 2.5L hybrid A25A-FXS'),
  (@gen_id, NULL, 'spark_plug',    '90919-01253',   'Denso (Toyota OE)',  0.80, NULL,    'Denso SC20HR11 — 3.5L V6 2GR-FKS'),
  (@gen_id, NULL, 'oil_filter',    '04152-YZZA6',   'Toyota Genuine',     NULL, NULL,    'Cartridge; hybrid 2.5 (TNGA-K)'),
  (@gen_id, NULL, 'oil_filter',    '04152-31110',   'Toyota Genuine',     NULL, NULL,    'Cartridge; V6 2GR-FKS'),
  (@gen_id, NULL, 'air_filter',    '17801-F0050',   'Toyota Genuine',     NULL, NULL,    'Engine air filter (TNGA-K Highlander/Sienna)'),
  (@gen_id, NULL, 'cabin_filter',  '87139-0E040',   'Toyota Genuine',     NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '85212-0E090',   'Toyota Genuine',     NULL, '26 in', 'Driver side hybrid blade'),
  (@gen_id, NULL, 'wiper_front_p', '85222-0E060',   'Toyota Genuine',     NULL, '21 in', 'Passenger side'),
  (@gen_id, NULL, 'wiper_rear',    '85242-0E040',   'Toyota Genuine',     NULL, '12 in', 'Rear hatch');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12,  'Toyota maintenance schedule — 5k severe (towing, dusty, short trips).'),
  (@gen_id, NULL, 'tire_rotation',          5000,  5000,  8000,  8000,  NULL, 'Every other oil change.'),
  (@gen_id, NULL, 'brake_inspection',       10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  60000, 30000, 96000, 48000, NULL, '8AT drain-and-fill severe duty; "fill for life" normal.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  36,   'Dealer-recommended 3 yr.'),
  (@gen_id, NULL, 'spark_plugs',            120000,60000, 192000,96000, NULL, 'Iridium 120k; hybrid same plug, longer effective life.'),
  (@gen_id, NULL, 'coolant_flush',          100000,50000, 160000,80000, 120,  'Toyota SLLC initial 100k/10yr, then 50k/5yr.'),
  (@gen_id, NULL, 'rear_diff_oil',          60000, 30000, 96000, 48000, NULL, 'AWD trims — Dynamic Torque Control rear coupling.'),
  (@gen_id, NULL, 'pcv_valve',              60000, 30000, 96000, 48000, NULL, 'V6 only.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/65 R18 (L / LE / XLE)'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '235/65 R18 (L / LE / XLE)'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/55 R20 (Limited / Platinum)'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '235/55 R20 (Limited / Platinum)'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T155/70 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT 'highlander-xu70 moat fill complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs        WHERE generation_id = @gen_id) AS fluid_specs,
  (SELECT COUNT(*) FROM torque_specs       WHERE generation_id = @gen_id) AS torque_specs,
  (SELECT COUNT(*) FROM electrical_specs   WHERE generation_id = @gen_id) AS electrical_specs,
  (SELECT COUNT(*) FROM bulbs              WHERE generation_id = @gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses              WHERE generation_id = @gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts              WHERE generation_id = @gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals  WHERE generation_id = @gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures     WHERE generation_id = @gen_id) AS tire_pressures;
