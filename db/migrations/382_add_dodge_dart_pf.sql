-- mig 382: ADD Dodge Dart PF (1st gen modern, 2013-2016) — compact sedan
--
-- Short-lived (4 model years) FCA compact sedan on the Compact U.S. Wide platform
-- (Alfa Romeo Giulietta-derived; same platform basis as Cherokee KL). Discontinued
-- end of 2016 — Belvidere plant repurposed for Cherokee KL production.
--
-- 3 engines in 2016 OM:
--   - 1.4L MultiAir2 turbo (Aero/Rallye; 160 hp; NEW engine added)
--   - 2.0L Tigershark NA (SXT/SE; 160 hp; NEW engine added — different from 2.0
--     Hurricane turbo)
--   - 2.4L Tigershark MultiAir2 NA (GT/Rallye/R/T; 184 hp; engine 213 reused
--     from Cherokee KL)
--
-- Source: Mopar Dodge Dart 2016 OM (PDF 50, 691 pages). public_link=1.

SET @make_dodge := 35;
SET @e_24tigershark := (SELECT id FROM engines WHERE code='2.4 Tigershark MA2');

-- 1. ADD engines: 1.4L MultiAir turbo + 2.0L Tigershark NA
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('1.4 MA2 T',     'FCA 1.4L MultiAir2 turbo I4 (Dart/500 Abarth)', 1368, 'gasoline', 'turbo', 4, 72.0, 84.0, 9.8),
  ('2.0 Tigershark', 'FCA Tigershark 2.0L I4 NA (Dart/Patriot)',     1995, 'gasoline', 'na',    4, 86.0, 86.0, 10.5);

SET @e_14ma := (SELECT id FROM engines WHERE code='1.4 MA2 T');
SET @e_20tiger := (SELECT id FROM engines WHERE code='2.0 Tigershark');

-- 2. ADD model
INSERT INTO models (make_id, slug, name, is_active)
SELECT @make_dodge, 'dart', 'Dart', 1
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=@make_dodge AND slug='dart');

SET @m_dart := (SELECT id FROM models WHERE make_id=@make_dodge AND slug='dart');

-- 3. ADD generation
INSERT INTO generations
  (model_id, slug, ordinal, codename, family_slug, family_label, display_name,
   body_type, start_year, end_year, layout, length_mm, width_mm, height_mm, wheelbase_mm,
   fuel_tank_l, front_suspension, rear_suspension, front_brakes, rear_brakes)
SELECT @m_dart, 'dart-pf-sedan-2013-2016', 1, 'PF',
       'fca-compact-us-wide-platform-2014-2023', 'FCA Compact U.S. Wide Platform',
       'Dart (PF, 1st gen modern)', 'sedan', 2013, 2016,
       'FWD', 4671, 1834, 1473, 2703,
       54.0,
       'MacPherson strut independent', 'Multi-link Chapman strut independent',
       'Ventilated disc 12.0 in (GT 12.6 in)', 'Solid disc 11.9 in'
WHERE NOT EXISTS (
  SELECT 1 FROM generations g WHERE g.model_id=@m_dart AND g.slug='dart-pf-sedan-2013-2016'
);

SET @g_pf := (SELECT id FROM generations WHERE model_id=@m_dart AND slug='dart-pf-sedan-2013-2016');

-- 4. ADD trims
INSERT INTO trims (generation_id, slug, name, engine_id, hp) VALUES
  (@g_pf, 'aero-1-4-turbo-6mt',     '1.4 MultiAir Turbo Aero (160 Hp) FWD 6MT',   @e_14ma,    160),
  (@g_pf, 'aero-1-4-turbo-6dct',    '1.4 MultiAir Turbo Aero (160 Hp) FWD 6DDCT', @e_14ma,    160),
  (@g_pf, 'sxt-2-0-i4-6mt',         '2.0 Tigershark SXT/SE (160 Hp) FWD 6MT',     @e_20tiger, 160),
  (@g_pf, 'sxt-2-0-i4-6at',         '2.0 Tigershark SXT/SE (160 Hp) FWD 6AT',     @e_20tiger, 160),
  (@g_pf, 'gt-2-4-i4-6at',          '2.4 Tigershark GT/R/T (184 Hp) FWD 6AT',     @e_24tigershark, 184);

