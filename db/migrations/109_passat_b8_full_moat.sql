-- VW Passat B8 (gen 66, 2015-2024) per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData (typeIds: CHHB t_318011879, CUKC t_317000557,
-- CJXA t_318011877, CUAA t_311000006, DNUA t_619014585) cross-verified with VW
-- Group factory oil spec (source 609). Public citations point at the VW Passat
-- (B8) Service Manual (source 394) and the VW Group aggregator (609).
-- HaynesPro itself is is_public=0 and not linked.
--
-- Engines (5):
--   CHHB (eid 72)  — 2.0 TSI 220 Hp (EA888 Gen 3, FWD, DQ250 6-spd wet DSG)
--   CUKC (eid 113) — 1.4 TSI GTE 218 Hp PHEV (EA211 + e-motor, DQ400e 6-spd)
--   CJXA (eid 114) — 2.0 TSI 280 Hp 4MOTION (EA888 Gen 3, DQ250 6-spd wet)
--   CUAA (eid 115) — 2.0 BiTDI 240 Hp 4MOTION (EA288, DQ500 7-spd wet)
--   DNUA (eid 116) — 2.0 TSI 272 Hp 4MOTION facelift (EA888 evo, DQ381 7-spd wet)
--
-- HaynesPro publishes multiple oil-spec/viscosity options per engine keyed on
-- service schedule (Time/distance vs. LongLife) and pre-/post-2020. We record
-- the LongLife/post-2020 value as canonical (most common in EU service) and
-- list the time/distance alternative in the notes.

SET NAMES utf8mb4;

SET @gen      := 66;
SET @e_chhb   := 72;
SET @e_cukc   := 113;
SET @e_cjxa   := 114;
SET @e_cuaa   := 115;
SET @e_dnua   := 116;
SET @s_sm     := 394;
SET @s_vwg    := 609;

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
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_chhb, 'engine_oil', 5.7, 6.0, '0W-30', 'VW 504 00 (LongLife III)', 18000, 30000, 24,
   '2.0 TSI EA888 Gen 3 (220 Hp, FWD). With-filter sump capacity per VW Passat B8 service data. LongLife (post-2020) uses VW 504 00 0W-30. Time/distance schedule (pre-2020): VW 502 00 5W-40 if fuel is not EN 228 compliant, VW 504 00 0W-30 otherwise. Renew drain plug + seal at each change; alloy/plastic sump pan torque differs (plastic = ''as far as the stop''; metal = 30 Nm).'),
  (@gen, @e_cukc, 'engine_oil', 4.0, 4.2, '5W-40', 'VW 502 00', 18000, 30000, 24,
   '1.4 TSI EA211 GTE plug-in hybrid (218 Hp). With-filter sump capacity per Passat B8 service data. VW lists VW 502 00 5W-40 only — the GTE does NOT use the 0W-20 / VW 508 00 spec of the newer EA211 evo. Renew drain plug at each change.'),
  (@gen, @e_cjxa, 'engine_oil', 5.7, 6.0, '0W-30', 'VW 504 00 (LongLife III)', 18000, 30000, 24,
   '2.0 TSI EA888 Gen 3 (280 Hp, 4MOTION). Same EA888 Gen 3 sump as CHHB; identical with-filter capacity. LongLife post-2020 spec is VW 504 00 0W-30; time/distance alternative is VW 502 00 5W-40 (non-EN228 fuel) or VW 504 00 0W-30 (EN228).'),
  (@gen, @e_cuaa, 'engine_oil', 4.9, 5.2, '0W-30', 'VW 507 00 (LongLife III low-SAPS, diesel)', 18000, 30000, 24,
   '2.0 BiTDI EA288 (240 Hp, 4MOTION). With-filter sump capacity per Passat B8 service data. DPF-equipped diesel requires VW 507 00 low-SAPS oil only — both 0W-30 and 5W-30 viscosities permitted. AdBlue (AUS32) tank also fitted for SCR.'),
  (@gen, @e_dnua, 'engine_oil', 5.7, 6.0, '0W-30', 'VW 504 00 (LongLife III)', 18000, 30000, 24,
   '2.0 TSI EA888 evo (272 Hp, 4MOTION facelift, 2019+). With-filter sump capacity per Passat B8 service data. LongLife uses VW 504 00 (0W-30 or 5W-30). Newer plastic sump variant tightens drain bolt ''as far as the stop'' rather than to a torque value.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- HaynesPro distinguishes a TL-VW 774J (G13) era and a TL-VW 774L (G12 EVO)
-- era at 07/07/2019 changeover. Both are silicate-based pink/lilac OAT and
-- compatible at top-up; full flush should match production-era spec.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_chhb, 'coolant', 10.0, 10.6, 'TL-VW 774J (G13, pink) or TL-VW 774L (G12 EVO post-07/2019)', NULL, NULL, NULL,
   '2.0 TSI EA888 Gen 3 (FWD). VW spec is lifetime fill; replace if contaminated or after major repair. 2019+ cars factory-filled with G12 EVO; older cars use G13.'),
  (@gen, @e_cukc, 'coolant', 8.0, 8.5, 'TL-VW 774J (G13) or TL-VW 774L (G12 EVO post-07/2019)', NULL, NULL, NULL,
   '1.4 TSI GTE PHEV — smaller engine coolant loop (8.0 L). The PHEV battery has a separate coolant circuit; see service manual for the HV-battery loop capacity.'),
  (@gen, @e_cjxa, 'coolant', 10.0, 10.6, 'TL-VW 774J (G13, pink) or TL-VW 774L (G12 EVO post-07/2019)', NULL, NULL, NULL,
   '2.0 TSI 4MOTION (280 Hp). Cooling loop volume includes added 4MOTION transmission cooler.'),
  (@gen, @e_cuaa, 'coolant', 8.0, 8.5, 'TL-VW 774J (G13, pink) or TL-VW 774L (G12 EVO post-07/2019)', NULL, NULL, NULL,
   '2.0 BiTDI 4MOTION. Diesel cooling loop is slightly smaller than the 2.0 TSI (no charge-air intercooler on the coolant circuit at the same geometry).'),
  (@gen, @e_dnua, 'coolant', 10.0, 10.6, 'TL-VW 774L (G12 EVO, pink)', NULL, NULL, NULL,
   '2.0 TSI 4MOTION facelift — 2019+ build, always G12 EVO from factory.');

