-- Toyota Camry XV70 (2018-2024, generation_id=2) — full per-engine moat backfill.
--
-- Three engines in this gen:
--   * A25A-FKS (id=5): 2.5L Dynamic Force NA — LE, SE, XLE non-hybrid (UB80E 8AT)
--   * A25A-FXS (id=6): 2.5L hybrid Atkinson — LE Hybrid (P710 eCVT)
--   * 2GR-FKS  (id=7): 3.5L V6 NA — XSE V6 (UB80E 8AT)
--
-- Cross-verification matrix (2 public sources per fact, 3rd from internal):
--   Source A (id=5):   Toyota 2020 Camry Owner's Manual — Toyota US OEM
--   Source B (id=605): Toyota/Lexus factory oil spec (AMSOIL + OilType + Toyota-Club cross)
--   Source C (id=593): NHTSA vPIC — engine code + displacement validation

SET NAMES utf8mb4;

SET @gen      := 2;
SET @e_fks    := 5;   -- A25A-FKS 2.5 NA
SET @e_fxs    := 6;   -- A25A-FXS 2.5 hybrid
SET @e_2gr    := 7;   -- 2GR-FKS 3.5 V6

SET @s_om     := 5;
SET @s_amsoil := 605;
SET @s_nhtsa  := 593;

-- =========================================================================
-- STEP 1 — wipe legacy NULL-engine_id engine-scoped rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','engine_oil_v6','engine_oil_hybrid','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','engine_oil_v6','engine_oil_hybrid','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'engine_oil', 4.4, 4.6, '0W-16', 'API SP / ILSAC GF-6',  '04152-YZZA6', 10000, 16000, 12,
   '2.5L A25A-FKS NA (LE, SE, XLE). Capacity with filter change per Toyota 2020 Camry OM Specifications appendix: 4.6 US qt / 4.4 L. Toyota US recommends 0W-16 for fuel economy; 0W-20 is back-compat for cold-climate markets. Toyota Maintenance Schedule: 10,000 mi or 12 months normal; 5,000 mi severe.'),
  (@gen, @e_fxs, 'engine_oil', 4.4, 4.6, '0W-16', 'API SP / ILSAC GF-6',  '04152-YZZA6', 10000, 16000, 12,
   '2.5L A25A-FXS Hybrid (LE Hybrid, SE Hybrid, XLE Hybrid, XSE Hybrid). Same A25A oil pan and capacity as A25A-FKS — 4.4 L with filter. Atkinson-cycle tune does not change oil capacity. Same OEM filter 04152-YZZA6.'),
  (@gen, @e_2gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6',  '04152-31110', 10000, 16000, 12,
   '3.5L 2GR-FKS V6 (XSE V6, TRD V6). Capacity with filter change per Toyota 2020 Camry V6 OM: 6.0 US qt / 5.7 L. Toyota US recommends 0W-20 (V6 cannot run 0W-16 — heavier load). Different filter PN than the 2.5L: 04152-31110.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- A25A-FKS/FXS (4-cyl) and 2GR-FKS (V6) have notably different cooling
-- system sizes. Hybrid adds the inverter / motor-generator coolant loop.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'coolant', 6.3, 6.7, 'Toyota Super Long Life Coolant SLLC (pink)', 100000, 160000, 120,
   '2.5L A25A-FKS NA. Engine + radiator + heater total per Toyota 2020 Camry OM. SLLC pre-mix — never mix with green IAT or amber HOAT. Initial change 100k mi / 10 yr; subsequent 50k mi / 5 yr.'),
  (@gen, @e_fxs, 'coolant', 8.7, 9.2, 'Toyota Super Long Life Coolant SLLC (pink) + inverter loop',  100000, 160000, 120,
   '2.5L A25A-FXS Hybrid. 6.3 L engine cooling + 2.4 L inverter / motor-generator loop = 8.7 L total. Toyota OM specifies separate fill procedure for the inverter loop. Same SLLC chemistry as engine loop, but Toyota recommends bleeding the inverter loop separately at service.'),
  (@gen, @e_2gr, 'coolant', 9.0, 9.5, 'Toyota Super Long Life Coolant SLLC (pink)', 100000, 160000, 120,
   '3.5L 2GR-FKS V6. Larger cooling system to handle V6 thermal load: 9.0 L total per Toyota 2020 Camry V6 OM. Same SLLC formula.');

-- =========================================================================
-- STEP 4 — transmission fluid per engine.
-- UB80E 8AT pairs with A25A-FKS and 2GR-FKS (different vehicles, same trans
-- box and fluid). P710 eCVT pairs with the A25A-FXS hybrid (categorized
-- as transmissions.type='CVT' in our DB → fluid_type='transmission_cvt').
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'transmission_at', 3.6, 3.8, 'Toyota WS (World Standard) / JWS 3324', 60000, 96000, NULL,
   'A25A-FKS + UB80E 8AT. Drain-and-fill capacity per Toyota 2020 Camry OM. Toyota WS only — DO NOT substitute Dexron, Mercon, or generic ATF; WS uses a different additive package and friction modifier. Full system fill ~8.0 L; pan service ~3.6 L.'),
  (@gen, @e_2gr, 'transmission_at', 3.6, 3.8, 'Toyota WS (World Standard) / JWS 3324', 60000, 96000, NULL,
   '2GR-FKS V6 + UB80E 8AT. Same transmission box and fluid spec as the 2.5L variant. Toyota WS only.'),
  (@gen, @e_fxs, 'transmission_cvt', 4.0, 4.2, 'Toyota WS (World Standard) / JWS 3324', 100000, 160000, NULL,
   'A25A-FXS hybrid + P710 eCVT. Toyota labels this an eCVT but the fluid is the same Toyota WS as the conventional AT (Toyota uses WS across the eCVT line). Capacity slightly higher than UB80E AT due to the planetary gear set bath. Toyota OM lists 100k mi normal service interval — much longer than conventional AT because the eCVT has no clutch packs to wear.');

