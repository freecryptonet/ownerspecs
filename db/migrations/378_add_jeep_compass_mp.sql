-- mig 378: ADD Jeep Compass MP (2nd gen, 2017-present) — compact crossover SUV
--
-- Built on FCA Small Wide LWB platform (shared with Renegade + Fiat 500X). US market
-- 2022 OM lists only the 2.4L Tigershark engine. Internationally also offered with:
--   - 1.3L T4 turbo MultiAir3 (Hurricane T4) — 4xe PHEV in Europe (270 hp combined)
--   - 1.4L MultiAir2 turbo — discontinued
--   - 2.0L Multijet diesel (international)
-- A 2.0L Hurricane turbo gas variant was added for 2023+ US — beyond 2022 OM.
--
-- Source: Mopar Jeep Compass 2022 OM (PDF P134296_22_MP_OM, 336 pages). public_link=1.

SET @make_jeep := 21;
SET @e_24tigershark := (SELECT id FROM engines WHERE code='2.4 Tigershark MA2');

-- 1. ADD model: Jeep Compass
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_jeep, 'compass', 'Compass', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_jeep AND slug='compass');

SET @m_compass := (SELECT id FROM models WHERE make_id=@make_jeep AND slug='compass');

-- 2. ADD generation: Compass MP 2nd gen
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_compass, 'compass-mp-suv-2017-present', 2, 'MP',
       'fca-small-wide-platform-2015-present', 'FCA Small Wide LWB Platform',
       'Compass (MP, 2nd gen)', 'suv', 2017, NULL,
       'FWD', 4395, 1810, 1640, 2636,
       51.0,
       'MacPherson strut independent', 'Multi-link Chapman strut independent',
       'Ventilated disc 11.6 in', 'Solid disc 10.95 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_compass AND g.slug='compass-mp-suv-2017-present'
);

SET @g_mp := (SELECT id FROM generations WHERE model_id=@m_compass AND slug='compass-mp-suv-2017-present');

-- 3. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_mp, 'sport-2-4-i4-fwd-6at',     '2.4 Tigershark I4 Sport/Latitude FWD (177 Hp) 6AT',  @e_24tigershark, 177),
  (@g_mp, 'trailhawk-2-4-i4-awd-9at', '2.4 Tigershark I4 Trailhawk/Limited AWD (180 Hp) 9AT', @e_24tigershark, 180);

-- 4. fluid_specs — from Mopar Compass 2022 OM page 316

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_mp, @e_24tigershark, 'engine_oil', 5.2, 5.5, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20 full synthetic',
   '2.4L Tigershark MultiAir2 I4 NA: 5.2 L (5.5 qt) with filter, SAE 0W-20 per Mopar Compass 2022 OM p.316. Same engine block + capacity as Cherokee KL 2.4L.'),
  (@g_mp, @e_24tigershark, 'coolant', 6.5, 6.8, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L Tigershark cooling: 6.5 L (6.8 qt) per Mopar Compass 2022 OM p.316. Slightly smaller than Cherokee KL 2.4L (6.8 L) — different radiator package.');

-- Chassis fluids (Mopar Compass 2022 OM page 317)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_mp, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Compass 2022 OM p.317.'),
  (@g_mp, 'transmission_at', 'Mopar AW-1 ATF (6AT FWD) or Mopar ZF 8&9 Speed ATF (9AT 4WD)',
   '6-speed Aisin AW (FWD only, 2017-2021) uses Mopar AW-1 ATF. 9-speed 948TE (4WD trims) uses Mopar ZF 8&9 Speed ATF per Mopar Compass 2022 OM p.317.'),
  (@g_mp, 'transfer_case', 'Mopar Front Axle/PTU Synthetic 75W-90 (API GL-5)',
   'Power Transfer Unit (PTU; AWD trims only): Mopar Front Axle/PTU 75W-90 per Mopar Compass 2022 OM p.317.'),
  (@g_mp, 'rear_differential', 'Mopar Rear Axle/RDM Synthetic 75W-90 (API GL-5)',
   'Rear Drive Module (RDM; AWD trims only): Mopar Rear Axle/RDM 75W-90 per Mopar Compass 2022 OM p.317. Disconnects in highway cruise for fuel economy.'),
  (@g_mp, 'ac_refrigerant', 'R-1234yf; see under-hood A/C label',
   'A/C refrigerant — Compass MP uses R-1234yf from 2017 launch. Charge per under-hood label ~0.56 kg (560 g) typical.'),
  (@g_mp, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.0 L typical compact crossover.');

-- 5. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Jeep_Compass_MP_2022_OM_Mopar.pdf',
   '0040aba68a6d18750ebbbe3538538d6e8bc0045ab26947e4dabd6cba466eae92',
   'owner', 'Jeep', 'Compass', 2022, 2022,
   'P134296', '22_MP_OM_EN_USC_DIGITAL', NULL,
   'en-US', 'US', 336,
   'Jeep Compass Owner''s Manual', NOW(),
   'Mopar Jeep Compass (MP) 2022 OM. US market — 2.4L Tigershark only (international markets also have 1.3T 4xe PHEV + 2.0 Multijet diesel). FLUID CAPACITIES p.316.');

SET @mi_mp := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'Jeep Compass (MP) 2022 Owner''s Manual',
   NULL, @mi_mp, 1, 1, NOW(),
   'OEM Owner''s Manual; US-market 2022 Compass.');

SET @s_mp_om := LAST_INSERT_ID();

-- 6. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_mp, NULL, NULL, '/images/jeep/compass-mp-suv-2017-present/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2018_Jeep_Compass_Latitude_2.4L_front_4.20.19.jpg',
   '2026-05-25', '2018 Jeep Compass Latitude 2.4L', '3-4-front', 1280, 726);

-- 7. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_mp_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_mp;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_mp, @s_mp_om);
