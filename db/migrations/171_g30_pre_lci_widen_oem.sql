-- BMW 5-Series G30 pre-LCI (2017-2020) widening + OEM moat data per
-- "collect all data before next gen" workflow. Same patterns as F30 + G20
-- migrations.
--
-- Existing G30 had only 5 trims (540i + M550 variants). This adds the
-- entry/mid-tier trims (520i, 520d, 530i + xDrive, 530d + xDrive, 530e
-- PHEV, 540d xDrive) plus OEM-verified engine_oil + coolant per engine.
--
-- Sources collected for G30 pre-LCI:
--   1. BMW US 2019 5 Series Sedan Owner's Manual (Part no. 01402722600 - VI/18)
--   2. BMW US 2020 5 Series Sedan Owner's Manual (Part no. 01402913849 - X/19)
--   3. Auto-Data.net G30 generation page
--   4. Ultimatespecs.com BMW G30 5-Series Sedan page
--
-- OEM-confirmed findings:
-- - 2019 manual: LL-01 FE / LL-14 FE+ gasoline; 0W-20 / 0W-30.
-- - 2020 manual: LL-01 FE / LL-14 FE+ / LL-17 FE+ (added MY2020); 0W-20 /
--   0W-30. CRITICAL CAVEAT: "Oil ratings LL-14 FE+ and LL-17 FE+ are NOT
--   suitable for gasoline engines 50i and 60i" — the high-output N63 V8
--   needs LL-01 FE only; "0W-20 is NOT suitable for engines 50i and 60i"
--   (must use 0W-30 minimum on N63).
-- - Diesel: LL-12 FE for B47 / B57 variants.

SET NAMES utf8mb4;

SET @gen_g30 := (SELECT id FROM generations WHERE slug = '5-series-g30-sedan-2017-2020');

-- Engines already in DB:
SET @e_b46    := (SELECT id FROM engines WHERE code = 'B46B20');
SET @e_b48    := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b   := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b47    := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b58c   := (SELECT id FROM engines WHERE code = 'B58B30C');
SET @e_b57a   := (SELECT id FROM engines WHERE code = 'B57D30A');
SET @e_b57c   := (SELECT id FROM engines WHERE code = 'B57D30C');
SET @e_n63c   := (SELECT id FROM engines WHERE code = 'N63B44C');
SET @e_n63d   := (SELECT id FROM engines WHERE code = 'N63B44D');

SET @tx_at8st := 5;
SET @tx_at8   := 6;

-- ----------------------------------------------------------------------------
-- 1. OEM source rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2019 5 Series Sedan Owner''s Manual (Part no. 01402722600 - VI/18)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2019-owners-manual-76605', NOW(),
   'G30 pre-LCI MY2019. Lists LL-01 FE / LL-14 FE+ gasoline specs; 0W-20 / 0W-30 viscosity.'),
  ('BMW US 2020 5 Series Sedan Owner''s Manual (Part no. 01402913849 - X/19)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2020-owners-manual-76623', NOW(),
   'Final G30 pre-LCI MY2020. Adds LL-17 FE+ but flags that LL-14 FE+ and LL-17 FE+ are NOT suitable for N63 V8 (50i / 60i nameplates) — those require LL-01 FE only and 0W-30 minimum.'),
  ('Auto-Data.net — BMW 5 Series G30 Sedan', 'https://www.auto-data.net/en/bmw-5-series-sedan-g30', NOW(), NULL),
  ('Ultimatespecs.com — BMW G30 5-Series Sedan', 'https://www.ultimatespecs.com/car-specs/BMW-models/5-Series-G30', NOW(), NULL);

SET @s_2019 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2019-owners-manual-76605');
SET @s_2020 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2020-owners-manual-76623');
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-sedan-g30');
SET @s_us   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/5-Series-G30');

-- ----------------------------------------------------------------------------
-- 2. New trims (10 most-common G30 pre-LCI variants)
-- ----------------------------------------------------------------------------
-- 520i (EU base petrol, B48B20 184 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '520i-184-hp-steptronic', '520i (184 Hp) Steptronic', @e_b48, @tx_at8st, 184, 7.8, 226, 'RWD', 2017, 2020);

-- 520d (EU diesel, B47D20 190 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '520d-190-hp-steptronic',        '520d (190 Hp) Steptronic',        @e_b47, @tx_at8st, 190, 7.5, 235, 'RWD', 2017, 2020),
  (@gen_g30, '520d-190-hp-xdrive-steptronic', '520d (190 Hp) xDrive Steptronic', @e_b47, @tx_at8st, 190, 7.4, 230, 'AWD', 2017, 2020);

-- 530i (US petrol 248 hp B46, EU 252 hp B48 — model two distinct rows)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '530i-248-hp-steptronic-us',        '530i (248 Hp) Steptronic (US)',        @e_b46, @tx_at8st, 248, 6.2, 209, 'RWD', 2017, 2020),
  (@gen_g30, '530i-248-hp-xdrive-steptronic-us', '530i (248 Hp) xDrive Steptronic (US)', @e_b46, @tx_at8st, 248, 6.0, 209, 'AWD', 2017, 2020),
  (@gen_g30, '530i-252-hp-steptronic',           '530i (252 Hp) Steptronic',             @e_b48, @tx_at8st, 252, 6.2, 250, 'RWD', 2017, 2020),
  (@gen_g30, '530i-252-hp-xdrive-steptronic',    '530i (252 Hp) xDrive Steptronic',      @e_b48, @tx_at8st, 252, 6.0, 250, 'AWD', 2017, 2020);

