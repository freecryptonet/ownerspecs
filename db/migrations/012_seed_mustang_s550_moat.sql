-- Ford Mustang (S550) moat fill — 6th-gen pony car, 2015-2023 fastback
-- Cross-verified against Ford OM, Motorcraft parts catalog, AutoZone OE
-- references for the 5.0 Coyote and 2.3 EcoBoost.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'S550' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Ford Mustang (S550) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- HERO IMAGE
-- ===================================================================
INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/ford/mustang-s550-fastback-2015-2017/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'MercurySable99 / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2015_Ford_Mustang_V6_Fastback,_front_left,_09-03-2022.jpg',
  CURDATE(),
  '2015 Ford Mustang Fastback (S550)',
  '3-4-front', 1280, 804
FROM generations g WHERE g.codename = 'S550';

-- ===================================================================
-- FLUIDS — 5.0 Coyote V8 figures (most iconic S550 powertrain)
-- ===================================================================
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      7.50, 8.00, '5W-20', 'Ford WSS-M2C945-A / SAE 5W-20 (Motorcraft synthetic blend)', 'FL-500S', 10000, 16000, 12, '5.0 Coyote V8 · 8.0 US qt with filter. 2.3 EcoBoost: 5.7 qt 5W-30 (WSS-M2C961-A1). 3.7 V6: 6.0 qt 5W-20.'),
  (@gen_id, NULL, 'transmission_at', 11.3, 11.9, NULL,    'Motorcraft MERCON LV (XT-10-QLVC)',           'FT-186',     150000,240000, NULL, '6R80 6-speed auto · total dry capacity. Drain & fill is ~5 qt. Ford labels lifetime; independents recommend 60-100k mi.'),
  (@gen_id, NULL, 'transmission_mt', 2.80, 2.96, NULL,    'Motorcraft Full Synthetic Manual Trans Fluid (XT-M5-QS)', NULL, 60000, 96000, NULL, 'MT-82 6-speed manual. Some owners switch to Royal Purple Synchromax.'),
  (@gen_id, NULL, 'rear_differential',1.32, 1.40, NULL,   '75W-85 GL-5 (XY-75W85-QL) + friction modifier (XL-3)', NULL, 150000,240000, NULL, '8.8" IRS differential.'),
  (@gen_id, NULL, 'coolant',         9.50, 10.0, NULL,    'Motorcraft Orange (Yellow on 2018+ MY) · VC-3-B / VC-3DIL-B', NULL, 100000,160000, 120, 'Pre-mixed Gold (Yellow). Do not mix with Green OAT.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Motorcraft High Performance DOT 3 (PM-1-C)',  NULL,         30000, 48000, 36,   'Mileage or 3 yr time.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.79, 0.84, NULL,    'R-134a · PAG oil YN-12-D',                    NULL,         NULL,  NULL,  NULL, '2015-2017 R-134a. 2018+ Mustang switched to R-1234yf.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE
-- ===================================================================
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       203, 150, 'M14×1.5; star pattern. Heavy by class.'),
  (@gen_id, NULL, 'spark_plug',    20,  15,  'Motorcraft SP-526 platinum (5.0); SP-534 platinum (2.3). Pre-gapped 1.3 mm / 0.85 mm.'),
  (@gen_id, NULL, 'oil_drain',     33,  25,  'M14×1.5; copper crush washer.'),
  (@gen_id, NULL, 'caliper_bolt',  31,  23,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 156, 115, 'Front caliper carrier-to-knuckle.'),
  (@gen_id, NULL, 'rear_diff_fill_plug',  34, 25, '8.8" IRS housing.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL
-- ===================================================================
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, 'BXT-96R / H7', 850, 80, 175);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — S550 mixes LED + halogen depending on trim/MY
-- ===================================================================
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'H11',  2, 0),
  (@gen_id, NULL, 'headlight_high',  '9005', 2, 0),
  (@gen_id, NULL, 'fog_front',       'H11',  2, 0),
  (@gen_id, NULL, 'drl',             'LED',  2, 1),
  (@gen_id, NULL, 'turn_front',      '3157', 2, 0),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         '921',  2, 0),
  (@gen_id, NULL, 'turn_rear',       'LED',  2, 1),
  (@gen_id, NULL, 'license_plate',   '194',  2, 0),
  (@gen_id, NULL, 'interior_dome',   '578',  1, 0),
  (@gen_id, NULL, 'interior_map',    '194',  2, 0),
  (@gen_id, NULL, 'trunk',           '194',  1, 0);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES
