-- A6 C8 family hero images. All sourced from Wikimedia Commons under
-- CC BY-SA 4.0. Heroes go to /images/audi/{gen-slug}/hero.jpg on disk.

SET NAMES utf8mb4;

INSERT INTO images (generation_id, url, source, license, attribution, original_url, download_date, caption, position, width, height) VALUES
  (152, '/images/audi/a6-avant-c8-2018-2023/hero.jpg',
   'wikimedia', 'cc-by-sa-4.0',
   'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2019_Audi_A6_Avant_TDi_40.jpg',
   '2026-05-22', 'Audi A6 Avant (C8) — pre-LCI', '3-4-front', 1280, 760),
  (153, '/images/audi/a6-c8-lci-sedan-2023-present/hero.jpg',
   'wikimedia', 'cc-by-sa-4.0',
   'Johannes Maximilian / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:Audi_A6_4K_2024-08-01_JM_5D413545.jpg',
   '2026-05-22', 'Audi A6 (C8 LCI) Sedan — facelift 2023', '3-4-front', 1280, 853),
  (154, '/images/audi/a6-avant-c8-lci-2023-present/hero.jpg',
   'wikimedia', 'cc-by-sa-4.0',
   'Alexander-93 / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2024_Audi_A6_Avant_C8_IMG_0135.jpg',
   '2026-05-22', 'Audi A6 (C8 LCI) Avant — facelift 2023', '3-4-front', 1280, 853),
  (155, '/images/audi/a6-allroad-c8-2020-present/hero.jpg',
   'wikimedia', 'cc-by-sa-4.0',
   'Alexander-93 / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:Audi_A6_Allroad_Quattro_C8_IMG_0070.jpg',
   '2026-05-22', 'Audi A6 Allroad quattro (C8)', '3-4-front', 1280, 688);

SELECT id, generation_id, url, attribution FROM images WHERE generation_id IN (152,153,154,155);
