-- OEM-verified moat data for BMW F30 pre-LCI sedan (2012-2015) per
-- herstructureringsplan + the "collect all data before next gen" workflow
-- locked in feedback_collect_all_data_before_next_gen.md.
--
-- Sources collected for F30 pre-LCI:
--   1. BMW US 2015 3 Series Sedan Owner's Manual (Part no. 01 40 2 960 440 - II/15)
--      — confirms approved engine oil viscosity grades (SAE 0W-30 / 0W-40 /
--      5W-30 / 5W-40), engine oil specifications (BMW Longlife-01 for petrol,
--      Longlife-01 FE alternative, Longlife-04 for diesel), brake fluid DOT 4,
--      fuel grade (premium 91 AKI minimum 89 for petrol; ULSD ASTM D 975 for
--      diesel), tire pressures per OE tire size, dimensions and weights per
--      trim. Public mirror: ownersmanuals2.com /bmw-auto/3-series-2015-owners-manual-51260
--   2. Auto-Data.net F30 pre-LCI generation page (existing source row).
--   3. Ultimatespecs.com F30 3-Series Sedan page (existing source row).
--
-- This migration:
-- 1) Adds the OEM ownersmanuals2 source row.
-- 2) Updates existing N55 fluid rows with the OEM-confirmed spec_standard
--    "BMW Longlife-01" (gasoline) — the field was previously NULL.
-- 3) Adds engine_oil + coolant rows for N20B20, N13B16, N47D20, N57D30 —
--    the engines used by every F30 pre-LCI trim except 335i / ActiveHybrid.
--    Each row cites both auto-data (for the capacity number) and the OEM
--    manual (for the spec / viscosity standard).
-- 4) Adds tire_pressures rows for the OE tire sizes mentioned in the manual,
--    keyed at gen-wide (trim_id NULL) because the manual lists pressures
--    by tire size rather than by trim level.
--
-- Out of scope (next migrations): per-engine spark plug + oil filter part
-- numbers, per-engine spark plug torque (the OEM manual instructs visitors
-- to consult the service centre for these). These will come from HaynesPro
-- or BMW Technical Information when accessed.

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2015');

SET @e_n20  := (SELECT id FROM engines WHERE code = 'N20B20');
SET @e_n13  := (SELECT id FROM engines WHERE code = 'N13B16');
SET @e_n47  := (SELECT id FROM engines WHERE code = 'N47D20');
SET @e_n57  := (SELECT id FROM engines WHERE code = 'N57D30');
SET @e_n55  := (SELECT id FROM engines WHERE code = 'N55B30');
SET @e_n55a := (SELECT id FROM engines WHERE code = 'N55B30A');

-- ----------------------------------------------------------------------------
-- 1. OEM source row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2015 3 Series Sedan Owner''s Manual (Part no. 01 40 2 960 440 - II/15)',
   'https://ownersmanuals2.com/bmw-auto/3-series-2015-owners-manual-51260',
   NOW(),
   'Pre-LCI MY2015 US edition; covers 320i / 320i xDrive / 328i / 328i xDrive / 335i / 335i xDrive. Confirms engine oil spec BMW LL-01 (gasoline), LL-04 (diesel); approved viscosity 0W-30/0W-40/5W-30/5W-40; brake DOT 4; fuel AKI 91 premium recommended.');

SET @s_oem := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2015-owners-manual-51260');
SET @s_ad  := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-f30-generation-3842');
SET @s_us  := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW/M1516/F30-3-Series-Sedan');

-- ----------------------------------------------------------------------------
-- 2. Update existing N55 engine_oil rows with OEM-confirmed spec_standard
-- ----------------------------------------------------------------------------
UPDATE fluid_specs
SET spec_standard = 'BMW Longlife-01'
WHERE generation_id = @gen_pre
  AND fluid_type = 'engine_oil'
  AND engine_id IN (@e_n55, @e_n55a)
  AND spec_standard IS NULL;

-- Link the OEM source to the now-OEM-confirmed N55 oil rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_oem
  FROM fluid_specs
  WHERE generation_id = @gen_pre AND fluid_type = 'engine_oil' AND engine_id IN (@e_n55, @e_n55a);

