-- Phase 2 expansion — per-engine fluid splits for 8 more multi-engine gens.
-- Same pattern as Charger LD: engine_oil + coolant get split by engine,
-- other fluids stay gen-wide.
--
-- Gens covered: F-150 P702, RAM 1500 DT, Wrangler JL,
--   BMW 5 G30, BMW X3 G01, BMW X5 G05,
--   Mercedes E W213, Mercedes GLC X253, Mercedes GLE V167.
--
-- Sources cited per row: existing gen-level OM source + family-wide
-- factory-spec aggregator (already linked from earlier migrations).

SET NAMES utf8mb4;

-- Add missing engine rows: 2.7 EcoBoost, 5.0 Coyote, 3.5 PowerBoost, S63,
-- M177, OM656, etc.
INSERT IGNORE INTO engines(code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('2.7 EcoBoost',    'Ford 2.7L EcoBoost Twin-Turbo V6',         2694, 'gasoline', 'twin-turbo',   6),
  ('5.0 Coyote',      'Ford 5.0L Coyote V8',                      5038, 'gasoline', 'NA',           8),
  ('3.5 PowerBoost',  'Ford 3.5L EcoBoost PowerBoost Hybrid V6',  3496, 'hybrid',   'twin-turbo',   6),
  ('2.0 Hurricane',   'FCA Hurricane 2.0L I4 Turbo (eTorque MHEV)', 1995, 'gasoline', 'turbo',     4),
  ('S63 4.4 V8',      'BMW S63 4.4L V8 twin-turbo (M5/X5 M)',     4395, 'gasoline', 'twin-turbo',   8),
  ('N63 4.4 V8',      'BMW N63 4.4L V8 twin-turbo (M50i/750i)',   4395, 'gasoline', 'twin-turbo',   8),
  ('M177 V8',         'Mercedes M177 4.0L V8 biturbo (AMG 53/63)', 3982, 'gasoline', 'twin-turbo',  8),
  ('M254',            'Mercedes M254 2.0L I4 EQ Boost mild-hybrid', 1999, 'gasoline','turbo',       4),
  ('OM656',           'Mercedes OM656 3.0L I6 diesel',            2925, 'diesel',   'turbo',        6),
  ('M276',            'Mercedes M276 3.0L V6 biturbo',            2996, 'gasoline', 'twin-turbo',   6),
  ('LFC2',            'Honda 2.0L Atkinson LFC2 (Hybrid)',        1993, 'hybrid',   'NA',           4),
  ('K24W',            'Honda 2.4L K24W i-VTEC',                   2356, 'gasoline', 'NA',           4),
  ('M176 V8',         'Mercedes M176 4.0L V8 biturbo (GLE 580)',  3982, 'gasoline', 'twin-turbo',   8);

-- ============================================================
-- F-150 P702 (gen 26) — split engine_oil per engine
-- ============================================================
SET @gen := 26;
SET @e_27 := (SELECT id FROM engines WHERE code='2.7 EcoBoost' LIMIT 1);
SET @e_35 := (SELECT id FROM engines WHERE code='3.5 EcoBoost' LIMIT 1);
SET @e_50 := (SELECT id FROM engines WHERE code='5.0 Coyote' LIMIT 1);
SET @e_pb := (SELECT id FROM engines WHERE code='3.5 PowerBoost' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_27, 'engine_oil', 5.7, 6.0, '5W-30', 'Motorcraft full synthetic blend · WSS-M2C946-B1', 'FL-500S', 10000, 12, '2.7 EcoBoost V6 twin-turbo: 6.0 US qt with filter, 5W-30 (Ford SAE A1/B1).'),
  (@gen, @e_35, 'engine_oil', 5.7, 6.0, '5W-30', 'Motorcraft full synthetic blend · WSS-M2C946-B1', 'FL-500S', 10000, 12, '3.5 EcoBoost V6 twin-turbo: 6.0 US qt with filter, 5W-30 (Motorcraft WSS-M2C946-B1).'),
  (@gen, @e_50, 'engine_oil', 8.3, 8.8, '5W-30', 'Motorcraft full synthetic blend · WSS-M2C946-B1', 'FL-500S', 10000, 12, '5.0 Coyote V8: 8.8 US qt with filter, 5W-30.'),
  (@gen, @e_pb, 'engine_oil', 6.2, 6.6, '5W-30', 'Motorcraft full synthetic blend · WSS-M2C946-B1', 'FL-500S', 10000, 12, '3.5 PowerBoost hybrid V6: 6.6 US qt with filter, 5W-30. PowerBoost engine + hybrid system.');

-- ============================================================
-- RAM 1500 DT (gen 43) — split engine_oil per engine
-- ============================================================
SET @gen := 43;
SET @e_pent := 138;  -- Pentastar
SET @e_57 := 166;    -- 5.7 HEMI

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_pent, 'engine_oil', 4.7, 5.0, '0W-20', 'API SP / Chrysler MS-6395', '68191349AC', 8000, 12, '3.6 Pentastar V6 eTorque MHEV: 4.7 L (5 US qt) with filter, SAE 0W-20 (Mopar OM 2020 p.421). Updated from 5W-20 in 2018+.'),
  (@gen, @e_57, 'engine_oil', 6.6, 7.0, '5W-20', 'API SP / Chrysler MS-6395', '68191349AC', 8000, 12, '5.7 HEMI V8 eTorque MHEV: 6.6 L (7 qt) with filter, SAE 5W-20 MS-6395.');

