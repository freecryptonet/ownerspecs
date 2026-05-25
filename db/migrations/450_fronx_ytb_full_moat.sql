-- 450: Moat fill for Suzuki Fronx (YTB) gen 324. Had fluids(11), battery(2), fuses(68).
-- Missing: torque, tyres, bulbs, svc, parts. Fronx is too new for HaynesPro; it is the Baleno
-- platform (Heartect) with the K12N 1.2 Dualjet. Engine torques + oil filter are the K12-Dualjet
-- family values cross-verified across the sibling Celerio/Ignis/Swift/Baleno gens (migs 442-449);
-- wheel-nut torque is the Baleno platform value. Full-LED lighting confirmed. Cite Fronx OM.

SET @gen = 324;   -- fronx-ytb-suv-2023-present
SET @eng = (SELECT engine_id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil' LIMIT 1);
SET @src = (SELECT id FROM sources WHERE citation LIKE '%Fronx%Owner%' LIMIT 1);

INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',            100, 74, 'Baleno platform'),
  (@gen, @eng, 'Engine oil drain plug',  35, 26, NULL),
  (@gen, @eng, 'Spark plugs',            18, 13, NULL),
  (@gen, @eng, 'Oil filter',             14, 10, NULL);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 33.0, 230, '195/60 R16 89H'),
  (@gen, 'rear',  'standard', 33.0, 230, '195/60 R16 89H');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',   'LED',  2, 1),
  (@gen, 'High beam headlight',  'LED',  2, 1),
  (@gen, 'Daytime running light','LED',  2, 1),
  (@gen, 'Front turn signal',    'LED',  2, 1),
  (@gen, 'Tail / brake light',   'LED',  2, 1),
  (@gen, 'Reverse light',        'W16W', 1, 0);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, miles_severe, km_severe, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 4650, 7500, 12,  'Whichever comes first'),
  (@gen, 'Engine air filter',   37000, 60000, NULL, NULL, NULL,NULL),
  (@gen, 'Brake fluid',         NULL,  NULL,  NULL, NULL, 24,  'Time-based'),
  (@gen, 'Spark plugs',         65000, 105000,NULL, NULL, NULL,'Iridium'),
  (@gen, 'Engine coolant',      93000, 150000,NULL, NULL, 120, NULL);

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @eng, 'spark_plug', 'ILZKR6F11',   'NGK',    NULL, 'Iridium; 1.2 Dualjet'),
  (@gen, @eng, 'oil_filter', '16510-84M00', 'Suzuki', NULL, 'K-series spin-on');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
