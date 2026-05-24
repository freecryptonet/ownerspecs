-- mig 373: ADD Dodge Challenger LC (3rd gen, 2008-2023) — new model + generation
--
-- Sister to Charger LD (gen 122) — same LC/LX/LD-derived platform, mostly identical
-- engine + chassis hardware. Available in 4 main powertrain variants over the gen's
-- 16-year run: 3.6L Pentastar V6 (SXT base, 2011+), 5.7L HEMI V8 (R/T), 6.4L HEMI 392
-- (Scat Pack from 2015), 6.2L Hellcat Supercharged V8 (SRT Hellcat from 2015,
-- Demon 2018 limited, Redeye from 2019). Also: 3.5L EGG V6 + 6.1L SRT8 in 2008-2010.
--
-- Source: Mopar Dodge Challenger 2017 OM (PDF 2120, downloaded). public_link=1.

SET @make_dodge := 35;
SET @e_pentastar := 138;
SET @e_57hemi := 166;
SET @e_64hemi := 167;
SET @e_62hellcat := 168;

-- 1. ADD model: Dodge Challenger
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'challenger', 'Challenger', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='challenger');

SET @m_challenger := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='challenger');

-- 2. ADD generation: Challenger LC 3rd gen (2008-2023)
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_challenger, 'challenger-lc-coupe-2008-2023', 3, 'LC',
       'dodge-lx-platform-2005-2023', 'LX/LD/LC Platform',
       'Challenger (LC, 3rd gen)', 'coupe', 2008, 2023,
       'RWD', 5022, 1923, 1448, 2946,
       70.0,
       'SLA short-long arm independent', 'Multi-link independent',
       'Ventilated disc 14.2 in (SRT 15.4 in Brembo)',
       'Ventilated disc 13.8 in (SRT 13.8 in Brembo 4-piston)'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_challenger AND g.slug='challenger-lc-coupe-2008-2023'
);

SET @g_lc := (SELECT id FROM generations WHERE model_id=@m_challenger AND slug='challenger-lc-coupe-2008-2023');

-- 3. ADD trims (4 major powertrain variants, post-2011 facelift era)
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_lc, 'sxt-3-6-v6-8at',         '3.6 Pentastar V6 SXT (305 Hp) RWD 8AT',            @e_pentastar, 305),
  (@g_lc, 'rt-5-7-hemi-8at',        '5.7 HEMI V8 R/T (372 Hp) RWD 8AT',                 @e_57hemi, 372),
  (@g_lc, 'scat-pack-6-4-392-8at',  '6.4 HEMI 392 Scat Pack (485 Hp) RWD 8AT',          @e_64hemi, 485),
  (@g_lc, 'srt-hellcat-6-2-sc-8at', '6.2 Hellcat Supercharged SRT (707-807 Hp) RWD 8AT', @e_62hellcat, 707);

-- 4. ADD fluid_specs from Mopar Challenger 2017 OM pages 474-477

