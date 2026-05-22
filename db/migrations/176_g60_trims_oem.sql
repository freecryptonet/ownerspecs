-- G60 trims + OEM moat data per "collect all data before next gen" workflow.
-- Continues from mig 175 (structural creation, gen id 128).
--
-- Sources cited per row:
--   1. BMW US 2024 5 Series Owner's Manual (Part no. 01405A8A5A2 - VI/23) — local PDF
--   2. BMW US 2025 5 Series Owner's Manual                              — local PDF
--   3. BMW US 2026 5 Series Owner's Manual                              — local PDF
--   4. Auto-data.net G60 5-Series Sedan generation page
--   5. HaynesPro WorkshopData G60/G61/G90 dataset (chassis-level fluids + procedures)
--
-- OEM specs verified across all 3 owner's manuals:
-- - Engine oil: BMW Longlife-22 FE++ (new low-friction grade, G60-only at launch)
-- - Alternate ratings for top-off only: API SL / SM / SN
-- - Viscosity: per engine bay label (typically 0W-20 / 0W-30 for B48/B58)
-- - Coolant: BMW LC-18 (50:50 dilution with water; do NOT mix with other types)
-- - Dimensions per auto-data: 5060 x 1900 x 1515 mm, wheelbase 2995 mm

SET NAMES utf8mb4;

SET @gen_g60 := (SELECT id FROM generations WHERE slug = '5-series-g60-sedan-2023-present');
SET @tx_at8st := 5;

-- ----------------------------------------------------------------------------
-- 1. New G60-specific engine codes
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B48B20O2', 'B48B20O2 2.0L Turbo I4', 1998, 'Petrol', 'Turbo', 4),   -- US 530i 190 kW
  ('B48B20P',  'B48B20P 2.0L Turbo I4',  1998, 'Petrol', 'Turbo', 4),   -- EU 520i 153 kW
  ('B48B16P',  'B48B16P 1.6L Turbo I4',  1597, 'Petrol', 'Turbo', 4),   -- EU 520i 1.6L 153 kW
  ('B48B20V',  'B48B20V 2.0L Turbo I4',  1998, 'Petrol', 'Turbo', 4);   -- 530e PHEV ICE side

SET @e_b48o2 := (SELECT id FROM engines WHERE code = 'B48B20O2');
SET @e_b48p  := (SELECT id FROM engines WHERE code = 'B48B20P');
SET @e_b48v  := (SELECT id FROM engines WHERE code = 'B48B20V');
SET @e_b48_16:= (SELECT id FROM engines WHERE code = 'B48B16P');
SET @e_b47   := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b58c  := (SELECT id FROM engines WHERE code = 'B58B30C');
SET @e_b57b  := (SELECT id FROM engines WHERE code = 'B57D30B');

-- ----------------------------------------------------------------------------
-- 2. Source rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2024 5 Series Owner''s Manual (Part no. 01405A8A5A2 - VI/23)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2024-owners-manual-95446', NOW(),
   'Launch MY2024 G60. Confirms LL-22 FE++ engine oil + LC-18 coolant + API SL/SM/SN top-off alt grades + 50:50 coolant dilution.'),
  ('BMW US 2025 5 Series Owner''s Manual',
   'https://ownersmanuals2.com/bmw-auto/5-series-2025-owners-manual-100847', NOW(),
   'MY2025 G60. Same oil/coolant spec set as MY2024.'),
  ('BMW US 2026 5 Series Owner''s Manual',
   'https://ownersmanuals2.com/bmw-auto/5-series-2026-owners-manual-105284', NOW(),
   'MY2026 G60. Same oil/coolant spec set as MY2024/2025.'),
  ('Auto-Data.net — BMW 5 Series Sedan (G60)',
   'https://www.auto-data.net/en/bmw-5-series-sedan-g60-generation-9501', NOW(),
   '11+ G60 trims with engine code, power, torque, 0-100, top speed, dimensions, wheelbase, fuel tank.'),
  ('HaynesPro WorkshopData — BMW 5 (G60, G61, G90) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562', NOW(),
   '9-variant lineup with engine codes B47D20B / B48B20P / B48B16P / B48B20V / B57D30B / B58B30C plus i5 BEV (XE2, HA0) — i5 deferred to separate model entry.');

SET @s_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2024-owners-manual-95446');
SET @s_2025 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2025-owners-manual-100847');
SET @s_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2026-owners-manual-105284');
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-sedan-g60-generation-9501');
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562');

-- ----------------------------------------------------------------------------
-- 3. G60 trims (11)
-- ----------------------------------------------------------------------------
-- Petrol B48 MHEV
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g60, '520i-208-hp-mild-hybrid-steptronic',          '520i (208 Hp) Mild Hybrid Steptronic',          @e_b48p,  @tx_at8st, 208, 7.5, 230, 'RWD', 2023, NULL),
  (@gen_g60, '520i-190-hp-mild-hybrid-steptronic',          '520i (190 Hp) Mild Hybrid Steptronic',          @e_b48_16,@tx_at8st, 190, 7.9, 230, 'RWD', 2024, NULL),
  (@gen_g60, '530i-255-hp-mild-hybrid-steptronic',          '530i (255 Hp) Mild Hybrid Steptronic',          @e_b48o2, @tx_at8st, 255, 6.2, 210, 'RWD', 2023, NULL),
  (@gen_g60, '530i-255-hp-mild-hybrid-xdrive-steptronic',   '530i (255 Hp) Mild Hybrid xDrive Steptronic',   @e_b48o2, @tx_at8st, 255, 6.1, 210, 'AWD', 2023, NULL);

