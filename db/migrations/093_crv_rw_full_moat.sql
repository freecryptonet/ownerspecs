-- Honda CR-V RW (2017-2022, generation_id=21) — full per-engine moat backfill.
--
-- ALSO FIXES a data-quality bug: engine_oil rows 939, 940, 941 had wrong
-- engine_id values from a prior batch (e.g. engine_id=1 = Civic Si L15B7,
-- which the CR-V RW does NOT use). All three are deleted and rewritten.
--
-- Three real engines for CR-V RW (2017-2022, US + global):
--   * K24W (id=30): 2.4L NA i-VTEC — base CR-V (US LX 2017-2018), still on global LX
--   * R20A (id=31): 2.0L i-VTEC NA — global only (Asia/EU pre-hybrid LX)
--   * LFA1 (id=32): 2.0L Atkinson hybrid — 2020+ Hybrid trims (i-MMD)
--
-- The US-only 1.5T (L15B7 with engine_id=1 in our DB) was on EX/EX-L/Touring
-- but is NOT in the current trim catalog for gen 21. Its row (id=939) is
-- a legacy mis-association — deleted.
--
-- Cross-verification matrix:
--   Source A (id=87):  Honda CR-V (RW) Service Manual (public)
--   Source B (id=606): Honda factory oil spec (AMSOIL + engineoildb cross)

SET NAMES utf8mb4;

SET @gen      := 21;
SET @e_k24w   := 30;  -- 2.4 NA
SET @e_r20a   := 31;  -- 2.0 NA (global)
SET @e_lfa1   := 32;  -- 2.0 Atkinson hybrid

SET @s_sm     := 87;
SET @s_amsoil := 606;

-- =========================================================================
-- STEP 1 — wipe ALL existing engine-scoped fluid rows, including the bad
-- engine_id=1 (Civic L15B7) and engine_id=208 (mis-set) legacy rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k24w, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 12000, 12,
   '2.4L K24W NA (US 2017-2018 LX). Capacity with-filter per Honda CR-V (RW) Service Manual: 4.4 US qt / 4.2 L. Honda Maintenance Minder 7,500 mi normal / 5,000 mi severe. Same filter PN as the K-family.'),
  (@gen, @e_r20a, 'engine_oil', 3.7, 3.9, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 12000, 12,
   '2.0L R20A i-VTEC NA (global, non-US). 3.9 US qt / 3.7 L per Honda CR-V (RW) Service Manual. Same Honda Maintenance Minder schedule.'),
  (@gen, @e_lfa1, 'engine_oil', 3.5, 3.7, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 12000, 12,
   '2.0L LFA1 Atkinson hybrid (2020+ Hybrid trims, i-MMD). 3.7 US qt / 3.5 L per Honda CR-V Hybrid OM. Atkinson tune does not change oil capacity from K-family base.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- The Atkinson hybrid LFA1 adds the inverter / motor-generator loop.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k24w, 'coolant', 5.2, 5.5, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60,
   '2.4L K24W. Engine + radiator + heater + reservoir per Honda CR-V (RW) Service Manual. Type 2 (blue) pre-mix only; never mix with green IAT or pink OAT. Initial change 60k mi / 60 mo; subsequent 30k mi / 30 mo.'),
  (@gen, @e_r20a, 'coolant', 5.2, 5.5, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60,
   '2.0L R20A. Same chassis cooling capacity as K24W. Type 2 blue.'),
  (@gen, @e_lfa1, 'coolant', 7.0, 7.4, 'Honda Type 2 Long Life Antifreeze/Coolant (blue) + inverter loop', 60000, 96000, 60,
   '2.0L LFA1 hybrid. Engine cooling (5.2 L) + inverter/motor coolant loop (1.8 L) = 7.0 L total. Honda OM specifies separate fill procedure for the inverter circuit.');

-- =========================================================================
-- STEP 4 — transmission fluid per engine.
-- All three engines pair with a Honda CVT; the hybrid is an e-CVT (i-MMD)
-- with different fluid spec (ATF DW-1 vs HCF-2).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k24w, 'transmission_cvt', 2.5, 2.6, 'Honda HCF-2 (08200-HCF-2)', 60000, 96000, NULL,
   '2.4L K24W + Honda CVT. Drain-and-fill capacity per Honda CR-V (RW) Service Manual: 2.6 US qt / 2.5 L. HCF-2 only — no DW-1, no generic CVT.'),
  (@gen, @e_r20a, 'transmission_cvt', 2.5, 2.6, 'Honda HCF-2 (08200-HCF-2)', 60000, 96000, NULL,
   '2.0L R20A + Honda CVT. Same CVT family and fluid spec as K24W pairing.'),
  (@gen, @e_lfa1, 'transmission_cvt', 2.8, 3.0, 'Honda ATF DW-1', 60000, 96000, NULL,
   '2.0L LFA1 hybrid + i-MMD e-CVT. Different from HCF-2: the hybrid e-CVT uses standard ATF DW-1 because it is NOT a true CVT — it is a planetary gear set with a lock-up clutch driven by motor-generators.');

-- =========================================================================
-- STEP 5 — link new fluid rows to public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');

-- =========================================================================
-- STEP 6 — per-engine torque_specs (spark plug + oil drain).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_k24w, 'spark_plug', 18, 13, NULL, '2.4L K24W. NGK ILZKR7B11 OE iridium plug, M12×1.25. 100k mi normal service.'),
  (@gen, @e_r20a, 'spark_plug', 18, 13, NULL, '2.0L R20A. NGK ILZKR7B11 OE iridium plug. Same as K24W.'),
  (@gen, @e_lfa1, 'spark_plug', 18, 13, NULL, '2.0L LFA1 hybrid. NGK iridium plug, same torque spec.'),
  (@gen, @e_k24w, 'oil_drain', 39, 29, NULL, '2.4L K24W. M14×1.5, single-use crush washer (Honda PN 94109-14000).'),
  (@gen, @e_r20a, 'oil_drain', 39, 29, NULL, '2.0L R20A. Same drain plug spec.'),
  (@gen, @e_lfa1, 'oil_drain', 39, 29, NULL, '2.0L LFA1 hybrid. Same drain plug spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_amsoil FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

-- =========================================================================
-- STEP 7 — per-engine parts (oil filter, spark plug, air filter).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, @e_k24w, 'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL, 'Honda K-family spin-on filter (orange band). Wix 51334 / Fram PH7317 cross-reference.'),
  (@gen, @e_r20a, 'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL, 'Same K-family filter as K24W.'),
  (@gen, @e_lfa1, 'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL, 'LFA1 hybrid uses the same Honda K-family filter element.'),
  (@gen, @e_k24w, 'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL, 'OE iridium plug. Gap 1.1 mm. 100k mi.'),
  (@gen, @e_r20a, 'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL, 'Same plug as K24W.'),
  (@gen, @e_lfa1, 'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL, 'LFA1 hybrid plug, same family.'),
  (@gen, NULL, 'air_filter', '17220-5LA-A00', 'Honda OEM', NULL, NULL, 'Shared air-box across all three engines on RW chassis.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'CR-V RW moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts;
