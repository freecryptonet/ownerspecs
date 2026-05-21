-- Batch backfill: Mustang S550 + Corolla E170 + RAV4 XA40 + 4Runner N280.
--
-- Toyota engines (recycle from prior migrations):
--   * 1NR-FE (id=87): 1.33L NA
--   * 1ZR-FAE (id=18): 1.6L Valvematic NA
--   * 1ND-TV (id=86): 1.4 D-4D diesel
--   * 2AR-FE (id=95): 2.5L NA
--   * 3ZR-FAE (id=98): 2.0L NA
--   * 2AD-FTV (id=97) / 2AD-FHV (id=96): 2.2 D-4D diesel variants
--   * 1GR-FE (id=135): 4.0L V6
--   * 2TR-FE (id=136): 2.7L 4-cyl
-- Ford:
--   * EcoBoost (id=26): 2.3L turbo
--   * Coyote (id=25): 5.0L V8

SET NAMES utf8mb4;
SET @s_amsoil := 605;     -- Toyota aggregator
SET @s_ford   := 602;     -- Ford aggregator

-- =========================================================================
-- MUSTANG S550 (gen 19) — 2 engines
-- =========================================================================
SET @gen := 19; SET @s_sm := 68;
SET @e_eco := 26; SET @e_coy := 25;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_eco, 'engine_oil', 5.7, 6.0, '5W-30', 'Ford WSS-M2C945-A (Motorcraft synthetic blend)', 'FL-500S', 10000, 16000, 12,
   '2.3L EcoBoost turbo. With-filter capacity per Ford Mustang (S550) Service Manual.'),
  (@gen, @e_coy, 'engine_oil', 8.5, 9.0, '5W-30', 'Ford WSS-M2C931-B (Motorcraft full synthetic)', 'FL-500S', 7500, 12000, 12,
   '5.0L Coyote V8. With-filter capacity per Ford Mustang GT OM: 9.0 US qt / 8.5 L. Coyote requires WSS-M2C931-B (full synthetic), tighter spec than the EcoBoost.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_eco, 'coolant', 9.5, 10.0, 'Motorcraft Orange (pre-2018) / Yellow (2018+)', 120000, 192000, 120,
   'S550 chassis cooling system per Ford Service Manual.'),
  (@gen, @e_coy, 'coolant', 9.5, 10.0, 'Motorcraft Orange (pre-2018) / Yellow (2018+)', 120000, 192000, 120,
   'Coyote V8 same chassis cooling capacity.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_eco, 'transmission_at', 11.3, 11.9, 'Motorcraft MERCON LV (XT-10-QLVC)', 150000, 240000, NULL,
   '6R80/10R80 6/10-speed AT. Ford lists fill-for-life with severe-duty 60k mi.'),
  (@gen, @e_coy, 'transmission_at', 11.3, 11.9, 'Motorcraft MERCON LV (XT-10-QLVC)', 150000, 240000, NULL,
   'Same AT family on GT trims.'),
  (@gen, @e_eco, 'transmission_mt', 2.8, 3.0, 'Motorcraft Full Synthetic MT (XT-M5-QS)', 60000, 96000, NULL,
   'MT82 6-speed manual.'),
  (@gen, @e_coy, 'transmission_mt', 2.8, 3.0, 'Motorcraft Full Synthetic MT (XT-M5-QS)', 60000, 96000, NULL,
   'GT also offered with MT82 6-speed.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_ford FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt');

