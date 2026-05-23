-- mig 260 — Catalog scaffolding for BMW 1 Series (4 chassis, 2004-) +
-- BMW 7 Series (4 modern chassis, 2001-).
--
-- 1 Series gens chosen pragmatically (the E8x chassis had hatch + coupe +
-- convertible bodies; F2x/F4x/F7x are hatch-only):
--   E87 hatch (2004-2013) — covers 5-door E87 + 3-door E81 (mechanical identical)
--   E82 coupe (2007-2013) — covers E82 coupe + E88 convertible
--   F20/F21 (2011-2019) — pre-LCI + LCI
--   F40 (2019-) — 3rd gen, FWD-based
--   F70 (2024-) — 4th gen, current
--
-- 7 Series gens chosen pragmatically (every gen has LWB variant — treated
-- as same gen since mechanical is identical):
--   E65 (2001-2008) — covers E65 SWB + E66 LWB
--   F01 (2008-2015) — covers F01 SWB + F02 LWB + F04 ActiveHybrid 7
--   G11 (2015-2019) pre-LCI + LCI 2019-2022 — covers SWB + LWB
--   G70 (2022-) — current ICE + i7 G70 BEV

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_bmw, '1-series', '1 Series'),
  (@make_bmw, '7-series', '7 Series'),
  (@make_bmw, 'i7', 'i7');

SET @m_1  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '1-series');
SET @m_7  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '7-series');
SET @m_i7 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'i7');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- 1 Series (6 gens)
  (@m_1, '1-series-e87-hatch-2004-2013',     'E81/E87', '1 Series (E81, E87) 2004-2013',     'Hatchback',   2004, 2013, 'RWD'),
  (@m_1, '1-series-e82-coupe-2007-2013',     'E82/E88', '1 Series (E82, E88) 2007-2013',     'Coupe',       2007, 2013, 'RWD'),
  (@m_1, '1-series-f20-hatch-2011-2015',     'F20',     '1 Series (F20, F21) 2011-2015',     'Hatchback',   2011, 2015, 'RWD'),
  (@m_1, '1-series-f20-lci-hatch-2015-2019', 'F20 LCI', '1 Series (F20 LCI) 2015-2019',      'Hatchback',   2015, 2019, 'RWD'),
  (@m_1, '1-series-f40-hatch-2019-2024',     'F40',     '1 Series (F40, 3rd gen) 2019-2024', 'Hatchback',   2019, 2024, 'FWD'),
  (@m_1, '1-series-f70-hatch-2024-present',  'F70',     '1 Series (F70, 4th gen) 2024-',     'Hatchback',   2024, NULL, 'FWD'),
  -- 7 Series (4 gens)
  (@m_7, '7-series-e65-sedan-2001-2008',     'E65/E66', '7 Series (E65, E66) 2001-2008',         'Sedan', 2001, 2008, 'RWD'),
  (@m_7, '7-series-f01-sedan-2008-2015',     'F01/F02', '7 Series (F01, F02, F04) 2008-2015',     'Sedan', 2008, 2015, 'RWD'),
  (@m_7, '7-series-g11-sedan-2015-2019',     'G11/G12',     '7 Series (G11, G12) 2015-2019',        'Sedan', 2015, 2019, 'RWD'),
  (@m_7, '7-series-g11-lci-sedan-2019-2022', 'G11 LCI', '7 Series (G11 LCI, G12 LCI) 2019-2022', 'Sedan', 2019, 2022, 'RWD'),
  (@m_7, '7-series-g70-sedan-2022-present',  'G70',     '7 Series (G70) 2022-',                  'Sedan', 2022, NULL, 'RWD'),
  -- i7 G70 (BEV variant of 7-series G70)
  (@m_i7, 'i7-g70-sedan-2022-present', 'G70', 'i7 (G70) 2022-', 'Sedan', 2022, NULL, 'AWD');

SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  '1-series-e87-hatch-2004-2013','1-series-e82-coupe-2007-2013',
  '1-series-f20-hatch-2011-2015','1-series-f20-lci-hatch-2015-2019',
  '1-series-f40-hatch-2019-2024','1-series-f70-hatch-2024-present',
  '7-series-e65-sedan-2001-2008','7-series-f01-sedan-2008-2015',
  '7-series-g11-sedan-2015-2019','7-series-g11-lci-sedan-2019-2022',
  '7-series-g70-sedan-2022-present','i7-g70-sedan-2022-present'
) ORDER BY m.slug, g.start_year;
