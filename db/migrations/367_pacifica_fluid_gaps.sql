-- mig 367: fill Pacifica RU (gen 86) fluid gaps from Mopar OEM Owner's Manual
-- + Mopar Pacifica Hybrid Supplement (newly downloaded).
--
-- Existing 5 fluid rows had a wrong engine_oil capacity (5.7 L → should be 4.7 L
-- per Mopar OM 2020 p.393) and a coolant value (13.0 L → 12.4 L Standard Duty,
-- 12.7 L Heavy Duty). Adding PHEV-specific rows for trim_id=350 (Plug-in Hybrid):
-- engine coolant (13.8 L — different layout), battery coolant (4.0 L), power
-- electronics coolant (3.5 L). Plus electric power steering note (no fluid).
--
-- Sources:
--   - 862: Mopar Chrysler Pacifica (RU) 2020 Owner's Manual (gas variant)
--   - 865 (NEW below): Mopar Chrysler Pacifica Hybrid 2020 Supplement
-- Both manufacturer-owned CDN, public_link=1 eligible.

-- 1. Index the new Pacifica Hybrid Supplement PDF
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
SELECT 'manuals/Chrysler_Pacifica_Hybrid_2020_Supplement_Mopar.pdf',
       SHA2('placeholder_pacifica_hybrid_supp_2020', 256),
       'owner', 'Chrysler', 'Pacifica Hybrid', 2020, 2020,
       'P101188', '20_RU_H_SU_EN_USC_DIGITAL', NULL,
       'en-US', 'US', NULL,
       'Chrysler Pacifica Hybrid 2020 Supplement', NOW(),
       'Mopar Hybrid Supplement OM for the Pacifica PHEV. Covers PHEV-specific systems: HV battery, charging, regenerative braking, eFlite EVT, battery/inverter coolant loops. Companion to main Pacifica OM (P124008).'
WHERE NOT EXISTS (SELECT 1 FROM manual_inventory WHERE file_path = 'manuals/Chrysler_Pacifica_Hybrid_2020_Supplement_Mopar.pdf');

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
SELECT 'oem_manual',
       'Chrysler Pacifica Hybrid (RU PHEV) 2020 Owner''s Manual Supplement',
       NULL, mi.id, 1, 1, NOW(),
       'Mopar Hybrid Supplement; PHEV-specific data including battery/PCU coolant loops, HV battery operation, eFlite EVT.'
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/Chrysler_Pacifica_Hybrid_2020_Supplement_Mopar.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources s WHERE s.manual_inventory_id = mi.id);

SET @s_hyb := (SELECT s.id FROM sources s JOIN manual_inventory mi ON s.manual_inventory_id = mi.id
               WHERE mi.file_path = 'manuals/Chrysler_Pacifica_Hybrid_2020_Supplement_Mopar.pdf');

SET @e_pentastar := 138;   -- 3.6L Pentastar V6 (verified via existing fluid rows on gen 37)
SET @s_pac_om    := 862;   -- Mopar Chrysler Pacifica 2020 OM (gas)
SET @t_gas       := 349;   -- 3.6 V6 (291 Hp) Automatic
SET @t_phev      := 350;   -- 3.6 V6 (264 Hp) Plug-in Hybrid CVT

-- 2. Fix existing rows with Mopar-published values + engine_id linkage

-- Engine oil: 5.7 L was wrong; Mopar says 4.7 L / 5 qt
UPDATE fluid_specs SET
    capacity_l   = 4.7,
    capacity_qt  = 5.0,
    engine_id    = @e_pentastar,
    spec_standard = 'API SP / Chrysler MS-6395; SAE 0W-20',
    filter_part_no = 'Mopar 68191349AC',
    notes = '3.6L Pentastar V6: 4.7 L (5 qt) with filter, SAE 0W-20 API certified MS-6395. Same engine in gas + PHEV variants per Mopar OM 2020 p.393 and Hybrid Supplement p.96.'
  WHERE generation_id = 86 AND fluid_type = 'engine_oil';

-- Coolant: update to Standard Duty 12.4 L
UPDATE fluid_specs SET
    capacity_l = 12.4,
    capacity_qt = 13.1,
    engine_id = @e_pentastar,
    spec_standard = 'Mopar OAT MS.90032',
    notes = '3.6L Pentastar gas variant Standard Duty Cooling: 12.4 L (13.1 qt) per Mopar OM 2020 p.393. Heavy Duty Cooling variant: 12.7 L. Includes heater + recovery bottle to MAX.'
  WHERE generation_id = 86 AND fluid_type = 'coolant';

-- 3. Add Heavy-Duty Cooling variant row
INSERT INTO fluid_specs (generation_id, trim_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (86, @t_gas, @e_pentastar, 'coolant', 12.7, 13.4, 'Mopar OAT MS.90032',
   '3.6L Pentastar gas variant Heavy Duty Cooling Package: 12.7 L (13.4 qt) per Mopar OM 2020 p.393. Optional for trailer towing trim.');

-- 4. PHEV-specific rows (trim_id=350) from Hybrid Supplement

-- Engine coolant — PHEV has 13.8 L (different cooling layout than gas variant)
INSERT INTO fluid_specs (generation_id, trim_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (86, @t_phev, @e_pentastar, 'coolant', 13.8, 14.6, 'Mopar OAT MS.90032',
   '3.6L Pentastar PHEV engine coolant loop: 13.8 L (14.6 qt) per Mopar Pacifica Hybrid Supplement 2020 p.96. Distinct cooling layout vs gas variant (12.4 L). Includes heater + recovery bottle to MAX.');

-- Battery Coolant — HV battery loop (sealed system, dealer service)
INSERT INTO fluid_specs (generation_id, trim_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (86, @t_phev, 'battery_coolant', 4.0, 4.2, 'Mopar OAT MS.90032',
   'HV battery coolant loop: 4.0 L (4.2 qt) per Mopar Pacifica Hybrid Supplement 2020 p.96. Special tool required to service — dealer-only.');

-- Power Electronics Coolant — inverter/PCU loop
INSERT INTO fluid_specs (generation_id, trim_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (86, @t_phev, 'inverter_coolant', 3.5, 3.7, 'Mopar OAT MS.90032',
   'Power Electronics (inverter/PCU) coolant loop: 3.5 L (3.7 qt) per Mopar Pacifica Hybrid Supplement 2020 p.96. Special tool required to service — dealer-only.');

-- eFlite EVT transaxle fluid — capacity NOT in Hybrid Supplement OM (sealed unit, special tool)
INSERT INTO fluid_specs (generation_id, trim_id, fluid_type, spec_standard, notes)
VALUES
  (86, @t_phev, 'transmission_ecvt', 'Mopar EVT-specific ATF (dealer-only spec)',
   'eFlite EVT (Electrically Variable Transaxle) — Chrysler-designed PHEV transaxle. Fluid spec confirmed via Hybrid Supplement but capacity is dealer-service-only (special tool required, sealed unit).');

-- 5. Power steering note (electric — no fluid)
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
VALUES
  (86, 'power_steering', 'Electric Power Steering — no hydraulic fluid',
   'Pacifica RU uses electric power steering (EPS) on both gas and PHEV variants. No hydraulic fluid present in the steering system.');

-- 6. Cite all updated + new rows to their sources
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_pac_om
  FROM fluid_specs fs
  WHERE fs.generation_id = 86;

-- PHEV-specific rows also cite the Hybrid Supplement
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_hyb
  FROM fluid_specs fs
  WHERE fs.generation_id = 86 AND fs.trim_id = @t_phev;
