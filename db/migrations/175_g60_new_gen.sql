-- G60 5-Series new generation (eighth-gen, MY2024-onwards).
--
-- The G60 launched mid-2023 for MY2024 globally, replacing G30 LCI (gen 127).
-- It rides on BMW's CLAR-2 architecture and ships with the BMW Curved Display
-- + iDrive 8.5 standard. The lineup mixes mild-hybrid 48V petrol, mild-hybrid
-- 48V diesel, and plug-in hybrids, plus a parallel-tracked i5 BEV (i5
-- eDrive40 / xDrive40 / M60 xDrive) that uses the same body but a different
-- drivetrain — i5 is treated as a SEPARATE model entry on ownerspecs.com
-- (deferred to a later batch) so this gen covers ICE + PHEV only.
--
-- Dimensions sourced from auto-data.net (G60 generation page + 530i trim
-- page) — gen is ~100 mm longer, 30 mm wider, 35 mm taller than G30 LCI.
-- OEM specs (oil LL-22 FE++ / coolant LC-18) cross-verified across BMW US
-- 2024, 2025 and 2026 owner's manuals downloaded locally.

SET NAMES utf8mb4;

SET @model_id := (SELECT id FROM models WHERE slug = '5-series');
SET @next_ord := (SELECT COALESCE(MAX(ordinal), 0) + 1 FROM generations WHERE model_id = @model_id);

INSERT INTO generations (
  model_id, slug, ordinal, codename, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_id,
  '5-series-g60-sedan-2023-present',
  @next_ord,
  'G60',
  'G60',
  'Sedan',
  2023,
  NULL,
  'AWD',
  'BMW CLAR-2',
  'The G60 is the eighth-generation BMW 5 Series sedan, launched mid-2023 for the 2024 model year. The platform — BMW Group''s second-generation CLAR architecture — is shared with the parallel-tracked i5 fully-electric sedan, allowing one body and two drivetrain families (combustion / plug-in hybrid in the G60, dual-motor BEV in the i5). Externally the G60 is identified by the illuminated kidney grille frame, slim split LED headlights, and a 100 mm increase in overall length over the G30 LCI predecessor.\n\nThe interior is dominated by the BMW Curved Display — a single curved glass panel housing the 12.3-inch digital cluster and 14.9-inch infotainment screen, both running iDrive 8.5. Physical heating, ventilation, drive-mode and volume controls are largely consolidated into the touchscreen, with a slimmed-down centre console retained for gear selection and the iDrive rotary controller.\n\nThe powertrain lineup at launch covers four families: petrol mild-hybrids (520i, 530i — B48 four-cylinder with 48V integrated starter-generator), petrol mild-hybrid inline-six (540i — B58), petrol plug-in hybrids (530e RWD and xDrive with B48 + electric motor; 550e xDrive flagship with B58 + electric for 489 hp combined), and diesel mild-hybrids (520d / 540d xDrive on B47 / B57). All G60 ICE engines use BMW Longlife-22 FE++ engine oil from launch — a new low-friction grade introduced specifically for this generation — and BMW LC-18 coolant (the same long-life formula adopted in the late G30 LCI MY2023 run). All G60 variants pair to the ZF 8HP-built BMW 8-speed automatic, which is the only transmission offered. Production is at BMW Group Dingolfing (Germany) for global supply.\n\nThis ownerspecs.com generation page covers ICE + plug-in hybrid trims only. For the fully-electric i5 (eDrive40, xDrive40, M60 xDrive), see the dedicated i5 model entry.',
  5060, 1900, 1515, 2995,
  1623, 1656, 60, 520,
  'Double-wishbone, with anti-roll bar',
  'Multi-link, with anti-roll bar',
  'Ventilated disc',
  'Ventilated disc',
  1
);

SET @gen_g60 := (SELECT id FROM generations WHERE slug = '5-series-g60-sedan-2023-present');

SELECT @gen_g60 AS gen_id, @next_ord AS ordinal;