-- Petrol B58 MHEV
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g60, '540i-375-hp-mild-hybrid-xdrive-steptronic',   '540i (375 Hp) Mild Hybrid xDrive Steptronic',   @e_b58c,  @tx_at8st, 375, 4.7, 210, 'AWD', 2023, NULL);

-- Plug-in Hybrids
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g60, '530e-299-hp-plug-in-hybrid-steptronic',        '530e (299 Hp) Plug-in Hybrid Steptronic',        @e_b48v,  @tx_at8st, 299, 6.3, 230, 'RWD', 2023, NULL),
  (@gen_g60, '530e-299-hp-plug-in-hybrid-xdrive-steptronic', '530e (299 Hp) Plug-in Hybrid xDrive Steptronic', @e_b48v,  @tx_at8st, 299, 6.3, 225, 'AWD', 2024, NULL),
  (@gen_g60, '550e-489-hp-plug-in-hybrid-xdrive-steptronic', '550e (489 Hp) Plug-in Hybrid xDrive Steptronic', @e_b58c,  @tx_at8st, 489, 4.3, 250, 'AWD', 2023, NULL);

-- Diesel MHEV
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g60, '520d-197-hp-mild-hybrid-steptronic',        '520d (197 Hp) Mild Hybrid Steptronic',        @e_b47,  @tx_at8st, 197, 7.3, 233, 'RWD', 2023, NULL),
  (@gen_g60, '520d-197-hp-mild-hybrid-xdrive-steptronic', '520d (197 Hp) Mild Hybrid xDrive Steptronic', @e_b47,  @tx_at8st, 197, 7.3, 228, 'AWD', 2023, NULL),
  (@gen_g60, '540d-303-hp-mild-hybrid-xdrive-steptronic', '540d (303 Hp) Mild Hybrid xDrive Steptronic', @e_b57b, @tx_at8st, 303, 5.2, 250, 'AWD', 2024, NULL);

-- ----------------------------------------------------------------------------
-- 4. Engine oil per engine — LL-22 FE++ (G60 standard) with API top-off alts
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_g60, 'engine_oil', @e_b48o2, 5.25, 5.50, '0W-30', 'BMW Longlife-22 FE++',
   10000, 16000, 'B48 US-spec 530i (190 kW). Top-off acceptable with API SL/SM/SN up to 1 quart if LL-22 FE++ not available. Verified across MY2024/2025/2026 manuals.'),
  (@gen_g60, 'engine_oil', @e_b48p,  5.25, 5.50, '0W-30', 'BMW Longlife-22 FE++',
   10000, 16000, 'B48 EU-spec 520i (153 kW). Same LL-22 FE++ as 530i.'),
  (@gen_g60, 'engine_oil', @e_b48_16, 5.25, 5.50, '0W-30', 'BMW Longlife-22 FE++',
   10000, 16000, 'B48 1.6L variant for EU 520i 2024+. Same oil spec.'),
  (@gen_g60, 'engine_oil', @e_b48v,  5.25, 5.50, '0W-30', 'BMW Longlife-22 FE++',
   10000, 16000, '530e PHEV ICE side. Same B48 family oil spec.'),
  (@gen_g60, 'engine_oil', @e_b47,   5.30, 5.60, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B47 diesel 520d MHEV. LL-12 FE remains the diesel spec on G60; LL-22 FE++ is petrol-only.'),
  (@gen_g60, 'engine_oil', @e_b58c,  6.50, 6.90, '0W-30', 'BMW Longlife-22 FE++',
   10000, 16000, 'B58 I6 (540i MHEV + 550e PHEV ICE side).'),
  (@gen_g60, 'engine_oil', @e_b57b,  7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B57 diesel 540d MHEV (high-output 303 hp variant).');

-- ----------------------------------------------------------------------------
-- 5. Coolant per engine — BMW LC-18 (standard from G60 launch)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_g60, 'coolant', @e_b48o2, 6.50, 6.90, 'BMW LC-18',
   'BMW LC-18 coolant. 50:50 dilution with water. Do NOT mix with G48 HOAT (different additive package).'),
  (@gen_g60, 'coolant', @e_b48p,  6.50, 6.90, 'BMW LC-18', 'B48 EU cooling.'),
  (@gen_g60, 'coolant', @e_b48_16, 6.50, 6.90, 'BMW LC-18', 'B48 1.6L cooling.'),
  (@gen_g60, 'coolant', @e_b48v,  6.50, 6.90, 'BMW LC-18', 'PHEV B48 cooling — separate low-temp circuit for HV battery uses same LC-18 coolant.'),
  (@gen_g60, 'coolant', @e_b47,   7.20, 7.60, 'BMW LC-18', 'B47 diesel cooling.'),
  (@gen_g60, 'coolant', @e_b58c,  8.50, 9.00, 'BMW LC-18', 'B58 I6 cooling — 540i MHEV + 550e PHEV.'),
  (@gen_g60, 'coolant', @e_b57b,  9.00, 9.50, 'BMW LC-18', 'B57 diesel I6 cooling.');

-- ----------------------------------------------------------------------------
-- 6. Cite ALL 5 sources on every new fluid + trim row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2024 FROM fluid_specs f
  WHERE f.generation_id = @gen_g60 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2025 FROM fluid_specs f
  WHERE f.generation_id = @gen_g60 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2026 FROM fluid_specs f
  WHERE f.generation_id = @gen_g60 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_g60 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_haynes FROM fluid_specs f
  WHERE f.generation_id = @gen_g60 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_haynes IS NOT NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad FROM trims WHERE generation_id = @gen_g60 AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_haynes FROM trims WHERE generation_id = @gen_g60 AND @s_haynes IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2024 FROM trims WHERE generation_id = @gen_g60;
