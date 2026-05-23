-- mig 316 — Audi A1 + Q2 + TT scaffolding (6 chassis, 10 gens).
-- TT bodies (Coupe + Roadster) share mechanicals — single gen per chassis.
-- SQ2 split from Q2 (300hp 2.0 TFSI with different oil spec).
-- TT RS split from TT (2.5 TFSI 5-cyl, distinct from regular).

SET NAMES utf8mb4;

SET @make_audi := (SELECT id FROM makes WHERE slug = 'audi');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_audi, 'a1', 'A1'),
  (@make_audi, 'q2', 'Q2'),
  (@make_audi, 'sq2', 'SQ2'),
  (@make_audi, 'tt', 'TT'),
  (@make_audi, 'tt-rs', 'TT RS');

SET @m_a1   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'a1');
SET @m_q2   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'q2');
SET @m_sq2  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'sq2');
SET @m_tt   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'tt');
SET @m_ttrs := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'tt-rs');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- A1 (2 gens)
  (@m_a1,   'a1-8x-hatch-2011-2018',         '8X',  'A1 (8X) 2011-2018',         'Hatchback', 2011, 2018, 'FWD'),
  (@m_a1,   'a1-gb-hatch-2019-present',      'GB',  'A1 (GB) 2019-',             'Hatchback', 2019, NULL, 'FWD'),
  -- Q2 + SQ2 (2 gens)
  (@m_q2,   'q2-ga-suv-2017-present',        'GA',  'Q2 (GA) 2017-',             'SUV',       2017, NULL, 'FWD'),
  (@m_sq2,  'sq2-ga-suv-2018-present',       'GA',  'SQ2 (GA) 2018-',            'SUV',       2018, NULL, 'AWD'),
  -- TT + TT RS (5 gens)
  (@m_tt,   'tt-8n-1998-2006',               '8N',  'TT (8N, 1st gen) 1998-2006', 'Coupe',     1998, 2006, 'AWD'),
  (@m_tt,   'tt-8j-2006-2014',               '8J',  'TT (8J, 2nd gen) 2006-2014', 'Coupe',     2006, 2014, 'AWD'),
  (@m_ttrs, 'tt-rs-8j-2009-2014',            '8J',  'TT RS (8J) 2009-2014',       'Coupe',     2009, 2014, 'AWD'),
  (@m_tt,   'tt-fv-2015-2023',               'FV',  'TT (FV/8S, 3rd gen) 2015-2023', 'Coupe',  2015, 2023, 'AWD'),
  (@m_ttrs, 'tt-rs-fv-2016-2023',            'FV',  'TT RS (FV/8S) 2016-2023',    'Coupe',     2016, 2023, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'a1-8x-hatch-2011-2018','a1-gb-hatch-2019-present',
  'q2-ga-suv-2017-present','sq2-ga-suv-2018-present',
  'tt-8n-1998-2006','tt-8j-2006-2014','tt-rs-8j-2009-2014','tt-fv-2015-2023','tt-rs-fv-2016-2023'
) ORDER BY m.slug, g.start_year;
