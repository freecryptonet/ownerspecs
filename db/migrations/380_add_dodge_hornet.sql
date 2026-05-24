-- mig 380: ADD Dodge Hornet (1st gen, 2023-present) — first Dodge non-muscle SUV
--
-- Hornet is a rebadged Alfa Romeo Tonale on Stellantis Small Wide LWB platform.
-- 2 powertrain variants in 2024 OM (chassis codes GG ICE + GH PHEV):
--   - GT: 2.0L Hurricane I4 turbo (268 hp) — engine 187 reused (same block as
--     Wrangler JL 2.0T, but Hornet uses FCA EU spec 5W-30 API SP/GF-6A vs
--     Stellantis NA 5W-30 MS-6395)
--   - R/T PHEV: 1.3L T4 turbo + electric (288 hp combined) — engine 215 reused
--     (1.3 T4 MA3 from Renegade)
--
-- Source: Mopar Hornet 2024 OM (PDF 105013_24_GG_GH_OM, 312 pages) +
--         Hornet Hybrid 2024 Owner Handbook (PDF 5699790_24_GG_H_OH, 80 pages).
-- Both public_link=1.

SET @make_dodge := 35;
SET @e_20hurricane := 187;
SET @e_13t4 := (SELECT id FROM engines WHERE code='1.3 T4 MA3');

-- 1. ADD model: Dodge Hornet
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'hornet', 'Hornet', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='hornet');

SET @m_hornet := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='hornet');

-- 2. ADD generation: Hornet 1st gen
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_hornet, 'hornet-gg-gh-suv-2023-present', 1, 'GG/GH',
       'stellantis-small-wide-2022-present', 'Stellantis Small Wide Platform (Tonale/Hornet)',
       'Hornet (GG/GH, 1st gen)', 'suv', 2023, NULL,
       'AWD', 4500, 1841, 1612, 2636,
       51.0,
       'MacPherson strut independent', 'Multi-link independent',
       'Ventilated disc 12.4 in (R/T 13.0 in Brembo)',
       'Solid disc 12.6 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_hornet AND g.slug='hornet-gg-gh-suv-2023-present'
);

SET @g_h := (SELECT id FROM generations WHERE model_id=@m_hornet AND slug='hornet-gg-gh-suv-2023-present');

-- 3. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_h, 'gt-2-0-turbo-awd-9at',     'GT 2.0 Hurricane Turbo AWD (268 Hp) 9AT',           @e_20hurricane, 268),
  (@g_h, 'rt-1-3-phev-awd-6at',      'R/T 1.3 T4 PHEV AWD (288 Hp combined) 6AT + EV',    @e_13t4, 288);

