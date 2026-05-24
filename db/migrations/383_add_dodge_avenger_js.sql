-- mig 383: ADD Dodge Avenger JS (2nd gen, 2008-2014) — midsize sedan
--
-- Sister to Chrysler 200 (1st gen LX, NOT yet in our DB) and platform mate to
-- Dodge Journey JC. All three on Chrysler GS platform (FCA midsize).
-- Discontinued end of 2014 — Sterling Heights plant repurposed for Chrysler 200
-- 2nd gen.
--
-- 2013 OM lists only 2.4L World + 3.6L Pentastar (the earlier 2.7L EER and 3.5L
-- EGG V6 variants from 2008-2010 had been retired by 2011). Earlier-year coverage
-- could come from a 2008-2010 OM as supplementary mig.
--
-- Source: Mopar Dodge Avenger 2013 OM (PDF 293, 516 pages). public_link=1.

SET @make_dodge := 35;
SET @e_24world := (SELECT id FROM engines WHERE code='2.4 World ED');
SET @e_pentastar := 138;

-- 1. ADD model
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'avenger', 'Avenger', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='avenger');

SET @m_avenger := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='avenger');

-- 2. ADD generation
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_avenger, 'avenger-js-sedan-2008-2014', 2, 'JS',
       'chrysler-gs-platform-2007-2020', 'Chrysler GS Platform',
       'Avenger (JS, 2nd gen)', 'sedan', 2008, 2014,
       'FWD', 4860, 1820, 1457, 2766,
       64.0,
       'MacPherson strut independent', 'Multi-link independent',
       'Ventilated disc 11.6 in', 'Solid disc 11.0 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_avenger AND g.slug='avenger-js-sedan-2008-2014'
);

SET @g_js := (SELECT id FROM generations WHERE model_id=@m_avenger AND slug='avenger-js-sedan-2008-2014');

-- 3. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_js, 'se-2-4-i4-4at',  '2.4 World SE/SXT (173 Hp) FWD 4AT', @e_24world,  173),
  (@g_js, 'se-2-4-i4-6at',  '2.4 World SE/SXT (173 Hp) FWD 6AT', @e_24world,  173),
  (@g_js, 'rt-3-6-v6-6at',  '3.6 Pentastar R/T (283 Hp) FWD 6AT', @e_pentastar, 283);

-- 4. fluid_specs — Mopar Avenger 2013 OM page 472

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_js, @e_24world, 'engine_oil', 4.26, 4.5, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '2.4L World Engine (173 hp): 4.26 L (4.5 qt) with filter, SAE 5W-20 per Mopar Avenger 2013 OM p.472. Same engine + capacity as Journey JC 2.4L.'),
  (@g_js, @e_pentastar, 'engine_oil', 5.6, 6.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '3.6L Pentastar V6 (283 hp, replaces earlier 3.5L EGG in 2011): 5.6 L (6 qt) with filter, SAE 5W-20 per Mopar Avenger 2013 OM p.472.');

-- Cooling per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_js, @e_24world, 'coolant', 7.3, 7.7, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L World Engine cooling: 7.3 L (7.7 qt) per Mopar Avenger 2013 OM p.472.'),
  (@g_js, @e_pentastar, 'coolant', 11.0, 11.6, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar V6 cooling: 11.0 L (11.6 qt) per Mopar Avenger 2013 OM p.472. Smaller than Charger LX 3.6L cooling because Avenger is FWD-only (no AWD package).');

-- Chassis fluids (Mopar OM 2013 p.473-474)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_js, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Avenger 2013 OM p.473-474.'),
  (@g_js, 'transmission_at', 'Mopar ATF+4',
   '4-speed automatic (2.4L 2008-2010) or 6-speed Aisin AW (2.4L + 3.6L from 2011). All use ATF+4 per Mopar Avenger 2013 OM p.473.'),
  (@g_js, 'power_steering', 'Mopar Power Steering Fluid +4 or Mopar ATF+4',
   'Hydraulic power steering (no EPS). Mopar PSF+4 or ATF+4 per Mopar Avenger 2013 OM p.473.'),
  (@g_js, 'ac_refrigerant', 'R-134a; see under-hood A/C label',
   'A/C refrigerant — Avenger uses R-134a (pre-Stellantis R-1234yf transition). Charge per under-hood label ~0.59 kg (590 g).'),
  (@g_js, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.5 L typical midsize sedan.');

-- 5. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Avenger_JS_2013_OM_Mopar.pdf',
   'dfd772de2dc2895f24b5e9c38f66528616bb8d5c81d7b432a08d306a57a013ad',
   'owner', 'Dodge', 'Avenger', 2013, 2013,
   '293', NULL, NULL,
   'en-US', 'US', 516,
   'Dodge Avenger Owner''s Manual', NOW(),
   'Mopar Dodge Avenger 2013 OM. Covers SE/SXT/R/T trims + 2.4L World and 3.6L Pentastar. FLUID CAPACITIES p.472.');

SET @mi_avenger := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual', 'Dodge Avenger (JS) 2013 Owner''s Manual', NULL, @mi_avenger, 1, 1, NOW(),
   'OEM Owner''s Manual; covers post-facelift 2013 Avenger (final year was 2014). Earlier-year engines (2.7L EER + 3.5L EGG V6, 2008-2010) not covered.');

SET @s_avenger_om := LAST_INSERT_ID();

-- 6. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_js, NULL, NULL, '/images/dodge/avenger-js-sedan-2008-2014/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Mr.choppers / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2013_Dodge_Avenger_SE_in_Bright_White,_front_left.jpg',
   '2026-05-25', '2013 Dodge Avenger SE', '3-4-front', 1280, 740);

-- 7. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_avenger_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_js;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_js, @s_avenger_om);
