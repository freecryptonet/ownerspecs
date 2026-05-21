-- Dual-source the remaining single-source service_intervals rows across
-- the ~57 gens outside this session's recent migrations. Pairs each row
-- with its manufacturer-family aggregator using the canonical aggregator
-- IDs in CLAUDE.md.
--
-- Lincoln has no existing Ford-general aggregator (source 602 is F-150
-- P702-specific), so this migration creates a generic "Ford/Lincoln factory
-- oil spec" aggregator first.

SET NAMES utf8mb4;

-- =========================================================================
-- Create Ford/Lincoln generic aggregator (Lincoln has no aggregator in DB)
-- =========================================================================
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Ford/Lincoln factory oil spec (Motorcraft + Ford Service Content + AMSOIL cross-verification)', 1, NOW(),
          'Generic Ford+Lincoln aggregator covering Motorcraft Ford-spec engine oils, ATF, brake fluid, and coolant. Used as the 2nd-source citation for Ford/Lincoln gens without a model-specific aggregator already in the DB.');
SET @s_ford_agg := (SELECT id FROM sources WHERE citation LIKE 'Ford/Lincoln factory oil spec%' LIMIT 1);

-- =========================================================================
-- Add aggregator citation per make. INSERT IGNORE skips any row that
-- already happens to cite that aggregator.
--
-- The CTE-like derived table identifies all service_intervals rows on the
-- target make's gens that currently have <2 distinct public sources, then
-- inserts the aggregator citation for each.
-- =========================================================================

-- Toyota (605)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 605
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'toyota';

-- Lexus (605 — Toyota/Lexus aggregator)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 605
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'lexus';

-- Honda (606)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 606
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'honda';

-- Acura (606 — Honda owns Acura)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 606
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'acura';

-- Hyundai (607)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 607
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'hyundai';

-- Kia (607)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 607
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'kia';

-- Genesis (607)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 607
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'genesis';

-- Mazda (608)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 608
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'mazda';

-- Subaru (608 — Mazda/Subaru aggregator)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 608
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'subaru';

-- VW (609)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 609
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug IN ('volkswagen', 'vw');

-- Audi (609 — VW Group)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 609
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'audi';

-- BMW (603)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 603
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'bmw';

-- Mercedes-Benz (604)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 604
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'mercedes-benz';

-- GMC (610 — GM)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 610
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'gmc';

-- Chrysler + Jeep + Ram (611 — Stellantis/FCA)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 611
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug IN ('chrysler', 'jeep', 'ram');

-- Volvo (613)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 613
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'volvo';

-- Tesla (612)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 612
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'tesla';

-- Ford (use F-150 aggregator 602 for Ford itself, since it was created as
-- "Ford service content" — the citation reads accurately for Ford gens.
-- Lincoln gets the new generic 'Ford/Lincoln factory oil spec' aggregator.)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, 602
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'ford';

-- Lincoln — new Ford/Lincoln aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, @s_ford_agg
  FROM service_intervals si
  JOIN generations g ON g.id = si.generation_id
  JOIN models m ON m.id = g.model_id
  JOIN makes mk ON mk.id = m.make_id
  WHERE mk.slug = 'lincoln';

-- =========================================================================
-- Verification
-- =========================================================================
SELECT 'POST-MIGRATION 133' AS marker,
  (SELECT COUNT(*) FROM service_intervals si WHERE NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id)) AS uncited,
  (SELECT COUNT(*) FROM service_intervals si WHERE 1 = (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss JOIN sources s ON s.id=ss.source_id WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND s.is_public=1)) AS single_source,
  (SELECT COUNT(*) FROM service_intervals si WHERE 2 <= (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss JOIN sources s ON s.id=ss.source_id WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND s.is_public=1)) AS two_or_more_sources,
  (SELECT COUNT(*) FROM service_intervals) AS total_rows,
  @s_ford_agg AS new_ford_lincoln_agg_id;

-- Per-make follow-up: any make whose service_intervals still have <2 sources?
SELECT mk.slug, COUNT(*) AS still_single_source
FROM service_intervals si
JOIN generations g ON g.id = si.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE 1 = (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss JOIN sources s ON s.id=ss.source_id WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND s.is_public=1)
GROUP BY mk.slug
ORDER BY still_single_source DESC;
