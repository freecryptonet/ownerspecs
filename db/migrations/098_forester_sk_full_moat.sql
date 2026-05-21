-- Subaru Forester SK (2018-2021, generation_id=49) — full per-engine moat backfill.
--
-- Two engines:
--   * FB25 (id=43): 2.5L NA boxer — base 2.5 trims (Lineartronic CVT)
--   * FB20 (id=82): 2.0L Atkinson hybrid (e-Boxer) — 2.0 hybrid trim (Lineartronic + MGU)
--
-- Sources:
--   A id=284 Subaru Forester Service Manual
--   B id=291 Subaru Forester (SK) Owner's Manual
--   C id=608 Mazda/Subaru factory oil spec aggregator

SET NAMES utf8mb4;
SET @gen := 49; SET @e_fb25 := 43; SET @e_fb20 := 82;
SET @s_sm := 284; SET @s_om := 291; SET @s_amsoil := 608;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'engine_oil', 4.8, 5.1, '0W-20', 'API SP / ILSAC GF-6A', '15208AA170', 6000, 9600, 6,
   '2.5L FB25 boxer NA. With-filter capacity per Subaru Forester (SK) Service Manual: 5.1 US qt / 4.8 L. Note: slightly smaller than Outback BT (5.1 L) because the Forester SK uses a smaller oil pan.'),
  (@gen, @e_fb20, 'engine_oil', 4.4, 4.6, '0W-20', 'API SP / ILSAC GF-6A', '15208AA170', 6000, 9600, 6,
   '2.0L FB20 Atkinson hybrid (e-Boxer). With-filter capacity per Subaru Forester Hybrid OM: 4.6 US qt / 4.4 L. Same Subaru FB-family filter.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'coolant', 6.2, 6.5, 'Subaru Super Coolant Type 2 (blue, pre-mixed)', 60000, 96000, 60,
   '2.5L FB25. Total cooling system per Subaru Forester (SK) Service Manual. Subaru Super Coolant Type 2 (blue OAT).'),
  (@gen, @e_fb20, 'coolant', 7.7, 8.1, 'Subaru Super Coolant Type 2 (blue) + MGU coolant loop', 60000, 96000, 60,
   '2.0L FB20 e-Boxer. Engine loop (6.2 L) + motor-generator-unit cooling (~1.5 L) = 7.7 L total per Subaru Forester Hybrid OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'transmission_cvt', 11.7, 12.4, 'Subaru High-Torque CVTF II Lineartronic', 60000, 96000, NULL,
   'FB25 + Lineartronic CVT. Drain-and-fill capacity 11.7 L per Subaru Forester SM.'),
  (@gen, @e_fb20, 'transmission_cvt', 11.7, 12.4, 'Subaru High-Torque CVTF II Lineartronic', 60000, 96000, NULL,
   'FB20 e-Boxer + Lineartronic CVT. Same HTM fluid spec and capacity as FB25 pairing — the MGU sits between engine and CVT but does not change CVT fluid volume.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_fb25, 'spark_plug', 23, 17, NULL, 'FB25 NA. NGK SILZKR8E8G iridium plug, M12×1.25. 60k mi service.'),
  (@gen, @e_fb20, 'spark_plug', 23, 17, NULL, 'FB20 hybrid. Same Subaru FB-family plug spec.'),
  (@gen, @e_fb25, 'oil_drain', 42, 31, NULL, 'M16×1.5 drain plug, single-use Subaru crush washer 803916010.'),
  (@gen, @e_fb20, 'oil_drain', 42, 31, NULL, 'FB20 hybrid same drain plug spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL,    'oil_filter', '15208AA170', 'Subaru OEM', NULL, NULL, 'Shared FB-family spin-on filter.'),
  (@gen, @e_fb25, 'spark_plug', '22401AA831', 'Subaru OEM (NGK SILZKR8E8G)', 0.75, NULL, 'FB25 iridium plug.'),
  (@gen, @e_fb20, 'spark_plug', '22401AA831', 'Subaru OEM (NGK SILZKR8E8G)', 0.75, NULL, 'FB20 hybrid same plug.'),
  (@gen, NULL,    'air_filter', '16546AA160', 'Subaru OEM', NULL, NULL, 'Shared air-box panel filter.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Forester SK moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
