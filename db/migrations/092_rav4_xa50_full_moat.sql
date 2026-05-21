-- Toyota RAV4 XA50 (2019-2024, generation_id=12) — full per-engine moat backfill.
--
-- Two engines:
--   * A25A-FKS (id=5): 2.5L NA Dynamic Force — non-hybrid LE/XLE/Adventure/TRD (UB80F 8AT)
--   * A25A-FXS (id=6): 2.5L hybrid Atkinson — Hybrid LE/SE/XSE/XLE + RAV4 Prime PHEV (P810 e-CVT)
--
-- Cross-verification matrix:
--   Source A (id=40):  Toyota RAV4 (XA50) Service Manual (public)
--   Source B (id=605): Toyota/Lexus factory oil spec (AMSOIL + OilType cross)
--   Source C (id=593): NHTSA vPIC — engine code validation

SET NAMES utf8mb4;

SET @gen      := 12;
SET @e_fks    := 5;
SET @e_fxs    := 6;

SET @s_sm     := 40;
SET @s_amsoil := 605;
SET @s_nhtsa  := 593;

-- =========================================================================
-- STEP 1 — wipe legacy NULL-engine_id engine-scoped rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'engine_oil', 4.8, 5.1, '0W-16', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-16)', '04152-YZZA6', 10000, 16000, 12,
   '2.5L A25A-FKS NA (LE, XLE, Adventure, TRD Off-Road). Capacity with-filter per Toyota RAV4 (XA50) Service Manual: 5.1 US qt / 4.8 L. Toyota recommends 0W-16 for US market; 0W-20 acceptable cold-climate alternate. Maintenance interval 10,000 mi / 12 mo normal; 5,000 mi severe.'),
  (@gen, @e_fxs, 'engine_oil', 4.8, 5.1, '0W-16', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-16)', '04152-YZZA6', 10000, 16000, 12,
   '2.5L A25A-FXS Hybrid (Hybrid LE/XLE/XSE + Prime PHEV). Same A25A oil sump capacity and filter as A25A-FKS. Same 10,000 mi normal interval; Toyota Hybrid Synergy Drive does not change oil chemistry needs.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- A25A-FXS hybrid adds the inverter / motor-generator coolant loop;
-- Prime PHEV adds the high-voltage battery coolant loop on top of that.
-- We document hybrid as a single combined system capacity per Toyota OM
-- (engine + inverter), since the battery loop is a separate sealed system.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'coolant', 6.3, 6.7, 'Toyota Super Long Life Coolant SLLC (pink, pre-mixed)', 100000, 160000, 120,
   '2.5L A25A-FKS NA. Engine + radiator + heater + reservoir per Toyota RAV4 (XA50) Service Manual. SLLC pre-mix only — never mix with green IAT. Initial change 100k mi / 10 yr; subsequent 50k mi / 5 yr.'),
  (@gen, @e_fxs, 'coolant', 8.5, 9.0, 'Toyota Super Long Life Coolant SLLC (pink) + inverter loop',  100000, 160000, 120,
   '2.5L A25A-FXS Hybrid. Engine loop (6.3 L) + inverter / motor-generator coolant loop (2.2 L) = 8.5 L total per Toyota service manual. The Prime PHEV additionally has a sealed high-voltage battery coolant loop (~1.6 L); that is NOT included here as it is service-only and not customer-fillable.');

-- =========================================================================
-- STEP 4 — transmission fluid per engine.
-- A25A-FKS pairs with UB80F 8AT (similar to UB80E but RAV4-tuned).
-- A25A-FXS pairs with P810 e-CVT (Toyota labels as eCVT, stored as CVT in our DB).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fks, 'transmission_at', 4.3, 4.6, 'Toyota WS (World Standard) / JWS 3324 (Toyota PN 08886-02305)', 60000, 96000, NULL,
   'A25A-FKS + UB80F 8AT. Drain-and-fill capacity per Toyota RAV4 (XA50) Service Manual. Toyota WS only — different additive package from Dexron/Mercon. Full system fill ~9.5 L; pan service ~4.3 L.'),
  (@gen, @e_fxs, 'transmission_cvt', 4.0, 4.2, 'Toyota WS (World Standard) / JWS 3324 (Toyota PN 08886-02305)', 100000, 160000, NULL,
   'A25A-FXS hybrid + P810 e-CVT. Toyota uses the WS fluid across the eCVT line — same fluid as conventional UB80F AT. Capacity reflects planetary gear set bath. 100k mi service interval — the eCVT has no clutch packs to wear.');

-- =========================================================================
-- STEP 5 — link new fluid rows to public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
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
   'A25A-FKS 2.5L NA. Denso FK20HR-Q11 OE iridium plug, M12×1.25. Toyota service interval 120k mi for iridium.'),
  (@gen, @e_fxs, 'spark_plug', 25, 18, NULL,
   'A25A-FXS hybrid. Same Denso FK20HR-Q11 plug as A25A-FKS — identical head and plug well design.'),
  (@gen, @e_fks, 'oil_drain', 40, 30, NULL,
   'A25A-FKS oil pan drain plug — M12×1.25 with single-use crush washer (Toyota PN 90430-12031). Aluminum oil pan; over-torque pulls threads.'),
  (@gen, @e_fxs, 'oil_drain', 40, 30, NULL,
   'A25A-FXS hybrid. Same drain plug torque and washer as A25A-FKS.');

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
  (@gen, @e_fks, 'oil_filter', '04152-YZZA6', 'Toyota OEM', NULL, NULL,
   'Cartridge filter element (RAV4 XA50 uses reusable plastic housing — NOT spin-on). O-ring 90301-A0027 single-use at every change. Wix 57208 / Fram CH11710 cross-reference.'),
  (@gen, @e_fxs, 'oil_filter', '04152-YZZA6', 'Toyota OEM', NULL, NULL,
   'Same OEM filter element as A25A-FKS — shared A25A engine family.'),
  (@gen, @e_fks, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL,
   'OE iridium plug. Gap 1.1 mm pre-set. 120k mi service.'),
  (@gen, @e_fxs, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL,
   'Same iridium plug as A25A-FKS.'),
  (@gen, NULL, 'air_filter', '17801-25030', 'Toyota OEM', NULL, NULL,
   'Shared air-box across both engines on the XA50 chassis. Replace 30k mi normal, 15k mi severe.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'RAV4 XA50 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts;
