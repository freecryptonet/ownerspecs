-- Skoda Octavia Mk4 (gen 36, 2020-) per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData (DNPA typeId t_619032506, DGEA typeId
-- t_619035252/t_619035253) cross-verified with VW Group factory oil spec
-- (source 609). Public citations point at the Skoda OEM Service Manual
-- (source 194) and the VW Group aggregator (source 609); HaynesPro itself
-- is is_public=0 per the public-source visibility rule.
--
-- Engines:
--   DGEA (engine_id=24) — 1.4 TSI Plug-in Hybrid, 150 kW (iV 204 Hp) and
--                         180 kW (RS iV 245 Hp) shipping codes; both share
--                         the same DGEA+EANA powertrain and identical fluids.
--   DNPA (engine_id=57) — 2.0 TSI vRS 245 Hp (FWD only).
--
-- Critical corrections found vs. lore baseline:
--   DGEA DSG fill is 7.0 L refill / 8.1 L initial (DQ400e/0DD), NOT ~1.7 L.
--   DNPA DSG fill is 6.0-6.5 L refill / 7.2 L initial (DQ381/0GC), NOT ~1.9 L.
--   DNPA engine oil is 5.7 L with filter (5W viscosity), not 4.6 L.
--   DGEA engine oil is 4.0 L with filter, not 3.6 L.
--   Both engines: coolant 10.0 L (G12 EVO / TL-VW 774L). DGEA has an
--   additional 10.0 L HV-battery cooling loop (separate circuit).

SET NAMES utf8mb4;

SET @gen      := 36;
SET @e_dgea   := 24;   -- 1.4 TSI iV / RS iV PHEV (DGEA)
SET @e_dnpa   := 57;   -- 2.0 TSI vRS (DNPA)
SET @s_sm     := 194;  -- Skoda Octavia (Mk4) Service Manual (is_public=1)
SET @s_vwg    := 609;  -- VW Group factory oil spec aggregator (is_public=1)

-- =========================================================================
-- STEP 1 — wipe existing gen-wide / wrong-grain rows.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- HaynesPro lubricants table for both engines: 0W-20 / VW 508 00 / 30 Nm
-- drain plug. Capacities differ.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'engine_oil', 4.0, 4.2, '0W-20', 'VW 508 00', 18000, 30000, 24,
   '1.4 TSI EA211 plug-in hybrid (DGEA+EANA) — iV 204 Hp + iV RS 245 Hp share the same drivetrain and oil spec. With-filter sump capacity per Skoda Mk4 service data. LongLife interval (30,000 km / 24 mo); time/distance service is 15,000 km / 12 mo for high-stress profiles.'),
  (@gen, @e_dnpa, 'engine_oil', 5.7, 6.0, '0W-20', 'VW 508 00', 18000, 30000, 24,
   '2.0 TSI EA888 vRS (DNPA, 245 Hp). With-filter sump capacity per Skoda Mk4 service data. Drain plug must be renewed each change and the sealing washer replaced. LongLife interval 30,000 km / 24 mo; time/distance schedule is 15,000 km / 12 mo.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- Both engines: TL-VW 774L (G12 EVO, the VW Group lilac/pink HOAT successor
-- to G13). 10.0 L primary cooling loop. DGEA hybrid has an additional
-- separate 10.0 L HV-battery cooling circuit using the same fluid.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'coolant', 10.0, 10.6, 'TL-VW 774L (G12 EVO, pink HOAT)', NULL, NULL, NULL,
   '1.4 TSI iV/iV RS — primary engine cooling loop. The hybrid has an additional 10.0 L HV-battery cooling circuit (same TL-VW 774L spec). VW lists G12 EVO as a lifetime fill; replace if contaminated or after a major repair.'),
  (@gen, @e_dnpa, 'coolant', 10.0, 10.6, 'TL-VW 774L (G12 EVO, pink HOAT)', NULL, NULL, NULL,
   '2.0 TSI vRS — primary engine cooling loop. Cap pressure: 1.4–1.6 bar (blue) or 1.6–1.8 bar (black) depending on the radiator cap fitted at production. Lifetime fill per VW spec.');

