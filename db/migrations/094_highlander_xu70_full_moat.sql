-- Toyota Highlander XU70 (2020-2025, generation_id=41) — full per-engine moat backfill.
--
-- Three engines:
--   * A25A-FXS (id=6):  2.5L Atkinson hybrid — Hybrid trims (P810 e-CVT)
--   * T24A-FTS (id=67): 2.4L turbo Dynamic Force — 2023+ replaced V6 (UB80F 8AT)
--   * 2GR-FKS  (id=7):  3.5L V6 — 2020-2022 only (UB80F 8AT)
--
-- Cross-verification matrix:
--   Source A (id=233): Toyota Highlander (XU70) Owner's Manual (public)
--   Source B (id=226): Toyota Highlander Service Manual (public)
--   Source C (id=605): Toyota/Lexus factory oil spec aggregator (public)

SET NAMES utf8mb4;

SET @gen      := 41;
SET @e_fxs    := 6;
SET @e_2gr    := 7;
SET @e_t24    := 67;

SET @s_om     := 233;
SET @s_sm     := 226;
SET @s_amsoil := 605;

-- =========================================================================
-- STEP 1 — wipe legacy NULL-engine_id engine-scoped rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_ecvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_ecvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fxs, 'engine_oil', 4.5, 4.8, '0W-16', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-16)', '04152-YZZA6', 10000, 16000, 12,
   '2.5L A25A-FXS Hybrid. Capacity with-filter per Toyota Highlander (XU70) OM: 4.8 US qt / 4.5 L. Toyota US recommends 0W-16; 0W-20 alternate for cold-climate markets. 10,000 mi normal interval, 5,000 mi severe.'),
  (@gen, @e_2gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-31110', 10000, 16000, 12,
   '3.5L 2GR-FKS V6 (2020-2022). Capacity with-filter per Toyota Highlander V6 OM: 6.0 US qt / 5.7 L. V6 cannot run 0W-16 — 0W-20 minimum due to higher thermal load. Different filter from the 2.5L (04152-31110 vs 04152-YZZA6).'),
  (@gen, @e_t24, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12,
   '2.4L T24A-FTS turbo (2023+). Capacity with-filter per Toyota Highlander 2.4T OM: 6.0 US qt / 5.7 L. The turbo Dynamic Force engine uses a higher-capacity cartridge filter (04152-YZZA1) than the NA A25A. 0W-20 only — do NOT use 0W-16 on the turbo.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fxs, 'coolant', 8.7, 9.2, 'Toyota Super Long Life Coolant SLLC (pink) + inverter loop', 100000, 160000, 120,
   '2.5L A25A-FXS Hybrid. Engine loop (6.3 L) + inverter/motor coolant loop (2.4 L) = 8.7 L total per Toyota Highlander Hybrid OM. Separate fill procedure for inverter circuit.'),
  (@gen, @e_2gr, 'coolant', 9.1, 9.6, 'Toyota Super Long Life Coolant SLLC (pink, pre-mixed)', 100000, 160000, 120,
   '3.5L 2GR-FKS V6 (2020-2022). Total cooling system capacity per Toyota Highlander V6 OM: 9.1 L. SLLC pre-mix only.'),
  (@gen, @e_t24, 'coolant', 8.9, 9.4, 'Toyota Super Long Life Coolant SLLC (pink, pre-mixed)', 100000, 160000, 120,
   '2.4L T24A-FTS turbo (2023+). System capacity includes the turbo coolant loop (intercooler + turbo housing): 8.9 L total per Toyota Highlander 2.4T OM.');

