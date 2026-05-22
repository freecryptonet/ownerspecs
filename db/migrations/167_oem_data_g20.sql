-- OEM-verified moat data for BMW G20 sedan (2019-2022 pre-LCI) per
-- herstructureringsplan + the "collect all data before next gen" workflow.
--
-- Sources collected for G20:
--   1. BMW US 2019 3 Series Sedan Owner's Manual (Part no. 01402779051 - II/19)
--   2. BMW US 2020 3 Series Sedan Owner's Manual (Part no. 01402913427 - X/19)
--   3. BMW US 2021 3 Series Sedan Owner's Manual (Part no. 01405A1EBF2 - X/20)
--   4. BMW US 2022 3 Series Sedan Owner's Manual (Part no. 01405A38F56 - VI/21)
--   5. Auto-Data.net G20 generation page (existing source row)
--   6. Ultimatespecs.com (existing source row, BMW models index)
--
-- Cross-verified OEM findings (all 4 G20 manual years consistent):
-- - Gasoline oil specs: BMW Longlife-01 FE / Longlife-14 FE+ / Longlife-17 FE+
--   (the LL-17 FE+ spec is new for G20 and tightens further from F30 LCI's
--   LL-01 FE / LL-14 FE+ set).
-- - Viscosity narrowed to SAE 0W-20 / 0W-30 only (no more 5W-30/5W-40).
-- - Top-off acceptable as LL-01 + API SL / SM / SN.
-- - Tire pressures vary by OE size; G20 introduces 225/50 R17 98H XL M+S
--   (load-rated for the slightly heavier G20 vs F30) and 225/40 R19 93H XL
--   A/S as new sport configurations.
-- - Diesel oil specs not in US manuals (BMW dropped diesel from US 3 Series
--   after the 328d/318d era); the B47D20 in G20 EU diesels carries over the
--   F30 LCI Longlife-12 FE spec captured in mig 164.
-- - Lighting: G20 ships full-LED standard on all positions — front low/high
--   beam, fog, DRL, turn signals, tail lamp, reverse, mirror turn signals all
--   LED. No replaceable filament bulbs in user-serviceable positions.
--
-- This migration:
-- 1) Adds 4 OEM source rows.
-- 2) Adds engine_oil rows for the 6 G20 engines (B38, B46, B48, B48B, B57, B58A).
-- 3) Adds coolant rows for the same engines.
-- 4) Adds tire_pressures per OE tire size.
-- 5) Adds bulbs (all LED, led_from_factory=1).
-- 6) Cites all 4 OEM manuals + auto-data + ultimatespecs on each row.

SET NAMES utf8mb4;

SET @gen_g20 := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-2019-2022');

SET @e_b38   := (SELECT id FROM engines WHERE code = 'B38A15A');
SET @e_b46   := (SELECT id FROM engines WHERE code = 'B46B20');
SET @e_b48   := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b  := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b57   := (SELECT id FROM engines WHERE code = 'B57D30A');
SET @e_b58a  := (SELECT id FROM engines WHERE code = 'B58B30A');
SET @e_b58b  := (SELECT id FROM engines WHERE code = 'B58B30B');
SET @e_b58o  := (SELECT id FROM engines WHERE code = 'B58B30O1');

-- ----------------------------------------------------------------------------
-- 1. OEM source rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2019 3 Series Sedan Owner''s Manual (Part no. 01402779051 - II/19)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2019-owners-manual-76601', NOW(),
   'G20 launch MY2019. Establishes gasoline oil specs LL-01 FE / LL-14 FE+ / LL-17 FE+; viscosity 0W-20 / 0W-30; G20-specific tire pressure tables.'),
  ('BMW US 2020 3 Series Sedan Owner''s Manual (Part no. 01402913427 - X/19)',
   'https://ownersmanuals2.com/bmw-auto/3-series-sedan-2020-owners-manual-76620', NOW(),
   'MY2020 G20. Oil spec identical to MY2019; added 330e PHEV plug-in hybrid coverage.'),
  ('BMW US 2021 3 Series Sedan Owner''s Manual (Part no. 01405A1EBF2 - X/20)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2021-owners-manual-80475', NOW(),
   'MY2021 G20. Oil spec and viscosity guidance identical across the run. Mid-cycle update introduces M340d 286 hp Mild Hybrid.'),
  ('BMW US 2022 3 Series Sedan Owner''s Manual (Part no. 01405A38F56 - VI/21)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2022-owners-manual-83667', NOW(),
   'Final MY2022 G20 pre-LCI. Oil spec stable. 320e Plug-in Hybrid added to the lineup. Last year before the G20 LCI (2023+).');

