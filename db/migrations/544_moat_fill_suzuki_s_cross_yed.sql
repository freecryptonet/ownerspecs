-- mig 544 — moat-fill Suzuki S-Cross YED (2022-present) from EN OM.
-- Source: S-CrossWEB_99011-83RB4-01E.pdf (Suzuki EN OM for YED).
-- Source rows 844 (MY-min typo) and 850 (MYssed typo) both exist for YED.
-- Use 850 (newer MY24 edition); fix its citation. Engines:
--   2030 K14C 1.4 BoosterJet; 2031 K14D 1.4 Smart Hybrid BoosterJet;
--   2033 K15C 1.5 Smart Hybrid.
--
-- IMPORTANT: YED has DIFFERENT intervals than earlier S-Cross (JY) and
-- Vitara (LY) — corrections applied to coolant and spark plugs.

SET NAMES utf8mb4;

SET @gen := 328;
SET @src := 850;

UPDATE sources SET citation='Suzuki S-Cross Owner''s Manual (YED, MY24 edition 99011U63TD0-25D)',
                   notes='Suzuki S-Cross YED EN Owner''s Manual (2022+, MY24 edition). K14C / K14D / K15C powertrains, 20k-km column interval schedule. Aggregator-hosted; public_link=0.'
WHERE id=@src;

-- Fix existing rows per S-Cross YED OM (table headers: 20k/40k/60k/80k/100k/120k km).
UPDATE service_intervals SET miles_normal=9300, km_normal=15000, months=12,
  notes='Engine oil + filter: with non-ACEA oil every 15k km (9.3k mi); with ACEA / Suzuki Genuine every 20k km (12.5k mi). 12 mo or oil-change message. Suzuki S-Cross YED EN OM.'
WHERE id=3501;

-- Air filter is REPLACE every 60k km (R at col 3 of 6, 20k-km columns); existing 60k km value is correct.
UPDATE service_intervals SET miles_normal=37000, km_normal=60000,
  notes='Engine air cleaner: replace every 60,000 km (37,000 mi); paved-road inspection every 20,000 km (12,500 mi) / 12 mo per Suzuki S-Cross YED EN OM.'
WHERE id=3502;

UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months (time-based, not mileage) per Suzuki S-Cross YED EN OM.'
WHERE id=3503;

-- CORRECT spark plugs from 65k mi / 105k km to 37k mi / 60k km (YED-specific iridium spec).
UPDATE service_intervals SET miles_normal=37000, km_normal=60000, months=36,
  notes='Iridium spark plugs: replace every 60,000 km (37,000 mi) or 36 mo per Suzuki S-Cross YED EN OM. NB: YED uses shorter interval than older Suzuki K-series (105k km on JY/LY/JB64).'
WHERE id=3504;

-- CORRECT coolant from 93k mi / 150k km / 120 mo to 100k mi / 160k km / 96 mo (YED-specific).
UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=96,
  notes='Engine coolant (Suzuki LLC Super Blue): first time at 160,000 km (100,000 mi) or 96 mo; subsequent every 80,000 km / 48 mo. Standard Green: 40,000 km / 36 mo. YED interval is longer than older S-Cross (150k/75k). Suzuki S-Cross YED EN OM.'
WHERE id=3505;

-- Move existing spec_sources from 844 → 850 (the MY24 canonical citation).
UPDATE spec_sources SET source_id=@src
WHERE spec_table='service_intervals' AND spec_id IN (3501,3502,3503,3504,3505) AND source_id=844;

UPDATE spec_sources SET page_number=358 WHERE spec_table='service_intervals' AND spec_id=3501 AND source_id=@src;
UPDATE spec_sources SET page_number=363 WHERE spec_table='service_intervals' AND spec_id=3502 AND source_id=@src;
UPDATE spec_sources SET page_number=372 WHERE spec_table='service_intervals' AND spec_id=3503 AND source_id=@src;
UPDATE spec_sources SET page_number=363 WHERE spec_table='service_intervals' AND spec_id=3504 AND source_id=@src;
UPDATE spec_sources SET page_number=361 WHERE spec_table='service_intervals' AND spec_id=3505 AND source_id=@src;

INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'accessory_drive_belt_replacement', 50000, 80000, 48,   'Engine accessory drive belt: replace every 80,000 km (50,000 mi) or 48 mo per Suzuki S-Cross YED EN OM (R at col 4 of 20k-km schedule).'),
  (@gen, NULL, 'fuel_filter',                      63000,105000, NULL, 'Fuel filter (in-tank): replace every 105,000 km (63,000 mi) per Suzuki S-Cross YED EN OM.'),
  (@gen, NULL, 'pcv_valve_inspection',             50000, 80000, 48,   'PCV valve inspection every 80,000 km (50,000 mi) or 48 mo per Suzuki S-Cross YED EN OM.'),
  (@gen, NULL, 'transfer_case_fluid_inspection',   25000, 40000, 24,   'AllGrip 4WD only: transfer oil inspection every 40,000 km (25,000 mi) or 24 mo per Suzuki S-Cross YED EN OM.'),
  (@gen, NULL, 'rear_differential_fluid_inspection',25000, 40000, 24,  'AllGrip 4WD only: rear differential oil inspection every 40,000 km (25,000 mi) or 24 mo per Suzuki S-Cross YED EN OM.'),
  (@gen, NULL, 'brake_hose_inspection',            18000, 30000, 24,   'Brake hoses and pipes: inspect every 30,000 km (18,000 mi) or 24 mo per Suzuki S-Cross YED EN OM.'),
  (@gen, NULL, 'tire_pressure_check',              NULL,  NULL,  1,    'Check tire pressures monthly (cold pressure, including spare) per Suzuki S-Cross YED EN OM tire section.'),
  (@gen, NULL, 'fluid_level_check',                NULL,  NULL,  1,    'Check engine oil, coolant, brake fluid, washer fluid monthly per Suzuki S-Cross YED EN OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'accessory_drive_belt_replacement'    THEN 362
         WHEN 'fuel_filter'                         THEN 363
         WHEN 'pcv_valve_inspection'                THEN 363
         WHEN 'transfer_case_fluid_inspection'      THEN 367
         WHEN 'rear_differential_fluid_inspection'  THEN 367
         WHEN 'brake_hose_inspection'               THEN 372
         WHEN 'tire_pressure_check'                 THEN 375
         WHEN 'fluid_level_check'                   THEN 358
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('accessory_drive_belt_replacement','fuel_filter','pcv_valve_inspection','transfer_case_fluid_inspection','rear_differential_fluid_inspection','brake_hose_inspection','tire_pressure_check','fluid_level_check')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
