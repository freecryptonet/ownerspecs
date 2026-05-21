-- Honda Civic FE sedan (2022-2025, generation_id=50) — full per-engine moat backfill.
--
-- Four engine cross-references (3 wired + 1 Si NULL):
--   * K20C2 (id=2):  2.0L NA i-VTEC — LX (CVT)
--   * L15B7 (id=1):  1.5L turbo VTEC — Sport/EX/Touring (CVT)
--   * LFC1 (id=83):  2.0L i-MMD Atkinson hybrid — Hybrid e:HEV (e-CVT)
--   * NULL: Si 1.5T 6MT (200 Hp) — trim.engine_id not yet wired
--
-- Cross-verification:
--   Source A (id=326): Honda Civic XI (FE) Owner's Manual (public)
--   Source B (id=595): Honda Civic Sedan 2022 Owner's Manual via manualslib (public)
--   Source C (id=606): Honda factory oil spec aggregator (public)

SET NAMES utf8mb4;

SET @gen      := 50;
SET @e_k20    := 2;   -- 2.0 NA
SET @e_l15    := 1;   -- 1.5 turbo
SET @e_lfc1   := 83;  -- 2.0 Atkinson hybrid

SET @s_om     := 326;
SET @s_om2    := 595;
SET @s_amsoil := 606;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20,  'engine_oil', 3.5, 3.7, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 12000, 12,
   '2.0L K20C2 NA (LX). With-filter capacity per Honda Civic FE OM Specifications: 3.7 US qt / 3.5 L. Honda Maintenance Minder 7,500 mi normal / 5,000 mi severe.'),
  (@gen, @e_l15,  'engine_oil', 3.4, 3.6, '0W-20', 'API SP / ILSAC GF-6A', '15400-RTA-A01', 7500, 12000, 12,
   '1.5L L15B7 turbo (Sport, EX, Touring). With-filter capacity per Honda Civic FE OM: 3.6 US qt / 3.4 L. Honda continues to monitor 1.5T fuel-dilution behaviour — if dipstick reads above MAX or smells of fuel in cold-climate short-trip use, change at 3,500-5,000 mi severe.'),
  (@gen, @e_lfc1, 'engine_oil', 3.5, 3.7, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 12000, 12,
   '2.0L LFC1 Atkinson hybrid (e:HEV). With-filter capacity 3.7 US qt / 3.5 L per Honda Civic FE Hybrid OM. Same Honda K-family filter as K20C2.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20,  'coolant', 5.4, 5.7, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60,
   '2.0L K20C2. Engine + radiator + heater + reservoir capacity per Honda Civic FE OM. Type 2 (blue) pre-mix only — Honda changed from green to blue Type 2 across the 2022+ lineup. Initial 60k mi; subsequent 30k mi.'),
  (@gen, @e_l15,  'coolant', 5.4, 5.7, 'Honda Type 2 Long Life Antifreeze/Coolant (blue, pre-mixed)', 60000, 96000, 60,
   '1.5L L15B7 turbo. Same chassis cooling capacity as K20C2 on the FE platform.'),
  (@gen, @e_lfc1, 'coolant', 7.0, 7.4, 'Honda Type 2 Long Life Antifreeze/Coolant (blue) + inverter loop', 60000, 96000, 60,
   '2.0L LFC1 hybrid. Engine loop (5.4 L) + inverter / motor coolant loop (~1.6 L) = 7.0 L total per Honda Civic FE Hybrid OM. Separate fill procedure for inverter circuit.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20,  'transmission_cvt',  3.3, 3.5, 'Honda HCF-2 (08200-HCF-2)', 60000, 96000, NULL,
   '2.0L K20C2 + Honda CVT (M4VA family). Drain-and-fill capacity per Honda Civic FE OM. HCF-2 only — no DW-1, no generic CVT.'),
  (@gen, @e_l15,  'transmission_cvt',  3.3, 3.5, 'Honda HCF-2 (08200-HCF-2)', 60000, 96000, NULL,
   '1.5L L15B7 + Honda CVT (M4VA). Same fluid spec and capacity as K20C2 pairing.'),
  (@gen, @e_lfc1, 'transmission_ecvt', 2.8, 3.0, 'Honda ATF DW-1', 60000, 96000, NULL,
   '2.0L LFC1 hybrid + i-MMD e-CVT. Uses ATF DW-1 (NOT HCF-2) — the e-CVT is a planetary gear set with a lock-up clutch, not a CVT belt/cone. Smaller fluid capacity.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om2 FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_ecvt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type='engine_oil';

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_k20,  'spark_plug', 18, 13, NULL, '2.0L K20C2. NGK ILZKR7B11 iridium plug, M12×1.25. 100k mi service.'),
  (@gen, @e_l15,  'spark_plug', 18, 13, NULL, '1.5L L15B7 turbo. NGK DILZKAR7C11S iridium plug. 60k mi severe / 100k mi normal — turbo plugs hotter.'),
  (@gen, @e_lfc1, 'spark_plug', 18, 13, NULL, '2.0L LFC1 hybrid. Same iridium plug family as K20C2.'),
  (@gen, @e_k20,  'oil_drain', 39, 29, NULL, 'M14×1.5 drain plug, single-use Honda crush washer 94109-14000.'),
  (@gen, @e_l15,  'oil_drain', 39, 29, NULL, 'Same drain plug spec.'),
  (@gen, @e_lfc1, 'oil_drain', 39, 29, NULL, 'Same drain plug spec.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om2 FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, @e_k20,  'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL, 'Honda K-family spin-on filter (orange band).'),
  (@gen, @e_l15,  'oil_filter', '15400-RTA-A01', 'Honda OEM', NULL, NULL, 'Honda 1.5T filter (white band) — different housing than K-family.'),
  (@gen, @e_lfc1, 'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL, 'Honda K-family filter (LFC1 hybrid shares K-block oil filter mount).'),
  (@gen, @e_k20,  'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL, 'OE iridium plug. Gap 1.1 mm. 100k mi.'),
  (@gen, @e_l15,  'spark_plug', '12290-5BA-A01', 'Honda OEM (NGK DILZKAR7C11S)', 1.10, NULL, '1.5T OE iridium plug — different from K20 plug. Do NOT substitute.'),
  (@gen, @e_lfc1, 'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL, 'LFC1 hybrid uses K20-family iridium plug.'),
  (@gen, NULL,    'air_filter', '17220-64A-A00', 'Honda OEM', NULL, NULL, 'Shared air-box panel across all engines on FE chassis.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om2 FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

SELECT 'Civic FE moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
