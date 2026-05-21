-- Korean batch (Hyundai Tucson NX4, Kia Sportage NQ5, Hyundai Elantra CN7,
-- Kia Sorento MQ4) — full per-engine moat backfill in a single file.
--
-- Hyundai/Kia engines used across these four gens:
--   * G4FT (id=29): 1.6 T-GDI HEV (Smartstream hybrid)
--   * G4FP (id=27): 1.6 T-GDI (Smartstream)
--   * G4KN (id=28): 2.5 Smartstream NA
--   * G4NS (id=76): 2.0 Smartstream NA
--   * G4KH (id=75): 2.0 Theta II turbo (Elantra N)
--   * G4KP (id=127): 2.5 T-GDI (Sorento)
--   * D4HD (id=33): 2.0 CRDi diesel (Sportage EU)
--   * D4HE (id=128): 2.2 CRDi diesel (Sorento EU)
--
-- Source C used across all: id=607 Hyundai/Kia/Genesis factory oil spec aggregator
-- Plus per-gen Service Manuals as primary.

SET NAMES utf8mb4;
SET @s_amsoil := 607;

-- =========================================================================
-- TUCSON NX4 (gen 20)
-- =========================================================================
SET @gen := 20; SET @s_sm := 77;
SET @e_g4ft := 29; SET @e_g4fp := 27; SET @e_g4kn := 28;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Hyundai Premium Long-Life)', '26300-35505', 7500, 12000, 12,
   '1.6 T-GDI G4FT HEV. With-filter capacity per Hyundai Tucson (NX4) Service Manual: 4.8 US qt / 4.5 L.'),
  (@gen, @e_g4fp, 'engine_oil', 4.5, 4.8, '0W-30', 'API SP / ACEA C2', '26300-35505', 7500, 12000, 12,
   '1.6 T-GDI G4FP (non-hybrid PHEV variant). Same capacity, Hyundai recommends 0W-30 for the heavier-duty PHEV tune.'),
  (@gen, @e_g4kn, 'engine_oil', 4.6, 4.9, '0W-20', 'API SP / ILSAC GF-6', '26300-35505', 7500, 12000, 12,
   '2.5 Smartstream G4KN NA. 4.6 L with filter per Hyundai Tucson 2.5 SM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'coolant', 7.3, 7.7, 'Hyundai Long Life Coolant (pink OAT, pre-mixed) + inverter loop', 120000, 192000, 120,
   '1.6 T-GDI HEV. Engine loop + inverter loop included in OM capacity.'),
  (@gen, @e_g4fp, 'coolant', 7.3, 7.7, 'Hyundai Long Life Coolant (pink OAT, pre-mixed)', 120000, 192000, 120,
   'PHEV adds high-voltage battery cooling loop — sealed system, not customer-fillable.'),
  (@gen, @e_g4kn, 'coolant', 7.3, 7.7, 'Hyundai Long Life Coolant (pink OAT, pre-mixed)', 120000, 192000, 120,
   '2.5 NA G4KN. Same chassis cooling system as turbo variants.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV-RR / SK ATF SP-IV (PN 00232-19052)', 60000, 96000, NULL,
   'G4FT + 6AT HEV. Drain-and-fill 8.0 L; full fill larger.'),
  (@gen, @e_g4fp, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV-RR / SK ATF SP-IV', 60000, 96000, NULL,
   'G4FP + Hyundai 8AT.'),
  (@gen, @e_g4kn, 'transmission_at', 8.0, 8.5, 'Hyundai SP-IV-RR / SK ATF SP-IV', 60000, 96000, NULL,
   'G4KN 2.5 + Hyundai 8AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- SPORTAGE NQ5 (gen 22)
-- =========================================================================
SET @gen := 22; SET @s_sm := 97;
SET @e_d4hd := 33;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'engine_oil', 4.5, 4.8, '0W-20', 'API SP / ILSAC GF-6 (Kia Premium Long-Life)', '26300-35505', 7500, 12000, 12,
   '1.6 T-GDI HEV. Same engine and oil spec as Tucson NX4 sibling.'),
  (@gen, @e_d4hd, 'engine_oil', 6.0, 6.3, '5W-30', 'ACEA C2 / API CK-4 (low-SAPS diesel)', '26350-2A500', 7500, 12000, 12,
   '2.0 CRDi D4HD diesel (EU). With-filter capacity per Kia Sportage NQ5 EU SM. Low-SAPS required for DPF compatibility.'),
  (@gen, @e_g4kn, 'engine_oil', 4.6, 4.9, '0W-20', 'API SP / ILSAC GF-6 (Kia Premium Long-Life)', '26300-35505', 7500, 12000, 12,
   '2.5 Smartstream GDI G4KN NA.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'coolant', 7.5, 7.9, 'Kia/Hyundai LLC (pink OAT, pre-mixed) + inverter loop', 120000, 192000, 120, '1.6 T-GDI HEV.'),
  (@gen, @e_d4hd, 'coolant', 8.0, 8.5, 'Kia/Hyundai LLC (pink OAT, pre-mixed)', 120000, 192000, 120, '2.0 CRDi diesel — slightly larger cooling system for diesel thermal load.'),
  (@gen, @e_g4kn, 'coolant', 7.5, 7.9, 'Kia/Hyundai LLC (pink OAT, pre-mixed)', 120000, 192000, 120, '2.5 GDI NA.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ft, 'transmission_at', 8.0, 8.5, 'Hyundai/Kia SP-IV-RR (PN 00232-19052)', 60000, 96000, NULL, 'HEV + 6AT.'),
  (@gen, @e_d4hd, 'transmission_at', 8.0, 8.5, 'Hyundai/Kia SP-IV-RR', 60000, 96000, NULL, 'Diesel + 8AT.'),
  (@gen, @e_g4kn, 'transmission_at', 8.0, 8.5, 'Hyundai/Kia SP-IV-RR', 60000, 96000, NULL, '2.5 NA + 8AT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

-- =========================================================================
-- ELANTRA CN7 (gen 45)
-- =========================================================================
SET @gen := 45; SET @s_sm := 256; SET @s_om := 287;
SET @e_g4ns := 76; SET @e_g4kh := 75;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_dct','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_dct','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ns, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6 (or 5W-20)', '26300-35504', 7500, 12000, 12,
   '2.0L G4NS Smartstream NA. With-filter capacity per Hyundai Elantra (CN7) Service Manual: 4.4 US qt / 4.2 L.'),
  (@gen, @e_g4kh, 'engine_oil', 4.8, 5.1, '5W-30', 'API SP / Hyundai N-spec', '26300-35504', 6000, 9600, 12,
   '2.0L Theta II turbo G4KH (Elantra N, 276 Hp). 5W-30 required for N tune. 6,000 mi normal interval — N model service is more aggressive.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ns, 'coolant', 6.5, 6.9, 'Hyundai Long-Life Coolant (blue, pre-mixed)', 120000, 192000, 120, '2.0L NA.'),
  (@gen, @e_g4kh, 'coolant', 7.0, 7.4, 'Hyundai Long-Life Coolant (blue, pre-mixed)', 120000, 192000, 120, 'N turbo — adds turbo coolant loop.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4ns, 'transmission_cvt', 5.0, 5.3, 'Hyundai SP-CVT-1', 60000, 96000, NULL, '2.0 NA + Hyundai CVT (IVT).'),
  (@gen, @e_g4ns, 'transmission_mt', 1.9, 2.0, 'Hyundai MTF 75W-85 GL-4', 60000, 96000, NULL, '2.0 NA + 6MT.'),
  (@gen, @e_g4kh, 'transmission_dct', 2.5, 2.6, 'Hyundai DCTF (PN 04500-00100)', 40000, 64000, NULL, 'Elantra N + 8DCT. Hyundai DCTF only.'),
  (@gen, @e_g4kh, 'transmission_mt', 2.2, 2.3, 'Hyundai MTF 75W-85 GL-4', 60000, 96000, NULL, 'Elantra N + 6MT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_dct','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_dct','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

-- =========================================================================
-- SORENTO MQ4 (gen 79)
-- =========================================================================
SET @gen := 79; SET @s_sm := 475; SET @s_om := 501;
SET @e_d4he := 128; SET @e_g4kp := 127;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4kn, 'engine_oil', 4.6, 4.9, '0W-20', 'API SP / ILSAC GF-6', '26300-35505', 7500, 12000, 12, '2.5 GDI G4KN NA.'),
  (@gen, @e_d4he, 'engine_oil', 7.7, 8.1, '5W-30', 'ACEA C3 / API CK-4 (low-SAPS diesel)', '26350-2A500', 7500, 12000, 12, '2.2 CRDi D4HE diesel — larger oil capacity, low-SAPS for DPF.'),
  (@gen, @e_g4kp, 'engine_oil', 5.5, 5.8, '5W-30', 'API SP / Hyundai N-spec', '26300-2J000', 6000, 9600, 12, '2.5 T-GDI G4KP. 5W-30 required for high-output turbo.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4kn, 'coolant', 9.5, 10.0, 'Hyundai LLC (blue, pre-mixed)', 120000, 192000, 120, '2.5 GDI NA.'),
  (@gen, @e_d4he, 'coolant', 10.5, 11.1, 'Hyundai LLC (blue, pre-mixed)', 120000, 192000, 120, '2.2 CRDi diesel — larger cooling system.'),
  (@gen, @e_g4kp, 'coolant', 9.8, 10.4, 'Hyundai LLC (blue, pre-mixed)', 120000, 192000, 120, '2.5T turbo.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_g4kn, 'transmission_at', 7.5, 7.9, 'Hyundai SP-IV ATF', 60000, 96000, NULL, '2.5 NA + 8AT.'),
  (@gen, @e_d4he, 'transmission_dct', 2.5, 2.6, 'Hyundai DCTF (PN 04500-00100)', 40000, 64000, NULL, '2.2 CRDi + 8DCT-AWD.'),
  (@gen, @e_g4kp, 'transmission_dct', 2.5, 2.6, 'Hyundai DCTF (PN 04500-00100)', 40000, 64000, NULL, '2.5T + 8DCT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_dct');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

SELECT 'Korean batch (Tucson + Sportage + Elantra + Sorento) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (20,22,45,79) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
