-- Chevrolet Silverado 1500 (T1) moat fill — 4th-gen pickup, 2019-2024
-- Cross-verified against startmycar.com fuse-box (2020 Silverado, 92+25+42
-- positions extracted live), HaynesPro WorkshopData, Chevrolet OM, ACDelco
-- parts catalog. T1XX platform shared with GMC Sierra 1500.
-- Powertrains: 5.3 EcoTec3 L84 V8 (DFM), 6.2 L87 V8, 2.7 L3B turbo I4,
--              3.0 LM2/LZ0 Duramax inline-6 diesel.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'T1' AND display_name LIKE 'Silverado%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Chevrolet Silverado 1500 (T1) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/chevrolet/silverado-t1-pickup-2019-2024/hero.jpg', 'wikimedia', 'public-domain',
  'Bull-Doser / Wikimedia Commons, Public domain',
  'https://commons.wikimedia.org/wiki/File:%2719_Chevrolet_Silverado_1500_Crew_Cab_%40_Francos_2019.jpg',
  CURDATE(), '2019 Chevrolet Silverado 1500 Crew Cab (T1)', '3-4-front', 1280, 772
FROM generations g WHERE g.id = @gen_id;

-- 5.3 EcoTec3 L84 V8 — volume powertrain on LT/RST/LTZ
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      7.60, 8.00, '0W-20', 'dexos1 Gen 3 (ACDelco)',                       'PF63E',     7500,  12000, 12, '5.3 L84 V8 · 8.0 qt with filter. 6.2 L87 V8: 8.0 qt. 2.7 L3B turbo: 6.0 qt dexos1. 3.0 Duramax I6 diesel: 7.5 qt dexos D 5W-30.'),
  (@gen_id, NULL, 'transmission_at', 11.4, 12.04, NULL,   'GM Hydra-Matic AFL fluid (88861800)',          NULL,         97500, 156000, NULL, '10L80 10-speed auto (5.3/6.2 V8 4WD). 8L90 on some 6.2; GM lifetime fill — change with adverse conditions per dealer.'),
  (@gen_id, NULL, 'transfer_case',   1.20, 1.27, NULL,    'AutoTrak II / Borg-Warner Active Transfer Case', NULL,        50000, 80000,  NULL, '4WD models. Manual t-case = SAE 80W-90 GL-5; Auto-trak II uses AutoTrak II fluid.'),
  (@gen_id, NULL, 'front_differential',1.42,1.50, NULL,   'SAE 75W-90 GL-5 (4WD only)',                   NULL,         50000, 80000,  NULL, '8.25" IFS front diff.'),
  (@gen_id, NULL, 'rear_differential',1.66,1.75, NULL,    'SAE 75W-90 GL-5 + GM friction modifier',       NULL,         50000, 80000,  NULL, '9.5" rear diff (open or G80 locker). Severe = 30k.'),
  (@gen_id, NULL, 'coolant',         14.7, 15.5, NULL,    'GM dexcool (orange, pre-mixed)',                NULL,         150000,240000, 60, 'First 150k mi / 5 yr, then every 100k mi.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'GM Genuine DOT 3 (88958860)',                  NULL,         30000, 48000,  36, 'Mileage or 3 yr.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.79, 0.84, NULL,    'R-134a · PAG oil PAG46',                       NULL,         NULL,  NULL,   NULL, '790 ±20 g. T1 stayed on R-134a unlike newer GM platforms.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       190, 140, 'M14×1.5; star pattern. Heavy by class.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'ACDelco 41-114 platinum (L84 V8).'),
  (@gen_id, NULL, 'oil_drain',     25,  18,  'M14×1.5; new crush washer (11588776).'),
  (@gen_id, NULL, 'caliper_bolt',  45,  33,  'Front caliper slide-pin (Brembo on Trail Boss).'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 250, 184, 'Front carrier-to-knuckle.'),
  (@gen_id, NULL, 'transfer_case_drain', 35, 26, 'NV264 / BW 4493.'),
  (@gen_id, NULL, 'diff_fill_plug', 33, 24, 'Front 8.25" / Rear 9.5".'),
  (@gen_id, NULL, 'half-shaft_nut', 244, 180, 'Axle hub nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, '94R / H7 AGM (dual on diesel)', 730, 80, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED (LT+) / 9006', 2, 0),
  (@gen_id, NULL, 'headlight_high', 'LED (LT+) / 9005', 2, 0),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     '3157A', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED (LT+) / 3157', 2, 0),
  (@gen_id, NULL, 'reverse',        '921', 2, 0),
  (@gen_id, NULL, 'turn_rear',      '3157', 2, 0),
  (@gen_id, NULL, 'license_plate',  '194', 2, 0),
  (@gen_id, NULL, 'interior_dome',  '578', 1, 0),
  (@gen_id, NULL, 'interior_map',   '194', 2, 0),
  (@gen_id, NULL, 'cargo_bed',      'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — REAL DATA from startmycar.com /chevrolet/silverado-1500/info/fusebox/2020
-- (92 underhood + 25 driver + 42 IP-left positions; key high-value entries below)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', '1',  10,  'High-beam left'),
  (@gen_id, NULL, 'under_hood', '2',  10,  'High-beam right'),
  (@gen_id, NULL, 'under_hood', '3',  20,  'Headlamp left'),
  (@gen_id, NULL, 'under_hood', '4',  20,  'Headlamp right'),
  (@gen_id, NULL, 'under_hood', '8',  15,  'Fog lamp'),
  (@gen_id, NULL, 'under_hood', '13', 15,  'Washer front'),
  (@gen_id, NULL, 'under_hood', '19', 60,  'DC/AC inverter (110 V bed outlet)'),
  (@gen_id, NULL, 'under_hood', '46', 15,  'Engine control module ignition'),
  (@gen_id, NULL, 'under_hood', '47', 10,  'Transmission control module ignition'),
  (@gen_id, NULL, 'under_hood', '52', 25,  'Front wiper'),
  (@gen_id, NULL, 'under_hood', '63', 30,  'Trailer battery'),
  (@gen_id, NULL, 'under_hood', '66', 50,  'Cooling fan motor left'),
  (@gen_id, NULL, 'under_hood', '71', 50,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', '84', 30,  'Trailer brake'),
  (@gen_id, NULL, 'cabin',      'F1', 20,  'Rear heated seats'),
  (@gen_id, NULL, 'cabin',      'F6', 20,  'Heated and ventilated seats'),
  (@gen_id, NULL, 'cabin',      'F9', 15,  'Passive entry / Passive start'),
  (@gen_id, NULL, 'cabin',      'F2', 30,  'Left doors module'),
  (@gen_id, NULL, 'cabin',      'F6-IP', 40, 'Front blower'),
  (@gen_id, NULL, 'cabin',      'F10', 15, 'Body control module 6/7');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '41-114',     'ACDelco',  1.10, NULL,    '5.3/6.2 V8 platinum'),
  (@gen_id, NULL, 'oil_filter',    'PF63E',      'ACDelco',  NULL, NULL,    'Cartridge; 5.3/6.2/2.7 EcoTec'),
  (@gen_id, NULL, 'air_filter',    'A3204C',     'ACDelco',  NULL, NULL,    'Panel filter'),
  (@gen_id, NULL, 'cabin_filter',  'CF188',      'ACDelco',  NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '8-2228',     'ACDelco',  NULL, '22 in', 'Driver'),
  (@gen_id, NULL, 'wiper_front_p', '8-2228',     'ACDelco',  NULL, '22 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  3000,  12000, 5000,  12, '8.0 qt 0W-20 dexos1 (5.3 V8). Severe = towing, dust.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      45000, 22500, 72000, 36000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       22500, 11250, 36000, 18000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  97500, 45000, 156000,72000, NULL, '10L80; GM lifetime; severe duty 45k.'),
  (@gen_id, NULL, 'transfer_case_fluid',    50000, 30000, 80000, 48000, NULL, '4WD only. AutoTrak II fluid.'),
  (@gen_id, NULL, 'rear_differential_fluid',50000, 30000, 80000, 48000, NULL, 'G80 locker = severe.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  36,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            100000,NULL,  160000,NULL,  NULL, 'ACDelco 41-114 platinum.'),
  (@gen_id, NULL, 'coolant_flush',          150000,NULL,  240000,NULL,  60,   'GM dexcool — first 5 yr / 150k mi.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 36, 250, '265/70 R17 115T'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '265/70 R17 115T'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '275/60 R20 114T (LTZ)'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '275/60 R20 114T (LTZ)'),
  (@gen_id, NULL, 'front', 'loaded', 45, 310, '275/60 R20 114T'),
  (@gen_id, NULL, 'rear',  'loaded', 60, 415, '275/60 R20 114T'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, '265/70 R17 (full-size matching)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
