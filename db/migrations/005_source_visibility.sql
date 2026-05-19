-- ownerspecs.com · v0.3 · source visibility split
--
-- Public-facing pages cite ONLY owner manuals, factory service manuals, and
-- service bulletins — never the third-party catalogues we use internally for
-- cross-verification. The internal sources stay in the DB so we keep the
-- provenance for ourselves, just hidden from rendered pages.
--
-- Wikipedia is permitted (CC-licensed factual content) but we don't have any
-- cited yet.

SET NAMES utf8mb4;

-- ===================================================================
-- Add public-visibility flag to sources
-- ===================================================================

ALTER TABLE sources
  ADD COLUMN is_public TINYINT(1) NOT NULL DEFAULT 1 AFTER notes;

-- Mark internal cross-verification sources as not-public
UPDATE sources SET is_public = 0
WHERE type IN ('auto_data', 'ultimatespecs', 'haynespro', 'alldata', 'mitchell');

-- ===================================================================
-- Add a public OEM-manual citation for BMW G20 + link existing spec_sources
-- ===================================================================

INSERT INTO sources (type, citation, url, retrieved_at, notes, is_public)
VALUES (
  'oem_manual',
  'BMW 3 Series (G20) Service Manual',
  NULL,
  NOW(),
  'Manufacturer service literature · G20 chassis (2019–2022)',
  1
);
SET @bmw_g20_manual_id := LAST_INSERT_ID();

-- Link every G20 trim row + fluid_specs row to this public citation.
-- INSERT IGNORE because unique index on (spec_table, spec_id, source_id).
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'trims', t.id, @bmw_g20_manual_id
FROM trims t
JOIN generations g ON t.generation_id = g.id
WHERE g.codename = 'G20';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @bmw_g20_manual_id
FROM fluid_specs f
JOIN generations g ON f.generation_id = g.id
WHERE g.codename = 'G20';

-- Verify
SELECT 'sources visibility:' AS check_section, NULL AS detail, NULL AS count
UNION ALL
SELECT 'sources public', type, COUNT(*) FROM sources WHERE is_public = 1 GROUP BY type
UNION ALL
SELECT 'sources hidden', type, COUNT(*) FROM sources WHERE is_public = 0 GROUP BY type
UNION ALL
SELECT 'bmw g20 spec_sources via public sources', NULL,
  (SELECT COUNT(*) FROM spec_sources ss
   JOIN sources s ON ss.source_id = s.id
   WHERE s.is_public = 1 AND ss.spec_id IN (
     SELECT id FROM trims WHERE generation_id IN (SELECT id FROM generations WHERE codename='G20')
   ));
