-- G20 LCI trim widening + OEM moat data per "collect all data before next
-- gen" workflow. Continues from mig 169 (structural split) — the LCI gen
-- existed but with 0 trims. This populates the LCI-period lineup from
-- auto-data G20 LCI page + the 4 BMW US owner's manuals 2023-2026.
--
-- Sources collected for G20 LCI:
--   1. BMW US 2023 3 Series Owner's Manual (Part no. 01405A5F6E0 - VI/22)
--   2. BMW US 2024 3 Series Owner's Manual (Part no. 01405A8A749 - VI/23)
--   3. BMW US 2025 3 Series Owner's Manual (Part no. 01405B465F9 - VI/24)
--   4. BMW US 2026 3 Series Owner's Manual (Part no. 01405B738C8 - VI/25)
--   5. Auto-Data.net G20 LCI generation page
--   6. Ultimatespecs.com BMW 3-Series catalogue
--
-- Cross-verified OEM findings (LCI run):
-- - MY2023-MY2025: gasoline spec BMW Longlife-17 FE+ (LL-17 FE+) /
--   Longlife-12 FE diesel; viscosity 0W-20 / 0W-30; coolant BMW LC-18
--   (NEW spec, replaces G48 HOAT used pre-LCI through MY2022).
-- - MY2026: BMW Longlife-22 FE++ (LL-22 FE++) added as primary gasoline
--   spec — backward-compatible with LL-17 FE+ engines.
--
-- This migration:
-- 1. Adds 4 OEM source rows.
-- 2. Adds 16 LCI-period trims (covering 318i/318d/320i/320d/320e/330i/330d/
--    330e/M340i/M340d variants).
-- 3. Adds engine_oil + coolant per LCI engine (B38, B47, B48, B48B, B57, B58A,
--    B58B, B58O1).
-- 4. Cites all 6 sources on each fluid row.

SET NAMES utf8mb4;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-lci-2022-present');

SET @e_b38   := (SELECT id FROM engines WHERE code = 'B38A15A');
SET @e_b47   := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b48   := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b  := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b57   := (SELECT id FROM engines WHERE code = 'B57D30A');
SET @e_b58a  := (SELECT id FROM engines WHERE code = 'B58B30A');
SET @e_b58b  := (SELECT id FROM engines WHERE code = 'B58B30B');
SET @e_b58o  := (SELECT id FROM engines WHERE code = 'B58B30O1');

SET @tx_at8st := 5;  -- 8 gears, automatic Steptronic
SET @tx_at8   := 6;  -- 8 gears, automatic transmission

-- ----------------------------------------------------------------------------
-- 1. OEM source rows (4 manuals)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2023 3 Series Sedan Owner''s Manual (Part no. 01405A5F6E0 - VI/22)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2023-owners-manual-85302', NOW(),
   'G20 LCI launch MY2023. Establishes Longlife-17 FE+ gasoline / Longlife-12 FE diesel oil specs and new BMW LC-18 coolant (replaces G48 HOAT from pre-LCI).'),
  ('BMW US 2024 3 Series Sedan Owner''s Manual (Part no. 01405A8A749 - VI/23)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2024-owners-manual-95809', NOW(),
   'MY2024 G20 LCI. Oil + coolant spec carries over from MY2023.'),
  ('BMW US 2025 3 Series Sedan Owner''s Manual (Part no. 01405B465F9 - VI/24)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2025-owners-manual-100935', NOW(),
   'MY2025 G20 LCI. Specs stable.'),
  ('BMW US 2026 3 Series Sedan Owner''s Manual (Part no. 01405B738C8 - VI/25)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2026-owners-manual-109308', NOW(),
   'MY2026 G20 LCI. Introduces BMW Longlife-22 FE++ as primary gasoline spec; LL-17 FE+ remains acceptable. Coolant LC-18 unchanged.');

SET @s_2023 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2023-owners-manual-85302');
SET @s_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2024-owners-manual-95809');
SET @s_2025 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2025-owners-manual-100935');
SET @s_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2026-owners-manual-109308');

