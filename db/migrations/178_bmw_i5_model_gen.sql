-- BMW i5 model + G60-sedan generation + 3 BEV trims.
--
-- The i5 shares the G60 chassis (5060 x 1900 x 1515 mm, wheelbase 2995 mm)
-- with the ICE 5 Series but is taxonomically separate on ownerspecs.com
-- because (1) the drivetrain is fundamentally different — dual electric
-- motors, no engine oil, no fuel tank — and (2) the owner's manual ships
-- as a distinct document. This mirrors the i4 model entry pattern (gen 119
-- 'i4-g26-sedan-2021-present').
--
-- Sources cited per row:
--   1. BMW US 2024 i5 Owner's Manual (Part no. 01405A93B43-VI/23) — local
--   2. BMW US 2026 i5 Owner's Manual                              — local
--   3. Auto-data.net i5 Sedan (G60) generation page + 3 trim pages
--   4. HaynesPro WorkshopData G60/G61/G90 dataset (lists i5 trims by typeId)
--
-- BMW i5 launch lineup (verified across all 4 sources):
-- - eDrive40 — 81.2 kWh net, 250 kW (340 hp), RWD, single rear motor
-- - xDrive40 — 83.9 kWh net, 290 kW (394 hp), AWD, dual motors (MY2024+)
-- - M60 xDrive — 81.2 kWh net, 442 kW (601 hp WLTP / 593 hp SAE), AWD, dual

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

-- ----------------------------------------------------------------------------
-- 1. New i5 model
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO models (make_id, slug, name, bio, is_active) VALUES
  (@make_bmw, 'i5', 'i5',
   'BMW i5 is the fully-electric variant of the eighth-generation 5 Series, launched mid-2023 for MY2024. It shares the G60 sedan body and CLAR-2 platform with the combustion 5 Series but uses dual electric motors and a floor-mounted lithium-ion battery pack instead of an inline engine and gearbox.',
   1);

SET @model_i5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'i5');

-- ----------------------------------------------------------------------------
-- 2. New electric motor entries
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel) VALUES
  ('BMW i5 PM Synch Single', 'BMW i5 5th-gen rear-axle PM synchronous motor', NULL, 'electric'),
  ('BMW i5 PM Synch Dual',   'BMW i5 5th-gen dual-motor (front induction + rear PM synchronous)', NULL, 'electric');

SET @e_i5_single := (SELECT id FROM engines WHERE code = 'BMW i5 PM Synch Single');
SET @e_i5_dual   := (SELECT id FROM engines WHERE code = 'BMW i5 PM Synch Dual');

-- ----------------------------------------------------------------------------
-- 3. i5 G60-sedan generation
-- ----------------------------------------------------------------------------
INSERT INTO generations (
  model_id, slug, ordinal, codename, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_i5,
  'i5-g60-sedan-2023-present',
  1,
  'G60',
  'G60',
  'Sedan',
  2023,
  NULL,
  'RWD',
  'BMW CLAR-2',
  'The i5 is BMW''s first fully-electric 5 Series, sharing the G60 sedan body but adopting a battery-and-motor drivetrain in place of the combustion 5 Series'' inline engine and ZF 8HP gearbox. The 81.2 kWh (net) lithium-ion battery sits in a flat pack under the floor between the axles, contributing to a low centre of gravity and roughly 50:50 weight distribution. Air-cooled high-voltage modules and a closed-loop coolant circuit (BMW LC-18) regulate cell temperature in both fast-charge and high-load scenarios.\n\nThe launch lineup spans three variants. The **eDrive40** (RWD) uses a single rear-axle permanent-magnet synchronous motor — 250 kW (340 hp) — paired with a single-speed reduction gear. The **xDrive40** (MY2024+) adds a front-axle induction motor for 290 kW (394 hp) combined and BMW xDrive electronic torque distribution. At the top, the **M60 xDrive** pairs a much more powerful front induction motor with the rear PMSM for 442 kW (601 hp peak Boost / 593 hp SAE), 0–100 km/h in 3.8 seconds, and an electronically limited 230 km/h top speed.\n\nDC fast charging is supported up to 205 kW (M60) / 195 kW (40 variants), enabling a typical 10–80 % charge in around 30 minutes on a CCS station. AC charging tops out at 11 kW three-phase (22 kW optional in some markets). All i5 variants use BMW LC-18 coolant for the battery and motor circuits (the same LC-18 spec used in late G30 LCI and G60 ICE engines), require no engine oil, and follow a BMW Condition-Based Service (CBS) maintenance schedule that focuses on brake fluid, reduction gear oil, cabin filter, and 12V auxiliary battery instead of ICE-specific items. Production is at BMW Group Dingolfing alongside the combustion G60.',
  5060, 1900, 1515, 2995,
  1623, 1656, NULL, 490,
  'Double-wishbone, with anti-roll bar',
  'Multi-link, with anti-roll bar',
  'Ventilated disc',
  'Ventilated disc',
  1
);

