-- Volvo XC60 II (gen 31, 2017-2024) per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData via scrapers/haynespro.ts on 2026-05-21.
-- typeIds used (all 5 engines share Volvo Drive-E 2.0L architecture):
--   B4204T48 t_619022832 — T8 Recharge 405 Hp PHEV
--   B4204T35 t_619024864 — T8 Twin Engine 415 Hp PHEV
--   B4204T34 t_619013095 — T8 Recharge 390 Hp PHEV
--   B4204T27 t_319005433 — T6 320 Hp (turbo+supercharged petrol)
--   B4204T46 t_619033874 — T6 Recharge 340 Hp MHEV
--
-- Public citations: Volvo XC60 (246) Service Manual (source 168) + Volvo
-- aggregator (source 613). HaynesPro stays is_public=0.
--
-- Notable cross-source corrections vs. training-data lore:
--   * Oil drain plug torque is 38 Nm (NOT the 30 Nm VW Group default).
--   * Coolant is Volvo G11 (yellow IAT-OAT hybrid), not G12 EVO / G13.
--   * Engine oil spec is "Volvo RBS0-2AE" (Volvo's proprietary low-SAPS
--     particulate-filter-compatible 0W-20 spec), not a generic ACEA C5.
--   * Brake fluid preference is DOT 5.1, DOT 4 LV acceptable alt.

SET NAMES utf8mb4;

SET @gen      := 31;
SET @e_t8_405 := 47;   -- B4204T48 T8 Recharge 405 Hp PHEV
SET @e_t8_415 := 48;   -- B4204T35 T8 Twin Engine 415 Hp PHEV
SET @e_t8_390 := 49;   -- B4204T34 T8 Recharge 390 Hp PHEV
SET @e_t6_320 := 51;   -- B4204T27 T6 320 Hp
SET @e_t6_340 := 52;   -- B4204T46 T6 Recharge 340 Hp MHEV
SET @s_sm     := 168;  -- Volvo XC60 II Service Manual
SET @s_volvo  := 613;  -- Volvo aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','haldex')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','haldex');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- engine_oil — all 5 engines share Drive-E 2.0L block: 5.6 L / 0W-20 / RBS0-2AE
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_t8_405, 'engine_oil', 5.6, 5.9, '0W-20', 'Volvo RBS0-2AE (ACEA C5 / API SP)', 12000, 19000, 12,
   'B4204T48 T8 Recharge 405 Hp PHEV — 2.0L Drive-E 4-cyl turbocharged+supercharged with e-motor. With-filter sump capacity per Volvo service data.'),
  (@gen, @e_t8_415, 'engine_oil', 5.6, 5.9, '0W-20', 'Volvo RBS0-2AE (ACEA C5 / API SP)', 12000, 19000, 12,
   'B4204T35 T8 Twin Engine 415 Hp PHEV — same Drive-E 2.0L architecture, different hybrid tune. With-filter capacity 5.6 L.'),
  (@gen, @e_t8_390, 'engine_oil', 5.6, 5.9, '0W-20', 'Volvo RBS0-2AE (ACEA C5 / API SP)', 12000, 19000, 12,
   'B4204T34 T8 Recharge 390 Hp PHEV — early T8 variant. With-filter capacity 5.6 L.'),
  (@gen, @e_t6_320, 'engine_oil', 5.6, 5.9, '0W-20', 'Volvo RBS0-2AE (ACEA C5 / API SP)', 12000, 19000, 12,
   'B4204T27 T6 320 Hp — 2.0L Drive-E turbocharged+supercharged petrol (no hybrid). With-filter capacity 5.6 L.'),
  (@gen, @e_t6_340, 'engine_oil', 5.6, 5.9, '0W-20', 'Volvo RBS0-2AE (ACEA C5 / API SP)', 12000, 19000, 12,
   'B4204T46 T6 Recharge 340 Hp Mild Hybrid (48 V MHEV). Same Drive-E block with 48 V belt-integrated starter-generator. With-filter capacity 5.6 L.');

