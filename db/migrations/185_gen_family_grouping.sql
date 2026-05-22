-- Family grouping for related generations (e.g. F30 sedan + F30 LCI sedan +
-- F31 Touring + F80 M3 all belong to the BMW 3-Series F30-platform family).
--
-- This adds an umbrella layer on top of per-gen pages without merging the
-- gens themselves. Each family has its own page at /family/<family-slug>
-- showing all sibling gens side-by-side with a "which one is mine?"
-- disambiguator. Gen pages get a small "related gens" block linking to
-- siblings.
--
-- Per-gen pages remain canonical for SEO — family pages add discoverability
-- only.

SET NAMES utf8mb4;

ALTER TABLE generations
  ADD COLUMN family_slug varchar(96) NULL AFTER codename,
  ADD COLUMN family_label varchar(96) NULL AFTER family_slug,
  ADD INDEX ix_generations_family (family_slug);

-- ----------------------------------------------------------------------------
-- Backfill — BMW families
-- ----------------------------------------------------------------------------
-- BMW 3-Series F30 platform family (2012-2019): F30 sedan, F30 LCI sedan
UPDATE generations
SET family_slug = 'bmw-3-series-f30-2012-2019',
    family_label = 'BMW 3 Series F30 family (2012-2019)'
WHERE slug IN ('3-series-f30-sedan-2012-2015', '3-series-f30-lci-sedan-2015-2018');

-- BMW 3-Series G20 platform family (2019-present): G20 sedan, G20 LCI sedan
UPDATE generations
SET family_slug = 'bmw-3-series-g20-2019-present',
    family_label = 'BMW 3 Series G20 family (2019-present)'
WHERE slug IN ('3-series-sedan-g20-2019-2022', '3-series-sedan-g20-lci-2022-present');

-- BMW 5-Series G30 platform family (2017-2024): G30 sedan, G30 LCI sedan,
-- G31 Touring (the F90 M5 is the same platform but isn't yet in the DB)
UPDATE generations
SET family_slug = 'bmw-5-series-g30-2017-2024',
    family_label = 'BMW 5 Series G30 family (2017-2024)'
WHERE slug IN (
  '5-series-g30-sedan-2017-2020',
  '5-series-g30-lci-sedan-2020-2023',
  '5-series-g31-touring-2017-2020'
);

-- BMW 5-Series G60 platform family (2023-present): G60 sedan + i5 (separate
-- model entry but same chassis platform — cross-list for "which one is mine?"
-- disambiguation, e.g. ICE vs BEV)
UPDATE generations
SET family_slug = 'bmw-5-series-g60-2023-present',
    family_label = 'BMW 5 Series G60 family (2023-present)'
WHERE slug IN (
  '5-series-g60-sedan-2023-present',
  'i5-g60-sedan-2023-present'
);

-- ----------------------------------------------------------------------------
-- Backfill — non-BMW where the structure helps (Camry XV70, Civic FC, MDX YD4
--                                                                  — left for follow-up)
-- ----------------------------------------------------------------------------
-- For now only BMW. Other makes get family backfill in follow-up migrations
-- once we've confirmed the family UX works.
