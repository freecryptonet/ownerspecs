-- mig 521 — widen Toyota EU catalog so the Tweddle owner-manual corpus attaches.
--
-- 182 Toyota EU OMs (2010-2025) sit behind the manufacturer's customer-manuals
-- portal but the DB only has 11 US-focused Toyota gens — so they don't attach.
--
-- This seeds the EU-market nameplates with their chassis codes (Toyota factory
-- platform codes: J-prefix for ladder-frame, XW for Prius, XP for Yaris/Corolla,
-- AN for Hilux, etc.) so the backfill's chassis tiebreaker can land each PDF on
-- the matching gen — especially for nameplates with multiple gens in the corpus
-- (Land Cruiser 70/100/150/200, Hilux AN10/AN20/AN30, etc.).
--
-- URLs land on a Tweddle viewer (vendor — public_link=0). Per
-- [[feedback_never_name_data_vendor]] the vendor is never named in a rendered
-- column; sources cite "Toyota Owner's Manual" only.

SET NAMES utf8mb4;

SET @toy := (SELECT id FROM makes WHERE slug='toyota');

-- 1. New models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@toy, 'auris',         'Auris'),
  (@toy, 'avensis',       'Avensis'),
  (@toy, 'aygo',          'Aygo'),
  (@toy, 'aygo-x',        'Aygo X'),
  (@toy, 'bz4x',          'bZ4X'),
  (@toy, 'c-hr',          'C-HR'),
  (@toy, 'corolla-cross', 'Corolla Cross'),
  (@toy, 'gr-86',         'GR 86'),
  (@toy, 'gr-supra',      'GR Supra'),
  (@toy, 'gr-yaris',      'GR Yaris'),
  (@toy, 'gt-86',         'GT 86'),
  (@toy, 'hilux',         'Hilux'),
  (@toy, 'iq',            'iQ'),
  (@toy, 'land-cruiser',  'Land Cruiser'),
  (@toy, 'mirai',         'Mirai'),
  (@toy, 'proace',        'PROACE'),
  (@toy, 'proace-city',   'PROACE CITY'),
  (@toy, 'proace-max',    'PROACE MAX'),
  (@toy, 'proace-verso',  'PROACE Verso'),
  (@toy, 'urban-cruiser', 'Urban Cruiser'),
  (@toy, 'verso',         'Verso'),
  (@toy, 'yaris',         'Yaris'),
  (@toy, 'yaris-cross',   'Yaris Cross'),
  (@toy, 'yaris-grmn',    'Yaris GRMN');

-- Resolve all model IDs
SET @m_auris         := (SELECT id FROM models WHERE make_id=@toy AND slug='auris');
SET @m_avensis       := (SELECT id FROM models WHERE make_id=@toy AND slug='avensis');
SET @m_aygo          := (SELECT id FROM models WHERE make_id=@toy AND slug='aygo');
SET @m_aygo_x        := (SELECT id FROM models WHERE make_id=@toy AND slug='aygo-x');
SET @m_bz4x          := (SELECT id FROM models WHERE make_id=@toy AND slug='bz4x');
SET @m_c_hr          := (SELECT id FROM models WHERE make_id=@toy AND slug='c-hr');
SET @m_corolla       := (SELECT id FROM models WHERE make_id=@toy AND slug='corolla');
SET @m_corolla_cross := (SELECT id FROM models WHERE make_id=@toy AND slug='corolla-cross');
SET @m_gr_86         := (SELECT id FROM models WHERE make_id=@toy AND slug='gr-86');
SET @m_gr_supra      := (SELECT id FROM models WHERE make_id=@toy AND slug='gr-supra');
SET @m_gr_yaris      := (SELECT id FROM models WHERE make_id=@toy AND slug='gr-yaris');
SET @m_gt_86         := (SELECT id FROM models WHERE make_id=@toy AND slug='gt-86');
SET @m_highlander    := (SELECT id FROM models WHERE make_id=@toy AND slug='highlander');
SET @m_hilux         := (SELECT id FROM models WHERE make_id=@toy AND slug='hilux');
SET @m_iq            := (SELECT id FROM models WHERE make_id=@toy AND slug='iq');
SET @m_land_cruiser  := (SELECT id FROM models WHERE make_id=@toy AND slug='land-cruiser');
SET @m_mirai         := (SELECT id FROM models WHERE make_id=@toy AND slug='mirai');
SET @m_prius         := (SELECT id FROM models WHERE make_id=@toy AND slug='prius');
SET @m_proace        := (SELECT id FROM models WHERE make_id=@toy AND slug='proace');
SET @m_proace_city   := (SELECT id FROM models WHERE make_id=@toy AND slug='proace-city');
SET @m_proace_max    := (SELECT id FROM models WHERE make_id=@toy AND slug='proace-max');
SET @m_proace_verso  := (SELECT id FROM models WHERE make_id=@toy AND slug='proace-verso');
SET @m_rav4          := (SELECT id FROM models WHERE make_id=@toy AND slug='rav4');
SET @m_urban_cruiser := (SELECT id FROM models WHERE make_id=@toy AND slug='urban-cruiser');
SET @m_verso         := (SELECT id FROM models WHERE make_id=@toy AND slug='verso');
SET @m_yaris         := (SELECT id FROM models WHERE make_id=@toy AND slug='yaris');
SET @m_yaris_cross   := (SELECT id FROM models WHERE make_id=@toy AND slug='yaris-cross');
SET @m_yaris_grmn    := (SELECT id FROM models WHERE make_id=@toy AND slug='yaris-grmn');

