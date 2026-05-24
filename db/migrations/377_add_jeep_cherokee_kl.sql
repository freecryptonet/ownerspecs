-- mig 377: ADD Jeep Cherokee KL (5th gen, 2014-2023) — compact mid-size SUV
--
-- Built on FCA Compact U.S. Wide platform (derived from Alfa Romeo Giulietta).
-- Three engine families in US market 2020 OM:
--   - 2.4L Tigershark MultiAir2 I4 NA (base, 184 hp)
--   - 3.2L Pentastar V6 (Limited/Trailhawk/Overland, 271 hp — different displacement than 3.6L)
--   - 2.0L Hurricane I4 turbo (added 2019+ Trailhawk Elite / Limited / High Altitude, 270 hp)
-- No 4xe PHEV variant. Discontinued after 2023 model year (KL plant idled).
--
-- Source: Mopar Jeep Cherokee 2020 OM (PDF P136176_20_KL_OM, 364 pages). public_link=1.

SET @make_jeep := 21;

-- 1. ADD engines if not exists
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('2.4 Tigershark MA2', 'FCA Tigershark MultiAir2 2.4L I4 NA', 2360, 'gasoline', 'na',    4, 88.0, 97.0, 10.0),
  ('3.2 Pentastar',      'Chrysler 3.2L Pentastar V6 (KL Cherokee-specific)', 3239, 'gasoline', 'na', 6, 91.0, 83.0, 10.7);

SET @e_24tigershark := (SELECT id FROM engines WHERE code='2.4 Tigershark MA2');
SET @e_32pentastar  := (SELECT id FROM engines WHERE code='3.2 Pentastar');
SET @e_20hurricane  := 187;

-- 2. ADD model: Jeep Cherokee
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_jeep, 'cherokee', 'Cherokee', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_jeep AND slug='cherokee');

SET @m_cherokee := (SELECT id FROM models WHERE make_id=@make_jeep AND slug='cherokee');

-- 3. ADD generation: Cherokee KL 5th gen (2014-2023)
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_cherokee, 'cherokee-kl-suv-2014-2023', 5, 'KL',
       'fca-compact-us-wide-platform-2014-2023', 'FCA Compact U.S. Wide Platform',
       'Cherokee (KL, 5th gen)', 'suv', 2014, 2023,
       'FWD', 4624, 1859, 1670, 2719,
       60.0,
       'MacPherson strut independent', 'Multi-link Chapman strut independent',
       'Ventilated disc 12.0 in (Trailhawk 13.0 in)',
       'Solid disc 12.0 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_cherokee AND g.slug='cherokee-kl-suv-2014-2023'
);

SET @g_kl := (SELECT id FROM generations WHERE model_id=@m_cherokee AND slug='cherokee-kl-suv-2014-2023');

-- 4. ADD trims (3 powertrain variants)
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_kl, 'latitude-2-4-i4-9at',     '2.4 Tigershark I4 Latitude/Sport (184 Hp) FWD/AWD 9AT', @e_24tigershark, 184),
  (@g_kl, 'trailhawk-2-0-turbo-9at', '2.0 Hurricane I4 Turbo Trailhawk Elite (270 Hp) AWD 9AT', @e_20hurricane,  270),
  (@g_kl, 'limited-3-2-v6-9at',      '3.2 Pentastar V6 Limited/Overland (271 Hp) FWD/AWD 9AT',  @e_32pentastar,  271);