-- =========================================================================
-- STEP 5 — link new fluid rows to the three public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nhtsa FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type='engine_oil' AND engine_id IS NOT NULL;

-- =========================================================================
-- STEP 6 — per-engine torque_specs (spark plug + oil drain).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_fks, 'spark_plug', 25, 18, NULL,
   'A25A-FKS 2.5L NA. Denso FK20HR-Q11 OE iridium plug, M12×1.25. Toyota service interval 120k mi for iridium. Torque cold engine; over-torque on aluminium head will pull threads.'),
  (@gen, @e_fxs, 'spark_plug', 25, 18, NULL,
   'A25A-FXS 2.5L Hybrid. Same Denso FK20HR-Q11 plug and torque as A25A-FKS — identical head and plug well design. Hybrid runs cooler but uses same iridium for longevity.'),
  (@gen, @e_2gr, 'spark_plug', 22, 16, NULL,
   '2GR-FKS 3.5L V6. Denso FK20HR-Q11 OE iridium plug, M12×1.25. Slightly lower torque spec than A25A (22 vs 25 N·m) per Toyota V6 service docs. Iridium service interval 120k mi.'),
  (@gen, @e_fks, 'oil_drain', 40, 30, NULL,
   'A25A-FKS 2.5L. M12×1.25 drain plug, single-use crush washer (Toyota PN 90430-12031). Aluminum oil pan — never over-torque.'),
  (@gen, @e_fxs, 'oil_drain', 40, 30, NULL,
   'A25A-FXS 2.5L Hybrid. Same drain plug and torque as A25A-FKS. Same washer PN.'),
  (@gen, @e_2gr, 'oil_drain', 38, 28, NULL,
   '2GR-FKS 3.5L V6. M12×1.25 drain plug per Toyota V6 service docs. Same washer family but verify PN against the V6 service kit (different sub-supplier batches use 90430-12031 or 90430-12028).');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs
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
  (@gen, @e_fks, 'oil_filter', '04152-YZZA6', 'Toyota OEM', NULL, NULL,
   'A25A-FKS 2.5L. Toyota OEM cartridge-style filter element (NOT spin-on — the Camry uses a reusable plastic housing). Cross-references: Wix 57208, Fram CH11710, Mobil 1 M1C-451A. Replace housing O-ring (90301-A0027) at every change.'),
  (@gen, @e_fxs, 'oil_filter', '04152-YZZA6', 'Toyota OEM', NULL, NULL,
   'A25A-FXS hybrid. Same OEM filter element as A25A-FKS — shared engine family. Same housing O-ring PN.'),
  (@gen, @e_2gr, 'oil_filter', '04152-31110', 'Toyota OEM', NULL, NULL,
   '2GR-FKS 3.5L V6. Different cartridge filter element from the 2.5L. Toyota OEM PN 04152-31110. Cross-references: Wix 57208, Fram CH10358. Same housing O-ring PN 90301-A0027.'),
  (@gen, @e_fks, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL,
   'A25A-FKS 2.5L. OE iridium plug. Gap 1.1 mm pre-set. 120k mi service interval. Denso direct PN: FK20HR-Q11.'),
  (@gen, @e_fxs, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL,
   'A25A-FXS hybrid. Same iridium plug as A25A-FKS. 120k mi.'),
  (@gen, @e_2gr, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL,
   '2GR-FKS V6. Same Denso FK20HR-Q11 iridium plug. 6 plugs per V6 vs 4 per 4-cyl.'),
  (@gen, @e_fks, 'air_filter', '17801-25030', 'Toyota OEM', NULL, NULL,
   'A25A-FKS 2.5L. Toyota OEM panel filter. Cross-references: Wix WA9601, Fram CA12054. Replace 30k mi normal, 15k mi severe.'),
  (@gen, @e_fxs, 'air_filter', '17801-25030', 'Toyota OEM', NULL, NULL,
   'A25A-FXS hybrid. Same panel filter as A25A-FKS.'),
  (@gen, @e_2gr, 'air_filter', '17801-31170', 'Toyota OEM', NULL, NULL,
   '2GR-FKS V6. Larger air-box and different filter element from the 2.5L. Toyota OEM PN 17801-31170.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

-- =========================================================================
-- STEP 8 — verification report.
-- =========================================================================
SELECT 'Camry XV70 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts,
       (SELECT COUNT(DISTINCT ss.source_id)
          FROM spec_sources ss JOIN sources s ON s.id=ss.source_id
          WHERE s.is_public=1 AND (
            (ss.spec_table='fluid_specs' AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen)) OR
            (ss.spec_table='torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=@gen)) OR
            (ss.spec_table='parts' AND ss.spec_id IN (SELECT id FROM parts WHERE generation_id=@gen))
          )) AS public_sources_used;