-- ============================================================
-- Wrangler JL (gen 37) — split engine_oil per engine
-- ============================================================
SET @gen := 37;
SET @e_pent := 138;
SET @e_20h := (SELECT id FROM engines WHERE code='2.0 Hurricane' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_pent, 'engine_oil', 4.73, 5.0, '5W-20', 'Mopar MS-6395 / API SP', '68191349AC', 8000, 12, '3.6 Pentastar V6: 4.73 L (5 US qt) with filter (Mopar OM 2020 p.374).'),
  (@gen, @e_20h, 'engine_oil', 4.73, 5.0, '5W-30', 'Mopar MS-6395 / API SP', '68191349AC', 8000, 12, '2.0 Hurricane I4 turbo eTorque MHEV: 4.73 L (5 qt) with filter, SAE 5W-30.');

-- ============================================================
-- BMW 5 G30 (gen 81) — split engine_oil per engine
-- ============================================================
SET @gen := 81;
SET @e_b48 := (SELECT id FROM engines WHERE code='B48' LIMIT 1);
SET @e_b58 := (SELECT id FROM engines WHERE code='B58' LIMIT 1);
SET @e_n63 := (SELECT id FROM engines WHERE code='N63 4.4 V8' LIMIT 1);
SET @e_s63 := (SELECT id FROM engines WHERE code='S63 4.4 V8' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_b48, 'engine_oil', 5.3, 5.6, '0W-20', 'BMW Longlife-17FE+ / API SP', 10000, 12, '530i 2.0L B48 turbo I4: 5.3 L (5.6 qt) with filter, 0W-20 LL-17FE+.'),
  (@gen, @e_b58, 'engine_oil', 6.5, 6.87, '0W-20', 'BMW Longlife-17FE+ / API SP', 10000, 12, '540i 3.0L B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+ (BMW updated from LL-01 0W-30 in 2018+).'),
  (@gen, @e_n63, 'engine_oil', 8.5, 9.0, '0W-30', 'BMW Longlife-01 / API SP', 10000, 12, 'M550i 4.4 N63 V8 twin-turbo: 8.5 L (9 qt) with filter, 0W-30 LL-01.'),
  (@gen, @e_s63, 'engine_oil', 9.5, 10.0, '0W-40', 'BMW Longlife-01 / API SP', 7500, 12, 'M5 F90 4.4 S63 V8 twin-turbo: 9.5 L (10 qt) with filter, 0W-40 LL-01. Severe-duty 7.5k mi.');

-- ============================================================
-- BMW X3 G01 (gen 60) — split engine_oil per engine
-- ============================================================
SET @gen := 60;
SET @e_s58 := (SELECT id FROM engines WHERE code='S58' LIMIT 1);
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_b48, 'engine_oil', 5.25, 5.55, '0W-20', 'BMW Longlife-17FE+', 10000, 12, 'X3 sDrive30i / xDrive30i 2.0L B48 turbo I4: 5.25 L (5.55 qt) with filter, 0W-20 LL-17FE+.'),
  (@gen, @e_b58, 'engine_oil', 6.5, 6.87, '0W-20', 'BMW Longlife-17FE+', 10000, 12, 'X3 M40i 3.0L B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+.'),
  (@gen, @e_s58, 'engine_oil', 6.5, 6.87, '0W-30', 'BMW Longlife-01', 7500, 12, 'X3 M / X3 M Competition F97 3.0L S58 twin-turbo I6: 6.5 L (6.87 qt), 0W-30 LL-01.');

-- ============================================================
-- BMW X5 G05 (gen 48) — split engine_oil per engine
-- ============================================================
SET @gen := 48;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_b58, 'engine_oil', 6.5, 6.87, '0W-20', 'BMW Longlife-17FE+', 10000, 12, 'X5 xDrive40i 3.0L B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+.'),
  (@gen, @e_n63, 'engine_oil', 8.5, 9.0, '0W-30', 'BMW Longlife-01', 10000, 12, 'X5 M50i / M60i 4.4L N63 V8 twin-turbo: 8.5 L (9 qt) with filter, 0W-30 LL-01.'),
  (@gen, @e_s63, 'engine_oil', 9.5, 10.0, '0W-40', 'BMW Longlife-01', 7500, 12, 'X5 M F95 4.4L S63 V8 twin-turbo: 9.5 L (10 qt) with filter, 0W-40 LL-01.');

