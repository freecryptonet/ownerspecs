-- mig 250 — Catalog scaffolding for BMW iX3 (G08, BEV) + X3 (E83, 1st gen).
-- iX3 G08 is the BEV variant of X3 G01 — separate chassis in HaynesPro.
-- X3 E83 is the original X3 (2004-2010, includes LCI 2006-2010).
-- Spec data follows in migrations 251 + 252.

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');
SET @m_x3 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x3');

-- iX3 is its own model line (electric SUV) — create it if missing
INSERT IGNORE INTO models (make_id, slug, name) VALUES (@make_bmw, 'ix3', 'iX3');
SET @m_ix3 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'ix3');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  (@m_ix3, 'ix3-g08-suv-2020-2024',     'G08',     'iX3 (G08) 2020-2024',         'SUV', 2020, 2024, 'RWD'),
  (@m_x3,  'x3-e83-suv-2004-2006',      'E83',     'X3 (E83, 1st gen) 2004-2006', 'SUV', 2004, 2006, 'AWD'),
  (@m_x3,  'x3-e83-lci-suv-2006-2010',  'E83 LCI', 'X3 (E83 LCI, 1st gen) 2006-2010', 'SUV', 2006, 2010, 'AWD');

-- Audit
SELECT g.id, m.slug AS model, g.slug, g.codename, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE mk.slug = 'bmw' AND m.slug IN ('x3','ix3')
ORDER BY m.slug, g.start_year;
