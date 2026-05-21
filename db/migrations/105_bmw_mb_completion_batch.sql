-- BMW + Mercedes completion batch: 5-Series G30, X5 G05, 3-Series F30,
-- E-Class W213, GLC X253. These all had partial engine_oil data using
-- shadow / duplicate engine_id references. We wipe and rewrite to use the
-- trim-bound engine IDs so the variant comparison renders correctly.

SET NAMES utf8mb4;
SET @s_bmw := 603;
SET @s_mb  := 604;

-- =========================================================================
-- BMW 5-SERIES G30 (gen 81) — 4 engines (trim-bound)
-- =========================================================================
SET @gen := 81; SET @s_sm := 485;
SET @e_b58c := 81; SET @e_b57c := 79; SET @e_n63c := 130; SET @e_n63d := 78;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+', '11428575211', 10000, 16000, 12, 'B58B30C 3.0L turbo (540i).'),
  (@gen, @e_b57c, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-04 (diesel)', '11428575211', 10000, 16000, 12, 'B57D30C 3.0L diesel (M550d).'),
  (@gen, @e_n63c, 'engine_oil', 9.5, 10.0, '0W-30', 'BMW LL-17 FE+', '11427848321', 10000, 16000, 12, 'N63B44C 4.4L V8 (M550i 462 Hp). Larger filter for V8.'),
  (@gen, @e_n63d, 'engine_oil', 9.5, 10.0, '0W-30', 'BMW LL-17 FE+', '11427848321', 10000, 16000, 12, 'N63B44D 4.4L V8 (M550i 530 Hp).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'coolant', 9.5, 10.0, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 turbo.'),
  (@gen, @e_b57c, 'coolant', 9.5, 10.0, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B57 diesel.'),
  (@gen, @e_n63c, 'coolant', 12.0, 12.7, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'V8 — larger cooling for high thermal load.'),
  (@gen, @e_n63d, 'coolant', 12.0, 12.7, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'V8 530 Hp tune — same cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'B58 + ZF 8HP75.'),
  (@gen, @e_b57c, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'B57 diesel + ZF 8HP75.'),
  (@gen, @e_n63c, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 (V8 high-torque)', 60000, 96000, NULL, 'V8 + ZF 8HP95 (heavy-duty for V8 torque).'),
  (@gen, @e_n63d, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 (V8 high-torque)', 60000, 96000, NULL, 'V8 530 Hp + ZF 8HP95.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- BMW X5 G05 (gen 48) — 4 engines
-- =========================================================================
SET @gen := 48; SET @s_sm := 277;
SET @e_n63m3 := 80;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+', '11428575211', 10000, 16000, 12, 'B58B30C 3.0L turbo (45e PHEV + 40i). SUV chassis.'),
  (@gen, @e_b57c, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-04 (diesel)', '11428575211', 10000, 16000, 12, 'B57D30C 3.0L diesel (M50d).'),
  (@gen, @e_n63m3, 'engine_oil', 9.5, 10.0, '0W-30', 'BMW LL-17 FE+', '11427848321', 10000, 16000, 12, 'N63B44M3 4.4L V8 (50i 462 Hp).'),
  (@gen, @e_n63d, 'engine_oil', 9.5, 10.0, '0W-30', 'BMW LL-17 FE+', '11427848321', 10000, 16000, 12, 'N63B44D 4.4L V8 (M50i 530 Hp).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'coolant', 14.0, 14.8, 'BMW Longlife Coolant (blue) + HV loop on 45e', 120000, 192000, 120, 'B58 in X5 SUV chassis. 45e PHEV adds HV battery loop.'),
  (@gen, @e_b57c, 'coolant', 14.0, 14.8, 'BMW Longlife Coolant (blue)', 120000, 192000, 120, 'B57 diesel.'),
  (@gen, @e_n63m3, 'coolant', 15.5, 16.4, 'BMW Longlife Coolant (blue)', 120000, 192000, 120, 'V8 — largest cooling system for high-output 4.4 V8.'),
  (@gen, @e_n63d, 'coolant', 15.5, 16.4, 'BMW Longlife Coolant (blue)', 120000, 192000, 120, 'V8 530 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b58c, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8', 60000, 96000, NULL, 'B58 + ZF 8HP75.'),
  (@gen, @e_b57c, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8', 60000, 96000, NULL, 'B57 + ZF 8HP75.'),
  (@gen, @e_n63m3, 'transmission_at', 9.5, 10.0, 'ZF Lifeguard 8 (V8 high-torque)', 60000, 96000, NULL, 'V8 + ZF 8HP95.'),
  (@gen, @e_n63d, 'transmission_at', 9.5, 10.0, 'ZF Lifeguard 8 (V8 high-torque)', 60000, 96000, NULL, 'V8 530 + ZF 8HP95.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- BMW 3-SERIES F30 (gen 53) — 2 engines (335i with N55 variants)
-- =========================================================================
SET @gen := 53; SET @s_sm := 309;
SET @e_n55a := 89; SET @e_n55h := 88;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_n55a, 'engine_oil', 6.5, 6.9, '5W-30', 'BMW LL-01 (older spec; LL-04 acceptable)', '11427566327', 10000, 16000, 12, 'N55B30A 3.0L turbo (F30 era — 335i). BMW LL-01 was the F30-era spec.'),
  (@gen, @e_n55h, 'engine_oil', 6.5, 6.9, '5W-30', 'BMW LL-01', '11427566327', 10000, 16000, 12, 'N55B30 ActiveHybrid 3.0 (with eAssist mild hybrid).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_n55a, 'coolant', 8.5, 9.0, 'BMW Longlife Coolant (blue)', 120000, 192000, 120, 'N55 turbo.'),
  (@gen, @e_n55h, 'coolant', 8.5, 9.0, 'BMW Longlife Coolant (blue)', 120000, 192000, 120, 'ActiveHybrid same cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_n55a, 'transmission_at', 7.0, 7.4, 'ZF Lifeguard 6 (early MY) / 8 (late MY)', 60000, 96000, NULL, 'N55 + ZF 8HP50 (post-2014) or older 6HP21 (early F30).'),
  (@gen, @e_n55h, 'transmission_at', 7.0, 7.4, 'ZF Lifeguard 8', 60000, 96000, NULL, 'ActiveHybrid + 8HP.'),
  (@gen, @e_n55a, 'transmission_mt', 1.7, 1.8, 'BMW MTF-LT-2', 60000, 96000, NULL, '335i + 6MT (ZF GS6-17BG).');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

-- =========================================================================
-- MERCEDES GLC X253 (gen 61) — 4 engines
-- =========================================================================
SET @gen := 61; SET @s_sm := 359;
SET @e_m276g := 107; SET @e_m274g := 109; SET @e_om642 := 108; SET @e_m177g := 106;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276g, 'engine_oil', 6.5, 6.9, '0W-40', 'MB 229.5', 'A2761800009', 10000, 16000, 12, 'M276 3.0L V6 turbo (AMG GLC 43).'),
  (@gen, @e_m274g, 'engine_oil', 5.8, 6.1, '0W-20', 'MB 229.71', 'A2701800009', 10000, 16000, 12, 'M274 2.0L turbo (GLC 350e PHEV).'),
  (@gen, @e_om642, 'engine_oil', 8.5, 9.0, '5W-30', 'MB 229.52 (low-SAPS diesel)', 'A6541801409', 10000, 16000, 12, 'OM642 3.0L V6 diesel (GLC 350d).'),
  (@gen, @e_m177g, 'engine_oil', 9.0, 9.5, '5W-40', 'MB 229.5', 'A1331840525', 10000, 16000, 12, 'M177 4.0L V8 AMG hand-built (AMG GLC 63 / 63 S).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276g, 'coolant', 8.5, 9.0, 'MB-Spec 325.6 NF (Glysantin G40)', 60000, 96000, 60, 'M276 V6.'),
  (@gen, @e_m274g, 'coolant', 8.5, 9.0, 'MB-Spec 325.6 NF (Glysantin G40) + HV loop', 60000, 96000, 60, 'M274 PHEV.'),
  (@gen, @e_om642, 'coolant', 9.0, 9.5, 'MB-Spec 325.6 NF', 60000, 96000, 60, 'OM642 diesel.'),
  (@gen, @e_m177g, 'coolant', 10.0, 10.6, 'MB-Spec 325.6 NF', 60000, 96000, 60, 'M177 V8 — largest cooling for AMG tune.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276g, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.14 (NAG-9G)', 60000, 96000, NULL, 'M276 + 9G-TRONIC.'),
  (@gen, @e_m274g, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.14', 60000, 96000, NULL, 'M274 + 9G-TRONIC.'),
  (@gen, @e_om642, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.14', 60000, 96000, NULL, 'OM642 + 9G-TRONIC.'),
  (@gen, @e_m177g, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.91 (AMG MCT)', 40000, 64000, NULL, 'M177 + AMG MCT 9G.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mb FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- MERCEDES E-CLASS W213 (gen 65) — 3 engines (M276, M256, M177)
-- =========================================================================
SET @gen := 65; SET @s_sm := 384;
SET @e_m276e := 107; SET @e_m256 := 112; SET @e_m177e := 106;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276e, 'engine_oil', 6.5, 6.9, '0W-40', 'MB 229.5', 'A2761800009', 10000, 16000, 12, 'M276 3.0L V6 turbo (E 450, AMG E 43).'),
  (@gen, @e_m256, 'engine_oil', 7.5, 7.9, '0W-30', 'MB 229.71', 'A2761800409', 10000, 16000, 12, 'M256 3.0L inline-6 turbo + EQ Boost ISG (AMG E 53). Mercedes I6 — distinct from V6 M276.'),
  (@gen, @e_m177e, 'engine_oil', 9.0, 9.5, '5W-40', 'MB 229.5', 'A1331840525', 10000, 16000, 12, 'M177 4.0L V8 AMG biturbo (AMG E 63 / 63 S).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276e, 'coolant', 8.5, 9.0, 'MB-Spec 325.6 NF', 60000, 96000, 60, 'M276 V6.'),
  (@gen, @e_m256, 'coolant', 9.0, 9.5, 'MB-Spec 325.6 NF', 60000, 96000, 60, 'M256 I6 with EQ Boost — larger cooling.'),
  (@gen, @e_m177e, 'coolant', 10.0, 10.6, 'MB-Spec 325.6 NF', 60000, 96000, 60, 'M177 V8 AMG.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m276e, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.14', 60000, 96000, NULL, 'M276 + 9G-TRONIC.'),
  (@gen, @e_m256, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.91 (AMG TCT)', 40000, 64000, NULL, 'M256 + AMG SPEEDSHIFT TCT 9G.'),
  (@gen, @e_m177e, 'transmission_at', 8.5, 9.0, 'MB-Approval 236.91 (AMG MCT)', 40000, 64000, NULL, 'M177 + AMG MCT 9G.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mb FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

SELECT 'BMW + Mercedes completion batch (5 gens) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (81,48,53,61,65) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
