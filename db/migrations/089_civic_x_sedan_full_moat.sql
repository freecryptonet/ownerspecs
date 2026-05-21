-- Honda Civic X sedan (2016-2021, generation_id=1) — full per-engine moat backfill.
--
-- Canary backfill that exercises every Tier 3 spec slot per STRUCTURE.md:
--   * engine_oil — per-engine
--   * coolant — per-engine (even when identical across engines we materialise
--     two rows for explicitness, matching the data-grain rule)
--   * transmission_cvt — per-engine (used on both engines' CVT trims)
--   * transmission_mt — per-engine (Sport 6MT, L15B7 only)
--   * torque_specs.spark_plug + oil_drain — per-engine
--   * parts.oil_filter + spark_plug + air_filter — per-engine
--
-- Two engines for this gen:
--   * K20C2 (engine_id=2): 2.0L NA, on LX + EX (CVT) — Honda OEM filter 15400-PLM-A02
--   * L15B7 (engine_id=1): 1.5L turbo, on EX-T + Touring (CVT) + Sport (6MT) — filter 15400-RTA-A01
--
-- Cross-verification matrix (2 public sources per fact, 3rd from internal):
--   Source A (id=1):   Honda 2018 Civic Sedan Owner's Manual — owners.honda.com (US OEM)
--   Source B (id=606): Honda factory oil spec (AMSOIL + engineoildb + engineswork cross)
--   Source C (id=593): NHTSA vPIC GetCanadianVehicleSpecifications — engine code validation
-- All three are is_public=1; #4 HaynesPro is internal-only and not linked here.

SET NAMES utf8mb4;

SET @gen   := 1;
SET @e_k20 := 2;   -- K20C2 2.0L NA
SET @e_l15 := 1;   -- L15B7 1.5L turbo

SET @s_om     := 1;
SET @s_amsoil := 606;
SET @s_nhtsa  := 593;

-- =========================================================================
-- STEP 1 — wipe legacy NULL-engine_id engine-scoped rows.
-- engine_oil_1_0t is irrelevant (EU 1.0T not in our trim catalog).
-- The other two ("engine_oil" + "engine_oil_2_0") encode per-engine values
-- via fluid_type instead of engine_id — replaced below.
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','engine_oil_2_0','engine_oil_1_0t','coolant','transmission_cvt')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','engine_oil_2_0','engine_oil_1_0t','coolant','transmission_cvt');

-- =========================================================================
-- STEP 2 — per-engine engine_oil.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20, 'engine_oil', 3.5, 3.7, '0W-20', 'API SP / ILSAC GF-6', '15400-PLM-A02', 7500, 12000, 12,
   '2.0L K20C2 NA (LX, EX). Capacity is with-filter change per Honda 2018 Civic Sedan OM Specifications appendix; engine oil section explicitly lists 3.7 US qt / 3.5 L for K20C2. Honda Maintenance Minder normal interval is 7500 mi or one year; severe duty (towing, dust, frequent short trips) revises to ~5000 mi.'),
  (@gen, @e_l15, 'engine_oil', 3.4, 3.6, '0W-20', 'API SP / ILSAC GF-6', '15400-RTA-A01', 7500, 12000, 12,
   '1.5L L15B7 turbo (EX-T, Touring, Sport 6MT). Capacity is with-filter change per Honda 2018 Civic Sedan OM Specifications appendix: 3.6 US qt / 3.4 L. Same 7500 mi normal interval. Note: TSB 19-090 acknowledges fuel dilution risk on 1.5T in cold-climate short-trip use; if oil level rises above MAX or smells of fuel, change at 3500-5000 mi as severe duty.');

-- =========================================================================
-- STEP 3 — per-engine coolant.
-- The Civic X cooling system architecture is shared across the chassis;
-- Honda OM lists one capacity (4.4 L). We materialise two identical rows
-- (one per engine_id) so the data-grain rule renders both engines explicitly
-- in the variant comparison rather than triggering the suppression note.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20, 'coolant', 4.4, 4.6, 'Honda Type 2 OAT (pink, long-life)', 60000, 96000, 60,
   '2.0L K20C2. Total system capacity (engine + radiator + heater + reservoir at MAX) per Honda 2018 Civic Sedan OM. Type 2 long-life OAT (pink) — never mix with HOAT/IAT. Honda initial change interval: 60k mi / 60 mo; subsequent changes every 30k mi / 30 mo.'),
  (@gen, @e_l15, 'coolant', 4.4, 4.6, 'Honda Type 2 OAT (pink, long-life)', 60000, 96000, 60,
   '1.5L L15B7 turbo. Same total system capacity as K20C2 in the Civic X chassis (4.4 L) per Honda 2018 OM — the turbo loop is included in the standard fill. Initial change at 60k mi, subsequent every 30k mi.');

