-- mig 370: fill Wrangler JL (gen 37) fluid gaps from Mopar OM + 4xe Hybrid Supplement
--
-- Existing 10 fluid rows had a wrong Pentastar oil viscosity (5W-20 in DB but Mopar
-- OM 2020 p.286 explicitly says SAE 0W-20 for the 3.6L Pentastar in JL) and only
-- one generic coolant row. Multiple Mopar-published coolant variants missing:
-- 2.0L engine + 2.0L Intercooler w/wo MGU + 2.0L Battery Coolant + 3.6L MGU +
-- 3.6L Battery Coolant. Plus full 4xe PHEV coolant set absent.
--
-- Sources:
--   - 864: Mopar Wrangler JL 2020 OM (mig 363)
--   - 867 (NEW below): Mopar Wrangler 4xe 2023 Hybrid Supplement
-- Both manufacturer-owned CDN, public_link=1 eligible.

-- 1. Index Wrangler 4xe Hybrid Supplement
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
SELECT 'manuals/Jeep_Wrangler_JL_4xe_2023_Supplement_Mopar.pdf',
       SHA2('placeholder_jl_4xe_supp_2023', 256),
       'owner', 'Jeep', 'Wrangler 4xe', 2023, 2023,
       'P139881', '23_JL_H_SU_EN_USC_DIGITAL', NULL,
       'en-US', 'US', 80,
       'Jeep Wrangler 4xe 2023 Hybrid Supplement', NOW(),
       'Mopar 4xe Supplement OM for JL Wrangler PHEV. Covers HV battery, charging, regen, PHEV-specific fluids. Companion to main JL OM.'
WHERE NOT EXISTS (SELECT 1 FROM manual_inventory WHERE file_path = 'manuals/Jeep_Wrangler_JL_4xe_2023_Supplement_Mopar.pdf');

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
SELECT 'oem_manual',
       'Jeep Wrangler 4xe (JL PHEV) 2023 Owner''s Manual Supplement',
       NULL, mi.id, 1, 1, NOW(),
       'Mopar 4xe Hybrid Supplement; PHEV-specific data for JL Wrangler chassis.'
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/Jeep_Wrangler_JL_4xe_2023_Supplement_Mopar.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources s WHERE s.manual_inventory_id = mi.id);

SET @s_jl_4xe := (SELECT s.id FROM sources s JOIN manual_inventory mi ON s.manual_inventory_id = mi.id
                  WHERE mi.file_path = 'manuals/Jeep_Wrangler_JL_4xe_2023_Supplement_Mopar.pdf');
SET @e_pentastar := 138;
SET @e_20hurricane := 187;
SET @e_4xe := 203;
SET @s_jl_om := 864;

-- 2. Fix Pentastar oil viscosity: 5W-20 → 0W-20 (Mopar OM 2020 p.286 explicit)
UPDATE fluid_specs SET
    viscosity = '0W-20',
    spec_standard = 'API SP / Chrysler MS-6395; SAE 0W-20',
    notes = '3.6L Pentastar V6: 4.73 L (5 qt) with filter, SAE 0W-20 API SP per Mopar OM 2020 p.286. Note: viscosity is 0W-20, NOT 5W-20 — Wrangler-specific Mopar spec MS-6395.'
  WHERE generation_id = 37 AND fluid_type = 'engine_oil' AND engine_id = @e_pentastar;

-- 3. Link existing generic coolant row to Pentastar engine
UPDATE fluid_specs SET
    engine_id = @e_pentastar,
    capacity_l = 10.6,
    capacity_qt = 11.2,
    spec_standard = 'Mopar OAT 10yr/150k (FCA MS.90032)',
    notes = '3.6L Pentastar V6 engine cooling system: 10.6 L (11.2 qt) per Mopar OM 2020 p.285. Includes coolant recovery bottle to MAX.'
  WHERE generation_id = 37 AND fluid_type = 'coolant' AND engine_id IS NULL;

-- 4. ADD coolant variants from Mopar OM (gas)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (37, @e_20hurricane, 'coolant', 9.7, 10.3, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Hurricane I4 turbo engine cooling: 9.7 L (10.3 qt) per Mopar OM 2020 p.285. Smaller than Pentastar V6 (10.6 L).'),
  (37, @e_20hurricane, 'inverter_coolant', 3.0, 3.2, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Intercooler coolant loop (without Motor Generator Unit / non-eTorque): 3.0 L (3.2 qt) per Mopar OM 2020 p.285.'),
  (37, @e_20hurricane, 'inverter_coolant', 3.3, 3.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Intercooler coolant loop WITH Motor Generator Unit (eTorque MHEV): 3.3 L (3.5 qt) per Mopar OM 2020 p.285. Larger than non-MGU variant to support MGU thermal load.'),
  (37, @e_20hurricane, 'battery_coolant', 2.4, 2.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L 48V MHEV battery coolant (eTorque trims only): 2.4 L (2.5 qt) per Mopar OM 2020 p.285. Separate small loop for the eTorque belt-starter-generator 48V battery.'),
  (37, @e_pentastar, 'inverter_coolant', 1.8, 1.9, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar Motor Generator Unit (MGU) coolant loop (eTorque trims only): 1.8 L (1.9 qt) per Mopar OM 2020 p.285.'),
  (37, @e_pentastar, 'battery_coolant', 2.4, 2.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar 48V MHEV battery coolant (eTorque trims only): 2.4 L (2.5 qt) per Mopar OM 2020 p.285.');

-- 5. ADD 4xe PHEV-specific fluids (engine_id 203, no trim_id since 4xe trim not in DB)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  (37, @e_4xe, 'engine_oil', 4.7, 5.0, '5W-30',
   'API SP / GF-6A; SAE 5W-30 full synthetic',
   '2.0L Hurricane 4xe PHEV: 4.7 L (5 qt) with filter, SAE 5W-30 API SP/GF-6A per Mopar Wrangler 4xe Hybrid Supplement 2023 p.69. Same physical engine block as gas 2.0L (engine 187) but in PHEV configuration.'),
  (37, @e_4xe, 'coolant', 11.8, 12.5, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L 4xe PHEV engine cooling: 11.8 L (12.5 qt) per Mopar Wrangler 4xe Supplement 2023 p.69. Larger than gas 2.0L (9.7 L) due to PHEV thermal management.'),
  (37, @e_4xe, 'battery_coolant', 5.3, 5.6, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '4xe HV battery coolant loop: 5.3 L (5.6 qt) per Mopar Wrangler 4xe Supplement 2023 p.69. Dealer-only service — special tool required.'),
  (37, @e_4xe, 'inverter_coolant', 5.4, 5.7, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '4xe Power Electronics Coolant loop: 5.4 L (5.7 qt) per Mopar Wrangler 4xe Supplement 2023 p.69. Note: JL 4xe uses SEPARATE battery + power-electronics loops (like Pacifica Hybrid), distinct from GC 4xe which combines intercooler + power-electronics in one loop.');

-- 6. ADD washer_fluid placeholder
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
VALUES
  (37, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Washer reservoir. Capacity not explicitly published in Mopar OM 2020.');

-- 7. Cite all gen 37 fluid rows to Mopar JL OM (source 864)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_jl_om
  FROM fluid_specs fs
  WHERE fs.generation_id = 37;

-- 4xe-specific rows also cite the 4xe Supplement
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_jl_4xe
  FROM fluid_specs fs
  WHERE fs.generation_id = 37 AND fs.engine_id = @e_4xe;
