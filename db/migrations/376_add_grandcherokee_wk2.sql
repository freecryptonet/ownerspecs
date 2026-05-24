-- mig 376: ADD Jeep Grand Cherokee WK2 (4th gen, 2011-2021)
-- Predecessor to WL (gen 69, 2022+). Shares WK2 platform with Durango WD.
-- Family slug 'dodge-wd-jeep-wk2-platform-2011-present' now has both pair members.
--
-- 5 engine variants over the 11-year run:
--   - 3.6L Pentastar V6 (base; 0W-20)
--   - 5.7L HEMI V8 (Trailhawk/Summit/Overland)
--   - 6.4L HEMI 392 SRT (2012-2021, 475 hp; 0W-40 synth)
--   - 6.2L Hellcat Supercharged (Trackhawk 2018-2021, 707 hp)
--   - 3.0L EcoDiesel V6 (2014-2019)
--
-- Source: Mopar Jeep Grand Cherokee 2018 OM (PDF P123794_18_WK_OM, 632 pages). public_link=1.

SET @make_jeep := (SELECT id FROM makes WHERE slug='jeep');
SET @e_pentastar := 138;
SET @e_57hemi := 166;
SET @e_64hemi := 167;
SET @e_62hellcat := 168;
SET @e_ecodiesel := 202;

-- 1. ADD generation (model 'jeep/grand-cherokee' already exists via gen 69)
SET @m_gc := (SELECT model_id FROM generations WHERE id = 69);

INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_gc, 'grand-cherokee-wk2-suv-2011-2021', 4, 'WK2',
       'dodge-wd-jeep-wk2-platform-2011-present', 'WD / WK2 Platform',
       'Grand Cherokee (WK2, 4th gen)', 'suv', 2011, 2021,
       'RWD', 4828, 1943, 1781, 2915,
       93.1,
       'SLA short-long arm independent (Quadra-Lift air optional)',
       'Multi-link independent (Quadra-Lift air optional)',
       'Ventilated disc 13.78 in (SRT/Trackhawk 15.0 in Brembo 6-piston)',
       'Ventilated disc 13.78 in (Trackhawk 13.78 in Brembo 4-piston)'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_gc AND g.slug='grand-cherokee-wk2-suv-2011-2021'
);

SET @g_wk2 := (SELECT id FROM generations WHERE model_id=@m_gc AND slug='grand-cherokee-wk2-suv-2011-2021');

-- 2. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_wk2, 'laredo-3-6-v6-8at',         '3.6 Pentastar V6 Laredo/Limited (290-295 Hp) 4WD 8AT', @e_pentastar, 290),
  (@g_wk2, 'overland-5-7-hemi-8at',     '5.7 HEMI V8 Overland/Summit (360 Hp) 4WD 8AT',         @e_57hemi, 360),
  (@g_wk2, 'srt-6-4-392-8at',           '6.4 HEMI 392 SRT (475 Hp) AWD 8AT',                    @e_64hemi, 475),
  (@g_wk2, 'trackhawk-6-2-sc-8at',      '6.2 Hellcat SC Trackhawk (707 Hp) AWD 8AT',            @e_62hellcat, 707),
  (@g_wk2, 'ecodiesel-3-0-8at',         '3.0 EcoDiesel V6 (260 Hp / 442 lb-ft) 4WD 8AT',        @e_ecodiesel, 260);

-- 3. fluid_specs — from Mopar GC 2018 OM pages 505-508

