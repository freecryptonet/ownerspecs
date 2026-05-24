-- mig 356 — Phase 3 catalog: Suzuki as a new make, with 10 models +
-- 11 generations. Dimensions + fuel-tank from Suzuki EU spec sheets,
-- cross-verified against the NL owner manuals (mig 353 inventory).
--
-- This pass adds the SKELETON only — make, models, generations with
-- dims + body, plus one OEM-manual source row per gen. Engines + fluids
-- are deferred to a follow-up migration (357) so the catalog goes live
-- in one fast step and per-engine spec extraction can be batched per
-- model in subsequent sessions.
--
-- 70 Suzuki owner manuals already indexed in manual_inventory (mig 353).
-- Each new source row links to the most-current manual per gen via
-- sources.manual_inventory_id (sha256 + edition_code = immutable
-- provenance trail).
--
-- Rebadge note: Across is a Suzuki-branded Toyota RAV4 PHEV; Swace is a
-- Suzuki-branded Toyota Corolla Touring Sports. Both are catalogued
-- under Suzuki per Tim's "selling brand" convention (matches the
-- filename precedence in scan_manuals.ts after the mig 353 patch).

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- 1. Make
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO makes (slug, name, country_of_origin, is_active)
VALUES ('suzuki', 'Suzuki', 'JP', 1);

SET @mk = (SELECT id FROM makes WHERE slug = 'suzuki');

-- ---------------------------------------------------------------------------
-- 2. Models (10)
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO models (make_id, slug, name, is_active) VALUES
  (@mk, 'across',  'Across',  1),
  (@mk, 'baleno',  'Baleno',  1),
  (@mk, 'celerio', 'Celerio', 1),
  (@mk, 'fronx',   'Fronx',   1),
  (@mk, 'ignis',   'Ignis',   1),
  (@mk, 'jimny',   'Jimny',   1),
  (@mk, 's-cross', 'S-Cross', 1),
  (@mk, 'swace',   'Swace',   1),
  (@mk, 'swift',   'Swift',   1),
  (@mk, 'vitara',  'Vitara',  1);

SET @m_across  = (SELECT id FROM models WHERE make_id=@mk AND slug='across');
SET @m_baleno  = (SELECT id FROM models WHERE make_id=@mk AND slug='baleno');
SET @m_celerio = (SELECT id FROM models WHERE make_id=@mk AND slug='celerio');
SET @m_fronx   = (SELECT id FROM models WHERE make_id=@mk AND slug='fronx');
SET @m_ignis   = (SELECT id FROM models WHERE make_id=@mk AND slug='ignis');
SET @m_jimny   = (SELECT id FROM models WHERE make_id=@mk AND slug='jimny');
SET @m_scross  = (SELECT id FROM models WHERE make_id=@mk AND slug='s-cross');
SET @m_swace   = (SELECT id FROM models WHERE make_id=@mk AND slug='swace');
SET @m_swift   = (SELECT id FROM models WHERE make_id=@mk AND slug='swift');
SET @m_vitara  = (SELECT id FROM models WHERE make_id=@mk AND slug='vitara');

-- ---------------------------------------------------------------------------
-- 3. Generations (11)
-- Dimensions + fuel tank from Suzuki EU spec sheets (suzuki.nl / suzuki.com)
-- cross-verified against the indexed owner manuals.
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO generations
  (model_id, slug, ordinal, codename, display_name, body_type,
   start_year, end_year, layout,
   length_mm, width_mm, height_mm, wheelbase_mm, front_track_mm, rear_track_mm,
   fuel_tank_l, is_active)
VALUES
  -- Across (AX10) — Suzuki-branded Toyota RAV4 PHEV. Single gen so far.
  (@m_across, 'across-ax10-suv-2020-present', 1, 'AX10', 'Across (AX10, 1st gen)', 'SUV',
   2020, NULL, 'AWD', 4635, 1855, 1690, 2690, 1605, 1625, 55.0, 1),

  -- Baleno (WB) — 2nd gen, EU-discontinued 2022
  (@m_baleno, 'baleno-wb-hatchback-2015-2022', 2, 'WB', 'Baleno (WB, 2nd gen)', 'Hatchback',
   2015, 2022, 'FWD', 3995, 1745, 1470, 2520, 1520, 1530, 37.0, 1),

  -- Celerio (LF) — 1st gen, EU-discontinued 2017
  (@m_celerio, 'celerio-lf-hatchback-2014-2017', 1, 'LF', 'Celerio (LF, 1st gen)', 'Hatchback',
   2014, 2017, 'FWD', 3600, 1600, 1530, 2425, 1410, 1410, 35.0, 1),

  -- Fronx (YTB) — Maruti Suzuki / global crossover, launched 2023
  (@m_fronx, 'fronx-ytb-suv-2023-present', 1, 'YTB', 'Fronx (YTB, 1st gen)', 'SUV',
   2023, NULL, 'FWD', 3995, 1765, 1550, 2520, 1530, 1530, 37.0, 1),

  -- Ignis (MF, FF21S) — single gen with 2020 + 2024 mid-cycle revisions
  (@m_ignis, 'ignis-mf-hatchback-2016-present', 1, 'MF', 'Ignis (MF, 1st gen)', 'Hatchback',
   2016, NULL, 'FWD', 3700, 1660, 1595, 2435, 1455, 1450, 32.0, 1),

  -- Jimny (JB64) — 4th gen, 3-door body
  (@m_jimny, 'jimny-jb64-suv-2018-present', 4, 'JB64', 'Jimny (JB64, 4th gen)', 'SUV',
   2018, NULL, '4WD', 3645, 1645, 1725, 2250, 1395, 1405, 40.0, 1),

  -- S-Cross JY — 1st gen EU (2013-2021)
  (@m_scross, 's-cross-jy-suv-2013-2021', 1, 'JY', 'S-Cross (JY, 1st gen)', 'SUV',
   2013, 2021, 'FWD', 4300, 1785, 1585, 2600, 1535, 1505, 47.0, 1),

  -- S-Cross YED — 2nd gen (2022-present), Smart Hybrid + Full Hybrid
  (@m_scross, 's-cross-yed-suv-2022-present', 2, 'YED', 'S-Cross (YED, 2nd gen)', 'SUV',
   2022, NULL, 'FWD', 4300, 1785, 1585, 2600, 1535, 1505, 47.0, 1),

  -- Swace (SX10) — Suzuki-branded Toyota Corolla Touring Sports Hybrid
  (@m_swace, 'swace-sx10-wagon-2020-present', 1, 'SX10', 'Swace (SX10, 1st gen)', 'Wagon',
   2020, NULL, 'FWD', 4655, 1790, 1460, 2700, 1545, 1555, 36.0, 1),

  -- Swift AZ — 4th gen (2017-2024)
  (@m_swift, 'swift-az-hatchback-2017-2024', 4, 'AZ', 'Swift (AZ, 4th gen)', 'Hatchback',
   2017, 2024, 'FWD', 3840, 1735, 1495, 2450, 1530, 1530, 37.0, 1),

  -- Vitara (LY) — 4th gen, single chassis with 2018 + 2024 mid-cycle revisions
  (@m_vitara, 'vitara-ly-suv-2015-present', 4, 'LY', 'Vitara (LY, 4th gen)', 'SUV',
   2015, NULL, 'FWD', 4170, 1775, 1610, 2500, 1535, 1505, 47.0, 1);