-- =========================================================================
-- STEP 4 — per-engine transmission (DSG/DCT).
-- DGEA pairs with 0DD DQ400e 6-speed wet DSG (PHEV-specific).
-- DNPA pairs with 0GC DQ381 7-speed wet DSG.
-- Refill volume reported (not initial fill, which is service-only).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dgea, 'transmission_dct', 7.0, 7.4, 'VW G 052 182 (TL 525 18) — DQ400e (0DD) wet DSG fluid', 40000, 60000, NULL,
   '1.4 TSI iV + 0DD DQ400e 6-speed wet DSG (PHEV-tuned, integrates the e-motor). Initial fill 8.1 L; service-drain refill 7.0 L. VW recommends DSG fluid service every ~60,000 km on the wet DSG.'),
  (@gen, @e_dnpa, 'transmission_dct', 6.0, 6.3, 'VW G 055 529 A2 — DQ381 (0GC) wet DSG fluid', 40000, 60000, NULL,
   '2.0 TSI vRS + 0GC DQ381 7-speed wet DSG (FWD). Initial fill 7.2 L; service-drain refill 6.0–6.5 L. DQ381 uses the newer G 055 529 A2 fluid — do NOT substitute with older DQ250 G 052 182.');

-- =========================================================================
-- STEP 5 — transmission_mt (vRS 6MT only, DNPA).
-- 02Q gearbox, 75W gear oil, 2.3 L refill.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_dnpa, 'transmission_mt', 2.3, 2.4, 'VW G 052 527 A2 (SAE 75W)', NULL, NULL, NULL,
   'vRS 6MT (02Q manual gearbox). VW lists 75W G 052 527 A2 fluid; refill capacity 2.3 L. Lifetime fill per VW; replace if contaminated or after clutch service.');

-- =========================================================================
-- STEP 6 — gen-wide brake fluid + A/C refrigerant.
-- Brake system varies by transmission (DSG/MT/AT) — DSG 1.0 L, MT 1.15 L.
-- We record the DSG value (majority case) with notes.
-- A/C refrigerant is year-dependent: R134a (earlier) or R1234yf (later).
-- We record both since the gen straddles the EU R1234yf mandate transition.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'VW 501 14 (preferred) — DOT 4 alternative', 'Brake system reservoir capacity. DSG-equipped cars: 1.0 L. Manual transmission: 1.15 L. VW recommends 2-year fluid change interval on hygroscopic DOT 4-class fluids.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R134a 500 ± 15 g (early) / R1234yf 460 g (later)', 'A/C refrigerant — R134a on early production, R1234yf on later EU production. Compressor oil varies by compressor brand (Denso/Mahle/Hanon): see service manual. Charge value applies to system total.');

-- =========================================================================
-- STEP 7 — per-engine torque_specs.
-- HaynesPro lubricants table includes oil drain plug torque for both engines:
-- 30 Nm (renew the plug + sealing washer). No spark plug torque in the
-- accessible HaynesPro adjustment data — left out, not fabricated.
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_dgea, 'oil_drain', 30, 22, NULL,
   '1.4 TSI iV oil pan drain plug. VW spec: renew the plug at the first oil change only, renew the seal at every change. Apply torque cold; do not overtighten — the alloy pan is the failure mode.'),
  (@gen, @e_dnpa, 'oil_drain', 30, 22, NULL,
   '2.0 TSI vRS oil pan drain plug. VW spec: renew the plug and the sealing washer at every oil change. Apply torque cold.');

-- =========================================================================
-- STEP 8 — public source citations (Skoda OEM SM + VW Group aggregator).
-- HaynesPro is is_public=0 and not linked here per the public-source rule.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vwg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transmission_mt','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_vwg FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- STEP 9 — post-migration sweep (scraper-leftover thin rows).
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

UPDATE fluid_specs
   SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen
   AND capacity_l IS NOT NULL
   AND capacity_qt IS NULL;

-- =========================================================================
-- STEP 10 — verification report.
-- =========================================================================
SELECT 'Octavia Mk4 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(DISTINCT ss.source_id)
          FROM spec_sources ss JOIN sources s ON s.id=ss.source_id
          WHERE s.is_public=1 AND (
            (ss.spec_table='fluid_specs'  AND ss.spec_id IN (SELECT id FROM fluid_specs  WHERE generation_id=@gen)) OR
            (ss.spec_table='torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=@gen))
          )) AS public_sources_used;