-- =========================================================================
-- STEP 4 — transmission fluid per engine.
-- A25A-FXS pairs with P810 e-CVT; 2GR-FKS and T24A-FTS share UB80F 8AT.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fxs, 'transmission_cvt', 4.2, 4.4, 'Toyota WS / JWS 3324 (Toyota Genuine ATF WS)', 100000, 160000, NULL,
   'A25A-FXS hybrid + P810 e-CVT. Drain-and-fill capacity 4.2 L per Toyota Highlander Hybrid OM. Toyota WS only. 100k mi service interval — eCVT lacks clutch packs.'),
  (@gen, @e_2gr, 'transmission_at', 6.6, 7.0, 'Toyota WS / JWS 3324 (Toyota Genuine ATF WS)', 60000, 96000, NULL,
   '3.5L 2GR-FKS V6 + UB80F 8AT. Drain-and-fill 6.6 L per Toyota Highlander V6 OM. Full system fill ~10 L.'),
  (@gen, @e_t24, 'transmission_at', 6.6, 7.0, 'Toyota WS / JWS 3324 (Toyota Genuine ATF WS)', 60000, 96000, NULL,
   '2.4L T24A-FTS turbo + UB80F 8AT (Direct Shift). Same trans box and fluid as V6 pairing; just paired with the 2.4T post-2023.');

-- =========================================================================
-- STEP 5 — link new fluid rows to public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type='engine_oil';

-- =========================================================================
-- STEP 6 — per-engine torque_specs.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_fxs, 'spark_plug', 25, 18, NULL, 'A25A-FXS hybrid. Denso FK20HR-Q11 OE iridium, M12×1.25.'),
  (@gen, @e_2gr, 'spark_plug', 22, 16, NULL, '2GR-FKS V6. Denso FK20HR-Q11 OE iridium. Slightly lower torque (22 vs 25 N·m) per Toyota V6 service docs.'),
  (@gen, @e_t24, 'spark_plug', 25, 18, NULL, 'T24A-FTS turbo. Denso ILKAR8L11 OE high-thermal-range iridium for turbo application. Do not substitute with non-iridium.'),
  (@gen, @e_fxs, 'oil_drain', 40, 30, NULL, 'A25A-FXS hybrid. M12×1.25, single-use washer (Toyota 90430-12031).'),
  (@gen, @e_2gr, 'oil_drain', 38, 28, NULL, '2GR-FKS V6. M12×1.25, single-use washer.'),
  (@gen, @e_t24, 'oil_drain', 40, 30, NULL, 'T24A-FTS turbo. M12×1.25, single-use washer.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

-- =========================================================================
-- STEP 7 — per-engine parts.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, @e_fxs, 'oil_filter', '04152-YZZA6', 'Toyota OEM', NULL, NULL, 'Cartridge filter element; O-ring 90301-A0027 single-use at every change.'),
  (@gen, @e_2gr, 'oil_filter', '04152-31110', 'Toyota OEM', NULL, NULL, 'V6 cartridge filter element. Different from 2.5L.'),
  (@gen, @e_t24, 'oil_filter', '04152-YZZA1', 'Toyota OEM', NULL, NULL, 'T24A turbo cartridge filter element. Higher capacity than NA A25A.'),
  (@gen, @e_fxs, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL, 'A25A-FXS hybrid iridium plug.'),
  (@gen, @e_2gr, 'spark_plug', '90919-01290', 'Toyota OEM (Denso FK20HR-Q11)', 1.10, NULL, '2GR-FKS V6 — same plug. 6 cylinders × 1 plug each.'),
  (@gen, @e_t24, 'spark_plug', '90919-01275', 'Toyota OEM (Denso ILKAR8L11)', 0.70, NULL, 'T24A-FTS turbo iridium plug — different heat range and tighter gap than the NA A25A plug.'),
  (@gen, @e_fxs, 'air_filter', '17801-25030', 'Toyota OEM', NULL, NULL, 'Hybrid air-box panel filter.'),
  (@gen, @e_2gr, 'air_filter', '17801-31170', 'Toyota OEM', NULL, NULL, 'V6 air-box panel filter — different from 2.5L.'),
  (@gen, @e_t24, 'air_filter', '17801-25030', 'Toyota OEM', NULL, NULL, 'T24A turbo shares air-box with the 2.5L hybrid on the XU70 chassis post-2023.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Highlander XU70 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts;
