-- Mazda 3 BP sedan (2020-present, generation_id=10) — full per-engine moat backfill.
--
-- Two wired engines (others NULL):
--   * PY-VPS  (id=15): 2.5L Skyactiv-G NA — Skyactiv-Drive 6AT
--   * PY-VPTS (id=14): 2.5L Skyactiv-G turbo (2.5T) — Skyactiv-Drive 6AT
--
-- Sources:
--   A id=29  Mazda 3 (BP) Service Manual
--   B id=608 Mazda/Subaru factory oil spec aggregator

SET NAMES utf8mb4;
SET @gen := 10; SET @e_25 := 15; SET @e_25t := 14;
SET @s_sm := 29; SET @s_amsoil := 608;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_25,  'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302', 7500, 12000, 12,
   '2.5L PY-VPS Skyactiv-G NA. With-filter capacity per Mazda 3 (BP) Service Manual: 4.4 US qt / 4.2 L. Mazda US recommends 0W-20; high-compression Skyactiv tolerates 5W-30 in hot climates.'),
  (@gen, @e_25t, 'engine_oil', 4.7, 5.0, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302', 7500, 12000, 12,
   '2.5T PY-VPTS Skyactiv-G turbo (250 Hp). With-filter capacity 5.0 US qt / 4.7 L per Mazda 3 Turbo SM. Turbo holds more oil in the turbo oil-feed gallery. Same filter PN as the NA — shared housing.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_25,  'coolant', 6.0, 6.3, 'Mazda Long-life Coolant FL22 (green)', 120000, 192000, 120,
   '2.5L PY-VPS. Total cooling system per Mazda 3 (BP) SM. Mazda FL22 (green) — DO NOT mix with universal antifreeze; FL22 is a Mazda-specific phosphate-OAT chemistry. Initial 120k mi (10 yr) / subsequent every 50k mi.'),
  (@gen, @e_25t, 'coolant', 6.2, 6.5, 'Mazda Long-life Coolant FL22 (green)', 120000, 192000, 120,
   '2.5T PY-VPTS. Slightly larger system due to turbo intercooler/coolant routing: 6.2 L total per Mazda 3 Turbo SM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_25,  'transmission_at', 3.3, 3.5, 'Mazda ATF FZ (PN 0000-77-110E-01)', 60000, 96000, NULL,
   'PY-VPS + Skyactiv-Drive 6AT. Drain-and-fill 3.3 L per Mazda 3 (BP) SM. Mazda ATF FZ only — engineered for the Skyactiv-Drive transmission; do NOT substitute Dexron/Mercon.'),
  (@gen, @e_25t, 'transmission_at', 3.3, 3.5, 'Mazda ATF FZ (PN 0000-77-110E-01)', 60000, 96000, NULL,
   'PY-VPTS turbo + Skyactiv-Drive 6AT. Same trans family and fluid as NA pairing.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_25,  'spark_plug', 18, 13, NULL, 'PY-VPS NA. NGK ILZKAR7B11 OE iridium, M12×1.25. 60k mi.'),
  (@gen, @e_25t, 'spark_plug', 18, 13, NULL, 'PY-VPTS turbo. NGK ILKAR7C11 OE high-thermal-range iridium for turbo.'),
  (@gen, @e_25,  'oil_drain', 35, 26, NULL, 'M14×1.5, single-use Mazda crush washer 9956-41-400.'),
  (@gen, @e_25t, 'oil_drain', 35, 26, NULL, 'Same drain plug.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_amsoil FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL,    'oil_filter', 'PE01-14-302', 'Mazda OEM', NULL, NULL, 'Shared spin-on filter housing across NA and turbo.'),
  (@gen, @e_25,  'spark_plug', 'PE5R-18-110', 'Mazda OEM (NGK ILZKAR7B11)', 0.80, NULL, 'NA iridium plug.'),
  (@gen, @e_25t, 'spark_plug', 'PYFA-18-110', 'Mazda OEM (NGK ILKAR7C11)', 0.80, NULL, 'Turbo iridium plug — higher heat range.'),
  (@gen, NULL,    'air_filter', 'PE07-13-3A0', 'Mazda OEM', NULL, NULL, 'Shared air-box panel filter.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Mazda 3 BP moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
