-- ownerspecs.com · hero images for the 3 existing generations
--
-- Sourced from Wikimedia Commons under CC BY-SA 4.0. Files downloaded to
-- /public/images/{make}/{gen-slug}/hero.jpg (1280px thumbs from Wikimedia
-- thumbnailer; original files are 4-5K px). Attribution rendered in the
-- page footer per CC BY-SA terms.

SET NAMES utf8mb4;

-- BMW G20
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/bmw/3-series-sedan-g20-2019-2022/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2019_BMW_330i_M_Sport_2.0_Front.jpg',
  CURDATE(),
  '2019 BMW 330i M Sport',
  '3-4-front', 1280, 792
FROM generations g WHERE g.codename = 'G20';

-- Civic FC
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/honda/civic-sedan-x-2016-2021/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2018_Honda_Civic_Saloon_Front.jpg',
  CURDATE(),
  '2018 Honda Civic Saloon',
  '3-4-front', 1280, 653
FROM generations g WHERE g.codename = 'FC';

-- Camry XV70
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/toyota/camry-xv70-2018-2024/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2018_Toyota_Camry_SE_front_3.16.18.jpg',
  CURDATE(),
  '2018 Toyota Camry SE',
  '3-4-front', 1280, 583
FROM generations g WHERE g.codename = 'XV70';

SELECT g.codename, i.url, i.attribution, i.width, i.height
FROM images i JOIN generations g ON g.id = i.generation_id
ORDER BY g.codename;
