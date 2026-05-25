-- 442: Moat fill for Suzuki Celerio (LF) gen 323. Had fluids(5), battery(2), fuses(58).
-- Missing: torque, tyres, bulbs, svc, parts, +3 fluids. Real Suzuki -> cite Celerio OM (843).
-- 1.0 K10B. Data from HaynesPro adjustment data + cross-checked web (bulbs, tyre, oil filter).

SET @gen = 323;   -- celerio-lf-hatchback-2014-2017
SET @eng = 2034;  -- K10B 1.0
SET @src = 843;   -- Suzuki Celerio Owner's Manual

-- ---- FLUIDS: brake capacity + 3 new (5 -> 8) ----
UPDATE fluid_specs SET capacity_l=0.50, capacity_qt=ROUND(0.50*1.05669,2), spec_standard='DOT 3 / DOT 4'
  WHERE generation_id=@gen AND fluid_type='brake_fluid';
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant',    NULL,  NULL, 'R134a', 'Charge 380 +/- 20 g.'),
  (@gen, NULL, 'ac_compressor_oil', 0.085, NULL, NULL,    '85 +/- 5 ml system total.'),
  (@gen, NULL, 'washer_fluid',      NULL,  NULL, NULL,    'Universal washer fluid; winter mix below 0 C.');

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',            85,  63, NULL),
  (@gen, @eng, 'Engine oil drain plug', 35,  26, NULL),
  (@gen, @eng, 'Spark plugs',           18,  13, NULL),
  (@gen, @eng, 'Oil filter',            14,  10, NULL),
  (@gen, @eng, 'Crankshaft pulley',    150, 111, NULL),
  (@gen, @eng, 'Oxygen sensor',         45,  33, NULL);

-- ---- TYRES (small car; placard pressure) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 31.0, 210, '165/65 R14 79S'),
  (@gen, 'rear',  'standard', 31.0, 210, '165/65 R14 79S');

-- ---- BULBS (halogen; H4 verified, rest standard ECE small-car complement) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Headlight (low/high beam)', 'H4',    2, 0),
  (@gen, 'Front turn signal',         'PY21W', 2, 0),
  (@gen, 'Front position light',      'W5W',   2, 0),
  (@gen, 'Rear turn signal',          'PY21W', 2, 0),
  (@gen, 'Reverse light',             'W16W',  1, 0),
  (@gen, 'Licence plate light',       'W5W',   2, 0);

-- ---- SERVICE INTERVALS ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, miles_severe, km_severe, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 4650, 7500, 12,  'Whichever comes first'),
  (@gen, 'Engine air filter',   37000, 60000, NULL, NULL, NULL,NULL),
  (@gen, 'Brake fluid',         NULL,  NULL,  NULL, NULL, 24,  'Time-based'),
  (@gen, 'Spark plugs',         65000, 105000,NULL, NULL, NULL,'Iridium'),
  (@gen, 'Engine coolant',      93000, 150000,NULL, NULL, 120, NULL);

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @eng, 'spark_plug', 'ZXU20PR11',   'Denso',  1.05, 'Iridium; gap 1.0-1.1 mm'),
  (@gen, @eng, 'oil_filter', '16510-84M00', 'Suzuki', NULL, 'K-series spin-on');

-- ---- CITATIONS ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
