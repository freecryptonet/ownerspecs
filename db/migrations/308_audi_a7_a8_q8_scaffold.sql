-- mig 308 — Audi luxury lineup scaffolding: A7 + A8 + Q8 + Q8 e-tron.
-- Pragmatic: 1 gen per chassis (covers SWB + LWB for A8), separate RS variants
-- (RS7 — 4.0 V8 TFSI; RS Q8 — 4.0 V8 TFSI). S7/S8 stays in base gen.
-- A8 4D (1994-2003) skipped.

SET NAMES utf8mb4;

SET @make_audi := (SELECT id FROM makes WHERE slug = 'audi');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_audi, 'a7', 'A7'),
  (@make_audi, 'a8', 'A8'),
  (@make_audi, 'q8', 'Q8'),
  (@make_audi, 'rs7', 'RS 7'),
  (@make_audi, 'rs-q8', 'RS Q8'),
  (@make_audi, 'q8-e-tron', 'Q8 e-tron');

SET @m_a7    := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'a7');
SET @m_a8    := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'a8');
SET @m_q8    := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'q8');
SET @m_rs7   := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs7');
SET @m_rsq8  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs-q8');
SET @m_q8et  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'q8-e-tron');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- A7 (4 gens — 2 base + 2 RS7)
  (@m_a7,   'a7-4g-sportback-2010-2018',           '4G',  'A7 Sportback (4G) 2010-2018',         'Hatchback', 2010, 2018, 'AWD'),
  (@m_rs7,  'rs7-4g-sportback-2013-2018',          '4G',  'RS 7 Sportback (4G) 2013-2018',       'Hatchback', 2013, 2018, 'AWD'),
  (@m_a7,   'a7-4k-sportback-2018-present',        '4K',  'A7 Sportback (4K) 2018-',             'Hatchback', 2018, NULL, 'AWD'),
  (@m_rs7,  'rs7-4k-sportback-2019-present',       '4K',  'RS 7 Sportback (4K) 2019-',           'Hatchback', 2019, NULL, 'AWD'),
  -- A8 (3 gens, S8 stays in base)
  (@m_a8,   'a8-4e-sedan-2003-2010',               '4E',  'A8 (4E) 2003-2010',                   'Sedan',     2003, 2010, 'AWD'),
  (@m_a8,   'a8-4h-sedan-2010-2017',               '4H',  'A8 (4H) 2010-2017',                   'Sedan',     2010, 2017, 'AWD'),
  (@m_a8,   'a8-4n-sedan-2018-present',            '4N',  'A8 (4N) 2018-',                       'Sedan',     2018, NULL, 'AWD'),
  -- Q8 (2 gens — 1 base ICE + 1 RS Q8). SQ8 stays in base.
  (@m_q8,   'q8-4mn-suv-2019-present',             '4MN', 'Q8 (4MN) 2019-',                      'SUV',       2019, NULL, 'AWD'),
  (@m_rsq8, 'rs-q8-4mn-suv-2019-present',          '4MN', 'RS Q8 (4MN) 2019-',                   'SUV',       2019, NULL, 'AWD'),
  -- Q8 e-tron (1 gen, BEV)
  (@m_q8et, 'q8-e-tron-suv-2023-present',          'GET', 'Q8 e-tron (GET, GEG) 2023-',          'SUV',       2023, NULL, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'a7-4g-sportback-2010-2018','rs7-4g-sportback-2013-2018','a7-4k-sportback-2018-present','rs7-4k-sportback-2019-present',
  'a8-4e-sedan-2003-2010','a8-4h-sedan-2010-2017','a8-4n-sedan-2018-present',
  'q8-4mn-suv-2019-present','rs-q8-4mn-suv-2019-present','q8-e-tron-suv-2023-present'
) ORDER BY m.slug, g.start_year;
