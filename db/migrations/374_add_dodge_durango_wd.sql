-- mig 374: ADD Dodge Durango WD (3rd gen, 2011-present) — 3-row SUV
--
-- Shares WK2 unibody platform with Jeep Grand Cherokee WK2 (2011-2021).
-- 4 engine families across the gen:
--   - 3.6L Pentastar V6 (base, 2011+; SAE 0W-20 differs from Charger LD's 5W-20)
--   - 5.7L HEMI V8 (R/T, Citadel)
--   - 6.4L SRT8 392 V8 (2018+ SRT trim, 475 hp)
--   - 6.2L Hellcat Supercharged V8 (2021 limited + 2024+ SRT Hellcat)
--
-- Source: Mopar Dodge Durango 2020 OM (PDF P136150_20_WD_OM, 356 pages). public_link=1.

SET @make_dodge := 35;
SET @e_pentastar := 138;
SET @e_57hemi := 166;
SET @e_64hemi := 167;
SET @e_62hellcat := 168;

-- 1. ADD model: Dodge Durango
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'durango', 'Durango', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='durango');

SET @m_durango := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='durango');

-- 2. ADD generation: Durango WD 3rd gen (2011-present, still in production)
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_durango, 'durango-wd-suv-2011-present', 3, 'WD',
       'dodge-wd-jeep-wk2-platform-2011-present', 'WD / WK2 Platform',
       'Durango (WD, 3rd gen)', 'suv', 2011, NULL,
       'RWD', 5113, 1924, 1809, 3043,
       93.0,
       'SLA independent', 'Multi-link independent',
       'Ventilated disc 13.78 in (SRT 15.0 in Brembo 6-piston)',
       'Ventilated disc 13.78 in (SRT 13.78 in Brembo 4-piston)'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_durango AND g.slug='durango-wd-suv-2011-present'
);

SET @g_wd := (SELECT id FROM generations WHERE model_id=@m_durango AND slug='durango-wd-suv-2011-present');

-- 3. ADD trims (4 powertrain variants)
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_wd, 'sxt-3-6-v6-8at',         '3.6 Pentastar V6 SXT/GT (295-360 Hp) RWD/AWD 8AT', @e_pentastar, 295),
  (@g_wd, 'rt-5-7-hemi-8at',        '5.7 HEMI V8 R/T (360-370 Hp) RWD/AWD 8AT',         @e_57hemi, 360),
  (@g_wd, 'srt-6-4-392-8at',        '6.4 HEMI 392 SRT (475 Hp) AWD 8AT',                @e_64hemi, 475),
  (@g_wd, 'srt-hellcat-6-2-sc-8at', '6.2 Hellcat Supercharged SRT (710 Hp) AWD 8AT',    @e_62hellcat, 710);

-- 4. fluid_specs — from Mopar Durango 2020 OM pages 271-273

