-- mig 253 — Catalog scaffolding for BMW 5 series F10/F11 (2010-2017) +
-- M5 F10 (2011-2016) + X5 E70 (2006-2013).
--
-- F10 LCI cutoff: mid-2013 (BMW announced LCI in Jan 2013, deliveries
-- from MY2014). E70 LCI cutoff: mid-2010 (announced May 2010, deliveries
-- from MY2011).
-- F18 LWB (China-only) not added — outside our intl audience.

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');
SET @m_5  := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = '5-series');
SET @m_m5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm5');
SET @m_x5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'x5');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  (@m_5,  '5-series-f10-sedan-2010-2013',     'F10',     '5 Series (F10) 2010-2013',     'Sedan',  2010, 2013, 'RWD'),
  (@m_5,  '5-series-f10-lci-sedan-2013-2017', 'F10 LCI', '5 Series (F10 LCI) 2013-2017', 'Sedan',  2013, 2017, 'RWD'),
  (@m_5,  '5-series-f11-touring-2010-2013',     'F11',     '5 Series Touring (F11) 2010-2013',     'Estate', 2010, 2013, 'RWD'),
  (@m_5,  '5-series-f11-lci-touring-2013-2017', 'F11 LCI', '5 Series Touring (F11 LCI) 2013-2017', 'Estate', 2013, 2017, 'RWD'),
  (@m_m5, 'm5-f10-sedan-2011-2016',           'F10',     'M5 (F10) 2011-2016',           'Sedan',  2011, 2016, 'RWD'),
  (@m_x5, 'x5-e70-suv-2006-2010',             'E70',     'X5 (E70, 2nd gen) 2006-2010',  'SUV',    2006, 2010, 'AWD'),
  (@m_x5, 'x5-e70-lci-suv-2010-2013',         'E70 LCI', 'X5 (E70 LCI, 2nd gen) 2010-2013', 'SUV', 2010, 2013, 'AWD');

-- Audit
SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.codename, g.start_year, g.end_year
FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
WHERE g.id >= LAST_INSERT_ID() OR g.slug IN
  ('5-series-f10-sedan-2010-2013','5-series-f10-lci-sedan-2013-2017',
   '5-series-f11-touring-2010-2013','5-series-f11-lci-touring-2013-2017',
   'm5-f10-sedan-2011-2016','x5-e70-suv-2006-2010','x5-e70-lci-suv-2010-2013')
ORDER BY m.slug, g.start_year;