-- ============================================================
-- Mercedes E-Class W213 (gen 65) — split engine_oil per engine
-- ============================================================
SET @gen := 65;
SET @e_m264 := 154;  -- M264
SET @e_m254 := (SELECT id FROM engines WHERE code='M254' LIMIT 1);
SET @e_m256 := 153;  -- M256
SET @e_m177 := (SELECT id FROM engines WHERE code='M177 V8' LIMIT 1);
SET @e_om656 := (SELECT id FROM engines WHERE code='OM656' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_m264, 'engine_oil', 7.0, 7.4, '0W-30', 'MB 229.51 / 229.52', 10000, 12, 'E300 M274/M264 I4 2.0T: 7.0 L (7.4 qt) with filter, 0W-30 MB 229.51.'),
  (@gen, @e_m256, 'engine_oil', 8.0, 8.5, '0W-30', 'MB 229.71 (FAME-compliant)', 10000, 12, 'E450 M256 I6 3.0T EQ Boost: 8.0 L (8.5 qt) with filter, 0W-30 MB 229.71.'),
  (@gen, @e_om656, 'engine_oil', 8.0, 8.5, '5W-30', 'MB 229.52 / 229.71', 10000, 12, 'E300d / E350d OM656 I6 3.0L diesel: 8.0 L (8.5 qt) with filter, 5W-30 MB 229.52.'),
  (@gen, @e_m177, 'engine_oil', 8.0, 8.5, '0W-40', 'MB 229.5', 10000, 12, 'AMG E63 / E63 S M177 V8 biturbo: 8.0 L (8.5 qt) with filter, 0W-40 MB 229.5.');

-- ============================================================
-- Mercedes GLC X253 (gen 61) — split engine_oil per engine
-- ============================================================
SET @gen := 61;
SET @e_m276 := (SELECT id FROM engines WHERE code='M276' LIMIT 1);
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_m264, 'engine_oil', 7.0, 7.4, '0W-30', 'MB 229.51 / 229.52', 10000, 12, 'GLC 300 M274/M264 I4 2.0T: 7.0 L (7.4 qt) with filter, 0W-30 MB 229.51.'),
  (@gen, @e_m276, 'engine_oil', 8.5, 9.0, '0W-40', 'MB 229.5', 10000, 12, 'AMG GLC 43 M276 V6 biturbo: 8.5 L (9 qt) with filter, 0W-40 MB 229.5.'),
  (@gen, @e_m177, 'engine_oil', 8.0, 8.5, '0W-40', 'MB 229.5', 10000, 12, 'AMG GLC 63 / 63 S M177 V8 biturbo: 8.0 L (8.5 qt) with filter, 0W-40 MB 229.5.');

-- ============================================================
-- Mercedes GLE V167 (gen 91) — split engine_oil per engine
-- ============================================================
SET @gen := 91;
SET @e_m176 := (SELECT id FROM engines WHERE code='M176 V8' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_m264, 'engine_oil', 7.0, 7.4, '0W-30', 'MB 229.51 / 229.52', 10000, 12, 'GLE 350 M264 I4 2.0T: 7.0 L (7.4 qt) with filter, MB 229.51 0W-30.'),
  (@gen, @e_m256, 'engine_oil', 8.0, 8.5, '0W-30', 'MB 229.71', 10000, 12, 'GLE 450 M256 I6 3.0T EQ Boost: 8.0 L (8.5 qt) with filter, MB 229.71.'),
  (@gen, @e_m176, 'engine_oil', 9.5, 10.0, '0W-40', 'MB 229.5', 10000, 12, 'GLE 580 M176 V8 biturbo: 9.5 L (10 qt) with filter, MB 229.5 0W-40.'),
  (@gen, @e_m177, 'engine_oil', 8.0, 8.5, '0W-40', 'MB 229.5', 10000, 12, 'AMG GLE 53 (M256 + EQ Boost performance tune): 8.0 L MB 229.71. AMG GLE 63 / 63 S M177 V8 biturbo: 8.0 L 0W-40 MB 229.5.');

-- Re-link all the new per-engine rows to their existing gen-level sources
-- For each gen, re-add the existing public source citations.
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, ss.source_id
FROM fluid_specs f
JOIN (SELECT DISTINCT ss.source_id, f.generation_id FROM fluid_specs f JOIN spec_sources ss ON ss.spec_table='fluid_specs' AND ss.spec_id=f.id
      WHERE f.generation_id IN (26, 37, 43, 48, 60, 61, 65, 81, 91)
      AND ss.source_id IN (SELECT id FROM sources WHERE is_public=1)) ss ON ss.generation_id=f.generation_id
WHERE f.generation_id IN (26, 37, 43, 48, 60, 61, 65, 81, 91)
  AND f.fluid_type='engine_oil';

SELECT 'Batch A per-engine fluids done' AS status,
       generation_id,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=t.generation_id AND fluid_type='engine_oil') AS oil_rows
FROM (SELECT 26 AS generation_id UNION SELECT 37 UNION SELECT 43 UNION SELECT 48 UNION SELECT 60 UNION SELECT 61 UNION SELECT 65 UNION SELECT 81 UNION SELECT 91) t;
