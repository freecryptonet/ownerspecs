-- mig 520 — widen Kia catalog so the 260-PDF CA corpus attaches.
--
-- Backfill currently matches 4 of 4 existing Kia gens (EV6, Sorento MQ4,
-- Sportage NQ5, Telluride ON). The other 250-ish PDFs sit on disk because
-- the DB lacks the corresponding chassis-coded gens — Kia's CA portal
-- publishes one OM per (model, model-year) for ~30 nameplates 2007-2027.
--
-- Codenames are the published Kia chassis codes for each generation
-- (Kia uses single-word internal designations like TF, JF, DL3, MQ4,
-- not Hyundai-style platform codes). Where Kia rebrands a nameplate
-- mid-life (Magentis→Optima→K5, Sedona→Carnival, Borrego/Mohave global,
-- Spectra→Forte), each badge gets its own model row — keeps OM attach 1:1.
--
-- Catalog-only seed; per the render-gate downgrade these render as
-- "Catalogue data · owner-manual data in progress" until moat-fill.

SET NAMES utf8mb4;

SET @kia := (SELECT id FROM makes WHERE slug='kia');

-- 1. New models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@kia, 'amanti',   'Amanti'),
  (@kia, 'borrego',  'Borrego'),
  (@kia, 'cadenza',  'Cadenza'),
  (@kia, 'carnival', 'Carnival'),
  (@kia, 'ev5',      'EV5'),
  (@kia, 'ev9',      'EV9'),
  (@kia, 'forte',    'Forte'),
  (@kia, 'k4',       'K4'),
  (@kia, 'k5',       'K5'),
  (@kia, 'k900',     'K900'),
  (@kia, 'magentis', 'Magentis'),
  (@kia, 'niro',     'Niro'),
  (@kia, 'optima',   'Optima'),
  (@kia, 'rio',      'Rio'),
  (@kia, 'rondo',    'Rondo'),
  (@kia, 'sedona',   'Sedona'),
  (@kia, 'seltos',   'Seltos'),
  (@kia, 'sephia',   'Sephia'),
  (@kia, 'sorento',  'Sorento'),
  (@kia, 'soul',     'Soul'),
  (@kia, 'spectra',  'Spectra'),
  (@kia, 'sportage', 'Sportage'),
  (@kia, 'stinger',  'Stinger');

-- Resolve all model IDs we reference
SET @m_amanti    := (SELECT id FROM models WHERE make_id=@kia AND slug='amanti');
SET @m_borrego   := (SELECT id FROM models WHERE make_id=@kia AND slug='borrego');
SET @m_cadenza   := (SELECT id FROM models WHERE make_id=@kia AND slug='cadenza');
SET @m_carnival  := (SELECT id FROM models WHERE make_id=@kia AND slug='carnival');
SET @m_ev5       := (SELECT id FROM models WHERE make_id=@kia AND slug='ev5');
SET @m_ev9       := (SELECT id FROM models WHERE make_id=@kia AND slug='ev9');
SET @m_forte     := (SELECT id FROM models WHERE make_id=@kia AND slug='forte');
SET @m_k4        := (SELECT id FROM models WHERE make_id=@kia AND slug='k4');
SET @m_k5        := (SELECT id FROM models WHERE make_id=@kia AND slug='k5');
SET @m_k900      := (SELECT id FROM models WHERE make_id=@kia AND slug='k900');
SET @m_magentis  := (SELECT id FROM models WHERE make_id=@kia AND slug='magentis');
SET @m_niro      := (SELECT id FROM models WHERE make_id=@kia AND slug='niro');
SET @m_optima    := (SELECT id FROM models WHERE make_id=@kia AND slug='optima');
SET @m_rio       := (SELECT id FROM models WHERE make_id=@kia AND slug='rio');
SET @m_rondo     := (SELECT id FROM models WHERE make_id=@kia AND slug='rondo');
SET @m_sedona    := (SELECT id FROM models WHERE make_id=@kia AND slug='sedona');
SET @m_seltos    := (SELECT id FROM models WHERE make_id=@kia AND slug='seltos');
SET @m_sephia    := (SELECT id FROM models WHERE make_id=@kia AND slug='sephia');
SET @m_sorento   := (SELECT id FROM models WHERE make_id=@kia AND slug='sorento');
SET @m_soul      := (SELECT id FROM models WHERE make_id=@kia AND slug='soul');
SET @m_spectra   := (SELECT id FROM models WHERE make_id=@kia AND slug='spectra');
SET @m_sportage  := (SELECT id FROM models WHERE make_id=@kia AND slug='sportage');
SET @m_stinger   := (SELECT id FROM models WHERE make_id=@kia AND slug='stinger');

