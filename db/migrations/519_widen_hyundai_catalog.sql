-- mig 519 — widen Hyundai catalog so the 70-PDF NL corpus attaches.
--
-- Backfill currently matches 5 of 7 existing Hyundai gens (i20 GB, IONIQ 5
-- NE1, Kona SX2, Santa Fe TM, Tucson NX4). The other 65 PDFs sit on disk
-- because the DB lacks the corresponding chassis-coded gens.
--
-- Hyundai uses platform codes in the OEM PDF filenames (BC3, AC3, GB, PDe,
-- AE, NE, CE, AX1, etc.) — these are the strongest disambiguators for
-- sibling cars sharing a platform (i20 BC3 vs Bayon BC3) and feed straight
-- into the chassis tiebreaker in backfill_oem_manual_urls.py.
--
-- Catalog-only seed; per the render-gate downgrade these render as
-- "Catalogue data · owner-manual data in progress" until moat-fill.

SET NAMES utf8mb4;

SET @hyu := (SELECT id FROM makes WHERE slug='hyundai');

-- 1. New models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@hyu, 'bayon',   'Bayon'),
  (@hyu, 'i10',     'i10'),
  (@hyu, 'i30',     'i30'),
  (@hyu, 'i40',     'i40'),
  (@hyu, 'inster',  'Inster'),
  (@hyu, 'ioniq',   'IONIQ'),
  (@hyu, 'ioniq-6', 'IONIQ 6'),
  (@hyu, 'ix20',    'ix20'),
  (@hyu, 'nexo',    'Nexo');

-- Resolve all model IDs we reference
SET @m_bayon    := (SELECT id FROM models WHERE make_id=@hyu AND slug='bayon');
SET @m_i10      := (SELECT id FROM models WHERE make_id=@hyu AND slug='i10');
SET @m_i20      := (SELECT id FROM models WHERE make_id=@hyu AND slug='i20');
SET @m_i30      := (SELECT id FROM models WHERE make_id=@hyu AND slug='i30');
SET @m_i40      := (SELECT id FROM models WHERE make_id=@hyu AND slug='i40');
SET @m_inster   := (SELECT id FROM models WHERE make_id=@hyu AND slug='inster');
SET @m_ioniq    := (SELECT id FROM models WHERE make_id=@hyu AND slug='ioniq');
SET @m_ioniq6   := (SELECT id FROM models WHERE make_id=@hyu AND slug='ioniq-6');
SET @m_ix20     := (SELECT id FROM models WHERE make_id=@hyu AND slug='ix20');
SET @m_kona     := (SELECT id FROM models WHERE make_id=@hyu AND slug='kona');
SET @m_nexo     := (SELECT id FROM models WHERE make_id=@hyu AND slug='nexo');
SET @m_santa_fe := (SELECT id FROM models WHERE make_id=@hyu AND slug='santa-fe');
SET @m_tucson   := (SELECT id FROM models WHERE make_id=@hyu AND slug='tucson');

-- 2. Extend tucson NX4 (the 2024 facelift kept the chassis code; 2025 PDFs
--    should attach to this gen rather than orphan).
UPDATE generations
SET end_year = NULL
WHERE model_id=@m_tucson AND slug='tucson-nx4-suv-2021-2024';

-- 3. New gens. Codenames are the Hyundai platform codes seen in the PDF
--    filenames; the backfill chassis tiebreaker keys on these.
INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  -- Bayon (BC3 platform — same as i20 gen 3)
  (@m_bayon,    'bayon-bc3-suv-2021-present',           'BC3',  'Hyundai Bayon (BC3)',                   'SUV',         2021, NULL, 'FWD', 1),
  -- i10 (gen 2 IA + gen 3 AC3)
  (@m_i10,      'i10-ia-hatchback-2014-2019',           'IA',   'Hyundai i10 II (IA)',                   'Hatchback',   2014, 2019, 'FWD', 1),
  (@m_i10,      'i10-ac3-hatchback-2020-present',       'AC3',  'Hyundai i10 III (AC3)',                 'Hatchback',   2020, NULL, 'FWD', 1),
  -- i20 (gen 1 PB; gen 3 BC3 — existing GB gen 2 already in DB)
  (@m_i20,      'i20-pb-hatchback-2008-2014',           'PB',   'Hyundai i20 I (PB)',                    'Hatchback',   2008, 2014, 'FWD', 1),
  (@m_i20,      'i20-bc3-hatchback-2020-present',       'BC3',  'Hyundai i20 III (BC3)',                 'Hatchback',   2020, NULL, 'FWD', 1),
  -- i30 (gen 2 GD/GDe; gen 3 PD/PDe)
  (@m_i30,      'i30-gde-hatchback-2012-2017',          'GDe',  'Hyundai i30 II (GDe)',                  'Hatchback',   2012, 2017, 'FWD', 1),
  (@m_i30,      'i30-pde-hatchback-2017-present',       'PDe',  'Hyundai i30 III (PDe)',                 'Hatchback',   2017, NULL, 'FWD', 1),
  -- i40 (VF)
  (@m_i40,      'i40-vf-sedan-2011-2019',               'VF',   'Hyundai i40 (VF)',                      'Sedan',       2011, 2019, 'FWD', 1),
  -- Inster (AX1, BEV)
  (@m_inster,   'inster-ax1-hatchback-2024-present',    'AX1',  'Hyundai Inster (AX1)',                  'Hatchback',   2024, NULL, 'FWD', 1),
  -- IONIQ first gen (AE — sold as Electric / Hybrid / Plug-in PHEV, single chassis)
  (@m_ioniq,    'ioniq-ae-hatchback-2016-2022',         'AE',   'Hyundai IONIQ (AE)',                    'Hatchback',   2016, 2022, 'FWD', 1),
  -- IONIQ 6 (CE)
  (@m_ioniq6,   'ioniq-6-ce-sedan-2022-present',        'CE',   'Hyundai IONIQ 6 (CE)',                  'Sedan',       2022, NULL, 'AWD', 1),
  -- ix20 (JC)
  (@m_ix20,     'ix20-jc-hatchback-2010-2019',          'JC',   'Hyundai ix20 (JC)',                     'Hatchback',   2010, 2019, 'FWD', 1),
  -- Kona gen 1 (OS — covers ICE + Electric + N trim, single chassis)
  (@m_kona,     'kona-os-suv-2017-2023',                'OS',   'Hyundai Kona I (OS)',                   'SUV',         2017, 2023, 'FWD', 1),
  -- Nexo (FE, fuel-cell)
  (@m_nexo,     'nexo-fe-suv-2018-present',             'FE',   'Hyundai Nexo (FE)',                     'SUV',         2018, NULL, 'FWD', 1),
  -- Santa Fe gen 3 (DM) and gen 5 (MX5 — TM is existing)
  (@m_santa_fe, 'santa-fe-dm-suv-2012-2018',            'DM',   'Hyundai Santa Fe III (DM)',             'SUV',         2012, 2018, 'AWD', 1),
  (@m_santa_fe, 'santa-fe-mx5-suv-2024-present',        'MX5',  'Hyundai Santa Fe V (MX5)',              'SUV',         2024, NULL, 'AWD', 1),
  -- Tucson gen 3 (TLe — NX4 is existing)
  (@m_tucson,   'tucson-tle-suv-2015-2020',             'TLe',  'Hyundai Tucson III (TLe)',              'SUV',         2015, 2020, 'FWD', 1);
