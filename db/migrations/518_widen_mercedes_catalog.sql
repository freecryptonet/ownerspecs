-- mig 518 — widen Mercedes-Benz catalog so the 33-PDF OEM corpus attaches.
--
-- Why: mig 516+517 added the OEM-manual download card; Mercedes had 8 matches
-- (4 correct, 4 wrong) on the previous backfill run, and after the body-style
-- discriminator landed in mig 517's backfill update only 4 attached. The other
-- 29 PDFs sit on disk because the DB lacked the corresponding models/gens.
--
-- This is catalog-only seed (per the render-gate downgrade — gens render
-- as "Catalogue data · owner-manual data in progress" until moat-fill).
-- Codenames are accurate per Mercedes' factory chassis codes (W = saloon,
-- S = wagon, C = coupe, A = cabriolet, V = LWB/Maybach, X = SUV, E = electric,
-- H = compact-SUV) — the backfill chassis tiebreaker reads `codename` so
-- W465 vs E465 PDFs land on the correct gen.
--
-- Extends gle-v167 end_year to NULL — V167 was facelifted in 2024 but the
-- chassis code is unchanged, so the 2025 OEM PDF should attach to the
-- existing gen rather than orphan.

SET NAMES utf8mb4;

SET @mb := (SELECT id FROM makes WHERE slug='mercedes-benz');

-- 1. New models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@mb, 'amg-gt',  'AMG GT'),
  (@mb, 'cla',     'CLA'),
  (@mb, 'cle',     'CLE'),
  (@mb, 'eqb',     'EQB'),
  (@mb, 'eqe',     'EQE'),
  (@mb, 'eqs',     'EQS'),
  (@mb, 'g-class', 'G-Class'),
  (@mb, 'gla',     'GLA'),
  (@mb, 'glb',     'GLB'),
  (@mb, 'gls',     'GLS'),
  (@mb, 's-class', 'S-Class');

-- Resolve all model IDs we'll reference
SET @m_a_class := (SELECT id FROM models WHERE make_id=@mb AND slug='a-class');
SET @m_c_class := (SELECT id FROM models WHERE make_id=@mb AND slug='c-class');
SET @m_e_class := (SELECT id FROM models WHERE make_id=@mb AND slug='e-class');
SET @m_glc     := (SELECT id FROM models WHERE make_id=@mb AND slug='glc');
SET @m_gle     := (SELECT id FROM models WHERE make_id=@mb AND slug='gle');
SET @m_amg_gt  := (SELECT id FROM models WHERE make_id=@mb AND slug='amg-gt');
SET @m_cla     := (SELECT id FROM models WHERE make_id=@mb AND slug='cla');
SET @m_cle     := (SELECT id FROM models WHERE make_id=@mb AND slug='cle');
SET @m_eqb     := (SELECT id FROM models WHERE make_id=@mb AND slug='eqb');
SET @m_eqe     := (SELECT id FROM models WHERE make_id=@mb AND slug='eqe');
SET @m_eqs     := (SELECT id FROM models WHERE make_id=@mb AND slug='eqs');
SET @m_g_class := (SELECT id FROM models WHERE make_id=@mb AND slug='g-class');
SET @m_gla     := (SELECT id FROM models WHERE make_id=@mb AND slug='gla');
SET @m_glb     := (SELECT id FROM models WHERE make_id=@mb AND slug='glb');
SET @m_gls     := (SELECT id FROM models WHERE make_id=@mb AND slug='gls');
SET @m_s_class := (SELECT id FROM models WHERE make_id=@mb AND slug='s-class');

-- 2. Extend GLE V167 end-year (facelift 2024 = same chassis)
UPDATE generations
SET end_year = NULL
WHERE model_id=@m_gle AND slug='gle-v167-suv-2019-2023';

