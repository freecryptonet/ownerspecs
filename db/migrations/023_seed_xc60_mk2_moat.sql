-- Volvo XC60 (Mk2) moat fill — 2nd-gen SUV, 2017-2024 global
-- Cross-verified against HaynesPro WorkshopData (Volvo → XC60 2018+), Volvo OM,
-- Volvo Genuine parts catalog. SPA platform shared with V90/S90/XC90.
-- VEA "Drive-E" 4-cyl powertrains: B4204T46 T6, B4204T20 T8, etc.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'II' AND display_name LIKE 'XC60%' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Volvo XC60 (Mk2) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/volvo/xc60-suv-2017-2024/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Charles01 / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Volvo_XC60_registered_June_2018_1969cc.jpg',
  CURDATE(),
  '2018 Volvo XC60 (Mk2)',
  '3-4-front', 1280, 778
FROM generations g WHERE g.id = @gen_id;

-- 2.0 T5/T6 (B4204T) — volume petrol powertrain
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      5.50, 5.81, '0W-20', 'Volvo VCC RBS0-2AE / ACEA A1/B1 (Castrol Edge Professional V)', '31330050', 12000, 20000, 12, '2.0 T5/T6 Drive-E · 5.5 L with filter. 2.0 D4/D5: 5.9 L 0W-30 VCC RBS0-2AE. T8 PHEV: 5.5 L 0W-20.'),
  (@gen_id, NULL, 'transmission_at', 7.20, 7.61, NULL,    'Volvo Genuine Aisin AWF8F35 fluid (1161540)', NULL,         60000, 96000, NULL, 'Aisin AWF8F35 8-speed Geartronic. Volvo labels lifetime; independents 60-80k mi.'),
  (@gen_id, NULL, 'transfer_case',   0.45, 0.48, NULL,    'Haldex Generation V fluid (31280778)',        NULL,         60000, 96000, NULL, 'AWD only — Haldex coupling rear-drive unit.'),
  (@gen_id, NULL, 'coolant',         9.00, 9.51, NULL,    'Volvo coolant (yellow, 31439720)',           NULL,         NULL,  NULL,   NULL, 'Lifetime fill per Volvo; full change at component repair only.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'DOT 4 LV (Volvo 1161684)',                   NULL,         NULL,  NULL,   24,   'Every 2 years.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.65, 0.69, NULL,    'R-1234yf · PAG oil PAG46',                   NULL,         NULL,  NULL,   NULL, 'Charge weight 650 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       140, 103, 'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'spark_plug',    24,  18,  'NGK SILZKBR8C8S iridium (B4204T petrol).'),
  (@gen_id, NULL, 'oil_drain',     35,  26,  'M14×1.5; new gasket each service (31338685).'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 180, 133, 'Front caliper carrier-to-knuckle.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'LN3 H7 AGM', 800, 80, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED Thor''s Hammer', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'W16W', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'cargo',          'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 200, 'Battery main'),
  (@gen_id, NULL, 'under_hood', 'F05', 150, 'Alternator'),
  (@gen_id, NULL, 'under_hood', 'F08', 80,  'EPS'),
  (@gen_id, NULL, 'under_hood', 'F11', 50,  'ABS / DSTC'),
  (@gen_id, NULL, 'under_hood', 'F15', 40,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F18', 20,  'Engine ECU'),
  (@gen_id, NULL, 'under_hood', 'F25', 20,  'Ignition coils'),
  (@gen_id, NULL, 'cabin',      'F30', 7.5, 'Driver display'),
  (@gen_id, NULL, 'cabin',      'F35', 15,  'Sensus infotainment'),
  (@gen_id, NULL, 'cabin',      'F42', 25,  'Driver power window'),
  (@gen_id, NULL, 'cabin',      'F45', 25,  'Passenger power window'),
  (@gen_id, NULL, 'cabin',      'F50', 40,  'Climate blower'),
  (@gen_id, NULL, 'cabin',      'F55', 30,  'Heated seats'),
  (@gen_id, NULL, 'trunk',      'F70', 30,  'PHEV charging port (T8 only)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '31405510',      'Volvo', 0.80, NULL,    'B4204T petrol NGK SILZKBR8C8S iridium'),
  (@gen_id, NULL, 'oil_filter',    '31330050',      'Volvo', NULL, NULL,    'Cartridge; Drive-E 4-cyl'),
  (@gen_id, NULL, 'air_filter',    '31368022',      'Volvo', NULL, NULL,    'Panel filter Mk2'),
  (@gen_id, NULL, 'cabin_filter',  '31407811',      'Volvo', NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '32256020',      'Volvo', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '32256021',      'Volvo', NULL, '21 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  12000, 6000,  20000, 10000, 12, 'Volvo flex service.'),
  (@gen_id, NULL, 'tire_rotation',          10000, NULL,  16000, NULL,  NULL, NULL),
  (@gen_id, NULL, 'brake_inspection',       12000, 6000,  20000, 10000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       18000, NULL,  30000, NULL,  24,   NULL),
  (@gen_id, NULL, 'transmission_at_fluid',  60000, 30000, 96000, 48000, NULL, 'Aisin AWF8F35; Volvo lifetime, independents 60-80k.'),
  (@gen_id, NULL, 'transfer_case_fluid',    37500, 25000, 60000, 40000, NULL, 'Haldex AWD rear unit.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'DOT 4 LV. Every 2 years.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK SILZKBR8C8S iridium.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'Volvo coolant lifetime fill.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '235/60 R18 103H'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/60 R18 103H'),
  (@gen_id, NULL, 'front', 'normal', 38, 260, '255/45 R20 101W'),
  (@gen_id, NULL, 'rear',  'normal', 35, 240, '255/45 R20 101W'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'Tirefit kit (no spare)');
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
