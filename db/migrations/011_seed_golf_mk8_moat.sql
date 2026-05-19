-- Volkswagen Golf (Mk8) moat fill — 8th-gen hatchback, 2020-present global
-- MQB Evo platform, EA211/EA288 engines. Cross-verified against VW OM,
-- VW Genuine parts catalog, NGK/Bosch/Sachs OE part numbers.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'Mk8' AND display_name = 'Golf VIII' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Volkswagen Golf (Mk8) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- HERO IMAGE
-- ===================================================================
INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/volkswagen/golf-mk8-hatchback-2020-2024/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2020_Volkswagen_Golf_Style_1.5_Front.jpg',
  CURDATE(),
  '2020 Volkswagen Golf Style 1.5 (Mk8)',
  '3-4-front', 1280, 653
FROM generations g WHERE g.codename = 'Mk8' AND g.display_name = 'Golf VIII';

-- ===================================================================
-- FLUIDS — 1.5 TSI EA211 evo figures (most common Mk8)
-- ===================================================================
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.30, 4.55, '0W-20', 'VW 508 00 (Castrol Edge Professional LL III FE)', '04E115561H', 18000, 30000, 24, '1.5 TSI EA211 evo · 4.3 L with filter. 2.0 TSI EA888: 5.7 L (VW 504 00). VW long-life 30k km / 2 yr.'),
  (@gen_id, NULL, 'transmission_dsg', 1.90, 2.01, NULL,    'VW G 052 529 A2 (DSG DQ200/DQ381 dry/wet)',         'O2E398029',  37500, 60000, 60,  '7-speed DSG (DQ381 wet) drain & fill. DQ200 dry: no service. DQ381 wet: 60k km / 5 yr.'),
  (@gen_id, NULL, 'transmission_mt', 1.90, 2.01, NULL,    'VW G 052 178 A1 (MQ281 6-speed)',                   NULL,         60000, 96000, NULL, 'Manual gearbox MQ281 · fill for life per VW; independents recommend 60k mi.'),
  (@gen_id, NULL, 'coolant',         7.50, 7.93, NULL,    'VW G 13 (purple, pre-mixed)',                       NULL,         NULL,  NULL,  NULL, 'Lifetime fill per VW. Do not mix with G 11/G 12+/G 12++.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'VW TL 766-Z (DOT 4 LV)',                            NULL,         NULL,  NULL,  36,   'Every 3 years regardless of mileage.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.45, 0.48, NULL,    'R-1234yf · PAG oil PAG46',                          NULL,         NULL,  NULL,  NULL, 'Charge weight 450 ±20 g. All Mk8 from 2020 R-1234yf.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE
-- ===================================================================
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       120, 89,  'M14×1.5; star pattern. Steel & alloy wheels.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'NGK PFR7S8EG / Bosch ZR6SI332S double-iridium; pre-gapped.'),
  (@gen_id, NULL, 'oil_drain',     30,  22,  'M14×1.5; new aluminum gasket each service.'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 190, 140, 'Front caliper carrier-to-knuckle bolt — replace once.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL
-- ===================================================================
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, 'LN3 H7 AGM', 760, 80, 150);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — Mk8 nearly all LED from factory; halogen on base eTSI only
-- ===================================================================
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'LED',  2, 1),
  (@gen_id, NULL, 'headlight_high',  'LED',  2, 1),
  (@gen_id, NULL, 'drl',             'LED',  2, 1),
  (@gen_id, NULL, 'turn_front',      'LED',  2, 1),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',       'LED',  2, 1),
  (@gen_id, NULL, 'license_plate',   'LED',  2, 1),
  (@gen_id, NULL, 'interior_dome',   'LED',  1, 1),
  (@gen_id, NULL, 'interior_map',    'LED',  2, 1),
  (@gen_id, NULL, 'cargo',           'LED',  1, 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES — Mk8 engine bay (SC) + cabin (SB/SD)
-- ===================================================================
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'SC1',  500, 'Battery main / megafuse'),
  (@gen_id, NULL, 'under_hood', 'SC2',  150, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'SC3',  80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'SC4',  50,  'ABS'),
  (@gen_id, NULL, 'under_hood', 'SC10', 30,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'SC15', 15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'SC18', 15,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'SB5',  7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      'SB8',  15,  'Infotainment MIB3'),
  (@gen_id, NULL, 'cabin',      'SD25', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'SD26', 30,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'SD30', 30,  'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '04E905614C',     'VW',    0.80, NULL,    '1.5 TSI EA211 evo · NGK PFR7S8EG'),
  (@gen_id, NULL, 'oil_filter',    '04E115561H',     'VW',    NULL, NULL,    'Cartridge; 1.5/2.0 TSI'),
  (@gen_id, NULL, 'air_filter',    '5Q0129620E',     'VW',    NULL, NULL,    'Panel filter'),
  (@gen_id, NULL, 'cabin_filter',  '5WA819644',      'VW',    NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '5H1955425',      'VW',    NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '5H1955426',      'VW',    NULL, '19 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS — VW LongLife service
-- ===================================================================
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  18000, 9000,  30000, 15000, 24, 'VW LongLife. Severe = short trips, towing, dust.'),
  (@gen_id, NULL, 'tire_rotation',          10000, NULL,  16000, NULL,  NULL, 'Per VW guidance.'),
  (@gen_id, NULL, 'brake_inspection',       18000, 9000,  30000, 15000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      36000, 18000, 60000, 30000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       18000, NULL,  30000, NULL,  24,   NULL),
  (@gen_id, NULL, 'transmission_dsg_fluid', 37500, NULL,  60000, NULL,  60,   'DQ381 wet DSG; DQ200 dry is fill-for-life.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  36,   'Every 3 years regardless of mileage.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK PFR7S8EG double iridium.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'VW G 13 lifetime fill.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, 'Serpentine.'),
  (@gen_id, NULL, 'timing_belt_replacement',NULL,  NULL,  NULL,  NULL,  NULL, '1.5 TSI EA211 evo: chain (no service). 2.0 TSI EA888 gen3b: chain (no service).');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRES — 205/55 R16 base, 225/40 R18 GTI, 235/35 R19 Clubsport
-- ===================================================================
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '205/55 R16 91H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '205/55 R16 91H'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '225/40 R18 92Y'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '225/40 R18 92Y'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Tirefit kit (no spare on most trims)');

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
