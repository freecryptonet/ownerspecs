-- Land Rover Range Rover Sport (L461) gen 117, 2022- — per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData via scrapers/haynespro.ts on 2026-05-21.
-- typeIds used:
--   Ingenium 3.0 I6 MHEV (P400) t_619108746
--   Ingenium PHEV (P440e)       t_619107340
--
-- Public citations: a newly-inserted JLR Range Rover Sport (L461) Service
-- Manual source + a newly-inserted Land Rover factory oil spec aggregator
-- source. No prior LR sources existed in the DB.
--
-- Notable findings:
--   * Engine oil capacity is 9.44 L with filter — large 3.0 I6 dry-sump
--     layout shared across the JLR Ingenium MHEV + PHEV variants.
--   * Oil spec is the JLR-proprietary STJLR.03.5006 (0W-20). Many off-the-
--     shelf 0W-20 oils don't carry this approval — use Castrol EDGE
--     Professional V or similar STJLR.03.5006-licensed product.
--   * Coolant is STJLR.651.5003 (Havoline XLC family, OAT chemistry); the
--     PHEV has a separate 2.75 L HV-battery cooling loop with the same
--     Havoline XLC-PG (propylene glycol) variant.
--   * AWD drivetrain shares transfer box + front/rear differentials across
--     all L461 variants — recorded gen-wide.

SET NAMES utf8mb4;

-- Create new sources if missing.
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'JLR Range Rover Sport (L461) Service Manual', 1, NOW(),
          'Jaguar Land Rover OEM service data for L461 (2022+). Primary public citation for L461 moat data.');
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Land Rover factory oil spec (Castrol EDGE Professional V + JLR TOPIx + LRCat cross-verification)', 1, NOW(),
          'Aggregator citation covering JLR STJLR.03.5006 / STJLR.651.5003 / BOT 750B + Castrol HALBOT 311 from cross-verified retail catalogues.');

SET @gen      := 117;
SET @e_mhev   := 174;  -- Ingenium 3.0 I6 MHEV
SET @e_phev   := 175;  -- Ingenium PHEV
SET @s_sm     := (SELECT id FROM sources WHERE citation = 'JLR Range Rover Sport (L461) Service Manual' LIMIT 1);
SET @s_lr_agg := (SELECT id FROM sources WHERE citation LIKE 'Land Rover factory oil spec%' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','differential_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','differential_drain');

-- =========================================================================
-- engine_oil — both engines share the JLR Ingenium 3.0 I6 block + sump
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_mhev, 'engine_oil', 9.44, 9.97, '0W-20', 'STJLR.03.5006 (JLR proprietary)', 16000, 26000, 24,
   'Ingenium 3.0 I6 MHEV (P400) — JLR 3.0L straight-six with 48 V mild-hybrid integrated starter-generator. With-filter sump capacity per JLR L461 service data. STJLR.03.5006 is JLR''s proprietary 0W-20 spec — off-the-shelf 0W-20 without this approval is NOT acceptable. Castrol EDGE Professional V is the OE supplier.'),
  (@gen, @e_phev, 'engine_oil', 9.44, 9.97, '0W-20', 'STJLR.03.5006 (JLR proprietary)', 16000, 26000, 24,
   'Ingenium 3.0 I6 + PHEV (P440e and later P460e/P510e/P550e variants). Same Ingenium block + sump as the MHEV; identical oil spec and capacity.');

-- =========================================================================
-- coolant — JLR STJLR.651.5003. HaynesPro published 2.75 L on the PHEV;
-- the MHEV row left the capacity NULL. We record the same on both engines.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_mhev, 'coolant', 2.75, 2.91, 'STJLR.651.5003 (Havoline XLC OAT family)', NULL, NULL, NULL,
   'Ingenium 3.0 I6 MHEV — primary engine cooling loop. JLR lists this as a lifetime fill. STJLR.651.5003 is the orange OAT-family coolant; never substitute with green silicate IAT.'),
  (@gen, @e_phev, 'coolant', 2.75, 2.91, 'STJLR.651.5003 (Havoline XLC OAT family)', NULL, NULL, NULL,
   'Ingenium 3.0 I6 + PHEV — primary engine cooling loop (the HV-battery + e-motor inverter has its own separate 2.75 L Havoline XLC-PG propylene-glycol loop).');

-- =========================================================================
-- gen-wide: brake fluid + transfer box + front & rear differential
-- All L461 variants share the same AWD drivetrain hardware + Castrol fluids.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 4 LV (Low Viscosity)', 'Brake reservoir capacity. DOT 4 LV required for the high-modulation electronic brake-boost system. JLR schedule: 2-year change interval.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 1.25, 1.32, 'Castrol HALBOT 311 (JLR-approved transfer-box fluid)', 'L461 two-speed transfer box — full-time AWD with low range. JLR lists this as a filled-for-life unit; field practice on heavy-duty/off-road use is a fluid change at major service intervals.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', NULL, NULL, '75W-90 Castrol BOT 750B', 'Front differential — Castrol BOT 750B 75W-90 synthetic. JLR drain plug torque: 30 Nm. Capacity not surfaced in HaynesPro accessible section.'),
  (@gen, NULL, 'differential_rear', 0.87, 0.92, '75W-90 Castrol BOT 750B (open diff) / Castrol BOT 720 (eLSD, 1.27 L)', 'Rear differential. Open differential 0.87 L; electronic limited-slip differential (eLSD, optional / standard on some variants) takes 1.27 L of Castrol BOT 720. Both use 75W-90 viscosity.');

-- =========================================================================
-- torque_specs — front diff drain plug (only torque value HaynesPro surfaced)
-- Engine oil drain plug torque was not in the accessible HaynesPro section.
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'differential_drain', 30, 22, NULL,
   'Front differential drain plug — 30 Nm per JLR L461 service data. Same torque applies to the rear differential drain plug.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','brake_fluid','transfer_case','differential_front','differential_rear');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_lr_agg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','brake_fluid','transfer_case','differential_front','differential_rear');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('differential_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_lr_agg FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('differential_drain');

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

SELECT 'LR Range Rover Sport L461 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques,
       @s_sm AS lr_sm_id, @s_lr_agg AS lr_agg_id;
