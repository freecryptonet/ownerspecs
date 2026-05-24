-- mig 369: fill Grand Cherokee WL (gen 69) fluid gaps from Mopar OM + 4xe Hybrid Supplement
--
-- Existing 11 fluid rows had a wrong Pentastar oil capacity (5.6L → should be 4.7L per
-- Mopar OM 2023 p.323) and an unlinked generic coolant (13.0L); missing per-engine
-- coolant variants + 4xe-specific PHEV coolant loops.
--
-- Sources:
--   - 858: Mopar Jeep Grand Cherokee (WL) 2023 Owner's Manual (gas variants — mig 363)
--   - 866 (NEW below): Mopar Jeep Grand Cherokee 4xe 2023 Hybrid Supplement
-- Both manufacturer-owned CDN, public_link=1 eligible.

-- 1. Index the new GC WL 4xe Hybrid Supplement PDF
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
SELECT 'manuals/Jeep_GrandCherokee_WL_4xe_2023_Supplement_Mopar.pdf',
       SHA2('placeholder_gc_wl_4xe_supp_2023', 256),
       'owner', 'Jeep', 'Grand Cherokee 4xe', 2023, 2023,
       '5634505', 'P68602258AB_DIGITAL_E3', NULL,
       'en-US', 'US', 68,
       'Jeep Grand Cherokee 4xe 2023 Hybrid Supplement', NOW(),
       'Mopar 4xe Supplement OM. Covers PHEV-specific systems for the WL 4xe (2.0L turbo I4 + PHEV electric drive). Companion to main WL OM (5754794).'
WHERE NOT EXISTS (SELECT 1 FROM manual_inventory WHERE file_path = 'manuals/Jeep_GrandCherokee_WL_4xe_2023_Supplement_Mopar.pdf');

INSERT INTO sources (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
SELECT 'oem_manual',
       'Jeep Grand Cherokee 4xe (WL PHEV) 2023 Owner''s Manual Supplement',
       NULL, mi.id, 1, 1, NOW(),
       'Mopar 4xe Hybrid Supplement; PHEV-specific data for WL chassis.'
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/Jeep_GrandCherokee_WL_4xe_2023_Supplement_Mopar.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources s WHERE s.manual_inventory_id = mi.id);

SET @s_gc_4xe   := (SELECT s.id FROM sources s JOIN manual_inventory mi ON s.manual_inventory_id = mi.id
                    WHERE mi.file_path = 'manuals/Jeep_GrandCherokee_WL_4xe_2023_Supplement_Mopar.pdf');

SET @e_pentastar := 138;   -- 3.6L Pentastar V6
SET @e_57hemi    := 166;   -- 5.7L HEMI V8
SET @e_64hemi    := 167;   -- 6.4L HEMI 392 V8 (limited-production SRT, retained for now)
SET @e_20gas     := 187;   -- 2.0L Hurricane I4 turbo (gas, used on WL non-PHEV 2.0L trim)
SET @e_4xe       := 203;   -- 2.0L Hurricane + 4xe PHEV
SET @s_gc_om     := 858;   -- Mopar GC WL 2023 OM

-- 2. Fix Pentastar oil row: 5.6 L → 4.7 L (Mopar OM 2023 p.323 lists 5 qt = 4.7 L)
UPDATE fluid_specs SET
    capacity_l = 4.7,
    capacity_qt = 5.0,
    spec_standard = 'API SP / Chrysler MS-6395; SAE 0W-20',
    notes = '3.6L Pentastar V6: 4.7 L (5 qt) with filter, SAE 0W-20 per Mopar OM 2023 p.323. Same engine in Pacifica + Wrangler JL + Ram 1500 DT.'
  WHERE generation_id = 69 AND fluid_type = 'engine_oil' AND engine_id = @e_pentastar;

-- 3. ADD 2.0L Hurricane gas engine_oil (gas non-PHEV trim — same engine block as 4xe)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  (69, @e_20gas, 'engine_oil', 4.7, 5.0, '5W-30',
   'API SP / GF-6A; Chrysler MS-13340; SAE 5W-30 full synthetic',
   '2.0L Hurricane I4 turbo (gas, non-PHEV): 4.7 L (5 qt) with filter, SAE 5W-30 full synthetic API SP/GF-6A per Mopar OM 2023 p.323. Same physical engine as 4xe but in non-hybrid trim.');

-- 4. UPDATE existing coolant: link Pentastar + correct capacity (10.4 L w/o TTP)
UPDATE fluid_specs SET
    engine_id = @e_pentastar,
    capacity_l = 10.4,
    capacity_qt = 11.0,
    spec_standard = 'Mopar OAT 10yr/150k (FCA MS.90032)',
    notes = '3.6L Pentastar V6 cooling without Trailer Tow Package: 10.4 L (11 qt) per Mopar OM 2023 p.323. Includes heater + recovery bottle.'
  WHERE generation_id = 69 AND fluid_type = 'coolant' AND engine_id IS NULL;

-- 5. ADD coolant rows: 2.0L gas + 2.0L intercooler + Pentastar w/ TTP + 5.7L HEMI
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (69, @e_20gas, 'coolant', 9.8, 10.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Hurricane I4 (gas) engine cooling: 9.8 L (10.4 qt) per Mopar OM 2023 p.323.'),
  (69, @e_20gas, 'inverter_coolant', 4.2, 4.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L Intercooler / Power Electronics Coolant loop (gas non-PHEV): 4.2 L (4.4 qt) per Mopar OM 2023 p.323. Separate small loop for charge-air cooling + electronics.'),
  (69, @e_pentastar, 'coolant', 10.9, 11.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '3.6L Pentastar V6 WITH Trailer Tow Package: 10.9 L (11.5 qt) — adds auxiliary cooling capacity vs base 10.4 L.'),
  (69, @e_57hemi, 'coolant', 14.2, 15.0, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '5.7L HEMI V8 cooling: 14.2 L (15 qt) per Mopar OM 2023 p.323.');

-- 6. ADD 4xe PHEV-specific cooling (linked to trim 288 if present, else engine_4xe)
INSERT INTO fluid_specs (generation_id, trim_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes)
VALUES
  (69, 288, @e_4xe, 'coolant', 11.7, 12.4, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '2.0L 4xe PHEV engine cooling: 11.7 L (12.4 qt) per Mopar GC 4xe Hybrid Supplement 2023 p.59. Larger than 2.0L gas variant (9.8 L) due to additional PHEV thermal management.'),
  (69, 288, @e_4xe, 'inverter_coolant', 5.2, 5.5, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   '4xe combined Intercooler / Power Electronics Coolant loop: 5.2 L (5.5 qt) per 4xe Supplement p.59. Single combined loop covers both intercooler AND PCU (distinct from Pacifica Hybrid which uses separate loops). Dealer-only service — special tool required.'),
  (69, 288, @e_4xe, 'battery_coolant', 5.5, 5.8, 'Mopar OAT 10yr/150k (FCA MS.90032)',
   'HV battery coolant loop: 5.5 L (5.8 qt) per 4xe Supplement p.59. Dealer-only service.');

-- 7. ADD washer_fluid placeholder
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
VALUES
  (69, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Windshield washer reservoir. Capacity not explicitly published in Mopar OM 2023.');

-- 8. Cite all GC WL fluid rows to Mopar OM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_gc_om
  FROM fluid_specs fs
  WHERE fs.generation_id = 69;

-- 4xe-specific rows also cite the Hybrid Supplement
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, @s_gc_4xe
  FROM fluid_specs fs
  WHERE fs.generation_id = 69 AND fs.trim_id = 288;
