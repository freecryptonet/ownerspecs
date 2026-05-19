-- Mazda 3 (BP) moat fill — 4th gen sedan, 2019-present US market
-- Cross-verified against Mazda OM, Mazda Genuine parts catalog, MZRForum
-- and Bob Is The Oil Guy. All spec_sources cite the public "Mazda 3 (BP)
-- Service Manual" entry (id 29, created automatically by the scraper insert
-- pipeline when the codename-aware version of insert.ts ran).

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'BP' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Mazda 3 (BP) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- FLUIDS
-- ===================================================================

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      4.17, 4.40, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302', 7500, 12000, 12, 'SkyActiv-G 2.5 NA · 4.4 US qt with filter'),
  (@gen_id, NULL, 'transmission_at', 3.31, 3.50, NULL,    'Mazda ATF FZ (PN 0000-77-110E-01)',         NULL,         30000, 48000, NULL, '6-speed automatic · drain & fill capacity; total dry ~6 qt. Mazda labels "no scheduled service"; independents recommend 30k mi.'),
  (@gen_id, NULL, 'coolant',         6.00, 6.34, NULL,    'Mazda FL22 long-life coolant (green)',     NULL,         120000,192000, 132, 'Premixed; do not mix with other coolants. Mazda 11-year/120k mi first interval.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 or DOT 4 (Mazda OM lists both)',     NULL,         30000, 48000, 30,  'Mileage or time, whichever first.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.46, 0.49, NULL,    'R-1234yf · PAG oil',                       NULL,         NULL,  NULL,  NULL,'Charge weight 460 ±10 g · 2019+ US-market all R-1234yf.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE
-- ===================================================================

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       108, 80,  'M14×1.5; star pattern, multi-step.'),
  (@gen_id, NULL, 'spark_plug',    25,  18,  'NGK ILKAR8L11 iridium; pre-gapped, do not adjust.'),
  (@gen_id, NULL, 'oil_drain',     30,  22,  'M14×1.5; new gasket each service (PN 9956-41-400).'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 100, 74, 'Front caliper carrier-to-knuckle bolt.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL
-- ===================================================================

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, '35 / Q-85 (i-stop)', 410, 55, 130);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — Mazda 3 BP is heavily LED on US trims
-- ===================================================================

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'LED',  2, 1),
  (@gen_id, NULL, 'headlight_high',  'LED',  2, 1),
  (@gen_id, NULL, 'fog_front',       'LED',  2, 1),
  (@gen_id, NULL, 'turn_front',      'LED',  2, 1),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         'LED',  2, 1),
  (@gen_id, NULL, 'turn_rear',       'LED',  2, 1),
  (@gen_id, NULL, 'license_plate',   'LED',  2, 1),
  (@gen_id, NULL, 'interior_dome',   'LED',  1, 1),
  (@gen_id, NULL, 'interior_map',    'LED',  2, 1),
  (@gen_id, NULL, 'trunk',           'LED',  1, 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES
-- ===================================================================

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 150, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F02', 60,  'ABS'),
  (@gen_id, NULL, 'under_hood', 'F03', 50,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F04', 40,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F08', 20,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'F12', 15,  'Fuel pump'),
  (@gen_id, NULL, 'cabin',      'F30', 7.5, 'Combo meter'),
  (@gen_id, NULL, 'cabin',      'F35', 15,  'Audio / infotainment'),
  (@gen_id, NULL, 'cabin',      'F42', 25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F43', 25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'F50', 30,  'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    'NGK ILKAR8L11', 'NGK',   1.10, NULL,   '2.5 SkyActiv-G iridium · pre-gapped'),
  (@gen_id, NULL, 'oil_filter',    'PE01-14-302',   'Mazda', NULL, NULL,   'Cartridge type'),
  (@gen_id, NULL, 'air_filter',    'PE07-13-3A0',   'Mazda', NULL, NULL,   '2.5 SkyActiv-G'),
  (@gen_id, NULL, 'cabin_filter',  'KD45-61-J6X',   'Mazda', NULL, NULL,   NULL),
  (@gen_id, NULL, 'wiper_front_d', 'BHN9-67-330',   'Mazda', NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', 'BHN9-67-340',   'Mazda', NULL, '18 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS
-- ===================================================================

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  5000,  12000, 8000,  12, '4.4 qt 0W-20 SkyActiv'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  30000, NULL,  48000, NULL,  NULL, 'Mazda labels no scheduled service; independents recommend 30k mi.'),
  (@gen_id, NULL, 'brake_fluid_flush',      30000, NULL,  48000, NULL,  30,   'DOT 3 or DOT 4.'),
  (@gen_id, NULL, 'spark_plugs',            75000, NULL,  120000,NULL,  NULL, 'NGK ILKAR8L11 iridium.'),
  (@gen_id, NULL, 'coolant_flush',          120000,NULL,  192000,NULL,  132,  'Mazda FL22 · first replacement at 132 months / 120k mi.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, NULL);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRES — 215/45 R18 on Mazda 3 BP US Premium/Premium Plus
-- ===================================================================

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 33, 230, '215/45 R18 89H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '215/45 R18 89H'),
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
  (SELECT COUNT(*) FROM tire_pressures    WHERE generation_id = @gen_id) AS tires;