-- Engine oil per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_wd, @e_pentastar, 'engine_oil', 5.6, 6.0, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '3.6L Pentastar V6: 5.6 L (6 qt) with filter, SAE 0W-20 per Mopar Durango 2020 OM p.271. Note: Durango Pentastar spec is 0W-20, distinct from Charger LD Pentastar 5W-20.'),
  (@g_wd, @e_57hemi, 'engine_oil', 6.6, 7.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '5.7L HEMI V8 R/T: 6.6 L (7 qt) with filter, SAE 5W-20 per Mopar Durango 2020 OM p.271.'),
  (@g_wd, @e_64hemi, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.4L HEMI 392 SRT (475 hp): 6.6 L (7 qt) with filter, SAE 0W-40 full synthetic per Mopar Durango 2020 OM p.272.'),
  (@g_wd, @e_62hellcat, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.2L Hellcat Supercharged SRT (710 hp, 2021 limited + 2024+ Hellcat trim): 6.6 L (7 qt) with filter, SAE 0W-40 full synthetic. Per Mopar Hellcat supplement.');

-- Cooling system per engine (with/without Trailer Tow Package variants for Pentastar + HEMI)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_wd, @e_pentastar, 'coolant', 9.9, 10.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar cooling WITHOUT Trailer Tow Package: 9.9 L (10.4 qt) per Mopar Durango 2020 OM p.271.'),
  (@g_wd, @e_pentastar, 'coolant', 10.4, 11.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar cooling WITH Trailer Tow Package: 10.4 L (11 qt) per Mopar Durango 2020 OM p.271. Adds aux cooling capacity.'),
  (@g_wd, @e_57hemi, 'coolant', 14.6, 15.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI cooling WITHOUT Trailer Tow Package: 14.6 L (15.4 qt) per Mopar Durango 2020 OM p.271.'),
  (@g_wd, @e_57hemi, 'coolant', 15.2, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI cooling WITH Trailer Tow Package: 15.2 L (16 qt) per Mopar Durango 2020 OM p.271.'),
  (@g_wd, @e_64hemi, 'coolant', 15.5, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.4L HEMI 392 SRT cooling: 15.5 L (16 qt) per Mopar Durango 2020 OM p.272.'),
  (@g_wd, @e_62hellcat, 'coolant', 15.5, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.2L Hellcat SC cooling main loop: ~15.5 L per Mopar Hellcat supplement. Supercharger intercooler is a separate low-temp loop (~7 L, dealer-only service).');

-- Chassis fluids (Mopar OM 2020 p.273)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_wd, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar OM 2020 p.273. Replace 2 yr.'),
  (@g_wd, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   'ZF 8HP70 8-speed (Pentastar + 5.7 HEMI) / ZF 8HP90 (SRT 392 + Hellcat). Total fill ~9.5 L; drain-refill 4-5 L. Per Mopar OM 2020 p.273.'),
  (@g_wd, 'transfer_case', 'Shell ATF (3.6L NV241 single-speed) or Mopar ATF+4 (5.7L NV245 Quadra-Trac II)',
   'AWD trims only. 3.6L uses NV241 single-speed transfer case (Shell ATF). 5.7L + SRT use NV245 Quadra-Trac II 2-speed (ATF+4). Per Mopar OM 2020 p.273.'),
  (@g_wd, 'differential_front', 'Mopar GL-5 Synthetic Axle Lubricant SAE 75W-85',
   'Front axle (AWD only): Mopar 75W-85 GL-5 per Mopar OM 2020 p.273. Note Durango uses lighter 75W-85 viscosity vs LC Challenger front (75W-90).'),
  (@g_wd, 'differential_rear', 'Mopar GL-5 Synthetic Axle Lubricant SAE 75W-85',
   'Rear axle: Mopar 75W-85 GL-5 per Mopar OM 2020 p.273. LSD variants on SRT trims add Mopar Limited-Slip Additive (MS-10111).'),
  (@g_wd, 'ac_refrigerant', 'R-134a (pre-2019) / R-1234yf (2019+); see under-hood A/C label',
   'A/C refrigerant — 2011-2018 uses R-134a ~0.78 kg; 2019+ R-1234yf ~0.85 kg. Charge per under-hood label.'),
  (@g_wd, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir; capacity not in Mopar OM ~4.5 L typical for full-size SUV.');

-- 5. Add Mopar Durango 2020 OM to manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Durango_WD_2020_OM_Mopar.pdf',
   '223c6ec9698a88356f421413bdde68e319149f40592400495800849cc59c086e',
   'owner', 'Dodge', 'Durango', 2020, 2020,
   'P136150', '20_WD_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', 356,
   'Dodge Durango Owner''s Manual', NOW(),
   'Mopar Dodge Durango (WD) 2020 OM. Splits FLUID CAPACITIES into Non-SRT (p.271) and SRT (p.272) sections. Pentastar viscosity is 0W-20 in Durango (distinct from Charger LD 5W-20).');

SET @mi_dur := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Dodge Durango (WD) 2020 Owner''s Manual',
   NULL, @mi_dur, 1, 1, NOW(),
   'OEM Owner''s Manual; covers 2020 Durango SXT/GT/R/T/SRT 392. Hellcat coverage via Hellcat supplement.');

SET @s_dur_om := LAST_INSERT_ID();

-- 6. Hero image (Charles / Wikimedia Commons CC BY-SA 2.0)
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_wd, NULL, NULL, '/images/dodge/durango-wd-suv-2011-present/hero.jpg',
   'wikimedia', 'CC BY-SA 2.0',
   'Charles from Port Chester, New York / Wikimedia Commons, CC BY-SA 2.0',
   'https://commons.wikimedia.org/wiki/File:Dodge_Durango_SRT_392_%282021%29_%2853769964552%29.jpg',
   '2026-05-25', '2021 Dodge Durango SRT 392', '3-4-front', 1280, 853);

-- 7. Cite all new fluid rows + gen row to Mopar Durango OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_dur_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_wd;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_wd, @s_dur_om);
