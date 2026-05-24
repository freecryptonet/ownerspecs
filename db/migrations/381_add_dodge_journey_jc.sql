-- mig 381: ADD Dodge Journey JC (1st gen, 2009-2020) — midsize 3-row crossover
--
-- Long-running platform mate to Dodge Avenger/Chrysler 200 (GS platform). Two main
-- engines in 2018 OM:
--   - 2.4L World Engine (Tigershark predecessor; ED3/ED4 codes) — base FWD, 4-speed
--     auto early then 6-speed Aisin. NEW engine added.
--   - 3.6L Pentastar V6 (2011+, replaced earlier 3.5L EGG V6 from 2009-2010) —
--     engine 138 reused.
--
-- Source: Mopar Dodge Journey 2018 OM (PDF 9184, 508 pages). public_link=1.

SET @make_dodge := 35;
SET @e_pentastar := 138;

-- 1. ADD engine: 2.4L World Engine
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('2.4 World ED', 'Chrysler 2.4L World Engine I4 NA (ED-series, Journey/Avenger)', 2360, 'gasoline', 'na', 4, 88.0, 97.0, 10.5);

SET @e_24world := (SELECT id FROM engines WHERE code='2.4 World ED');

-- 2. ADD model: Dodge Journey
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'journey', 'Journey', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='journey');

SET @m_journey := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='journey');

-- 3. ADD generation
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_journey, 'journey-jc-suv-2009-2020', 1, 'JC',
       'chrysler-gs-platform-2007-2020', 'Chrysler GS / JC Platform',
       'Journey (JC, 1st gen)', 'suv', 2009, 2020,
       'FWD', 4889, 1879, 1696, 2891,
       77.6,
       'MacPherson strut independent', 'Multi-link independent',
       'Ventilated disc 11.85 in', 'Solid disc 12.0 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_journey AND g.slug='journey-jc-suv-2009-2020'
);

SET @g_jc := (SELECT id FROM generations WHERE model_id=@m_journey AND slug='journey-jc-suv-2009-2020');

-- 4. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_jc, 'se-2-4-i4-fwd-6at',  '2.4 World SE Sport/Crossroad FWD (173 Hp) 4AT/6AT', @e_24world, 173),
  (@g_jc, 'crossroad-3-6-v6-fwd-6at',  '3.6 Pentastar V6 Crossroad/GT FWD (283 Hp) 6AT', @e_pentastar, 283),
  (@g_jc, 'crossroad-3-6-v6-awd-6at',  '3.6 Pentastar V6 Crossroad/GT AWD (283 Hp) 6AT', @e_pentastar, 283);

-- 5. fluid_specs — Mopar Journey 2018 OM page 367

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_jc, @e_24world, 'engine_oil', 4.26, 4.5, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '2.4L World Engine (ED-series, 173 hp): 4.26 L (4.5 qt) with filter, SAE 5W-20 per Mopar Journey 2018 OM p.367. Same engine block as Dodge Avenger / Chrysler 200 LX.'),
  (@g_jc, @e_pentastar, 'engine_oil', 5.6, 6.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '3.6L Pentastar V6 (283 hp, replaces earlier 3.5L EGG in 2009-2010): 5.6 L (6 qt) with filter, SAE 5W-20 per Mopar Journey 2018 OM p.367.');

-- Cooling per engine + climate config
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_jc, @e_24world, 'coolant', 7.5, 8.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L World Engine cooling with Single/Dual-Zone Climate Control: 7.5 L (8 qt) per Mopar Journey 2018 OM p.367.'),
  (@g_jc, @e_24world, 'coolant', 9.5, 10.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L World Engine cooling with Three-Zone Climate Control: 9.5 L (10 qt) per Mopar Journey 2018 OM p.367.'),
  (@g_jc, @e_pentastar, 'coolant', 12.4, 13.1, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar V6 cooling with Single/Dual-Zone Climate Control: 12.4 L (13.1 qt) per Mopar Journey 2018 OM p.367.'),
  (@g_jc, @e_pentastar, 'coolant', 13.7, 14.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar V6 cooling with Three-Zone Climate Control: 13.7 L (14.5 qt) per Mopar Journey 2018 OM p.367.');

-- Chassis fluids (page 370)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_jc, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Journey 2018 OM p.370.'),
  (@g_jc, 'transmission_at', 'Mopar ATF+4',
   '4-speed automatic (2.4L 2009-2011) or 6-speed Aisin AW (2.4L + 3.6L from 2011+). All use ATF+4 per Mopar Journey 2018 OM p.370.'),
  (@g_jc, 'transfer_case', 'Mopar 75W-90 GL-5',
   'Power Transfer Unit (PTU; AWD V6 trims only): Mopar 75W-90 per Mopar Journey 2018 OM p.370.'),
  (@g_jc, 'rear_differential', 'Mopar 75W-90 GL-5',
   'Rear Drive Assembly (RDA; AWD V6 trims only): Mopar 75W-90 per Mopar Journey 2018 OM p.370.'),
  (@g_jc, 'power_steering', 'Mopar Power Steering Fluid +4 or Mopar ATF+4',
   'Hydraulic power steering on Journey (no EPS). Mopar PSF+4 or ATF+4 per Mopar Journey 2018 OM p.370.'),
  (@g_jc, 'ac_refrigerant', 'R-134a; see under-hood A/C label',
   'A/C refrigerant — Journey uses R-134a (pre-EU MAC directive transition to R-1234yf). Charge per under-hood label ~0.66 kg (660 g).'),
  (@g_jc, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.8 L typical midsize SUV.');

-- 6. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Journey_JC_2018_OM_Mopar.pdf',
   'e03060a85f7c3611d8d32136aff947b1ad52b398a9a6c8a17b57832044bde572',
   'owner', 'Dodge', 'Journey', 2018, 2018,
   '9184', NULL, NULL,
   'en-US', 'US', 508,
   'Dodge Journey Owner''s Manual', NOW(),
   'Mopar Dodge Journey 2018 OM. Covers SE/SXT/Crossroad/GT trims + 2.4L World Engine and 3.6L Pentastar. FLUID CAPACITIES p.367.');

SET @mi_journey := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual', 'Dodge Journey (JC) 2018 Owner''s Manual', NULL, @mi_journey, 1, 1, NOW(),
   'OEM Owner''s Manual; covers all 2018 Journey trims + 2 engines (2.4L World + 3.6L Pentastar).');

SET @s_journey_om := LAST_INSERT_ID();

-- 7. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_jc, NULL, NULL, '/images/dodge/journey-jc-suv-2009-2020/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Elise240SX / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2018_Dodge_Journey_Crossroad_FWD_in_Granite_Crystal_Metallic,_Front_Right,_2023-06-29.jpg',
   '2026-05-25', '2018 Dodge Journey Crossroad FWD', '3-4-front', 1280, 794);

-- 8. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_journey_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_jc;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_jc, @s_journey_om);