-- 4. fluid_specs — Mopar Hornet 2024 OM page 290

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_h, @e_20hurricane, 'engine_oil', 4.73, 5.0, '5W-30',
   'API SP/GF-6A / Chrysler MS-13340; SAE 5W-30 full synthetic',
   '2.0L Hurricane I4 turbo (GT, 268 hp): 4.73 L (5 qt) with filter, SAE 5W-30 API SP/GF-6A per Mopar Hornet 2024 OM p.290. Note: Hornet 2.0T uses MS-13340 spec (FCA EU lineage from Tonale) vs Stellantis NA Wrangler JL 2.0T which uses MS-6395.'),
  (@g_h, @e_13t4, 'engine_oil', 4.74, 5.0, '0W-30',
   'API SN PLUS / Chrysler MS-13340; SAE 0W-30 full synthetic',
   '1.3L T4 MultiAir3 turbo (R/T PHEV, 288 hp combined): 4.74 L (5 qt) with filter, SAE 0W-30 per Mopar Hornet 2024 OM p.290. Same engine block as Renegade BU 1.3T but slightly higher service refill (4.74 L vs 4.5 L) — different sump/pan on Hornet.'),
  (@g_h, @e_13t4, 'coolant', 5.6, 5.9, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '1.3L turbo engine cooling: 5.6 L (5.9 qt) per Mopar Hornet 2024 OM p.290.'),
  (@g_h, @e_13t4, 'battery_coolant', 7.0, 7.4, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   'R/T PHEV Battery + Power Electronics Coolant (combined loop): 7.0 L (7.4 qt) per Mopar Hornet 2024 OM p.290. Dealer-only service. Single combined loop architecture (like GC 4xe) — different from Pacifica Hybrid which has separate battery + PE loops.'),
  (@g_h, @e_20hurricane, 'coolant', 6.6, 7.0, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Hurricane engine cooling: 6.6 L (7 qt) per Mopar Hornet 2024 OM p.290.'),
  (@g_h, @e_20hurricane, 'inverter_coolant', 2.17, 2.3, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Low-temp intercooler/turbo cooling loop: 2.17 L (2.3 qt) per Mopar Hornet 2024 OM p.290. Separate small loop for charge-air cooling.');

-- Chassis fluids
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_h, 'brake_fluid', 'Mopar DOT 4 (TUTELA TOP EVO)',
   'Brake master cylinder: Mopar DOT 4 (TUTELA TOP EVO — Italian FCA brand brake fluid, Alfa Romeo lineage from Tonale platform) per Mopar Hornet 2024 OM p.292.'),
  (@g_h, 'transmission_at', 'Mopar ZF 8 & 9 ATF (MS-12892, gasoline 9AT) or Mopar AW-1 (R/T PHEV 6AT)',
   '9-speed 948TE automatic on GT 2.0L (gasoline) uses ZF 8&9 ATF. R/T PHEV uses 6-speed automatic with Mopar AW-1 ATF. Per Mopar Hornet 2024 OM p.292.'),
  (@g_h, 'transfer_case', 'Mopar Front Axle/PTU Synthetic 75W-90 (API GL-5)',
   'Power Transfer Unit (PTU): Mopar 75W-90 per Mopar Hornet 2024 OM p.292. AWD standard on all Hornet trims.'),
  (@g_h, 'rear_differential', 'Mopar Rear Axle/RDM Synthetic 75W-90 (API GL-5)',
   'Rear Drive Module (RDM): Mopar 75W-90 per Mopar Hornet 2024 OM p.292. R/T PHEV uses electric motor on rear axle.'),
  (@g_h, 'ac_refrigerant', 'R-1234yf; see under-hood A/C label',
   'A/C refrigerant — Hornet uses R-1234yf from 2023 launch. Charge per under-hood label ~0.56 kg (560 g) typical.'),
  (@g_h, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.0 L typical compact crossover.');

-- 5. manual_inventory + sources (both main OM + Hybrid OH)
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Hornet_2024_OM_Mopar.pdf',
   'caf8678605560e75effc6ea1f8fe3b0e58cdfbf011b6cabde95be3bdb40de3e4',
   'owner', 'Dodge', 'Hornet', 2024, 2024,
   '105013', '24_GG_GH_OM_EN_USC_DIGITAL_E4_V1', NULL,
   'en-US', 'US', 312,
   'Dodge Hornet Owner''s Manual', NOW(),
   'Mopar Dodge Hornet 2024 OM. Covers both GG (ICE 2.0T) and GH (PHEV 1.3T+electric) chassis variants. FLUID CAPACITIES p.290.');

SET @mi_hornet := LAST_INSERT_ID();

INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Hornet_Hybrid_2024_OH_Mopar.pdf',
   '883f691b1f2a7b2c0be9d32634fafd3d847e0ee7ce4d1e12ddfaba1bf7b72a5c',
   'owner', 'Dodge', 'Hornet Hybrid', 2024, 2024,
   '5699790', '24_GG_H_OH_EN_USC_DIGITAL_E2', NULL,
   'en-US', 'US', 80,
   'Dodge Hornet Hybrid Owner Handbook', NOW(),
   'Mopar Dodge Hornet Hybrid 2024 Owner Handbook (supplement to main OM). PHEV-specific procedures + HV battery operation.');

SET @mi_hornet_h := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual', 'Dodge Hornet 2024 Owner''s Manual', NULL, @mi_hornet, 1, 1, NOW(),
   'OEM Owner''s Manual; covers GT (2.0L) and R/T (1.3T PHEV) trims.'),
  ('oem_manual', 'Dodge Hornet Hybrid 2024 Owner Handbook', NULL, @mi_hornet_h, 1, 1, NOW(),
   'Mopar Hybrid Supplement Handbook; PHEV-specific HV battery + charging + regen.');

SET @s_hornet_om := (SELECT s.id FROM sources s WHERE s.manual_inventory_id = @mi_hornet);
SET @s_hornet_h := (SELECT s.id FROM sources s WHERE s.manual_inventory_id = @mi_hornet_h);

-- 6. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_h, NULL, NULL, '/images/dodge/hornet-gg-gh-suv-2023-present/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'MercurySable99 / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:2023_Dodge_Hornet_GT,_front_right,_08-05-2023.jpg',
   '2026-05-25', '2023 Dodge Hornet GT', '3-4-front', 1280, 924);

-- 7. Cite all fluid rows + gen to Mopar Hornet OM
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_hornet_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_h;

-- PHEV-specific rows also cite Hybrid OH
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_hornet_h
  FROM fluid_specs fs WHERE fs.generation_id = @g_h AND (fs.engine_id = @e_13t4 OR fs.fluid_type = 'battery_coolant');

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_h, @s_hornet_om);
