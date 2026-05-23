-- mig 269 — Catalog scaffolding for BMW X1 (3 chassis) + 2 Series coupe-line (3 chassis).
-- Active Tourer MPV (F45/U06) skipped — separate body family.

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');
SET @m_x1 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x1');

-- Need to create m_x1 if missing + new models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, 'x1', 'X1'),
  (@make_bmw, 'ix1', 'iX1'),
  (@make_bmw, '2-series', '2 Series'),
  (@make_bmw, 'm2', 'M2');

SET @m_x1  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x1');
SET @m_ix1 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'ix1');
SET @m_2   := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '2-series');
SET @m_m2  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm2');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- X1 family (4 gens)
  (@m_x1,  'x1-e84-suv-2009-2015',     'E84', 'X1 (E84) 2009-2015',           'SUV', 2009, 2015, 'RWD'),
  (@m_x1,  'x1-f48-suv-2015-2022',     'F48', 'X1 (F48) 2015-2022',           'SUV', 2015, 2022, 'FWD'),
  (@m_x1,  'x1-u11-suv-2022-present',  'U11', 'X1 (U11) 2022-',               'SUV', 2022, NULL, 'FWD'),
  (@m_ix1, 'ix1-u11-suv-2022-present', 'U11', 'iX1 (U11) 2022-',              'SUV', 2022, NULL, 'AWD'),
  -- 2 Series coupe-line (7 gens)
  (@m_2,  '2-series-f22-coupe-2014-2021',           'F22', '2 Series Coupe (F22) 2014-2021',         'Coupe',       2014, 2021, 'RWD'),
  (@m_2,  '2-series-f23-convertible-2014-2021',     'F23', '2 Series Convertible (F23) 2014-2021',   'Convertible', 2014, 2021, 'RWD'),
  (@m_m2, 'm2-f87-coupe-2016-2021',                 'F87', 'M2 (F87) 2016-2021',                     'Coupe',       2016, 2021, 'RWD'),
  (@m_2,  '2-series-f44-gran-coupe-2019-present',   'F44', '2 Series Gran Coupe (F44) 2019-',        'Coupe',       2019, NULL, 'FWD'),
  (@m_2,  '2-series-g42-coupe-2022-present',        'G42', '2 Series Coupe (G42) 2022-',             'Coupe',       2022, NULL, 'RWD'),
  (@m_m2, 'm2-g87-coupe-2023-present',              'G87', 'M2 (G87) 2023-',                         'Coupe',       2023, NULL, 'RWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'x1-e84-suv-2009-2015','x1-f48-suv-2015-2022','x1-u11-suv-2022-present','ix1-u11-suv-2022-present',
  '2-series-f22-coupe-2014-2021','2-series-f23-convertible-2014-2021','m2-f87-coupe-2016-2021',
  '2-series-f44-gran-coupe-2019-present','2-series-g42-coupe-2022-present','m2-g87-coupe-2023-present'
) ORDER BY m.slug, g.start_year;