-- 2. New gens. Codenames are the Toyota chassis platform codes.
INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  -- Auris (E150 gen 1 + E180 gen 2 — Corolla nameplate in EU before 2019)
  (@m_auris,         'auris-e150-hatchback-2007-2012',         'E150',  'Toyota Auris I (E150)',           'Hatchback',   2007, 2012, 'FWD', 1),
  (@m_auris,         'auris-e180-hatchback-2013-2018',         'E180',  'Toyota Auris II (E180)',          'Hatchback',   2013, 2018, 'FWD', 1),
  -- Avensis (T270 gen 3 — Corolla executive variant, EU)
  (@m_avensis,       'avensis-t270-sedan-2009-2018',           'T270',  'Toyota Avensis III (T270)',       'Sedan',       2009, 2018, 'FWD', 1),
  -- Aygo (AB10 gen 1 + AB40 gen 2)
  (@m_aygo,          'aygo-ab10-hatchback-2005-2014',          'AB10',  'Toyota Aygo I (AB10)',            'Hatchback',   2005, 2014, 'FWD', 1),
  (@m_aygo,          'aygo-ab40-hatchback-2014-2022',          'AB40',  'Toyota Aygo II (AB40)',           'Hatchback',   2014, 2022, 'FWD', 1),
  -- Aygo X (AB70)
  (@m_aygo_x,        'aygo-x-ab70-hatchback-2022-present',     'AB70',  'Toyota Aygo X (AB70)',            'Hatchback',   2022, NULL, 'FWD', 1),
  -- bZ4X (XZ10)
  (@m_bz4x,          'bz4x-xz10-suv-2022-present',             'XZ10',  'Toyota bZ4X (XZ10)',              'SUV',         2022, NULL, 'AWD', 1),
  -- C-HR (AX10 gen 1 + AX20 gen 2)
  (@m_c_hr,          'c-hr-ax10-suv-2016-2023',                'AX10',  'Toyota C-HR I (AX10)',            'SUV',         2016, 2023, 'FWD', 1),
  (@m_c_hr,          'c-hr-ax20-suv-2023-present',             'AX20',  'Toyota C-HR II (AX20)',           'SUV',         2023, NULL, 'FWD', 1),
  -- Corolla — EU adds E210 hatchback + touring sports body variants on existing E210 gen
  (@m_corolla,       'corolla-e210-hatchback-2019-present',    'E210',  'Toyota Corolla XII Hatchback (E210)', 'Hatchback', 2019, NULL, 'FWD', 1),
  (@m_corolla,       'corolla-e210-wagon-2019-present',        'E210',  'Toyota Corolla XII Touring Sports (E210)', 'Wagon', 2019, NULL, 'FWD', 1),
  -- Corolla Cross (G10)
  (@m_corolla_cross, 'corolla-cross-g10-suv-2021-present',     'G10',   'Toyota Corolla Cross (G10)',      'SUV',         2021, NULL, 'FWD', 1),
  -- GR 86 (ZN8)
  (@m_gr_86,         'gr-86-zn8-coupe-2022-present',           'ZN8',   'Toyota GR 86 (ZN8)',              'Coupe',       2022, NULL, 'RWD', 1),
  -- GR Supra (A90)
  (@m_gr_supra,      'gr-supra-a90-coupe-2019-present',        'A90',   'Toyota GR Supra (A90)',           'Coupe',       2019, NULL, 'RWD', 1),
  -- GR Yaris (XP210)
  (@m_gr_yaris,      'gr-yaris-xp210-hatchback-2020-present',  'XP210', 'Toyota GR Yaris (XP210)',         'Hatchback',   2020, NULL, 'AWD', 1),
  -- GT 86 (ZN6) — predecessor of GR 86
  (@m_gt_86,         'gt-86-zn6-coupe-2012-2020',              'ZN6',   'Toyota GT 86 (ZN6)',              'Coupe',       2012, 2020, 'RWD', 1),
  -- Highlander EU — gen 4 XU70 already in DB; add no-op
  -- Hilux (AN20 gen 7 + AN30 gen 7 facelift + AN120/130 gen 8)
  (@m_hilux,         'hilux-an20-an30-pickup-2005-2015',       'AN20',  'Toyota Hilux VII (AN20/AN30)',    'Pickup',      2005, 2015, 'RWD', 1),
  (@m_hilux,         'hilux-an120-an130-pickup-2015-present',  'AN120', 'Toyota Hilux VIII (AN120/AN130)', 'Pickup',      2015, NULL, 'RWD', 1),
  -- iQ (AJ10)
  (@m_iq,            'iq-aj10-hatchback-2008-2016',            'AJ10',  'Toyota iQ (AJ10)',                'Hatchback',   2008, 2016, 'FWD', 1),
  -- Land Cruiser (J70, J100, J150 "Prado", J200, J250, J300 — multiple still in production globally)
  (@m_land_cruiser,  'land-cruiser-j70-suv-1984-present',      'J70',   'Toyota Land Cruiser 70 (J70)',    'SUV',         1984, NULL, 'AWD', 1),
  (@m_land_cruiser,  'land-cruiser-j100-suv-1998-2007',        'J100',  'Toyota Land Cruiser 100 (J100)',  'SUV',         1998, 2007, 'AWD', 1),
  (@m_land_cruiser,  'land-cruiser-j150-suv-2009-2024',        'J150',  'Toyota Land Cruiser Prado (J150)','SUV',         2009, 2024, 'AWD', 1),
  (@m_land_cruiser,  'land-cruiser-j200-suv-2007-2021',        'J200',  'Toyota Land Cruiser 200 (J200)',  'SUV',         2007, 2021, 'AWD', 1),
  (@m_land_cruiser,  'land-cruiser-j250-suv-2024-present',     'J250',  'Toyota Land Cruiser Prado (J250)','SUV',         2024, NULL, 'AWD', 1),
  (@m_land_cruiser,  'land-cruiser-j300-suv-2021-present',     'J300',  'Toyota Land Cruiser 300 (J300)',  'SUV',         2021, NULL, 'AWD', 1),
  -- Mirai (JPD10 + JPD20)
  (@m_mirai,         'mirai-jpd10-sedan-2014-2020',            'JPD10', 'Toyota Mirai I (JPD10)',          'Sedan',       2014, 2020, 'FWD', 1),
  (@m_mirai,         'mirai-jpd20-sedan-2020-present',         'JPD20', 'Toyota Mirai II (JPD20)',         'Sedan',       2020, NULL, 'RWD', 1),
  -- Prius EU adds XW50 gen 4 (XW60 already in DB)
  (@m_prius,         'prius-xw50-hatchback-2015-2022',         'XW50',  'Toyota Prius IV (XW50)',          'Hatchback',   2015, 2022, 'FWD', 1),
  -- PROACE (G2/G3 commercial — Stellantis-built)
  (@m_proace,        'proace-g3-van-2016-present',             'G3',    'Toyota PROACE Medium (G3)',       'Hatchback',   2016, NULL, 'FWD', 1),
  (@m_proace_city,   'proace-city-k9-van-2019-present',        'K9',    'Toyota PROACE City (K9)',         'Hatchback',   2019, NULL, 'FWD', 1),
  (@m_proace_max,    'proace-max-y4-van-2024-present',         'Y4',    'Toyota PROACE Max (Y4)',          'Hatchback',   2024, NULL, 'RWD', 1),
  (@m_proace_verso,  'proace-verso-g3-minivan-2016-present',   'G3',    'Toyota PROACE Verso (G3)',        'Minivan',     2016, NULL, 'FWD', 1),
  -- RAV4 EU XA50 already in DB
  -- Urban Cruiser (S35 gen 1 + GE85 EV gen 2)
  (@m_urban_cruiser, 'urban-cruiser-s35-suv-2009-2014',        'S35',   'Toyota Urban Cruiser I (S35)',    'SUV',         2009, 2014, 'AWD', 1),
  (@m_urban_cruiser, 'urban-cruiser-ge85-suv-2025-present',    'GE85',  'Toyota Urban Cruiser II (GE85)',  'SUV',         2025, NULL, 'AWD', 1),
  -- Verso (R20 — Corolla-based MPV)
  (@m_verso,         'verso-r20-minivan-2009-2018',            'R20',   'Toyota Verso (R20)',              'Minivan',     2009, 2018, 'FWD', 1),
  -- Yaris (XP10 gen 1 + XP90 gen 2 + XP130 gen 3 + XP150 gen 4 + XP210 gen 5)
  (@m_yaris,         'yaris-xp90-hatchback-2005-2010',         'XP90',  'Toyota Yaris II (XP90)',          'Hatchback',   2005, 2010, 'FWD', 1),
  (@m_yaris,         'yaris-xp130-hatchback-2011-2019',        'XP130', 'Toyota Yaris III (XP130)',        'Hatchback',   2011, 2019, 'FWD', 1),
  (@m_yaris,         'yaris-xp150-hatchback-2020-present',     'XP150', 'Toyota Yaris IV (XP150)',         'Hatchback',   2020, NULL, 'FWD', 1),
  -- Yaris Cross (XP210)
  (@m_yaris_cross,   'yaris-cross-xp210-suv-2021-present',     'XP210', 'Toyota Yaris Cross (XP210)',      'SUV',         2021, NULL, 'FWD', 1),
  -- Yaris GRMN (XP130 hot-hatch limited)
  (@m_yaris_grmn,    'yaris-grmn-xp130-hatchback-2017-2018',   'XP130', 'Toyota Yaris GRMN (XP130)',       'Hatchback',   2017, 2018, 'FWD', 1);
