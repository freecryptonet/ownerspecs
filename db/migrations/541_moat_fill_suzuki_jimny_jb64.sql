-- mig 541 — moat-fill Suzuki Jimny JB64 (2018-present) from EN OM.
-- Source: Jimny-3Dr_MC25-99011-85UB1-01E.pdf (Suzuki EN OM, 3-door MC25).
-- Source row 849 already exists with truncated citation; fix here.
-- Single engine: 2032 = K15B 1.5 4-cyl NA (Jimny JB64 / JB74).

SET NAMES utf8mb4;

SET @gen     := 326;
SET @src     := 849;
SET @eng_k15 := 2032;

-- Fix truncated citation.
UPDATE sources SET citation='Suzuki Jimny Owner''s Manual (JB64/JB74, edition 99011-85UB1-01E)',
                   notes='Suzuki Jimny JB64 (3-door) / JB74 (5-door) EN Owner''s Manual. Service intervals, fluid grades, lighting and tire pressures for K15B 1.5L petrol. Aggregator-hosted; public_link=0.'
WHERE id=@src;

-- All scheduled items here are K15B-specific (single engine). Attach engine_id.
UPDATE service_intervals SET miles_normal=9300, km_normal=15000, months=12, engine_id=@eng_k15,
  notes='K15B 1.5L: engine oil + filter every 15,000 km (9,300 mi) or 12 mo per Suzuki Jimny EN OM. Somalia-spec exception: 5,000 km / 6 mo.'
WHERE id=3481;

UPDATE service_intervals SET miles_normal=37000, km_normal=60000, engine_id=@eng_k15,
  notes='K15B: engine air cleaner element replacement every 60,000 km (37,000 mi); paved-road inspection every 15,000 km per Suzuki Jimny EN OM.'
WHERE id=3482;

UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months (time-based, not mileage) per Suzuki Jimny EN OM.'
WHERE id=3483;

UPDATE service_intervals SET miles_normal=65000, km_normal=105000, engine_id=@eng_k15,
  notes='K15B: iridium spark plugs at 105,000 km (65,000 mi) or 84 mo per Suzuki Jimny EN OM. Mileage- AND time-based (whichever first).'
WHERE id=3484;

UPDATE service_intervals SET miles_normal=93000, km_normal=150000, months=96, engine_id=@eng_k15,
  notes='K15B: coolant (Suzuki LLC Super Blue) first time at 150,000 km (90,000 mi) or 96 mo; subsequent every 75,000 km / 48 mo. Suzuki Jimny EN OM.'
WHERE id=3485;

UPDATE spec_sources SET page_number=23 WHERE spec_table='service_intervals' AND spec_id=3481 AND source_id=@src;
UPDATE spec_sources SET page_number=29 WHERE spec_table='service_intervals' AND spec_id=3482 AND source_id=@src;
UPDATE spec_sources SET page_number=35 WHERE spec_table='service_intervals' AND spec_id=3483 AND source_id=@src;
UPDATE spec_sources SET page_number=29 WHERE spec_table='service_intervals' AND spec_id=3484 AND source_id=@src;
UPDATE spec_sources SET page_number=27 WHERE spec_table='service_intervals' AND spec_id=3485 AND source_id=@src;

INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_k15, 'fuel_filter',                  63000,105000, NULL, 'K15B: fuel filter replacement every 105,000 km (63,000 mi) per Suzuki Jimny EN OM.'),
  (@gen, @eng_k15, 'pcv_valve_inspection',         50000, 80000, 48,   'K15B: PCV valve inspection every 80,000 km (50,000 mi) or 48 mo per Suzuki Jimny EN OM. (Note: Swift/Vitara use 90k km; Jimny shorter.)'),
  (@gen, NULL,     'transfer_case_fluid_inspection',18000, 30000, 24,  'Jimny is 4WD-only: transfer (low-range) oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Jimny EN OM.'),
  (@gen, NULL,     'transfer_case_fluid_change',   99000,165000, NULL, '4WD transfer (low-range) oil replacement every 165,000 km (99,000 mi) per Suzuki Jimny EN OM.'),
  (@gen, NULL,     'rear_differential_fluid_inspection',18000,30000, 24,'Rear differential oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Jimny EN OM.'),
  (@gen, NULL,     'front_differential_fluid_inspection',18000,30000, 24,'Front differential oil inspection every 30,000 km (18,000 mi) or 24 mo per Suzuki Jimny EN OM.'),
  (@gen, NULL,     'brake_hose_inspection',        18000, 30000, 24,   'Brake hoses and pipes: inspect every 30,000 km (18,000 mi) or 24 mo per Suzuki Jimny EN OM.'),
  (@gen, NULL,     'tire_pressure_check',          NULL,  NULL,  1,    'Check tire pressures monthly (cold pressure, including spare) per Suzuki Jimny EN OM tire section.'),
  (@gen, NULL,     'fluid_level_check',            NULL,  NULL,  1,    'Check engine oil, coolant, brake fluid, washer fluid monthly per Suzuki Jimny EN OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'fuel_filter'                         THEN 27
         WHEN 'pcv_valve_inspection'                THEN 27
         WHEN 'transfer_case_fluid_inspection'      THEN 32
         WHEN 'transfer_case_fluid_change'          THEN 32
         WHEN 'rear_differential_fluid_inspection'  THEN 32
         WHEN 'front_differential_fluid_inspection' THEN 32
         WHEN 'brake_hose_inspection'               THEN 35
         WHEN 'tire_pressure_check'                 THEN 38
         WHEN 'fluid_level_check'                   THEN 23
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('fuel_filter','pcv_valve_inspection','transfer_case_fluid_inspection','transfer_case_fluid_change','rear_differential_fluid_inspection','front_differential_fluid_inspection','brake_hose_inspection','tire_pressure_check','fluid_level_check')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