-- =========================================================================
-- STEP 4 — per-engine transmission_dct (DSG/DCT).
-- All B8 trims are DSG-only in the gens we have. Refill capacity recorded;
-- initial-fill in notes.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_chhb, 'transmission_dct', 5.2, 5.5, 'VW G 052 182 (TL 525 18) — DQ250 wet DSG', 40000, 60000, NULL,
   '2.0 TSI 220 Hp + 0D9 DQ250 6-speed wet DSG. Initial fill 6.9–7.2 L; service-drain refill 5.2 L. VW recommends DSG fluid + filter at ~60,000 km on wet DSG.'),
  (@gen, @e_cukc, 'transmission_dct', 7.0, 7.4, 'VW G 052 182 (TL 525 18) — DQ400e wet DSG (PHEV)', 40000, 60000, NULL,
   '1.4 TSI GTE PHEV + 0DD DQ400e 6-speed wet DSG (e-motor integrated). Initial fill 8.1 L; service-drain refill 7.0 L. Higher fluid volume because the gearbox houses the hybrid drive motor.'),
  (@gen, @e_cjxa, 'transmission_dct', 5.2, 5.5, 'VW G 052 182 (TL 525 18) — DQ250 wet DSG', 40000, 60000, NULL,
   '2.0 TSI 280 Hp 4MOTION + 0D9 DQ250 6-speed wet DSG. Initial fill 6.9–7.2 L; service-drain refill 5.2 L.'),
  (@gen, @e_cuaa, 'transmission_dct', 5.5, 5.8, 'VW G 052 182 (TL 525 18) — DQ500 wet DSG', 40000, 60000, NULL,
   '2.0 BiTDI 240 Hp 4MOTION + 0DL DQ500 7-speed wet DSG (high-torque variant). Initial fill 6.9–7.1 L; service-drain refill 5.5 L.'),
  (@gen, @e_dnua, 'transmission_dct', 6.0, 6.3, 'VW G 055 529 A2 — DQ381 wet DSG', 40000, 60000, NULL,
   '2.0 TSI 272 Hp 4MOTION facelift + 0GC DQ381 7-speed wet DSG (newer wet 7-speed). Initial fill 6.7–6.9 L; service-drain refill 6.0 L. DQ381 uses the newer G 055 529 A2 fluid — do NOT substitute with older DQ250 G 052 182.');

-- =========================================================================
-- STEP 5 — gen-wide brake fluid + A/C refrigerant.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'VW 501 14 (preferred) — DOT 4 alternative', 'Brake reservoir capacity — DSG-equipped cars 1.0 L. VW recommends a 2-year change interval on hygroscopic DOT 4-class fluids.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R134a 500 ± 15 g (pre-07/2019) / R1234yf 460 ± 15 g (post-07/2019)', 'A/C refrigerant — VW switched the Passat B8 EU production from R134a to R1234yf in mid-2019 (per EU MAC Directive 2006/40/EC). Compressor oil varies by compressor brand (Denso/Sanden/Mahle); see service manual.');

-- =========================================================================
-- STEP 6 — per-engine torque_specs (oil drain plug).
-- HaynesPro: 30 Nm for metal sump on all five engines; plastic sump uses a
-- ''tighten to stop'' procedure on newer (DNUA) and pre-2020 (CHHB, CJXA).
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_chhb, 'oil_drain', 30, 22, NULL,
   '2.0 TSI 220 Hp oil pan drain plug — metal sump value. Plastic-sump variant: tighten to the stop; renew the drain plug at every change.'),
  (@gen, @e_cukc, 'oil_drain', 30, 22, NULL,
   '1.4 TSI GTE oil pan drain plug. Renew the seal at every change.'),
  (@gen, @e_cjxa, 'oil_drain', 30, 22, NULL,
   '2.0 TSI 280 Hp 4MOTION oil pan drain plug — metal sump value.'),
  (@gen, @e_cuaa, 'oil_drain', 30, 22, NULL,
   '2.0 BiTDI 240 Hp 4MOTION oil pan drain plug. Renew the seal at every change.'),
  (@gen, @e_dnua, 'oil_drain', 30, 22, NULL,
   '2.0 TSI 272 Hp 4MOTION facelift oil pan drain plug — metal sump value. Plastic-sump variant on later production: tighten to the stop, do not torque.');

-- =========================================================================
-- STEP 7 — public source citations.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vwg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_vwg FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- STEP 8 — post-migration sweep (scraper-leftover thin rows).
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

-- =========================================================================
-- STEP 9 — verification.
-- =========================================================================
SELECT 'Passat B8 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(DISTINCT ss.source_id)
          FROM spec_sources ss JOIN sources s ON s.id=ss.source_id
          WHERE s.is_public=1 AND (
            (ss.spec_table='fluid_specs'  AND ss.spec_id IN (SELECT id FROM fluid_specs  WHERE generation_id=@gen)) OR
            (ss.spec_table='torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=@gen))
          )) AS public_sources_used;
