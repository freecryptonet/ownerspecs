-- mig 357 — Phase 3b: Suzuki engines + per-gen per-engine fluids,
-- extracted directly from the 11 indexed Suzuki NL owner manuals
-- (mig 353 inventory). 6 of 11 gens covered this pass; the 5 Toyota-
-- rebadged or pre-2020 layouts (Across, Swace, Baleno, Celerio, Fronx)
-- use a different spec-table format and are deferred to a follow-up.
--
-- Engines added (7 new):
--   K12C — 1.2L 4-cyl DualJet NA (Ignis, Swift)
--   K12D — 1.2L 4-cyl Smart Hybrid (Ignis, Swift)
--   K12M — 1.2L 4-cyl SHVS Mild Hybrid (Ignis)
--   K14C — 1.4L 4-cyl Boosterjet turbo (S-Cross, Vitara)
--   K14D — 1.4L 4-cyl Smart Hybrid (S-Cross, Vitara, Swift Sport)
--   K15B — 1.5L 4-cyl NA (Jimny JB64; universally documented though
--          the EU manual itself doesn't print the engine code)
--   K15C — 1.5L 4-cyl Smart Hybrid (Vitara LY MC2, S-Cross YED)
--
-- All data from the actual SPECIFICATIES / TECHNISCHE GEGEVENS chapters.
-- Coolant "SUZUKI LLC: Super (Blauw)" is the gen-spec across nearly all
-- modern Suzukis. Brake fluid: DOT4 for S-Cross/Vitara, DOT3 for Swift/
-- Ignis/Jimny — confirmed per manual.

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- 1. Engines
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('K12C', 'Suzuki 1.2 DualJet (K12C) 4-cyl NA',          1242, 'gasoline', 'naturally aspirated', 4),
  ('K12D', 'Suzuki 1.2 Smart Hybrid (K12D) 4-cyl',         1197, 'gasoline', 'naturally aspirated', 4),
  ('K12M', 'Suzuki 1.2 SHVS Mild Hybrid (K12M) 4-cyl',     1242, 'gasoline', 'naturally aspirated', 4),
  ('K14C', 'Suzuki 1.4 Boosterjet (K14C) 4-cyl turbo',     1373, 'gasoline', 'turbocharged',        4),
  ('K14D', 'Suzuki 1.4 Smart Hybrid Boosterjet (K14D) 4-cyl turbo', 1373, 'gasoline', 'turbocharged', 4),
  ('K15B', 'Suzuki 1.5 (K15B) 4-cyl NA (Jimny JB64)',      1462, 'gasoline', 'naturally aspirated', 4),
  ('K15C', 'Suzuki 1.5 Smart Hybrid (K15C) 4-cyl',         1462, 'gasoline', 'naturally aspirated', 4);

SET @e_k12c = (SELECT id FROM engines WHERE code='K12C');
SET @e_k12d = (SELECT id FROM engines WHERE code='K12D');
SET @e_k12m = (SELECT id FROM engines WHERE code='K12M');
SET @e_k14c = (SELECT id FROM engines WHERE code='K14C');
SET @e_k14d = (SELECT id FROM engines WHERE code='K14D');
SET @e_k15b = (SELECT id FROM engines WHERE code='K15B');
SET @e_k15c = (SELECT id FROM engines WHERE code='K15C');

-- ---------------------------------------------------------------------------
-- 2. Gen + source ID lookups (mig 356 created these)
-- ---------------------------------------------------------------------------

SET @g_ignis    = (SELECT id FROM generations WHERE slug='ignis-mf-hatchback-2016-present');
SET @g_jimny    = (SELECT id FROM generations WHERE slug='jimny-jb64-suv-2018-present');
SET @g_scross_j = (SELECT id FROM generations WHERE slug='s-cross-jy-suv-2013-2021');
SET @g_scross_y = (SELECT id FROM generations WHERE slug='s-cross-yed-suv-2022-present');
SET @g_swift    = (SELECT id FROM generations WHERE slug='swift-az-hatchback-2017-2024');
SET @g_vitara   = (SELECT id FROM generations WHERE slug='vitara-ly-suv-2015-present');

SET @s_ignis    = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Ignis_2022_compressed.pdf'));
SET @s_jimny    = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Jimny_2022_compressed.pdf'));
SET @s_scross_j = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Gebruikershandleiding_S-Cross_2021-min.pdf'));
SET @s_scross_y = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Scross_24MC_WEB_99011U63TD0-25D-compressed.pdf'));
SET @s_swift    = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Gebruikershandleiding_Swift_2021-min.pdf'));
SET @s_vitara   = (SELECT id FROM sources WHERE manual_inventory_id = (SELECT id FROM manual_inventory WHERE file_path='manuals/Vitara_2024MC_WEB_99011U74SE0-25D_compressed.pdf'));

-- ---------------------------------------------------------------------------
-- 3. Fluids per (gen, engine) — data straight from manual SPECIFICATIES
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO fluid_specs
  (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  -- IGNIS MF (Ignis_2022_compressed.pdf)
  (@g_ignis, @e_k12c, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-5/GF-6', NULL),
  (@g_ignis, @e_k12d, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-5/GF-6', NULL),
  (@g_ignis, @e_k12m, 'engine_oil', 3.1, 3.28, '0W-20', 'API SL/SM/SN/SP, ILSAC GF-3/GF-4/GF-5/GF-6', NULL),
  (@g_ignis, @e_k12c, 'coolant',    4.0, 4.23, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_ignis, @e_k12d, 'coolant',    4.0, 4.23, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_ignis, @e_k12m, 'coolant',    3.8, 4.02, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_ignis, NULL,    'transmission_mt',  1.5, 1.59, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_ignis, NULL,    'transmission_cvt', 5.73, 6.05, NULL, 'SUZUKI CVTF GREEN-2 (do not substitute)', NULL),
  (@g_ignis, NULL,    'transfer_case',    0.41, 0.43, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_ignis, NULL,    'rear_differential', 0.85, 0.90, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_ignis, NULL,    'brake_fluid',      NULL, NULL, NULL,  'SAE J1703 or DOT 3', NULL),

  -- JIMNY JB64 (Jimny_2022_compressed.pdf). K15B engine per JB64 convention.
  (@g_jimny, @e_k15b, 'engine_oil', 3.6, 3.80, '0W-16', 'API SN/SP, ILSAC GF-5/GF-6 (EU spec)', NULL),
  (@g_jimny, @e_k15b, 'coolant',    5.0, 5.28, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_jimny, NULL,    'transmission_mt',   1.2, 1.27, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_jimny, NULL,    'transmission_at',   5.7, 6.02, NULL,   'SUZUKI ATF 3317 or Mobil ATF 3309', NULL),
  (@g_jimny, NULL,    'front_differential',1.6, 1.69, '75W-85', 'SUZUKI SUPER GEAR OIL 75W-85 SYNTHETIC', NULL),
  (@g_jimny, NULL,    'rear_differential', 1.3, 1.37, '75W-85', 'SUZUKI SUPER GEAR OIL 75W-85 SYNTHETIC', NULL),
  (@g_jimny, NULL,    'transfer_case',     1.21, 1.28, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_jimny, NULL,    'brake_fluid',       NULL, NULL, NULL,  'SAE J1703 or DOT 3', NULL),

  -- S-CROSS JY (Gebruikershandleiding_S-Cross_2021-min.pdf)
  (@g_scross_j, @e_k14c, 'engine_oil', 3.3, 3.49, '5W-30', 'ACEA A1/B1 A3/B3 A3/B4 A5/B5, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_scross_j, @e_k14d, 'engine_oil', 3.6, 3.80, '0W-20', 'ACEA A1/B1, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_scross_j, @e_k14c, 'coolant',    5.5, 5.81, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_scross_j, @e_k14d, 'coolant',    6.7, 7.08, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_scross_j, NULL,    'transmission_mt',  2.5, 2.64, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_scross_j, NULL,    'transmission_at',  6.2, 6.55, NULL,  'SUZUKI AT OIL AW-1', NULL),
  (@g_scross_j, NULL,    'transfer_case',    0.82, 0.87, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_scross_j, NULL,    'rear_differential', 0.73, 0.77, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_scross_j, NULL,    'brake_fluid',      NULL, NULL, NULL,  'SAE J1704 or DOT 4', NULL),

  -- S-CROSS YED (Scross_24MC_WEB_99011U63TD0-25D-compressed.pdf) — adds K15C
  (@g_scross_y, @e_k14c, 'engine_oil', 3.3, 3.49, '5W-30', 'ACEA A1/B1 A3/B3 A3/B4 A5/B5, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_scross_y, @e_k14d, 'engine_oil', 3.6, 3.80, '0W-20', 'ACEA A1/B1, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_scross_y, @e_k15c, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-6', NULL),
  (@g_scross_y, @e_k14c, 'coolant',    5.5, 5.81, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_scross_y, @e_k14d, 'coolant',    6.7, 7.08, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_scross_y, @e_k15c, 'coolant',    4.5, 4.76, NULL,    'SUZUKI LLC: Super (Blauw) (incl. expansion tank)', NULL),
  (@g_scross_y, NULL,    'transmission_mt',  2.6, 2.75, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_scross_y, NULL,    'transmission_at',  6.2, 6.55, NULL,  'SUZUKI AT OIL AW-1 (K14C/K14D)', NULL),
  (@g_scross_y, NULL,    'transfer_case',    0.82, 0.87, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models)', NULL),
  (@g_scross_y, NULL,    'rear_differential', 0.73, 0.77, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models)', NULL),
  (@g_scross_y, NULL,    'brake_fluid',      NULL, NULL, NULL,  'SAE J1704 or DOT 4', NULL),

  -- SWIFT AZ (Gebruikershandleiding_Swift_2021-min.pdf)
  (@g_swift, @e_k12c, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-5/GF-6', NULL),
  (@g_swift, @e_k12d, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-5/GF-6', NULL),
  (@g_swift, @e_k14d, 'engine_oil', 3.6, 3.80, '0W-20', 'ACEA A1/B1, API SL/SM/SN/SP, ILSAC GF-3/GF-4/GF-5/GF-6 (EU/Israel)', NULL),
  (@g_swift, @e_k12c, 'coolant',    4.6, 4.86, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_swift, @e_k12d, 'coolant',    4.3, 4.54, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_swift, @e_k14d, 'coolant',    5.3, 5.60, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_swift, NULL,    'transmission_mt',  1.5, 1.59, '75W', 'SUZUKI GEAR OIL 75W (K12C/K12D 2WD)', NULL),
  (@g_swift, NULL,    'transmission_cvt', 5.73, 6.05, NULL, 'SUZUKI CVTF GREEN-2', NULL),
  (@g_swift, NULL,    'transfer_case',    0.41, 0.43, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_swift, NULL,    'rear_differential', 0.43, 0.45, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models only)', NULL),
  (@g_swift, NULL,    'brake_fluid',      NULL, NULL, NULL,  'SAE J1703 or DOT 3', NULL),

  -- VITARA LY MC2 (Vitara_2024MC_WEB_99011U74SE0-25D_compressed.pdf)
  (@g_vitara, @e_k14c, 'engine_oil', 3.3, 3.49, '5W-30', 'ACEA A1/B1 A3/B3 A3/B4 A5/B5, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_vitara, @e_k14d, 'engine_oil', 3.6, 3.80, '0W-20', 'ACEA A1/B1, API SL/SM/SN/SP, ILSAC GF-6', NULL),
  (@g_vitara, @e_k15c, 'engine_oil', 3.3, 3.49, '0W-16', 'API SN/SP, ILSAC GF-6', NULL),
  (@g_vitara, @e_k14c, 'coolant',    5.5, 5.81, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_vitara, @e_k14d, 'coolant',    6.7, 7.08, NULL,    'SUZUKI LLC: Super (Blauw) — M/T (incl. expansion tank)', NULL),
  (@g_vitara, @e_k15c, 'coolant',    4.5, 4.76, NULL,    'SUZUKI LLC: Super (Blauw) (incl. expansion tank)', NULL),
  (@g_vitara, NULL,    'transmission_mt',  2.6, 2.75, '75W', 'SUZUKI GEAR OIL 75W', NULL),
  (@g_vitara, NULL,    'transmission_at',  6.2, 6.55, NULL,  'SUZUKI AT OIL AW-1 (K14C/K14D)', NULL),
  (@g_vitara, NULL,    'transfer_case',    0.82, 0.87, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models)', NULL),
  (@g_vitara, NULL,    'rear_differential', 0.73, 0.77, '75W-85', 'SUZUKI GEAR OIL 75W-85 (4WD models)', NULL),
  (@g_vitara, NULL,    'brake_fluid',      NULL, NULL, NULL,  'SAE J1704 or DOT 4', NULL);

-- ---------------------------------------------------------------------------
-- 4. Cite all new fluid rows to their gen's manual source
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_ignis  FROM fluid_specs WHERE generation_id = @g_ignis;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_jimny  FROM fluid_specs WHERE generation_id = @g_jimny;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_scross_j FROM fluid_specs WHERE generation_id = @g_scross_j;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_scross_y FROM fluid_specs WHERE generation_id = @g_scross_y;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_swift  FROM fluid_specs WHERE generation_id = @g_swift;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_vitara FROM fluid_specs WHERE generation_id = @g_vitara;

-- POST-CHECK
SELECT 'engines added' k, COUNT(*) n FROM engines WHERE code IN ('K12C','K12D','K12M','K14C','K14D','K15B','K15C')
UNION ALL SELECT 'fluid rows per gen', NULL
UNION ALL SELECT 'ignis fluids',   COUNT(*) FROM fluid_specs WHERE generation_id=@g_ignis
UNION ALL SELECT 'jimny fluids',   COUNT(*) FROM fluid_specs WHERE generation_id=@g_jimny
UNION ALL SELECT 's-cross JY',     COUNT(*) FROM fluid_specs WHERE generation_id=@g_scross_j
UNION ALL SELECT 's-cross YED',    COUNT(*) FROM fluid_specs WHERE generation_id=@g_scross_y
UNION ALL SELECT 'swift fluids',   COUNT(*) FROM fluid_specs WHERE generation_id=@g_swift
UNION ALL SELECT 'vitara fluids',  COUNT(*) FROM fluid_specs WHERE generation_id=@g_vitara;

COMMIT;
