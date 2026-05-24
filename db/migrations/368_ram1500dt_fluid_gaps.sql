-- mig 368: fill Ram 1500 DT (gen 43) fluid gaps from Mopar Ram 1500 2022 OM
--
-- Existing 10 fluid rows lack the diesel + HEMI cooling + DEF + MGU coolant entries.
-- Plus the rear_differential row has the wrong viscosity (75W-85 in DB, but Mopar
-- says 75W-90 for the standard 3.21/3.55 axle and 75W-140 for the 3.92 axle).
--
-- Source: Mopar Ram 1500 (DT) 2022 Owner's Manual (sources.id = 861, from mig 363).
-- Verified via pypdf coordinate extraction of pages 372-375.

SET @e_pentastar  := 138;
SET @e_57hemi     := 166;
SET @e_ecodiesel  := 202;
SET @s_ram_om     := 861;

-- 1. ADD engine_oil for 3.0L EcoDiesel
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  (43, @e_ecodiesel, 'engine_oil', 8.0, 8.5, '5W-40',
   'API SP / Chrysler MS-12991; SAE 5W-40 full synthetic (Mopar)',
   '3.0L EcoDiesel V6 (VM Motori A630 DOHC). Service refill with filter: 8.0 L (8.5 qt) per Mopar OM 2022 p.370. Diesel-spec oil required — do not substitute gasoline-engine oils.');

-- 2. UPDATE existing coolant row: link to Pentastar, narrow note
UPDATE fluid_specs SET
    engine_id = @e_pentastar,
    capacity_l = 13.0,
    capacity_qt = 13.7,
    spec_standard = 'Mopar OAT 10yr/150k (FCA MS.90032)',
    notes = '3.6L Pentastar V6 engine cooling system: 13.0 L (13.7 qt) per Mopar OM 2022 p.370. Includes heater + recovery bottle.'
  WHERE generation_id = 43 AND fluid_type = 'coolant' AND engine_id IS NULL;

-- 3. ADD coolant rows for 5.7L HEMI + 3.0L EcoDiesel + 3.6L MGU
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (43, @e_57hemi, 'coolant', 17.3, 18.3, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI V8 engine cooling system: 17.3 L (18.3 qt) per Mopar OM 2022 p.370. Larger cooling capacity vs Pentastar to support HEMI thermal load + eTorque if equipped.'),
  (43, @e_ecodiesel, 'coolant', 11.0, 11.6, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.0L EcoDiesel V6 engine cooling system: 11.0 L (11.6 qt) per Mopar OM 2022 p.371.'),
  (43, @e_pentastar, 'inverter_coolant', 1.7, 1.8, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar eTorque Motor Generator Unit (MGU) coolant loop: 1.7 L (1.8 qt) per Mopar OM 2022 p.370. Separate small cooling loop for the 48V MHEV motor-generator. Not present on non-eTorque trims.');

-- 4. ADD Diesel Exhaust Fluid (DEF) tank entries
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (43, @e_ecodiesel, 'def_fluid', 19.5, 5.14, 'Mopar Diesel Exhaust Fluid (API Certified, ISO 22241)',
   'DEF tank capacity Tradesman / Rebel models: 19.5 L (5.14 US gal) per Mopar OM 2022 p.370. Required for EcoDiesel SCR after-treatment system.'),
  (43, @e_ecodiesel, 'def_fluid', 21.7, 5.74, 'Mopar Diesel Exhaust Fluid (API Certified, ISO 22241)',
   'DEF tank capacity all other EcoDiesel models: 21.7 L (5.74 US gal) per Mopar OM 2022 p.370.');

-- 5. FIX rear_differential spec — Mopar OM 2022 p.373 says 75W-90 (MS-A0160) for std 3.21/3.55, 75W-140 (MS-8985) for 3.92
UPDATE fluid_specs SET
    spec_standard = 'Mopar GL-5 Synthetic 75W-90 (MS-A0160)',
    notes = 'Rear axle 3.21 / 3.55 ratios: Mopar Synthetic Gear Lubricant SAE 75W-90 (MS-A0160). 9.25" AAM. Limited-Slip axles require 5 oz (148 ml) Mopar Limited Slip Additive (MS-10111). 3.92 ratio uses heavier 75W-140 (MS-8985); MaxTow uses Dana 80W-90.'
  WHERE generation_id = 43 AND fluid_type = 'rear_differential';

-- 6. ADD rear_differential variants (3.92 ratio + MaxTow)
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (43, 'rear_differential', 2.1, 2.22, 'Mopar Synthetic Gear Lubricant SAE 75W-140 (MS-8985)',
   '3.92 axle ratio: Mopar Synthetic 75W-140 per Mopar OM 2022 p.373. Limited-Slip variants also require 5 oz Mopar LSD Additive (MS-10111).'),
  (43, 'rear_differential', 2.1, 2.22, 'Dana SAE 80W-90 Axle Lubricant',
   'MaxTow rear axle (3.92 ratio + heavy-duty package): Dana 80W-90 per Mopar OM 2022 p.373.');

-- 7. FIX transfer_case — Mopar OM 2022 says Mobil Fluid LT (48-11 4WD AUTO) or Shell Spirax S2 ATF A389 (48-12 Part-Time)
UPDATE fluid_specs SET
    spec_standard = 'Mobil Fluid LT (48-11 Active On-Demand) or Shell Spirax S2 ATF A389 (48-12 Part-Time)',
    notes = 'Two transfer case variants: BorgWarner 48-11 Active On-Demand 2-speed (4WD AUTO trims) requires Mobil Fluid LT. BW 48-12 Part-Time 2-speed (without 4WD AUTO) requires Shell Spirax S2 ATF A389. Per Mopar OM 2022 p.373.'
  WHERE generation_id = 43 AND fluid_type = 'transfer_case';

-- 8. ADD washer_fluid placeholder
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
VALUES
  (43, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Windshield washer fluid reservoir. Capacity not explicitly published in Mopar OM 2022 — typical Stellantis full-size truck reservoir holds ~5 L. Use winter-rated formula in sub-freezing climates.');

-- 9. Fuel-tank already corrected to 98 L (standard) in mig 365.
-- Mopar OM 2022 lists three variants: 87 L (RegCab Short / Crew Quad std), 98 L (Long std),
-- 121 L (Long optional). Plus 98.5 L for EcoDiesel. These variations are per-trim/configuration.

-- 10. Cite all updated + new fluid rows to the Mopar Ram OM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_ram_om
  FROM fluid_specs fs
  WHERE fs.generation_id = 43;
