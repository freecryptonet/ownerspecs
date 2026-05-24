-- mig 363: Index 7 Stellantis NA owner-manual PDFs from Mopar.com into manual_inventory + sources
-- Source: https://vehicleinfo.mopar.com/assets/publications/en-us/<Brand>/<Year>/<Model>/<DocCode>.pdf
-- Manufacturer-owned domain (Stellantis North America) → public_link = 1 eligible (per mig 194 policy).
-- PDFs downloaded 2026-05-25; live at /home/deploy/ownerspecs/manuals/.
--
-- These OEM owner manuals supersede / complement the existing Chrysler 300 LX Mopar FSM linkage (mig 358)
-- and provide first OEM source for the other 6 Stellantis gens currently in our DB.

-- 1. manual_inventory rows
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Chrysler_300_LX_2008_OM_Mopar.pdf',
   'cf2239ff0c141a518a2e5d6be6b1cad999f1a1d6fe1b8938a6b9dc033647cc6a',
   'owner', 'Chrysler', '300', 2008, 2008, '776', NULL, NULL,
   'en-US', 'US', NULL, 'Chrysler 300 Owner''s Manual', NOW(),
   'Chrysler 300 (LX) 2008 model-year Owner''s Manual; from Mopar.com vehicleinfo CDN.'),

  ('manuals/Chrysler_Pacifica_RU_2020_OM_Mopar.pdf',
   'caa070702a5ba33c68a8dd11911e73a9a19c817971f9cde3dddae7aeb3b600ef',
   'owner', 'Chrysler', 'Pacifica', 2020, 2020, 'P124008', '20_RU_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', NULL, 'Chrysler Pacifica Owner''s Manual', NOW(),
   'Chrysler Pacifica (RU) 2020 model-year Owner''s Manual; from Mopar.com vehicleinfo CDN.'),

  ('manuals/Dodge_Charger_LX_2008_OM_Mopar.pdf',
   '493fe3f756cf2d6b4788aebe685c62390278732cc92bc10c0975868302e49edd',
   'owner', 'Dodge', 'Charger', 2008, 2008, '789', NULL, NULL,
   'en-US', 'US', NULL, 'Dodge Charger Owner''s Manual', NOW(),
   'Dodge Charger (LX) 2008 model-year Owner''s Manual; from Mopar.com vehicleinfo CDN.'),

  ('manuals/Dodge_Charger_LD_2017_OM_Mopar.pdf',
   'a0dc1370e349aa64e38b4baea64204b0778ddc94212d799f4f9c9e1e8f454880',
   'owner', 'Dodge', 'Charger', 2017, 2017, '2126', NULL, NULL,
   'en-US', 'US', NULL, 'Dodge Charger Owner''s Manual', NOW(),
   'Dodge Charger (LD) 2017 model-year Owner''s Manual; from Mopar.com vehicleinfo CDN.'),

  ('manuals/Jeep_GrandCherokee_WL_2023_OM_Mopar.pdf',
   '164d861344bf4b6d67040407179f85e4ddcdab34cda75c17db71eb14db053452',
   'owner', 'Jeep', 'Grand Cherokee', 2023, 2023, '5754794', '23_WL_OM_EN_USC_DIGITAL_E5', NULL,
   'en-US', 'US', NULL, 'Jeep Grand Cherokee Owner''s Manual', NOW(),
   'Jeep Grand Cherokee (WL) 2023 Owner''s Manual; covers L variant body but WL chassis. From Mopar.com vehicleinfo CDN.'),

  ('manuals/Jeep_Wrangler_JL_2020_OM_Mopar.pdf',
   'eccf53d564172144d82728cacc2b7f87210c2dd7af0a535e1df78f588a92cd92',
   'owner', 'Jeep', 'Wrangler', 2020, 2020, 'P138305', '20_JL_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', NULL, 'Jeep Wrangler Owner''s Manual', NOW(),
   'Jeep Wrangler (JL) 2020 Owner''s Manual; from Mopar.com vehicleinfo CDN.'),

  ('manuals/Ram_1500_DT_2022_OM_Mopar.pdf',
   'c68b42707a0aeb6bd9959fda2bfc50550eb9cbc71410b2e6fe2a3b0fbd38853c',
   'owner', 'Ram', '1500', 2022, 2022, '5690658', '22_DT_OM_EN_USC_DIGITAL_E5', NULL,
   'en-US', 'US', NULL, 'Ram 1500 Owner''s Manual', NOW(),
   'Ram 1500 (DT) 2022 Owner''s Manual; from Mopar.com vehicleinfo CDN.');

