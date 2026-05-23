-- mig 298 — Audi A3/A5/Q3 catalog scaffolding (9 chassis, 16 gens).
-- Pragmatic split: one gen per chassis covering all bodies (hatch/sportback/sedan/cabrio),
-- plus separate gens for RS variants (distinctly different mechanicals — RS3 2.5 TFSI 5-cyl,
-- RS5 V8/V6 TFSI, RS Q3 2.5 TFSI 5-cyl).
-- S3/S5 high-trims stay in their base gen (smaller mechanical delta).
-- A3 8L (1997-2006) skipped — pre-2003 too old for SEO target.

SET NAMES utf8mb4;

SET @make_audi := (SELECT id FROM makes WHERE slug = 'audi');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_audi, 'a3', 'A3'),
  (@make_audi, 'a5', 'A5'),
  (@make_audi, 'q3', 'Q3'),
  (@make_audi, 'rs3', 'RS 3'),
  (@make_audi, 'rs5', 'RS 5'),
  (@make_audi, 'rs-q3', 'RS Q3');

SET @m_a3   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'a3');
SET @m_a5   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'a5');
SET @m_q3   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'q3');
SET @m_rs3  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs3');
SET @m_rs5  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs5');
SET @m_rsq3 := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs-q3');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- A3 family (6 gens — 3 base + 3 RS3)
  (@m_a3,   'a3-8p-2003-2013',                  '8P', 'A3 (8P, II) 2003-2013',                    'Hatchback', 2003, 2013, 'FWD'),
  (@m_rs3,  'rs3-8p-sportback-2011-2013',       '8P', 'RS 3 Sportback (8P) 2011-2013',            'Hatchback', 2011, 2013, 'AWD'),
  (@m_a3,   'a3-8v-2013-2020',                  '8V', 'A3 (8V, III) 2013-2020',                   'Hatchback', 2013, 2020, 'FWD'),
  (@m_rs3,  'rs3-8v-2015-2020',                 '8V', 'RS 3 (8V) 2015-2020',                      'Hatchback', 2015, 2020, 'AWD'),
  (@m_a3,   'a3-8y-2020-present',               '8Y', 'A3 (8Y, IV) 2020-',                        'Hatchback', 2020, NULL, 'FWD'),
  (@m_rs3,  'rs3-8y-2021-present',              '8Y', 'RS 3 (8Y) 2021-',                          'Hatchback', 2021, NULL, 'AWD'),
  -- A5 family (5 gens — 3 base + 2 RS5)
  (@m_a5,   'a5-8t-2007-2017',                  '8T/8F', 'A5 (8T, 8F) 2007-2017',                 'Coupe',     2007, 2017, 'AWD'),
  (@m_rs5,  'rs5-8t-coupe-2010-2015',           '8T', 'RS 5 Coupe (8T) V8 2010-2015',             'Coupe',     2010, 2015, 'AWD'),
  (@m_a5,   'a5-f5-2017-2025',                  'F5', 'A5 (F5) 2017-2025',                        'Coupe',     2017, 2025, 'AWD'),
  (@m_rs5,  'rs5-f5-2017-2025',                 'F5', 'RS 5 (F5) 2017-2025',                      'Coupe',     2017, 2025, 'AWD'),
  (@m_a5,   'a5-fu-sedan-2024-present',         'FU', 'A5 (FU, replaces A4) 2024-',               'Sedan',     2024, NULL, 'AWD'),
  -- Q3 family (5 gens — 3 base + 2 RS Q3)
  (@m_q3,   'q3-8u-suv-2012-2018',              '8U', 'Q3 (8U, I) 2012-2018',                     'SUV',       2012, 2018, 'AWD'),
  (@m_rsq3, 'rs-q3-8u-suv-2013-2018',           '8U', 'RS Q3 (8U) 2013-2018',                     'SUV',       2013, 2018, 'AWD'),
  (@m_q3,   'q3-f3-suv-2018-present',           'F3', 'Q3 (F3, II) 2018-',                        'SUV',       2018, NULL, 'AWD'),
  (@m_rsq3, 'rs-q3-f3-suv-2019-present',        'F3', 'RS Q3 (F3) 2019-',                         'SUV',       2019, NULL, 'AWD'),
  (@m_q3,   'q3-fj-suv-2024-present',           'FJ', 'Q3 (FJ, III) 2024-',                       'SUV',       2024, NULL, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'a3-8p-2003-2013','rs3-8p-sportback-2011-2013','a3-8v-2013-2020','rs3-8v-2015-2020','a3-8y-2020-present','rs3-8y-2021-present',
  'a5-8t-2007-2017','rs5-8t-coupe-2010-2015','a5-f5-2017-2025','rs5-f5-2017-2025','a5-fu-sedan-2024-present',
  'q3-8u-suv-2012-2018','rs-q3-8u-suv-2013-2018','q3-f3-suv-2018-present','rs-q3-f3-suv-2019-present','q3-fj-suv-2024-present'
) ORDER BY m.slug, g.start_year;
