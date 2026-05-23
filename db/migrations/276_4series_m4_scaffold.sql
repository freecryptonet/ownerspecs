-- mig 276 — Catalog scaffolding for BMW 4 Series F32/F33/F36 (2013-2020)
-- + M4 F82/F83, BMW 4 Series G22/G23/G26 (2020-) + M4 G82/G83.
--
-- F-gen LCI cutoffs:
--   F32 Coupe / F33 Convertible / F36 Gran Coupe LCI: 2017
--   F82/F83 M4: no LCI in BMW M sense
-- G-gen: no LCI yet (G22 introduced 2020)

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, '4-series', '4 Series'),
  (@make_bmw, 'm4', 'M4');

SET @m_4  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '4-series');
SET @m_m4 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm4');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- F32 family (8 gens incl LCI + M4)
  (@m_4,  '4-series-f32-coupe-2013-2017',          'F32',     '4 Series Coupe (F32) 2013-2017',         'Coupe',       2013, 2017, 'RWD'),
  (@m_4,  '4-series-f32-lci-coupe-2017-2020',      'F32 LCI', '4 Series Coupe (F32 LCI) 2017-2020',     'Coupe',       2017, 2020, 'RWD'),
  (@m_4,  '4-series-f33-convertible-2014-2017',    'F33',     '4 Series Convertible (F33) 2014-2017',   'Convertible', 2014, 2017, 'RWD'),
  (@m_4,  '4-series-f33-lci-convertible-2017-2020', 'F33 LCI', '4 Series Convertible (F33 LCI) 2017-2020', 'Convertible', 2017, 2020, 'RWD'),
  (@m_4,  '4-series-f36-gran-coupe-2014-2017',     'F36',     '4 Series Gran Coupe (F36) 2014-2017',     'Coupe',       2014, 2017, 'RWD'),
  (@m_4,  '4-series-f36-lci-gran-coupe-2017-2020', 'F36 LCI', '4 Series Gran Coupe (F36 LCI) 2017-2020', 'Coupe',       2017, 2020, 'RWD'),
  (@m_m4, 'm4-f82-coupe-2014-2020',                'F82',     'M4 (F82) 2014-2020',                     'Coupe',       2014, 2020, 'RWD'),
  (@m_m4, 'm4-f83-convertible-2014-2020',          'F83',     'M4 (F83) 2014-2020',                     'Convertible', 2014, 2020, 'RWD'),
  -- G22 family (5 gens incl Gran Coupe + M4)
  (@m_4,  '4-series-g22-coupe-2020-present',       'G22',     '4 Series Coupe (G22) 2020-',             'Coupe',       2020, NULL, 'RWD'),
  (@m_4,  '4-series-g23-convertible-2020-present', 'G23',     '4 Series Convertible (G23) 2020-',       'Convertible', 2020, NULL, 'RWD'),
  (@m_4,  '4-series-g26-gran-coupe-2021-present',  'G26',     '4 Series Gran Coupe (G26) 2021-',        'Coupe',       2021, NULL, 'RWD'),
  (@m_m4, 'm4-g82-coupe-2021-present',             'G82',     'M4 (G82) 2021-',                         'Coupe',       2021, NULL, 'RWD'),
  (@m_m4, 'm4-g83-convertible-2021-present',       'G83',     'M4 (G83) 2021-',                         'Convertible', 2021, NULL, 'RWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  '4-series-f32-coupe-2013-2017','4-series-f32-lci-coupe-2017-2020',
  '4-series-f33-convertible-2014-2017','4-series-f33-lci-convertible-2017-2020',
  '4-series-f36-gran-coupe-2014-2017','4-series-f36-lci-gran-coupe-2017-2020',
  'm4-f82-coupe-2014-2020','m4-f83-convertible-2014-2020',
  '4-series-g22-coupe-2020-present','4-series-g23-convertible-2020-present',
  '4-series-g26-gran-coupe-2021-present',
  'm4-g82-coupe-2021-present','m4-g83-convertible-2021-present'
) ORDER BY m.slug, g.start_year;
