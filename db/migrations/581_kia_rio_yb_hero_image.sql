-- 581: hero image for Kia Rio IV (YB) hatchback (gen 456) — was missing.
-- Sourced from Wikimedia Commons, CC BY-SA 4.0, full provenance per the images-table contract
-- (source/license/attribution/original_url/download_date). Front 3/4 view (position 3-4-front)
-- so getGenerationHero() picks it. File placed at public/images/kia/rio-yb-hatchback-2018-2023/hero.jpg.
INSERT INTO images
  (generation_id, position, url, source, license, attribution, original_url, download_date, caption, width, height)
VALUES
  (456, '3-4-front', '/images/kia/rio-yb-hatchback-2018-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
   'EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2017_Kia_Rio_(YB)_S_5-door_hatchback_(2017-07-15)_01.jpg',
   CURDATE(), '2017 Kia Rio (YB) 5-door hatchback', 1920, 1219);
