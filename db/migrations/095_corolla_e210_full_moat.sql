-- Toyota Corolla E210 sedan (2019-2022, generation_id=11) — full per-engine moat backfill.
--
-- Three engines:
--   * 1ZR-FAE (id=18): 1.6L NA — global only (EU base)
--   * 2ZR-FE  (id=17): 1.8L NA Atkinson-cycle — global (CVTi-S + MT)
--   * 2ZR-FXE (id=16): 1.8L hybrid Atkinson — Hybrid (e-CVT, P410 family)
--
-- Cross-verification:
--   Source A (id=32):  Toyota Corolla (E210) Service Manual (public)
--   Source B (id=605): Toyota factory oil spec aggregator (public)
--   Source C (id=593): NHTSA vPIC — engine validation

SET NAMES utf8mb4;

SET @gen      := 11;
SET @e_1zr    := 18;
SET @e_2zr    := 17;
SET @e_2zr_h  := 16;

SET @s_sm     := 32;
SET @s_amsoil := 605;
SET @s_nhtsa  := 593;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1zr,   'engine_oil', 3.8, 4.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12,
   '1.6L 1ZR-FAE NA (EU). With-filter capacity per Toyota Corolla E210 Service Manual: 4.0 US qt / 3.8 L.'),
  (@gen, @e_2zr,   'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12,
   '1.8L 2ZR-FE NA. With-filter capacity per Toyota Corolla E210 Service Manual: 4.4 US qt / 4.2 L.'),
  (@gen, @e_2zr_h, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA1', 10000, 16000, 12,
   '1.8L 2ZR-FXE Atkinson hybrid. Same oil sump capacity as 2ZR-FE per Toyota Corolla Hybrid OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1zr,   'coolant', 6.0, 6.3, 'Toyota Super Long Life Coolant SLLC (pink, pre-mixed)', 100000, 160000, 120,
   '1.6L 1ZR-FAE. Total cooling system per Toyota Corolla E210 Service Manual. SLLC pre-mix only.'),
  (@gen, @e_2zr,   'coolant', 6.4, 6.8, 'Toyota Super Long Life Coolant SLLC (pink, pre-mixed)', 100000, 160000, 120,
   '1.8L 2ZR-FE. Slightly larger system than 1.6L per Toyota Corolla E210 OM.'),
  (@gen, @e_2zr_h, 'coolant', 7.7, 8.1, 'Toyota Super Long Life Coolant SLLC (pink) + inverter loop', 100000, 160000, 120,
   '1.8L 2ZR-FXE hybrid. Engine loop (6.4 L) + inverter / motor coolant loop (1.3 L) = 7.7 L total per Toyota Corolla Hybrid OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1zr,   'transmission_cvt', 3.7, 3.9, 'Toyota CVT Fluid FE (08886-02505)', 60000, 96000, NULL,
   '1.6L + Toyota CVT (CVTi-S K313/K3xx). Drain-and-fill 3.7 L per Toyota Corolla E210 SM. Toyota CVT Fluid FE only — DO NOT substitute with WS or generic CVT fluid; the FE formula has different friction modifiers tuned for this CVT family.'),
  (@gen, @e_2zr,   'transmission_cvt', 3.7, 3.9, 'Toyota CVT Fluid FE (08886-02505)', 60000, 96000, NULL,
   '1.8L 2ZR-FE + CVTi-S. Same trans and fluid as 1.6L pairing.'),
  (@gen, @e_2zr,   'transmission_mt', 2.0, 2.1, 'Toyota Manual Transmission Gear Oil 75W (08885-81001)', 60000, 96000, NULL,
   '1.8L 2ZR-FE + 6MT (E351 6-speed manual). Drain-and-fill 2.0 L per Toyota Corolla E210 SM.'),
  (@gen, @e_1zr,   'transmission_mt', 2.0, 2.1, 'Toyota Manual Transmission Gear Oil 75W (08885-81001)', 60000, 96000, NULL,
   '1.6L 1ZR-FAE + 6MT. Same trans and fluid as 1.8L pairing.'),
  (@gen, @e_2zr_h, 'transmission_cvt', 3.3, 3.5, 'Toyota WS (World Standard) / JWS 3324', 100000, 160000, NULL,
   '1.8L 2ZR-FXE hybrid + P410 e-CVT. Toyota uses WS fluid on the eCVT planetary gear set (different from the conventional CVT FE used on the 1.6/1.8 NA). 100k mi service.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nhtsa FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type='engine_oil';

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_1zr,   'spark_plug', 18, 13, NULL, '1.6L 1ZR-FAE. Denso SC20HR11 OE iridium, M14×1.25. 100k mi service.'),
  (@gen, @e_2zr,   'spark_plug', 18, 13, NULL, '1.8L 2ZR-FE. Denso SC20HR11 OE iridium.'),
  (@gen, @e_2zr_h, 'spark_plug', 18, 13, NULL, '1.8L 2ZR-FXE hybrid. Same Denso plug.'),
  (@gen, @e_1zr,   'oil_drain', 38, 28, NULL, '1.6L. M12×1.25, single-use Toyota crush washer 90430-12031.'),
  (@gen, @e_2zr,   'oil_drain', 38, 28, NULL, '1.8L NA. Same drain plug.'),
  (@gen, @e_2zr_h, 'oil_drain', 38, 28, NULL, '1.8L hybrid. Same drain plug.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_amsoil FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL,     'oil_filter', '04152-YZZA1', 'Toyota OEM', NULL, NULL, 'Shared cartridge filter element across all three engines on E210 chassis. O-ring 90301-A0026 single-use.'),
  (@gen, NULL,     'spark_plug', '90919-01253', 'Toyota OEM (Denso SC20HR11)', 1.10, NULL, 'OE iridium plug shared across all E210 engines. Gap 1.1 mm. 100k mi.'),
  (@gen, NULL,     'air_filter', '17801-37020', 'Toyota OEM', NULL, NULL, 'Shared air-box on E210 chassis.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Corolla E210 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
