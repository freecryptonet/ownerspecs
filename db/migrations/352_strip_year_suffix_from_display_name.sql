-- mig 352 — strip year suffixes from generations.display_name.
-- Surfaced 2026-05-24 from a homepage screenshot: "Recently published"
-- cards rendered "Mercedes-Benz B-Class (W247, 3rd gen) 2019- · 2019 –
-- present" — display_name has the year baked in AND the renderer adds
-- a separate "start_year – end_year/present" suffix, so:
--   (a) it's redundant
--   (b) the open-ended "2019-" form ends in a trailing dash that looks
--       like a typo
--
-- Scope:
--   108 rows match " YYYY-YYYY$" (closed range, e.g. "X5 (E70, 2nd gen) 2006-2010")
--    49 rows match " YYYY-$"     (open / present, e.g. "M2 (G87) 2023-")
--     2 rows have a single year (Silverado/Sierra T1) — leave alone, not a suffix
--
-- After this, display_name is pure model+chassis identifier ("B-Class
-- (W247, 3rd gen)"), and every renderer (homepage cards, hub h1, breadcrumbs,
-- topic-page titles, family pages, compare pages, engine-by-engine pages)
-- gets the cleaner output for free.

SET NAMES utf8mb4;

START TRANSACTION;

-- 1. Strip closed range " YYYY-YYYY" from end of display_name (108 rows).
UPDATE generations
SET display_name = REGEXP_REPLACE(display_name, ' [0-9]{4}-[0-9]{4}$', '')
WHERE display_name REGEXP ' [0-9]{4}-[0-9]{4}$';

-- 2. Strip open range " YYYY-" from end of display_name (49 rows).
UPDATE generations
SET display_name = REGEXP_REPLACE(display_name, ' [0-9]{4}-$', '')
WHERE display_name REGEXP ' [0-9]{4}-$';

-- POST-CHECK — both should be 0
SELECT 'remaining closed-range suffixes' k, COUNT(*) n FROM generations WHERE display_name REGEXP ' [0-9]{4}-[0-9]{4}$'
UNION ALL
SELECT 'remaining open-range suffixes', COUNT(*) FROM generations WHERE display_name REGEXP ' [0-9]{4}-$'
UNION ALL
SELECT 'rows with empty display_name (safety net)', COUNT(*) FROM generations WHERE display_name IS NULL OR display_name = '';

COMMIT;
