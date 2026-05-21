-- Porsche 911 (992) gen 32, 2019-2025 — per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData (DKHA Turbo S t_619031060,
-- DKEA Turbo t_619036178). Both engines are the same 3.8L flat-6
-- twin-turbo (9A2 architecture, dry-sump) with different boost tune
-- and exhaust calibration. HaynesPro publishes identical fluid specs
-- for both type entries. Public citations: Porsche 911 (992) Service
-- Manual (source 178) + VW Group factory oil spec aggregator (609)
-- since Porsche is part of VW Group and uses VW-family coolant +
-- transmission fluids.
--
-- Engines (2):
--   DKHA (eid 53) — 3.8 TT Turbo S 650 Hp (478 kW)
--   DKEA (eid 54) — 3.8 TT Turbo   580 Hp (427 kW)
-- HaynesPro labels the Turbo S as DKHA; the DB recorded the code as
-- DKH. Same engine, same fluids — values apply unchanged.

SET NAMES utf8mb4;

SET @gen      := 32;
SET @e_dkh    := 53;   -- Turbo S (HaynesPro: DKHA)
SET @e_dkea   := 54;   -- Turbo
SET @s_sm     := 178;
SET @s_vwg    := 609;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- engine_oil
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dkh, 'engine_oil', 8.3, 8.8, '0W-40', 'Porsche C40 (ACEA A3/B4)', 10000, 16000, 12,
   '3.8L flat-6 twin-turbo Turbo S (650 Hp). Dry-sump system — capacity is total fill including filter, NOT a wet-sump pan measurement. Porsche-approved Mobil 1 0W-40 ESP X4 is the OE choice; 5W-40 Porsche C40 is the alternative on pre-2020 production. Drain plug is a snap-action design: renew the plug, tighten until it clicks into place — no torque value.'),
  (@gen, @e_dkea, 'engine_oil', 8.3, 8.8, '0W-40', 'Porsche C40 (ACEA A3/B4)', 10000, 16000, 12,
   '3.8L flat-6 twin-turbo Turbo (580 Hp). Same engine family as the Turbo S — different boost tune, identical lubrication system, identical service procedures. Dry-sump total capacity 8.3 L with filter. Snap-action drain plug; renew and click-tighten.');

-- =========================================================================
-- coolant — Porsche uses Glysantin G40 (Porsche own name) which is the
-- pink/violet G12++ chemistry. TL-VW 774G is the underlying VW spec.
-- 992 cooling system is large (dual front-radiator architecture); HaynesPro
-- does not publish a numeric capacity for the 992 cooling system in the
-- accessible lubricants section. Left NULL with a structural note.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dkh, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', NULL, NULL, NULL,
   '992 Turbo S — dual front-radiator + intercooler coolant circuits. Porsche lists this as a lifetime fill; total system capacity is large but is not published as a single number in the accessible workshop data (the system requires staged bleeding via dual front radiators + the engine-bay degas tank).'),
  (@gen, @e_dkea, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', NULL, NULL, NULL,
   '992 Turbo — same dual-radiator cooling architecture as Turbo S. Lifetime fill per Porsche.');

-- =========================================================================
-- transmission_dct — 8-speed PDK (CDT50)
-- Porsche PDK has two separate fluid systems: gear-oil section (5.8 L) and
-- hydraulic control section (5.9 L initial / 4.0 L drain refill). We record
-- the gear-oil section since that's the user-facing "transmission fluid".
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dkh, 'transmission_dct', 5.8, 6.1, '75W-90 Porsche 000 043 304 72 (CDT50 PDK gear oil)', 80000, 128000, NULL,
   '8-speed PDK (CDT50) gearbox section, Turbo S. Initial fill 5.8 L of Porsche 000 043 304 72 SAE 75W-90 gear oil. Separate hydraulic-control circuit holds Porsche PDK fluid 000 043 210 44 (initial 5.9 L, drain refill 4.0 L). Porsche schedule: full PDK service at 80,000 mi.'),
  (@gen, @e_dkea, 'transmission_dct', 5.8, 6.1, '75W-90 Porsche 000 043 304 72 (CDT50 PDK gear oil)', 80000, 128000, NULL,
   '8-speed PDK (CDT50) gearbox section, Turbo. Identical to Turbo S — same gear-oil capacity, same PDK fluid for the hydraulic circuit.');

-- =========================================================================
-- front differential (Turbo S + Turbo are AWD; the front diff sits ahead of
-- the engine on these rear-engine cars). Per-engine since both have AWD.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_dkh, 'differential_front', 0.3, 0.32, 'SAE 75W-80 Mobil Mobilube PTX FE', '992 Turbo S front differential — 0.3 L drain refill.'),
  (@gen, @e_dkea, 'differential_front', 0.3, 0.32, 'SAE 75W-80 Mobil Mobilube PTX FE', '992 Turbo front differential — 0.3 L drain refill.');

-- =========================================================================
-- gen-wide brake fluid + Haldex
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'Porsche/Hydraulan 404 — DOT 4 LV alternative', 'Brake reservoir capacity. DOT 4 LV (Low Viscosity) is required for the high-frequency ABS/PSM/PCCB modulation found on 992. Porsche schedule: change every 2 years.');

-- =========================================================================
-- torque_specs — drain plug is snap-action, NO torque value per Porsche.
-- We record this explicitly with a sentinel-style note (no Nm value).
-- HaynesPro does not publish a numeric torque for the 992 drain plug.
-- (No torque_specs row inserted — fastener:'oil_drain' intentionally
-- omitted because publishing a fabricated value would mislead.)
-- =========================================================================

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','differential_front','brake_fluid');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vwg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','differential_front','brake_fluid');

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

SELECT '911 992 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