-- Look up the 11 new gen IDs (used for source linkage)
SET @g_across   = (SELECT id FROM generations WHERE slug='across-ax10-suv-2020-present');
SET @g_baleno   = (SELECT id FROM generations WHERE slug='baleno-wb-hatchback-2015-2022');
SET @g_celerio  = (SELECT id FROM generations WHERE slug='celerio-lf-hatchback-2014-2017');
SET @g_fronx    = (SELECT id FROM generations WHERE slug='fronx-ytb-suv-2023-present');
SET @g_ignis    = (SELECT id FROM generations WHERE slug='ignis-mf-hatchback-2016-present');
SET @g_jimny    = (SELECT id FROM generations WHERE slug='jimny-jb64-suv-2018-present');
SET @g_scross1  = (SELECT id FROM generations WHERE slug='s-cross-jy-suv-2013-2021');
SET @g_scross2  = (SELECT id FROM generations WHERE slug='s-cross-yed-suv-2022-present');
SET @g_swace    = (SELECT id FROM generations WHERE slug='swace-sx10-wagon-2020-present');
SET @g_swift    = (SELECT id FROM generations WHERE slug='swift-az-hatchback-2017-2024');
SET @g_vitara   = (SELECT id FROM generations WHERE slug='vitara-ly-suv-2015-present');

-- ---------------------------------------------------------------------------
-- 4. Source rows per gen, linked to most-current owner manual.
-- ---------------------------------------------------------------------------

INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual', concat_ws(' ', CONCAT("Suzuki ", model, " Owner's Manual"), '—',
       CONCAT('MY', SUBSTRING(file_path, -8, 4), ' (', edition_code, ')')),
       id, 0, NOW(), 1
FROM manual_inventory
WHERE file_path IN (
  'manuals/Gebruikershandleiding_Suzuki_ACROSS_99011-53ZM3-25D-compressed.pdf',          -- Across MY2023
  'manuals/Gebruikershandleiding_Baleno_2018.pdf',                                        -- Baleno MY2018
  'manuals/Gebruikershandleiding_Celerio_2018_compressed.pdf',                            -- Celerio MY2018
  'manuals/Fronx_YTB_99011M74T07-01E_OM_20-Mar-25.pdf',                                   -- Fronx (2025)
  'manuals/Ignis_2022_compressed.pdf',                                                    -- Ignis MY2022
  'manuals/Jimny_2022_compressed.pdf',                                                    -- Jimny MY2022
  'manuals/Gebruikershandleiding_S-Cross_2021-min.pdf',                                   -- S-Cross JY MY2021
  'manuals/Scross_24MC_WEB_99011U63TD0-25D-compressed.pdf',                               -- S-Cross YED MY2024
  'manuals/Gebruikershandleiding_Suzuki_SWACE_99011-54ZM3-25D-min.pdf',                   -- Swace MY2024
  'manuals/Gebruikershandleiding_Swift_2021-min.pdf',                                     -- Swift AZ MY2021
  'manuals/Vitara_2024MC_WEB_99011U74SE0-25D_compressed.pdf'                              -- Vitara LY MC2 MY2024
)
AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = manual_inventory.id);

-- POST-CHECK
SELECT 'new suzuki gens'  k, COUNT(*) n FROM generations g
  JOIN models m ON m.id=g.model_id WHERE m.make_id=@mk
UNION ALL SELECT 'new suzuki models', COUNT(*) FROM models WHERE make_id=@mk
UNION ALL SELECT 'new suzuki sources', COUNT(*) FROM sources s
  JOIN manual_inventory mi ON mi.id = s.manual_inventory_id
  WHERE mi.brand='suzuki';

COMMIT;