-- 5. fluid_specs — Mopar Dart 2016 OM page 640

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
  (@g_pf, @e_14ma, 'engine_oil', 3.8, 4.0, '5W-40',
   'API SP / Chrysler MS-12991; SAE 5W-40 full synthetic',
   '1.4L MultiAir2 turbo (Aero/Rallye 160 hp; FIAT/FCA C625A): 3.8 L (4 qt) with filter, SAE 5W-40 full synthetic per Mopar Dart 2016 OM p.640. MS-12991 is the European diesel-grade spec; required for the GME-T4 family.'),
  (@g_pf, @e_20tiger, 'engine_oil', 4.7, 5.0, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '2.0L Tigershark I4 NA (SXT/SE 160 hp): 4.7 L (5 qt) with filter, SAE 0W-20 per Mopar Dart 2016 OM p.640. Different engine block from 2.0 Hurricane turbo (used in Wrangler JL etc.).'),
  (@g_pf, @e_24tigershark, 'engine_oil', 5.2, 5.5, '0W-20',
   'API SP / Chrysler MS-6395; SAE 0W-20',
   '2.4L Tigershark MultiAir2 (GT/R/T 184 hp): 5.2 L (5.5 qt) with filter, SAE 0W-20 per Mopar Dart 2016 OM p.640. Same engine + capacity as Cherokee KL 2.4L.');

-- Cooling per engine
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@g_pf, @e_14ma, 'coolant', 5.5, 5.8, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '1.4L MultiAir turbo cooling: 5.5 L (5.8 qt) per Mopar Dart 2016 OM p.640.'),
  (@g_pf, @e_20tiger, 'coolant', 6.8, 7.2, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Tigershark NA cooling: 6.8 L (7.2 qt) per Mopar Dart 2016 OM p.640. Same as 2.4L variant.'),
  (@g_pf, @e_24tigershark, 'coolant', 6.8, 7.2, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.4L Tigershark cooling: 6.8 L (7.2 qt) per Mopar Dart 2016 OM p.640.');

-- Chassis fluids (Mopar OM 2016 next pages)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes) VALUES
  (@g_pf, 'brake_fluid', 'Mopar DOT 3 SAE J1703 (DOT 4 LV backup)',
   'Brake master cylinder: Mopar DOT 3 per Mopar Dart 2016 OM.'),
  (@g_pf, 'transmission_at', 'Mopar AW-1 ATF (6AT) or Mopar C635 MTF (6MT)',
   '6-speed Aisin AW (1.4T DDCT and 2.0/2.4 6AT trims) uses Mopar AW-1 ATF. 6-speed C635 manual (1.4T base) uses Mopar Manual Transmission Fluid per Mopar Dart 2016 OM.'),
  (@g_pf, 'transmission_mt', 'Mopar C635 Manual Transmission Fluid',
   '6-speed C635 manual transmission (FCA/FIAT, Aero/Rallye 1.4T base): Mopar specific MTF. Same gearbox family as Fiat 500/Abarth.'),
  (@g_pf, 'ac_refrigerant', 'R-134a; see under-hood A/C label',
   'A/C refrigerant — Dart uses R-134a (pre-2019 Stellantis transition to R-1234yf). Charge per under-hood label ~0.51 kg (510 g) typical compact.'),
  (@g_pf, 'washer_fluid', 'Mopar Windshield Washer Solvent (low-temp formula)',
   'Washer reservoir; capacity not in OM ~3.0 L typical compact sedan.');

-- 6. manual_inventory + sources
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/Dodge_Dart_PF_2016_OM_Mopar.pdf',
   '553f091b68d2d21f2bb6116f26fa0fdf0145941bbf036772d2a8e1a43f8a72e1',
   'owner', 'Dodge', 'Dart', 2016, 2016,
   '50', NULL, NULL,
   'en-US', 'US', 691,
   'Dodge Dart Owner''s Manual', NOW(),
   'Mopar Dodge Dart 2016 OM (final model year). Covers Aero/SXT/SE/GT/R/T trims + 1.4T/2.0/2.4 engines. FLUID CAPACITIES p.640.');

SET @mi_dart := LAST_INSERT_ID();

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual', 'Dodge Dart (PF) 2016 Owner''s Manual', NULL, @mi_dart, 1, 1, NOW(),
   'OEM Owner''s Manual; final model year 2016. Covers all 3 engines.');

SET @s_dart_om := LAST_INSERT_ID();

-- 7. Hero
INSERT INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url,
   download_date, caption, position, width, height)
VALUES
  (@g_pf, NULL, NULL, '/images/dodge/dart-pf-sedan-2013-2016/hero.jpg',
   'wikimedia', 'CC BY-SA 4.0',
   'Alexander-93 / Wikimedia Commons, CC BY-SA 4.0',
   'https://commons.wikimedia.org/wiki/File:Dodge_Dart_(2013)_1X7A7366.jpg',
   '2026-05-25', '2013 Dodge Dart', '3-4-front', 1280, 854);

-- 8. Cite all rows
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_dart_om
  FROM fluid_specs fs WHERE fs.generation_id = @g_pf;

INSERT INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', @g_pf, @s_dart_om);
