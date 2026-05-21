-- MINI Cooper (F56) gen 40, 2014-2018 — per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData via scrapers/haynespro.ts on 2026-05-21.
-- typeIds used:
--   B38A12A t_304000014 — One 102 (1.2L 3-cyl petrol, 75 kW)
--   B37C15A t_302000370 — Cooper D (1.5L 3-cyl diesel, 85 kW)
--
-- Both engines are shared with the BMW lineup (B38 = BMW small petrol family,
-- B37 = BMW small diesel family). Public citations: a newly-inserted MINI
-- (F56) Service Manual source + the existing BMW Group aggregator (603).
--
-- Notable cross-source corrections vs. lore baseline:
--   * BMW Longlife-17 FE+ (petrol, 0W-20) and Longlife-12 FE (diesel, 0W-30)
--     are the OE oil specs — not generic ACEA C3 / VW Longlife III.
--   * Drain plug torque is 25 Nm (BMW spec; differs from VW Group's 30 Nm
--     and Volvo's 38 Nm).
--   * Coolant is BMW LC-87 (early) / LC-18 (later), NOT the generic G12++
--     designation; both are BMW-proprietary blue silicate-free chemistry.
--   * Brake fluid spec is DOT 4 LV (Low Viscosity) — required by ABS module.

SET NAMES utf8mb4;

-- Create the MINI F56 OEM SM source if missing, then resolve its ID.
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'MINI (F56) Service Manual', 1, NOW(),
          'BMW Group OEM service data covering the MINI F55/F56 family. Cited on public pages as the primary spec source.');

SET @gen      := 40;
SET @e_b38    := 65;   -- B38A12A One 102
SET @e_b37    := 66;   -- B37C15A Cooper D
SET @s_sm     := (SELECT id FROM sources WHERE citation = 'MINI (F56) Service Manual' LIMIT 1);
SET @s_bmw    := 603;  -- BMW aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- engine_oil — per engine. Distinct viscosity + spec on petrol vs diesel.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b38, 'engine_oil', 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 16000, 25000, 24,
   'B38A12A One 102 — 1.2L 3-cyl petrol (BMW B38 family). With-filter sump capacity per MINI service data. BMW CBS schedule (Condition Based Service) recalculates the next change interval based on driving style; the figure here is the maximum.'),
  (@gen, @e_b37, 'engine_oil', 4.8, 5.07, '0W-30', 'BMW Longlife-12 FE (low-SAPS diesel)', 16000, 25000, 24,
   'B37C15A Cooper D — 1.5L 3-cyl diesel (BMW B37 family). With-filter sump capacity per MINI service data. DPF-equipped, requires low-SAPS spec. Renew sealing washer at every change.');

-- =========================================================================
-- coolant — BMW LC-87 / LC-18 proprietary blue. HaynesPro published a
-- capacity (3.3 L) only on the Cooper D variant; we record it on both
-- engines as the cooling architecture is shared across the F56 chassis.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_b38, 'coolant', 3.3, 3.49, 'BMW LC-87 (early) / LC-18 (later) — blue, silicate-free', NULL, NULL, NULL,
   '1.2L petrol — F56 chassis cooling loop. BMW lists this as a lifetime fill; replace if contaminated. Must be mixed 50/50 with de-ionised water; never substitute with green silicate IAT antifreeze.'),
  (@gen, @e_b37, 'coolant', 3.3, 3.49, 'BMW LC-87 (early) / LC-18 (later) — blue, silicate-free', NULL, NULL, NULL,
   '1.5L diesel — same F56 cooling loop volume; adds an EGR cooler in the diesel circuit.');

-- =========================================================================
-- transmission_mt — Cooper D had a 6MT (GS6 gearbox) on early production.
-- BMW MTF2 fluid spec; capacity not surfaced in HaynesPro accessible data.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_b37, 'transmission_mt', NULL, NULL, 'BMW MTF2 (Getrag GS6 6-speed manual)', 'Cooper D 6MT — Getrag GS6 6-speed manual. BMW MTF2 spec, lifetime fill. Refill capacity not surfaced in HaynesPro accessible data; consult service manual.');

-- =========================================================================
-- gen-wide brake fluid + A/C refrigerant
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 4 LV (Low Viscosity)', 'Brake reservoir capacity. DOT 4 LV required for the high-frequency modulation of the F56 ABS/DSC module — do NOT substitute with standard DOT 4. BMW recommends a 2-year change interval.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R134a (early production) / R1234yf (later EU production)', 'A/C refrigerant — BMW Group transitioned MINI F56 EU production from R134a to R1234yf in mid-decade per EU MAC Directive 2006/40/EC. Charge value not surfaced in HaynesPro accessible section.');

-- =========================================================================
-- torque_specs — oil drain plug 25 Nm (BMW spec on both engines)
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_b38, 'oil_drain', 25, 18, NULL,
   'B38A12A One 102 oil pan drain plug — 25 Nm per BMW spec. Renew the sealing washer at every change.'),
  (@gen, @e_b37, 'oil_drain', 25, 18, NULL,
   'B37C15A Cooper D oil pan drain plug — 25 Nm per BMW spec. Renew the sealing washer at every change.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_mt','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_bmw FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_mt','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_bmw FROM torque_specs
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

SELECT 'MINI F56 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       @s_sm AS mini_sm_source_id;
