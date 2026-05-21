-- Family extension batch — closes out the manufacturers I just researched.
-- 7 gens: Mazda 3 BM, Santa Fe TM, Palisade LX2, CX-50, Acura TLX II, CX-90 KK,
-- Kona SX2 (engine variants only — EV skipped on this fluid layer).

SET NAMES utf8mb4;
SET @s_honda  := 606;
SET @s_hyundai := 607;
SET @s_mazda  := 608;

-- =========================================================================
-- MAZDA 3 BM (gen 51) — 3 engines
-- =========================================================================
SET @gen := 51; SET @s_sm := 298;
SET @e_sh := 84; SET @e_pe := 85; SET @e_py := 15;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pe, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302', 7500, 12000, 12, '2.0L PE-VPS Skyactiv-G NA.'),
  (@gen, @e_py, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302', 7500, 12000, 12, '2.5L PY-VPS Skyactiv-G NA.'),
  (@gen, @e_sh, 'engine_oil', 5.7, 6.0, '0W-30', 'ACEA C3 (low-SAPS diesel)', 'SH01-14-302', 7500, 12000, 12, '2.2L SH-VTPS Skyactiv-D diesel.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pe, 'coolant', 6.0, 6.3, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '2.0L Skyactiv-G NA.'),
  (@gen, @e_py, 'coolant', 6.0, 6.3, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '2.5L Skyactiv-G NA.'),
  (@gen, @e_sh, 'coolant', 7.5, 7.9, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '2.2L diesel — larger system.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pe, 'transmission_at', 5.5, 5.8, 'Mazda ATF FZ', 60000, 96000, NULL, '2.0L + Skyactiv-Drive 6AT.'),
  (@gen, @e_py, 'transmission_at', 5.5, 5.8, 'Mazda ATF FZ', 60000, 96000, NULL, '2.5L + Skyactiv-Drive 6AT.'),
  (@gen, @e_sh, 'transmission_at', 5.5, 5.8, 'Mazda ATF FZ', 60000, 96000, NULL, '2.2L diesel + Skyactiv-Drive 6AT.'),
  (@gen, @e_pe, 'transmission_mt', 2.0, 2.1, 'Mazda Genuine MTF', 60000, 96000, NULL, '2.0L + 6MT.'),
  (@gen, @e_py, 'transmission_mt', 2.0, 2.1, 'Mazda Genuine MTF', 60000, 96000, NULL, '2.5L + 6MT.'),
  (@gen, @e_sh, 'transmission_mt', 2.0, 2.1, 'Mazda Genuine MTF', 60000, 96000, NULL, '2.2L diesel + 6MT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mazda FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

-- =========================================================================
-- HYUNDAI SANTA FE TM (gen 68) — 2 engines (both diesel)
-- =========================================================================
SET @gen := 68; SET @s_sm := 407;
SET @e_d4ha := 118; SET @e_d4hb := 117;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4ha, 'engine_oil', 5.8, 6.1, '5W-30', 'ACEA C2 (low-SAPS diesel)', '26350-2A500', 7500, 12000, 12, '2.0 CRDi R II D4HA diesel.'),
  (@gen, @e_d4hb, 'engine_oil', 6.3, 6.7, '5W-30', 'ACEA C2 (low-SAPS diesel)', '26350-2A500', 7500, 12000, 12, '2.2 CRDi R II D4HB diesel.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4ha, 'coolant', 7.3, 7.7, 'Hyundai Long Life Coolant (pink OAT, pre-mixed)', 120000, 192000, 120, '2.0 CRDi.'),
  (@gen, @e_d4hb, 'coolant', 7.5, 7.9, 'Hyundai Long Life Coolant (pink OAT, pre-mixed)', 120000, 192000, 120, '2.2 CRDi — slightly larger system.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4ha, 'transmission_at', 7.5, 7.9, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '2.0 CRDi + Hyundai 8AT.'),
  (@gen, @e_d4hb, 'transmission_at', 7.5, 7.9, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '2.2 CRDi + Hyundai 8AT.'),
  (@gen, @e_d4hb, 'transmission_mt', 1.9, 2.0, 'Hyundai MTF 75W-85 GL-4', 60000, 96000, NULL, '2.2 CRDi + 6MT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_hyundai FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

-- =========================================================================
-- HYUNDAI PALISADE LX2 (gen 78) — 3 engines
-- =========================================================================
SET @gen := 78; SET @s_sm := 469;
SET @e_g6dc := 126; SET @e_g6dn := 103;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4hb, 'engine_oil', 6.3, 6.7, '5W-30', 'ACEA C2 (low-SAPS diesel)', '26350-2A500', 7500, 12000, 12, '2.2 TCi D4HB diesel.'),
  (@gen, @e_g6dc, 'engine_oil', 6.3, 6.7, '0W-20', 'API SP / ILSAC GF-6 (Hyundai Premium Long-Life)', '26300-3C250', 7500, 12000, 12, '3.5L Lambda II G6DC V6 NA.'),
  (@gen, @e_g6dn, 'engine_oil', 6.3, 6.7, '0W-20', 'API SP / ILSAC GF-6 (Hyundai Premium Long-Life)', '26300-3C250', 7500, 12000, 12, '3.8L Lambda II G6DN V6 GDI.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4hb, 'coolant', 10.0, 10.6, 'Hyundai LLC (pink OAT)', 120000, 192000, 120, '2.2 diesel V6 SUV chassis.'),
  (@gen, @e_g6dc, 'coolant', 10.0, 10.6, 'Hyundai LLC (pink OAT)', 120000, 192000, 120, '3.5 V6 NA.'),
  (@gen, @e_g6dn, 'coolant', 10.0, 10.6, 'Hyundai LLC (pink OAT)', 120000, 192000, 120, '3.8 V6 GDI.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_d4hb, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '2.2 CRDi + Hyundai 8AT.'),
  (@gen, @e_g6dc, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '3.5 V6 + 8AT.'),
  (@gen, @e_g6dn, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '3.8 V6 + 8AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_hyundai FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- MAZDA CX-50 (gen 80) — 3 engines (2.5 NA + 2.5T + 2.5 Hybrid Toyota-derived)
-- =========================================================================
SET @gen := 80; SET @s_sm := 481;
SET @e_25t := 14;  -- PY-VPTS turbo (also used in CX-5)
SET @e_25h := 129;  -- Dynamic Force hybrid (Toyota-licensed A25A)

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py, 'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12, '2.5L PY-VPS Skyactiv-G NA (CX-50 S).'),
  (@gen, @e_25t, 'engine_oil', 4.7, 5.0, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12, '2.5T PY-VPTS Skyactiv-G turbo.'),
  (@gen, @e_25h, 'engine_oil', 4.5, 4.8, '0W-16', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-16)', '04152-YZZA6', 10000, 16000, 12, '2.5L Hybrid (Toyota A25A-FXS Atkinson licensed by Mazda for CX-50 Hybrid).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py, 'coolant', 7.4, 7.8, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '2.5 NA.'),
  (@gen, @e_25t, 'coolant', 7.6, 8.0, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '2.5T.'),
  (@gen, @e_25h, 'coolant', 8.7, 9.2, 'Toyota SLLC (pink) + inverter loop', 100000, 160000, 120, 'Hybrid — Toyota-derived powertrain, uses Toyota SLLC.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py, 'transmission_at', 6.6, 7.0, 'Mazda ATF FZ', 60000, 96000, NULL, '2.5 NA + Skyactiv-Drive 6AT.'),
  (@gen, @e_25t, 'transmission_at', 6.6, 7.0, 'Mazda ATF FZ', 60000, 96000, NULL, '2.5T + Skyactiv-Drive 6AT.'),
  (@gen, @e_25h, 'transmission_cvt', 4.2, 4.4, 'Toyota WS ATF', 100000, 160000, NULL, 'Hybrid + Toyota e-CVT (licensed with Toyota hybrid powertrain).');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mazda FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- ACURA TLX II (gen 88) — 2 engines (K20C6 2.0T + J30AC 3.0T V6)
-- =========================================================================
SET @gen := 88; SET @s_sm := 520;
SET @e_k20c6 := 139; SET @e_j30 := 119;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20c6, 'engine_oil', 4.7, 5.0, '0W-20', 'API SP / ILSAC GF-6A', '15400-RTA-A01', 7500, 12000, 12, '2.0T K20C6 Honda K-family turbo (Acura-tuned for TLX).'),
  (@gen, @e_j30, 'engine_oil', 5.0, 5.3, '0W-30', 'API SP / Honda Type S spec', '15400-RTA-A01', 6000, 9600, 12, 'Type S 3.0T J30AC Honda J-family V6 turbo. 0W-30 required for V6 turbo tune. 6,000 mi normal for performance application.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20c6, 'coolant', 6.5, 6.9, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60, '2.0T.'),
  (@gen, @e_j30, 'coolant', 8.5, 9.0, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60, '3.0T V6 — larger system.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20c6, 'transmission_at', 6.0, 6.3, 'Honda ATF DW-1', 60000, 96000, NULL, '2.0T + Honda 10AT.'),
  (@gen, @e_j30, 'transmission_at', 6.5, 6.9, 'Honda ATF DW-1', 60000, 96000, NULL, 'Type S 3.0T V6 + Honda 10AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_honda FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- MAZDA CX-90 KK (gen 95) — 3 wired engines (3.3 I6 diesel + 3.3 I6 gas + 2.5 PHEV)
-- =========================================================================
SET @gen := 95; SET @s_sm := 557;
SET @e_diesel := 151; SET @e_gas33 := 160; SET @e_phev := 161;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_gas33, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'TKZ4-14-302', 7500, 12000, 12, '3.3 e-SKYACTIV-G inline-6 (Mazda new I6 platform, M Hybrid Boost).'),
  (@gen, @e_diesel, 'engine_oil', 7.6, 8.0, '5W-30', 'ACEA C3 (low-SAPS diesel)', 'TKZ4-14-302', 7500, 12000, 12, '3.3 e-SKYACTIV-D inline-6 diesel.'),
  (@gen, @e_phev, 'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12, '2.5L PHEV (Mazda PY-VPS-derived block with PHEV integration).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_gas33, 'coolant', 9.5, 10.0, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '3.3 I6 gas.'),
  (@gen, @e_diesel, 'coolant', 11.0, 11.6, 'Mazda Long-life FL22 (green)', 120000, 192000, 120, '3.3 I6 diesel — larger cooling.'),
  (@gen, @e_phev, 'coolant', 10.5, 11.1, 'Mazda Long-life FL22 (green) + HV battery loop', 120000, 192000, 120, '2.5 PHEV — engine + HV battery loop.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_gas33, 'transmission_at', 7.5, 7.9, 'Mazda ATF FZ', 60000, 96000, NULL, '3.3 I6 + Mazda 8AT.'),
  (@gen, @e_diesel, 'transmission_at', 7.5, 7.9, 'Mazda ATF FZ', 60000, 96000, NULL, '3.3 I6 diesel + Mazda 8AT.'),
  (@gen, @e_phev, 'transmission_at', 7.5, 7.9, 'Mazda ATF FZ', 60000, 96000, NULL, '2.5 PHEV + Mazda 8AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mazda FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- HYUNDAI KONA SX2 (gen 118) — 2 ICE engines (EV skipped on this layer)
-- =========================================================================
SET @gen := 118;
SET @e_nu := 179; SET @e_g16t := 180;
SET @s_nhtsa := 593;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_dct')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_dct');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_nu, 'engine_oil', 4.0, 4.2, '5W-30', 'API SP / ILSAC GF-6 (Hyundai Premium)', '26300-35503', 7500, 12000, 12, '2.0L Nu MPI NA. Note: Hyundai recommends 5W-30 on older Nu engine block (vs 0W-20 on newer Smartstream).'),
  (@gen, @e_g16t, 'engine_oil', 4.5, 4.8, '0W-30', 'API SP / ACEA C2', '26300-35505', 7500, 12000, 12, '1.6 T-GDI Smartstream (N-Line). 0W-30 for the turbo.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_nu, 'coolant', 6.7, 7.1, 'Hyundai LLC (pink OAT)', 120000, 192000, 120, '2.0 Nu cooling.'),
  (@gen, @e_g16t, 'coolant', 7.0, 7.4, 'Hyundai LLC (pink OAT)', 120000, 192000, 120, '1.6T — turbo coolant loop included.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_nu, 'transmission_cvt', 5.0, 5.3, 'Hyundai SP-CVT-1', 60000, 96000, NULL, '2.0 Nu + Hyundai IVT (intelligent variable transmission).'),
  (@gen, @e_g16t, 'transmission_dct', 2.5, 2.6, 'Hyundai DCTF', 40000, 64000, NULL, '1.6T + 7DCT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nhtsa FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_hyundai FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_dct');

SELECT 'Family extension batch (7 gens) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (51,68,78,80,88,95,118) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