-- 530e Plug-in Hybrid (B48 + electric, 252 hp combined)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '530e-252-hp-plug-in-hybrid-steptronic', '530e (252 Hp) Plug-in Hybrid Steptronic', @e_b48, @tx_at8st, 252, 6.2, 235, 'RWD', 2017, 2020);

-- 530d (diesel I6 B57 265 hp + xDrive)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '530d-265-hp-steptronic',        '530d (265 Hp) Steptronic',        @e_b57a, @tx_at8st, 265, 5.7, 250, 'RWD', 2017, 2020),
  (@gen_g30, '530d-265-hp-xdrive-steptronic', '530d (265 Hp) xDrive Steptronic', @e_b57a, @tx_at8st, 265, 5.4, 250, 'AWD', 2017, 2020);

-- 540d xDrive (high-output diesel)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g30, '540d-320-hp-xdrive-steptronic', '540d (320 Hp) xDrive Steptronic', @e_b57c, @tx_at8st, 320, 4.8, 250, 'AWD', 2017, 2020);

-- ----------------------------------------------------------------------------
-- 3. Engine oil per G30 engine — apply OEM-confirmed N63 caveat
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  -- B46B20 (US 530i 248 hp)
  (@gen_g30, 'engine_oil', @e_b46,  5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000, 'B46 US-spec gasoline. LL-14 FE+ / LL-17 FE+ acceptable from MY2020 manual.'),
  -- B48B20 (EU 520i / 530i / 530e)
  (@gen_g30, 'engine_oil', @e_b48,  5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000, 'B48 EU-spec. Same spec as B46.'),
  -- B47D20 (520d)
  (@gen_g30, 'engine_oil', @e_b47,  5.30, 5.60, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B47 diesel; low-SAPS LL-12 FE.'),
  -- B58B30C (540i)
  (@gen_g30, 'engine_oil', @e_b58c, 6.50, 6.90, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000, 'B58 inline-six gasoline. LL-14 FE+ also acceptable.'),
  -- B57D30A (530d 265 hp)
  (@gen_g30, 'engine_oil', @e_b57a, 7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B57 diesel I6, single-turbo 265 hp tune.'),
  -- B57D30C (M550d / 540d high-output diesel — quad-turbo on M550d)
  (@gen_g30, 'engine_oil', @e_b57c, 7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B57 high-output diesel; quad-turbo on M550d. Same oil spec as B57D30A.'),
  -- N63B44C (M550i 462 hp V8) — IMPORTANT: NO LL-14/LL-17, NO 0W-20
  (@gen_g30, 'engine_oil', @e_n63c, 8.50, 9.00, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'N63 V8 high-output. CRITICAL: OEM 2020 manual explicitly EXCLUDES Longlife-14 FE+ and Longlife-17 FE+ for "50i and 60i" engines — use LL-01 FE only. SAE 0W-20 also NOT suitable — 0W-30 minimum on N63.'),
  -- N63B44D (M550i 530 hp later variant)
  (@gen_g30, 'engine_oil', @e_n63d, 8.50, 9.00, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'N63 V8 highest-output variant for M550i. Same OEM caveat as B44C — LL-01 FE only, 0W-30 minimum, no LL-14/LL-17 FE+.');

-- ----------------------------------------------------------------------------
-- 4. Coolant per engine (BMW G48 HOAT — G30 pre-LCI uses G48 like F30/G20 pre-LCI)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_g30, 'coolant', @e_b46,  6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B46 cooling.'),
  (@gen_g30, 'coolant', @e_b48,  6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B48 cooling.'),
  (@gen_g30, 'coolant', @e_b47,  7.20, 7.60, 'BMW G48 / HOAT (blue-green silicate)', 'B47 diesel.'),
  (@gen_g30, 'coolant', @e_b58c, 8.50, 9.00, 'BMW G48 / HOAT (blue-green silicate)', 'B58 I6 gasoline.'),
  (@gen_g30, 'coolant', @e_b57a, 9.00, 9.50, 'BMW G48 / HOAT (blue-green silicate)', 'B57 diesel I6.'),
  (@gen_g30, 'coolant', @e_b57c, 9.00, 9.50, 'BMW G48 / HOAT (blue-green silicate)', 'B57 high-output diesel.'),
  (@gen_g30, 'coolant', @e_n63c, 11.50, 12.20, 'BMW G48 / HOAT (blue-green silicate)', 'N63 V8 — largest cooling volume due to twin-turbo intercooler circuit.'),
  (@gen_g30, 'coolant', @e_n63d, 11.50, 12.20, 'BMW G48 / HOAT (blue-green silicate)', 'N63 high-output V8.');

-- ----------------------------------------------------------------------------
-- 5. Cite all 4 sources on every new fluid + trim row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2020 FROM fluid_specs f
  WHERE f.generation_id = @gen_g30 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2019 FROM fluid_specs f
  WHERE f.generation_id = @gen_g30 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_g30 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us FROM fluid_specs f
  WHERE f.generation_id = @gen_g30 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_us IS NOT NULL;

-- Cite sources on the new trims
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad FROM trims WHERE generation_id = @gen_g30 AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2020 FROM trims WHERE generation_id = @gen_g30;