SET @gen_i5 := (SELECT id FROM generations WHERE model_id = @model_i5 AND slug = 'i5-g60-sedan-2023-present');

-- ----------------------------------------------------------------------------
-- 4. i5 trims (3)
-- ----------------------------------------------------------------------------
INSERT INTO trims (generation_id, slug, name, engine_id, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel, curb_weight_kg, start_year, end_year) VALUES
  (@gen_i5, '81-2-kwh-340-hp-edrive40',       '81.2 kWh (340 Hp) eDrive40',          @e_i5_single, 340, 430, 6.0, 193, 'RWD', 2130, 2023, NULL),
  (@gen_i5, '83-9-kwh-394-hp-xdrive40',       '83.9 kWh (394 Hp) xDrive40',          @e_i5_dual,   394, 600, 5.4, 200, 'AWD', 2245, 2024, NULL),
  (@gen_i5, 'm60-81-2-kwh-601-hp-xdrive',     'M60 81.2 kWh (601 Hp) xDrive',        @e_i5_dual,   601, 820, 3.8, 230, 'AWD', 2305, 2023, NULL);

-- ----------------------------------------------------------------------------
-- 5. Source rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2024 i5 Owner''s Manual',
   'https://ownersmanuals2.com/bmw-auto/i5-2024-owners-manual-95889', NOW(),
   'Launch MY2024 i5. Confirms 11 kW AC minimum charging recommendation, LC-18 coolant for HV battery + motor circuit, no engine oil servicing.'),
  ('BMW US 2026 i5 Owner''s Manual',
   'https://ownersmanuals2.com/bmw-auto/i5-2026-owners-manual-107914', NOW(),
   'MY2026 i5. Adds xDrive40 to tire pressure tables (versus 2024 manual which only documented eDrive40 + M60).'),
  ('Auto-Data.net — BMW i5 Sedan (G60)',
   'https://www.auto-data.net/en/bmw-i5-sedan-g60-generation-9502', NOW(),
   '3 BEV variants: eDrive40 81.2 kWh RWD, xDrive40 83.9 kWh AWD MY2024+, M60 xDrive 81.2 kWh AWD. 400V Li-Ion architecture. WLTP range 497-582 km (eDrive40).'),
  ('HaynesPro WorkshopData — BMW 5 (G60, G61, G90) — i5 chassis variants',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562', NOW(),
   'i5 typeId t_619116377 (HA0 motor 250 kW), t_619139201 (XE2 290 kW), t_619116378 (XE2 442 kW).');

SET @s_i5_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2024-owners-manual-95889');
SET @s_i5_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2026-owners-manual-107914');
SET @s_ad_i5   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-i5-sedan-g60-generation-9502');
SET @s_haynes  := (SELECT id FROM sources WHERE citation LIKE 'HaynesPro WorkshopData — BMW 5 (G60, G61, G90) — i5%' LIMIT 1);

-- Cite all 4 sources on the new trims
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_i5 FROM trims WHERE generation_id = @gen_i5;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_haynes FROM trims WHERE generation_id = @gen_i5;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_i5_2024 FROM trims WHERE generation_id = @gen_i5;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_i5_2026 FROM trims WHERE generation_id = @gen_i5;
