-- mig 377b: fix-up after mig 377 hit varchar(96) overflow on transfer_case spec_standard.
-- Remaining items: chassis fluids (brake, transmission_at, transfer_case, diffs, AC, washer),
-- manual_inventory, sources, hero image, citations.

SET @g_kl := (SELECT id FROM generations WHERE slug='cherokee-kl-suv-2014-2023');

-- Chassis fluids (with shorter spec_standard strings)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_kl, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Cherokee 2020 OM p.276.'),
  (@g_kl, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   'ZF 9HP48 9-speed automatic (948TE on V6 / 2.0T variants). First Stellantis 9HP application. Per Mopar Cherokee 2020 OM p.276.'),
  (@g_kl, 'transfer_case', 'Mopar ATF+4 (Active Drive I/II) or Mopar TC Lubricant (Trailhawk Lock)',
   'AWD trims: Active Drive I (single-speed PTU, Sport/Latitude) and Active Drive II (Limited/Overland) use ATF+4. Active Drive Lock (Trailhawk, 56:1 crawl ratio) uses Mopar TC Lubricant.'),
  (@g_kl, 'front_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant',
   'Front differential / PTU (AWD trims): Mopar 75W-85 GL-5. Capacity not in OM.'),
  (@g_kl, 'rear_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant',
   'Rear differential (AWD trims; FWD trims have none). Mopar 75W-85 GL-5 per typical FCA spec.'),
  (@g_kl, 'ac_refrigerant', 'R-134a (2014-2018) / R-1234yf (2019-2023); see A/C label',
   'A/C refrigerant — 2014-2018 R-134a; 2019+ R-1234yf. Charge per under-hood label ~0.59 kg (590 g).'),
  (@g_kl, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.5 L typical compact SUV.');

-- manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Jeep_Cherokee_KL_2020_OM_Mopar.pdf',
   '2908356ba72459f697783980f846b65744b9e407fc9cbb6da097a176df98823f',
   'owner', 'Jeep', 'Cherokee', 2020, 2020,
   'P136176', '20_KL_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', 364,
   'Jeep Cherokee Owner''s Manual', NOW(),
   'Mopar Jeep Cherokee (KL) 2020 OM. 3 engines (2.4 Tigershark / 2.0 Hurricane turbo / 3.2 Pentastar). FLUID CAPACITIES p.274.');

SET @mi_kl := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Cherokee (KL) 2020 Owner''s Manual',
   NULL, @mi_kl, 1, 1, NOW(),
   'OEM Owner''s Manual; covers all 2020 KL Cherokee trims + 3 engines.');

SET @s_kl_om := LAST_INSERT_ID();

-- Hero image
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_kl, NULL, NULL, '/images/jeep/cherokee-kl-suv-2014-2023/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2019_Jeep_Cherokee_Latitude_front_5.27.18.jpg',
   '2026-05-25', '2019 Jeep Cherokee Latitude', '3-4-front', 1280, 799);

-- Cite all fluid rows (including the 6 already-inserted) + gen to Mopar Cherokee OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_kl_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_kl;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_kl, @s_kl_om);