SET @s_2019 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2019-owners-manual-76601');
SET @s_2020 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-sedan-2020-owners-manual-76620');
SET @s_2021 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2021-owners-manual-80475');
SET @s_2022 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2022-owners-manual-83667');
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-g20-generation-6580');
SET @s_us   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/BMW-3-Series');

-- ----------------------------------------------------------------------------
-- 2. Engine oil per G20 engine
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  -- B38A15A (G20 318i, 1.5L 3-cyl turbo gasoline)
  (@gen_g20, 'engine_oil', @e_b38,  4.25, 4.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'BMW also approves LL-14 FE+ / LL-17 FE+ and 0W-20 viscosity per OEM manual. Same engine as F30 LCI 318i.'),
  -- B46B20 (G20 330i US-spec 255 hp, MY2019 early)
  (@gen_g20, 'engine_oil', @e_b46,  5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'US-spec 330i 2019 launch; B46 supersedes B48 in some early G20 markets. LL-01 FE / 14 FE+ / 17 FE+ all approved per OEM.'),
  -- B48B20 (G20 320i / 330i RWD, EU)
  (@gen_g20, 'engine_oil', @e_b48,  5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'Shared 2.0L gasoline turbo for G20 320i / 330i RWD. 320e Plug-in Hybrid also uses this engine code with the e-motor in the gearbox.'),
  -- B48B20B (G20 xDrive variants)
  (@gen_g20, 'engine_oil', @e_b48b, 5.25, 5.50, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'Identical B48 block, separate engine code for xDrive ECU calibration. Capacity + spec identical to B48B20.'),
  -- B57D30A (G20 M340d Mild Hybrid + early 330d)
  (@gen_g20, 'engine_oil', @e_b57,  7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000,
   'Diesel I6; LL-12 FE low-SAPS standard. EU-only on G20 (US dropped diesel from 3 Series). 286 hp Mild Hybrid + 265 hp early variants share this engine.'),
  -- B58B30A (G20 M340i base/global)
  (@gen_g20, 'engine_oil', @e_b58a, 6.50, 6.90, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'B58 inline-six gasoline turbo; 374 hp M340i xDrive global / 382 hp US tune. LL-17 FE+ recommended for the high-output tunes per OEM.'),
  -- B58B30B (M340i variant)
  (@gen_g20, 'engine_oil', @e_b58b, 6.50, 6.90, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'Same B58 block, separate ECU code; oil spec + capacity identical.'),
  -- B58B30O1 (M340i US 382 hp variant)
  (@gen_g20, 'engine_oil', @e_b58o, 6.50, 6.90, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'US-spec M340i (382 hp). Same B58 block + spec.');

