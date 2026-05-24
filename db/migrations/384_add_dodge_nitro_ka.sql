-- mig 384: ADD Dodge Nitro KA (1st gen, 2007-2011) — midsize SUV
--
-- Built on the Jeep Liberty KK platform (NOT yet in our DB). Sister to Liberty.
-- US production 2007-2011, Mexico 2007-2012. Discontinued in favor of Journey JC.
--
-- 2 engines in 2010 OM:
--   - 3.7L PowerTech V6 (base, 210 hp; NEW engine added)
--   - 4.0L SOHC V6 (R/T, 260 hp; NEW engine added — Mopar premium variant)
-- Older engine technology with HOAT coolant (Hybrid Organic Additive Technology
-- 5yr/100k Formula) — same chemistry as LX-platform 2005-2010.
--
-- Source: Mopar Dodge Nitro 2010 OM (PDF 733, 498 pages). public_link=1.

SET @make_dodge := 35;

-- 1. ADD engines
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('3.7 PowerTech V6', 'Chrysler 3.7L PowerTech V6 SOHC (EKG/EKK; Nitro/Liberty/Dakota)', 3700, 'gasoline', 'na', 6, 93.0, 90.8, 9.6),
  ('4.0 SOHC V6',      'Chrysler 4.0L SOHC V6 (EER-related; Nitro R/T)',                   4015, 'gasoline', 'na', 6, 93.0, 98.5, 10.3);

SET @e_37powertech := (SELECT id FROM engines WHERE code='3.7 PowerTech V6');
SET @e_40sohc := (SELECT id FROM engines WHERE code='4.0 SOHC V6');

-- 2. ADD model
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'nitro', 'Nitro', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='nitro');

SET @m_nitro := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='nitro');

-- 3. ADD generation
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_nitro, 'nitro-ka-suv-2007-2011', 1, 'KA',
       'chrysler-kk-ka-platform-2007-2012', 'Chrysler KK / KA Platform (Liberty/Nitro)',
       'Nitro (KA, 1st gen)', 'suv', 2007, 2011,
       'RWD', 4577, 1857, 1798, 2763,
       73.8,
       'Independent SLA upper-lower control arms', '5-link solid axle coil',
       'Ventilated disc 12.9 in', 'Solid disc 12.7 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_nitro AND g.slug='nitro-ka-suv-2007-2011'
);

SET @g_ka := (SELECT id FROM generations WHERE model_id=@m_nitro AND slug='nitro-ka-suv-2007-2011');

-- 4. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_ka, 'sxt-3-7-v6-4at', '3.7 PowerTech SXT/SE (210 Hp) RWD/4WD 4AT', @e_37powertech, 210),
  (@g_ka, 'heat-3-7-v6-4at', '3.7 PowerTech Heat/Detonator (210 Hp) RWD/4WD 4AT', @e_37powertech, 210),
  (@g_ka, 'rt-4-0-v6-5at',  '4.0 SOHC R/T (260 Hp) RWD/4WD 5AT', @e_40sohc, 260);

-- 5. fluid_specs — Mopar Nitro 2010 OM page 445

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_ka, @e_37powertech, 'engine_oil', 4.7, 5.0, '5W-20',
   'API SP / Chrysler MS-6395; SAE 5W-20',
   '3.7L PowerTech V6 (210 hp, EKG/EKK family): 4.7 L (5 qt) with filter, SAE 5W-20 per Mopar Nitro 2010 OM p.445. Spark plug: NGK ZFR6F-11G, gap 0.043 in (1.09 mm).'),
  (@g_ka, @e_40sohc, 'engine_oil', 5.2, 5.5, '10W-30',
   'API SP / Chrysler MS-6395; SAE 10W-30',
   '4.0L SOHC V6 R/T (260 hp): 5.2 L (5.5 qt) with filter, SAE 10W-30 per Mopar Nitro 2010 OM p.445. Note: heavier 10W-30 viscosity vs lighter 5W-20 on 3.7L. Spark plug: NGK ZFR5LP-13G, gap 0.050 in (1.27 mm).');

