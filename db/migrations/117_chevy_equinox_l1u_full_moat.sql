-- Chevrolet Equinox (L1U) gen 55, 2018-2021 — per-engine moat backfill.
-- Source: 2019 Chevrolet Equinox Owner's Manual (PDF, official Chevrolet
-- content) — saved at scrapers/manuals/2019-chevy-equinox-om.pdf.
--   URL: https://www.chevrolet.com/ownercenter/content/dam/gmownercenter/
--        gmna/dynamic/manuals/2019/Chevrolet/equinox/2019-chevrolet-equinox-
--        owners-manual.pdf
--   Capacities + specs from pp. 378–384 ("Recommended Fluids and Lubricants"
--   and "Capacities and Specifications").
--
-- HaynesPro does NOT catalogue the Equinox L1U (US/CA-only model not in their
-- EU dataset), so this migration uses the OEM owner manual as the primary
-- public source — exactly the workflow CLAUDE.md prescribes for cases where
-- HaynesPro lacks coverage. Cross-verified with the GM Group aggregator (610).
--
-- Engines (4 in our DB):
--   91 LSY  — 2.0L turbo gasoline, 260 Hp (550T AWD MY2020+)
--   92 L3Z  — 1.5L turbo gasoline, 180 Hp (535T)
--   93 LTG  — 2.0L turbo gasoline, 256 Hp (2.0i, early MY 2018-2019)
--   94 LH7  — 1.6L turbo diesel,   139 Hp (1.6d AWD)
--
-- The 2019 Equinox OM lists three engine families: 1.5L (LYX/L3Z), 1.6L
-- diesel (LH7), 2.0L (LTG, later LSY). Capacities differ FWD vs AWD on the
-- gasoline engines — we record the dominant configuration per our trim mix
-- and document both values in the notes field.

SET NAMES utf8mb4;

SET @gen      := 55;
SET @e_lsy    := 91;   -- 2.0L LSY (later 2.0T)
SET @e_l3z    := 92;   -- 1.5L L3Z (LYX-equivalent 1.5T)
SET @e_ltg    := 93;   -- 2.0L LTG (early 2.0T)
SET @e_lh7    := 94;   -- 1.6L LH7 diesel
SET @s_sm     := 321;  -- Chevrolet Equinox (L1U) Service Manual / Owner Manual
SET @s_gm     := 610;  -- GM Group aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','lug_nut')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain','lug_nut');

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter','cabin_filter','fuel_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter','cabin_filter','fuel_filter');

-- =========================================================================
-- engine_oil — per engine. Viscosity + spec varies between gas and diesel.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_lsy, 'engine_oil', 4.7, 5.0, '5W-30', 'GM dexos1 (full synthetic)', '12640445', 7500, 12000, 12,
   '2.0L LSY turbo (550T AWD, MY2020+ replacement for LTG). With-filter sump capacity per 2019 Chevrolet Equinox OM. FWD variant takes 5.0 L; the 550T is AWD-only (4.7 L). Cold-temperature alt: 0W-30 below -29 °C. dexos1 full-synthetic required; substitute ACEA C3 if dexos1 unavailable.'),
  (@gen, @e_l3z, 'engine_oil', 5.0, 5.3, '0W-20', 'GM dexos1 (full synthetic)', '12640445', 7500, 12000, 12,
   '1.5L L3Z turbo (LYX-equivalent — same physical engine, different GM production code). 535T trim. With-filter sump capacity 5.0 L FWD; AWD variant takes 4.0 L. dexos1 full-synthetic required. Honda OE filter PN 12640445 (ACDelco PF64) is shared with the 2.0L gas engines.'),
  (@gen, @e_ltg, 'engine_oil', 4.7, 5.0, '5W-30', 'GM dexos1 (full synthetic)', '12640445', 7500, 12000, 12,
   '2.0L LTG turbo (2.0i, early MY 2018-2019 — replaced by LSY in 2020). With-filter sump capacity 4.7 L AWD / 5.0 L FWD per 2019 Equinox OM. Cold-temperature alt: 0W-30 below -29 °C. dexos1 full-synthetic required.'),
  (@gen, @e_lh7, 'engine_oil', 5.7, 6.0, '5W-30', 'GM dexos2 (low-SAPS diesel)', '55588497', 7500, 12000, 12,
   '1.6L LH7 turbo diesel (1.6d AWD). With-filter sump capacity 5.7 L per 2019 Equinox OM. dexos2 spec REQUIRED — DPF-equipped. Substitute ACEA C3 only if dexos2 unavailable. Cold-temperature alt: 0W-40 below -29 °C. Oil filter PN 55588497 (ACDelco PF2264G).');

