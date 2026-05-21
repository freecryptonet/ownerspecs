-- Subaru Ascent (WM) gen 94, 2019-2023 — per-engine moat backfill.
-- Source: 2020 Subaru Ascent Owner's Manual (PDF, official Subaru content
-- mirrored at startmycar.com → manuals.opinautos.com) saved at
-- scrapers/manuals/2020-subaru-ascent-om.pdf. Page references throughout
-- this migration point at the "Specifications" chapter (Ch. 12, pp. 480-487).
--   PDF: https://manuals.opinautos.com/published/Subaru-Ascent_2020_EN-US_US_898b115c16.pdf
--   Landing page: https://www.startmycar.com/subaru/ascent/info/manuals
--
-- HaynesPro does NOT catalogue the Ascent (US/CA-only model, not in EU
-- dataset), so this migration uses the OEM OM as primary public source +
-- the Mazda/Subaru aggregator (608) as the second citation.
--
-- Engines (2 in our DB):
--   42  FA24  — 2.4L DOHC turbo flat-4 (Subaru FA24 family), 260 Hp
--   159 FA24F — Updated FA24 production code (same physical engine, later MY)
--
-- Both engines share the same FA24 architecture (94.0×86.0 mm bore×stroke,
-- 10.6:1 compression, 1-3-2-4 firing). Subaru tracks production-code revisions
-- separately but fluid specs are identical between FA24 and FA24F.

SET NAMES utf8mb4;

SET @gen      := 94;
SET @e_fa24   := 42;
SET @e_fa24f  := 159;
SET @s_sm     := 555;   -- Subaru Ascent (WM) Service Manual / Owner Manual
SET @s_subaru := 608;   -- Mazda/Subaru aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front','differential_rear')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_front','differential_rear');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');

-- =========================================================================
-- engine_oil — both FA24 production codes use identical spec + capacity
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_fa24, 'engine_oil', 4.5, 4.8, '0W-20', 'SUBARU approved 0W-20 full synthetic (API SN "Resource Conserving" / ILSAC GF-5)', 6000, 10000, 6,
   'FA24 2.4L DOHC turbo flat-4. With-filter sump capacity 4.5 L / 4.8 US qt per 2020 Subaru Ascent OM Ch. 12. Top-off (low→full): ~1.0 L. 0W-20 synthetic required for optimum protection; 5W-30 conventional acceptable only as temporary replenishment, must be changed back to 0W-20 synthetic at the next service. Subaru schedule: 6,000 mi / 6 mo normal, 3,000 mi severe duty.'),
  (@gen, @e_fa24f, 'engine_oil', 4.5, 4.8, '0W-20', 'SUBARU approved 0W-20 full synthetic (API SN "Resource Conserving" / ILSAC GF-5)', 6000, 10000, 6,
   'FA24F (production-code-revised FA24, later MY). Same physical engine + sump; identical 4.5 L with-filter capacity and 0W-20 spec.');

-- =========================================================================
-- coolant — Subaru Super Coolant, 11.1 L total
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_fa24, 'coolant', 11.1, 11.7, 'Subaru Super Coolant (blue, long-life OAT)', 'FA24 — 11.1 L total cooling system per 2020 Subaru Ascent OM. Subaru Super Coolant is a blue long-life OAT premix; never substitute with green silicate IAT or pink VW G13. Initial change at 137,500 mi / 11 yr; subsequent every 137,500 mi / 11 yr per Subaru maintenance schedule.'),
  (@gen, @e_fa24f, 'coolant', 11.1, 11.7, 'Subaru Super Coolant (blue, long-life OAT)', 'FA24F — same Ascent WM cooling system as FA24 (chassis-level component, not engine-specific).');

-- =========================================================================
-- transmission_cvt — Subaru Lineartronic CVT (TR690 family)
-- Two capacities depending on whether the air-cooled CVT cooler is fitted:
--   TR690S (with cooler): 12.0 L
--   TR690G (without):     11.6 L
-- We record the cooler-equipped variant as canonical (most Ascent trims
-- have the cooler) and note both in the description.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_fa24, 'transmission_cvt', 12.0, 12.7, 'Subaru High Torque CVTF II (consult Subaru dealer — proprietary)', 'FA24 + Subaru Lineartronic CVT (TR690 family). 12.0 L total fill with air-cooled CVT cooler (TR690S); 11.6 L without cooler (TR690G). Subaru does NOT publish the fluid PN in the OM — service manual lists it as "Subaru High Torque CVTF II". Substituting any non-Subaru CVT fluid will damage the variator. CVT fluid is "filled for life" under normal duty; severe-duty schedule (towing especially) calls for 25,000 mi service.'),
  (@gen, @e_fa24f, 'transmission_cvt', 12.0, 12.7, 'Subaru High Torque CVTF II (consult Subaru dealer — proprietary)', 'FA24F + same Lineartronic CVT. Identical fluid spec and capacity.');

-- =========================================================================
-- gen-wide: front + rear diff, brake fluid, A/C
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', 1.2, 1.27, 'SUBARU Extra MT (or API GL-5 75W-90 alternative)', 'Front differential (integrated with CVT bell-housing). 1.2 L per 2020 Subaru Ascent OM. Factory-filled with Subaru Extra MT; API GL-5 75W-90 acceptable as alternative.'),
  (@gen, NULL, 'differential_rear', 0.8, 0.85, 'SUBARU Extra MT (or API GL-5 75W-90 alternative)', 'Rear differential — 0.8 L. Symmetrical AWD: every Ascent has both front and rear diffs (no FWD variant). Subaru schedule: inspect every 30,000 mi; change at 60,000 mi for severe duty (towing/dust).'),
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'FMVSS No. 116 DOT 3 or DOT 4', 'Brake fluid — DOT 3 or DOT 4 acceptable per 2020 OM (Subaru does not specify which is preferred). Capacity not published in the OM. 2-year change interval per Subaru maintenance schedule.'),
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R-1234yf', 'A/C refrigerant — Ascent WM ships with R-1234yf per US EPA SNAP regulations. Charge value per under-hood label.');

-- =========================================================================
-- torque_specs — wheel-nut torque is the only torque value in the OM
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 120, 89, NULL, 'Wheel nut torque per 2020 Subaru Ascent OM (Ch. 12 Specifications). Apply in star pattern.');

-- =========================================================================
-- parts — spark plugs per FA24 family
-- =========================================================================
INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, @e_fa24, 'spark_plug', 'SILKFR8A6', 'NGK', 'NGK SILKFR8A6 — laser iridium plug. Standard FA24 OE spark plug per 2020 Subaru Ascent OM. Subaru schedule: 60,000 mi service interval.'),
  (@gen, @e_fa24f, 'spark_plug', 'SILKFR8A6', 'NGK', 'NGK SILKFR8A6 — same OE plug as base FA24 (same combustion chamber + heat range).');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','differential_front','differential_rear','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_subaru FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','differential_front','differential_rear','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_subaru FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_subaru FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');

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

SELECT 'Subaru Ascent WM moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen) AS parts;
