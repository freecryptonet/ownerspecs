-- Lexus family batch: RX AL20, NX AZ20, ES XZ10, IS XE30.
-- All use Toyota engine families — high source-reuse with prior Toyota batches.

SET NAMES utf8mb4;
SET @s_amsoil := 605;
SET @s_nhtsa  := 593;

-- =========================================================================
-- LEXUS RX AL20 (gen 35) — 2 distinct engines (2GR-FKS NA, 2GR-FXS hybrid)
-- =========================================================================
SET @gen := 35; SET @s_sm := 185;
SET @e_2gr := 7; SET @e_2gr_h := 55; SET @e_2gr_h2 := 56;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-31110', 10000, 16000, 12, '2GR-FKS V6 NA (350L).'),
  (@gen, @e_2gr_h, 'engine_oil', 6.0, 6.3, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-31110', 10000, 16000, 12, '2GR-FXS V6 hybrid (450hL Atkinson).'),
  (@gen, @e_2gr_h2, 'engine_oil', 6.0, 6.3, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-31110', 10000, 16000, 12, '2GR-FXS hybrid variant (450h / 450h F Sport).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2gr, 'coolant', 8.8, 9.3, 'Toyota SLLC (pink)', 100000, 160000, 120, 'V6 NA.'),
  (@gen, @e_2gr_h, 'coolant', 10.0, 10.6, 'Toyota SLLC (pink) + inverter loop', 100000, 160000, 120, 'V6 hybrid — engine + inverter cooling.'),
  (@gen, @e_2gr_h2, 'coolant', 10.0, 10.6, 'Toyota SLLC (pink) + inverter loop', 100000, 160000, 120, 'V6 hybrid sibling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2gr, 'transmission_at', 6.6, 7.0, 'Toyota WS ATF', 60000, 96000, NULL, '350L + 8AT.'),
  (@gen, @e_2gr_h, 'transmission_cvt', 4.0, 4.2, 'Toyota WS ATF', 100000, 160000, NULL, '450hL hybrid + e-CVT.'),
  (@gen, @e_2gr_h2, 'transmission_cvt', 4.0, 4.2, 'Toyota WS ATF', 100000, 160000, NULL, '450h hybrid + e-CVT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- LEXUS NX AZ20 (gen 64) — 3 engines (A25A NA + hybrid + T24A turbo)
-- =========================================================================
SET @gen := 64; SET @s_sm := 378;
SET @e_a25fks := 5; SET @e_a25fxs := 6; SET @e_t24 := 77;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fks, 'engine_oil', 4.5, 4.8, '0W-16', 'API SP / ILSAC GF-6', '04152-YZZA6', 10000, 16000, 12, '2.5L A25A-FKS NA (NX 250).'),
  (@gen, @e_a25fxs, 'engine_oil', 4.5, 4.8, '0W-16', 'API SP / ILSAC GF-6', '04152-YZZA6', 10000, 16000, 12, '2.5L A25A-FXS hybrid (NX 350h / NX 450h+ PHEV).'),
  (@gen, @e_t24, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6', '04152-YZZA1', 10000, 16000, 12, '2.4L T24A-FTS turbo (NX 350).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fks, 'coolant', 7.5, 7.9, 'Toyota SLLC (pink)', 100000, 160000, 120, '2.5 NA.'),
  (@gen, @e_a25fxs, 'coolant', 9.0, 9.5, 'Toyota SLLC (pink) + inverter/HV loops', 100000, 160000, 120, 'Hybrid + PHEV — adds inverter + battery cooling.'),
  (@gen, @e_t24, 'coolant', 8.0, 8.5, 'Toyota SLLC (pink)', 100000, 160000, 120, 'T24A turbo.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fks, 'transmission_at', 6.6, 7.0, 'Toyota WS ATF', 60000, 96000, NULL, '2.5 NA + 8AT.'),
  (@gen, @e_a25fxs, 'transmission_cvt', 4.0, 4.2, 'Toyota WS ATF', 100000, 160000, NULL, '2.5 hybrid + e-CVT.'),
  (@gen, @e_t24, 'transmission_at', 6.6, 7.0, 'Toyota WS ATF', 60000, 96000, NULL, 'T24A turbo + 8AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- LEXUS ES XZ10 (gen 71) — 2 engines (A25A-FXS hybrid + 2GR-FKS V6)
-- =========================================================================
SET @gen := 71; SET @s_sm := 422;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fxs, 'engine_oil', 4.5, 4.8, '0W-16', 'API SP / ILSAC GF-6', '04152-YZZA6', 10000, 16000, 12, '2.5L A25A-FXS hybrid (ES 300h).'),
  (@gen, @e_2gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6', '04152-31110', 10000, 16000, 12, '3.5L 2GR-FKS V6 (ES 350).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fxs, 'coolant', 8.5, 9.0, 'Toyota SLLC (pink) + inverter loop', 100000, 160000, 120, 'Hybrid coolant + inverter.'),
  (@gen, @e_2gr, 'coolant', 8.0, 8.5, 'Toyota SLLC (pink)', 100000, 160000, 120, 'V6 NA.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_a25fxs, 'transmission_cvt', 4.0, 4.2, 'Toyota WS ATF', 100000, 160000, NULL, 'Hybrid e-CVT.'),
  (@gen, @e_2gr, 'transmission_at', 6.6, 7.0, 'Toyota WS ATF', 60000, 96000, NULL, 'V6 + 8AT Direct Shift.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt');

-- =========================================================================
-- LEXUS IS XE30 (gen 102) — 2 engines (8AR-FTS 2.0T + 2GR-FKS V6)
-- =========================================================================
SET @gen := 102;
SET @e_8ar := 173;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_8ar, 'engine_oil', 4.6, 4.9, '0W-20', 'API SP / ILSAC GF-6 (older variant on early MY)', '04152-YZZA1', 10000, 16000, 12, '8AR-FTS 2.0L turbo (IS 200t / 300t).'),
  (@gen, @e_2gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6', '04152-31110', 10000, 16000, 12, '2GR-FKS V6 (IS 300 AWD / IS 350).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_8ar, 'coolant', 6.8, 7.2, 'Toyota SLLC (pink)', 100000, 160000, 120, '2.0T cooling system.'),
  (@gen, @e_2gr, 'coolant', 8.0, 8.5, 'Toyota SLLC (pink)', 100000, 160000, 120, 'V6 — larger cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_8ar, 'transmission_at', 5.6, 5.9, 'Toyota WS ATF', 60000, 96000, NULL, '2.0T + 8AT.'),
  (@gen, @e_2gr, 'transmission_at', 8.3, 8.8, 'Toyota WS ATF', 60000, 96000, NULL, 'V6 + 8AT (AS80E).');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nhtsa FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

SELECT 'Lexus batch (RX + NX + ES + IS) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (35,64,71,102) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
