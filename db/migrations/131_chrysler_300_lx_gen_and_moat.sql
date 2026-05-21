-- Chrysler 300 (LX) — NEW model + generation seed + per-engine moat.
-- Sister model of the Dodge Charger LX (gen 123); same LX platform, same
-- engines (2.7L EER, 3.5L EGG, 5.7L HEMI, 6.1L SRT8). User dropped the 2007
-- Chrysler 300 OM (Mopar publication 817).
--
-- The DB had no Chrysler 300 model or generation prior to this migration.

SET NAMES utf8mb4;

-- =========================================================================
-- STEP 1 — Insert new source
-- =========================================================================
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Chrysler 300 (LX) 2007 Owner''s Manual', 1, NOW(),
          'Mopar publication 817 — 2007 Chrysler 300 OM covering 2.7/3.5/5.7L engines. The SRT8 6.1 is documented in a separate Charger SRT8 OM (source 623) which covers the LX-platform SRT8 powertrain shared by Charger SRT8 + 300C SRT8.');

SET @s_300_om := (SELECT id FROM sources WHERE citation = 'Chrysler 300 (LX) 2007 Owner''s Manual' LIMIT 1);
SET @s_srt_om := 623;  -- Charger SRT OM also covers the 300C SRT8 6.1
SET @s_fca    := 611;

-- =========================================================================
-- STEP 2 — Insert 300 model under existing Chrysler make
-- =========================================================================
SET @make_chrysler := (SELECT id FROM makes WHERE slug = 'chrysler' LIMIT 1);

INSERT IGNORE INTO models (make_id, slug, name)
  VALUES (@make_chrysler, '300', '300');

SET @model_300 := (SELECT id FROM models WHERE make_id = @make_chrysler AND name = '300' LIMIT 1);

-- =========================================================================
-- STEP 3 — Insert Chrysler 300 LX generation
-- =========================================================================
INSERT IGNORE INTO generations (model_id, slug, ordinal, codename, display_name, body_type, start_year, end_year, layout, fuel_tank_l, platform)
  VALUES (@model_300, 'chrysler-300-lx-sedan-2005-2010', 1, 'LX',
          'Chrysler 300 (LX) 2005-2010',
          'sedan', 2005, 2010, 'FR/AWD', 72.0, 'Chrysler LX');

SET @gen := (SELECT id FROM generations WHERE slug = 'chrysler-300-lx-sedan-2005-2010' LIMIT 1);

-- Engines reused from Charger LX migration 130
SET @e_27       := (SELECT id FROM engines WHERE code = '2.7 EER'  LIMIT 1);
SET @e_35       := (SELECT id FROM engines WHERE code = '3.5 EGG'  LIMIT 1);
SET @e_57hemi   := 166;
SET @e_61srt8   := (SELECT id FROM engines WHERE code = '6.1 SRT8' LIMIT 1);

-- =========================================================================
-- STEP 4 — Trims
-- =========================================================================
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, start_year, end_year, hp, torque_nm, drive_wheel)
  VALUES
    (@gen, 'base-2-7-v6',        '300 Base 2.7 V6 (178 Hp)',         @e_27,     2005, 2010, 178, 258, 'RWD'),
    (@gen, 'touring-3-5-v6',     '300 Touring 3.5 V6 (250 Hp)',      @e_35,     2005, 2010, 250, 339, 'RWD'),
    (@gen, 'c-5-7-hemi',         '300C 5.7 HEMI V8 (340 Hp)',        @e_57hemi, 2005, 2010, 340, 529, 'RWD'),
    (@gen, 'c-srt8-6-1-hemi',    '300C SRT8 6.1 HEMI V8 (425 Hp)',   @e_61srt8, 2005, 2010, 425, 569, 'RWD');

