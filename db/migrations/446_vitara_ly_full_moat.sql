-- 446: Moat fill for Suzuki Vitara (LY / HaynesPro APK) gen 331. Had fluids(11), fuses(96).
-- Missing: battery, torque, tyres, bulbs, svc, parts. 1.4 Boosterjet K14C. Cite Vitara OM.
-- Data from HaynesPro adjustment data + cross-checked web (battery, oil filter).

SET @gen = 331;   -- vitara-ly-suv-2015-present
SET @eng = (SELECT engine_id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil' LIMIT 1);
SET @src = (SELECT id FROM sources WHERE citation LIKE '%Vitara%Owner%' AND citation NOT LIKE '%Grand%' LIMIT 1);

INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES (@gen, NULL, 60, 640);

INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',            85, 63, NULL),
  (@gen, @eng, 'Engine oil drain plug', 35, 26, NULL),
  (@gen, @eng, 'Spark plugs',           18, 13, 'Boosterjet K14C, NGK ILZKR7D8'),
  (@gen, @eng, 'Oil filter',            14, 10, NULL),
  (@gen, @eng, 'Ignition coil',         11,  8, NULL),
  (@gen, @eng, 'Crankshaft pulley',     19, 14, 'Stage 1; then angle');

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 41.0, 280, '215/60 R16 95H'),
  (@gen, 'rear',  'standard', 38.0, 260, '215/60 R16 95H');

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
  (@gen, @eng, 'spark_plug', 'ILZKR7D8',    'NGK',    NULL, 'Iridium; 1.4 Boosterjet K14C'),
  (@gen, @eng, 'oil_filter', '16510-81421', 'Suzuki', NULL, '1.4 Boosterjet');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',     id, @src FROM torque_specs     WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',   id, @src FROM tire_pressures   WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',            id, @src FROM bulbs            WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',            id, @src FROM parts            WHERE generation_id=@gen;
