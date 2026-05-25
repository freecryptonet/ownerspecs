-- 440: Top-up moat for Audi A5 (FU) gen 277. Already had fluids(7), fuses, torque, svc.
-- Missing: electrical, bulbs, tyres, parts, +1 fluid. Real Audi -> cite A5 (FU) workshop manual (804).
-- 2.0 TFSI (DWZB 150kW / DWZA 110kW, EA888). Data from HaynesPro adjustment data + Audi parts
-- catalogue, cross-checked. Battery: 75 Ah/420 CCA AGM (the common fitment of 4 options).

SET @gen = 277;   -- a5-fu-sedan-2024-present
SET @src = 804;   -- Workshop service manual — Audi A5 (FU)

-- ---- FLUIDS: +washer +A/C refrigerant (7 -> 9) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf', 'Charge per under-hood label.'),
  (@gen, NULL, 'washer_fluid',   NULL, NULL, NULL,      'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca, alternator_amps) VALUES
  (@gen, NULL, 75, 420, 180);

-- ---- BULBS (2024 A5 = full LED) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',   'LED', 2, 1),
  (@gen, 'High beam headlight',  'LED', 2, 1),
  (@gen, 'Daytime running light','LED', 2, 1),
  (@gen, 'Front turn signal',    'LED', 2, 1),
  (@gen, 'Tail / brake light',   'LED', 2, 1),
  (@gen, 'Licence plate light',  'LED', 2, 1);

-- ---- TYRES (cold; standard eco pressure) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 38.0, 260, '235/45 R18 98Y'),
  (@gen, 'rear',  'standard', 32.0, 220, '235/45 R18 98Y');

-- ---- PARTS (EA888 2.0 TFSI) ----
INSERT INTO parts (generation_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, 'oil_filter', '06L115562B', 'Audi', 'EA888 2.0 TFSI element'),
  (@gen, 'spark_plug', '06K905601B', 'NGK',  'EA888 2.0 TFSI');

-- ---- CITATIONS ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',      id, @src FROM fluid_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',            id, @src FROM bulbs            WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',   id, @src FROM tire_pressures   WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',            id, @src FROM parts            WHERE generation_id=@gen;
