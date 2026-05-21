-- Honda Accord CV (2023-present, generation_id=42) — full per-engine moat backfill.
--
-- Two engines:
--   * CY1 (id=69): 1.5L L15-family turbo — 1.5 Turbo CVT trim (Honda CVT)
--   * CY2 (id=68): 2.0L LFB-derived Atkinson — Hybrid e-CVT trim (i-MMD)
--
-- Cross-verification matrix (3 public sources):
--   Source A (id=238): Honda Accord (CV) Owner's Manual
--   Source B (id=236): Honda Accord Service Manual
--   Source C (id=606): Honda factory oil spec (AMSOIL + engineoildb cross)

SET NAMES utf8mb4;

SET @gen      := 42;
SET @e_cy1    := 69;   -- 1.5L L15 turbo
SET @e_cy2    := 68;   -- 2.0L LFB Atkinson hybrid

SET @s_om     := 238;
SET @s_sm     := 236;
SET @s_amsoil := 606;

-- =========================================================================
-- STEP 1 — wipe legacy NULL-engine_id engine-scoped rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cy1, 'engine_oil', 3.4, 3.6, '0W-20', 'API SP / ILSAC GF-6A', '15400-RTA-A01', 7500, 12000, 12,
   '1.5T (CY1, L15-family turbo). Capacity with-filter per Honda Accord (CV) 2023 Owner''s Manual Specifications appendix: 3.6 US qt / 3.4 L. Same filter PN family as the Civic X 1.5T (Honda 1.5T platform shares filter element). Honda Maintenance Minder 7,500 mi normal / 5,000 mi severe.'),
  (@gen, @e_cy2, 'engine_oil', 3.4, 3.6, '0W-20', 'API SP / ILSAC GF-6A', '15400-RTA-A01', 7500, 12000, 12,
   '2.0L Hybrid Atkinson (CY2). Same oil capacity as 1.5T per Honda Accord (CV) 2023 OM. Honda recommends 0W-20 for the Atkinson hybrid; the e-CVT removes shift-load on the engine so drain interval is 7,500 mi normal. Cross-verify filter against your year''s Honda parts catalog — early-MY 2023 Accords used 15400-RBA-F01 on the hybrid before consolidating to the RTA-A01 family.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- The 1.5T uses the engine cooling loop only. The 2.0 hybrid adds an
-- additional inverter / motor-generator coolant loop above the engine fill.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cy1, 'coolant', 5.4, 5.7, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mix)', 60000, 96000, 60,
   '1.5T (CY1). Total engine cooling system capacity per Honda Accord (CV) 2023 OM. Honda Type 2 (blue) is pre-mix only — DO NOT dilute or substitute with green IAT. Initial change 60k mi / 60 mo; subsequent 30k mi / 30 mo.'),
  (@gen, @e_cy2, 'coolant', 7.4, 7.8, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mix) + inverter loop', 60000, 96000, 60,
   '2.0L Hybrid (CY2). Engine cooling loop (5.4 L) + inverter/motor coolant loop (~2.0 L) = ~7.4 L total. Honda OM specifies separate fill procedure for the inverter circuit; do not mix used coolant between loops. Same Type 2 chemistry on both loops.');

-- =========================================================================
-- STEP 4 — transmission fluid per engine.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cy1, 'transmission_cvt', 3.3, 3.5, 'Honda HCF-2 (genuine Honda only)', 60000, 96000, NULL,
   '1.5T (CY1) + Honda CVT. Drain-and-fill capacity per Honda Accord (CV) 2023 OM. HCF-2 only — no DW-1, no generic CVT fluid. Honda recommends drain at 60k mi normal / 25k mi severe duty.'),
  (@gen, @e_cy2, 'transmission_ecvt', 2.8, 3.0, 'Honda ATF DW-1 (genuine Honda)', 60000, 96000, NULL,
   '2.0L Hybrid (CY2) + i-MMD e-CVT. The Honda hybrid is NOT a true CVT — it uses planetary gear sets driven by motor-generator with a single lock-up clutch. Lubricant is ATF DW-1 (NOT HCF-2). Smaller capacity (2.8 L) than 1.5T CVT (3.3 L). Same 60k mi service interval.');

-- =========================================================================
-- STEP 5 — link new fluid rows to public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type='engine_oil';

-- =========================================================================
-- STEP 6 — per-engine torque_specs (spark plug + oil drain).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_cy1, 'spark_plug', 18, 13, NULL,
   '1.5T (CY1) — Honda L15-family. NGK DILZKAR7C11S OE iridium plug, M12×1.25. 100k mi normal service.'),
  (@gen, @e_cy2, 'spark_plug', 18, 13, NULL,
   '2.0L Hybrid (CY2). Same iridium plug family as 1.5T (Honda standardizes across i-MMD lineup). 100k mi normal.'),
  (@gen, @e_cy1, 'oil_drain', 39, 29, NULL,
   '1.5T oil pan drain plug — M14×1.5 with single-use crush washer (Honda PN 94109-14000). Aluminum oil pan — over-torque pulls threads.'),
  (@gen, @e_cy2, 'oil_drain', 39, 29, NULL,
   '2.0L Hybrid oil drain — same M14×1.5 and washer as 1.5T. Same torque spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

-- =========================================================================
-- STEP 7 — per-engine parts (oil filter, spark plug, air filter).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, @e_cy1, 'oil_filter', '15400-RTA-A01', 'Honda OEM', NULL, NULL,
   'Honda 1.5T filter (white band). Cross-references: Wix 51365, Fram PH6017, Mobil 1 M1-101A.'),
  (@gen, @e_cy2, 'oil_filter', '15400-RTA-A01', 'Honda OEM', NULL, NULL,
   '2.0L Hybrid. Honda Accord (CV) consolidated to the 15400-RTA-A01 filter element across both powertrains. Early-MY 2023 hybrid used 15400-RBA-F01 — verify against your year''s Honda parts catalog if VIN is early-2023.'),
  (@gen, @e_cy1, 'spark_plug', '12290-5BA-A01', 'Honda OEM (NGK DILZKAR7C11S)', 1.10, NULL,
   '1.5T OE iridium plug. Gap 1.1 mm pre-set. 100k mi.'),
  (@gen, @e_cy2, 'spark_plug', '12290-5BA-A01', 'Honda OEM (NGK DILZKAR7C11S)', 1.10, NULL,
   '2.0L Hybrid OE iridium plug. Same plug as 1.5T per Honda parts catalog for the i-MMD platform.'),
  (@gen, NULL, 'air_filter', '17220-64A-A00', 'Honda OEM', NULL, NULL,
   'Shared air-box across both engines on Accord (CV) chassis. Replace 30k mi normal, 15k mi severe.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

-- =========================================================================
-- STEP 8 — verification report.
-- =========================================================================
SELECT 'Accord CV moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts;
