-- mig 389: decouple the engine page URL from the mutable `engines.code`
--
-- BUG (flagged by Tim): the /engines/[code] route slugifies engines.code at build
-- time. Editing a code for accuracy (migs 387/388: 5.7 HEMI→"EZB/EZH 5.7 HEMI",
-- 6.1 SRT8→"ESF 6.1 SRT8", etc.) changed the slug, so the previously-served URLs
-- (/engines/57-hemi, /engines/61-srt8) started returning 404 while gen pages still
-- linked to them. Any future code edit would re-break URLs.
--
-- FIX: add a frozen `slug` column. The route + every internal link reads this column
-- instead of recomputing from code. Editing code/display_name no longer touches the URL.
-- A BEFORE INSERT trigger auto-derives slug from code when not supplied, so new engines
-- can never ship without one.

ALTER TABLE engines ADD COLUMN slug VARCHAR(64) NULL AFTER code;

-- Populate from the same slugify rule the app used (\s and / → '-', strip non-alnum,
-- collapse repeats, lowercase). For untouched engines this equals the live URL exactly.
UPDATE engines
   SET slug = LOWER(REGEXP_REPLACE(REGEXP_REPLACE(
                REPLACE(REPLACE(code,' ','-'),'/','-'),
                '[^a-zA-Z0-9-]',''),'-+','-'))
 WHERE code IS NOT NULL AND code <> '';

-- Restore clean, stable, displacement-based slugs for the engines whose code changed in
-- migs 387/388 — these preserve the URLs already linked/indexed (57-hemi, 61-srt8) and
-- avoid ugly sales-code-derived slugs. The accurate sales code still shows on the page.
UPDATE engines SET slug = '57-hemi'      WHERE id = 166;  -- 5.7 HEMI (EZB/EZH)
UPDATE engines SET slug = '64-hemi-392'  WHERE id = 167;  -- 6.4 392 (ESG)
UPDATE engines SET slug = '62-hemi-sc'   WHERE id = 168;  -- 6.2 Hellcat (EWB)
UPDATE engines SET slug = '61-srt8'      WHERE id = 214;  -- 6.1 SRT8 (ESF)

-- Enforce uniqueness now that values are settled (collision-checked: none).
ALTER TABLE engines ADD UNIQUE KEY uk_engines_slug (slug);

-- Future-proof: auto-derive slug on insert when caller doesn't supply one. Frozen
-- thereafter (no BEFORE UPDATE trigger), so code edits never change the URL.
DROP TRIGGER IF EXISTS engines_slug_bi;
DELIMITER $$
CREATE TRIGGER engines_slug_bi BEFORE INSERT ON engines FOR EACH ROW
BEGIN
  IF NEW.slug IS NULL OR NEW.slug = '' THEN
    SET NEW.slug = LOWER(REGEXP_REPLACE(REGEXP_REPLACE(
                     REPLACE(REPLACE(NEW.code,' ','-'),'/','-'),
                     '[^a-zA-Z0-9-]',''),'-+','-'));
  END IF;
END$$
DELIMITER ;
