-- Mazda CX-5 KF (2017-2024, generation_id=58) — full per-engine moat backfill.
--
-- Three engines:
--   * PY-Y8  (id=102): 2.5L Skyactiv-G NA (early-MY EU 188 Hp tune)
--   * PYZ8/PYZC (id=101): 2.5L Skyactiv-G NA (US/global 188-194 Hp tune)
--   * PY-VPTS (id=14): 2.5L Skyactiv-G turbo (Signature/Turbo 228-250 Hp)
--
-- Note: PY-Y8 and PYZ8 are essentially the same Skyactiv-G 2.5L block with
-- minor tune differences (EU vs US emission calibration). Same fluid specs.
--
-- Sources:
--   A id=344 Mazda CX-5 Service Manual
--   B id=366 Mazda CX-5 II (KF) Owner's Manual
--   C id=608 Mazda/Subaru factory oil spec aggregator

SET NAMES utf8mb4;
SET @gen := 58; SET @e_py8 := 102; SET @e_pyz8 := 101; SET @e_25t := 14;
SET @s_sm := 344; SET @s_om := 366; SET @s_amsoil := 608;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py8,  'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12,
   '2.5L PY-Y8 Skyactiv-G NA (EU tune). With-filter capacity per Mazda CX-5 II (KF) Service Manual: 4.8 US qt / 4.5 L.'),
  (@gen, @e_pyz8, 'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12,
   '2.5L PYZ8/PYZC Skyactiv-G NA (US/global tune). Same oil capacity and filter as PY-Y8 — same 2.5L block, different emissions tune.'),
  (@gen, @e_25t,  'engine_oil', 4.7, 5.0, '0W-20', 'API SP / ILSAC GF-6 (Mazda 0W-20 Genuine)', 'PE01-14-302A', 7500, 12000, 12,
   '2.5T PY-VPTS Skyactiv-G turbo. With-filter capacity 5.0 US qt / 4.7 L per Mazda CX-5 Turbo SM. Turbo holds slightly more oil.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py8,  'coolant', 7.4, 7.8, 'Mazda Long-life Coolant FL22 (green)', 120000, 192000, 120,
   '2.5L PY-Y8 NA. Total cooling system per Mazda CX-5 (KF) SM. FL22 green — phosphate-OAT, Mazda-specific.'),
  (@gen, @e_pyz8, 'coolant', 7.4, 7.8, 'Mazda Long-life Coolant FL22 (green)', 120000, 192000, 120,
   '2.5L PYZ8/PYZC NA. Same chassis cooling system as PY-Y8.'),
  (@gen, @e_25t,  'coolant', 7.6, 8.0, 'Mazda Long-life Coolant FL22 (green)', 120000, 192000, 120,
   '2.5T PY-VPTS turbo. Slightly larger system (turbo intercooler routing): 7.6 L total per Mazda CX-5 Turbo SM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_py8,  'transmission_at', 6.6, 7.0, 'Mazda ATF FZ', 60000, 96000, NULL,
   '2.5L NA + Skyactiv-Drive 6AT (SUV-tuned, larger torque converter than Mazda 3). Drain-and-fill 6.6 L per Mazda CX-5 SM.'),
  (@gen, @e_pyz8, 'transmission_at', 6.6, 7.0, 'Mazda ATF FZ', 60000, 96000, NULL,
   '2.5L NA + Skyactiv-Drive 6AT. Same as PY-Y8 pairing.'),
  (@gen, @e_25t,  'transmission_at', 6.6, 7.0, 'Mazda ATF FZ', 60000, 96000, NULL,
   '2.5T + Skyactiv-Drive 6AT. Same trans family and fluid spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_py8,  'spark_plug', 18, 13, NULL, '2.5L NA (EU). NGK ILZKAR7B11 OE iridium, M12×1.25. 60k mi.'),
  (@gen, @e_pyz8, 'spark_plug', 18, 13, NULL, '2.5L NA (US). Same plug.'),
  (@gen, @e_25t,  'spark_plug', 18, 13, NULL, '2.5T. NGK ILKAR7C11 high-heat-range plug.'),
  (@gen, @e_py8,  'oil_drain', 35, 26, NULL, 'M14×1.5, single-use Mazda crush washer 9956-41-400.'),
  (@gen, @e_pyz8, 'oil_drain', 35, 26, NULL, 'Same drain spec.'),
  (@gen, @e_25t,  'oil_drain', 35, 26, NULL, 'Same drain spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL,    'oil_filter', 'PE01-14-302A', 'Mazda OEM', NULL, NULL, 'Shared spin-on filter across all CX-5 KF engines.'),
  (@gen, @e_py8,  'spark_plug', 'PE5R-18-110', 'Mazda OEM (NGK ILZKAR7B11)', 0.80, NULL, '2.5L NA iridium plug.'),
  (@gen, @e_pyz8, 'spark_plug', 'PE5R-18-110', 'Mazda OEM (NGK ILZKAR7B11)', 0.80, NULL, 'Same plug as PY-Y8.'),
  (@gen, @e_25t,  'spark_plug', 'PYFA-18-110', 'Mazda OEM (NGK ILKAR7C11)', 0.80, NULL, 'Turbo high-heat plug.'),
  (@gen, NULL,    'air_filter', 'PE07-13-3A0', 'Mazda OEM', NULL, NULL, 'Shared air-box panel filter.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'CX-5 KF moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
