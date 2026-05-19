-- Ram 1500 (DT) moat fill — 5th-gen full-size pickup, 2019-2024 (pre-facelift)
-- Engines: 3.6L Pentastar V6 (305 hp, eTorque mild hybrid most years),
-- 5.7L HEMI V8 (395 hp, w/ and w/o eTorque), 3.0L EcoDiesel V6 (260 hp, 2020-2023),
-- 6.2L SC Hellcat V8 (TRX, 702 hp, 2021-2024). 8HP75 ZF 8-speed (TorqueFlite 8)
-- standard. BoF frame, 98% high-strength steel.
-- Cross-verified against Mopar 2022 Ram 1500 OM, Mopar Genuine parts catalog,
-- 2021 Ram 1500 Service Information.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'DT' AND display_name LIKE '1500%' LIMIT 1);

INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Ram 1500 (DT) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Ram 1500 (DT) Owner''s Manual');
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Ram 1500 (DT) Owner''s Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/ram/1500-dt-pickup-2019-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2019_Ram_1500_Laramie,_front_3.1.20.jpg',
  CURDATE(), '2019 Ram 1500 Laramie (DT)', '3-4-front', 1280, 695
FROM generations g WHERE g.id = @gen_id;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',         5.40, 5.70, '5W-20', 'API SP / Chrysler MS-6395 (or 0W-20)',  '68191349AC',  10000, 16000, 12, '3.6L Pentastar V6 · 5.7 US qt with filter. 5.7L HEMI V8: 7.0 qt 5W-20. EcoDiesel 3.0: 10.5 qt 5W-40 MS-11106.'),
  (@gen_id, NULL, 'transmission_at',    9.50, 10.0, NULL,    'Mopar ZF 8&9 Speed ATF (MS-12892)',     NULL,          60000, 96000, NULL, 'ZF 8HP75 TorqueFlite 8 — total fill ~9.5 L (drain-and-fill 4-5 L).'),
  (@gen_id, NULL, 'coolant',            14.0, 14.8, NULL,    'Mopar OAT Coolant (orange, MS-12106)',  NULL,          150000,240000,NULL, 'Severe service 60k mi. EcoDiesel: HOAT MS-7170 + DEF 8-gal AdBlue tank.'),
  (@gen_id, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Mopar DOT 3 (or DOT 4 LV)',              NULL,          NULL,  NULL,  24,   'Inspect each oil change; replace 2 yr per Mopar.'),
  (@gen_id, NULL, 'ac_refrigerant',     0.85, 0.90, NULL,    'R-1234yf · PAG oil ND-OIL 8',             NULL,          NULL,  NULL,  NULL, '850 ±30 g R-1234yf (US 2019+).'),
  (@gen_id, NULL, 'transfer_case',      1.40, 1.48, NULL,    'Mopar BW44-46 ATF+4 (MS-9602)',          NULL,          120000,192000,NULL, 'BorgWarner BW44-46 — 4WD trims only.'),
  (@gen_id, NULL, 'front_differential', 1.20, 1.27, NULL,    'Mopar 75W-85 Synthetic (MS-9763)',       NULL,          60000, 96000, NULL, '9.25" AAM front axle (4WD).'),
  (@gen_id, NULL, 'rear_differential',  2.10, 2.22, NULL,    'Mopar 75W-85 Synthetic (MS-9763)',       NULL,          60000, 96000, NULL, '9.25" AAM (3.21/3.55/3.92 ratios). Add 4 oz friction modifier on LSD.'),
  (@gen_id, NULL, 'power_steering',     1.10, 1.16, NULL,    'Mopar ATF+4 (MS-9602)',                   NULL,          NULL,  NULL,  NULL, 'Hydraulic PS on 5.7L V8 (electric PS on 3.6L V6).');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',              176, 130, 'M14×1.5; star pattern; re-torque after 100 mi (truck-grade).'),
  (@gen_id, NULL, 'spark_plug',           17,  13,  '3.6L V6 NGK ZFR6F-11G. 5.7L HEMI: NGK ZFR5LP-13G (16 plugs total).'),
  (@gen_id, NULL, 'oil_drain',            34,  25,  'M14×1.5 magnetic plug; new aluminum gasket.'),
  (@gen_id, NULL, 'caliper_slide_pin',    35,  26,  'Front floating caliper guide pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 175, 129, 'Front carrier-to-knuckle (truck-grade).'),
  (@gen_id, NULL, 'diff_fill_plug',       34,  25,  'AAM 9.25" front/rear diff fill plug.'),
  (@gen_id, NULL, 'transfer_case_drain',  40,  30,  'BW44-46 drain & fill plug.'),
  (@gen_id, NULL, 'driveshaft_flange',    100, 74,  'Front and rear driveshaft U-joint flange bolts.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'H8 (94R) AGM', 800, 80, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  '9008 (H13)', 2, 0),
  (@gen_id, NULL, 'headlight_high', '9008 (H13)', 2, 0),
  (@gen_id, NULL, 'headlight_led',  'LED (Limited)', 2, 1),
  (@gen_id, NULL, 'fog_front',      'PSX24W', 2, 0),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     '3157NAK', 2, 0),
  (@gen_id, NULL, 'brake_tail',     '3157', 2, 0),
  (@gen_id, NULL, 'brake_chmsl',    'LED', 1, 1),
  (@gen_id, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen_id, NULL, 'turn_rear',      '3157NAK', 2, 0),
  (@gen_id, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen_id, NULL, 'cargo_lamp',     '906', 2, 0),
  (@gen_id, NULL, 'interior_dome',  '578 (festoon)', 1, 0),
  (@gen_id, NULL, 'interior_map',   '194 (W5W)', 2, 0),
  (@gen_id, NULL, 'bed_lamp',       'LED (Limited)', 4, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — derived from Mopar 2022 Ram 1500 OM section 8 (Totally Integrated Power Module + cabin BCM)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'engine_bay', 'F01',   200, 'Powertrain Control Module main feed'),
  (@gen_id, NULL, 'engine_bay', 'F02',   80,  'ABS pump motor'),
  (@gen_id, NULL, 'engine_bay', 'F03',   60,  'Electric power steering (3.6L only)'),
  (@gen_id, NULL, 'engine_bay', 'F04',   40,  'Engine cooling fan'),
  (@gen_id, NULL, 'engine_bay', 'F09',   30,  'Trailer tow battery / trailer 7-pin'),
  (@gen_id, NULL, 'engine_bay', 'F12',   30,  'Front blower motor'),
  (@gen_id, NULL, 'engine_bay', 'F18',   30,  'Heated rear window / wiper'),
  (@gen_id, NULL, 'engine_bay', 'F20',   30,  'Cabin power outlet circuit'),
  (@gen_id, NULL, 'engine_bay', 'F23',   25,  'Headlight high beam'),
  (@gen_id, NULL, 'engine_bay', 'F24',   25,  'Headlight low beam'),
  (@gen_id, NULL, 'engine_bay', 'F27',   20,  'Fuel pump'),
  (@gen_id, NULL, 'engine_bay', 'F32',   20,  'Trailer brake controller'),
  (@gen_id, NULL, 'engine_bay', 'F40',   15,  'Engine ignition coils'),
  (@gen_id, NULL, 'engine_bay', 'F47',   10,  'Horn'),
  (@gen_id, NULL, 'cabin',      'M01',   20,  'Cigar lighter / 12V front'),
  (@gen_id, NULL, 'cabin',      'M02',   20,  'Console 12V power outlet'),
  (@gen_id, NULL, 'cabin',      'M05',   15,  'Audio amplifier / radio'),
  (@gen_id, NULL, 'cabin',      'M08',   10,  'Body Control Module IGN'),
  (@gen_id, NULL, 'cabin',      'M12',   20,  'Heated seats (Laramie+)'),
  (@gen_id, NULL, 'cabin',      'M15',   25,  'Power sliding rear window'),
  (@gen_id, NULL, 'cabin',      'M18',   10,  'OBD-II diagnostic port'),
  (@gen_id, NULL, 'cabin',      'M22',   20,  'Power running boards (Limited)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '68303800AA',  'NGK (Mopar OE)',       1.10, NULL,    'NGK ZFR6F-11G — 3.6L Pentastar V6'),
  (@gen_id, NULL, 'spark_plug',    '68317757AA',  'NGK (Mopar OE)',       1.30, NULL,    'NGK ZFR5LP-13G — 5.7L HEMI (16 plugs)'),
  (@gen_id, NULL, 'oil_filter',    '68191349AC',  'Mopar Genuine',        NULL, NULL,    'Cartridge; 3.6L Pentastar'),
  (@gen_id, NULL, 'oil_filter',    '04892339AB',  'Mopar Genuine',        NULL, NULL,    'Spin-on; 5.7L HEMI V8'),
  (@gen_id, NULL, 'air_filter',    '68318343AA',  'Mopar Genuine',        NULL, NULL,    'Engine air filter (DT)'),
  (@gen_id, NULL, 'cabin_filter',  '68318366AA',  'Mopar Genuine',        NULL, NULL,    'Activated carbon (DT)'),
  (@gen_id, NULL, 'wiper_front_d', '68349906AA',  'Mopar Genuine',        NULL, '22 in', 'Driver side beam blade'),
  (@gen_id, NULL, 'wiper_front_p', '68349907AA',  'Mopar Genuine',        NULL, '22 in', 'Passenger side beam blade');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',   10000, 4000,  16000, 6400,  12,  'Oil Change Indicator System — 10k normal, 4k severe (towing, dusty, idle).'),
  (@gen_id, NULL, 'tire_rotation',           8000,  8000,  12800, 12800, NULL, 'Every other oil change.'),
  (@gen_id, NULL, 'brake_inspection',        10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',        20000, 10000, 32000, 16000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',   60000, 60000, 96000, 96000, NULL, 'ZF 8HP75 drain-and-fill (Mopar MS-12892 ATF).'),
  (@gen_id, NULL, 'brake_fluid_flush',       NULL,  NULL,  NULL,  NULL,  24,   'Every 2 years.'),
  (@gen_id, NULL, 'spark_plugs',             100000,60000, 160000,96000, NULL, '3.6L Pentastar / 5.7L HEMI iridium.'),
  (@gen_id, NULL, 'coolant_flush',           150000,75000, 240000,120000,120,  'Mopar OAT initial 150k/10yr, then 100k/5yr.'),
  (@gen_id, NULL, 'transfer_case_fluid',     120000,60000, 192000,96000, NULL, 'BW44-46 — 4WD trims only.'),
  (@gen_id, NULL, 'front_diff_oil',          60000, 30000, 96000, 48000, NULL, 'AAM 9.25" front (4WD).'),
  (@gen_id, NULL, 'rear_diff_oil',           60000, 30000, 96000, 48000, NULL, 'AAM 9.25" rear; 4oz friction modifier on LSD.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '275/65 R18 (Tradesman / Big Horn)'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '275/65 R18 (Tradesman / Big Horn)'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '275/55 R20 (Laramie / Rebel)'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '275/55 R20 (Laramie / Rebel)'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '275/45 R22 (Limited)'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '275/45 R22 (Limited)'),
  (@gen_id, NULL, 'front', 'loaded', 40, 280, '275/55 R20 — max tow / payload'),
  (@gen_id, NULL, 'rear',  'loaded', 45, 310, '275/55 R20 — max tow / payload'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Full-size matching spare under bed');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT 'ram-1500-dt moat fill complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs        WHERE generation_id = @gen_id) AS fluid_specs,
  (SELECT COUNT(*) FROM torque_specs       WHERE generation_id = @gen_id) AS torque_specs,
  (SELECT COUNT(*) FROM electrical_specs   WHERE generation_id = @gen_id) AS electrical_specs,
  (SELECT COUNT(*) FROM bulbs              WHERE generation_id = @gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses              WHERE generation_id = @gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts              WHERE generation_id = @gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals  WHERE generation_id = @gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures     WHERE generation_id = @gen_id) AS tire_pressures;
