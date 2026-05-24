-- mig 375: ADD Jeep Gladiator JT (1st gen, 2020-present) — Wrangler JL-based pickup
--
-- Shares JL chassis architecture (front clip, doors, body panels) with extended
-- wheelbase + truck bed. 2 engine families in 2022 OM:
--   - 3.6L Pentastar V6 (base, 285 hp; 0W-20 viscosity — Gladiator/JL-specific spec)
--   - 3.0L EcoDiesel V6 (260 hp / 442 lb-ft, 2020-2023, dropped after EPA tightening)
--   - (6.4L HEMI 392 added 2025+ Rubicon X, beyond 2022 OM scope)
--   - (No 4xe PHEV variant — Wrangler-only feature)
--
-- Source: Mopar Jeep Gladiator 2022 OM (PDF 104713, 380 pages). public_link=1.

SET @make_jeep := (SELECT id FROM makes WHERE slug='jeep');
SET @e_pentastar := 138;
SET @e_ecodiesel := 202;

-- 1. ADD model: Jeep Gladiator
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_jeep, 'gladiator', 'Gladiator', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_jeep AND slug='gladiator');

SET @m_gladiator := (SELECT id FROM models WHERE make_id=@make_jeep AND slug='gladiator');

-- 2. ADD generation: Gladiator JT 1st gen (2020-present)
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_gladiator, 'gladiator-jt-pickup-2020-present', 1, 'JT',
       'jeep-jl-jt-platform-2018-present', 'JL / JT Platform',
       'Gladiator (JT, 1st gen)', 'pickup', 2020, NULL,
       '4WD', 5539, 1894, 1869, 3488,
       83.0,
       'Solid Dana 44 axle 5-link coil', 'Solid Dana 44 axle 5-link coil',
       'Ventilated disc 12.9 in (Rubicon 13.0 in)',
       'Ventilated disc 13.5 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_gladiator AND g.slug='gladiator-jt-pickup-2020-present'
);

SET @g_jt := (SELECT id FROM generations WHERE model_id=@m_gladiator AND slug='gladiator-jt-pickup-2020-present');

-- 3. ADD trims (2 powertrain variants — Pentastar + EcoDiesel)
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_jt, 'sport-3-6-v6-8at',      '3.6 Pentastar V6 Sport (285 Hp) 4WD 8AT',  @e_pentastar, 285),
  (@g_jt, 'sport-3-6-v6-6mt',      '3.6 Pentastar V6 Sport (285 Hp) 4WD 6MT',  @e_pentastar, 285),
  (@g_jt, 'rubicon-3-0-diesel-8at','3.0 EcoDiesel V6 Rubicon (260 Hp) 4WD 8AT', @e_ecodiesel, 260),
  (@g_jt, 'mojave-3-6-v6-8at',     '3.6 Pentastar V6 Mojave (285 Hp) 4WD 8AT',  @e_pentastar, 285);

-- 4. fluid_specs — from Mopar Gladiator 2022 OM page 362

-- Engine oil per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_jt, @e_pentastar, 'engine_oil', 4.7, 5.0, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20 full synthetic',
   '3.6L Pentastar V6: 4.7 L (5 qt) with filter, SAE 0W-20 per Mopar Gladiator 2022 OM p.360. Note: Gladiator Pentastar spec is 0W-20 (matches Wrangler JL Pentastar 0W-20 after our mig 370 fix; distinct from Charger LD 5W-20).'),
  (@g_jt, @e_ecodiesel, 'engine_oil', 8.5, 9.0, '5W-40',
   'API SN/SP / Chrysler MS-12991; SAE 5W-40 full synthetic',
   '3.0L EcoDiesel V6 (VM Motori A630, 260 hp / 442 lb-ft): 8.5 L (9.0 qt) with filter, SAE 5W-40 full synthetic per Mopar Gladiator 2022 OM p.360. Note: slightly higher capacity than Ram 1500 DT EcoDiesel (8.0 L) — different sump/pan for JT chassis.');

