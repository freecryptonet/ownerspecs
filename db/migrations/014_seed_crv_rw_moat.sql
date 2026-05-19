-- Honda CR-V (RW) moat fill — 5th-gen SUV, 2017-2022 global
-- Shares the Earth Dreams 1.5 turbo (L15B7/L15BE) with Civic FC and the
-- 2.4 K24W with Accord 9G. Cross-verified against Honda OM, Honda
-- Genuine parts catalog, NGK OE iridium part numbers.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'RW' AND display_name = 'CR-V V' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Honda CR-V (RW) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- HERO IMAGE
-- ===================================================================
INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/honda/cr-v-rw-suv-2017-2022/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2017_Honda_CR-V_(RW_MY18)_VTi_2WD_wagon_(2017-11-18)_01.jpg',
  CURDATE(),
  '2017 Honda CR-V (RW)',
  '3-4-front', 1280, 860
FROM generations g WHERE g.codename = 'RW' AND g.display_name = 'CR-V V';

-- ===================================================================
-- FLUIDS — 1.5 L15B7 turbo (US/global most common)
-- ===================================================================
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      3.70, 3.90, '0W-20', 'API SP / ILSAC GF-6 (Honda Genuine 0W-20)', '15400-PLM-A02', 7500, 12000, 12, '1.5 L15B7 turbo · 3.9 US qt with filter. 2.4 K24W: 4.4 qt. 2.0 LFA Hybrid: 3.7 qt.'),
  (@gen_id, NULL, 'transmission_cvt',2.50, 2.64, NULL,    'Honda HCF-2 (08200-HCF-2)',                  NULL,         30000, 50000, NULL, 'CVT drain & fill capacity; total dry ~5.7 L. Honda lists no severe-duty interval; independents recommend 30k mi.'),
  (@gen_id, NULL, 'coolant',         5.20, 5.49, NULL,    'Honda Type 2 long-life (blue, pre-mixed)',   NULL,         120000,192000, 132, 'Pre-mixed. Do not mix with other coolants.'),
  (@gen_id, NULL, 'rear_differential',1.20, 1.27, NULL,   'Honda DPSF (08293-99902HE)',                 NULL,         30000, 50000, NULL, 'AWD only. Inspect at every oil change.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'Honda DOT 3 (08798-9008)',                   NULL,         36000, 60000, 36,   'Mileage or 3 yr.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.41, 0.43, NULL,    'R-1234yf · PAG oil ND-OIL 8',                NULL,         NULL,  NULL,  NULL, 'Charge weight 410 ±20 g. 2017+ R-1234yf.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE
-- ===================================================================
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       108, 80,  'M12×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    22,  16,  'NGK DILZKAR7C11S iridium (L15B7); NGK IZFR6K-11S (K24W).'),
  (@gen_id, NULL, 'oil_drain',     39,  29,  'M14×1.5; new gasket each service (PN 94109-14000).'),
  (@gen_id, NULL, 'caliper_bolt',  37,  27,  'Front caliper slide-pin bolt.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 110, 81, 'Front caliper carrier-to-knuckle bolt.'),
  (@gen_id, NULL, 'rear_diff_fill_plug',  44, 32, 'AWD only.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL
-- ===================================================================
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, '51R / Group 51R', 410, 47, 130);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — RW mostly LED on EX-L/Touring, halogen on LX
-- ===================================================================
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'LED',  2, 1),
  (@gen_id, NULL, 'headlight_high',  'LED',  2, 1),
  (@gen_id, NULL, 'fog_front',       'LED',  2, 1),
  (@gen_id, NULL, 'turn_front',      'PY24W', 2, 0),
  (@gen_id, NULL, 'brake_tail',      'LED',  2, 1),
  (@gen_id, NULL, 'reverse',         'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',       'PY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',   'LED',  2, 1),
  (@gen_id, NULL, 'interior_dome',   'LED',  1, 1),
  (@gen_id, NULL, 'interior_map',    'LED',  2, 1),
  (@gen_id, NULL, 'cargo',           'W5W',  1, 0);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES
-- ===================================================================
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'MAIN',     200, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'ALT',      120, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'EPS',      60,  'Electric power steering'),
  (@gen_id, NULL, 'under_hood', 'ABS MTR',  30,  'ABS motor'),
  (@gen_id, NULL, 'under_hood', 'ABS FSR',  40,  'ABS solenoid'),
  (@gen_id, NULL, 'under_hood', 'RAD FAN',  30,  'Radiator fan'),
  (@gen_id, NULL, 'under_hood', 'IG COIL',  15,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'FI ECU',   20,  'Engine ECU'),
  (@gen_id, NULL, 'cabin',      'METER',    7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',      'AUDIO',    15,  'Audio / display audio'),
  (@gen_id, NULL, 'cabin',      'PW DRV',   20,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'PW PASS',  20,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'BLOWER',   40,  'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '12290-59B-003 / DILZKAR7C11S', 'NGK',   1.10, NULL,    '1.5 L15B7 turbo iridium'),
  (@gen_id, NULL, 'oil_filter',    '15400-PLM-A02',                'Honda', NULL, NULL,    'Spin-on; 1.5 turbo / 2.4 K24W'),
  (@gen_id, NULL, 'air_filter',    '17220-5AA-A00',                'Honda', NULL, NULL,    '1.5 L15B7 turbo'),
  (@gen_id, NULL, 'cabin_filter',  '80292-TF0-G01',                'Honda', NULL, NULL,    NULL),
  (@gen_id, NULL, 'wiper_front_d', '76622-TLA-A02',                'Honda', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '76632-TLA-A02',                'Honda', NULL, '17 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS — Honda Maintenance Minder is condition-based
-- ===================================================================
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  3750,  12000, 6000,  12, '3.9 qt 0W-20 (1.5 turbo). Honda Maintenance Minder shortens this under severe duty.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, 'Every oil change.'),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'transmission_cvt_fluid', 30000, 25000, 50000, 40000, NULL, 'Honda HCF-2 only. Watch for shudder — symptom of overdue service.'),
  (@gen_id, NULL, 'rear_differential_fluid',30000, 15000, 50000, 24000, NULL, 'AWD only. Honda DPSF.'),
  (@gen_id, NULL, 'brake_fluid_flush',      36000, NULL,  60000, NULL,  36,   'DOT 3.'),
  (@gen_id, NULL, 'spark_plugs',            100000,NULL,  160000,NULL,  NULL, 'NGK DILZKAR7C11S iridium.'),
  (@gen_id, NULL, 'coolant_flush',          120000,NULL,  192000,NULL,  132,  'Honda Type 2 — first replacement at 11 yr / 120k mi.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, 'Serpentine.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRES — 235/65 R17 LX, 235/60 R18 EX/EX-L, 235/55 R19 Touring
-- ===================================================================
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 30, 210, '235/65 R17 104H'),
  (@gen_id, NULL, 'rear',  'normal', 30, 210, '235/65 R17 104H'),
  (@gen_id, NULL, 'front', 'normal', 33, 230, '235/60 R18 103H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/60 R18 103H'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T155/90 D17 compact');

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
