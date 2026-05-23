-- mig 291 — Catalog scaffolding for BMW 6 Series (3 chassis) + X2 (2) + iX (1).
-- 6 Series: E63/E64 (V10 M6), F06/F12/F13 (V8 M6), G32 Gran Turismo (5-door)
-- X2: F39 (1st gen FWD), U10 (2nd gen)
-- iX: I20 (large BEV SUV, discontinued 2025)

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, '6-series', '6 Series'),
  (@make_bmw, 'm6', 'M6'),
  (@make_bmw, 'x2', 'X2'),
  (@make_bmw, 'ix', 'iX');

SET @m_6  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '6-series');
SET @m_m6 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm6');
SET @m_x2 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x2');
SET @m_ix := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'ix');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- 6 Series E63/E64 family (4 gens)
  (@m_6,  '6-series-e63-coupe-2003-2010',          'E63', '6 Series Coupe (E63) 2003-2010',          'Coupe',       2003, 2010, 'RWD'),
  (@m_6,  '6-series-e64-convertible-2004-2010',    'E64', '6 Series Convertible (E64) 2004-2010',    'Convertible', 2004, 2010, 'RWD'),
  (@m_m6, 'm6-e63-coupe-2005-2010',                'E63', 'M6 Coupe (E63) V10 2005-2010',            'Coupe',       2005, 2010, 'RWD'),
  (@m_m6, 'm6-e64-convertible-2006-2010',          'E64', 'M6 Convertible (E64) V10 2006-2010',      'Convertible', 2006, 2010, 'RWD'),
  -- 6 Series F06/F12/F13 family (6 gens)
  (@m_6,  '6-series-f13-coupe-2011-2018',          'F13', '6 Series Coupe (F13) 2011-2018',          'Coupe',       2011, 2018, 'RWD'),
  (@m_6,  '6-series-f12-convertible-2011-2018',    'F12', '6 Series Convertible (F12) 2011-2018',    'Convertible', 2011, 2018, 'RWD'),
  (@m_6,  '6-series-f06-gran-coupe-2012-2018',     'F06', '6 Series Gran Coupe (F06) 2012-2018',     'Coupe',       2012, 2018, 'RWD'),
  (@m_m6, 'm6-f13-coupe-2012-2018',                'F13', 'M6 Coupe (F13) V8 2012-2018',             'Coupe',       2012, 2018, 'RWD'),
  (@m_m6, 'm6-f12-convertible-2012-2018',          'F12', 'M6 Convertible (F12) V8 2012-2018',       'Convertible', 2012, 2018, 'RWD'),
  (@m_m6, 'm6-f06-gran-coupe-2013-2018',           'F06', 'M6 Gran Coupe (F06) V8 2013-2018',        'Coupe',       2013, 2018, 'RWD'),
  -- 6 Series G32 Gran Turismo (1 gen)
  (@m_6,  '6-series-g32-gran-turismo-2017-present', 'G32', '6 Series Gran Turismo (G32) 2017-',       'Hatchback',   2017, NULL, 'RWD'),
  -- X2 family (2 gens)
  (@m_x2, 'x2-f39-suv-2018-2023',                  'F39', 'X2 (F39) 2018-2023',                       'SUV',         2018, 2023, 'FWD'),
  (@m_x2, 'x2-u10-suv-2023-present',               'U10', 'X2 (U10) 2023-',                           'SUV',         2023, NULL, 'FWD'),
  -- iX (1 gen)
  (@m_ix, 'ix-i20-suv-2021-2025',                  'I20', 'iX (I20) 2021-2025',                       'SUV',         2021, 2025, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  '6-series-e63-coupe-2003-2010','6-series-e64-convertible-2004-2010',
  'm6-e63-coupe-2005-2010','m6-e64-convertible-2006-2010',
  '6-series-f13-coupe-2011-2018','6-series-f12-convertible-2011-2018','6-series-f06-gran-coupe-2012-2018',
  'm6-f13-coupe-2012-2018','m6-f12-convertible-2012-2018','m6-f06-gran-coupe-2013-2018',
  '6-series-g32-gran-turismo-2017-present',
  'x2-f39-suv-2018-2023','x2-u10-suv-2023-present',
  'ix-i20-suv-2021-2025'
) ORDER BY m.slug, g.start_year;