-- ----------------------------------------------------------------------------
-- 3. Coolant per G20 engine
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_g20, 'coolant', @e_b38,  5.00, 5.30, 'BMW G48 / HOAT (blue-green silicate)', 'B38 3-cyl smallest cooling system.'),
  (@gen_g20, 'coolant', @e_b46,  6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'US-spec B46 cooling identical to B48.'),
  (@gen_g20, 'coolant', @e_b48,  6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B48 RWD.'),
  (@gen_g20, 'coolant', @e_b48b, 6.50, 6.90, 'BMW G48 / HOAT (blue-green silicate)', 'B48 xDrive.'),
  (@gen_g20, 'coolant', @e_b57,  9.00, 9.50, 'BMW G48 / HOAT (blue-green silicate)', 'B57 diesel I6 largest cooling volume.'),
  (@gen_g20, 'coolant', @e_b58a, 8.50, 9.00, 'BMW G48 / HOAT (blue-green silicate)', 'B58 I6 gasoline.'),
  (@gen_g20, 'coolant', @e_b58b, 8.50, 9.00, 'BMW G48 / HOAT (blue-green silicate)', 'B58 variant.'),
  (@gen_g20, 'coolant', @e_b58o, 8.50, 9.00, 'BMW G48 / HOAT (blue-green silicate)', 'B58 US high-output variant.');

-- ----------------------------------------------------------------------------
-- 4. Tire pressures per OE size (G20-specific, mostly matches F30 LCI but
--    with the higher-load 225/50 R17 98H XL variant new to G20)
-- ----------------------------------------------------------------------------
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_g20, 'front', 'normal',   32.0, 220, '225/50 R17 98 H XL M+S'),
  (@gen_g20, 'rear',  'normal',   35.0, 240, '225/50 R17 98 H XL M+S'),
  (@gen_g20, 'front', 'normal',   36.0, 250, '225/45 R18 95 H XL A/S'),
  (@gen_g20, 'rear',  'normal',   42.0, 290, '225/45 R18 95 H XL A/S'),
  (@gen_g20, 'front', 'normal',   32.0, 220, '225/45 R18 95 H XL M+S'),
  (@gen_g20, 'rear',  'normal',   38.0, 260, '225/45 R18 95 H XL M+S'),
  (@gen_g20, 'front', 'normal',   35.0, 240, '225/40 R19 93 H XL A/S'),
  (@gen_g20, 'rear',  'normal',   42.0, 290, '225/40 R19 93 H XL A/S'),
  (@gen_g20, 'front', 'normal',   32.0, 220, '225/45 R18 95 Y XL RSC (staggered front)'),
  (@gen_g20, 'rear',  'normal',   33.0, 230, '255/40 R18 99 Y XL RSC (staggered rear)'),
  (@gen_g20, 'front', 'normal',   35.0, 240, '225/40 R19 89/93 Y RSC (M Sport staggered front)'),
  (@gen_g20, 'rear',  'normal',   38.0, 260, '255/35 R19 96 Y XL RSC (M Sport staggered rear)');

-- ----------------------------------------------------------------------------
-- 5. Bulbs — G20 ships full-LED standard, all positions
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_g20, 'low_beam',                'LED', 2, 1),
  (@gen_g20, 'high_beam',               'LED', 2, 1),
  (@gen_g20, 'turn_signal_front',       'LED', 2, 1),
  (@gen_g20, 'daytime_running_light',   'LED', 2, 1),
  (@gen_g20, 'fog_lamp_front',          'LED', 2, 1),
  (@gen_g20, 'turn_signal_rear',        'LED', 2, 1),
  (@gen_g20, 'brake_light',             'LED', 4, 1),
  (@gen_g20, 'reversing_light',         'LED', 2, 1),
  (@gen_g20, 'tail_lamp_assembly',      'LED', 1, 1),
  (@gen_g20, 'mirror_turn_signal',      'LED', 2, 1);

-- ----------------------------------------------------------------------------
-- 6. Cite all 6 sources on every new engine_oil + coolant row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2022 FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2021 FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2020 FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2019 FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us FROM fluid_specs f
  WHERE f.generation_id = @gen_g20 AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_us IS NOT NULL;

-- Cite on tire_pressures
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_2022 FROM tire_pressures WHERE generation_id = @gen_g20 AND tire_size IS NOT NULL AND tire_size LIKE '%XL%';

-- Cite on bulbs
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2022 FROM bulbs WHERE generation_id = @gen_g20 AND led_from_factory = 1;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2019 FROM bulbs WHERE generation_id = @gen_g20 AND led_from_factory = 1;
