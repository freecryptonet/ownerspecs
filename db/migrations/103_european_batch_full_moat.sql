-- European batch backfill: BMW G20, BMW X3 G01, Mercedes W206, VW Golf Mk8.
-- Heaviest-suppression set in the canary audit — all four had 0 per-engine
-- fluid rows despite 4-8 engine variants each.

SET NAMES utf8mb4;
SET @s_bmw  := 603;  -- BMW factory oil spec aggregator (TIS + Pelican + Blauparts)
SET @s_mb   := 604;  -- Mercedes-Benz factory oil spec aggregator
SET @s_vw   := 609;  -- VW Group factory oil spec aggregator

-- =========================================================================
-- BMW G20 3-Series sedan (gen 6) — 6 engines
-- =========================================================================
SET @gen := 6; SET @s_sm := 20;
SET @e_b46    := 13;  -- B46B20 2.0T US
SET @e_b48    := 8;   -- B48B20 2.0T EU
SET @e_b48b   := 12;  -- B48B20B 2.0T xDrive
SET @e_b57    := 11;  -- B57D30A 3.0L diesel M340d
SET @e_b58b   := 10;  -- B58B30B 3.0L turbo M340i EU 374 Hp
SET @e_b58o   := 9;   -- B58B30O1 3.0L turbo M340i US 382 Hp

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b46, 'engine_oil', 5.2, 5.5, '0W-20', 'BMW LL-17 FE+ (Longlife)', '11428583898', 10000, 16000, 12, 'B46B20 2.0T (US 330i 255 Hp). With-filter capacity per BMW 3-Series (G20) Service Manual. BMW LL-17 FE+ approval required.'),
  (@gen, @e_b48, 'engine_oil', 5.2, 5.5, '0W-30', 'BMW LL-17 FE+ (Longlife)', '11428583898', 10000, 16000, 12, 'B48B20 2.0T (EU 330i 258 Hp). EU markets prefer 0W-30 for cold-climate; 0W-20 backward-compat for warmer.'),
  (@gen, @e_b48b, 'engine_oil', 5.2, 5.5, '0W-30', 'BMW LL-17 FE+ (Longlife)', '11428583898', 10000, 16000, 12, 'B48B20B 2.0T xDrive (EU 330i xDrive 258 Hp).'),
  (@gen, @e_b57, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-04 (diesel-only with DPF)', '11428575211', 10000, 16000, 12, 'B57D30A 3.0L diesel (M340d). LL-04 required — low-SAPS for DPF.'),
  (@gen, @e_b58b, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+ (Longlife)', '11428575211', 10000, 16000, 12, 'B58B30B 3.0L turbo (M340i EU 374 Hp). Larger filter than 2.0L B-engines.'),
  (@gen, @e_b58o, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+ (Longlife)', '11428575211', 10000, 16000, 12, 'B58B30O1 3.0L turbo (M340i US 382 Hp). Same oil capacity as EU tune; US OM lists 0W-30 with LL-17 FE+ approval.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b46, 'coolant', 7.5, 7.9, 'BMW Longlife Coolant (blue, pre-mixed) — NO substitutes', 120000, 192000, 120, 'B46 2.0T cooling.'),
  (@gen, @e_b48, 'coolant', 7.5, 7.9, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B48 2.0T.'),
  (@gen, @e_b48b, 'coolant', 7.5, 7.9, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B48B 2.0T xDrive — same cooling.'),
  (@gen, @e_b57, 'coolant', 9.0, 9.5, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B57 3.0L diesel — larger system for diesel thermal load.'),
  (@gen, @e_b58b, 'coolant', 9.5, 10.0, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 3.0L turbo — adds turbo coolant loop + intercooler.'),
  (@gen, @e_b58o, 'coolant', 9.5, 10.0, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 US tune — same coolant capacity.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b46, 'transmission_at', 7.5, 7.9, 'ZF Lifeguard 8 (BMW ATF, 83222152426)', 60000, 96000, NULL, '2.0T + ZF 8HP50 8AT. BMW lists "fill-for-life" but service at 60k mi severe / 100k mi normal recommended by ZF.'),
  (@gen, @e_b48, 'transmission_at', 7.5, 7.9, 'ZF Lifeguard 8', 60000, 96000, NULL, 'Same 8HP50.'),
  (@gen, @e_b48b, 'transmission_at', 7.5, 7.9, 'ZF Lifeguard 8', 60000, 96000, NULL, 'Same 8HP50 xDrive.'),
  (@gen, @e_b57, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8 (high-torque variant)', 60000, 96000, NULL, 'M340d + ZF 8HP75 (heavy-duty for diesel torque).'),
  (@gen, @e_b58b, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'M340i + ZF 8HP75.'),
  (@gen, @e_b58o, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'M340i US + ZF 8HP75.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- BMW X3 G01 (gen 60) — 4 engines
-- =========================================================================
SET @gen := 60; SET @s_sm := 353;
SET @e_b57x := 105; SET @e_b58a := 104;
-- e_b58b and e_b58o reused from G20

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b57x, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-04 (diesel)', '11428575211', 10000, 16000, 12, 'B57D30B 3.0L diesel mild hybrid (M40d). LL-04 only.'),
  (@gen, @e_b58a, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+', '11428575211', 10000, 16000, 12, 'B58B30A 3.0L turbo (M40i 354 Hp).'),
  (@gen, @e_b58b, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+', '11428575211', 10000, 16000, 12, 'B58B30B 3.0L turbo (M40i EU 360 Hp).'),
  (@gen, @e_b58o, 'engine_oil', 6.5, 6.9, '0W-30', 'BMW LL-17 FE+', '11428575211', 10000, 16000, 12, 'B58B30O1 3.0L turbo (M40i US 382 Hp).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b57x, 'coolant', 10.5, 11.1, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B57 diesel in SUV chassis — larger cooling.'),
  (@gen, @e_b58a, 'coolant', 9.8, 10.4, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 turbo in X3 SUV chassis.'),
  (@gen, @e_b58b, 'coolant', 9.8, 10.4, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 EU 360 Hp.'),
  (@gen, @e_b58o, 'coolant', 9.8, 10.4, 'BMW Longlife Coolant (blue, pre-mixed)', 120000, 192000, 120, 'B58 US tune.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b57x, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8 (high-torque)', 60000, 96000, NULL, 'M40d + ZF 8HP75.'),
  (@gen, @e_b58a, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'M40i + ZF 8HP75.'),
  (@gen, @e_b58b, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'M40i 360 Hp.'),
  (@gen, @e_b58o, 'transmission_at', 8.5, 9.0, 'ZF Lifeguard 8', 60000, 96000, NULL, 'M40i 382 Hp US.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- MERCEDES W206 C-Class (gen 29) — 2 engines
-- =========================================================================
SET @gen := 29; SET @s_sm := 154;
SET @e_m254 := 45;  -- M254.920 2.0T
SET @e_m139 := 44;  -- M139.580 2.0T AMG

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m254, 'engine_oil', 5.8, 6.1, '0W-20', 'MB 229.71 (fuel-economy spec)', 'A2701800009', 10000, 16000, 12, 'M254 2.0T mild hybrid + EQ Boost (C 300e / C 400e). MB 229.71 required — DO NOT substitute MB 229.5 (different spec).'),
  (@gen, @e_m139, 'engine_oil', 7.0, 7.4, '5W-40', 'MB 229.5 (high-performance)', 'A1331840525', 10000, 16000, 12, 'M139 2.0T AMG hand-built (C 43, C 63 S E PERFORMANCE). 5W-40 only — high-output tune needs heavier base oil.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m254, 'coolant', 8.5, 9.0, 'MB-Spec 325.6 NF (Glysantin G40, pink/red)', 60000, 96000, 60, 'M254 W206 cooling system.'),
  (@gen, @e_m139, 'coolant', 9.0, 9.5, 'MB-Spec 325.6 NF (Glysantin G40, pink/red)', 60000, 96000, 60, 'M139 AMG — slightly larger system for high-output tune.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_m254, 'transmission_at', 7.0, 7.4, 'MB-Approval 236.15 (FE-CVT-fluid)', 60000, 96000, NULL, 'M254 + 9G-Tronic 9AT.'),
  (@gen, @e_m139, 'transmission_at', 7.5, 7.9, 'MB-Approval 236.91 (AMG MCT-specific)', 40000, 64000, NULL, 'M139 + AMG SPEEDSHIFT MCT 9G. Different fluid spec from 9G-Tronic — do not substitute.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mb FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- VW GOLF MK8 (gen 18) — 6 engine variants (EA888 family + 1.4 TSI eHybrid)
-- =========================================================================
SET @gen := 18; SET @s_sm := 65;
SET @e_dgea  := 24;
SET @e_dnpa  := 23;
SET @e_dnfc  := 22;
SET @e_dsf   := 21;
SET @e_dnfg  := 20;
SET @e_dnnf  := 19;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'engine_oil', 4.0, 4.2, '0W-20', 'VW 508.00 / 509.00 (LongLife IV FE)', '04E115561H', 10000, 16000, 12, '1.4 TSI eHybrid GTE (DGEA). VW 508.00 fuel-economy spec required for the hybrid.'),
  (@gen, @e_dnpa, 'engine_oil', 5.7, 6.0, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, '2.0 TSI GTI 245 Hp (DNPA, EA888 evo3). With-filter capacity per VW Golf Mk8 SM.'),
  (@gen, @e_dnfc, 'engine_oil', 5.7, 6.0, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, '2.0 TSI GTI Clubsport 300 Hp (DNFC).'),
  (@gen, @e_dsf,  'engine_oil', 5.7, 6.0, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, '2.0 TSI R 315 Hp (DSFE/DSFF).'),
  (@gen, @e_dnfg, 'engine_oil', 5.7, 6.0, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, '2.0 TSI R 320 Hp (DNFG, EA888 evo4).'),
  (@gen, @e_dnnf, 'engine_oil', 5.7, 6.0, '0W-20', 'VW 508.00 (LongLife IV FE)', '06L115562B', 10000, 16000, 12, '2.0 TSI R 20 Years 333 Hp (DNNF, EA888 evo4).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'coolant', 9.5, 10.0, 'VW G13 (lilac, OAT) — never mix with G11/G12', 120000, 192000, 120, '1.4 TSI eHybrid + battery cooling loop.'),
  (@gen, @e_dnpa, 'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, '2.0 TSI GTI 245 Hp.'),
  (@gen, @e_dnfc, 'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'GTI Clubsport.'),
  (@gen, @e_dsf,  'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'R 315 Hp.'),
  (@gen, @e_dnfg, 'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'R 320 Hp.'),
  (@gen, @e_dnnf, 'coolant', 9.0, 9.5, 'VW G13 (lilac, OAT)', 120000, 192000, 120, 'R 20 Years 333 Hp.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G052529 (eHybrid-specific)', 40000, 64000, NULL, '1.4 TSI eHybrid + DQ400e wet DSG (P2 hybrid).'),
  (@gen, @e_dnpa, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, '2.0 TSI GTI + DQ381 7-speed wet DSG.'),
  (@gen, @e_dnpa, 'transmission_mt', 1.7, 1.8, 'VW MTF G052171', 60000, 96000, NULL, 'GTI 245 + 6MT.'),
  (@gen, @e_dnfc, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'GTI Clubsport + DQ381 DSG.'),
  (@gen, @e_dsf,  'transmission_mt', 1.7, 1.8, 'VW MTF G052171', 60000, 96000, NULL, 'R 315 Hp + 6MT.'),
  (@gen, @e_dsf,  'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'R 315 Hp + DQ381 DSG.'),
  (@gen, @e_dnfg, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'R 320 Hp + DQ381 DSG.'),
  (@gen, @e_dnnf, 'transmission_dct', 5.5, 5.8, 'VW DSG fluid G055530', 40000, 64000, NULL, 'R 333 Hp + DQ381 DSG.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vw FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt');

SELECT 'European batch (G20 + X3 G01 + W206 + Golf Mk8) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (6,60,29,18) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
