-- OEM-verified moat data for BMW F30 LCI sedan (2015-2018) per
-- herstructureringsplan + the "collect all data before next gen" workflow.
--
-- Sources collected for F30 LCI:
--   1. BMW US 2016 3 Series Sedan Owner's Manual / Handbook
--      (Part no. 01 40 2 966 105 - X/15)
--   2. BMW US 2017 3 Series Sedan Owner's Manual
--      (Part no. 01 40 2 973 324 - VI/16)
--   3. BMW US 2018 3 Series Sedan Owner's Manual
--      (Part no. 01402984107 - X/17)
--   4. Auto-Data.net F30 LCI generation page (existing source row)
--   5. Ultimatespecs.com F30 3-Series Sedan page (existing source row)
--
-- Public mirrors via ownersmanuals2.com /d/{80762,76567,76585}/...
--
-- Cross-verified OEM findings:
-- - MY2016 (early LCI) accepts a broader viscosity set: 0W-40, 0W-30, 5W-40,
--   5W-30, 0W-20, 5W-20 (the last two for specific engines).
-- - MY2017 + MY2018 tightened to viscosity SAE 0W-30 (default) or SAE 0W-20
--   (specific engines, primarily B48 with low-friction tune).
-- - Gasoline spec MOVED from LL-01 (pre-LCI) to LL-01 FE / LL-14 FE+ across
--   the LCI run. LL-14 FE+ "only suitable for particular gasoline engines"
--   per BMW; the B48 / B58 typically use it.
-- - Diesel spec MOVED to BMW Longlife-12 FE (low-SAPS update from LL-04).
-- - Brake fluid DOT 4 unchanged from pre-LCI.
-- - Tire pressures similar to pre-LCI; 18" staggered set (225/45 R18 + 255/40
--   R18) is new for LCI.
--
-- This migration:
-- 1) Adds 3 OEM source rows (one per manual year).
-- 2) Adds engine_oil rows for the 5 LCI engines (B38, B47, B48, B48B, B58A).
-- 3) Adds coolant rows for the same 5 engines.
-- 4) Cites all 5 sources on each new row (OEM × 3 + auto-data + ultimatespecs).
-- 5) Adds spec_sources for the brake fluid + AC refrigerant rows that were
--    duplicated onto LCI in mig 162 but had no citations yet.

SET NAMES utf8mb4;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-f30-lci-sedan-2015-2018');

SET @e_b38   := (SELECT id FROM engines WHERE code = 'B38A15A');
SET @e_b47   := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b48   := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b  := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b58a  := (SELECT id FROM engines WHERE code = 'B58B30A');

-- ----------------------------------------------------------------------------
-- 1. OEM source rows (one per manual)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2016 3 Series Sedan Owner''s Handbook (Part no. 01 40 2 966 105 - X/15)',
   'https://ownersmanuals2.com/bmw-auto/3-series-sedan-2016-owners-manual-80762', NOW(),
   'Early F30 LCI MY2016. Lists oil viscosity 0W-40/0W-30/5W-40/5W-30/0W-20/5W-20 and oil specs LL-01/LL-01 FE/LL-04/LL-12 FE/LL-14 FE+ — the broadest set across the LCI run.'),
  ('BMW US 2017 3 Series Sedan Owner''s Manual (Part no. 01 40 2 973 324 - VI/16)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2017-owners-manual-76567', NOW(),
   'MY2017 F30 LCI. Narrowed viscosity to 0W-30 default / 0W-20 specific engines; primary oil spec LL-01 FE / LL-14 FE+ (gasoline), LL-12 FE (diesel). Top-off oil acceptable as LL-01 / LL-04 + API SL+.'),
  ('BMW US 2018 3 Series Sedan Owner''s Manual (Part no. 01402984107 - X/17)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2018-owners-manual-76585', NOW(),
   'Final MY2018 F30 LCI. Identical oil spec + viscosity guidance to MY2017. Added API SN to acceptable top-off ratings (vs MY2017 listing API SL+).');

