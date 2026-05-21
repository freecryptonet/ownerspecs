-- Dodge Charger (LX) — NEW generation seed + per-engine moat.
-- The DB previously only had the Charger LD (gen 122, 2011-2023). User
-- provided the 2008 Charger LX OM + 2007 Charger SRT OM, so this migration
-- creates the LX generation (2006-2010) plus its 4 engines, 4 representative
-- trims, fluid_specs, service_intervals.
--
-- Sources:
--   2008 Dodge Charger OM    (scrapers/manuals/2008-dodge-charger-om.pdf)
--   2007 Dodge Charger SRT OM (scrapers/manuals/2007-dodge-charger-srt-om.pdf)
--   Stellantis/FCA aggregator (source 611)
-- The 2008 OM and 2007 SRT OM are inserted as new public sources.
--
-- Engines (4):
--   2.7L EER V6 SOHC     — Chrysler 2.7L EER, 178 Hp
--   3.5L EGG V6 SOHC     — Chrysler 3.5L EGG, 250 Hp
--   5.7L HEMI V8 (eid 166, reused from Charger LD — same engine family)
--   6.1L 392 HEMI SRT8   — Chrysler 6.1L SRT8 HEMI, 425 Hp

SET NAMES utf8mb4;

-- =========================================================================
-- STEP 1 — Insert new OEM sources
-- =========================================================================
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Dodge Charger (LX) 2008 Owner''s Manual', 1, NOW(),
          'Mopar publication 789 — 2008 Charger LX OM covering 2.7/3.5/5.7L engines. Primary public citation for LX moat data.');
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Dodge Charger SRT8 (LX) 2007 Owner''s Manual', 1, NOW(),
          'Mopar publication 825 — 2007 Charger SRT8 OM covering 6.1L 392 HEMI SRT8 engine.');

SET @s_lx_om  := (SELECT id FROM sources WHERE citation = 'Dodge Charger (LX) 2008 Owner''s Manual' LIMIT 1);
SET @s_srt_om := (SELECT id FROM sources WHERE citation = 'Dodge Charger SRT8 (LX) 2007 Owner''s Manual' LIMIT 1);
SET @s_fca    := 611;

-- =========================================================================
-- STEP 2 — Insert new engine rows (EER, EGG, SRT8). Reuse 166 for 5.7 HEMI.
-- =========================================================================
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression)
  VALUES
    ('2.7 EER',  'Chrysler 2.7L EER V6 SOHC',           2736, 'gasoline', 'NA', 'SOHC 24v',   6, 86.0, 78.5, 9.7),
    ('3.5 EGG',  'Chrysler 3.5L EGG V6 SOHC',           3518, 'gasoline', 'NA', 'SOHC 24v',   6, 96.0, 81.0, 10.0),
    ('6.1 SRT8', 'Chrysler 6.1L 392 HEMI SRT8 V8',      6059, 'gasoline', 'NA', 'OHV 16v',    8, 103.0, 90.9, 10.3);

SET @e_27       := (SELECT id FROM engines WHERE code = '2.7 EER'  LIMIT 1);
SET @e_35       := (SELECT id FROM engines WHERE code = '3.5 EGG'  LIMIT 1);
SET @e_57hemi   := 166;
SET @e_61srt8   := (SELECT id FROM engines WHERE code = '6.1 SRT8' LIMIT 1);

-- =========================================================================
-- STEP 3 — Insert the Charger LX generation
-- =========================================================================
SET @model_id := (SELECT g.model_id FROM generations g WHERE g.id = 122);  -- Charger model_id

INSERT IGNORE INTO generations (model_id, slug, ordinal, codename, display_name, body_type, start_year, end_year, layout, fuel_tank_l, platform, successor_id)
  VALUES (@model_id, 'charger-lx-sedan-2006-2010', 6, 'LX',
          'Dodge Charger (LX) 2006-2010',
          'sedan', 2006, 2010, 'FR/AWD', 72.0, 'Chrysler LX', 122);

SET @gen := (SELECT id FROM generations WHERE slug = 'charger-lx-sedan-2006-2010' LIMIT 1);

-- Link LD as the successor (predecessor of LD is LX)
UPDATE generations SET predecessor_id = @gen WHERE id = 122 AND predecessor_id IS NULL;

-- =========================================================================
-- STEP 4 — Insert representative trims (one per engine)
-- =========================================================================
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, start_year, end_year, hp, torque_nm, drive_wheel)
  VALUES
    (@gen, 'base-2-7-v6',    'Base 2.7 V6 (178 Hp)',           @e_27,     2006, 2010, 178, 258, 'RWD'),
    (@gen, 'sxt-3-5-v6',     'SXT 3.5 V6 (250 Hp)',            @e_35,     2006, 2010, 250, 339, 'RWD'),
    (@gen, 'rt-5-7-hemi',    'R/T 5.7 HEMI V8 (340 Hp)',       @e_57hemi, 2006, 2010, 340, 529, 'RWD'),
    (@gen, 'srt8-6-1-hemi',  'SRT8 6.1 HEMI V8 (425 Hp)',      @e_61srt8, 2006, 2010, 425, 569, 'RWD');

