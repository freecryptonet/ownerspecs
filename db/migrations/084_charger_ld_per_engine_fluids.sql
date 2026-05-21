-- Phase 2 — Charger LD per-engine fluid rows.
--
-- This is the proof of concept for the engine-scoped fluid_specs refactor.
-- We keep the existing "all engines" rows where the spec is truly common
-- (brake fluid, A/C refrigerant, washer fluid). We split engine_oil and
-- coolant into per-engine rows so the overview page can show the right
-- value next to the right engine.
--
-- Sources: Mopar OM 2016 (F:\ownermanuals/2016 dodge charger owners manuel.pdf)
-- + Stellantis press materials + AMSOIL Charger Pentastar/HEMI lookups.

SET NAMES utf8mb4;

SET @gen      := 122;
SET @e_v6     := 138;   -- Pentastar
SET @e_57     := 166;   -- 5.7 HEMI
SET @e_64     := 167;   -- 6.4 HEMI 392
SET @e_sc     := 168;   -- 6.2 HEMI SC (Hellcat)

-- 1. Engine oil — split into 4 per-engine rows (delete the existing
--    gen-wide row, insert 4 new ones).
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN
  (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_v6, 'engine_oil', 5.6, 6.0, '5W-20', 'FCA MS-6395 / API Certified', '68191349AC', 8000, 12,
   '3.6L Pentastar V6 (SXT/GT): 5.6 L (6 US qt) with filter, 5W-20 API Certified MS-6395 (Mopar OM 2016 p.629/p.632). Mopar TSB later approved 0W-20 alternate for fuel economy alignment.'),
  (@gen, @e_57, 'engine_oil', 6.6, 7.0, '5W-20', 'FCA MS-6395 / API Certified', '68191349AC', 8000, 12,
   '5.7L HEMI V8 (R/T): 6.6 L (7 US qt) with filter, 5W-20 API Certified MS-6395 (Mopar OM 2016 p.630/p.633). Mopar TSB later approved 0W-20 alternate.'),
  (@gen, @e_64, 'engine_oil', 6.5, 7.0, '0W-40', 'FCA MS-13340 / API Certified', '68191349AC', 6000, 12,
   '6.4L HEMI 392 (R/T Scat Pack / SRT 392): 6.5 L (7 US qt) with filter, SAE 0W-40 MS-13340 (Pennzoil Ultra Platinum Euro is the OEM-approved fit). High-performance schedule: 6k mi.'),
  (@gen, @e_sc, 'engine_oil', 6.6, 7.0, '0W-40', 'FCA MS-13340 / API Certified', '68191349AC', 6000, 12,
   '6.2L Hellcat HEMI V8 supercharged: 6.6 L (7 US qt) with filter, SAE 0W-40 MS-13340 (Pennzoil Ultra Platinum). Mandatory severe-duty 6k mi cycle on Hellcat / Redeye / Jailbreak.');

-- 2. Coolant — split into 2 per-engine rows (V6 vs V8 — Hellcat / 392 share the V8 system size with the R/T)
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN
  (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='coolant') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='coolant';

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_v6, 'coolant',  9.5, 10.0, 'MOPAR OAT (10-yr/150k formula)', 150000, 120,
   '3.6L Pentastar V6: 9.5 L (10 US qt) total system with heater + reserve (Mopar OM 2016 p.629). MOPAR OAT — NEVER mix with HOAT or universal coolant.'),
  (@gen, @e_57, 'coolant', 13.9, 14.5, 'MOPAR OAT (10-yr/150k formula)', 150000, 120,
   '5.7L HEMI V8 (R/T): 13.9 L (14.5 US qt) standard, 14.3 L (15 qt) with Severe Duty II cooling (Mopar OM 2016 p.630). Scat Pack and Hellcat share the V8 system; Hellcat adds supercharger intercooler ~3.8 L on top.'),
  (@gen, @e_sc, 'coolant', 17.7, 18.7, 'MOPAR OAT (10-yr/150k formula)', 150000, 120,
   '6.2L Hellcat supercharged: 13.9 L engine + 3.8 L intercooler chiller loop = 17.7 L (18.7 qt) total. Mopar TSB requires periodic flush of the chiller loop independently.');

-- 3. Transmission AT — different transmission per trim too. Keep gen-wide
--    but document variance (ZF 8HP70 for SXT/GT/R/T/Scat Pack, 8HP90 for Hellcat).
--    Most pan-fill services are 4.5 qt regardless; full fill differs.
UPDATE fluid_specs
SET notes = 'ZF 8HP70 8AT (SXT post-2015 / GT / R/T / Scat Pack): 8.2 L (8.7 qt) total fill. ZF 8HP90 8AT (Hellcat / Redeye / Jailbreak): 9.0 L (9.5 qt) total. Pre-2015 SXT base W5A580 5AT: ~9 qt ATF+4. Pan + filter service: ~4.5 qt for all 8HP variants. (Mopar OM 2016 p.634; cross-verified via blauparts service kit specs).'
WHERE generation_id=@gen AND fluid_type='transmission_at';

-- 4. Other fluids stay gen-wide (engine_id stays NULL): brake, ac_refrigerant,
--    transfer_case (BW44-46 on all AWD trims regardless of engine),
--    rear_differential (75W-85 across all), transmission_at (handled above).

-- 5. Re-link the new oil + coolant rows to all 3 existing Charger LD sources
SET @om_2016    := (SELECT id FROM sources WHERE citation='Dodge Charger 2016 Owner''s Manual (LD facelift)' LIMIT 1);
SET @om_old     := (SELECT id FROM sources WHERE citation='Dodge Charger (LD) Owner''s Manual' LIMIT 1);
SET @stell      := (SELECT id FROM sources WHERE citation='Stellantis (FCA) factory oil spec (Mopar service docs + AMSOIL + cross-aggregator)' LIMIT 1);

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @om_2016 FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @stell   FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant');

SELECT 'Charger LD per-engine split done' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS oil_rows,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND fluid_type='coolant') AS coolant_rows;
