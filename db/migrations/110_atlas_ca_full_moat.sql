-- VW Atlas / Teramont (gen 72, 2018-2024) per-engine moat backfill.
-- Sold as Atlas in US/CA, Teramont in EU/CN. HaynesPro indexes under Teramont.
-- Sourced from HaynesPro WorkshopData (typeIds: 2.0 TSI CXDA t_619022299,
-- 3.6 VR6 CDVC t_619022300). The DB's DCGA engine_id (122) corresponds to
-- the US-spec production code; the underlying physical engine is the same
-- EA888 Gen 3 2.0 TSI also coded CXDA in non-US markets.
-- Cross-verified with VW Group factory oil spec (source 609). Public
-- citations: VW Atlas (CA) Service Manual (source 431) + VW Group aggregator (609).
--
-- Engines (2):
--   CDVC (eid 121) — 3.6 VR6 FSI 276 Hp NA (EA390, 4MOTION, Aisin 09P 8AT)
--   DCGA (eid 122) — 2.0 TSI 235 Hp turbo (EA888 Gen 3, FWD + 4MOTION, 09P 8AT)

SET NAMES utf8mb4;

SET @gen      := 72;
SET @e_cdvc   := 121;
SET @e_dcga   := 122;
SET @s_sm     := 431;
SET @s_vwg    := 609;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','oil_filter_housing')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','oil_filter_housing');

-- =========================================================================
-- engine_oil
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cdvc, 'engine_oil', 5.5, 5.8, '0W-30', 'VW 504 00 (LongLife III)', 10000, 16000, 12,
   '3.6 VR6 FSI EA390 (276 Hp). With-filter sump capacity per VW Atlas service data. US schedule is fixed-interval 10,000 mi / 12 mo. Alternative oils: VW 502 00 5W-40 acceptable on pre-2020 cars; VW 504 00 5W-30 acceptable. Renew the drain plug at every change; oil filter housing drain plug torques to 10 Nm separately (renew O-ring).'),
  (@gen, @e_dcga, 'engine_oil', 5.7, 6.0, '5W-40', 'VW 508 88 (post-2021) / VW 502 00 (pre-2020)', 10000, 16000, 12,
   '2.0 TSI EA888 Gen 3 (235 Hp, sold as DCGA in US-market production codes, same physical engine as CXDA elsewhere). With-filter sump capacity per VW Atlas service data. 2021+ production calls for the heavier 5W-40 VW 508 88 spec (HTHS ≥ 3.5); pre-2020 cars accept VW 502 00 5W-40 or VW 504 00 0W-30/5W-30 on EN 228 fuel. Renew the sealing washer at every change.');

-- =========================================================================
-- coolant
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cdvc, 'coolant', 20.0, 21.1, 'TL-VW 774L (G12 EVO, pink)', NULL, NULL, NULL,
   '3.6 VR6 — 20.0 L total cooling system on the larger 3-row SUV chassis with V6 cooling demand. VW spec is lifetime fill (G12 EVO); replace if contaminated or after major repair.'),
  (@gen, @e_dcga, 'coolant', 10.0, 10.6, 'TL-VW 774L (G12 EVO, pink)', NULL, NULL, NULL,
   '2.0 TSI — 10.0 L (smaller 4-cyl cooling loop). Lifetime fill per VW spec.');

-- =========================================================================
-- transmission_at — Aisin TF-80SC / VW 09P 8-speed torque-converter AT
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_cdvc, 'transmission_at', 7.0, 7.4, 'VW G 055 540 A2 (Aisin TF-80SC ATF)', 60000, 96000, NULL,
   '3.6 V6 + VW 09P 8-speed AT (Aisin TF-80SC family). Initial fill 7.0 L; VW classifies this as a filled-for-life unit but field practice is a 60k-mi service-drain change. Overflow-pipe + level-plug fill procedure (NOT a dipstick) — needs lift access.'),
  (@gen, @e_dcga, 'transmission_at', 7.0, 7.4, 'VW G 055 540 A2 (Aisin TF-80SC ATF)', 60000, 96000, NULL,
   '2.0 TSI + VW 09P 8-speed AT. Same gearbox + fluid as 3.6; capacity matches.');

-- =========================================================================
-- gen-wide brake fluid + AC refrigerant
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'VW 501 14 (preferred) — DOT 4 alternative', 'Brake reservoir capacity. VW recommends a 2-year change interval on hygroscopic DOT 4-class fluids.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R134a 600–700 g or R1234yf 550–650 g (depending on compressor + market)', 'A/C refrigerant charge varies by Sanden compressor variant (3AA / 3CN family) and market. US/CA Atlas uses R134a 600 g most commonly; refer to under-hood A/C label for the exact charge.');

-- =========================================================================
-- torque_specs — oil drain plug (both engines: 30 Nm) + oil filter housing (10 Nm on V6)
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_cdvc, 'oil_drain', 30, 22, NULL,
   '3.6 V6 oil pan drain plug. Renew the drain plug at every change.'),
  (@gen, @e_dcga, 'oil_drain', 30, 22, NULL,
   '2.0 TSI oil pan drain plug. Renew the sealing washer at every change.'),
  (@gen, @e_cdvc, 'oil_filter_housing', 10, 7, NULL,
   '3.6 V6 oil filter housing drain plug — separate from sump drain. Renew the O-ring; lubricate the O-ring with clean engine oil before assembly.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vwg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain','oil_filter_housing');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_vwg FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain','oil_filter_housing');

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
DELETE fs FROM fluid_specs fs
WHERE fs.generation_id = @gen
  AND fs.fluid_type IN ('engine_oil','coolant')
  AND fs.viscosity IS NULL AND fs.spec_standard IS NULL
  AND EXISTS (
    SELECT 1 FROM fluid_specs fr
    WHERE fr.generation_id = fs.generation_id
      AND fr.fluid_type   = fs.fluid_type
      AND fr.id != fs.id
      AND fr.spec_standard IS NOT NULL
  );

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Atlas CA moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
