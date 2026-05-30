-- mig 549 — moat-fill Dodge Dart PF 2016 from US OM.
-- Source: Dodge_Dart_PF_2016_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 878 already exists (oem_manual, public_link=1).
-- Engines:
--   2036 = ED6 2.4L Tigershark MultiAir2 NA;
--   2040 = 1.4L MultiAir2 Turbo (Italian-cadence schedule);
--   2041 = 2.0L Tigershark NA.

SET NAMES utf8mb4;

SET @gen    := 341;
SET @src    := 878;
SET @eng_24 := 2036;
SET @eng_14t:= 2040;
SET @eng_20 := 2041;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Dart PF 2016 OM p.647. 2.0L/2.4L Tigershark: 5W-20 MS-6395; 1.4L MultiAir2 Turbo: 5W-40 ACEA C3 MS-13340.'
WHERE id=3407;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Dart PF 2016 OM p.648. First sign of irregular wear takes precedence.'
WHERE id=3408;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change; linings every 20k mi (32k km) per Mopar Dart PF 2016 OM p.649.'
WHERE id=3409;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k schedule per Mopar Dart PF 2016 OM p.650.'
WHERE id=3410;

-- 1.4L Turbo plugs: 30k mi cadence (Italian turbo).
UPDATE service_intervals SET miles_normal=30000, km_normal=48000, months=NULL, engine_id=@eng_14t,
  notes='1.4L MultiAir2 Turbo: spark plugs every 30k mi (48k km) — mileage-only per Mopar Dart PF 2016 OM p.651. Italian-cadence turbo plug interval.'
WHERE id=3411;

UPDATE service_intervals SET
  notes='C635 6-speed dry DCT (1.4L) or Aisin 6-speed automatic (2.0L/2.4L). 1.4L Turbo MT: 6MT C510. Normal: fill-for-life; severe-duty change at 60k mi (96k km) per Mopar Dart PF 2016 OM.'
WHERE id=3413;

-- Add 2.0L + 2.4L spark plug rows (100k mi).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_24, 'spark_plugs',              100000,160000, NULL, '2.4L Tigershark (ED6): spark plugs at 100k mi (160k km) — mileage-only per Mopar Dart PF 2016 OM p.651.'),
  (@gen, @eng_20, 'spark_plugs',              100000,160000, NULL, '2.0L Tigershark: spark plugs at 100k mi (160k km) — mileage-only per Mopar Dart PF 2016 OM p.651.'),
  (@gen, @eng_14t,'timing_belt_replacement', 150000,240000, NULL, '1.4L MultiAir2 Turbo: replace timing belt at 150k mi (240k km) per Mopar Dart PF 2016 OM p.652. Interference engine.'),
  (@gen, NULL,    'cabin_air_filter',         20000, 32000, NULL, 'Replace cabin air filter every 20k mi (32k km) per Mopar Dart PF 2016 OM p.650.'),
  (@gen, NULL,    'accessory_drive_belt_inspection',150000,240000, NULL, 'Inspect front accessory drive belt, tensioner, idler pulley at 150k mi (240k km); replace if necessary per Mopar Dart PF 2016 OM p.650.'),
  (@gen, NULL,    'pcv_valve_inspection',    100000,160000, NULL, 'Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Dart PF 2016 OM p.652.'),
  (@gen, NULL,    'transmission_at_fluid_severe',60000, 96000, NULL, 'Severe-duty 2.0L/2.4L automatic transmission fluid change: every 60k mi (96k km) under harsh conditions (off-road, towing, sustained high speed >90°F) per Mopar Dart PF 2016 OM p.652.'),
  (@gen, NULL,    'tire_pressure_check',      NULL,  NULL,    1,  'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Dart PF 2016 OM p.647.'),
  (@gen, NULL,    'fluid_level_check',        NULL,  NULL,    1,  'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Dart PF 2016 OM p.647.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_24  AND si.service='spark_plugs'              THEN 651
         WHEN si.engine_id=@eng_20  AND si.service='spark_plugs'              THEN 651
         WHEN si.engine_id=@eng_14t AND si.service='timing_belt_replacement'  THEN 652
         WHEN si.service='cabin_air_filter'                                   THEN 650
         WHEN si.service='accessory_drive_belt_inspection'                    THEN 650
         WHEN si.service='pcv_valve_inspection'                               THEN 652
         WHEN si.service='transmission_at_fluid_severe'                       THEN 652
         WHEN si.service='tire_pressure_check'                                THEN 647
         WHEN si.service='fluid_level_check'                                  THEN 647
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id IN (@eng_24,@eng_20) AND si.service='spark_plugs')
    OR (si.engine_id=@eng_14t AND si.service='timing_belt_replacement')
    OR si.service IN ('cabin_air_filter','accessory_drive_belt_inspection','pcv_valve_inspection','transmission_at_fluid_severe','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