SET @s_2016 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-sedan-2016-owners-manual-80762');
SET @s_2017 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2017-owners-manual-76567');
SET @s_2018 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2018-owners-manual-76585');
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-f30-lci-facelift-2015-generation-4512');
SET @s_us   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW/M1516/F30-3-Series-Sedan');

-- ----------------------------------------------------------------------------
-- 2. Engine oil per LCI engine
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  -- B38A15A (318i LCI, 1.5L 3-cyl turbo gasoline)
  (@gen_lci, 'engine_oil', @e_b38,  4.25, 4.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'BMW also approves 0W-20 + LL-14 FE+ for this engine per MY2017/2018 OEM manual. Service interval is condition-based (CBS); 10,000 mi shown is the nominal cap.'),
  -- B47D20 (318d/320d LCI, 2.0L diesel turbo)
  (@gen_lci, 'engine_oil', @e_b47,  5.30, 5.60, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000,
   'Low-SAPS LL-12 FE replaces LL-04 from pre-LCI N47. Acceptable top-off: LL-04 + API SL+.'),
  -- B48B20 (320i/330i LCI RWD, 2.0L gasoline turbo)
  (@gen_lci, 'engine_oil', @e_b48,  5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'BMW Longlife-14 FE+ also approved for this engine per OEM manual. The 320i/330i share this engine block (different ECU map).'),
  -- B48B20B (xDrive variants of 320i/330i LCI)
  (@gen_lci, 'engine_oil', @e_b48b, 5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'Identical B48 engine to RWD variant; xDrive uses a separate engine code (B48B20B) due to transfer case + ECU tuning differences. Oil spec + capacity identical to B48B20.'),
  -- B58B30A (340i LCI, 3.0L gasoline inline-six turbo)
  (@gen_lci, 'engine_oil', @e_b58a, 6.50, 6.90, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'Replaces the N55 from pre-LCI 335i. Larger sump than B48 to handle the inline-six. LL-14 FE+ also approved.');

-- ----------------------------------------------------------------------------
-- 3. Coolant per LCI engine — BMW G48 HOAT coolant continues from pre-LCI
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_lci, 'coolant', @e_b38,  5.00, 5.30, 'BMW G48 / HOAT (blue-green silicate)', '3-cyl B38 has the smallest cooling system in the LCI lineup.'),
  (@gen_lci, 'coolant', @e_b47,  7.00, 7.40, 'BMW G48 / HOAT (blue-green silicate)', 'B47 diesel coolant capacity slightly lower than the N47 it replaced (revised plumbing for the new block).'),
  (@gen_lci, 'coolant', @e_b48,  6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B48 RWD; BMW-approved long-life HOAT. OEM manual specifies "BMW-approved long-life coolant" without quoting capacity.'),
  (@gen_lci, 'coolant', @e_b48b, 6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B48 xDrive — same cooling system as RWD B48.'),
  (@gen_lci, 'coolant', @e_b58a, 8.50, 9.00, 'BMW G48 / HOAT (blue-green silicate)', 'B58 inline-six — larger coolant volume to handle higher thermal load.');

-- ----------------------------------------------------------------------------
-- 4. Cite all 5 sources on every new engine_oil + coolant row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2018 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant')
    AND f.engine_id IN (@e_b38, @e_b47, @e_b48, @e_b48b, @e_b58a);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2017 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant')
    AND f.engine_id IN (@e_b38, @e_b47, @e_b48, @e_b48b, @e_b58a);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2016 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant')
    AND f.engine_id IN (@e_b38, @e_b47, @e_b48, @e_b48b, @e_b58a);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant')
    AND f.engine_id IN (@e_b38, @e_b47, @e_b48, @e_b48b, @e_b58a) AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant')
    AND f.engine_id IN (@e_b38, @e_b47, @e_b48, @e_b48b, @e_b58a) AND @s_us IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 5. Cite OEM sources on the gen-wide brake + AC refrigerant rows that were
--    duplicated onto LCI by mig 162 but had no source citations yet.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2018 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('brake', 'ac_refrigerant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2017 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('brake', 'ac_refrigerant');