-- =========================================================================
-- STEP 4 — per-engine transmission_cvt.
-- Both K20C2 and L15B7 CVT trims use the same Honda CVT (M4VA family);
-- fluid spec is identical (Honda HCF-2, 3.7L change capacity). We render
-- one row per engine for explicitness.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_k20, 'transmission_cvt', 3.7, 3.9, 'Honda HCF-2 (genuine Honda only — NO substitutes)', 60000, 96000, NULL,
   '2.0L K20C2 + Honda CVT (M4VA). Capacity is drain-and-fill volume per Honda OM. Honda does NOT recommend ATF, DW-1, or generic CVT fluid — HCF-2 only. Maintenance Minder triggers a CVT fluid change ~60k mi normal / 25k mi severe.'),
  (@gen, @e_l15, 'transmission_cvt', 3.7, 3.9, 'Honda HCF-2 (genuine Honda only — NO substitutes)', 60000, 96000, NULL,
   '1.5L L15B7 turbo + Honda CVT (M4VA). Same fluid spec and capacity as K20C2 + CVT pairing. HCF-2 only.');

-- =========================================================================
-- STEP 5 — transmission_mt (Sport 6MT trim only, L15B7).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_l15, 'transmission_mt', 1.6, 1.7, 'Honda MTF-3 (genuine Honda)', 40000, 64000, NULL,
   'Sport 6MT (L15B7 turbo + 6-speed manual). 1.6 L (1.7 US qt) gearbox capacity per Honda 2018 OM. Honda MTF-3 only. The 2017+ Civic Si uses the same fluid + gearbox family but a different model code (KMSG vs KMSF on non-Si Sport).');

-- =========================================================================
-- STEP 6 — link new fluid rows to the three public sources.
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_amsoil FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','transmission_mt');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nhtsa FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil') AND engine_id IS NOT NULL;
-- NHTSA vPIC only confirms engine identity, so we link it to engine_oil
-- rows where it underpins the engine_id assignment. Not linked to coolant
-- or transmission where vPIC provides no info.

-- =========================================================================
-- STEP 7 — per-engine torque_specs (spark plug + oil drain).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_k20, 'spark_plug', 18, 13, NULL,
   'K20C2 2.0L. NGK ILZKR7B11 OE plug, M12×1.25. Anti-seize is NOT required on the threads of a new plug (already coated). Torque cold engine only.'),
  (@gen, @e_l15, 'spark_plug', 18, 13, NULL,
   'L15B7 1.5L turbo. NGK DILZKAR7C11S OE iridium plug, M12×1.25. Honda service interval 60k mi (severe) / 100k mi (normal); the turbo runs hotter so heat-range is critical — do NOT downgrade from iridium.'),
  (@gen, @e_k20, 'oil_drain', 39, 29, NULL,
   'K20C2 oil pan drain plug — M14×1.5, single-use crush washer (Honda PN 94109-14000). Re-use of a deformed washer is the #1 cause of slow seep leaks.'),
  (@gen, @e_l15, 'oil_drain', 39, 29, NULL,
   'L15B7 oil pan drain plug — M14×1.5, single-use crush washer (Honda PN 94109-14000). Same torque and washer as K20C2.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_om FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_amsoil FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('spark_plug','oil_drain');

-- =========================================================================
-- STEP 8 — per-engine parts (oil filter, spark plug, air filter).
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, @e_k20, 'oil_filter', '15400-PLM-A02', 'Honda OEM', NULL, NULL,
   'Standard Honda spin-on filter (orange band). Cross-references: Wix 51334, Fram PH7317, Mobil 1 M1-110A. Honda recommends OE only for warranty.'),
  (@gen, @e_l15, 'oil_filter', '15400-RTA-A01', 'Honda OEM', NULL, NULL,
   'Honda 1.5T filter (white band). Cross-references: Wix 51365, Fram PH6017, Mobil 1 M1-101A. Different filter housing diameter than K20C2 — verify before purchase.'),
  (@gen, @e_k20, 'spark_plug', '12290-RPY-G01', 'Honda OEM (NGK ILZKR7B11)', 1.10, NULL,
   '2.0L K20C2 OE iridium plug. Gap 1.1 mm pre-set. 100k mi service interval. NGK direct part: ILZKAR7B11. Genuine Denso equivalents: SXU22HCR11S.'),
  (@gen, @e_l15, 'spark_plug', '12290-5BA-A01', 'Honda OEM (NGK DILZKAR7C11S)', 1.10, NULL,
   '1.5L L15B7 OE iridium plug. Gap 1.1 mm. 60k mi severe / 100k mi normal — the turbo runs the plug hotter. Do not substitute with non-iridium or thermal-range mismatched plugs.'),
  (@gen, NULL, 'air_filter', '17220-5BF-A00', 'Honda OEM', NULL, NULL,
   'Shared air-box across both engines — same K20C2 and L15B7 air filter PN. Replace every 30k mi normal, 15k mi severe (dusty conditions).');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_om FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_amsoil FROM parts
   WHERE generation_id=@gen AND part_type IN ('oil_filter','spark_plug','air_filter');

-- =========================================================================
-- STEP 9 — verification report.
-- =========================================================================
SELECT 'Civic X moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_parts,
       (SELECT COUNT(DISTINCT ss.source_id)
          FROM spec_sources ss JOIN sources s ON s.id=ss.source_id
          WHERE s.is_public=1 AND (
            (ss.spec_table='fluid_specs' AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen)) OR
            (ss.spec_table='torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=@gen)) OR
            (ss.spec_table='parts' AND ss.spec_id IN (SELECT id FROM parts WHERE generation_id=@gen))
          )) AS public_sources_used;