-- Add auto-data G20 LCI page source
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Auto-Data.net — BMW 3 Series G20 LCI Sedan', 'https://www.auto-data.net/en/bmw-3-series-sedan-g20-lci-facelift-2022-generation-8879', NOW());
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-g20-lci-facelift-2022-generation-8879');
SET @s_us   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/BMW-3-Series');

-- ----------------------------------------------------------------------------
-- 2. LCI-period trims (16)
-- ----------------------------------------------------------------------------
-- 318i (B48A15A 156hp Steptronic)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '318i-156-hp-steptronic', '318i (156 Hp) Steptronic', @e_b38, @tx_at8st, 156, 8.6, 223, 'RWD', 2022, NULL),
  (@gen_lci, '318d-150-hp-steptronic', '318d (150 Hp) Steptronic', @e_b47, @tx_at8st, 150, 8.3, 218, 'RWD', 2022, NULL);

-- 320i variants (B48B20A 170/184hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '320i-170-hp-steptronic',        '320i (170 Hp) Steptronic',        @e_b48,  @tx_at8st, 170, 8.1, 228, 'RWD', 2022, NULL),
  (@gen_lci, '320i-184-hp-steptronic',        '320i (184 Hp) Steptronic',        @e_b48,  @tx_at8st, 184, 7.4, 235, 'RWD', 2022, NULL),
  (@gen_lci, '320i-184-hp-xdrive-steptronic', '320i (184 Hp) xDrive Steptronic', @e_b48b, @tx_at8st, 184, 7.7, 230, 'AWD', 2022, NULL);

-- 320d variants (B47D20)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '320d-190-hp-steptronic',        '320d (190 Hp) Steptronic',        @e_b47, @tx_at8st, 190, 6.9, 235, 'RWD', 2022, NULL),
  (@gen_lci, '320d-190-hp-xdrive-steptronic', '320d (190 Hp) xDrive Steptronic', @e_b47, @tx_at8st, 190, 7.2, 228, 'AWD', 2022, NULL);

-- 320e Plug-in Hybrid
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '320e-204-hp-plug-in-hybrid-steptronic', '320e (204 Hp) Plug-in Hybrid Steptronic', @e_b48, @tx_at8st, 204, 7.6, 225, 'RWD', 2022, NULL);

-- 330i variants — EU 245hp + US 255hp
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '330i-245-hp-steptronic',           '330i (245 Hp) Steptronic',           @e_b48b, @tx_at8st, 245, 5.9, 250, 'RWD', 2022, NULL),
  (@gen_lci, '330i-245-hp-xdrive-steptronic',    '330i (245 Hp) xDrive Steptronic',    @e_b48b, @tx_at8st, 245, 5.7, 250, 'AWD', 2022, NULL),
  (@gen_lci, '330i-255-hp-steptronic-us',        '330i (255 Hp) Steptronic (US)',      @e_b48b, @tx_at8st, 255, 5.6, 210, 'RWD', 2022, NULL),
  (@gen_lci, '330i-255-hp-xdrive-steptronic-us', '330i (255 Hp) xDrive Steptronic (US)', @e_b48b, @tx_at8st, 255, 5.4, 210, 'AWD', 2022, NULL);

-- 330d Mild Hybrid xDrive (B57)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '330d-286-hp-mild-hybrid-xdrive-steptronic', '330d (286 Hp) Mild Hybrid xDrive Steptronic', @e_b57, @tx_at8st, 286, 5.0, 250, 'AWD', 2022, NULL);

-- 330e Plug-in Hybrid + xDrive
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '330e-292-hp-plug-in-hybrid-steptronic',        '330e (292 Hp) Plug-in Hybrid Steptronic',        @e_b48,  @tx_at8st, 292, 5.8, 230, 'RWD', 2022, NULL),
  (@gen_lci, '330e-292-hp-plug-in-hybrid-xdrive-steptronic', '330e (292 Hp) Plug-in Hybrid xDrive Steptronic', @e_b48b, @tx_at8st, 292, 5.8, 230, 'AWD', 2022, NULL);