-- 5. fluid_specs — from Mopar Cherokee 2020 OM page 274

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_kl, @e_24tigershark, 'engine_oil', 5.2, 5.5, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '2.4L Tigershark MultiAir2 I4 NA: 5.2 L (5.5 qt) with filter, SAE 0W-20 per Mopar Cherokee 2020 OM p.274.'),
  (@g_kl, @e_20hurricane, 'engine_oil', 4.7, 5.0, '5W-30',
   'API SN PLUS / Chrysler MS-13340; SAE 5W-30 full synthetic',
   '2.0L Hurricane I4 turbo (eTorque MHEV on some trims; 270 hp Trailhawk Elite): 4.7 L (5 qt) with filter, SAE 5W-30 full synthetic API SN PLUS per Mopar Cherokee 2020 OM p.274-275.'),
  (@g_kl, @e_32pentastar, 'engine_oil', 5.6, 6.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '3.2L Pentastar V6 (Cherokee KL-specific displacement, NOT 3.6L): 5.6 L (6 qt) with filter, SAE 5W-20 per Mopar Cherokee 2020 OM p.274.');

-- Cooling per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_kl, @e_24tigershark, 'coolant', 6.8, 7.2, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L Tigershark cooling: 6.8 L (7.2 qt) per Mopar Cherokee 2020 OM p.274. Smallest cooling system among KL engines.'),
  (@g_kl, @e_20hurricane, 'coolant', 8.6, 9.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Hurricane turbo cooling: 8.6 L (9 qt) per Mopar Cherokee 2020 OM p.274.'),
  (@g_kl, @e_32pentastar, 'coolant', 9.5, 10.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.2L Pentastar V6 cooling: 9.5 L (10 qt) per Mopar Cherokee 2020 OM p.274.');

-- Chassis fluids
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_kl, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Cherokee 2020 OM p.276.'),
  (@g_kl, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   'ZF 9HP48 9-speed automatic (948TE on V6 / 2.0T variants). First Stellantis application of 9HP unit. Per Mopar Cherokee 2020 OM p.276.'),
  (@g_kl, 'transfer_case', 'Mopar ATF+4 (Active Drive I and II) or Mopar Transfer Case Lubricant (Active Drive Lock — Trailhawk)',
   'AWD trims: Active Drive I (single-speed PTU, Sport/Latitude) and Active Drive II (Limited/Overland) use ATF+4. Active Drive Lock (Trailhawk, 56:1 crawl ratio) uses Mopar TC Lubricant.'),
  (@g_kl, 'front_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant',
   'Front differential / PTU (AWD trims): Mopar 75W-85 GL-5. Capacity not in OM.'),
  (@g_kl, 'rear_differential', 'Mopar 75W-85 GL-5 Synthetic Axle Lubricant',
   'Rear differential (AWD trims; FWD trims have none). Mopar 75W-85 GL-5 per typical FCA spec.'),
  (@g_kl, 'ac_refrigerant', 'R-134a (2014-2018) / R-1234yf (2019-2023); see under-hood A/C label',
   'A/C refrigerant — 2014-2018 R-134a; 2019+ R-1234yf. Charge per under-hood label ~0.59 kg (590 g) typical Cherokee.'),
  (@g_kl, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.5 L typical compact SUV.');

-- 6. manual_inventory + sources
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
   'Mopar Jeep Cherokee (KL) 2020 OM. Covers all 2020 KL trims (Latitude/Sport/Limited/Trailhawk/Overland/High Altitude) + 3 engines (2.4L Tigershark, 2.0L Hurricane turbo, 3.2L Pentastar V6). FLUID CAPACITIES page 274.');

SET @mi_kl := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Cherokee (KL) 2020 Owner''s Manual',
   NULL, @mi_kl, 1, 1, NOW(),
   'OEM Owner''s Manual; covers all 2020 KL Cherokee trims + 3 engines.');

SET @s_kl_om := LAST_INSERT_ID();

-- 7. Hero image
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_kl, NULL, NULL, '/images/jeep/cherokee-kl-suv-2014-2023/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2019_Jeep_Cherokee_Latitude_front_5.27.18.jpg',
   '2026-05-25', '2019 Jeep Cherokee Latitude', '3-4-front', 1280, 799);

-- 8. Cite all rows to Mopar Cherokee OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_kl_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_kl;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_kl, @s_kl_om);