-- Cooling
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_jt, @e_pentastar, 'coolant', 12.3, 13.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar cooling: 12.3 L (13 qt) per Mopar Gladiator 2022 OM p.360. Larger cooling system than Wrangler JL Pentastar (10.6 L) — Gladiator runs more thermal load due to truck duty cycle.'),
  (@g_jt, @e_ecodiesel, 'coolant', 13.7, 14.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.0L EcoDiesel cooling: 13.7 L (14.5 qt) per Mopar Gladiator 2022 OM p.360.');

-- DEF Tank for EcoDiesel
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_jt, @e_ecodiesel, 'def_fluid', 19.3, 5.1, 'Mopar Diesel Exhaust Fluid (API Certified, ISO 22241)',
   'Diesel Exhaust Fluid tank: 19.3 L (5.1 US gal) per Mopar Gladiator 2022 OM p.360. Required for SCR after-treatment on the EcoDiesel.');

-- Chassis fluids (mirror Wrangler JL since shared platform)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_jt, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Gladiator OM 2022. Replace 2 yr.'),
  (@g_jt, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   '8-speed automatic 850RE (ZF 8HP-derived). Total fill ~9.5 L; drain-refill 4-5 L. Same unit as Wrangler JL automatic trims.'),
  (@g_jt, 'transmission_mt', 'Mopar Manual Transmission Fluid (MS-9417 or equivalent)',
   '6-speed manual D478 (Aisin / Toyota TR-6060 family; Sport trim only on 3.6L Pentastar). Capacity ~2.2 L per typical spec. Same unit as Wrangler JL 6MT.'),
  (@g_jt, 'transfer_case', 'Mopar Transfer Case Lubricant for NV241 (Sport Command-Trac) or NV241OR (Rubicon Rock-Trac)',
   'Two transfer cases: NV241 single-speed (Sport/Overland), NV241OR Rock-Trac w/ 4:1 low (Rubicon). Same units as Wrangler JL.'),
  (@g_jt, 'front_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant + Limited-Slip Additive (Rubicon)',
   'Solid Dana 44 (Sport/Overland/Mojave) or Dana 44 Heavy Duty Wide (Rubicon). Front axle capacity ~1.42 L typical, same as JL.'),
  (@g_jt, 'rear_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant + Limited-Slip Additive',
   'Solid Dana 44 rear (Sport/Overland) or Dana 44 Heavy Duty Wide (Rubicon/Mojave). LSD or e-Locker variants need LSD Additive (MS-10111). Rear axle capacity ~1.66 L typical.'),
  (@g_jt, 'ac_refrigerant', 'R-1234yf; see under-hood A/C label',
   'A/C refrigerant — Gladiator JT (2020+) uses R-1234yf from launch; charge per under-hood label ~0.62 kg (620 g).'),
  (@g_jt, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir; capacity not in Mopar OM ~5 L typical full-size pickup.');

-- 5. manual_inventory + sources for Mopar Gladiator 2022 OM
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Jeep_Gladiator_JT_2022_OM_Mopar.pdf',
   '73726de2d8494eba24eac39599231875c3edb97c0c1a0d898a703857aa63cca4',
   'owner', 'Jeep', 'Gladiator', 2022, 2022,
   '104713', '22_JT_OM_EN_USC_DIGITAL_E4_V1', NULL,
   'en-US', 'US', 380,
   'Jeep Gladiator Owner''s Manual', NOW(),
   'Mopar Jeep Gladiator (JT) 2022 OM. Covers Sport / Overland / Rubicon / Mojave / High Altitude trims. 3.6L Pentastar + 3.0L EcoDiesel (last year of diesel availability).');

SET @mi_glad := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Gladiator (JT) 2022 Owner''s Manual',
   NULL, @mi_glad, 1, 1, NOW(),
   'OEM Owner''s Manual; covers all 2022 Gladiator trims + both available engines.');

SET @s_glad_om := LAST_INSERT_ID();

-- 6. Hero image (Jengtingchen / Wikimedia Commons)
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_jt, NULL, NULL, '/images/jeep/gladiator-jt-pickup-2020-present/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Jengtingchen / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:Jeep_Gladiator_%28JT%29_001.jpg',
   '2026-05-25', 'Jeep Gladiator (JT)', '3-4-front', 1280, 960);

-- 7. Cite all fluid rows + gen to Mopar Gladiator OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_glad_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_jt;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_jt, @s_glad_om);
