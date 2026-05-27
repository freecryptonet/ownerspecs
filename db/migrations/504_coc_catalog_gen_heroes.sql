-- mig 504: hero images (Wikimedia Commons, full provenance) for the 4 new catalog gens.
INSERT INTO images (generation_id, url, source, license, attribution, original_url, download_date, caption, position, width, height) VALUES
(344, '/images/nissan/qashqai-j11-suv-2014-2021/hero.jpg', 'wikimedia', 'CC BY-SA 4.0',
 'Photo: Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
 'https://commons.wikimedia.org/wiki/File:NISSAN_QASHQAI_(J11)_China_(14).jpg',
 '2026-05-27', 'Nissan Qashqai II (J11)', '3-4-front', 1280, 853),
(345, '/images/nissan/juke-f15-suv-2010-2019/hero.jpg', 'wikimedia', 'CC0',
 'Photo: Tokumeigakarinoaoshima / Wikimedia Commons, CC0',
 'https://commons.wikimedia.org/wiki/File:Nissan_JUKE_NISMO_(F15)_front.JPG',
 '2026-05-27', 'Nissan Juke (F15)', '3-4-front', 1280, 853),
(346, '/images/hyundai/i20-gb-hatchback-2014-2020/hero.jpg', 'wikimedia', 'CC BY-SA 4.0',
 'Photo: Vauxford / Wikimedia Commons, CC BY-SA 4.0',
 'https://commons.wikimedia.org/wiki/File:2015_Hyundai_i20_Premium_SE_MPi_1.4_Front.jpg',
 '2026-05-27', '2015 Hyundai i20 (GB)', '3-4-front', 1280, 853),
(347, '/images/mitsubishi/outlander-gf-suv-2012-2021/hero.jpg', 'wikimedia', 'CC BY-SA 4.0',
 'Photo: EurovisionNim / Wikimedia Commons, CC BY-SA 4.0',
 'https://commons.wikimedia.org/wiki/File:2013_Mitsubishi_Outlander_(ZJ_MY14)_ES_2WD_wagon_(2014-12-26).jpg',
 '2026-05-27', '2013 Mitsubishi Outlander III (GF)', '3-4-front', 1280, 853);
