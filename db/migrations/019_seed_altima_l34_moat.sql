-- Nissan Altima (L34) moat fill — 6th-gen sedan, 2018-2022 US/CA
-- Cross-verified against Nissan OM, Nissan Genuine parts catalog. 2.5 PR25DD
-- direct-injection + 2.0 VC-Turbo KR20DDET variable-compression.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'L34' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Nissan Altima (L34) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/nissan/altima-l34-sedan-2018-2022/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'DestinationFearFan / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2019_Nissan_Altima_SR_AWD.jpg',
  CURDATE(),
  '2019 Nissan Altima SR AWD (L34)',
  '3-4-front', 1280, 886
FROM generations g WHERE g.codename = 'L34';

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.70, 4.95, '0W-20', 'API SP / ILSAC GF-6 (Nissan Genuine 0W-20)', '15208-9N01A', 5000, 8000, 6, '2.5 PR25DD · 4.95 US qt with filter. 2.0 VC-Turbo (KR20DDET): 5.4 qt 5W-30 (15208-65F00).'),
  (@gen_id, NULL, 'transmission_cvt',5.20, 5.50, NULL,    'Nissan NS-3 CVT fluid · KLE53-00004',       NULL,         60000, 96000, NULL, 'Xtronic JF016E CVT (2.5) / JF017E (2.0). Drain & fill ~5.2 L; total dry ~9.5 L.'),
  (@gen_id, NULL, 'coolant',         8.30, 8.77, NULL,    'Nissan Long Life Coolant (blue, pre-mixed)',NULL,         105000,168000, NULL, 'First replacement at 105k mi / 7 yr, then every 60k mi / 5 yr.'),
  (@gen_id, NULL, 'rear_differential',0.65,0.69, NULL,    'API GL-5 75W-90 (Nissan HypoidAuto)',       NULL,         60000, 96000, NULL, 'AWD only.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 (Nissan Genuine)',                    NULL,         30000, 48000, 30,   'Mileage or time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.51, 0.54, NULL,    'R-1234yf · PAG oil ND-12',                  NULL,         NULL,  NULL,   NULL, 'Charge weight 510 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       113, 83,  'M12×1.25; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    23,  17,  'NGK ILZKAR8H8S iridium (2.5 PR25DD); DILKAR8E8GS (2.0 VC-Turbo).'),
  (@gen_id, NULL, 'oil_drain',     34,  25,  'M12×1.25; new gasket (11026-01M02).'),
  (@gen_id, NULL, 'caliper_bolt',  37,  27,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 113, 83, 'Front caliper carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '35 / Q-85 (i-stop)', 410, 55, 130);
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
  (@gen_id, NULL, 'trunk',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 175, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F02', 120, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'F05', 60,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F08', 40,  'ABS pump'),
  (@gen_id, NULL, 'under_hood', 'F14', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F15', 15,  'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'F18', 15,  'Ignition coils'),
  (@gen_id, NULL, 'cabin',      'F30', 7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'F35', 15,  'NissanConnect infotainment'),
  (@gen_id, NULL, 'cabin',      'F42', 25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F45', 25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'F50', 40,  'Heater blower');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '22401-EN11A',   'Nissan', 0.80, NULL,    '2.5 PR25DD NGK ILZKAR8H8S iridium'),
  (@gen_id, NULL, 'oil_filter',    '15208-9N01A',   'Nissan', NULL, NULL,    'Spin-on; 2.5 PR25DD'),
  (@gen_id, NULL, 'air_filter',    '16546-6CA0A',   'Nissan', NULL, NULL,    'Panel filter L34'),
  (@gen_id, NULL, 'cabin_filter',  '27277-6CA0A',   'Nissan', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '28890-6CA0A',   'Nissan', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '28890-6CA0B',   'Nissan', NULL, '18 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  5000,  3750,  8000,  6000,  6,  '4.95 qt 0W-20. Severe = short trips, dust, towing.'),
  (@gen_id, NULL, 'tire_rotation',          5000,  NULL,  8000,  NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'NS-3 CVT fluid. Severe = towing, mountain driving.'),
  (@gen_id, NULL, 'rear_differential_fluid',60000, 30000, 96000, 48000, NULL, 'AWD only.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            105000,NULL,  168000,NULL,  NULL, 'NGK ILZKAR8H8S iridium.'),
  (@gen_id, NULL, 'coolant_flush',          105000,NULL,  168000,NULL,  84,   'First replacement at 105k mi / 7 yr.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '215/60 R16 95H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '215/60 R16 95H'),
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/40 R19 92V'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '235/40 R19 92V'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T125/70 D17 compact');
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
