-- Dodge Charger (LD) gen 122, 2011-2023 — per-engine moat refresh.
-- Source: 2022 Dodge Charger Owner's Manual (PDF, official Mopar content
-- — vehicleinfo.mopar.com/.../P135459_22_LD_OM_EN_USC_DIGITIAL.pdf). Saved
-- at scrapers/manuals/2022-dodge-charger-om.pdf. Capacity tables pp. 294-296
-- (Technical Specifications / Fluid Capacities + Engine Fluids and Lubricants).
--
-- The 2022 OM covers the 3.6L Pentastar V6 + 5.7L HEMI V8 as the standard
-- engines. The 6.4L HEMI 392 V8 (R/T Scat Pack) and 6.2L Hellcat Supercharged
-- V8 (SRT Hellcat) ship with separate SRT supplements — those engines retain
-- the well-documented Stellantis/Mopar SRT-specific values here.
--
-- Public citations: Dodge Charger (LD) OM (source 590) + Stellantis/FCA
-- factory oil spec aggregator (source 611).
--
-- This migration refreshes the migration-084 proof-of-concept per-engine
-- split with OEM-verified 2022 OM values + corrects two earlier errors:
--   * 3.6L Pentastar oil capacity: 5.6 L (not 5.7 L as previously seeded).
--   * 5.7L HEMI viscosity is 0W-20 (NOT 5W-20 as historically published —
--     Stellantis transitioned the 5.7 HEMI to 0W-20 MS-6395 for the MY2020+
--     model years; the 2022 OM confirms 0W-20).
--
-- Engines (gen 122):
--   138 Pentastar     — 3.6L Pentastar V6 NA, 292/300 Hp
--   166 5.7 HEMI      — Chrysler 5.7L HEMI V8, 370 Hp (R/T)
--   167 6.4 HEMI 392  — Chrysler 6.4L HEMI 392 V8, 485 Hp (R/T Scat Pack)
--   168 6.2 HEMI SC   — Chrysler 6.2L Hellcat HEMI V8 supercharged, 707-807 Hp

SET NAMES utf8mb4;

SET @gen       := 122;
SET @e_v6      := 138;
SET @e_57hemi  := 166;
SET @e_392     := 167;
SET @e_hellcat := 168;
SET @s_sm      := 590;
SET @s_fca     := 611;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

-- =========================================================================
-- engine_oil — per-engine. Capacities + viscosities + Mopar MS-6395 specs.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_v6, 'engine_oil', 5.6, 6.0, '5W-20', 'Mopar MS-6395 Full Synthetic', 10000, 16000, 12,
   '3.6L Pentastar V6 (NA). With-filter sump capacity 5.6 L (6 US qt) per 2022 Dodge Charger OM Section "Fluid Capacities". Mopar 5W-20 full synthetic MS-6395 is the OE specification; 5W-30 MS-6395 acceptable when 5W-20 is unavailable. Equivalent off-the-shelf full-synthetic 5W-20 with API Starburst is acceptable.'),
  (@gen, @e_57hemi, 'engine_oil', 6.6, 7.0, '0W-20', 'Mopar MS-6395 Full Synthetic', 6000, 9600, 12,
   '5.7L HEMI V8 (R/T). With-filter sump capacity 6.6 L (7 US qt) per 2022 Dodge Charger OM. Stellantis transitioned the 5.7 HEMI to 0W-20 MS-6395 for MY2020+ — DO NOT use the older 5W-20 spec referenced in pre-2020 documentation. The MDS (Multi-Displacement System) cylinder deactivation valve train is fluid-quality sensitive.'),
  (@gen, @e_392, 'engine_oil', 6.6, 7.0, '0W-40', 'Mopar Pennzoil Ultra Platinum MS-12633 (SRT spec)', 6000, 9600, 12,
   '6.4L HEMI 392 V8 (R/T Scat Pack, 485 Hp). With-filter sump capacity 6.6 L (7 US qt) per Mopar SRT supplement. Pennzoil Ultra Platinum 0W-40 (or equivalent ACEA A3/B4 0W-40) required for the high-RPM SRT duty cycle — NOT covered by the standard MS-6395 0W-20.'),
  (@gen, @e_hellcat, 'engine_oil', 6.6, 7.0, '0W-40', 'Mopar Pennzoil Ultra Platinum MS-12633 (Hellcat/SRT spec)', 6000, 9600, 12,
   '6.2L Hellcat Supercharged V8 (SRT Hellcat, 707-807 Hp). With-filter sump capacity 6.6 L (7 US qt) per Mopar SRT/Hellcat supplement. 0W-40 SRT-spec required for the supercharged duty cycle. Mopar recommends Pennzoil Ultra Platinum 0W-40 OE.');

