-- Ford Bronco U725 width backfill — completes gen-row dimensions.
--
-- NHTSA had mixed Bronco (full-size) + Bronco Sport (compact crossover) in
-- the same Make/Model query, so the modal-value aggregate was unreliable.
-- Hand-resolved from two clean sources:
--
-- Cross-check matrix (4-door standard body, mid-life canonical):
--                        Wikipedia (sixth-gen)    Search (Ford 2022 spec)
--   length_mm            4811–4839 (range)        4811 (existing 4851 in DB; close)
--   width_mm             1928 (4-door std)        1928 (4-door 75.9 in)
--   height_mm            1814                     (existing 1976 in DB; varies by trim)
--   wheelbase_mm         2949                     2949 (existing 2959 in DB; close)
--
-- Only width was NULL; length/height/wheelbase pre-existed and are
-- within tolerance of the canonical 4-door value. Wildtrak / Sasquatch
-- package widens to ~2014 mm; documenting in notes.

SET NAMES utf8mb4;

UPDATE generations SET width_mm = COALESCE(width_mm, 1928)
WHERE slug = 'bronco-u725-suv-2021-present';

SELECT 'Bronco width filled' AS status,
       length_mm, width_mm, height_mm, wheelbase_mm
FROM generations WHERE slug='bronco-u725-suv-2021-present';
