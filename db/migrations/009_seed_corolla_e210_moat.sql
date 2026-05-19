-- Toyota Corolla (E210) moat fill — 12th-gen sedan, 2019-present global
-- Cross-verified against Toyota OM, Toyota Genuine parts catalog, Denso
-- and Aisin OE part numbers. spec_sources cite the public "Toyota Corolla
-- (E210) Service Manual" entry created by the scraper insert pipeline.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'E210' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Toyota Corolla (E210) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- HERO IMAGE
-- ===================================================================
INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/toyota/corolla-sedan-e210-2019-2022/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:TOYOTA_COROLLA_SEDAN_(E210)_China.jpg',
  CURDATE(),
  'Toyota Corolla Sedan (E210)',
  '3-4-front', 1280, 832
FROM generations g WHERE g.codename = 'E210';

-- ===================================================================
-- FLUIDS — 1.8L 2ZR-FE figures (most common global E210)
-- ===================================================================
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.20, 4.40, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12, '1.8L 2ZR-FE NA · 4.4 US qt with filter. 1.6L 1ZR-FAE: 3.9 qt; 2ZR-FXE Hybrid: 4.4 qt.'),
  (@gen_id, NULL, 'transmission_cvt',3.70, 3.91, NULL,    'Toyota Genuine CVT Fluid FE (08886-02505)', NULL,         60000, 96000, NULL, 'Direct-shift CVT (K313) · drain & fill capacity; total dry ~6.5 L. Toyota labels "fill-for-life"; independents recommend 60k mi.'),
  (@gen_id, NULL, 'coolant',         6.40, 6.76, NULL,    'Toyota Super Long Life Coolant (pink, pre-mixed)', NULL,  100000,160000, 120, 'Do not mix with other coolants. First replacement at 100k mi / 10 years.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'FMVSS 116 DOT 3 (DOT 4 acceptable)',         NULL,        30000, 48000, 30,  'Mileage or time, whichever first.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.45, 0.48, NULL,    'R-1234yf · PAG oil ND-12',                   NULL,        NULL,  NULL,  NULL,'Charge weight 450 ±20 g · global E210 from 2019 production.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE
-- ===================================================================
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       103, 76,  'M12×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    18,  13,  'Denso SK16HR11 iridium; pre-gapped 1.1 mm, do not adjust.'),
  (@gen_id, NULL, 'oil_drain',     40,  30,  'M12×1.25; new gasket each service (PN 90430-12031).'),
  (@gen_id, NULL, 'caliper_bolt',  34,  25,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 107, 79, 'Front caliper carrier-to-knuckle bolt.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL
-- ===================================================================
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, 'LN2 / H6 EFB', 600, 70, 100);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — E210 is heavily LED on global trims from 2019
-- ===================================================================
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'LED',  2, 1),
  (@gen_id, NULL, 'headlight_high',  'LED',  2, 1),
  (@gen_id, NULL, 'fog_front',       'LED',  2, 1),
  (@gen_id, NULL, 'turn_front',      'WY21W LL', 2, 0),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',       'WY21W LL', 2, 0),
  (@gen_id, NULL, 'license_plate',   'LED',  2, 1),
  (@gen_id, NULL, 'interior_dome',   'LED',  1, 1),
  (@gen_id, NULL, 'interior_map',    'LED',  2, 1),
  (@gen_id, NULL, 'trunk',           'W5W',  1, 0);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES
-- ===================================================================
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'ALT',  140, 'Alternator main'),
  (@gen_id, NULL, 'under_hood', 'AM1',  40,  'Ignition switch'),
  (@gen_id, NULL, 'under_hood', 'ABS1', 50,  'ABS / VSC'),
  (@gen_id, NULL, 'under_hood', 'EPS',  60,  'Electric power steering'),
  (@gen_id, NULL, 'under_hood', 'RDI',  30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'EFI MAIN', 30, 'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'IG COIL', 15, 'Ignition coils'),
  (@gen_id, NULL, 'cabin',      'METER', 7.5,  'Combo meter'),
  (@gen_id, NULL, 'cabin',      'AUDIO', 15,   'Audio / infotainment'),
  (@gen_id, NULL, 'cabin',      'PW-D',  25,   'Driver power window'),
  (@gen_id, NULL, 'cabin',      'PW-P',  25,   'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'A/C',   30,   'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '90919-01253 / SK16HR11', 'Denso',  1.10, NULL,   '1.8 2ZR-FE iridium · pre-gapped'),
  (@gen_id, NULL, 'oil_filter',    '04152-YZZA1',            'Toyota', NULL, NULL,   'Cartridge; o-ring + drain plug included'),
  (@gen_id, NULL, 'air_filter',    '17801-37020',            'Toyota', NULL, NULL,   '1.8 2ZR-FE'),
  (@gen_id, NULL, 'cabin_filter',  '87139-30100',            'Toyota', NULL, NULL,   NULL),
  (@gen_id, NULL, 'wiper_front_d', '85212-12530',            'Toyota', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '85222-12420',            'Toyota', NULL, '16 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS
-- ===================================================================
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, '4.4 qt 0W-20 (1.8L); severe = short trips, dust, towing.'),
  (@gen_id, NULL, 'tire_rotation',          5000,  NULL,  8000,  NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'Toyota labels CVT-FE "fill for life"; independent shops recommend 60k mi.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            120000,NULL,  192000,NULL,  NULL, 'Denso SK16HR11 iridium.'),
  (@gen_id, NULL, 'coolant_flush',          100000,NULL,  160000,NULL,  120,  'Toyota Super Long Life · first replacement at 10 yr / 100k mi.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, 'Serpentine belt — inspect for cracks.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRES — 205/55 R16 on base, 225/40 R18 on top trims
-- ===================================================================
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 32, 220, '205/55 R16 91H'),
  (@gen_id, NULL, 'rear',  'normal', 32, 220, '205/55 R16 91H'),
  (@gen_id, NULL, 'front', 'normal', 33, 230, '225/40 R18 92W'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '225/40 R18 92W'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T125/70 D16 compact');

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
