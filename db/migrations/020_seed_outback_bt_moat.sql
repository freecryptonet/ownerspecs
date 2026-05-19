-- Subaru Outback (BT) moat fill — 6th-gen wagon, 2019-2024 global
-- Subaru Global Platform. 2.5 FB25 NA + 2.4 FA24F turbo. Symmetrical AWD.
-- Cross-verified against Subaru OM, Subaru Genuine parts catalog.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'BT' AND display_name LIKE 'Outback%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Subaru Outback (BT) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/subaru/outback-bt-wagon-2019-2024/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2020_Subaru_Outback_AWD,_front.jpg',
  CURDATE(),
  '2020 Subaru Outback AWD (BT)',
  '3-4-front', 1280, 684
FROM generations g WHERE g.codename = 'BT';

-- 2.5 FB25 NA — base US-market trims (most volume)
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      5.10, 5.39, '0W-20', 'API SP / ILSAC GF-6 (Subaru Genuine 0W-20)', '15208AA170', 6000, 10000, 6, '2.5 FB25 NA · 5.4 US qt with filter. 2.4 FA24F XT/Wilderness: 5.5 qt 0W-20.'),
  (@gen_id, NULL, 'transmission_cvt',12.0, 12.7, NULL,    'Subaru CVT-II (HTM Lineartronic) · 75W',     'K0425AA250', 60000, 96000, NULL, 'Lineartronic CVT TR690 (2.5) / TR580 (2.4 turbo). Total dry capacity; drain & fill ~4 L.'),
  (@gen_id, NULL, 'rear_differential',1.10, 1.16, NULL,   'Subaru Genuine 75W-90 GL-5',                 NULL,         30000, 48000, NULL, 'Inspect every oil change; replace at 30k mi or yearly if wading.'),
  (@gen_id, NULL, 'coolant',         9.50, 10.0, NULL,    'Subaru Super Coolant Type 2 (blue OAT)',     NULL,         137500,220000, NULL, 'Lifetime fill per Subaru; service at 137,500 mi or 11 yr.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 (Subaru Genuine)',                     NULL,         30000, 48000, 30,   'Mileage or time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.50, 0.53, NULL,    'R-1234yf · PAG oil ND-12',                   NULL,         NULL,  NULL,   NULL, 'Charge weight 500 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       120, 89,  'M12×1.25; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    20,  15,  'NGK SILZKR8C8S iridium (FB25); SILZKR7C11S (FA24F turbo).'),
  (@gen_id, NULL, 'oil_drain',     42,  31,  'M16×1.5; new gasket each service (PN 803916010).'),
  (@gen_id, NULL, 'caliper_bolt',  39,  29,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 137, 101, 'Front caliper carrier-to-knuckle.'),
  (@gen_id, NULL, 'cvt_drain',     40,  30,  'M14×1.5; new gasket required.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '35 / Q-85 EFB', 470, 60, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'PWY24W', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo',          'W5W', 2, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F02',  175, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F05',  120, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'F09',  60,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F11',  50,  'ABS / VDC'),
  (@gen_id, NULL, 'under_hood', 'F18',  30,  'Cooling fan main'),
  (@gen_id, NULL, 'under_hood', 'F19',  30,  'Cooling fan sub'),
  (@gen_id, NULL, 'under_hood', 'F25',  15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'F26',  20,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'F30',  7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'F35',  15,  'Starlink infotainment'),
  (@gen_id, NULL, 'cabin',      'F42',  25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F45',  25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'F50',  40,  'Heater blower'),
  (@gen_id, NULL, 'cabin',      'F55',  20,  'Heated seats');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '22401AA950',    'Subaru', 0.80, NULL,    '2.5 FB25 NGK SILZKR8C8S iridium'),
  (@gen_id, NULL, 'oil_filter',    '15208AA170',    'Subaru', NULL, NULL,    'Spin-on; FB25 / FA24F'),
  (@gen_id, NULL, 'air_filter',    '16546AA160',    'Subaru', NULL, NULL,    'Panel filter BT'),
  (@gen_id, NULL, 'cabin_filter',  '72880XC01A',    'Subaru', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '86532XC020',    'Subaru', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '86532XC030',    'Subaru', NULL, '18 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  6000,  3000,  10000, 5000,  6,  '5.4 qt 0W-20. Severe = short trips, dust, towing.'),
  (@gen_id, NULL, 'tire_rotation',          6000,  NULL,  10000, NULL,  NULL, 'Every oil change · Symmetrical AWD requires matched tread depth.'),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'CVT-II HTM. Severe = towing.'),
  (@gen_id, NULL, 'rear_differential_fluid',30000, 15000, 48000, 24000, NULL, 'Required to maintain AWD function.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK SILZKR8C8S iridium (FB25). Boxer engines accelerate plug wear.'),
  (@gen_id, NULL, 'coolant_flush',          137500,NULL,  220000,NULL,  132,  'Subaru Super Coolant Type 2 · first replacement at 11 yr / 137.5k mi.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, 'Serpentine.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '225/65 R17 102H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '225/65 R17 102H'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '225/60 R18 100H'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '225/60 R18 100H'),
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
