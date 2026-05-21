-- Citation backfill for the 69 totally-uncited service_intervals rows.
-- Migration 128 dual-sourced the 19 session gens; this migration applies
-- the same OEM-SM + manufacturer-aggregator pattern to the 14 gens that
-- had service_intervals rows with zero spec_sources citations.
--
-- Each pair below adds two citations (SM + aggregator) per gen. Uses
-- INSERT IGNORE so re-running this migration is safe.

SET NAMES utf8mb4;

-- Honda Civic FC (gen 1) — Civic SM (293) + Honda aggregator (606)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 293 FROM service_intervals WHERE generation_id = 1;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 606 FROM service_intervals WHERE generation_id = 1;

-- Toyota Camry XV70 (gen 2) — Camry OM (5, no SM in DB) + Toyota aggregator (605)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 5 FROM service_intervals WHERE generation_id = 2;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 605 FROM service_intervals WHERE generation_id = 2;

-- BMW 3 Series G20 (gen 6) — G20 SM (20) + BMW aggregator (603)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 20 FROM service_intervals WHERE generation_id = 6;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 603 FROM service_intervals WHERE generation_id = 6;

-- Toyota RAV4 XA50 (gen 12) — RAV4 SM (40) + Toyota aggregator (605)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 40 FROM service_intervals WHERE generation_id = 12;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 605 FROM service_intervals WHERE generation_id = 12;

-- Honda Accord CV (gen 42) — Accord SM (236) + Honda aggregator (606)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 236 FROM service_intervals WHERE generation_id = 42;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 606 FROM service_intervals WHERE generation_id = 42;

-- VW Tiguan AD1 (gen 44) — Tiguan SM (249) + VW Group aggregator (609)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 249 FROM service_intervals WHERE generation_id = 44;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 609 FROM service_intervals WHERE generation_id = 44;

-- Toyota Tacoma N300 (gen 47) — Tacoma SM (270) + Toyota aggregator (605)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 270 FROM service_intervals WHERE generation_id = 47;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 605 FROM service_intervals WHERE generation_id = 47;

-- BMW X5 G05 (gen 48) — X5 SM (277) + BMW aggregator (603)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 277 FROM service_intervals WHERE generation_id = 48;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 603 FROM service_intervals WHERE generation_id = 48;

-- Kia Telluride ON (gen 59) — Telluride SM (350) + Hyundai/Kia/Genesis (607)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 350 FROM service_intervals WHERE generation_id = 59;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 607 FROM service_intervals WHERE generation_id = 59;

-- BMW X3 G01 (gen 60) — X3 SM (353) + BMW aggregator (603)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 353 FROM service_intervals WHERE generation_id = 60;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 603 FROM service_intervals WHERE generation_id = 60;

-- Mercedes GLC X253 (gen 61) — GLC SM (359) + Mercedes aggregator (604)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 359 FROM service_intervals WHERE generation_id = 61;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 604 FROM service_intervals WHERE generation_id = 61;

-- Honda Pilot YF (gen 62) — Pilot SM (371) + Honda aggregator (606)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 371 FROM service_intervals WHERE generation_id = 62;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 606 FROM service_intervals WHERE generation_id = 62;

-- Honda Jazz GR9 (gen 63) — Jazz SM (375) + Honda aggregator (606)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 375 FROM service_intervals WHERE generation_id = 63;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 606 FROM service_intervals WHERE generation_id = 63;

-- Lexus NX AZ20 (gen 64) — Lexus NX SM (378, NOT 77 which was wrong Hyundai match)
--                        + Toyota/Lexus aggregator (605)
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 378 FROM service_intervals WHERE generation_id = 64;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 605 FROM service_intervals WHERE generation_id = 64;

-- Verification report
SELECT 'POST-MIGRATION 129' AS marker,
  (SELECT COUNT(*) FROM service_intervals si WHERE NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id)) AS uncited,
  (SELECT COUNT(*) FROM service_intervals si WHERE 1 = (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss JOIN sources s ON s.id=ss.source_id WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND s.is_public=1)) AS single_source,
  (SELECT COUNT(*) FROM service_intervals si WHERE 2 <= (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss JOIN sources s ON s.id=ss.source_id WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND s.is_public=1)) AS two_or_more_sources,
  (SELECT COUNT(*) FROM service_intervals) AS total_rows;
