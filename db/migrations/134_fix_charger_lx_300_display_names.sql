-- Fix display_name on the two new LX-platform gens.
-- Migrations 130 + 131 stored display_name with the brand prefix and the
-- year range ("Dodge Charger (LX) 2006-2010" / "Chrysler 300 (LX) 2005-2010").
-- The homepage renderer prepends the brand from makes.name and appends the
-- year range from start_year/end_year, producing duplicated output like
-- "Dodge Dodge Charger (LX) 2006-2010 · 2006 – 2010".
--
-- Existing pattern (e.g. Charger LD gen 122): display_name = "Charger VII (LD)"
-- — model + Roman ordinal + codename only. This migration brings the two new
-- gens into line with that convention.

SET NAMES utf8mb4;

UPDATE generations SET display_name = 'Charger VI (LX)' WHERE id = 123;
UPDATE generations SET display_name = '300 (LX)'        WHERE id = 124;

SELECT id, slug, display_name, codename, start_year, end_year FROM generations WHERE id IN (122, 123, 124) ORDER BY id;
