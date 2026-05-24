-- mig 353 — set family_slug / family_label on the BMW X-line G-generation
-- chassis. Enables the /family/[slug] comparison page and the "Related on
-- same chassis" pill bar on each gen hub. Follows the existing convention
-- from bmw-3-series-g20-2019-present (G20 + G21 + M3 + M3 Touring all in
-- one family) and bmw-5-series-g30-2017-2024.
--
-- Families:
--   bmw-x3-g01-2018-present  → 4 gens: X3 G01, X4 G02, X4 G02 LCI, X4M F98
--   bmw-x5-g05-2019-present  → 5 gens: X5 G05, X6 G06, X6 G06 LCI, X6M F96, X6M F96 LCI
--   bmw-x7-g07-2018-present  → 2 gens: X7 G07, X7 G07 LCI
--
-- The X5M F95 chassis is not yet in the catalog — when added later,
-- another short UPDATE will fold it into bmw-x5-g05-2019-present.

SET NAMES utf8mb4;

START TRANSACTION;

-- X3 G01 family (shares CLAR platform with X4 G02 sibling)
UPDATE generations
SET family_slug = 'bmw-x3-g01-2018-present',
    family_label = 'BMW X3 G01 family (2018-present)'
WHERE id IN (60, 231, 232, 233);   -- X3 G01, X4 G02, X4 G02 LCI, X4M F98

-- X5 G05 family (shares CLAR platform with X6 G06 sibling)
UPDATE generations
SET family_slug = 'bmw-x5-g05-2019-present',
    family_label = 'BMW X5 G05 family (2019-present)'
WHERE id IN (48, 237, 238, 239, 240);   -- X5 G05, X6 G06, X6 G06 LCI, X6M F96, X6M F96 LCI

-- X7 G07 family (standalone — no sister body)
UPDATE generations
SET family_slug = 'bmw-x7-g07-2018-present',
    family_label = 'BMW X7 G07 family (2018-present)'
WHERE id IN (241, 242);   -- X7 G07, X7 G07 LCI

-- POST-CHECK
SELECT family_slug, family_label, COUNT(*) gens,
  GROUP_CONCAT(slug ORDER BY start_year SEPARATOR ', ') members
FROM generations
WHERE family_slug IN ('bmw-x3-g01-2018-present', 'bmw-x5-g05-2019-present', 'bmw-x7-g07-2018-present')
GROUP BY family_slug, family_label;

COMMIT;
