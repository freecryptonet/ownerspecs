-- Source citation link policy: hide URLs for HaynesPro / aggregator / third-
-- party PDF-host sources to (a) stop bleeding SEO link equity to competitors
-- and (b) avoid DMCA / copyright invitations from paid workshop datasets like
-- HaynesPro.
--
-- Rendered citations follow academic style: text-only ("BMW US 2024 5 Series
-- Owner's Manual, Part no. 01405A8A5A2") for non-public sources; URL retained
-- in the DB for internal audit. Only sources with public_link=1 render a
-- clickable link (with rel="nofollow noopener noreferrer").
--
-- Backfill policy:
-- - public_link=1: manufacturer-owned domains (bmw.com, audi.com, vw.com,
--   toyota.com, honda.com), NHTSA, SAE, EPA, official government data
-- - public_link=0: HaynesPro (workshopdata.com), aggregator sites
--   (auto-data.net, ultimatespecs.com), third-party PDF hosts
--   (ownersmanuals2.com, manualslib.com), Wikipedia, blog/forum links

SET NAMES utf8mb4;

ALTER TABLE sources
  ADD COLUMN public_link tinyint(1) NOT NULL DEFAULT 0 AFTER url;

-- Backfill: explicitly mark each known source type
-- 1 (link rendered, rel=nofollow noopener noreferrer):
UPDATE sources
SET public_link = 1
WHERE url IS NOT NULL
  AND (
    url LIKE 'https://www.bmw.com/%' OR url LIKE 'https://www.audi.com/%'
    OR url LIKE 'https://www.volkswagen.%' OR url LIKE 'https://www.vw.com/%'
    OR url LIKE 'https://www.toyota.com/%' OR url LIKE 'https://www.lexus.com/%'
    OR url LIKE 'https://www.honda.com/%' OR url LIKE 'https://owners.honda.com/%'
    OR url LIKE 'https://www.acura.com/%'
    OR url LIKE 'https://www.hyundai%' OR url LIKE 'https://www.kia%'
    OR url LIKE 'https://www.genesis%'
    OR url LIKE 'https://www.mazda%' OR url LIKE 'https://www.subaru%'
    OR url LIKE 'https://www.ford.com/%' OR url LIKE 'https://www.chevrolet.com/%'
    OR url LIKE 'https://www.gmc.com/%' OR url LIKE 'https://www.cadillac.com/%'
    OR url LIKE 'https://www.dodge.com/%' OR url LIKE 'https://www.jeep.com/%'
    OR url LIKE 'https://www.chrysler.com/%' OR url LIKE 'https://www.ram%'
    OR url LIKE 'https://www.volvocars.com/%' OR url LIKE 'https://www.mercedes-benz%'
    OR url LIKE 'https://www.porsche.com/%' OR url LIKE 'https://www.tesla.com/%'
    OR url LIKE '%vpic.nhtsa.dot.gov%' OR url LIKE '%nhtsa.gov%'
    OR url LIKE '%epa.gov%' OR url LIKE '%fueleconomy.gov%'
    OR url LIKE '%sae.org%'
  );

-- 0 (text-only citation — explicit even though it's the default):
UPDATE sources
SET public_link = 0
WHERE url IS NOT NULL
  AND (
    url LIKE '%workshopdata.com%'                  -- HaynesPro
    OR url LIKE '%ownersmanuals2.com%'             -- third-party PDF host
    OR url LIKE '%manualslib.com%'
    OR url LIKE '%auto-data.net%'                  -- aggregator
    OR url LIKE '%ultimatespecs.com%'              -- aggregator
    OR url LIKE '%startmycar.com%'                 -- community Q&A
    OR url LIKE '%wikipedia%' OR url LIKE '%wikimedia%'
    OR url LIKE '%flickr.com%'                     -- (only for image source rows)
  );

-- Anything still NULL (url IS NULL — text-only citation that never had a URL):
-- default of 0 is correct; nothing to do.

-- Quick audit summary view
SELECT public_link, COUNT(*) AS n FROM sources GROUP BY public_link;
