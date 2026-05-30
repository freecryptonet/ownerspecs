-- mig 543 — moat-fill Suzuki Ignis MF (2016-present) from EN OM.
-- Source: Ignis-WEB_99011-73SB7-01E.pdf (Suzuki EN OM).
-- Source row 848 already exists with truncated citation; fix here.
-- Engines: 2027 K12C 1.2 DualJet; 2028 K12D 1.2 Smart Hybrid; 2029 K12B (older).

SET NAMES utf8mb4;

SET @gen := 325;
SET @src := 848;

-- Fix truncated citation.
UPDATE sources SET citation='Suzuki Ignis Owner''s Manual (MF, edition 99011-73SB7-01E)',
                   notes='Suzuki Ignis MF EN Owner''s Manual. Service intervals, fluid grades, lighting and tire pressures for K12-series engines. Aggregator-hosted; public_link=0.'
WHERE id=@src;

-- Tweak existing rows: notes + correct coolant months (96 not 120).
UPDATE service_intervals SET miles_normal=9300, km_normal=15000, months=12,
  notes='Engine oil + filter every 15,000 km (9,300 mi) or 12 mo per Suzuki Ignis EN OM. K12C / K12D / K12B — Suzuki K-series spec.'
WHERE id=3476;

UPDATE service_intervals SET miles_normal=37000, km_normal=60000,
  notes='Engine air cleaner element: replace every 60,000 km (37,000 mi); paved-road inspection every 15,000 km per Suzuki Ignis EN OM.'
WHERE id=3477;

UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months (time-based, not mileage) per Suzuki Ignis EN OM.'
WHERE id=3478;

UPDATE service_intervals SET miles_normal=65000, km_normal=105000,
  notes='Iridium spark plugs: replace every 105,000 km (65,000 mi) or 84 mo per Suzuki Ignis EN OM. Applies to Class 1+3 (K12C / K12B). K12D Hybrid uses condensed schedule (see notes).'
WHERE id=3479;

UPDATE service_intervals SET miles_normal=93000, km_normal=150000, months=96,
  notes='Engine coolant (Suzuki LLC Super Blue): first time at 150,000 km (90,000 mi) or 96 mo; subsequent every 75,000 km / 48 mo. Standard Green: 40,000 km / 36 mo. Suzuki Ignis EN OM.'
WHERE id=3480;

-- Attach page numbers.
UPDATE spec_sources SET page_number=23 WHERE spec_table='service_intervals' AND spec_id=3476 AND source_id=@src;
UPDATE spec_sources SET page_number=30 WHERE spec_table='service_intervals' AND spec_id=3477 AND source_id=@src;
UPDATE spec_sources SET page_number=35 WHERE spec_table='service_intervals' AND spec_id=3478 AND source_id=@src;
UPDATE spec_sources SET page_number=31 WHERE spec_table='service_intervals' AND spec_id=3479 AND source_id=@src;
UPDATE spec_sources SET page_number=28 WHERE spec_table='service_intervals' AND spec_id=3480 AND source_id=@src;

INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'accessory_drive_belt_replacement', 48000, 80000, 96,   'Engine accessory drive belt: inspect every 40,000 km / 48 mo, replace every 80,000 km (48,000 mi) / 96 mo per Suzuki Ignis EN OM.'),
  (@gen, NULL, 'fuel_filter',                      63000,105000, NULL, 'Fuel filter (in-tank): replace every 105,000 km (63,000 mi) per Suzuki Ignis EN OM.'),
  (@gen, NULL, 'pcv_valve_inspection',             50000, 80000, 48,   'PCV valve inspection every 80,000 km (50,000 mi) or 48 mo per Suzuki Ignis EN OM. (Different from Swift/Vitara which use 90k km / 108 mo.)'),
  (@gen, NULL, 'transfer_case_fluid_inspection',   18000, 30000, 24,   'AllGrip 4WD only: transfer oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Ignis EN OM.'),
  (@gen, NULL, 'manual_transmission_fluid_inspection', 18000, 30000, 24, 'MT only: manual transmission oil (Suzuki GEAR OIL 75W) inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Ignis EN OM.'),
  (@gen, NULL, 'brake_hose_inspection',            18000, 30000, 24,   'Brake hoses and pipes: inspect every 30,000 km (18,000 mi) or 24 mo per Suzuki Ignis EN OM.'),
  (@gen, NULL, 'tire_pressure_check',              NULL,  NULL,  1,    'Check tire pressures monthly (cold pressure, including spare) per Suzuki Ignis EN OM tire section.'),
  (@gen, NULL, 'fluid_level_check',                NULL,  NULL,  1,    'Check engine oil, coolant, brake fluid, washer fluid monthly per Suzuki Ignis EN OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'accessory_drive_belt_replacement'    THEN 25
         WHEN 'fuel_filter'                         THEN 25
         WHEN 'pcv_valve_inspection'                THEN 25
         WHEN 'transfer_case_fluid_inspection'      THEN 33
         WHEN 'manual_transmission_fluid_inspection' THEN 32
         WHEN 'brake_hose_inspection'               THEN 35
         WHEN 'tire_pressure_check'                 THEN 38
         WHEN 'fluid_level_check'                   THEN 23
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('accessory_drive_belt_replacement','fuel_filter','pcv_valve_inspection','transfer_case_fluid_inspection','manual_transmission_fluid_inspection','brake_hose_inspection','tire_pressure_check','fluid_level_check')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
