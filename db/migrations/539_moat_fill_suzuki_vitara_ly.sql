-- mig 539 — moat-fill Suzuki Vitara LY (2015-present) from EN OMs.
-- Sources: Vitara-WEB_99011U74SB6-02E.pdf + Vitara_2024MC_WEB_99011U74SE0-25D.pdf
-- (Suzuki proprietary; aggregator-hosted PDFs, public_link=0).
-- Source row 851 already exists; fix the truncated citation. Engines:
--   2030 = K14C 1.4 BoosterJet (turbo);
--   2031 = K14D 1.4 Smart Hybrid BoosterJet;
--   2033 = K15C 1.5 Smart Hybrid.

SET NAMES utf8mb4;

SET @gen := 331;
SET @src := 851;

-- Fix truncated citation.
UPDATE sources SET citation='Suzuki Vitara Owner''s Manual (MY24, edition 99011U74SE0-25D)',
                   notes='Suzuki Vitara LY OEM Owner''s Manual covering MY15-24 (2024MC edition 99011U74SE0-25D verified). Reference for service intervals, fluid grades, lighting and tire pressures. Aggregator-hosted; public_link=0.'
WHERE id=@src;

-- Existing rows (3491-3495) are correct; refine notes + attach page numbers,
-- correct coolant months (96 not 120 per Vitara EN OM p.7-25).
UPDATE service_intervals SET miles_normal=9300, km_normal=15000, months=12,
  notes='Engine oil + filter every 15,000 km (9,300 mi) or 12 mo per Suzuki Vitara EN OM (Periodic Maintenance Schedule). All petrol K-series.'
WHERE id=3491;

UPDATE service_intervals SET miles_normal=37000, km_normal=60000,
  notes='Engine air cleaner element: replace every 60,000 km (37,000 mi); paved-road inspection every 15,000 km per Suzuki Vitara EN OM.'
WHERE id=3492;

UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months (time-based, not mileage) per Suzuki Vitara EN OM.'
WHERE id=3493;

UPDATE service_intervals SET miles_normal=65000, km_normal=105000,
  notes='Iridium spark plugs: replace every 105,000 km (65,000 mi) per Suzuki Vitara EN OM. Applies to K14C / K14D / K15C — Suzuki K-series iridium spec.'
WHERE id=3494;

UPDATE service_intervals SET miles_normal=93000, km_normal=150000, months=96,
  notes='Engine coolant (Suzuki LLC Super Blue): first time at 150,000 km (90,000 mi) or 96 mo; subsequent every 75,000 km / 48 mo. Standard Green coolant: every 40,000 km / 36 mo. Suzuki Vitara EN OM.'
WHERE id=3495;

-- Attach page numbers to existing spec_sources (idempotent).
UPDATE spec_sources SET page_number=46 WHERE spec_table='service_intervals' AND spec_id=3491 AND source_id=@src;
UPDATE spec_sources SET page_number=55 WHERE spec_table='service_intervals' AND spec_id=3492 AND source_id=@src;
UPDATE spec_sources SET page_number=63 WHERE spec_table='service_intervals' AND spec_id=3493 AND source_id=@src;
UPDATE spec_sources SET page_number=58 WHERE spec_table='service_intervals' AND spec_id=3494 AND source_id=@src;
UPDATE spec_sources SET page_number=53 WHERE spec_table='service_intervals' AND spec_id=3495 AND source_id=@src;

-- New service intervals captured in the OM.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'accessory_drive_belt_replacement', 48000, 80000, 96,   'Engine accessory drive belt: inspect every 40,000 km / 48 mo, replace every 80,000 km (48,000 mi) / 96 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'fuel_filter',                      63000,105000, NULL, 'Fuel filter (in-tank): replace every 105,000 km (63,000 mi) per Suzuki Vitara EN OM. (Russia-spec models exempt.)'),
  (@gen, NULL, 'pcv_valve_inspection',             54000, 90000, 108,  'PCV valve inspection every 90,000 km (54,000 mi) or 108 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'transfer_case_fluid_inspection',   18000, 30000, 24,   '4WD only: transfer oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'transfer_case_fluid_change',       90000,150000, 120,  '4WD only: transfer oil replacement every 150,000 km (90,000 mi) or 120 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'rear_differential_fluid_inspection', 18000, 30000, 24, '4WD only: rear differential oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'rear_differential_fluid_change',   90000,150000, 120,  '4WD only: rear differential oil replacement every 150,000 km (90,000 mi) or 120 mo per Suzuki Vitara EN OM.'),
  (@gen, NULL, 'brake_hose_inspection',            18000, 30000, 24,   'Brake hoses and pipes: inspect every 30,000 km (18,000 mi) or 24 mo per Suzuki Vitara EN OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'accessory_drive_belt_replacement'    THEN 45
         WHEN 'fuel_filter'                         THEN 62
         WHEN 'pcv_valve_inspection'                THEN 25
         WHEN 'transfer_case_fluid_inspection'      THEN 60
         WHEN 'transfer_case_fluid_change'          THEN 60
         WHEN 'rear_differential_fluid_inspection'  THEN 60
         WHEN 'rear_differential_fluid_change'      THEN 60
         WHEN 'brake_hose_inspection'               THEN 63
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('accessory_drive_belt_replacement','fuel_filter','pcv_valve_inspection','transfer_case_fluid_inspection','transfer_case_fluid_change','rear_differential_fluid_inspection','rear_differential_fluid_change','brake_hose_inspection')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