-- 2. Extend existing gens whose chassis spans past their original end_year
UPDATE generations
SET end_year = NULL
WHERE codename IN ('MQ4','NQ5') AND model_id IN (
  SELECT id FROM models WHERE make_id=@kia AND slug IN ('sorento','sportage')
);

-- 3. New gens covering the PDF corpus (2007-2027).
INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  -- Amanti (GH) — sold as Opirus elsewhere; US/CA 2004-2010
  (@m_amanti,   'amanti-gh-sedan-2004-2010',          'GH',   'Kia Amanti (GH)',                  'Sedan',     2004, 2010, 'FWD', 1),
  -- Borrego / Mohave (HM) — US only one model year, global multiple
  (@m_borrego,  'borrego-hm-suv-2009-2011',           'HM',   'Kia Borrego (HM)',                 'SUV',       2009, 2011, 'AWD', 1),
  -- Cadenza (VG gen 1 + YG gen 2)
  (@m_cadenza,  'cadenza-vg-sedan-2011-2016',         'VG',   'Kia Cadenza I (VG)',               'Sedan',     2011, 2016, 'FWD', 1),
  (@m_cadenza,  'cadenza-yg-sedan-2017-2021',         'YG',   'Kia Cadenza II (YG)',              'Sedan',     2017, 2021, 'FWD', 1),
  -- Carnival (KA4)
  (@m_carnival, 'carnival-ka4-minivan-2022-present',  'KA4',  'Kia Carnival (KA4)',               'Minivan',   2022, NULL, 'FWD', 1),
  -- EV5 (OV1) + EV9 (MV)
  (@m_ev5,      'ev5-ov1-suv-2024-present',           'OV1',  'Kia EV5 (OV1)',                    'SUV',       2024, NULL, 'AWD', 1),
  (@m_ev9,      'ev9-mv-suv-2023-present',            'MV',   'Kia EV9 (MV)',                     'SUV',       2023, NULL, 'AWD', 1),
  -- Forte (TD gen 1 + YD gen 2 + BD gen 3)
  (@m_forte,    'forte-td-sedan-2009-2013',           'TD',   'Kia Forte I (TD)',                 'Sedan',     2009, 2013, 'FWD', 1),
  (@m_forte,    'forte-yd-sedan-2014-2018',           'YD',   'Kia Forte II (YD)',                'Sedan',     2014, 2018, 'FWD', 1),
  (@m_forte,    'forte-bd-sedan-2019-2024',           'BD',   'Kia Forte III (BD)',               'Sedan',     2019, 2024, 'FWD', 1),
  -- K4 (NA0)
  (@m_k4,       'k4-na0-sedan-2025-present',          'NA0',  'Kia K4 (NA0)',                     'Sedan',     2025, NULL, 'FWD', 1),
  -- K5 (DL3) — Optima rebrand for gen 5
  (@m_k5,       'k5-dl3-sedan-2021-present',          'DL3',  'Kia K5 (DL3)',                     'Sedan',     2021, NULL, 'FWD', 1),
  -- K900 (KH gen 1 + RJ gen 2)
  (@m_k900,     'k900-kh-sedan-2014-2017',            'KH',   'Kia K900 I (KH)',                  'Sedan',     2014, 2017, 'RWD', 1),
  (@m_k900,     'k900-rj-sedan-2019-2020',            'RJ',   'Kia K900 II (RJ)',                 'Sedan',     2019, 2020, 'RWD', 1),
  -- Magentis (MG) — became Optima
  (@m_magentis, 'magentis-mg-sedan-2006-2010',        'MG',   'Kia Magentis (MG)',                'Sedan',     2006, 2010, 'FWD', 1),
  -- Niro (DE gen 1 + SG2 gen 2)
  (@m_niro,     'niro-de-suv-2017-2021',              'DE',   'Kia Niro I (DE)',                  'SUV',       2017, 2021, 'FWD', 1),
  (@m_niro,     'niro-sg2-suv-2023-present',          'SG2',  'Kia Niro II (SG2)',                'SUV',       2023, NULL, 'FWD', 1),
  -- Optima (TF gen 3 + JF gen 4) — gen 5 is K5
  (@m_optima,   'optima-tf-sedan-2011-2015',          'TF',   'Kia Optima III (TF)',              'Sedan',     2011, 2015, 'FWD', 1),
  (@m_optima,   'optima-jf-sedan-2016-2020',          'JF',   'Kia Optima IV (JF)',               'Sedan',     2016, 2020, 'FWD', 1),
  -- Rio (UB gen 3 + YB gen 4 + SC gen 5)
  (@m_rio,      'rio-ub-hatchback-2012-2017',         'UB',   'Kia Rio III (UB)',                 'Hatchback', 2012, 2017, 'FWD', 1),
  (@m_rio,      'rio-yb-hatchback-2018-2023',         'YB',   'Kia Rio IV (YB)',                  'Hatchback', 2018, 2023, 'FWD', 1),
  -- Rondo / Carens (RP)
  (@m_rondo,    'rondo-rp-minivan-2014-2017',         'RP',   'Kia Rondo (RP)',                   'Minivan',   2014, 2017, 'FWD', 1),
  -- Sedona / Carnival (VQ gen 2 + YP gen 3) — gen 4 is Carnival KA4
  (@m_sedona,   'sedona-vq-minivan-2006-2014',        'VQ',   'Kia Sedona II (VQ)',               'Minivan',   2006, 2014, 'FWD', 1),
  (@m_sedona,   'sedona-yp-minivan-2015-2021',        'YP',   'Kia Sedona III (YP)',              'Minivan',   2015, 2021, 'FWD', 1),
  -- Seltos (SP2)
  (@m_seltos,   'seltos-sp2-suv-2020-present',        'SP2',  'Kia Seltos (SP2)',                 'SUV',       2020, NULL, 'FWD', 1),
  -- Sephia (FA) — early compact
  (@m_sephia,   'sephia-fa-sedan-1998-2001',          'FA',   'Kia Sephia II (FA)',               'Sedan',     1998, 2001, 'FWD', 1),
  -- Sorento (BL gen 1 + XM gen 2 + UM gen 3 — MQ4 already in DB)
  (@m_sorento,  'sorento-bl-suv-2003-2009',           'BL',   'Kia Sorento I (BL)',               'SUV',       2003, 2009, 'AWD', 1),
  (@m_sorento,  'sorento-xm-suv-2010-2015',           'XM',   'Kia Sorento II (XM)',              'SUV',       2010, 2015, 'AWD', 1),
  (@m_sorento,  'sorento-um-suv-2016-2020',           'UM',   'Kia Sorento III (UM)',             'SUV',       2016, 2020, 'AWD', 1),
  -- Soul (AM gen 1 + PS gen 2 + SK3 gen 3)
  (@m_soul,     'soul-am-hatchback-2008-2013',        'AM',   'Kia Soul I (AM)',                  'Hatchback', 2008, 2013, 'FWD', 1),
  (@m_soul,     'soul-ps-hatchback-2014-2019',        'PS',   'Kia Soul II (PS)',                 'Hatchback', 2014, 2019, 'FWD', 1),
  (@m_soul,     'soul-sk3-hatchback-2020-present',    'SK3',  'Kia Soul III (SK3)',               'Hatchback', 2020, NULL, 'FWD', 1),
  -- Spectra (LD) — replaced by Forte
  (@m_spectra,  'spectra-ld-sedan-2005-2009',         'LD',   'Kia Spectra (LD)',                 'Sedan',     2005, 2009, 'FWD', 1),
  -- Sportage (SL gen 3 + QL gen 4 — NQ5 already in DB)
  (@m_sportage, 'sportage-sl-suv-2011-2016',          'SL',   'Kia Sportage III (SL)',            'SUV',       2011, 2016, 'AWD', 1),
  (@m_sportage, 'sportage-ql-suv-2017-2022',          'QL',   'Kia Sportage IV (QL)',             'SUV',       2017, 2022, 'AWD', 1),
  -- Stinger (CK)
  (@m_stinger,  'stinger-ck-sedan-2018-2023',         'CK',   'Kia Stinger (CK)',                 'Sedan',     2018, 2023, 'RWD', 1);
