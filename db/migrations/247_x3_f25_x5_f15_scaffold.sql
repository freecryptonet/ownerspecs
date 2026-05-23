-- mig 247 — Catalog scaffolding for BMW X3 F25 (2011-2018) + BMW X5 F15 (2013-2019).
-- Both are previous-generation SUVs we want HaynesPro coverage for in mig 248-249.

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');
SET @m_x3 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x3');
SET @m_x5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x5');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  (@m_x3, 'x3-f25-suv-2011-2014',     'F25',     'X3 (F25, 2nd gen) 2011-2014',     'SUV', 2011, 2014, 'AWD'),
  (@m_x3, 'x3-f25-lci-suv-2014-2018', 'F25 LCI', 'X3 (F25 LCI, 2nd gen) 2014-2018', 'SUV', 2014, 2018, 'AWD'),
  (@m_x5, 'x5-f15-suv-2013-2019',     'F15',     'X5 (F15, 3rd gen) 2013-2019',     'SUV', 2013, 2019, 'AWD');

-- Audit
SELECT g.id, g.slug, g.codename, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE mk.slug = 'bmw' AND m.slug IN ('x3','x5')
ORDER BY m.slug, g.start_year;