-- =========================================================================
-- STEP 5 — fluid_specs per engine (from 2008 LX OM + 2007 SRT OM)
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_27, 'engine_oil', 5.7, 6.0, '5W-20', 'Mopar MS-6395 (API certified SM)', 6000, 10000, 12,
   '2.7L EER V6 SOHC. With-filter sump 5.7 L (6 US qt) per 2008 Charger LX OM. Oil Change Indicator may shorten or extend interval based on driving conditions.'),
  (@gen, @e_35, 'engine_oil', 5.7, 6.0, '10W-30', 'Mopar MS-6395 (API certified SM)', 6000, 10000, 12,
   '3.5L EGG V6 SOHC. With-filter sump 5.7 L per 2008 Charger LX OM. Note distinct 10W-30 viscosity vs the 5W-20 used in the 2.7L + 5.7L variants.'),
  (@gen, @e_57hemi, 'engine_oil', 6.6, 7.0, '5W-20', 'Mopar MS-6395 (API certified SM)', 6000, 10000, 12,
   '5.7L HEMI V8 with MDS (Multi-Displacement System) — same engine family as Charger LD 166; LX-era tuning differs but the sump + MDS valve train fluid spec is identical. 6.6 L (7 US qt) with filter.'),
  (@gen, @e_61srt8, 'engine_oil', 6.6, 7.0, '0W-40', 'Mopar MS-10725 (full synthetic, Mobil 1 0W-40 OE)', 6000, 10000, 12,
   '6.1L 392 HEMI SRT8 V8 (425 Hp). With-filter sump 7 US qt (6.6 L) per 2007 Charger SRT OM. Full-synthetic 0W-40 SRT-spec required — DO NOT substitute the 5W-20 spec used on the standard 5.7 HEMI.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_27,     'coolant',  9.4,  9.9, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '2.7L EER cooling system — 9.4 L per 2008 Charger LX OM. HOAT chemistry (not OAT — LX-era predates Mopar OAT spec). Do NOT mix with newer Mopar OAT used on LD.'),
  (@gen, @e_35,     'coolant', 10.5, 11.1, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '3.5L EGG cooling — 10.5 L (FWD/RWD config); AWD variant takes 10.8 L (11.4 US qt) per 2008 Charger LX OM.'),
  (@gen, @e_57hemi, 'coolant', 13.9, 14.7, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '5.7L HEMI cooling — 13.9 L without Severe Duty II; with Severe Duty II Cooling Package: 14.3 L (15.1 US qt) per 2008 Charger LX OM.'),
  (@gen, @e_61srt8, 'coolant', 14.4, 15.2, 'Mopar Antifreeze/Coolant 5 Year/100,000 Mile HOAT', '6.1L SRT8 HEMI cooling — 14.4 L per 2007 Charger SRT OM. Larger cooling capacity to manage the 425 Hp output.');

-- transmission_at gen-wide (Mercedes 5G-Tronic W5A580 on 5.7/3.5; 4-spd 42RLE on 2.7)
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'Mopar ATF+4 (MS-9602)', 'LX-era automatic transmissions: 42RLE 4-speed (2.7L base), Mercedes-Benz 5G-Tronic W5A580 (3.5L / 5.7L / 6.1L SRT8). All take Mopar ATF+4. Total fluid capacity is service-only spec; not published in the OM.');

-- gen-wide brake, axles, transfer case
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'Mopar DOT 3 (SAE J1703) — DOT 4 acceptable alternative', 'Brake master cylinder fluid. Mopar specifies DOT 3 SAE J1703; DOT 4 acceptable on track use. 2-year change interval per Mopar schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', NULL, NULL, 'Mopar Transfer Case Lubricant LX (PN 05170055AA, AWD only)', 'AWD-only. BorgWarner LX transfer case. Capacity not in OM; service-only spec.'),
  (@gen, NULL, 'differential_front', NULL, NULL, '75W-90 GL-5 Synthetic Gear Lubricant (AWD only)', 'AWD front axle. 75W-90 GL-5 synthetic. Capacity not in OM.'),
  (@gen, NULL, 'differential_rear', NULL, NULL, '75W-140 GL-5 Synthetic Gear Lubricant', 'Rear axle — 75W-140 GL-5 synthetic (heavier than newer LD-era 75W-85). All engines/trims use the same rear axle fluid spec. Capacity not in OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'power_steering_fluid', NULL, NULL, 'Mopar Power Steering Fluid +4 (or Mopar ATF+4)', 'Hydraulic power steering — LX uses Mopar PSF+4. ATF+4 acceptable alternative. Capacity not in OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R-134a', 'A/C refrigerant — 2006-2010 LX uses R-134a (pre-EU MAC directive transition to R-1234yf). Charge per under-hood label.');

-- =========================================================================
-- STEP 6 — parts (spark plugs from OM, per engine)
-- =========================================================================
INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @e_27,     'spark_plug', 'RE14PMC5',   'Mopar (Champion)', 1.27, '2.7L EER spark plug — RE14PMC5, gap 0.050 in / 1.27 mm per 2008 Charger LX OM.'),
  (@gen, @e_35,     'spark_plug', 'ZFR5LP-13G', 'Mopar (NGK)',      1.27, '3.5L EGG spark plug — NGK ZFR5LP-13G, gap 0.050 in / 1.27 mm per 2008 Charger LX OM.'),
  (@gen, @e_57hemi, 'spark_plug', 'REC14MCC4',  'Mopar (Champion)', 1.1,  '5.7L HEMI spark plug — REC14MCC4, gap 0.043 in / 1.1 mm per 2008 Charger LX OM. The 5.7 HEMI uses 16 plugs (2 per cylinder).'),
  (@gen, NULL,      'oil_filter', '05281090',   'Mopar OEM',        NULL, 'Mopar 05281090 — shared across all LX engines per 2008 Charger LX OM + 2007 Charger SRT OM.');

