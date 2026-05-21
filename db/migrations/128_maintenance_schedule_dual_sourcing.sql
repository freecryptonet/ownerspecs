-- Maintenance schedule dual-sourcing pass — adds the missing 2nd source
-- citation to service_intervals rows across the 19 gens migrated this
-- session (108-127). The fluid_specs / torque_specs already cite both an
-- OEM Service Manual AND a manufacturer-family aggregator per the two-
-- source rule; service_intervals had only one citation per row.
--
-- Each (gen, aggregator) pair below adds a second spec_sources row to
-- every existing service_intervals row for that gen. INSERT IGNORE ensures
-- we don't duplicate citations if a row already happens to cite the
-- aggregator. The Charger LD (gen 122) already has 2 OM citations and is
-- omitted from this pass.

SET NAMES utf8mb4;

-- gen 36 Skoda Octavia Mk4 — VW Group aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 36;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 194 FROM service_intervals WHERE generation_id = 36;

-- gen 66 VW Passat B8 — VW Group aggregator + Passat SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 66;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 394 FROM service_intervals WHERE generation_id = 66;

-- gen 72 VW Atlas CA — VW Group aggregator + Atlas SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 72;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 431 FROM service_intervals WHERE generation_id = 72;

-- gen 32 Porsche 911 992 — VW Group aggregator (Porsche is part of VW Group) + 911 SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 32;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 178 FROM service_intervals WHERE generation_id = 32;

-- gen 92 Porsche Macan 95B — VW Group aggregator + Macan SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 92;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 545 FROM service_intervals WHERE generation_id = 92;

-- gen 31 Volvo XC60 II — Volvo aggregator + XC60 SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 613 FROM service_intervals WHERE generation_id = 31;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 168 FROM service_intervals WHERE generation_id = 31;

-- gen 40 MINI F56 — BMW aggregator + MINI SM (created in 114)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 603 FROM service_intervals WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 615 FROM service_intervals WHERE generation_id = 40;

-- gen 117 LR L461 — LR aggregator (created in 115) + LR SM (created in 115)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 617 FROM service_intervals WHERE generation_id = 117;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 616 FROM service_intervals WHERE generation_id = 117;

-- gen 30 Mitsubishi Outlander GN — Mitsubishi aggregator (created in 116) + Outlander SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 619 FROM service_intervals WHERE generation_id = 30;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 163 FROM service_intervals WHERE generation_id = 30;

-- gen 73 Nissan Rogue T33 — Nissan aggregator (created in 119) + Rogue SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 620 FROM service_intervals WHERE generation_id = 73;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 436 FROM service_intervals WHERE generation_id = 73;

-- gen 116 Tesla Model S — Tesla service aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 612 FROM service_intervals WHERE generation_id = 116;

-- gen 27 Nissan Altima L34 — Nissan aggregator + Altima SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 620 FROM service_intervals WHERE generation_id = 27;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 143 FROM service_intervals WHERE generation_id = 27;

-- gen 26 Ford F-150 P702 — Ford F-150 service aggregator + F-150 SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 602 FROM service_intervals WHERE generation_id = 26;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 130 FROM service_intervals WHERE generation_id = 26;

-- gen 38 Silverado T1 — GM aggregator + Silverado SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id = 38;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 207 FROM service_intervals WHERE generation_id = 38;

-- gen 76 Tahoe T1XX — GM aggregator + Tahoe OM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id = 76;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 466 FROM service_intervals WHERE generation_id = 76;

-- gen 100 Escalade T1XX — GM aggregator + Escalade OM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id = 100;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 576 FROM service_intervals WHERE generation_id = 100;

-- gen 55 Equinox L1U — GM aggregator + Equinox SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id = 55;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 321 FROM service_intervals WHERE generation_id = 55;

-- gen 94 Ascent WM — Mazda/Subaru aggregator + Ascent SM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 608 FROM service_intervals WHERE generation_id = 94;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 555 FROM service_intervals WHERE generation_id = 94;

-- gen 122 Charger LD — Stellantis aggregator (already had 2 OM citations; this adds the aggregator as 3rd)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 611 FROM service_intervals WHERE generation_id = 122;

-- =========================================================================
-- Report: source counts per gen after the pass
-- =========================================================================
SELECT si.generation_id, mk.slug, m.name, g.codename,
  COUNT(*) AS si_rows,
  COUNT(ss.source_id) AS total_citations,
  ROUND(COUNT(ss.source_id) / COUNT(DISTINCT si.id), 2) AS avg_sources_per_row
FROM service_intervals si
JOIN generations g ON g.id = si.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
LEFT JOIN spec_sources ss ON ss.spec_table='service_intervals' AND ss.spec_id = si.id
LEFT JOIN sources s ON s.id = ss.source_id AND s.is_public = 1
WHERE si.generation_id IN (36, 66, 72, 32, 92, 31, 40, 117, 30, 73, 116, 27, 26, 38, 76, 100, 55, 94, 122)
GROUP BY si.generation_id, mk.slug, m.name, g.codename
ORDER BY si.generation_id;
