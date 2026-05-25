-- 444: Moat fill for Suzuki Jimny (JB64) gen 326. Had fluids(8), fuses(70).
-- Missing: battery, torque, tyres, bulbs, svc, parts. 1.5 K15B 4x4. Cite Jimny OM.
-- Data from HaynesPro adjustment data + cross-checked web (battery, tyre pressure, oil filter).

SET @gen = 326;   -- jimny-jb64-suv-2018-present
SET @eng = (SELECT engine_id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil' LIMIT 1);
SET @src = (SELECT id FROM sources WHERE citation LIKE '%Jimny%Owner%' LIMIT 1);

INSERT INTO electrical_specs (generation_id, battery_group, ah, cca, alternator_amps) VALUES (@gen, NULL, 45, 433, 80);

INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',            100, 74, NULL),
  (@gen, @eng, 'Engine oil drain plug',  35, 26, 'Renew gasket'),
  (@gen, @eng, 'Spark plugs',            18, 13, NULL),
  (@gen, @eng, 'Oil filter',             14, 10, NULL),
  (@gen, @eng, 'Crankshaft pulley',      19, 14, 'Stage 1; then +75 deg'),
  (@gen, @eng, 'Oxygen sensor',          45, 33, NULL);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 26.0, 180, '195/80 R15 96S'),
  (@gen, 'rear',  'standard', 26.0, 180, '195/80 R15 96S'),
  (@gen, 'rear',  'full',     29.0, 200, '195/80 R15 96S');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Headlight (low/high beam)', 'H4',    2, 0),
  (@gen, 'Front turn signal',         'PY21W', 2, 0),
  (@gen, 'Front position light',      'W5W',   2, 0),
  (@gen, 'Rear turn signal',          'PY21W', 2, 0),
  (@gen, 'Reverse light',             'W16W',  1, 0),
  (@gen, 'Licence plate light',       'W5W',   2, 0);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, miles_severe, km_severe, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 4650, 7500, 12,  'Whichever comes first'),
  (@gen, 'Engine air filter',   37000, 60000, NULL, NULL, NULL,NULL),
  (@gen, 'Brake fluid',         NULL,  NULL,  NULL, NULL, 24,  'Time-based'),
  (@gen, 'Spark plugs',         65000, 105000,NULL, NULL, NULL,'Iridium'),
  (@gen, 'Engine coolant',      93000, 150000,NULL, NULL, 120, NULL);

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @eng, 'spark_plug', 'ZXU20PR11',   'Denso',  1.05, 'Iridium; gap 1.0-1.1 mm'),
  (@gen, @eng, 'oil_filter', '16510-81404', 'Suzuki', NULL, 'K15B spin-on');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',     id, @src FROM torque_specs     WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',   id, @src FROM tire_pressures   WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',            id, @src FROM bulbs            WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',            id, @src FROM parts            WHERE generation_id=@gen;