-- =========================================================================
-- STEP 5 — fluid_specs (identical platform to Charger LX)
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_27, 'engine_oil', 5.7, 6.0, '5W-20', 'Mopar MS-6395 (API certified)', 6000, 10000, 12,
   '2.7L EER V6 SOHC. With-filter sump 5.7 L per 2007 Chrysler 300 OM. Shared engine with Dodge Charger LX (LX platform).'),
  (@gen, @e_35, 'engine_oil', 5.7, 6.0, '10W-30', 'Mopar MS-6395 (API certified)', 6000, 10000, 12,
   '3.5L EGG V6 SOHC. With-filter sump 5.7 L per 2007 Chrysler 300 OM. Distinct 10W-30 viscosity vs the 5W-20 used in 2.7L + 5.7L.'),
  (@gen, @e_57hemi, 'engine_oil', 6.6, 7.0, '5W-20', 'Mopar MS-6395 (API certified)', 6000, 10000, 12,
   '5.7L HEMI V8 (300C) with MDS. With-filter sump 6.6 L per 2007 Chrysler 300 OM.'),
  (@gen, @e_61srt8, 'engine_oil', 6.6, 7.0, '0W-40', 'Mopar MS-10725 (full synthetic, Mobil 1 0W-40)', 6000, 10000, 12,
   '6.1L 392 HEMI SRT8 V8 (300C SRT8, 425 Hp). Same engine as Charger SRT8; sump 6.6 L. 0W-40 full synthetic only.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_27,     'coolant',  9.4,  9.9, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '2.7L EER cooling — 9.4 L per 2007 Chrysler 300 OM.'),
  (@gen, @e_35,     'coolant', 10.5, 11.1, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '3.5L EGG cooling — 10.5 L (RWD); AWD takes 10.8 L per 2007 Chrysler 300 OM.'),
  (@gen, @e_57hemi, 'coolant', 13.9, 14.7, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '5.7L HEMI cooling — 13.9 L without Severe Duty II; with Severe Duty II: 14.3 L per 2007 Chrysler 300 OM.'),
  (@gen, @e_61srt8, 'coolant', 14.4, 15.2, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '6.1L SRT8 cooling — 14.4 L per 2007 Charger SRT8 OM (same LX-platform SRT8 cooling system as 300C SRT8).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'Mopar ATF+4 (MS-9602)', '42RLE 4-speed (2.7L base) or Mercedes-Benz 5G-Tronic W5A580 (3.5/5.7/6.1). All Mopar ATF+4.'),
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'Mopar DOT 3 (SAE J1703) — DOT 4 acceptable alternative', 'Brake fluid — DOT 3 SAE J1703.'),
  (@gen, NULL, 'transfer_case', NULL, NULL, 'Mopar Transfer Case Lubricant LX (PN 05170055AA, AWD only)', 'AWD-only. BorgWarner LX transfer case.'),
  (@gen, NULL, 'differential_front', NULL, NULL, '75W-90 GL-5 Synthetic Gear Lubricant (AWD only)', 'AWD front axle. 75W-90 GL-5 synthetic.'),
  (@gen, NULL, 'differential_rear', NULL, NULL, '75W-140 GL-5 Synthetic Gear Lubricant', 'Rear axle — 75W-140 GL-5 (heavier than LD-era).'),
  (@gen, NULL, 'power_steering_fluid', NULL, NULL, 'Mopar Power Steering Fluid +4 (or Mopar ATF+4)', 'Hydraulic power steering.'),
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R-134a', 'A/C refrigerant — 2005-2010 LX uses R-134a. Charge per under-hood label.');

-- =========================================================================
-- STEP 6 — parts
-- =========================================================================
INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @e_27,     'spark_plug', 'RE14PMC5',   'Mopar (Champion)', 1.27, '2.7L EER spark plug, gap 0.050 in / 1.27 mm.'),
  (@gen, @e_35,     'spark_plug', 'ZFR5LP-13G', 'Mopar (NGK)',      1.27, '3.5L EGG spark plug, gap 0.050 in / 1.27 mm.'),
  (@gen, @e_57hemi, 'spark_plug', 'REC14MCC4',  'Mopar (Champion)', 1.1,  '5.7L HEMI spark plug, gap 0.043 in / 1.1 mm. 16 plugs (2 per cylinder).'),
  (@gen, NULL,      'oil_filter', '05281090',   'Mopar OEM',        NULL, 'Mopar 05281090 — shared across all LX engines.');

-- =========================================================================
-- STEP 7 — service_intervals (same maintenance schedule as Charger LX)
-- =========================================================================
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, 'engine_oil_and_filter', 6000, 3000, 10000, 5000, 12, 'Mopar Oil Change Indicator may shorten the interval.'),
  (@gen, 'tire_rotation',         6000, NULL, 10000, NULL, NULL, NULL),
  (@gen, 'engine_air_filter',    30000, 15000, 50000, 25000, 30, NULL),
  (@gen, 'spark_plugs_hemi',     30000, NULL, 50000, NULL, 30, '5.7L HEMI: every 30,000 mi.'),
  (@gen, 'rear_diff_oil',        48000, NULL, 80000, NULL, 48, 'Severe duty only.'),
  (@gen, 'transmission_at_fluid',60000, NULL, 100000, NULL, 60, 'Severe duty — otherwise lifetime fill.'),
  (@gen, 'pcv_valve',            90000, NULL, 150000, NULL, 90, 'Inspect and replace if necessary.'),
  (@gen, 'coolant_flush',       102000, NULL, 170000, NULL, 60, 'Mopar HOAT 5-year / 100,000 mi.'),
  (@gen, 'spark_plugs_v6_srt',  102000, NULL, 170000, NULL, 102, '2.7L + 3.5L + 6.1L SRT8 spark plugs.'),
  (@gen, 'timing_belt',         102000, NULL, 170000, NULL, 102, '3.5L EGG ONLY — interference timing belt.'),
  (@gen, 'transmission_at_fluid_normal', 102000, NULL, 170000, NULL, 102, 'Normal-duty.'),
  (@gen, 'accessory_drive_belt', 120000, NULL, 200000, NULL, 120, '2.7L EER only.'),
  (@gen, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, 'Every 2 years.');

-- =========================================================================
-- STEP 8 — citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_300_om FROM fluid_specs
   WHERE generation_id=@gen AND engine_id != @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_srt_om FROM fluid_specs
   WHERE generation_id=@gen AND engine_id = @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_fca FROM fluid_specs WHERE generation_id=@gen;

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_300_om FROM parts WHERE generation_id=@gen AND engine_id != @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_fca FROM parts WHERE generation_id=@gen;

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, @s_300_om FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, @s_fca FROM service_intervals WHERE generation_id=@gen;

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Chrysler 300 LX gen seed complete' AS status,
       @gen AS new_gen_id, @model_300 AS new_model_id,
       (SELECT COUNT(*) FROM trims WHERE generation_id=@gen) AS trims,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen) AS fluid_rows,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen) AS parts_rows,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen) AS service_intervals_rows,
       @s_300_om AS new_source_id;