-- =========================================================================
-- STEP 7 — service_intervals (from OM "Maintenance Schedules")
-- =========================================================================
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, 'engine_oil_and_filter', 6000, 3000, 10000, 5000, 12, 'Mopar Oil Change Indicator may shorten the interval — follow the indicator if it triggers before mileage threshold.'),
  (@gen, 'tire_rotation',         6000, NULL, 10000, NULL, NULL, 'Per 2008 Charger LX OM Maintenance Schedule.'),
  (@gen, 'engine_air_filter',    30000, 15000, 50000, 25000, 30, 'Per 2008 Charger LX OM.'),
  (@gen, 'transfer_case_inspect',30000, NULL, 50000, NULL, 30, 'AWD only. Inspect fluid level.'),
  (@gen, 'spark_plugs',          30000, NULL, 50000, NULL, 30, '5.7L HEMI: every 30,000 mi. (2.7L + 3.5L + 6.1L SRT8: every 102,000 mi — see separate notes.)'),
  (@gen, 'rear_diff_oil',        48000, NULL, 80000, NULL, 48, 'Severe duty / fleet / police / off-road / towing only — otherwise lifetime fill.'),
  (@gen, 'transmission_at_fluid',60000, NULL, 100000, NULL, 60, 'Severe duty / fleet / police / towing only — otherwise lifetime fill per Mopar schedule.'),
  (@gen, 'transfer_case_fluid',  60000, NULL, 100000, NULL, 60, 'AWD severe duty / fleet / off-road / towing only.'),
  (@gen, 'pcv_valve',            90000, NULL, 150000, NULL, 90, 'Inspect and replace if necessary.'),
  (@gen, 'coolant_flush',       102000, NULL, 170000, NULL, 60, 'Mopar HOAT 5-year / 100,000 mi formula.'),
  (@gen, 'spark_plugs_v6_srt',  102000, NULL, 170000, NULL, 102, '2.7L + 3.5L V6 + 6.1L SRT8 spark plug replacement. NGK / Champion OE plugs.'),
  (@gen, 'timing_belt',         102000, NULL, 170000, NULL, 102, '3.5L EGG V6 ONLY — interference timing belt; failure to replace at interval results in valve damage.'),
  (@gen, 'transmission_at_fluid_normal', 102000, NULL, 170000, NULL, 102, 'Normal-duty automatic transmission fluid + filter change.'),
  (@gen, 'accessory_drive_belt', 120000, NULL, 200000, NULL, 120, '2.7L EER ONLY — replace accessory drive belt. Other engines: inspect every 30k mi.'),
  (@gen, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, 'Mopar schedule — every 2 years regardless of mileage.');

-- =========================================================================
-- STEP 8 — citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_lx_om FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','power_steering_fluid','ac_refrigerant') AND engine_id != @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_srt_om FROM fluid_specs
   WHERE generation_id=@gen AND engine_id = @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_fca FROM fluid_specs
   WHERE generation_id=@gen;

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_lx_om FROM parts
   WHERE generation_id=@gen AND engine_id != @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_srt_om FROM parts
   WHERE generation_id=@gen AND engine_id = @e_61srt8;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_fca FROM parts WHERE generation_id=@gen;

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, @s_lx_om FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, @s_fca FROM service_intervals WHERE generation_id=@gen;

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Charger LX gen seed complete' AS status,
       @gen AS new_gen_id,
       (SELECT COUNT(*) FROM trims WHERE generation_id=@gen) AS trims,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen) AS fluid_rows,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen) AS parts_rows,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen) AS service_intervals_rows,
       @s_lx_om AS lx_om_source_id, @s_srt_om AS srt_om_source_id,
       @e_27 AS eid_2_7, @e_35 AS eid_3_5, @e_61srt8 AS eid_6_1_srt8;
