-- mig 279 — Catalog scaffolding for BMW X4 + X6 + X7 coupé-SUV family.
-- X4: F26 (2014-2018), G02 + LCI (2018-), X4 M F98 (2019-)
-- X6: E71 (2008-2014), F16 (2014-2019), F86 X6 M (2014-2019),
--     G06 + LCI (2019-), F96 X6 M + LCI (2019-)
-- X7: G07 + LCI (2018-, LCI 2022)

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, 'x4', 'X4'),
  (@make_bmw, 'x6', 'X6'),
  (@make_bmw, 'x7', 'X7'),
  (@make_bmw, 'x4-m', 'X4 M'),
  (@make_bmw, 'x6-m', 'X6 M');

SET @m_x4   := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x4');
SET @m_x6   := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x6');
SET @m_x7   := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x7');
SET @m_x4m  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x4-m');
SET @m_x6m  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x6-m');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- X4 family (4 gens)
  (@m_x4,  'x4-f26-suv-2014-2018',           'F26',     'X4 (F26) 2014-2018',           'SUV', 2014, 2018, 'AWD'),
  (@m_x4,  'x4-g02-suv-2018-2022',           'G02',     'X4 (G02) 2018-2022',           'SUV', 2018, 2022, 'AWD'),
  (@m_x4,  'x4-g02-lci-suv-2022-present',    'G02 LCI', 'X4 (G02 LCI) 2022-',           'SUV', 2022, NULL, 'AWD'),
  (@m_x4m, 'x4-m-f98-suv-2019-2024',         'F98',     'X4 M (F98) 2019-2024',         'SUV', 2019, 2024, 'AWD'),
  -- X6 family (7 gens)
  (@m_x6,  'x6-e71-suv-2008-2014',           'E71/E72', 'X6 (E71, E72) 2008-2014',      'SUV', 2008, 2014, 'AWD'),
  (@m_x6,  'x6-f16-suv-2014-2019',           'F16',     'X6 (F16) 2014-2019',           'SUV', 2014, 2019, 'AWD'),
  (@m_x6m, 'x6-m-f86-suv-2014-2019',         'F86',     'X6 M (F86) 2014-2019',         'SUV', 2014, 2019, 'AWD'),
  (@m_x6,  'x6-g06-suv-2019-2023',           'G06',     'X6 (G06) 2019-2023',           'SUV', 2019, 2023, 'AWD'),
  (@m_x6,  'x6-g06-lci-suv-2023-present',    'G06 LCI', 'X6 (G06 LCI) 2023-',           'SUV', 2023, NULL, 'AWD'),
  (@m_x6m, 'x6-m-f96-suv-2019-2023',         'F96',     'X6 M (F96) 2019-2023',         'SUV', 2019, 2023, 'AWD'),
  (@m_x6m, 'x6-m-f96-lci-suv-2023-present',  'F96 LCI', 'X6 M (F96 LCI) 2023-',         'SUV', 2023, NULL, 'AWD'),
  -- X7 family (2 gens)
  (@m_x7,  'x7-g07-suv-2018-2022',           'G07',     'X7 (G07) 2018-2022',           'SUV', 2018, 2022, 'AWD'),
  (@m_x7,  'x7-g07-lci-suv-2022-present',    'G07 LCI', 'X7 (G07 LCI) 2022-',           'SUV', 2022, NULL, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'x4-f26-suv-2014-2018','x4-g02-suv-2018-2022','x4-g02-lci-suv-2022-present','x4-m-f98-suv-2019-2024',
  'x6-e71-suv-2008-2014','x6-f16-suv-2014-2019','x6-m-f86-suv-2014-2019',
  'x6-g06-suv-2019-2023','x6-g06-lci-suv-2023-present',
  'x6-m-f96-suv-2019-2023','x6-m-f96-lci-suv-2023-present',
  'x7-g07-suv-2018-2022','x7-g07-lci-suv-2022-present'
) ORDER BY m.slug, g.start_year;
