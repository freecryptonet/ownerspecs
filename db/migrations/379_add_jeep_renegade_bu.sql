-- mig 379: ADD Jeep Renegade BU (1st gen, 2015-2023) — subcompact crossover
--
-- Built on FCA Small Wide LWB platform (same as Compass MP + Fiat 500X).
-- BU = US chassis code; BV = international code. US 2021 OM covers:
--   - 1.3L T4 MultiAir3 turbo (177 hp, 2020-2023; NEW engine added)
--   - 2.4L Tigershark MultiAir2 NA (180 hp, 2015-2023; engine 213 reused)
-- Earlier 1.4L MultiAir2 turbo (2015-2018) discontinued by 2021 OM scope.
-- Renegade 4xe PHEV (1.3T + electric) is international-only (not US).
--
-- Source: Mopar Jeep Renegade 2021 OM (PDF P135657_21_BV_OM, 412 pages). public_link=1.

SET @make_jeep := 21;
SET @e_24tigershark := (SELECT id FROM engines WHERE code='2.4 Tigershark MA2');

-- 1. ADD engine: 1.3L T4 Hurricane turbo
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('1.3 T4 MA3', 'FCA 1.3L T4 MultiAir3 Hurricane I4 turbo', 1332, 'gasoline', 'turbo', 4, 70.0, 86.5, 10.0);

SET @e_13t4 := (SELECT id FROM engines WHERE code='1.3 T4 MA3');

-- 2. ADD model: Jeep Renegade
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_jeep, 'renegade', 'Renegade', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_jeep AND slug='renegade');

SET @m_renegade := (SELECT id FROM models WHERE make_id=@make_jeep AND slug='renegade');

-- 3. ADD generation
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_renegade, 'renegade-bu-suv-2015-2023', 1, 'BU',
       'fca-small-wide-platform-2015-present', 'FCA Small Wide LWB Platform',
       'Renegade (BU, 1st gen)', 'suv', 2015, 2023,
       'FWD', 4236, 1805, 1697, 2570,
       48.0,
       'MacPherson strut independent', 'Multi-link Chapman strut independent',
       'Ventilated disc 11.0 in', 'Solid disc 11.0 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_renegade AND g.slug='renegade-bu-suv-2015-2023'
);

SET @g_bu := (SELECT id FROM generations WHERE model_id=@m_renegade AND slug='renegade-bu-suv-2015-2023');

-- 4. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_bu, 'sport-1-3-turbo-9at',     '1.3 T4 Hurricane Sport/Latitude (177 Hp) FWD/AWD 9AT',  @e_13t4, 177),
  (@g_bu, 'latitude-2-4-i4-9at',     '2.4 Tigershark Sport/Latitude (180 Hp) FWD/AWD 9AT',    @e_24tigershark, 180),
  (@g_bu, 'trailhawk-2-4-i4-awd-9at','2.4 Tigershark Trailhawk AWD (180 Hp) 9AT',             @e_24tigershark, 180);

-- 5. fluid_specs — Mopar Renegade 2021 OM page 392

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_bu, @e_13t4, 'engine_oil', 4.5, 4.8, '0W-30',
   'API SN PLUS / Chrysler MS-13340; SAE 0W-30 full synthetic',
   '1.3L T4 MultiAir3 Hurricane turbo (177 hp, 2020-2023 US): 4.5 L (4.8 qt) with filter, SAE 0W-30 full synthetic API SN PLUS per Mopar Renegade 2021 OM p.392.'),
  (@g_bu, @e_24tigershark, 'engine_oil', 5.2, 5.5, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '2.4L Tigershark MultiAir2 NA: 5.2 L (5.5 qt) with filter, SAE 0W-20 per Mopar Renegade 2021 OM p.392. Same engine + capacity as Compass MP + Cherokee KL 2.4L.'),
  (@g_bu, @e_13t4, 'coolant', 8.3, 8.8, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '1.3L T4 turbo cooling: 8.3 L (8.8 qt) per Mopar Renegade 2021 OM p.392. Larger than 2.4L NA due to turbo + intercooler heat load.'),
  (@g_bu, @e_24tigershark, 'coolant', 6.5, 6.8, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L Tigershark cooling: 6.5 L (6.8 qt) per Mopar Renegade 2021 OM p.392. Matches Compass MP 2.4L.');

-- Chassis fluids
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_bu, 'brake_fluid', 'Mopar DOT 4 (DOT 3 acceptable backup)',
   'Renegade BU specifies Mopar DOT 4 per Mopar 2021 OM p.393 — distinct from Compass MP (DOT 3) despite shared platform. Must be replaced every 2 years regardless of mileage.'),
  (@g_bu, 'transmission_at', 'Mopar ZF 8 & 9 Speed ATF (MS-12892)',
   '9-speed 948TE automatic per Mopar Renegade 2021 OM p.393. Earlier (2015-2017) FWD trims used 6-speed Aisin AW with AW-1 ATF.'),
  (@g_bu, 'transfer_case', 'Mopar Front Axle/PTU Synthetic 75W-90 (API GL-5)',
   'Power Transfer Unit (PTU; AWD trims only): Mopar 75W-90 per Mopar Renegade 2021 OM p.393.'),
  (@g_bu, 'rear_differential', 'Mopar Rear Axle/RDM Synthetic 75W-90 (API GL-5)',
   'Rear Drive Module (RDM; AWD trims only): Mopar 75W-90 per Mopar Renegade 2021 OM p.393.'),
  (@g_bu, 'ac_refrigerant', 'R-1234yf; see under-hood A/C label',
   'A/C refrigerant — Renegade BU uses R-1234yf from 2015 launch. Charge per under-hood label ~0.45 kg (450 g) typical subcompact.'),
  (@g_bu, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~2.5 L typical subcompact crossover.');

-- 6. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Jeep_Renegade_BU_2021_OM_Mopar.pdf',
   'ff1d93dc17f6bfd86caebe2b97e5e5d43b8bfa42018e00a81e22671915b12bc5',
   'owner', 'Jeep', 'Renegade', 2021, 2021,
   'P135657', '21_BV_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', 412,
   'Jeep Renegade Owner''s Manual', NOW(),
   'Mopar Jeep Renegade (BU/BV) 2021 OM. US market — 1.3T + 2.4L Tigershark. International OM also covers 1.4T + 2.0 Multijet + 4xe PHEV.');

SET @mi_bu := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Renegade (BU) 2021 Owner''s Manual',
   NULL, @mi_bu, 1, 1, NOW(),
   'OEM Owner''s Manual; US-market 2021 Renegade Sport/Latitude/Trailhawk/Limited.');

SET @s_bu_om := LAST_INSERT_ID();

-- 7. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_bu, NULL, NULL, '/images/jeep/renegade-bu-suv-2015-2023/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Matti Blume / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:Jeep_Renegade,_GIMS_2019,_Le_Grand-Saconnex_(GIMS0538).jpg',
   '2026-05-25', 'Jeep Renegade at GIMS 2019', '3-4-front', 1280, 849);

-- 8. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_bu_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_bu;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_bu, @s_bu_om);