-- 2. sources rows — public_link=1 since vehicleinfo.mopar.com is a manufacturer-owned CDN
INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
SELECT 'oem_manual',
       CONCAT(mi.brand, ' ', mi.model, ' (', YEAR(NOW()), ') Owner''s Manual'),
       NULL, mi.id, 1, 0, NOW(),
       'OEM Owner''s Manual from Mopar.com. URL kept internal; cite as text (public_link=0 default) until URL stability is verified across years.'
  FROM manual_inventory mi
  WHERE mi.sha256 IN (
    'cf2239ff0c141a518a2e5d6be6b1cad999f1a1d6fe1b8938a6b9dc033647cc6a',
    'caa070702a5ba33c68a8dd11911e73a9a19c817971f9cde3dddae7aeb3b600ef',
    '493fe3f756cf2d6b4788aebe685c62390278732cc92bc10c0975868302e49edd',
    'a0dc1370e349aa64e38b4baea64204b0778ddc94212d799f4f9c9e1e8f454880',
    '164d861344bf4b6d67040407179f85e4ddcdab34cda75c17db71eb14db053452',
    'eccf53d564172144d82728cacc2b7f87210c2dd7af0a535e1df78f588a92cd92',
    'c68b42707a0aeb6bd9959fda2bfc50550eb9cbc71410b2e6fe2a3b0fbd38853c'
  );

-- 3. Cleaner citations after insert (the CONCAT above is generic — set proper per-row text)
UPDATE sources s
  JOIN manual_inventory mi ON s.manual_inventory_id = mi.id
  SET s.citation = CASE mi.sha256
    WHEN 'cf2239ff0c141a518a2e5d6be6b1cad999f1a1d6fe1b8938a6b9dc033647cc6a' THEN 'Chrysler 300 (LX) 2008 Owner''s Manual'
    WHEN 'caa070702a5ba33c68a8dd11911e73a9a19c817971f9cde3dddae7aeb3b600ef' THEN 'Chrysler Pacifica (RU) 2020 Owner''s Manual'
    WHEN '493fe3f756cf2d6b4788aebe685c62390278732cc92bc10c0975868302e49edd' THEN 'Dodge Charger (LX) 2008 Owner''s Manual'
    WHEN 'a0dc1370e349aa64e38b4baea64204b0778ddc94212d799f4f9c9e1e8f454880' THEN 'Dodge Charger (LD) 2017 Owner''s Manual'
    WHEN '164d861344bf4b6d67040407179f85e4ddcdab34cda75c17db71eb14db053452' THEN 'Jeep Grand Cherokee (WL) 2023 Owner''s Manual'
    WHEN 'eccf53d564172144d82728cacc2b7f87210c2dd7af0a535e1df78f588a92cd92' THEN 'Jeep Wrangler (JL) 2020 Owner''s Manual'
    WHEN 'c68b42707a0aeb6bd9959fda2bfc50550eb9cbc71410b2e6fe2a3b0fbd38853c' THEN 'Ram 1500 (DT) 2022 Owner''s Manual'
    ELSE s.citation
  END
  WHERE mi.brand IN ('Chrysler', 'Dodge', 'Jeep', 'Ram')
    AND s.retrieved_at >= DATE_SUB(NOW(), INTERVAL 1 MINUTE);

-- 4. Link sources to their gens via spec_sources on the generations row
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'generations', gen_id, s.id FROM (
  SELECT 124 AS gen_id, 'cf2239ff0c141a518a2e5d6be6b1cad999f1a1d6fe1b8938a6b9dc033647cc6a' AS sha UNION
  SELECT 86,             'caa070702a5ba33c68a8dd11911e73a9a19c817971f9cde3dddae7aeb3b600ef' UNION
  SELECT 123,            '493fe3f756cf2d6b4788aebe685c62390278732cc92bc10c0975868302e49edd' UNION
  SELECT 122,            'a0dc1370e349aa64e38b4baea64204b0778ddc94212d799f4f9c9e1e8f454880' UNION
  SELECT 69,             '164d861344bf4b6d67040407179f85e4ddcdab34cda75c17db71eb14db053452' UNION
  SELECT 37,             'eccf53d564172144d82728cacc2b7f87210c2dd7af0a535e1df78f588a92cd92' UNION
  SELECT 43,             'c68b42707a0aeb6bd9959fda2bfc50550eb9cbc71410b2e6fe2a3b0fbd38853c'
) mapping
JOIN manual_inventory mi ON mi.sha256 = mapping.sha
JOIN sources s ON s.manual_inventory_id = mi.id;
