-- VW Group batch backfill: Audi A4 B9, Audi Q5 FY, Audi Q7 4M, VW Tiguan AD1.
-- All share EA888 / EA897 / EA839 engine families across the VW Group lineup.

SET NAMES utf8mb4;
SET @s_vw := 609;

-- =========================================================================
-- AUDI A4 B9 (gen 24) — 5 engines
-- =========================================================================
SET @gen := 24; SET @s_sm := 106;
SET @e_cvkb := 37;  -- 2.0 TFSI 190 Hp
SET @e_cyrb := 36;  -- 2.0 TFSI 252 Hp
SET @e_deta := 38;  -- 2.0 TDI 190 Hp diesel
SET @e_cswb := 35;  -- 3.0 TDI 218 Hp V6 diesel
SET @e_crtc := 34;  -- 3.0 TDI 272 Hp V6 diesel

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cvkb, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, 'CVKB 2.0 TFSI 190 Hp (EA888 evo3).'),
  (@gen, @e_cyrb, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, 'CYRB 2.0 TFSI 252 Hp (EA888 evo3, higher-output tune).'),
  (@gen, @e_deta, 'engine_oil', 4.5, 4.8, '0W-30', 'VW 507.00 (LongLife III, low-SAPS diesel)', '04L115561H', 10000, 16000, 12, 'DETA 2.0 TDI 190 Hp diesel. 507.00 low-SAPS for DPF.'),
  (@gen, @e_cswb, 'engine_oil', 7.5, 7.9, '5W-30', 'VW 507.00 (LongLife III, low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'CSWB 3.0 TDI V6 218 Hp.'),
  (@gen, @e_crtc, 'engine_oil', 7.5, 7.9, '5W-30', 'VW 507.00 (LongLife III, low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'CRTC 3.0 TDI V6 272 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cvkb, 'coolant', 8.0, 8.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '2.0 TFSI 190 Hp.'),
  (@gen, @e_cyrb, 'coolant', 8.0, 8.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '2.0 TFSI 252 Hp.'),
  (@gen, @e_deta, 'coolant', 8.5, 9.0, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '2.0 TDI diesel — slightly larger cooling.'),
  (@gen, @e_cswb, 'coolant', 10.5, 11.1, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI V6 218 Hp.'),
  (@gen, @e_crtc, 'coolant', 10.5, 11.1, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI V6 272 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cvkb, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, '2.0 TFSI + 7-speed S tronic (DQ381).'),
  (@gen, @e_cvkb, 'transmission_mt', 1.9, 2.0, 'VW MTF G052171', 60000, 96000, NULL, '2.0 TFSI + 6MT (rare config).'),
  (@gen, @e_cyrb, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, '2.0 TFSI 252 Hp + S tronic 7DCT.'),
  (@gen, @e_deta, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, '2.0 TDI + S tronic 7DCT.'),
  (@gen, @e_cswb, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI V6 218 Hp + ZF 8HP Tiptronic.'),
  (@gen, @e_crtc, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI V6 272 Hp + ZF 8HP Tiptronic.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt');

-- =========================================================================
-- AUDI Q5 FY (gen 82) — 4 engines
-- =========================================================================
SET @gen := 82; SET @s_sm := 491;
SET @e_dnta := 133; SET @e_dlga := 131; SET @e_dcpe := 134; SET @e_dcpc := 132;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dnta, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, 'DNTA 2.0 TFSI 245 Hp (45 TFSI).'),
  (@gen, @e_dlga, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, 'DLGA 2.0 TFSI e PHEV (50/55 TFSI e).'),
  (@gen, @e_dcpe, 'engine_oil', 7.5, 7.9, '5W-30', 'VW 507.00 (low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'DCPE 3.0 TDI V6 231 Hp (45 TDI).'),
  (@gen, @e_dcpc, 'engine_oil', 7.5, 7.9, '5W-30', 'VW 507.00 (low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'DCPC 3.0 TDI V6 286 Hp (50 TDI).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dnta, 'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '2.0 TFSI.'),
  (@gen, @e_dlga, 'coolant', 9.5, 10.0, 'VW G13 (lilac, OAT) + HV battery loop', 120000, 192000, 120, '2.0 TFSI e PHEV — adds HV battery cooling.'),
  (@gen, @e_dcpe, 'coolant', 11.0, 11.6, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI V6 231 Hp.'),
  (@gen, @e_dcpc, 'coolant', 11.0, 11.6, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI V6 286 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dnta, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, '2.0 TFSI + S tronic 7DCT.'),
  (@gen, @e_dlga, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'PHEV + S tronic 7DCT.'),
  (@gen, @e_dcpe, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI V6 + ZF 8HP Tiptronic.'),
  (@gen, @e_dcpc, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI V6 286 Hp + ZF 8HP Tiptronic.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');

-- =========================================================================
-- AUDI Q7 4M (gen 90) — 5 engines
-- =========================================================================
SET @gen := 90; SET @s_sm := 535;
SET @e_dhxc := 144; SET @e_cvza := 142; SET @e_om656 := 155;
SET @e_dhxa := 143; SET @e_ea839 := 152;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dhxc, 'engine_oil', 8.0, 8.5, '5W-30', 'VW 507.00 (low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'DHXC 3.0 TDI V6 231 Hp MHEV (45 TDI).'),
  (@gen, @e_cvza, 'engine_oil', 7.5, 7.9, '5W-30', 'VW 507.00 (low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'CVZA 3.0 TDI e-tron PHEV.'),
  (@gen, @e_om656, 'engine_oil', 7.0, 7.4, '5W-30', 'MB 229.52 (low-SAPS diesel)', 'A6541801409', 10000, 16000, 12, 'OM656 3.0 TDI (Mercedes-derived inline-6 diesel — catalog entry suggests Q7 cross-market sourcing). Mercedes filter PN.'),
  (@gen, @e_dhxa, 'engine_oil', 8.0, 8.5, '5W-30', 'VW 507.00 (low-SAPS diesel)', '057115561L', 10000, 16000, 12, 'DHXA 3.0 TDI V6 286 Hp MHEV (50 TDI).'),
  (@gen, @e_ea839, 'engine_oil', 6.5, 6.9, '0W-20', 'VW 508.00 (LongLife IV FE)', '06M115562B', 10000, 16000, 12, 'EA839 3.0 TFSI V6 333 Hp (gasoline).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dhxc, 'coolant', 11.5, 12.2, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI MHEV — large SUV cooling.'),
  (@gen, @e_cvza, 'coolant', 12.0, 12.7, 'VW G13 (lilac, OAT) + HV battery loop', 120000, 192000, 120, '3.0 TDI PHEV.'),
  (@gen, @e_om656, 'coolant', 11.5, 12.2, 'VW G13 (lilac, OAT) — Mercedes spec accepted', 120000, 192000, 120, 'OM656 — verify against actual MY service docs.'),
  (@gen, @e_dhxa, 'coolant', 11.5, 12.2, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TDI 286 Hp MHEV.'),
  (@gen, @e_ea839, 'coolant', 11.5, 12.2, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '3.0 TFSI gasoline V6.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dhxc, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI MHEV + ZF 8HP Tiptronic.'),
  (@gen, @e_cvza, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI PHEV + ZF 8HP.'),
  (@gen, @e_om656, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, 'OM656 + ZF 8HP.'),
  (@gen, @e_dhxa, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TDI 286 Hp MHEV + ZF 8HP.'),
  (@gen, @e_ea839, 'transmission_at', 9.0, 9.5, 'ZF Lifeguard 8 / VW G055540', 60000, 96000, NULL, '3.0 TFSI + ZF 8HP.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- VW TIGUAN AD1 (gen 44) — 4 engines, all 2.0 TSI variants
-- =========================================================================
SET @gen := 44; SET @s_sm := 249;
SET @e_czpa := 74; SET @e_dkza := 73; SET @e_chhb := 72; SET @e_dkta := 71;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_czpa, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00', '06L115562B', 10000, 16000, 12, 'CZPA 2.0 TSI 180 Hp.'),
  (@gen, @e_dkza, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00', '06L115562B', 10000, 16000, 12, 'DKZA 2.0 TSI 190 Hp.'),
  (@gen, @e_chhb, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00', '06L115562B', 10000, 16000, 12, 'CHHB 2.0 TSI 220 Hp.'),
  (@gen, @e_dkta, 'engine_oil', 5.2, 5.5, '0W-20', 'VW 508.00', '06L115562B', 10000, 16000, 12, 'DKTA 2.0 TSI 230 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_czpa, 'coolant', 8.5, 9.0, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'CZPA cooling.'),
  (@gen, @e_dkza, 'coolant', 8.5, 9.0, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'DKZA cooling.'),
  (@gen, @e_chhb, 'coolant', 8.5, 9.0, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'CHHB cooling.'),
  (@gen, @e_dkta, 'coolant', 8.5, 9.0, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'DKTA cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_czpa, 'transmission_mt', 1.9, 2.0, 'VW MTF G052171', 60000, 96000, NULL, 'CZPA + 6MT.'),
  (@gen, @e_czpa, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'CZPA + 7DCT DSG.'),
  (@gen, @e_dkza, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'DKZA + 7DCT DSG.'),
  (@gen, @e_chhb, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'CHHB + 7DCT DSG.'),
  (@gen, @e_dkta, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'DKTA + 7DCT DSG.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt');

SELECT 'VW Group batch (A4 B9 + Q5 FY + Q7 4M + Tiguan AD1) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (24,82,90,44) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
