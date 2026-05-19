-- Audi A4 (B9) moat fill — 5th-gen sedan, 2015-2022 global
-- MLB Evo platform. EA888 2.0 TFSI / EA288 2.0 TDI powertrains. Cross-
-- verified against Audi OM, VW/Audi Genuine parts catalog, NGK OE.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'B9' AND display_name LIKE 'A4%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Audi A4 (B9) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/audi/a4-sedan-b9-2015-2018/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2016_Audi_A4_Sport_Ultra_TDi_S-A_2.0.jpg',
  CURDATE(),
  '2016 Audi A4 Sport Ultra TDi (B9)',
  '3-4-front', 1280, 543
FROM generations g WHERE g.codename = 'B9' AND g.display_name LIKE 'A4%';

-- 2.0 TFSI EA888 (CYRB) — global volume engine
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      5.20, 5.50, '5W-40', 'VW 502 00 / VW 505 00 (Castrol Edge Professional)', '06L115562', 18000, 30000, 24, '2.0 TFSI EA888 (CYRB) · 5.5 US qt with filter. 3.0 TFSI V6: 7.6 qt 5W-40. 2.0 TDI EA288: 5.0 qt 5W-30 VW 507 00.'),
  (@gen_id, NULL, 'transmission_dsg', 5.50, 5.81, NULL,    'Audi G 052 182 A2 (S tronic DQ500 wet)',          '0CW398029', 37500, 60000, 60,   '7-speed S tronic DQ500. Quattro-equipped trims. Drain & fill ~5.5 L.'),
  (@gen_id, NULL, 'transmission_at',  9.00, 9.51, NULL,    'Audi G 060 162 A2 (ZF 8HP tiptronic)',            'OAW325435E',75000, 120000, 75, '8-speed tiptronic 8HP55 (longitudinal RWD/Quattro). Audi labels lifetime; independents 60-80k mi.'),
  (@gen_id, NULL, 'coolant',          8.50, 8.98, NULL,    'Audi G13 (purple, pre-mixed)',                    NULL,         NULL,  NULL,   NULL, 'Lifetime fill. Do not mix with G11/G12+/G12++.'),
  (@gen_id, NULL, 'brake',            NULL, NULL, 'DOT 4', 'VW TL 766-Z (DOT 4 LV)',                          NULL,         NULL,  NULL,   24,   'Every 2 years regardless of mileage.'),
  (@gen_id, NULL, 'ac_refrigerant',   0.55, 0.58, NULL,    'R-1234yf · PAG oil PAG46',                        NULL,         NULL,  NULL,   NULL, 'Charge weight 550 ±20 g. EU 2017+ R-1234yf; US 2018+.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       120, 89,  'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    30,  22,  'NGK PFR8S8EG / Bosch ZR6SI332S double-iridium (2.0 TFSI).'),
  (@gen_id, NULL, 'oil_drain',     30,  22,  'M14×1.5; new aluminum gasket each service.'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 200, 148, 'Front caliper carrier-to-knuckle — replace once.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen_id, NULL, 'LN3 H7 AGM', 800, 80, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED Matrix', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED Matrix', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'PY24W', 2, 0),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'SA1', 250, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', 'SA2', 200, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'SA3', 80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'SA4', 50,  'ABS / ESC'),
  (@gen_id, NULL, 'under_hood', 'SC10',30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'SC15',15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'SC18',15,  'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'SC20',20,  'Fuel pump'),
  (@gen_id, NULL, 'cabin',      'SB7', 7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      'SC30',15,  'MMI infotainment'),
  (@gen_id, NULL, 'cabin',      'SD25',30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'SD26',30,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'SD30',40,  'Heater blower');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '06H905611',     'Audi', 0.80, NULL,    '2.0 TFSI EA888 · NGK PFR8S8EG'),
  (@gen_id, NULL, 'oil_filter',    '06L115562',     'Audi', NULL, NULL,    '2.0 TFSI cartridge'),
  (@gen_id, NULL, 'air_filter',    '8W0133843',     'Audi', NULL, NULL,    'Panel filter'),
  (@gen_id, NULL, 'cabin_filter',  '8W0819439A',    'Audi', NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '8W1955425',     'Audi', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '8W1955426',     'Audi', NULL, '20 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  18000, 9000,  30000, 15000, 24, 'Audi LongLife. Severe = short trips, dust, towing.'),
  (@gen_id, NULL, 'tire_rotation',          10000, NULL,  16000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       18000, 9000,  30000, 15000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      40000, 20000, 64000, 32000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       18000, NULL,  30000, NULL,  24,   NULL),
  (@gen_id, NULL, 'transmission_dsg_fluid', 37500, NULL,  60000, NULL,  60,   'S tronic DQ500.'),
  (@gen_id, NULL, 'transmission_at_fluid',  75000, NULL,  120000,NULL,  75,   '8HP tiptronic — Audi lifetime, independents 60-80k.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'Every 2 years regardless of mileage.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, '2.0 TFSI EA888 NGK PFR8S8EG.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'Audi G13 lifetime fill.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '225/55 R17 97Y'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '225/55 R17 97Y'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '245/35 R19 93Y'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '245/35 R19 93Y'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Tirefit kit (no spare on most trims)');
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