-- 3. New gens. Each row maps to a unique chassis code in the OEM PDF corpus
--    (33 PDFs, see manuals/mercedes_*.pdf). Codenames are written exactly so
--    the chassis tiebreaker in backfill_oem_manual_urls.py can disambiguate
--    same-body sibling chassis (g-class W465 vs E465, etc.).
INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  -- New body-variant gens for existing models
  (@m_a_class, 'a-class-v177-sedan-2018-present',     'V177', 'Mercedes-Benz A-Class Sedan (V177)',     'Sedan',       2018, NULL, 'FWD', 1),
  (@m_c_class, 'c-class-wagon-s205-2014-2021',        'S205', 'Mercedes-Benz C-Class Estate (S205)',    'Wagon',       2014, 2021, 'RWD', 1),
  (@m_e_class, 'e-class-wagon-s214-2023-present',     'S214', 'Mercedes-Benz E-Class Estate (S214)',    'Wagon',       2023, NULL, 'RWD', 1),
  (@m_glc,     'glc-x254-suv-2023-present',           'X254', 'Mercedes-Benz GLC (X254)',               'SUV',         2023, NULL, 'AWD', 1),
  (@m_glc,     'glc-coupe-c254-2023-present',         'C254', 'Mercedes-Benz GLC Coupe (C254)',         'Coupe',       2023, NULL, 'AWD', 1),
  (@m_gle,     'gle-coupe-c167-2020-present',         'C167', 'Mercedes-Benz GLE Coupe (C167)',         'Coupe',       2020, NULL, 'AWD', 1),

  -- AMG GT (4 gens by chassis)
  (@m_amg_gt,  'amg-gt-c190-coupe-2015-2020',         'C190', 'Mercedes-AMG GT (C190)',                 'Coupe',       2015, 2020, 'RWD', 1),
  (@m_amg_gt,  'amg-gt-r190-roadster-2017-2020',      'R190', 'Mercedes-AMG GT Roadster (R190)',        'Convertible', 2017, 2020, 'RWD', 1),
  (@m_amg_gt,  'amg-gt-c192-coupe-2024-present',      'C192', 'Mercedes-AMG GT (C192)',                 'Coupe',       2024, NULL, 'AWD', 1),
  (@m_amg_gt,  'amg-gt-x290-4door-coupe-2018-present','X290', 'Mercedes-AMG GT 4-Door Coupe (X290)',    'Coupe',       2018, NULL, 'AWD', 1),

  -- CLA (current C118, next C174)
  (@m_cla,     'cla-c118-coupe-2019-2025',            'C118', 'Mercedes-Benz CLA (C118)',               'Coupe',       2019, 2025, 'FWD', 1),
  (@m_cla,     'cla-c174-sedan-2026-present',         'C174', 'Mercedes-Benz CLA (C174)',               'Sedan',       2026, NULL, 'FWD', 1),

  -- CLE (replaces C-Coupe + E-Coupe lines)
  (@m_cle,     'cle-c236-coupe-2023-present',         'C236', 'Mercedes-Benz CLE Coupe (C236)',         'Coupe',       2023, NULL, 'RWD', 1),
  (@m_cle,     'cle-a236-cabriolet-2023-present',     'A236', 'Mercedes-Benz CLE Cabriolet (A236)',     'Cabriolet',   2023, NULL, 'RWD', 1),

  -- EQ-family BEVs
  (@m_eqb,     'eqb-x243-suv-2021-present',           'X243', 'Mercedes-Benz EQB (X243)',               'SUV',         2021, NULL, 'AWD', 1),
  (@m_eqe,     'eqe-v295-sedan-2022-present',         'V295', 'Mercedes-Benz EQE (V295)',               'Sedan',       2022, NULL, 'AWD', 1),
  (@m_eqe,     'eqe-x294-suv-2023-present',           'X294', 'Mercedes-Benz EQE SUV (X294)',           'SUV',         2023, NULL, 'AWD', 1),
  (@m_eqs,     'eqs-v297-sedan-2021-present',         'V297', 'Mercedes-Benz EQS (V297)',               'Sedan',       2021, NULL, 'AWD', 1),
  (@m_eqs,     'eqs-x296-suv-2023-present',           'X296', 'Mercedes-Benz EQS SUV (X296)',           'SUV',         2023, NULL, 'AWD', 1),

  -- G-Class current generation (W465 ICE + E465 EQG electric)
  (@m_g_class, 'g-class-w465-suv-2024-present',       'W465', 'Mercedes-Benz G-Class (W465)',           'SUV',         2024, NULL, 'AWD', 1),
  (@m_g_class, 'g-class-e465-suv-2024-present',       'E465', 'Mercedes-Benz G 580 with EQ Technology (E465)', 'SUV',  2024, NULL, 'AWD', 1),

  -- Compact + mid SUVs
  (@m_gla,     'gla-h247-suv-2020-present',           'H247', 'Mercedes-Benz GLA (H247)',               'SUV',         2020, NULL, 'AWD', 1),
  (@m_glb,     'glb-x247-suv-2019-present',           'X247', 'Mercedes-Benz GLB (X247)',               'SUV',         2019, NULL, 'AWD', 1),
  (@m_gls,     'gls-x167-suv-2019-present',           'X167', 'Mercedes-Benz GLS (X167)',               'SUV',         2019, NULL, 'AWD', 1),

  -- S-Class
  (@m_s_class, 's-class-w223-sedan-2020-present',     'W223', 'Mercedes-Benz S-Class (W223)',           'Sedan',       2020, NULL, 'RWD', 1),
  (@m_s_class, 's-class-c217-coupe-2014-2020',        'C217', 'Mercedes-Benz S-Class Coupe (C217)',     'Coupe',       2014, 2020, 'RWD', 1),
  (@m_s_class, 's-class-a217-cabriolet-2015-2020',    'A217', 'Mercedes-Benz S-Class Cabriolet (A217)', 'Cabriolet',   2015, 2020, 'RWD', 1);
