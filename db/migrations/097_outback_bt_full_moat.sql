-- Subaru Outback BT (2019-2024, generation_id=28) — full per-engine moat backfill.
--
-- Two engines (both Subaru boxer):
--   * FB25 (id=43): 2.5L NA — base 2.5i / Premium / Limited (Lineartronic CVT)
--   * FA24 (id=42): 2.4L turbo — XT, Wilderness, Onyx (Lineartronic CVT)
--
-- Sources:
--   A id=147 Subaru Outback (BT) Service Manual
--   B id=608 Mazda/Subaru factory oil spec aggregator

SET NAMES utf8mb4;
SET @gen := 28; SET @e_fb25 := 43; SET @e_fa24 := 42;
SET @s_sm := 147; SET @s_amsoil := 608;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'engine_oil', 5.1, 5.4, '0W-20', 'API SP / ILSAC GF-6 (Subaru Genuine 0W-20)', '15208AA170', 6000, 9600, 6,
   '2.5L FB25 boxer NA. With-filter capacity per Subaru Outback (BT) Service Manual: 5.4 US qt / 5.1 L. Subaru recommends 6,000 mi normal / 3,000 mi severe — shorter than Toyota/Honda because the boxer head design retains more oil at idle. Shared Subaru filter 15208AA170 across the FB family.'),
  (@gen, @e_fa24, 'engine_oil', 5.2, 5.5, '0W-20', 'API SP / ILSAC GF-6 (Subaru Genuine 0W-20; 5W-30 acceptable hot-climate)', '15208AA170', 6000, 9600, 6,
   '2.4L FA24 boxer turbo (XT, Wilderness). With-filter capacity 5.5 US qt / 5.2 L per Subaru Outback XT OM. Same filter as FB25. 5W-30 alternate acceptable in hot climates per Subaru TSB — the turbo runs hotter than the NA.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'coolant', 9.5, 10.0, 'Subaru Super Coolant Type 2 (blue OAT)', 60000, 96000, 60,
   '2.5L FB25. Total cooling system per Subaru Outback (BT) Service Manual. Subaru Super Coolant Type 2 (blue, OAT) — never mix with green IAT.'),
  (@gen, @e_fa24, 'coolant', 9.5, 10.0, 'Subaru Super Coolant Type 2 (blue OAT)', 60000, 96000, 60,
   '2.4L FA24 turbo. Same Outback chassis cooling system capacity as FB25 — the turbo intercooler is air-to-air on the FA24 in this application.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fb25, 'transmission_cvt', 12.0, 12.7, 'Subaru CVT-II High-Torque Lineartronic (HTM, 75W) PN K0425AA250', 60000, 96000, NULL,
   'FB25 + Lineartronic CVT. Total system fill 12.0 L per Subaru Outback SM. Subaru CVT-II HTM only — DO NOT substitute generic CVT fluid; HTM is the high-torque variant required for both 2.5 and 2.4T applications.'),
  (@gen, @e_fa24, 'transmission_cvt', 12.0, 12.7, 'Subaru CVT-II High-Torque Lineartronic (HTM, 75W) PN K0425AA250', 60000, 96000, NULL,
   'FA24 turbo + Lineartronic CVT. Same HTM fluid and capacity as FB25 pairing. Subaru recommends 60k mi service interval; severe duty 30k mi.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_fb25, 'spark_plug', 23, 17, NULL, 'FB25. NGK SILZKR8E8G iridium plug, M12×1.25. 60k mi service (Subaru shorter than Toyota/Honda due to boxer head).'),
  (@gen, @e_fa24, 'spark_plug', 23, 17, NULL, 'FA24 turbo. NGK ILKAR8E8G iridium plug (high heat range). 60k mi.'),
  (@gen, @e_fb25, 'oil_drain', 42, 31, NULL, 'FB25 drain plug — M16×1.5, single-use Subaru crush washer 803916010.'),
  (@gen, @e_fa24, 'oil_drain', 42, 31, NULL, 'FA24 same drain spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_amsoil FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL,     'oil_filter', '15208AA170', 'Subaru OEM', NULL, NULL, 'Shared spin-on filter across both Outback BT engines.'),
  (@gen, @e_fb25, 'spark_plug', '22401AA831', 'Subaru OEM (NGK SILZKR8E8G)', 0.75, NULL, 'FB25 iridium plug. 60k mi.'),
  (@gen, @e_fa24, 'spark_plug', '22401AA850', 'Subaru OEM (NGK ILKAR8E8G)', 0.75, NULL, 'FA24 turbo iridium plug — higher heat range than FB25 plug.'),
  (@gen, NULL,     'air_filter', '16546AA160', 'Subaru OEM', NULL, NULL, 'Shared air-box panel filter across both engines.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Outback BT moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
