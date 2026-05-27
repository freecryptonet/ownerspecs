-- mig 512: fix the SX4 (2006-2014) gen ingested from auto-data. The scraper created a
-- "SX4 S-Cross" model, but the 2006-2014 car is the original "SX4" nameplate (the S-Cross
-- is the separate 2013+ model already in the catalogue). Rename the model, fix the gen
-- slug/codename/years, add hero. M15A (2070) + M16A (2069) were reused by the scraper, so
-- the engine-compare "where used" now shows both Swift (ZC/ZD) and SX4.

UPDATE models SET name='SX4', slug='sx4' WHERE id=185;

UPDATE generations
   SET slug='sx4-hatchback-2006-2014', codename='EY/GY', display_name='SX4 (EY)',
       start_year=2006, end_year=2014
 WHERE id=349;

INSERT INTO images (generation_id, url, source, license, attribution, original_url, download_date, caption, position, width, height) VALUES
(349, '/images/suzuki/sx4-hatchback-2006-2014/hero.jpg', 'wikimedia', 'CC BY-SA 2.0',
 'Photo: RL GNZLZ / Wikimedia Commons, CC BY-SA 2.0',
 'https://commons.wikimedia.org/wiki/File:Suzuki_SX4_1.6_Urban_Sport_2007_(47055586571).jpg',
 '2026-05-27', '2007 Suzuki SX4 1.6 (M16A)', '3-4-front', 1280, 853);
