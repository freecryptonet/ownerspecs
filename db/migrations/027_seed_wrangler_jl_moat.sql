-- Jeep Wrangler (JL) moat fill — 4th-gen off-road SUV, 2018-2023
-- Cross-verified against HaynesPro WorkshopData, Jeep OM, Mopar parts catalog.
-- 3.6 Pentastar V6 + 2.0 Hurricane I4 turbo + 3.0 EcoDiesel V6 + 6.4 392 HEMI.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'JL' AND display_name LIKE 'Wrangler%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Jeep Wrangler (JL) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/jeep/wrangler-jl-suv-2018-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Jeep_Wrangler_Rubicon_(JL)_4xe_1X7A0285.jpg',
  CURDATE(), 'Jeep Wrangler Rubicon (JL) 4xe', '3-4-front', 1280, 724
FROM generations g WHERE g.id = @gen_id;

-- 3.6 Pentastar V6 — volume powertrain
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.70, 5.00, '5W-20', 'Mopar MS-6395 / API SP (Pennzoil Platinum 5W-20)', '68191349AC', 10000, 16000, 12, '3.6 Pentastar V6 · 5.0 qt with filter. 2.0 Hurricane turbo: 5.5 qt 5W-30 (FCA MS-12991). 3.0 EcoDiesel: 8.0 qt 5W-30 MS-10902.'),
  (@gen_id, NULL, 'transmission_at', 9.50, 10.04, NULL,   'Mopar ZF 8&9 Speed ATF (68157995AC)',              NULL,         60000, 96000, NULL, '8-speed 850RE; ZF 8HP-derived. FCA labels lifetime; off-road severe duty 30k.'),
  (@gen_id, NULL, 'transmission_mt', 2.20, 2.33, NULL,    'Mopar Manual Transmission Lubricant (68088034AC)', NULL,         60000, 96000, NULL, '6-speed manual D478 available on JL.'),
  (@gen_id, NULL, 'transfer_case',   1.30, 1.37, NULL,    'Mopar NV241OR transfer-case fluid',                NULL,         30000, 48000, NULL, 'Rubicon Rock-Trac NV241OR; standard Command-Trac NV241. Severe duty 15k.'),
  (@gen_id, NULL, 'front_differential',1.42,1.50, NULL,   'Mopar SAE 75W-85 GL-5 + Limited-Slip Additive',    NULL,         30000, 48000, NULL, 'Dana 30 front (Sport/Sahara); Dana 44 Rubicon.'),
  (@gen_id, NULL, 'rear_differential',1.66,1.75, NULL,    'Mopar SAE 75W-85 GL-5 + Limited-Slip Additive',    NULL,         30000, 48000, NULL, 'Dana 35 rear (Sport); Dana 44 Sahara/Rubicon. Critical for off-road.'),
  (@gen_id, NULL, 'coolant',         13.0, 13.74, NULL,   'Mopar OAT (purple, MS-12106)',                     NULL,         150000,240000, 120, 'First replacement 10 yr / 150k mi.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Mopar DOT 3 high-temp',                            NULL,         30000, 48000, 36,   'Mileage or 3 yr.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.62, 0.66, NULL,    'R-1234yf · PAG oil ND-12',                         NULL,         NULL,  NULL,   NULL, '620 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       176, 130, 'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    18,  13,  'Champion REC10WYC4 platinum (3.6 V6).'),
  (@gen_id, NULL, 'oil_drain',     34,  25,  'M14×1.5; new crush washer.'),
  (@gen_id, NULL, 'caliper_bolt',  43,  32,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 149, 110, 'Front carrier-to-knuckle.'),
  (@gen_id, NULL, 'transfer_case_drain', 35, 26, 'NV241/241OR drain plug.'),
  (@gen_id, NULL, 'diff_fill_plug',     34, 25, 'Dana 30/35/44 fill.'),
  (@gen_id, NULL, 'half-shaft_nut',     244, 180, 'Axle hub nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'H7 / Group 94R AGM', 800, 80, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'H13 (LED on Sahara+)', 2, 0),
  (@gen_id, NULL, 'headlight_high', 'H13 (LED on Sahara+)', 2, 0),
  (@gen_id, NULL, 'fog_front',      'H10', 2, 0),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     '4157NAK', 2, 0),
  (@gen_id, NULL, 'brake_tail',     '3157 (LED on Sahara+)', 2, 0),
  (@gen_id, NULL, 'reverse',        '3157', 2, 0),
  (@gen_id, NULL, 'turn_rear',      '3157NA', 2, 0),
  (@gen_id, NULL, 'license_plate',  '194', 2, 0),
  (@gen_id, NULL, 'interior_dome',  '578', 1, 0),
  (@gen_id, NULL, 'interior_map',   '194', 2, 0),
  (@gen_id, NULL, 'cargo',          '194', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 200, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F05', 175, 'PCM power'),
  (@gen_id, NULL, 'under_hood', 'F08', 80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F11', 50,  'ABS / ESC'),
  (@gen_id, NULL, 'under_hood', 'F14', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F18', 20,  'Fuel pump'),
  (@gen_id, NULL, 'under_hood', 'F22', 15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'F25', 30,  'Winch power outlet (Rubicon)'),
  (@gen_id, NULL, 'under_hood', 'F28', 30,  'Sway-bar disconnect (Rubicon)'),
  (@gen_id, NULL, 'cabin',      'M01', 7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      'M05', 15,  'Uconnect 4 / 5 infotainment'),
  (@gen_id, NULL, 'cabin',      'M10', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'M15', 40,  'HVAC blower'),
  (@gen_id, NULL, 'cabin',      'M20', 20,  'Heated seats');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    'SP-RC10WYC4', 'Mopar (Champion)', 1.10, NULL,    '3.6 Pentastar V6'),
  (@gen_id, NULL, 'oil_filter',    '68191349AC',  'Mopar',            NULL, NULL,    'Cartridge; 3.6 Pentastar'),
  (@gen_id, NULL, 'air_filter',    '68257030AA',  'Mopar',            NULL, NULL,    'Panel filter JL'),
  (@gen_id, NULL, 'cabin_filter',  '68301863AA',  'Mopar',            NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '68301831AA',  'Mopar',            NULL, '15 in', 'Driver — short for off-road clearance'),
  (@gen_id, NULL, 'wiper_front_p', '68301832AA',  'Mopar',            NULL, '15 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, '5.0 qt 5W-20 (3.6 V6). Off-road / water-fording = severe.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, 'Severe = dust / off-road.'),
  (@gen_id, NULL, 'cabin_air_filter',       20000, 10000, 32000, 16000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  60000, 30000, 96000, 48000, NULL, '850RE 8-speed.'),
  (@gen_id, NULL, 'transfer_case_fluid',    30000, 15000, 48000, 24000, NULL, 'NV241OR Rock-Trac; severe = water-fording.'),
  (@gen_id, NULL, 'front_differential_fluid',30000,15000, 48000, 24000, NULL, 'Dana 30/44.'),
  (@gen_id, NULL, 'rear_differential_fluid',30000, 15000, 48000, 24000, NULL, 'Dana 35/44. Required after water crossing.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  36,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            100000,NULL,  160000,NULL,  NULL, 'Champion REC10WYC4 platinum.'),
  (@gen_id, NULL, 'coolant_flush',          150000,NULL,  240000,NULL,  120,  'Mopar OAT purple.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 37, 255, '245/75 R17 112T'),
  (@gen_id, NULL, 'rear',  'normal', 37, 255, '245/75 R17 112T'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '255/75 R17 113T (Sahara)'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '255/75 R17 113T (Sahara)'),
  (@gen_id, NULL, 'front', 'normal', 37, 255, 'LT285/70 R17 121Q (Rubicon)'),
  (@gen_id, NULL, 'rear',  'normal', 37, 255, 'LT285/70 R17 121Q (Rubicon)'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Full-size matching (tailgate-mounted)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