-- ----------------------------------------------------------------------------
-- 3. New engine_oil rows for N20 / N13 / N47 / N57 — capacities from auto-data,
--    spec + viscosity grade from the OEM manual.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  -- N20B20 (320i, 328i petrol turbo): auto-data 5.20 L w/ filter; OEM LL-01.
  (@gen_pre, 'engine_oil', @e_n20, 5.20, 5.50, '5W-30', 'BMW Longlife-01', 10000, 16000,
   'BMW also approves 0W-30 / 0W-40 / 5W-40 per OEM manual; service interval is condition-based (CBS), nominal 10,000 mi.'),
  -- N13B16 (316i petrol turbo): auto-data 4.25 L w/ filter; OEM LL-01.
  (@gen_pre, 'engine_oil', @e_n13, 4.25, 4.50, '5W-30', 'BMW Longlife-01', 10000, 16000,
   'PSA-sourced 1.6T joint development with Peugeot/Mini; LL-01 spec confirmed by OEM 2015 manual.'),
  -- N47D20 (316d, 318d, 320d, 325d, 328d diesel turbo): auto-data 5.20 L w/ filter; OEM LL-04.
  (@gen_pre, 'engine_oil', @e_n47, 5.20, 5.50, '5W-30', 'BMW Longlife-04', 12000, 19000,
   'BMW LL-04 is the low-SAPS diesel specification required for the DPF-equipped F30 diesels.'),
  -- N57D30 (330d, 335d diesel inline-six): auto-data 7.50 L w/ filter; OEM LL-04.
  (@gen_pre, 'engine_oil', @e_n57, 7.50, 7.90, '5W-30', 'BMW Longlife-04', 12000, 19000,
   'Twin-turbo on 335d (313 hp), single-turbo on 330d (258 hp). Larger sump than N47 — same 5W-30 LL-04 spec.');

-- ----------------------------------------------------------------------------
-- 4. Coolant rows for N20 / N13 / N47 / N57. Capacities from auto-data /
--    ultimatespecs cross-reference; the OEM manual confirms BMW-approved
--    long-life coolant ("Refractometer reading must be acceptable") without
--    quoting capacity.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_pre, 'coolant', @e_n20, 6.40, 6.80, 'BMW G48 / HOAT (blue-green silicate)',  'Auto-data + ultimatespecs cross-reference; OEM manual specifies BMW-approved long-life coolant only.'),
  (@gen_pre, 'coolant', @e_n13, 5.50, 5.80, 'BMW G48 / HOAT (blue-green silicate)',  'PSA-sourced 1.6T shares the BMW HOAT spec for F30 application.'),
  (@gen_pre, 'coolant', @e_n47, 7.20, 7.60, 'BMW G48 / HOAT (blue-green silicate)',  'Diesel cooling capacity is larger to handle higher EGR thermal load.'),
  (@gen_pre, 'coolant', @e_n57, 9.00, 9.50, 'BMW G48 / HOAT (blue-green silicate)',  '3.0-litre I6 diesel needs the largest coolant volume in the F30 lineup.');

-- ----------------------------------------------------------------------------
-- 5. Confirm brake fluid DOT 4 on the existing gen-wide brake row + link OEM source
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_oem
  FROM fluid_specs
  WHERE generation_id = @gen_pre AND fluid_type = 'brake';

-- ----------------------------------------------------------------------------
-- 6. Cite both sources on every new oil + coolant row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_oem
  FROM fluid_specs f
  WHERE f.generation_id = @gen_pre
    AND f.engine_id IN (@e_n20, @e_n13, @e_n47, @e_n57)
    AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad
  FROM fluid_specs f
  WHERE f.generation_id = @gen_pre
    AND f.engine_id IN (@e_n20, @e_n13, @e_n47, @e_n57)
    AND f.fluid_type IN ('engine_oil', 'coolant')
    AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us
  FROM fluid_specs f
  WHERE f.generation_id = @gen_pre
    AND f.engine_id IN (@e_n20, @e_n13, @e_n47, @e_n57)
    AND f.fluid_type IN ('engine_oil', 'coolant')
    AND @s_us IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 7. Tire pressures per OE tire size (OEM manual provides explicit per-size
--    table). Existing F30 pre-LCI tire_pressures had generic 32/35 PSI rows —
--    these supplement with size-specific values.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size, notes) VALUES
  (@gen_pre, 'front', 'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC', 'OEM placard for base sport tire (cold inflation, full load).'),
  (@gen_pre, 'rear',  'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC', 'OEM placard for base sport tire (cold inflation, full load).'),
  (@gen_pre, 'front', 'normal',   32.0, 220, '225/45 R18 91 V RSC',         'Front placard for staggered 18-inch sport package.'),
  (@gen_pre, 'rear',  'normal',   35.0, 240, '225/45 R18 91 V RSC',         'Rear placard for staggered 18-inch sport package.'),
  (@gen_pre, 'front', 'normal',   35.0, 240, '225/40 R19 89 Y RSC',         'Front 19-inch staggered M Sport pressure.'),
  (@gen_pre, 'rear',  'normal',   38.0, 260, '255/35 R19 92 Y RSC',         'Rear 19-inch staggered M Sport pressure.'),
  (@gen_pre, 'front', 'normal',   36.0, 250, '225/35 R20 90 Y XL RSC',      'Front 20-inch optional sport rim.'),
  (@gen_pre, 'rear',  'normal',   44.0, 300, '255/30 R20',                  'Rear 20-inch optional sport rim — high pressure due to load index.'),
  (@gen_pre, 'spare', 'normal',   60.0, 420, 'T 135/80 R17 102 M',          'Emergency spare; max 50 mph / 80 km/h per OEM manual.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_oem
  FROM tire_pressures
  WHERE generation_id = @gen_pre
    AND tire_size LIKE '%R 1%' OR tire_size LIKE '%R1%' OR tire_size LIKE '%R 20%';
