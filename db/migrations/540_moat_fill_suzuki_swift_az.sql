-- mig 540 — moat-fill Suzuki Swift AZ (2017-2024) from EN OMs.
-- Source: Swift-WEB_99011-80SS5-01E.pdf (Suzuki EN OM).
-- Source row 847 already exists with truncated citation; fix here.
-- Engines: 2027 = K12C 1.2 DualJet; 2028 = K12D 1.2 Smart Hybrid;
--          2031 = K14D 1.4 Smart Hybrid BoosterJet.

SET NAMES utf8mb4;

SET @gen := 330;
SET @src := 847;

-- Fix truncated citation.
UPDATE sources SET citation='Suzuki Swift Owner''s Manual (AZ, edition 99011-80SS5-01E)',
                   notes='Suzuki Swift AZ OEM Owner''s Manual (English / international). Service intervals, fluid grades, lighting and tire pressures for K12C / K12D / K14D powertrains. Aggregator-hosted; public_link=0.'
WHERE id=@src;

UPDATE service_intervals SET miles_normal=9300, km_normal=15000, months=12,
  notes='Engine oil + filter every 15,000 km (9,300 mi) or 12 mo per Suzuki Swift EN OM. K12C / K12D / K14D — Suzuki K-series spec.'
WHERE id=3486;

UPDATE service_intervals SET miles_normal=37000, km_normal=60000,
  notes='Engine air cleaner element: replace every 60,000 km (37,000 mi); paved-road inspection every 15,000 km per Suzuki Swift EN OM.'
WHERE id=3487;

UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months (time-based, not mileage) per Suzuki Swift EN OM.'
WHERE id=3488;

UPDATE service_intervals SET miles_normal=65000, km_normal=105000,
  notes='Iridium spark plugs: replace every 105,000 km (65,000 mi) per Suzuki Swift EN OM. Applies to all K-series engines (K12C / K12D / K14D).'
WHERE id=3489;

UPDATE service_intervals SET miles_normal=93000, km_normal=150000, months=96,
  notes='Engine coolant (Suzuki LLC Super Blue): first time at 150,000 km (90,000 mi) or 96 mo; subsequent every 75,000 km / 48 mo. Standard Green: 40,000 km / 36 mo. Suzuki Swift EN OM.'
WHERE id=3490;

UPDATE spec_sources SET page_number=23 WHERE spec_table='service_intervals' AND spec_id=3486 AND source_id=@src;
UPDATE spec_sources SET page_number=47 WHERE spec_table='service_intervals' AND spec_id=3487 AND source_id=@src;
UPDATE spec_sources SET page_number=35 WHERE spec_table='service_intervals' AND spec_id=3488 AND source_id=@src;
UPDATE spec_sources SET page_number=50 WHERE spec_table='service_intervals' AND spec_id=3489 AND source_id=@src;
UPDATE spec_sources SET page_number=45 WHERE spec_table='service_intervals' AND spec_id=3490 AND source_id=@src;

INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'accessory_drive_belt_replacement', 48000, 80000, 96,   'Engine accessory drive belt: inspect every 40,000 km / 48 mo, replace every 80,000 km (48,000 mi) / 96 mo per Suzuki Swift EN OM.'),
  (@gen, NULL, 'fuel_filter',                      63000,105000, NULL, 'Fuel filter (in-tank): replace every 105,000 km (63,000 mi) per Suzuki Swift EN OM.'),
  (@gen, NULL, 'pcv_valve_inspection',             54000, 90000, 108,  'PCV valve inspection every 90,000 km (54,000 mi) or 108 mo per Suzuki Swift EN OM.'),
  (@gen, NULL, 'fuel_evap_system_inspection',      54000, 90000, 108,  'Fuel evaporative emission control system: inspect every 90,000 km (54,000 mi) or 108 mo per Suzuki Swift EN OM.'),
  (@gen, NULL, 'brake_hose_inspection',            18000, 30000, 24,   'Brake hoses and pipes: inspect every 30,000 km (18,000 mi) or 24 mo per Suzuki Swift EN OM.'),
  (@gen, NULL, 'tire_pressure_check',              NULL,  NULL,  1,    'Check tire pressures monthly (cold pressure, including spare) per Suzuki Swift EN OM tire-pressure section.'),
  (@gen, NULL, 'fluid_level_check',                NULL,  NULL,  1,    'Check engine oil, coolant, brake fluid, washer fluid monthly per Suzuki Swift EN OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'accessory_drive_belt_replacement' THEN 45
         WHEN 'fuel_filter'                      THEN 25
         WHEN 'pcv_valve_inspection'             THEN 25
         WHEN 'fuel_evap_system_inspection'      THEN 25
         WHEN 'brake_hose_inspection'            THEN 26
         WHEN 'tire_pressure_check'              THEN 66
         WHEN 'fluid_level_check'                THEN 23
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('accessory_drive_belt_replacement','fuel_filter','pcv_valve_inspection','fuel_evap_system_inspection','brake_hose_inspection','tire_pressure_check','fluid_level_check')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
