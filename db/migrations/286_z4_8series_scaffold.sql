-- mig 286 — Catalog scaffolding for BMW Z4 (3 chassis) + 8 Series (1 modern chassis).
-- Z4: E85 Roadster + E86 Coupe, E89 (folding hardtop convertible), G29 (current Roadster)
-- 8 Series: G14 Convertible + G15 Coupe + G16 Gran Coupe + M8 F91/F92/F93
-- E31 8 Series (1989-1999) skipped — too old for traffic
-- LCI split skipped for 8-series: 2022 LCI was cosmetic only, fluid specs unchanged

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, 'z4', 'Z4'),
  (@make_bmw, '8-series', '8 Series'),
  (@make_bmw, 'm8', 'M8');

SET @m_z4 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'z4');
SET @m_8  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '8-series');
SET @m_m8 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm8');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- Z4 family (4 gens)
  (@m_z4, 'z4-e85-roadster-2003-2009',        'E85', 'Z4 Roadster (E85) 2003-2009',           'Roadster',    2003, 2009, 'RWD'),
  (@m_z4, 'z4-e86-coupe-2006-2009',           'E86', 'Z4 Coupe (E86) 2006-2009',              'Coupe',       2006, 2009, 'RWD'),
  (@m_z4, 'z4-e89-convertible-2009-2016',     'E89', 'Z4 (E89) 2009-2016',                    'Convertible', 2009, 2016, 'RWD'),
  (@m_z4, 'z4-g29-roadster-2019-present',     'G29', 'Z4 Roadster (G29) 2019-',               'Roadster',    2019, NULL, 'RWD'),
  -- 8 Series + M8 (6 gens)
  (@m_8,  '8-series-g15-coupe-2018-present',         'G15', '8 Series Coupe (G15) 2018-',              'Coupe',       2018, NULL, 'RWD'),
  (@m_8,  '8-series-g14-convertible-2019-present',   'G14', '8 Series Convertible (G14) 2019-',        'Convertible', 2019, NULL, 'RWD'),
  (@m_8,  '8-series-g16-gran-coupe-2019-present',    'G16', '8 Series Gran Coupe (G16) 2019-',         'Coupe',       2019, NULL, 'RWD'),
  (@m_m8, 'm8-f92-coupe-2019-present',               'F92', 'M8 Coupe (F92) 2019-',                    'Coupe',       2019, NULL, 'RWD'),
  (@m_m8, 'm8-f91-convertible-2019-present',         'F91', 'M8 Convertible (F91) 2019-',              'Convertible', 2019, NULL, 'RWD'),
  (@m_m8, 'm8-f93-gran-coupe-2019-present',          'F93', 'M8 Gran Coupe (F93) 2019-',               'Coupe',       2019, NULL, 'RWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'z4-e85-roadster-2003-2009','z4-e86-coupe-2006-2009',
  'z4-e89-convertible-2009-2016','z4-g29-roadster-2019-present',
  '8-series-g15-coupe-2018-present','8-series-g14-convertible-2019-present','8-series-g16-gran-coupe-2019-present',
  'm8-f92-coupe-2019-present','m8-f91-convertible-2019-present','m8-f93-gran-coupe-2019-present'
) ORDER BY m.slug, g.start_year;