-- Engine oil per engine (verified from Mopar 2017 OM)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_lc, @e_pentastar, 'engine_oil', 5.6, 6.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '3.6L Pentastar V6 SXT (RWD/AWD): 5.6 L (6 qt) with filter, SAE 5W-20 per Mopar Challenger 2017 OM p.474. Same engine block as Charger LD V6 trims.'),
  (@g_lc, @e_57hemi, 'engine_oil', 6.6, 7.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '5.7L HEMI V8 R/T (372-375 hp): 6.6 L (7 qt) with filter, SAE 5W-20 per Mopar Challenger 2017 OM p.475-476. Identical spec for automatic and manual transmission variants.'),
  (@g_lc, @e_64hemi, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.4L HEMI 392 Scat Pack (485 hp): 6.6 L (7 qt) with filter, SAE 0W-40 synthetic per Mopar Challenger 2017 OM p.477. Mandatory full synthetic.'),
  (@g_lc, @e_62hellcat, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.2L Hellcat Supercharged V8 (SRT Hellcat 707-807 hp, Redeye 797 hp 2019+): 6.6 L (7 qt) with filter, SAE 0W-40 full synthetic. Per Mopar Hellcat supplement. Demon 2018 same spec.');

-- Cooling system per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_lc, @e_pentastar, 'coolant', 10.5, 11.1, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar cooling: 10.5 L (11.1 qt) per Mopar Challenger 2017 OM p.474. Mopar OAT (orange) — distinct from older LX-era HOAT.'),
  (@g_lc, @e_57hemi, 'coolant', 13.9, 14.7, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI V8 cooling: 13.9 L (14.7 qt) per Mopar Challenger 2017 OM p.475-476. Severe Duty II Cooling Package optional adds ~0.4 L.'),
  (@g_lc, @e_64hemi, 'coolant', 14.4, 15.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.4L HEMI 392 cooling: 14.4 L (15 qt) per Mopar Challenger 2017 OM p.477.'),
  (@g_lc, @e_62hellcat, 'coolant', 14.4, 15.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.2L Hellcat SC main cooling loop: ~14.4 L per Mopar Hellcat supplement. Supercharger intercooler is a separate ~7 L loop (dealer-only service, low-temp loop).');

-- Chassis fluids (Mopar 2017 OM p.503-504 chassis section)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_lc, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar OM 2017 p.503. Replace 2 yr per Mopar maintenance schedule.'),
  (@g_lc, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   'ZF 8HP70 8-speed automatic (Pentastar + R/T 5.7) / ZF 8HP90 (392 Scat Pack + Hellcat). Total fill ~9.5 L; drain-and-refill 4-5 L. FCA labels lifetime; recommend service at 60-100k mi.'),
  (@g_lc, 'transmission_mt', 'Mopar Manual Transmission Fluid (MS-9417 or equivalent)',
   'Tremec TR-6060 6-speed manual (R/T + SRT 6.4 + Hellcat manual trims, 2008-2023). Capacity ~2.6 L per typical Tremec spec. Unique to Challenger — Charger LD did not offer manual transmission.'),
  (@g_lc, 'differential_rear', 'Mopar OD Synthetic 75W-85 GL-5 (V6/5.7) or LSD 75W-85 (392/Hellcat)',
   'Rear axle (RWD): 75W-85 GL-5 per Mopar OM 2017 p.503-504. SRT 392 and Hellcat use Limited-Slip variant with friction modifier. Capacity not in OM (~1.5 L typical).'),
  (@g_lc, 'differential_front', 'Mopar Synthetic Gear Lubricant SAE 75W-90 (API GL-5)',
   'Front axle (AWD V6 trims 2017+ only): Mopar 75W-90 GL-5 per Mopar OM 2017 p.503. Capacity not in OM.'),
  (@g_lc, 'transfer_case', 'Mopar Transfer Case Lubricant for BorgWarner 44-40',
   'AWD trims only (V6 Pentastar AWD added 2017-2023). BorgWarner 44-40 transfer case per Mopar OM 2017 p.503.'),
  (@g_lc, 'ac_refrigerant', 'R-134a (pre-2019) / R-1234yf (2019+); see under-hood A/C label',
   'A/C refrigerant — 2008-2018 LC uses R-134a ~0.74 kg; 2019+ transitioned to R-1234yf ~0.85 kg. Charge per under-hood label.'),
  (@g_lc, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir; capacity not in Mopar OM ~3.8 L typical Stellantis full-size.');

-- 5. Add Mopar Challenger 2017 OM to manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Challenger_LC_2017_OM_Mopar.pdf',
   '87733075c0133a9557b368e0a746c22a5a23cab7a05bce33dd8c48c184814c5f',
   'owner', 'Dodge', 'Challenger', 2017, 2017,
   '2120', NULL, NULL,
   'en-US', 'US', 523,
   'Dodge Challenger Owner''s Manual', NOW(),
   'Mopar Dodge Challenger (LC) 2017 model-year OM. Covers SXT/R/T/Scat Pack/SRT Hellcat per per-engine fluid pages 474-477.');

SET @mi_chal := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Dodge Challenger (LC) 2017 Owner''s Manual',
   NULL, @mi_chal, 1, 1, NOW(),
   'OEM Owner''s Manual; covers 2017 Challenger SXT/R/T/Scat Pack/SRT lineup. Pages 474-477 per-engine fluid capacities; pages 503-504 chassis fluids.');

SET @s_chal_om := LAST_INSERT_ID();

-- 6. ADD hero image
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_lc, NULL, NULL, '/images/dodge/challenger-lc-coupe-2008-2023/hero.jpg',
   'wikimedia', 'CC BY-SA 2.0',
   'Greg Gjerdingen / Wikimedia Commons, CC BY-SA 2.0',
   'https://commons.wikimedia.org/wiki/File:2014_Dodge_Challenger_SRT_%2827763434034%29.jpg',
   '2026-05-25', '2014 Dodge Challenger SRT', '3-4-front', 1280, 853);

-- 7. Cite all new fluid rows to Mopar Challenger OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_chal_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_lc;

-- 8. Cite the generation row itself to the Mopar OM (for dims + fuel-tank)
INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_lc, @s_chal_om);