-- ===================================================================
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', '1',  175, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', '7',  40,  'PCM power'),
  (@gen_id, NULL, 'under_hood', '8',  40,  'EPAS (electric power steering)'),
  (@gen_id, NULL, 'under_hood', '11', 50,  'ABS pump'),
  (@gen_id, NULL, 'under_hood', '14', 30,  'Cooling fan 1'),
  (@gen_id, NULL, 'under_hood', '15', 30,  'Cooling fan 2'),
  (@gen_id, NULL, 'under_hood', '21', 20,  'Fuel pump'),
  (@gen_id, NULL, 'under_hood', '32', 15,  'Ignition coils'),
  (@gen_id, NULL, 'cabin',      '24', 7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      '30', 15,  'SYNC infotainment'),
  (@gen_id, NULL, 'cabin',      '42', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      '47', 30,  'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    'SP-526',    'Motorcraft', 1.30, NULL,    '5.0 Coyote V8 platinum'),
  (@gen_id, NULL, 'oil_filter',    'FL-500S',   'Motorcraft', NULL, NULL,    '5.0 / 3.7 spin-on'),
  (@gen_id, NULL, 'oil_filter',    'FL-2070',   'Motorcraft', NULL, NULL,    '2.3 EcoBoost cartridge'),
  (@gen_id, NULL, 'air_filter',    'FA-1927',   'Motorcraft', NULL, NULL,    '5.0 Coyote'),
  (@gen_id, NULL, 'cabin_filter',  'FP-77',     'Motorcraft', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', 'WW-2403-PF','Motorcraft', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', 'WW-1903-PF','Motorcraft', NULL, '19 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS
-- ===================================================================
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, '8 qt 5W-20 (5.0); severe = track, tow, dust.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       20000, 10000, 32000, 16000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  150000,60000, 240000,96000, NULL, '6R80 — Ford lifetime; independents recommend 60-100k.'),
  (@gen_id, NULL, 'rear_differential_fluid',150000,60000, 240000,96000, NULL, '8.8" IRS — 30k mi if tracked.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  36,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            100000,NULL,  160000,NULL,  NULL, 'Motorcraft platinum (SP-526).'),
  (@gen_id, NULL, 'coolant_flush',          100000,NULL,  160000,NULL,  120,  'Motorcraft Yellow.'),
  (@gen_id, NULL, 'drive_belt_inspection',  90000, NULL,  144000,NULL,  NULL, 'Serpentine.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRES — 235/55 R17 base, 255/40 R19 Performance, 255+275/40 R19 GT PP
-- ===================================================================
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 32, 220, '235/55 R17 99V'),
  (@gen_id, NULL, 'rear',  'normal', 32, 220, '235/55 R17 99V'),
  (@gen_id, NULL, 'front', 'normal', 32, 220, '255/40 R19 96Y'),
  (@gen_id, NULL, 'rear',  'normal', 32, 220, '275/40 R19 101Y'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T155/70 R17 (compact spare, not all trims)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT
  (SELECT COUNT(*) FROM fluid_specs       WHERE generation_id = @gen_id) AS fluids,
  (SELECT COUNT(*) FROM torque_specs      WHERE generation_id = @gen_id) AS torques,
  (SELECT COUNT(*) FROM electrical_specs  WHERE generation_id = @gen_id) AS electrical,
  (SELECT COUNT(*) FROM bulbs             WHERE generation_id = @gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses             WHERE generation_id = @gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts             WHERE generation_id = @gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals WHERE generation_id = @gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures    WHERE generation_id = @gen_id) AS tires,
  (SELECT COUNT(*) FROM images            WHERE generation_id = @gen_id) AS images;