-- Cooling per engine (both same capacity)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_ka, @e_37powertech, 'coolant', 13.3, 14.0, 'Mopar HOAT 5yr/100k (Hybrid OAT)',
   '3.7L PowerTech cooling: 13.3 L (14 qt) per Mopar Nitro 2010 OM p.445. HOAT chemistry (5 year / 100k mi) — distinct from newer Stellantis OAT (10yr/150k).'),
  (@g_ka, @e_40sohc, 'coolant', 13.3, 14.0, 'Mopar HOAT 5yr/100k (Hybrid OAT)',
   '4.0L SOHC cooling: 13.3 L (14 qt) per Mopar Nitro 2010 OM p.445.');

-- Chassis fluids (page 447)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_ka, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Nitro 2010 OM p.447.'),
  (@g_ka, 'transmission_at', 'Mopar ATF+4',
   '4-speed automatic (3.7L) or 5-speed automatic (4.0L). Both use ATF+4 per Mopar Nitro 2010 OM p.447. 5AT is Mercedes-Benz W5A580 from LX-platform.'),
  (@g_ka, 'transfer_case', 'Mopar ATF+4',
   '4WD trims (Command-Trac single-speed NV241 or Trac-Lok 2-speed NV245). Both use ATF+4 per Mopar Nitro 2010 OM p.447.'),
  (@g_ka, 'differential_front', 'SAE 80W-90 GL-5 Multi-Purpose Gear Lubricant',
   'Front axle (4WD trims only): SAE 80W-90 GL-5 per Mopar Nitro 2010 OM p.447. Heavier viscosity than newer Stellantis 75W-85 spec — Nitro uses older Liberty/Dakota truck-grade gear oil.'),
  (@g_ka, 'differential_rear', 'SAE 75W-140 Synthetic Gear Lubricant (API GL-5)',
   'Rear axle: SAE 75W-140 synthetic GL-5 per Mopar Nitro 2010 OM p.447. Heavier than LX-platform 75W-90 — truck-derived axle.'),
  (@g_ka, 'power_steering', 'Mopar Power Steering Fluid +4 or Mopar ATF+4',
   'Hydraulic power steering (no EPS). Mopar PSF+4 or ATF+4 per Mopar Nitro 2010 OM p.447.'),
  (@g_ka, 'ac_refrigerant', 'R-134a; see under-hood A/C label',
   'A/C refrigerant — Nitro uses R-134a all years (pre-Stellantis R-1234yf transition). Charge per under-hood label ~0.66 kg (660 g) typical mid-size SUV.'),
  (@g_ka, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.5 L typical midsize SUV.');

-- 6. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Nitro_KA_2010_OM_Mopar.pdf',
   '4715e4886e7c145c27254ac1f642effb1e93c171c459a7ac2c8dee5eb37cd804',
   'owner', 'Dodge', 'Nitro', 2010, 2010,
   '733', NULL, NULL,
   'en-US', 'US', 498,
   'Dodge Nitro Owner''s Manual', NOW(),
   'Mopar Dodge Nitro 2010 OM. Covers SXT/SE/Heat/Detonator/R/T trims + 3.7L PowerTech / 4.0L SOHC V6. HOAT coolant. FLUID CAPACITIES p.445.');

SET @mi_nitro := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual', 'Dodge Nitro (KA) 2010 Owner''s Manual', NULL, @mi_nitro, 1, 1, NOW(),
   'OEM Owner''s Manual; covers 2010 Nitro (post-facelift). Final year was 2011.');

SET @s_nitro_om := LAST_INSERT_ID();

-- 7. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_ka, NULL, NULL, '/images/dodge/nitro-ka-suv-2007-2011/hero.jpg',
   'wikimedia', 'CC BY-SA 2.0',
   'crash71100 / Wikimedia Commons, CC BY-SA 2.0',
   'https://commons.wikimedia.org/wiki/File:Dodge_Nitro_(48598535191).jpg',
   '2026-05-25', 'Dodge Nitro', '3-4-front', 1280, 858);

-- 8. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_nitro_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_ka;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_ka, @s_nitro_om);