-- =========================================================================
-- COROLLA E170 (gen 52) — 4 engines
-- =========================================================================
SET @gen := 52; SET @s_sm := 304; SET @s_om := 328;
SET @e_1nd := 86; SET @e_1nr := 87; SET @e_1zr := 18;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1nd, 'engine_oil', 3.8, 4.0, '0W-30', 'ACEA C2 (low-SAPS diesel)', '04152-YZZA1', 6000, 9600, 12,
   '1.4 D-4D 1ND-TV diesel (EU). Low-SAPS required for DPF.'),
  (@gen, @e_1nr, 'engine_oil', 3.4, 3.6, '0W-20', 'API SN / ILSAC GF-5', '04152-YZZA1', 7500, 12000, 12,
   '1.33L 1NR-FE NA (EU).'),
  (@gen, @e_1zr, 'engine_oil', 4.2, 4.4, '0W-20', 'API SN / ILSAC GF-5', '04152-YZZA1', 7500, 12000, 12,
   '1.6L 1ZR-FAE Valvematic NA.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1nd, 'coolant', 5.5, 5.8, 'Toyota SLLC (pink)', 100000, 160000, 120, '1.4 D-4D — same chassis cooling.'),
  (@gen, @e_1nr, 'coolant', 5.5, 5.8, 'Toyota SLLC (pink)', 100000, 160000, 120, '1.33L NA.'),
  (@gen, @e_1zr, 'coolant', 5.5, 5.8, 'Toyota SLLC (pink)', 100000, 160000, 120, '1.6L Valvematic.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1nd, 'transmission_mt', 2.0, 2.1, 'Toyota MTF 75W-85 GL-4', 60000, 96000, NULL, 'Diesel + 6MT.'),
  (@gen, @e_1nr, 'transmission_mt', 1.9, 2.0, 'Toyota MTF 75W-85 GL-4', 60000, 96000, NULL, '1.33L + 6MT.'),
  (@gen, @e_1zr, 'transmission_mt', 1.9, 2.0, 'Toyota MTF 75W-85 GL-4', 60000, 96000, NULL, '1.6L + 6MT.'),
  (@gen, @e_1zr, 'transmission_cvt', 4.0, 4.2, 'Toyota CVT Fluid FE (08886-02505)', 60000, 96000, NULL, '1.6L + Toyota CVTi-S.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

-- =========================================================================
-- RAV4 XA40 (gen 56) — 4 engines
-- =========================================================================
SET @gen := 56; SET @s_sm := 332; SET @s_om := 364;
SET @e_2ar := 95; SET @e_3zr := 98; SET @e_2ad_v := 97; SET @e_2ad_h := 96;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2ar, 'engine_oil', 4.4, 4.6, '0W-20', 'API SN / ILSAC GF-5', '04152-YZZA1', 10000, 16000, 12,
   '2.5L 2AR-FE NA (US primary). With-filter per Toyota RAV4 XA40 OM.'),
  (@gen, @e_3zr, 'engine_oil', 4.2, 4.4, '0W-20', 'API SN / ILSAC GF-5', '04152-YZZA1', 10000, 16000, 12,
   '2.0L 3ZR-FAE Valvematic NA (EU/Asia).'),
  (@gen, @e_2ad_v, 'engine_oil', 5.8, 6.1, '5W-30', 'ACEA C3 / API CK-4 (low-SAPS)', '04152-YZZA3', 6000, 9600, 12,
   '2.2 D-4D 2AD-FTV diesel (EU MT).'),
  (@gen, @e_2ad_h, 'engine_oil', 5.8, 6.1, '5W-30', 'ACEA C3 / API CK-4 (low-SAPS)', '04152-YZZA3', 6000, 9600, 12,
   '2.2 D-CAT 2AD-FHV diesel (EU AT).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2ar, 'coolant', 8.4, 8.9, 'Toyota SLLC (pink)', 100000, 160000, 120, '2.5L NA.'),
  (@gen, @e_3zr, 'coolant', 8.4, 8.9, 'Toyota SLLC (pink)', 100000, 160000, 120, '2.0L NA.'),
  (@gen, @e_2ad_v, 'coolant', 8.4, 8.9, 'Toyota SLLC (pink)', 100000, 160000, 120, '2.2 diesel — same chassis cooling.'),
  (@gen, @e_2ad_h, 'coolant', 8.4, 8.9, 'Toyota SLLC (pink)', 100000, 160000, 120, 'D-CAT diesel — same chassis cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_2ar, 'transmission_at', 7.4, 7.8, 'Toyota Genuine ATF WS', 60000, 96000, NULL, '2.5L + 6AT (US trims).'),
  (@gen, @e_3zr, 'transmission_cvt', 5.7, 6.0, 'Toyota CVT Fluid FE (08886-02505)', 60000, 96000, NULL, '2.0L + Multidrive S CVT.'),
  (@gen, @e_2ad_h, 'transmission_at', 7.4, 7.8, 'Toyota Genuine ATF WS', 60000, 96000, NULL, '2.2 D-CAT + 6AT.'),
  (@gen, @e_2ad_v, 'transmission_mt', 2.2, 2.3, 'Toyota MTF 75W-85 GL-4', 60000, 96000, NULL, '2.2 D-4D + 6MT.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

-- =========================================================================
-- 4RUNNER N280 (gen 83) — 2 engines
-- =========================================================================
SET @gen := 83; SET @s_sm := 497; SET @s_om := 505;
SET @e_1gr := 135; SET @e_2tr := 136;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1gr, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA6', 10000, 16000, 12,
   '4.0L 1GR-FE V6 (US primary, 270 Hp). With-filter capacity per Toyota 4Runner OM.'),
  (@gen, @e_2tr, 'engine_oil', 4.7, 5.0, '0W-20', 'API SP / ILSAC GF-6 (Toyota Genuine 0W-20)', '04152-YZZA6', 10000, 16000, 12,
   '2.7L 2TR-FE 4-cyl (entry, 157 Hp).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1gr, 'coolant', 12.7, 13.4, 'Toyota Super Long Life Coolant (pink)', 100000, 160000, 120, 'V6 — body-on-frame cooling system is large.'),
  (@gen, @e_2tr, 'coolant', 12.7, 13.4, 'Toyota Super Long Life Coolant (pink)', 100000, 160000, 120, '2.7 4-cyl — same chassis cooling.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_1gr, 'transmission_at', 8.3, 8.8, 'Toyota WS ATF', 60000, 96000, NULL, 'V6 + A750F 5AT. Full fill ~11 L; pan service ~8.3 L.'),
  (@gen, @e_2tr, 'transmission_at', 8.3, 8.8, 'Toyota WS ATF', 60000, 96000, NULL, '2.7 + 5AT — same trans family.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

SELECT 'Toyota+Ford batch (Mustang + Corolla E170 + RAV4 XA40 + 4Runner) complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id IN (19,52,56,83) AND engine_id IS NOT NULL) AS per_engine_fluids_total;
