-- mig 334 — Mercedes A-Class + B-Class catalog scaffolding (7 gens, 6 chassis).
-- A45/A35 AMG merged into base A-Class gen per chassis (smaller mechanical delta).
-- W168 (1998-2005) skipped — too old.

SET NAMES utf8mb4;

SET @make_mb := (SELECT id FROM makes WHERE slug = 'mercedes-benz');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_mb, 'a-class', 'A-Class'),
  (@make_mb, 'b-class', 'B-Class');

SET @m_a := (SELECT id FROM models WHERE make_id = @make_mb AND slug = 'a-class');
SET @m_b := (SELECT id FROM models WHERE make_id = @make_mb AND slug = 'b-class');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- A-Class (3 modern gens)
  (@m_a, 'a-class-w169-2005-2012',     'W169', 'A-Class (W169, 2nd gen) 2005-2012',  'Hatchback', 2005, 2012, 'FWD'),
  (@m_a, 'a-class-w176-2012-2018',     'W176', 'A-Class (W176, 3rd gen) 2012-2018',  'Hatchback', 2012, 2018, 'FWD'),
  (@m_a, 'a-class-w177-2018-present',  'W177', 'A-Class (W177, 4th gen) 2018-',      'Hatchback', 2018, NULL, 'FWD'),
  -- B-Class (3 gens)
  (@m_b, 'b-class-w245-2005-2011',     'W245', 'B-Class (W245, 1st gen) 2005-2011',  'Hatchback', 2005, 2011, 'FWD'),
  (@m_b, 'b-class-w246-2011-2018',     'W246', 'B-Class (W246, 2nd gen) 2011-2018',  'Hatchback', 2011, 2018, 'FWD'),
  (@m_b, 'b-class-w247-2019-present',  'W247', 'B-Class (W247, 3rd gen) 2019-',      'Hatchback', 2019, NULL, 'FWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  'a-class-w169-2005-2012','a-class-w176-2012-2018','a-class-w177-2018-present',
  'b-class-w245-2005-2011','b-class-w246-2011-2018','b-class-w247-2019-present'
) ORDER BY m.slug, g.start_year;
