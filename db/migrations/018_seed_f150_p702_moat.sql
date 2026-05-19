-- Ford F-150 (P702) moat fill — 14th-gen pickup, 2021-2025 US/Canada/Mexico
-- Cross-verified against Ford OM, Motorcraft parts catalog. 5.0 Coyote V8 + 3.5 EcoBoost V6 + 3.5 PowerBoost hybrid + 3.3 NA + 2.7 EcoBoost.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'P702' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Ford F-150 (P702) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/ford/f-150-p702-pickup-2021-2025/hero.jpg',
  'wikimedia', 'cc-by-sa-2.0',
  'RL GNZLZ / Wikimedia Commons, CC BY-SA 2.0',
  'https://commons.wikimedia.org/wiki/File:Ford_F-150_V6_XLT_2021_(54198898468).jpg',
  CURDATE(),
  '2021 Ford F-150 XLT (P702)',
  '3-4-front', 1280, 720
FROM generations g WHERE g.codename = 'P702';

-- Fluids — 3.5 EcoBoost V6 (top-volume powertrain on Crew Cab)
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      5.70, 6.00, '5W-30', 'Motorcraft full synthetic blend · WSS-M2C946-B1', 'FL-500S', 7500, 12000, 12, '3.5 EcoBoost V6 · 6.0 US qt with filter. 5.0 Coyote V8: 8.8 qt 5W-30. 2.7 EcoBoost: 6.0 qt 5W-30. 3.5 PowerBoost: 6.6 qt 5W-30.'),
  (@gen_id, NULL, 'transmission_at', 13.5, 14.3, NULL,    'Motorcraft MERCON ULV (XT-12-QULV)',              'XL-12-QULV',150000,240000, NULL, '10R80 10-speed auto · total dry capacity. Drain & fill is ~5 qt. Ford labels lifetime; independents 60-100k mi.'),
  (@gen_id, NULL, 'transfer_case',   1.30, 1.37, NULL,    'Motorcraft transfer-case fluid (XL-12)',          NULL,         150000,240000, NULL, '4WD models only (BorgWarner T44).'),
  (@gen_id, NULL, 'front_differential',1.16,1.23, NULL,   'Motorcraft 75W-85 GL-5 + friction modifier',      NULL,         150000,240000, NULL, '4WD models · 8.8" front diff.'),
  (@gen_id, NULL, 'rear_differential',1.42,1.50, NULL,    'Motorcraft 75W-85 GL-5 + friction modifier',      NULL,         150000,240000, NULL, '9.75" rear diff. With electronic-locker, change at 30k mi.'),
  (@gen_id, NULL, 'coolant',         15.4, 16.3, NULL,    'Motorcraft Orange (Yellow on 2018+ MY) · VC-3DIL-B', NULL,      100000,160000, 120, 'Pre-mixed Yellow. Do not mix with Green OAT.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Motorcraft High Performance DOT 3 (PM-1-C)',      NULL,         30000, 48000, 36,   'Mileage or 3 yr.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.74, 0.78, NULL,    'R-1234yf · PAG oil YN-35-G',                      NULL,         NULL,  NULL,   NULL, 'Charge weight 740 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       203, 150, 'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    20,  15,  'Motorcraft SP-560 platinum (3.5 EcoBoost); SP-526 (5.0).'),
  (@gen_id, NULL, 'oil_drain',     35,  26,  'M14×1.5; copper crush washer.'),
  (@gen_id, NULL, 'caliper_bolt',  37,  27,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 250, 184, 'Front caliper carrier-to-knuckle.'),
  (@gen_id, NULL, 'transfer_case_drain', 35, 26, 'M16×1.5; new gasket.'),
  (@gen_id, NULL, 'diff_fill_plug',     35, 26, '8.8" front · 9.75" rear.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'BXT-65-650 / H6', 650, 70, 240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     '3157A', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      '3157', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo_bed',      'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', '1',  300, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', '2',  175, 'PCM power'),
  (@gen_id, NULL, 'under_hood', '7',  40,  'EPAS (electric power steering)'),
  (@gen_id, NULL, 'under_hood', '11', 50,  'ABS pump'),
  (@gen_id, NULL, 'under_hood', '14', 30,  'Cooling fan 1'),
  (@gen_id, NULL, 'under_hood', '15', 30,  'Cooling fan 2'),
  (@gen_id, NULL, 'under_hood', '21', 20,  'Fuel pump'),
  (@gen_id, NULL, 'under_hood', '32', 15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', '50', 60,  'Trailer brake'),
  (@gen_id, NULL, 'under_hood', '70', 30,  'Pro Power Onboard inverter'),
  (@gen_id, NULL, 'cabin',      '24', 7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      '30', 15,  'SYNC 4 infotainment'),
  (@gen_id, NULL, 'cabin',      '42', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      '47', 40,  'Heater blower'),
  (@gen_id, NULL, 'cabin',      '52', 25,  'Heated/cooled seats');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    'SP-560',    'Motorcraft', 0.80, NULL,    '3.5 EcoBoost V6 platinum'),
  (@gen_id, NULL, 'oil_filter',    'FL-500S',   'Motorcraft', NULL, NULL,    'Spin-on; 3.5 EcoBoost / 5.0 / 3.3'),
  (@gen_id, NULL, 'air_filter',    'FA-2103',   'Motorcraft', NULL, NULL,    '3.5 EcoBoost / 5.0 / 2.7 EcoBoost'),
  (@gen_id, NULL, 'cabin_filter',  'FP-86',     'Motorcraft', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', 'WW-2203-PF','Motorcraft', NULL, '22 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', 'WW-2203-PF','Motorcraft', NULL, '22 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, '6.0 qt 5W-30 (3.5 EcoBoost); severe = towing, dust, idle.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       20000, 10000, 32000, 16000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  150000,60000, 240000,96000, NULL, '10R80 — Ford lifetime; tow severe at 60k.'),
  (@gen_id, NULL, 'transfer_case_fluid',    150000,30000, 240000,48000, NULL, '4WD; severe duty = off-road / heavy tow.'),
  (@gen_id, NULL, 'front_differential_fluid',150000,30000,240000,48000, NULL, '4WD only.'),
  (@gen_id, NULL, 'rear_differential_fluid',150000,30000, 240000,48000, NULL, 'Severe duty = e-locker or trailer tow over 5k lb.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  36,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, '3.5 EcoBoost SP-560 platinum.'),
  (@gen_id, NULL, 'coolant_flush',          100000,NULL,  160000,NULL,  120,  'Motorcraft Yellow.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '265/70 R17 115T'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '265/70 R17 115T'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '275/60 R20 115T'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '275/60 R20 115T'),
  (@gen_id, NULL, 'front', 'loaded', 45, 310, '275/60 R20 115T'),
  (@gen_id, NULL, 'rear',  'loaded', 50, 345, '275/60 R20 115T'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, '265/70 R17 (full-size matching)');
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