-- =========================================================================
-- coolant — Volvo G11 (yellow IAT-OAT hybrid), Drive-E circuit. HaynesPro
-- published 8.3 L on the T6 320 Hp variant; other variants share the same
-- engine cooling-system architecture. PHEVs have an additional HV-battery
-- cooling loop not separately broken out here.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_t8_405, 'coolant', 8.3, 8.8, 'Volvo G11 (yellow, de-ionised water 50/50)', NULL, NULL, NULL,
   'T8 PHEV — Drive-E engine cooling loop. The HV-battery + e-motor inverter has a separate low-temperature cooling circuit (additional fluid, not summed here).'),
  (@gen, @e_t8_415, 'coolant', 8.3, 8.8, 'Volvo G11 (yellow, de-ionised water 50/50)', NULL, NULL, NULL, 'T8 Twin Engine PHEV — same engine cooling loop volume as other T8 variants.'),
  (@gen, @e_t8_390, 'coolant', 8.3, 8.8, 'Volvo G11 (yellow, de-ionised water 50/50)', NULL, NULL, NULL, 'T8 Recharge 390 Hp PHEV.'),
  (@gen, @e_t6_320, 'coolant', 8.3, 8.8, 'Volvo G11 (yellow, de-ionised water 50/50)', NULL, NULL, NULL, 'T6 320 Hp — non-hybrid, engine-only cooling loop.'),
  (@gen, @e_t6_340, 'coolant', 8.3, 8.8, 'Volvo G11 (yellow, de-ionised water 50/50)', NULL, NULL, NULL, 'T6 Recharge 340 Hp MHEV — 48 V starter-generator integrated into engine cooling loop.');

-- =========================================================================
-- transmission_at — Aisin AWF8F35 8-speed AT, gen-wide on the XC60 II.
-- HaynesPro lubricants did not publish the AT fluid capacity in the
-- accessible section. Spec is well-known as Volvo proprietary ATF (AISIN AWF
-- type); capacity_l left NULL to avoid fabrication.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_t8_405, 'transmission_at', NULL, NULL, 'Volvo ATF (Aisin AWF8F35 8-speed)', 'T8 + Aisin AWF8F35 8-speed. Capacity not surfaced in HaynesPro accessible data; consult service manual.'),
  (@gen, @e_t8_415, 'transmission_at', NULL, NULL, 'Volvo ATF (Aisin AWF8F35 8-speed)', 'T8 Twin Engine + Aisin AWF8F35.'),
  (@gen, @e_t8_390, 'transmission_at', NULL, NULL, 'Volvo ATF (Aisin AWF8F35 8-speed)', 'T8 Recharge 390 + Aisin AWF8F35.'),
  (@gen, @e_t6_320, 'transmission_at', NULL, NULL, 'Volvo ATF (Aisin AWF8F35 8-speed)', 'T6 320 + Aisin AWF8F35.'),
  (@gen, @e_t6_340, 'transmission_at', NULL, NULL, 'Volvo ATF (Aisin AWF8F35 8-speed)', 'T6 MHEV + Aisin AWF8F35.');

-- =========================================================================
-- gen-wide: brake fluid + rear diff + Haldex coupling
-- All XC60 II in our DB are AWD (T6 + T8 trims) — rear diff + Haldex apply
-- gen-wide. T4/T5 FWD trims aren't represented in our engines list.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 5.1 (preferred) — DOT 4 LV acceptable', 'Brake reservoir capacity. DOT 5.1 preferred for the high-modulation City Safety + Pilot Assist braking systems. 2-year change interval per Volvo.'),
  (@gen, NULL, 'differential_rear', 1.0, 1.06, 'Volvo 31259380 (SAE 75W-90 synthetic)', 'AWD rear differential — single Volvo OE fluid PN. Fitted on all T6 and T8 trims.'),
  (@gen, NULL, 'haldex', NULL, NULL, 'Volvo 31367940 (Haldex Gen 5 hydraulic fluid)', 'Haldex Gen 5 AWD coupling — Volvo OE fluid PN. Service interval typically 60,000 km; capacity is small (~0.6–0.7 L), not published in accessible HaynesPro.');

-- =========================================================================
-- per-engine torque_specs — oil drain plug 38 Nm across all 5 engines
-- (Volvo Drive-E spec; different from VW Group's 30 Nm).
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_t8_405, 'oil_drain', 38, 28, NULL, 'T8 Recharge 405 — Drive-E oil pan drain plug, 38 Nm.'),
  (@gen, @e_t8_415, 'oil_drain', 38, 28, NULL, 'T8 Twin Engine 415 — 38 Nm drain plug.'),
  (@gen, @e_t8_390, 'oil_drain', 38, 28, NULL, 'T8 Recharge 390 — 38 Nm drain plug.'),
  (@gen, @e_t6_320, 'oil_drain', 38, 28, NULL, 'T6 320 — 38 Nm drain plug.'),
  (@gen, @e_t6_340, 'oil_drain', 38, 28, NULL, 'T6 Recharge MHEV — 38 Nm drain plug.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','differential_rear','haldex');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_volvo FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','differential_rear','haldex');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_volvo FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');

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

SELECT 'Volvo XC60 II moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