-- M340i variants
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, 'm340i-374-hp-xdrive-steptronic',    'M340i (374 Hp) xDrive Steptronic',    @e_b58b, @tx_at8st, 374, 4.4, 250, 'AWD', 2022, 2025),
  (@gen_lci, 'm340i-382-hp-steptronic-us',        'M340i (382 Hp) Steptronic (US)',      @e_b58o, @tx_at8st, 382, 4.4, 210, 'RWD', 2022, NULL),
  (@gen_lci, 'm340d-340-hp-mild-hybrid-xdrive-steptronic', 'M340d (340 Hp) Mild Hybrid xDrive Steptronic', @e_b57, @tx_at8st, 340, 4.6, 250, 'AWD', 2022, NULL);

-- ----------------------------------------------------------------------------
-- 3. Engine oil per LCI engine — LL-17 FE+ primary (MY2023-2025);
--    LL-22 FE++ added for MY2026 in notes
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_lci, 'engine_oil', @e_b38,  4.25, 4.50, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B38A15A 3-cyl turbo gasoline. MY2026 OEM manual lists Longlife-22 FE++ as primary; LL-17 FE+ remains acceptable. Viscosity 0W-30 (default) or 0W-20 (specific engines).'),
  (@gen_lci, 'engine_oil', @e_b47,  5.30, 5.60, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000,
   'B47D20 2.0L diesel turbo. LL-12 FE low-SAPS spec unchanged from pre-LCI.'),
  (@gen_lci, 'engine_oil', @e_b48,  5.25, 5.50, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B48B20 2.0L gasoline (320i RWD / 330e PHEV ICE). MY2026+ accepts LL-22 FE++.'),
  (@gen_lci, 'engine_oil', @e_b48b, 5.25, 5.50, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B48B20B 2.0L gasoline (330i / xDrive variants). MY2026+ accepts LL-22 FE++.'),
  (@gen_lci, 'engine_oil', @e_b57,  7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000,
   'B57D30 3.0L diesel I6 (330d / M340d Mild Hybrid). LL-12 FE.'),
  (@gen_lci, 'engine_oil', @e_b58a, 6.50, 6.90, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B58B30A I6 gasoline. LL-22 FE++ recommended from MY2026 for the high-output tunes.'),
  (@gen_lci, 'engine_oil', @e_b58b, 6.50, 6.90, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B58B30B M340i 374 hp variant.'),
  (@gen_lci, 'engine_oil', @e_b58o, 6.50, 6.90, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000,
   'B58B30O1 M340i 382 hp US.');

-- ----------------------------------------------------------------------------
-- 4. Coolant per LCI engine — NEW BMW LC-18 spec (replaces G48 HOAT)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_lci, 'coolant', @e_b38,  5.00, 5.30, 'BMW LC-18',
   'New BMW LC-18 specification introduced for G20 LCI (MY2023+); replaces the G48 HOAT used pre-LCI. Do NOT mix with G48 — different additive chemistry.'),
  (@gen_lci, 'coolant', @e_b47,  7.00, 7.40, 'BMW LC-18', 'B47 diesel; LC-18.'),
  (@gen_lci, 'coolant', @e_b48,  6.50, 6.90, 'BMW LC-18', 'B48 RWD; LC-18.'),
  (@gen_lci, 'coolant', @e_b48b, 6.50, 6.90, 'BMW LC-18', 'B48 xDrive; LC-18.'),
  (@gen_lci, 'coolant', @e_b57,  9.00, 9.50, 'BMW LC-18', 'B57 diesel I6; largest cooling volume.'),
  (@gen_lci, 'coolant', @e_b58a, 8.50, 9.00, 'BMW LC-18', 'B58 I6 gasoline.'),
  (@gen_lci, 'coolant', @e_b58b, 8.50, 9.00, 'BMW LC-18', 'B58 variant.'),
  (@gen_lci, 'coolant', @e_b58o, 8.50, 9.00, 'BMW LC-18', 'B58 US.');

-- ----------------------------------------------------------------------------
-- 5. Cite all 6 sources on every new engine_oil + coolant row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2026 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2025 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2024 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2023 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_us IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 6. Source citations on the new trims
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad FROM trims WHERE generation_id = @gen_lci AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us FROM trims WHERE generation_id = @gen_lci AND @s_us IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2023 FROM trims WHERE generation_id = @gen_lci;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2026 FROM trims WHERE generation_id = @gen_lci;