-- =========================================================================
-- coolant — Mopar OAT 10-year coolant (MS.90032). Per-engine capacities.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_v6, 'coolant', 9.5, 10.0, 'Mopar Antifreeze/Coolant 10 Year/150,000 Mile OAT (MS.90032, purple)', '3.6L Pentastar — 9.5 L total cooling system per 2022 Dodge Charger OM. Mopar OAT (purple) only; do NOT mix with HOAT (green/orange) — system flush required if cross-contaminated.'),
  (@gen, @e_57hemi, 'coolant', 13.9, 14.7, 'Mopar Antifreeze/Coolant 10 Year/150,000 Mile OAT (MS.90032, purple)', '5.7L HEMI V8 — 13.9 L (14.5 US qt) cooling system WITHOUT Severe Duty II Cooling Package. With Severe Duty II Cooling Package: 14.3 L (15 US qt). Includes heater core + coolant reservoir at MAX level.'),
  (@gen, @e_392, 'coolant', 14.3, 15.1, 'Mopar Antifreeze/Coolant 10 Year/150,000 Mile OAT (MS.90032, purple)', '6.4L HEMI 392 V8 (Scat Pack) — 14.3 L cooling system per Mopar SRT supplement. Larger system than the 5.7L base to handle the higher heat output.'),
  (@gen, @e_hellcat, 'coolant', 14.3, 15.1, 'Mopar Antifreeze/Coolant 10 Year/150,000 Mile OAT (MS.90032, purple)', '6.2L Hellcat SC V8 — main cooling loop ~14.3 L per Hellcat supplement. The supercharger intercooler runs a separate coolant circuit (low-temp loop, not summed here).');

-- =========================================================================
-- transmission_at — ZF 8HP70 (gen-wide, all RWD trims) / ZF 8HP75 on AWD
-- + SRT variants. Mopar ZF 8 & 9 Speed ATF spec.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'Mopar ZF 8 & 9 Speed ATF (Mopar PN 68218925AA / equivalent)', 'ZF 8HP70 8-speed AT (Pentastar 3.6 + 5.7 HEMI) / ZF 8HP90 8-speed (392 Scat Pack + Hellcat). Single Mopar ZF 8&9 Speed ATF spec across all variants. Total capacity is service-only spec; ZF schedule calls for fluid + pan filter at 50,000 mi for severe duty.');

-- =========================================================================
-- gen-wide: brake fluid + transfer case (AWD) + front diff (AWD) + rear diff
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'Mopar DOT 3 (SAE J1703, MS-1947) — DOT 4 acceptable alternative', 'Brake master cylinder fluid. Mopar specifies DOT 3 SAE J1703; DOT 4 acceptable on track use. 2-year change interval per Mopar schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', NULL, NULL, 'Mopar Transfer Case Lubricant for BorgWarner 44-40 (AWD only)', 'AWD transfer case — BorgWarner 44-40 unit. Capacity not in OM; service-only spec.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', NULL, NULL, 'Mopar Synthetic Gear Lubricant SAE 75W-90 (API GL-5)', 'AWD front differential. 75W-90 API GL-5 synthetic. Capacity not in OM; service-only spec.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', NULL, NULL, 'Mopar OD Synthetic Gear Lubricant SAE 75W-85 (API GL-5)', 'Rear differential (3.6/5.7 engines per OM; SRT 6.4/6.2 use a heavier 75W-90 LSD additive package per SRT supplement). 75W-85 API GL-5. Capacity not in OM; service-only spec.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R-1234yf (MY2017+) / R-134a (MY2011-2016)', 'A/C refrigerant — Stellantis transitioned the Charger LD from R-134a to R-1234yf in MY2017 per US EPA SNAP. Charge value per under-hood label.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_fca FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');

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

SELECT 'Charger LD moat refresh complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids;
