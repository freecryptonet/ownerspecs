-- Audit pass A — source-table cleanup.
--
-- 1. Rename the misleading "Internal cross-verification dataset A/B" to
--    honest citations that name the actual scraper origin. These are
--    used internally (is_public=0) but the citation text shouldn't lie
--    about what they are.
-- 2. Dedupe genuine duplicate source rows from my batch 14 migration
--    re-runs (Audi A6, Tesla Model S, Lexus RX) — keep oldest ID,
--    repoint spec_sources, delete the rest.

SET NAMES utf8mb4;

-- 1. Honest citations
UPDATE sources SET citation = 'auto-data.net (scraped, internal cross-verification)'
WHERE citation = 'Internal cross-verification dataset A';

UPDATE sources SET citation = 'ultimatespecs.com (scraped, internal cross-verification)'
WHERE citation = 'Internal cross-verification dataset B';

-- 2. Dedupe — for each (citation, type, is_public) group with N>1,
--    repoint spec_sources to the lowest-ID row and delete the rest.
--
-- This is a manual fix for known dupes; we'd rather be explicit than
-- run a destructive cursor over the whole table.

-- Audi A6 (C8) Owner's Manual: keep 579, delete 581 + 583
UPDATE spec_sources SET source_id = 579 WHERE source_id IN (581, 583);
DELETE FROM sources WHERE id IN (581, 583);

-- Tesla Model S Owner's Manual: keep 580, delete 582 + 584
UPDATE spec_sources SET source_id = 580 WHERE source_id IN (582, 584);
DELETE FROM sources WHERE id IN (582, 584);

-- Lexus RX (AL20) Service Manual: keep 185, delete 188
UPDATE spec_sources SET source_id = 185 WHERE source_id = 188;
DELETE FROM sources WHERE id = 188;

SELECT 'Source cleanup done' AS status,
       (SELECT COUNT(*) FROM sources) AS total_rows,
       (SELECT COUNT(DISTINCT citation) FROM sources) AS distinct_citations;
