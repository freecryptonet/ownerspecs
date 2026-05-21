-- Tesla Model S gen 116, 2012- — per-engine moat backfill.
-- Tesla Model S is an EV — there is no engine oil, no engine coolant in the
-- traditional sense. The moat-data set is therefore narrower than for ICE
-- vehicles: drive-unit gear oil, HV-battery + drivetrain coolant, brake
-- fluid, A/C refrigerant + compressor oil.
--
-- Sourced from HaynesPro WorkshopData via scrapers/haynespro.ts on 2026-05-21
-- (typeId t_619033274 — Long Range Plus 2019-2021, representative of pre-
-- refresh dual-motor Model S). HaynesPro does NOT catalogue the 2021+
-- refreshed Model S Plaid; Plaid drive-unit values noted as deferred.
--
-- Public citations: Tesla Model S Owner's Manual (source 580) + Tesla
-- service spec aggregator (source 612). Both already exist in the DB.
--
-- "Engines" (drive units) in our DB:
--   176 Tesla Drive Unit LR    — Long Range dual-motor (front + rear induction)
--   177 Tesla Drive Unit Plaid — Plaid tri-motor (post-2021 refresh)

SET NAMES utf8mb4;

SET @gen        := 116;
SET @e_lr       := 176;
SET @e_plaid    := 177;
SET @s_sm       := 580;   -- Tesla Model S Owner's Manual
SET @s_tesla    := 612;   -- Tesla service spec aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','brake_fluid','ac_refrigerant','differential_front','differential_rear','transmission_at')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','brake_fluid','ac_refrigerant','differential_front','differential_rear','transmission_at');

-- =========================================================================
-- coolant — Glysantin G48 (Tesla pre-mix, DO NOT DILUTE)
-- Powers both the HV battery thermal-management loop and the drive-unit
-- cooling circuit. Single shared loop in the pre-refresh Model S.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_lr, 'coolant', NULL, NULL, 'Glysantin G48 (Tesla pre-mix — DO NOT dilute)',
   'Long Range AWD — HV-battery + drive-unit thermal-management loop. Tesla ships the coolant pre-mixed (silicate-based IAT chemistry); diluting it weakens the freeze protection. Capacity not published in the OM accessible section. Tesla schedule: every 4 yr / 50,000 mi service check.'),
  (@gen, @e_plaid, 'coolant', NULL, NULL, 'Glysantin G48 (Tesla pre-mix — DO NOT dilute)',
   'Plaid tri-motor (2021+ refresh) — same Glysantin G48 coolant per Tesla service documentation. Refresh introduced a revised manifold + heat-pump; total system capacity not published.');

-- =========================================================================
-- differential_front + differential_rear — Tesla drive units integrate a
-- single-speed reduction gear; the "transmission" fluid IS the drive-unit
-- ATF. Each axle has its own drive unit (and on Plaid, two rear units).
-- We record them as differential_front + differential_rear to fit the
-- existing data-grain rule.
--
-- HaynesPro publishes four front-unit variants per Tesla PN; the most
-- common 2019-2021 dual-motor combination uses:
--   Front 1035000-00-J → ATF TESLA KAF1 (or SK ATF 212-B), 1.75 L
--   Rear dual-motor   → SK ATF 212-B, 1.4 L
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_lr, 'differential_front', 1.75, 1.85, 'Tesla KAF1 (or SK ATF 212-B / Mobil SHC 629 by drive-unit PN)',
   'Long Range AWD front drive unit — large induction-motor reduction gear, 1.75 L. Multiple Tesla part-number variants ship with different OE ATF spec: PN 1035000-00-F → Mobil SHC 629; PN 1035000-00-J → Tesla KAF1 / SK ATF 212-B; PN 1478000-00-D / 1478000-01-D → Tesla ATF9 / EDF2 (1.8 L). Identify the front-unit PN before service.'),
  (@gen, @e_lr, 'differential_rear', 1.4, 1.48, 'SK ATF 212-B',
   'Long Range AWD rear drive unit (dual-motor configuration — smaller than single-motor RWD unit). 1.4 L per HaynesPro Tesla service data. Single-motor RWD Standard Range Model S takes 2.25 L in the same rear-unit slot.'),
  (@gen, @e_plaid, 'differential_front', 1.75, 1.85, 'Tesla ATF9 / EDF2 (Plaid drive units use later-spec fluid)',
   'Plaid front drive unit — same Tesla front-unit family as LR but with the later 1478000-series PN that calls for ATF9 / EDF2. Capacity ~1.8 L. Plaid drive units are carbon-sleeved permanent-magnet motors (vs the LR''s induction front unit) — fluid spec is critical, do not cross with KAF1.'),
  (@gen, @e_plaid, 'differential_rear', NULL, NULL, 'Tesla ATF9 / EDF2',
   'Plaid rear drive units (TWO motors on Plaid — one per rear wheel). Capacity not published in HaynesPro accessible section (Plaid is post-2021 refresh, beyond HaynesPro coverage at this time). Service via Tesla service center only.');

-- =========================================================================
-- brake_fluid — gen-wide, DOT 3 per Tesla OM
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 0.975, 1.03, 'DOT 3', 'Brake reservoir capacity. Tesla specifies DOT 3 only. 2-year change interval per Tesla service schedule.');

-- =========================================================================
-- ac_refrigerant — gen-wide, market-dependent
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf 730 ± 20 g (most markets) / R134a 770 ± 20 g (Asia-Pacific)',
   'A/C refrigerant charge varies by market. Compressor oil: ND-11 (POE, 150 mL total system). The Model S uses a heat-pump A/C system on later production — refrigerant is shared between cabin HVAC + HV-battery thermal management on those builds.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('coolant','differential_front','differential_rear','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_tesla FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('coolant','differential_front','differential_rear','brake_fluid','ac_refrigerant');

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Tesla Model S moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids;
