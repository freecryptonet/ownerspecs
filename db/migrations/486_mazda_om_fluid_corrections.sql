-- 486: Mazda fluid corrections verified against official Mazda Canada OMs (mazda.ca)
--
-- Audited all 6 Mazda gens against the manufacturer OM PDFs. Many oil/coolant/ATF
-- capacities were lore values that did NOT match the OM (same pattern as CX-90 migs
-- 483-484). Corrections below are each from the model's own Mazda Canada OM.
-- Also: linked NULL-engine trims, fixed two engine-table data errors, added the
-- missing Mazda3 BP OM source.
--
-- Engines NOT in any Canadian OM (left untouched, unverifiable from this source):
--   gen51 2.2 SkyActiv-D diesel (engine 84); gen80 2.5 hybrid A25A (engine 6, 2025 OM);
--   gen95 3.3 e-SkyActiv-D diesel (engine 151). Flagged for a EU-OM / FSM pass.
-- FLAG: gen58 CX-5 has two NA-2.5 engine rows (101 'PYZ8,PYZC' + 102 'PY-Y8') — likely
--   a shadow dup. Not merged here (would need OEM code cross-ref); only fixed 102's data.

-- ============ engines: data-error fixes ============
-- 2.0 SkyActiv-G (PE) compression is 13.0:1 per Mazda3 BM + MX-5 ND OMs (was 14.0).
UPDATE engines SET compression = 13.0 WHERE id = 85;
-- CX-5 NA 2.5 row had 3599 cc (impossible for a 2.5) and NULL compression.
UPDATE engines SET displacement_cc = 2488, compression = 13.0 WHERE id = 102;

-- ============ trims: link NULL engines ============
UPDATE trims SET engine_id = 15  WHERE generation_id = 10 AND id IN (32,33,34) AND engine_id IS NULL; -- Mazda3 2.5 NA
UPDATE trims SET engine_id = 160 WHERE generation_id = 95 AND id IN (378,379) AND engine_id IS NULL;   -- CX-90 3.3 I6 petrol
UPDATE trims SET engine_id = 161 WHERE generation_id = 95 AND id = 381 AND engine_id IS NULL;          -- CX-90 PHEV

-- ============ new source: Mazda3 (BP) Owner's Manual ============
INSERT INTO sources (type, citation, url, public_link, retrieved_at, notes, is_public)
SELECT 'oem_manual', 'Mazda 3 (BP) Owner''s Manual',
       'https://www.mazda.ca/globalassets/mazda-canada/en/pdf/manuals/vehicles/mazda3/2024-mazda3s_manual_en_optimized.pdf',
       1, NOW(), 'Mazda Canada (EN) owner''s manual, manufacturer-hosted on mazda.ca.', 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mazda 3 (BP) Owner''s Manual');
SET @bp_src = (SELECT id FROM sources WHERE citation = 'Mazda 3 (BP) Owner''s Manual' LIMIT 1);

-- ============ gen 10 — Mazda3 BP ============
UPDATE fluid_specs SET capacity_l=4.5, capacity_qt=4.8 WHERE id=1027;                                   -- oil 2.5 NA
UPDATE fluid_specs SET capacity_l=4.8, capacity_qt=5.1, viscosity='5W-30',
       spec_standard='API SP / ILSAC GF-6 (Mazda Genuine 5W-30)' WHERE id=1028;                         -- oil 2.5T (was 0W-20!)
UPDATE fluid_specs SET capacity_l=6.9, capacity_qt=7.3 WHERE id=1029;                                   -- coolant 2.5 NA (AT)
UPDATE fluid_specs SET capacity_l=9.5, capacity_qt=10.0,
       spec_standard='Mazda Long-life Coolant FL22 (green); incl. charge-air-cooler loop' WHERE id=1030;-- coolant 2.5T
UPDATE fluid_specs SET capacity_l=7.6, capacity_qt=8.0 WHERE id=1031;                                   -- ATF 2.5 NA (total)
UPDATE fluid_specs SET capacity_l=8.0, capacity_qt=8.5 WHERE id=1032;                                   -- ATF 2.5T (total)

-- ============ gen 51 — Mazda3 BM ============
UPDATE fluid_specs SET capacity_l=4.5, capacity_qt=4.8 WHERE id=1308;                                   -- oil 2.5
UPDATE fluid_specs SET capacity_l=6.8, capacity_qt=7.2 WHERE id=1311;                                   -- coolant 2.5 (AT)
UPDATE fluid_specs SET capacity_l=6.5, capacity_qt=6.9 WHERE id=1310;                                   -- coolant 2.0 (AT)
UPDATE fluid_specs SET capacity_l=7.8, capacity_qt=8.2 WHERE id=1314;                                   -- ATF 2.5 (total)
UPDATE fluid_specs SET capacity_l=7.8, capacity_qt=8.2 WHERE id=1313;                                   -- ATF 2.0 (total)
UPDATE fluid_specs SET capacity_l=1.7, capacity_qt=1.8, viscosity='75W-80',
       spec_standard='API GL-4 SAE 75W-80 (Mazda Genuine MTF)' WHERE id=1317;                           -- MT 2.5
