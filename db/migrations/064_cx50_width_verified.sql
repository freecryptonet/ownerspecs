-- Mazda CX-50 width backfill — completes the gen-row dimension set.
-- NHTSA Canadian Specs had no match for CX-50, so we sourced from the
-- Mazda OM directly via manualslib.
--
-- Cross-check matrix:
--                        Mazda OM (manualslib p.571)   Mazda press / dealer
--   length_mm            4720                          (already 4719 in DB; agrees)
--   width_mm             1920                          75.6 in = 1920 mm
--   height_mm            1604–1662 (range by trim)     (already 1623 in DB; in range)
--   wheelbase_mm         2815                          (already 2814 in DB; agrees)
--
-- Only width was NULL; this migration fills it. Existing length/height/
-- wheelbase values are within 1 mm of the Mazda OM and were left intact
-- by COALESCE.

SET NAMES utf8mb4;

UPDATE generations SET width_mm = COALESCE(width_mm, 1920)
WHERE slug = 'cx-50-suv-2023-present';

INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Mazda CX-50 2024 Owner''s Manual (via manualslib, p.571)',
       NOW(),
       1,
       'https://www.manualslib.com/manual/3706420/Mazda-Cx-50-2024.html?page=571',
       'Specifications section: overall length 4720, width 1920, height 1604-1662 (trim range), wheelbase 2815 mm. Also GVWR 2199-2243 kg by engine.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mazda CX-50 2024 Owner''s Manual (via manualslib, p.571)');

SELECT 'CX-50 width filled' AS status,
       length_mm, width_mm, height_mm, wheelbase_mm
FROM generations WHERE slug='cx-50-suv-2023-present';