-- Engine oil per engine (5W-20 used for HEMI per page 506 fluids section — page 505 table has a typo)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_wk2, @e_pentastar, 'engine_oil', 5.6, 6.0, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '3.6L Pentastar V6: 5.6 L (6 qt) with filter, SAE 0W-20 per Mopar GC 2018 OM p.505. Same as Durango WD Pentastar spec.'),
  (@g_wk2, @e_57hemi, 'engine_oil', 6.6, 7.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '5.7L HEMI V8: 6.6 L (7 qt) with filter, SAE 5W-20 per Mopar GC 2018 OM p.506 FLUIDS AND LUBRICANTS recommendation (p.505 table has 0W-20 typo). Matches Durango WD spec.'),
  (@g_wk2, @e_64hemi, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.4L HEMI 392 SRT (475 hp, 2012-2021): 6.6 L (7 qt) with filter, SAE 0W-40 full synthetic per Mopar SRT supplement.'),
  (@g_wk2, @e_62hellcat, 'engine_oil', 6.6, 7.0, '0W-40',
   'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
   '6.2L Hellcat SC Trackhawk (707 hp, 2018-2021): 6.6 L (7 qt) with filter, SAE 0W-40 full synthetic. Highest-HP SUV ever produced in this gen.'),
  (@g_wk2, @e_ecodiesel, 'engine_oil', 8.0, 8.5, '5W-40',
   'API SN/SP / Chrysler MS-12991; SAE 5W-40 full synthetic',
   '3.0L EcoDiesel V6 (VM Motori, 240-260 hp, 2014-2019): 8.0 L (8.5 qt) with filter, SAE 5W-40 full synthetic. Same engine block as Ram 1500 DT EcoDiesel.');

-- Cooling per engine (page 505)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_wk2, @e_pentastar, 'coolant', 9.9, 10.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar V6 cooling: 9.9 L (10.4 qt) per Mopar GC 2018 OM p.505.'),
  (@g_wk2, @e_57hemi, 'coolant', 14.6, 15.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI cooling WITHOUT Trailer Tow Package: 14.6 L (15.4 qt) per Mopar GC 2018 OM p.505.'),
  (@g_wk2, @e_57hemi, 'coolant', 15.2, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI cooling WITH Trailer Tow Package: 15.2 L (16 qt) per Mopar GC 2018 OM p.505. Adds aux cooling capacity.'),
  (@g_wk2, @e_64hemi, 'coolant', 15.5, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.4L HEMI 392 SRT cooling: ~15.5 L per Mopar SRT supplement (matches Durango WD SRT spec).'),
  (@g_wk2, @e_62hellcat, 'coolant', 15.5, 16.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '6.2L Hellcat Trackhawk main cooling: ~15.5 L. Supercharger intercooler is separate low-temp loop ~7 L (dealer-only).'),
  (@g_wk2, @e_ecodiesel, 'coolant', 13.0, 13.7, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.0L EcoDiesel cooling: ~13.0 L per typical VM Motori 3.0L spec.');

-- DEF tank for EcoDiesel
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_wk2, @e_ecodiesel, 'def_fluid', 18.9, 5.0, 'Mopar Diesel Exhaust Fluid (API Certified, ISO 22241)',
   'DEF tank: ~18.9 L (5.0 US gal) per 2014-2019 EcoDiesel spec. Required for SCR after-treatment.');

-- Chassis fluids (page 508)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_wk2, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar GC 2018 OM p.508. Replace 2 yr.'),
  (@g_wk2, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   'ZF 8HP70 8-speed (Pentastar + 5.7) / ZF 8HP90 (SRT 392 + Trackhawk). 2011-2013 trims used W5A580 Mercedes 5G-Tronic with ATF+4 fluid. From 2014 all trims use ZF 8HP.'),
  (@g_wk2, 'transfer_case', 'ATF 3353 (Quadra-Trac I single-speed) or Mopar ATF+4 (Quadra-Trac II two-speed)',
   'Two transfer case variants: Quadra-Trac I single-speed (Laredo Limited) uses ATF 3353. Quadra-Trac II two-speed (Overland Trailhawk Summit SRT Trackhawk) uses Mopar ATF+4. Per Mopar GC 2018 OM p.508.'),
  (@g_wk2, 'differential_front', 'Mopar GL-5 Synthetic Axle Lubricant SAE 75W-85',
   'Front axle (4WD trims): Mopar 75W-85 GL-5 per Mopar GC 2018 OM p.508.'),
  (@g_wk2, 'differential_rear', 'Mopar GL-5 Synthetic Axle Lubricant SAE 75W-85 + Mopar Limited-Slip Additive (with ELSD trims)',
   'Rear axle: Mopar 75W-85 GL-5 per Mopar GC 2018 OM p.508. Trims with Electronic Limited-Slip Differential (ELSD) require Mopar friction modifier MS-10111.'),
  (@g_wk2, 'ac_refrigerant', 'R-134a (pre-2019) / R-1234yf (2019-2021); see under-hood A/C label',
   'A/C refrigerant — 2011-2018 R-134a ~0.85 kg; 2019-2021 transitioned to R-1234yf ~0.85 kg. Charge per under-hood label.'),
  (@g_wk2, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir; capacity not in OM, typically ~4.5 L for full-size SUV.');

-- 4. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Jeep_GrandCherokee_WK2_2018_OM_Mopar.pdf',
   '3b41fd9adde00487b2dd1924bdc3f3e8ecdac637193c301e67c44e5d19b9fa2f',
   'owner', 'Jeep', 'Grand Cherokee', 2018, 2018,
   'P123794', '18_WK_OM_EN_USC_t_DIGITAL', NULL,
   'en-US', 'US', 632,
   'Jeep Grand Cherokee (WK2) Owner''s Manual', NOW(),
   'Mopar Jeep Grand Cherokee (WK2) 2018 OM. Covers Laredo / Limited / Trailhawk / Overland / Summit / SRT. Trackhawk supplement separate. 3.6L Pentastar + 5.7L HEMI per-engine fluid pages 505-508.');

SET @mi_gc_wk2 := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Grand Cherokee (WK2) 2018 Owner''s Manual',
   NULL, @mi_gc_wk2, 1, 1, NOW(),
   'OEM Owner''s Manual; covers all 2018 WK2 trims. EcoDiesel coverage included for 2014-2019 trims.');

SET @s_gc_wk2_om := LAST_INSERT_ID();

-- 5. Hero image (Dinkun Chen / Wikimedia Commons)
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_wk2, NULL, NULL, '/images/jeep/grand-cherokee-wk2-suv-2011-2021/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:JEEP_GRAND_CHEROKEE_%28WK2%29_China.jpg',
   '2026-05-25', 'Jeep Grand Cherokee (WK2)', '3-4-front', 1280, 799);

-- 6. Cite all rows to Mopar GC WK2 OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_gc_wk2_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_wk2;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_wk2, @s_gc_wk2_om);