UPDATE fluid_specs SET capacity_l=1.7, capacity_qt=1.8, viscosity='75W-80',
       spec_standard='API GL-4 SAE 75W-80 (Mazda Genuine MTF)' WHERE id=1316;                           -- MT 2.0

-- ============ gen 58 — CX-5 KF ============
UPDATE fluid_specs SET capacity_l=4.8, capacity_qt=5.1, viscosity='5W-30',
       spec_standard='API SP / ILSAC GF-6 (Mazda Genuine 5W-30)' WHERE id=1035;                         -- oil 2.5T (was 0W-20!)
UPDATE fluid_specs SET capacity_l=8.5, capacity_qt=9.0 WHERE id=1038;                                   -- coolant 2.5T
UPDATE fluid_specs SET capacity_l=7.5, capacity_qt=7.9 WHERE id=1037;                                   -- coolant 2.5 NA (101)
UPDATE fluid_specs SET capacity_l=7.5, capacity_qt=7.9 WHERE id=1036;                                   -- coolant 2.5 NA (102)
UPDATE fluid_specs SET capacity_l=8.0, capacity_qt=8.5 WHERE id=1041;                                   -- ATF 2.5T
UPDATE fluid_specs SET capacity_l=7.8, capacity_qt=8.2 WHERE id=1040;                                   -- ATF 2.5 NA (101)
UPDATE fluid_specs SET capacity_l=7.8, capacity_qt=8.2 WHERE id=1039;                                   -- ATF 2.5 NA (102)

-- ============ gen 80 — CX-50 ============
UPDATE fluid_specs SET capacity_l=4.8, capacity_qt=5.1, viscosity='5W-30',
       spec_standard='API SP / ILSAC GF-6 (Mazda Genuine 5W-30)' WHERE id=1336;                         -- oil 2.5T (was 0W-20!)
UPDATE fluid_specs SET capacity_l=6.8, capacity_qt=7.2 WHERE id=1338;                                   -- coolant 2.5 NA
UPDATE fluid_specs SET capacity_l=10.0, capacity_qt=10.6,
       spec_standard='Mazda Long-life Coolant FL22 (green); incl. charge-air-cooler loop' WHERE id=1339;-- coolant 2.5T
UPDATE fluid_specs SET capacity_l=7.7, capacity_qt=8.1 WHERE id=1341;                                   -- ATF 2.5 NA
UPDATE fluid_specs SET capacity_l=8.0, capacity_qt=8.5 WHERE id=1342;                                   -- ATF 2.5T

-- ============ gen 95 — CX-90 (PHEV coolant only; I6 already matched OM) ============
UPDATE fluid_specs SET capacity_l=9.2, capacity_qt=9.7,
       spec_standard='Mazda Long-life Coolant FL22 (green); engine circuit (EV system separate 6.5 L)' WHERE id=1355;

-- ============ gen 97 — MX-5 ND ============
UPDATE fluid_specs SET capacity_l=4.3, capacity_qt=4.5 WHERE id=754;                                    -- oil
UPDATE fluid_specs SET capacity_l=6.0, capacity_qt=6.3 WHERE id=758;                                    -- coolant
UPDATE fluid_specs SET capacity_l=7.2, capacity_qt=7.6,
       spec_standard='Mazda Genuine ATF (JWS3309 / Aisin AW)' WHERE id=756;                             -- AT (was wrongly ATF FZ)
UPDATE fluid_specs SET capacity_l=2.0, capacity_qt=2.1 WHERE id=755;                                    -- MT
UPDATE fluid_specs SET capacity_l=0.6, capacity_qt=0.63,
       spec_standard='Mazda Long Life Hypoid Gear Oil SG1' WHERE id=757;                                -- rear diff

-- ============ citations: link corrected rows to the model OM source ============
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', x.id, x.src FROM (
  SELECT 1027 id, @bp_src src UNION ALL SELECT 1028,@bp_src UNION ALL SELECT 1029,@bp_src
  UNION ALL SELECT 1030,@bp_src UNION ALL SELECT 1031,@bp_src UNION ALL SELECT 1032,@bp_src
  UNION ALL SELECT 1308,327 UNION ALL SELECT 1311,327 UNION ALL SELECT 1310,327
  UNION ALL SELECT 1314,327 UNION ALL SELECT 1313,327 UNION ALL SELECT 1317,327 UNION ALL SELECT 1316,327
  UNION ALL SELECT 1035,366 UNION ALL SELECT 1038,366 UNION ALL SELECT 1037,366 UNION ALL SELECT 1036,366
  UNION ALL SELECT 1041,366 UNION ALL SELECT 1040,366 UNION ALL SELECT 1039,366
  UNION ALL SELECT 1336,502 UNION ALL SELECT 1338,502 UNION ALL SELECT 1339,502
  UNION ALL SELECT 1341,502 UNION ALL SELECT 1342,502
  UNION ALL SELECT 1355,566
  UNION ALL SELECT 754,573 UNION ALL SELECT 758,573 UNION ALL SELECT 756,573
  UNION ALL SELECT 755,573 UNION ALL SELECT 757,573
) x
WHERE x.src IS NOT NULL;
