-- mig 323 — Mercedes-Benz C-Class + E-Class catalog scaffolding (12 gens, 9 chassis).
-- Pragmatic split: one gen per chassis covering sedan + estate (mechanical identical).
-- Coupe + Cabriolet of E-Class get their own chassis listing in HaynesPro (W207, W238)
-- so they become separate catalog gens.
-- AMG C63 split separately (4.0 V8 BiTurbo vs 6.2 V8 NA — distinctly different
-- mechanicals). AMG E63 / E53 stay in base gen for now.

SET NAMES utf8mb4;

SET @make_mb := (SELECT id FROM makes WHERE slug = 'mercedes-benz');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_mb, 'c-class', 'C-Class'),
  (@make_mb, 'e-class', 'E-Class'),
  (@make_mb, 'amg-c63', 'AMG C 63');

SET @m_c    := (SELECT id FROM models WHERE make_id = @make_mb AND slug = 'c-class');
SET @m_e    := (SELECT id FROM models WHERE make_id = @make_mb AND slug = 'e-class');
SET @m_c63  := (SELECT id FROM models WHERE make_id = @make_mb AND slug = 'amg-c63');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- C-Class (5 gens — 4 base + 1 AMG)
  (@m_c,   'c-class-w203-2000-2007',           'W203',  'C-Class (W203, 3rd gen) 2000-2007',     'Sedan', 2000, 2007, 'RWD'),
  (@m_c,   'c-class-w204-2007-2014',           'W204',  'C-Class (W204, 4th gen) 2007-2014',     'Sedan', 2007, 2014, 'RWD'),
  (@m_c,   'c-class-w205-2014-2021',           'W205',  'C-Class (W205, 5th gen) 2014-2021',     'Sedan', 2014, 2021, 'RWD'),
  (@m_c,   'c-class-w206-2021-present',        'W206',  'C-Class (W206, 6th gen) 2021-',         'Sedan', 2021, NULL, 'RWD'),
  (@m_c63, 'amg-c63-w205-2014-2021',           'W205',  'AMG C 63 (W205) V8 BiTurbo 2014-2021',   'Sedan', 2014, 2021, 'RWD'),
  -- E-Class (6 gens — 4 base sedan + 2 coupe-cabrio)
  (@m_e,   'e-class-w211-2002-2009',           'W211',  'E-Class (W211, 9th gen) 2002-2009',     'Sedan', 2002, 2009, 'RWD'),
  (@m_e,   'e-class-w212-2009-2016',           'W212',  'E-Class (W212, 10th gen) 2009-2016',    'Sedan', 2009, 2016, 'RWD'),
  (@m_e,   'e-class-c207-coupe-cabrio-2009-2016', 'C207/A207', 'E-Class Coupe/Cabrio (C207, A207) 2009-2016', 'Coupe', 2009, 2016, 'RWD'),
  (@m_e,   'e-class-w213-2016-2023',           'W213',  'E-Class (W213, 11th gen) 2016-2023',    'Sedan', 2016, 2023, 'RWD'),
  (@m_e,   'e-class-c238-coupe-cabrio-2017-2022', 'C238/A238', 'E-Class Coupe/Cabrio (C238, A238) 2017-2022', 'Coupe', 2017, 2022, 'RWD'),
  (@m_e,   'e-class-w214-2023-present',        'W214',  'E-Class (W214, 12th gen) 2023-',        'Sedan', 2023, NULL, 'RWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'c-class-w203-2000-2007','c-class-w204-2007-2014','c-class-w205-2014-2021','c-class-w206-2021-present',
  'amg-c63-w205-2014-2021',
  'e-class-w211-2002-2009','e-class-w212-2009-2016','e-class-c207-coupe-cabrio-2009-2016',
  'e-class-w213-2016-2023','e-class-c238-coupe-cabrio-2017-2022','e-class-w214-2023-present'
) ORDER BY m.slug, g.start_year;