-- =========================================================================
-- coolant — DEX-COOL OAT (orange), 50/50 mixture. Per-engine capacities.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_lsy, 'coolant', 7.8, 8.2, 'GM DEX-COOL (orange OAT)', '2.0L LSY — 7.8 L total cooling system per 2019 Equinox OM. DEX-COOL ONLY — do NOT substitute with green silicate IAT or pink VW G13. Initial 150,000 mi service life; subsequent changes every 5 yr / 150k mi per GM schedule.'),
  (@gen, @e_l3z, 'coolant', 6.6, 7.0, 'GM DEX-COOL (orange OAT)', '1.5L L3Z — 6.6 L total cooling system. Smallest engine in the L1U lineup.'),
  (@gen, @e_ltg, 'coolant', 7.8, 8.2, 'GM DEX-COOL (orange OAT)', '2.0L LTG — same 7.8 L cooling system as LSY (chassis-level component, not engine-specific).'),
  (@gen, @e_lh7, 'coolant', 7.5, 7.9, 'GM DEX-COOL (orange OAT)', '1.6L LH7 diesel — 7.5 L total cooling system. Includes EGR cooler + DPF heat-exchanger loop.');

-- =========================================================================
-- transmission_at — GM 9T50 9-speed AT, DEXRON-VI ATF. Capacity not in OM
-- (service-only spec); leave NULL with explanatory note.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'GM DEXRON-VI Automatic Transmission Fluid', 'GM 9T50 9-speed automatic transmission. Total system capacity is service-only spec — owner OM lists DEXRON-VI requirement without numeric capacity. Refer to service manual for full-fill volume.');

-- =========================================================================
-- gen-wide: brake fluid + transfer case (AWD) + A/C
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 3 (GM PN 19353126)', 'Brake reservoir capacity. GM specifies DOT 3 for the L1U; DOT 4 is acceptable for higher-temp track use but not OE. 3-year change interval per GM schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 0.8, 0.85, 'GM Transfer Case Fluid (PN 88900401)', 'AWD transfer case (Twinster-family, BorgWarner). 0.8 L total per 2019 Equinox OM. Sealed unit — service only at major intervals or per owner manual conditions.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'See refrigerant label under hood (R-1234yf on later production)', 'A/C refrigerant type and charge — per the 2019 OM, see under-hood label. L1U production transitioned from R-134a to R-1234yf per US EPA SNAP regulations during the gen run.');

-- =========================================================================
-- torque_specs — wheel-nut torque (gen-wide). Engine oil drain plug torque
-- not specified in the OM (GM publishes that only in the dealer service manual).
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 140, 100, NULL, 'Wheel nut torque per 2019 Equinox OM. Apply in star pattern with the vehicle on the ground (or torque to ~70 Nm on a jack, then re-torque to 140 Nm with all wheels on the ground).');

-- =========================================================================
-- parts — per-engine oil filter, air filter, spark plugs. From 2019 OM
-- "Maintenance Replacement Parts" table.
-- =========================================================================
INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @e_lsy, 'oil_filter', '12640445', 'GM (ACDelco PF64)', NULL, '2.0L gas oil filter — shared between 1.5L L3Z and both 2.0L variants (LSY, LTG).'),
  (@gen, @e_l3z, 'oil_filter', '12640445', 'GM (ACDelco PF64)', NULL, '1.5L gas oil filter — shared across all L1U gasoline engines.'),
  (@gen, @e_ltg, 'oil_filter', '12640445', 'GM (ACDelco PF64)', NULL, '2.0L LTG gas oil filter — same as LSY.'),
  (@gen, @e_lh7, 'oil_filter', '55588497', 'GM (ACDelco PF2264G)', NULL, '1.6L diesel oil filter — DIFFERENT from gas filter (different housing).'),
  (@gen, @e_lsy, 'spark_plug', '12647827', 'GM (ACDelco 41-125)', 0.825, '2.0L gas spark plug. Gap 0.75–0.90 mm.'),
  (@gen, @e_l3z, 'spark_plug', '12673527', 'GM (ACDelco 41-153)', 0.65, '1.5L gas spark plug. Gap 0.60–0.70 mm — narrower than 2.0L; do not substitute.'),
  (@gen, @e_ltg, 'spark_plug', '12647827', 'GM (ACDelco 41-125)', 0.825, '2.0L LTG spark plug — same as LSY.'),
  (@gen, @e_lh7, 'fuel_filter', '84186990', 'GM (ACDelco TP1016)', NULL, '1.6L diesel fuel filter. Service interval per Maintenance Schedule.'),
  (@gen, NULL, 'air_filter', '23279657', 'GM (ACDelco A3226C)', NULL, 'Engine air filter — same PN across all four L1U engines.'),
  (@gen, NULL, 'cabin_filter', '13508023', 'GM (ACDelco CF185)', NULL, 'Passenger compartment (cabin) air filter — gen-wide.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_gm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_gm FROM torque_specs WHERE generation_id=@gen AND fastener IN ('lug_nut');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter','cabin_filter','fuel_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_gm FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter','cabin_filter','fuel_filter');

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

SELECT 'Chevrolet Equinox L1U moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen) AS parts;
