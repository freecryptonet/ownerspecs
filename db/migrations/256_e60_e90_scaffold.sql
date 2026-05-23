-- mig 256 — Catalog scaffolding for BMW 5 Series E60/E61/M5 E60 (2003-2010)
-- + BMW 3 Series E90/E91/E92/E93/M3 (2005-2013).
--
-- LCI cutoffs:
--   E60/E61 LCI: 2007 (announced 09/2007, MY2008+)
--   E90/E91 LCI: 2008 (announced 03/2008, MY2009+)
--   E92/E93 LCI: 2010 (announced 03/2010, MY2011+)
--   M3 V8 (S65 4.0L): no LCI in the BMW M sense — same gen 2007-2013

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');
SET @m_3  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '3-series');
SET @m_5  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '5-series');
SET @m_m3 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm3');
SET @m_m5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm5');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  -- 5 Series E60/E61 + M5 E60
  (@m_5,  '5-series-e60-sedan-2003-2007',     'E60',     '5 Series (E60) 2003-2007',     'Sedan',      2003, 2007, 'RWD'),
  (@m_5,  '5-series-e60-lci-sedan-2007-2010', 'E60 LCI', '5 Series (E60 LCI) 2007-2010', 'Sedan',      2007, 2010, 'RWD'),
  (@m_5,  '5-series-e61-touring-2004-2007',     'E61',     '5 Series Touring (E61) 2004-2007',     'Estate', 2004, 2007, 'RWD'),
  (@m_5,  '5-series-e61-lci-touring-2007-2010', 'E61 LCI', '5 Series Touring (E61 LCI) 2007-2010', 'Estate', 2007, 2010, 'RWD'),
  (@m_m5, 'm5-e60-sedan-2005-2010',           'E60',     'M5 (E60) V10 2005-2010',       'Sedan',      2005, 2010, 'RWD'),
  -- 3 Series E90/E91/E92/E93
  (@m_3,  '3-series-e90-sedan-2005-2008',         'E90',     '3 Series (E90) 2005-2008',           'Sedan',       2005, 2008, 'RWD'),
  (@m_3,  '3-series-e90-lci-sedan-2008-2012',     'E90 LCI', '3 Series (E90 LCI) 2008-2012',       'Sedan',       2008, 2012, 'RWD'),
  (@m_3,  '3-series-e91-touring-2005-2008',         'E91',     '3 Series Touring (E91) 2005-2008',         'Estate',      2005, 2008, 'RWD'),
  (@m_3,  '3-series-e91-lci-touring-2008-2012',     'E91 LCI', '3 Series Touring (E91 LCI) 2008-2012',     'Estate',      2008, 2012, 'RWD'),
  (@m_3,  '3-series-e92-coupe-2006-2010',         'E92',     '3 Series Coupe (E92) 2006-2010',         'Coupe',       2006, 2010, 'RWD'),
  (@m_3,  '3-series-e92-lci-coupe-2010-2013',     'E92 LCI', '3 Series Coupe (E92 LCI) 2010-2013',     'Coupe',       2010, 2013, 'RWD'),
  (@m_3,  '3-series-e93-convertible-2007-2010',     'E93',     '3 Series Convertible (E93) 2007-2010',     'Convertible', 2007, 2010, 'RWD'),
  (@m_3,  '3-series-e93-lci-convertible-2010-2013', 'E93 LCI', '3 Series Convertible (E93 LCI) 2010-2013', 'Convertible', 2010, 2013, 'RWD'),
  -- M3 V8 (S65) — separate gens for each body
  (@m_m3, 'm3-e90-sedan-2007-2011',           'E90',     'M3 (E90) V8 2007-2011',         'Sedan',       2007, 2011, 'RWD'),
  (@m_m3, 'm3-e92-coupe-2007-2013',           'E92',     'M3 (E92) V8 2007-2013',         'Coupe',       2007, 2013, 'RWD'),
  (@m_m3, 'm3-e93-convertible-2008-2013',     'E93',     'M3 (E93) V8 2008-2013',         'Convertible', 2008, 2013, 'RWD');

-- Audit
SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.slug IN (
  '5-series-e60-sedan-2003-2007','5-series-e60-lci-sedan-2007-2010',
  '5-series-e61-touring-2004-2007','5-series-e61-lci-touring-2007-2010',
  'm5-e60-sedan-2005-2010',
  '3-series-e90-sedan-2005-2008','3-series-e90-lci-sedan-2008-2012',
  '3-series-e91-touring-2005-2008','3-series-e91-lci-touring-2008-2012',
  '3-series-e92-coupe-2006-2010','3-series-e92-lci-coupe-2010-2013',
  '3-series-e93-convertible-2007-2010','3-series-e93-lci-convertible-2010-2013',
  'm3-e90-sedan-2007-2011','m3-e92-coupe-2007-2013','m3-e93-convertible-2008-2013'
)
ORDER BY m.slug, g.start_year;
