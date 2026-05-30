-- mig 548 — moat-fill Dodge Avenger JS 2013 from US OM.
-- Source: Dodge_Avenger_JS_2013_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 879 already exists (oem_manual, public_link=1).
-- Engines: 138 = ERB 3.6L Pentastar V6; 2039 = ED3 2.4L World Engine I4.

SET NAMES utf8mb4;

SET @gen     := 342;
SET @src     := 879;
SET @eng_v6  := 138;
SET @eng_24  := 2039;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Avenger JS 2013 OM p.475. Severe duty 4k mi (6.5k km). 2.4L ED3: 5W-20 MS-6395; 3.6L Pentastar: 5W-20 MS-6395.'
WHERE id=3351;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Avenger JS 2013 OM p.476. First sign of irregular wear takes precedence.'
WHERE id=3352;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change; linings every 20k mi (32k km) per Mopar Avenger JS 2013 OM p.476-477.'
WHERE id=3353;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k schedule per Mopar Avenger JS 2013 OM p.478.'
WHERE id=3354;

-- 2.4L ED3 plugs at 30k mi (every 30k schedule for old World Engine copper).
UPDATE service_intervals SET miles_normal=30000, km_normal=48000, months=NULL, engine_id=@eng_24,
  notes='2.4L ED3 World Engine: spark plugs every 30k mi (48k km) — mileage-only per Mopar Avenger JS 2013 OM p.478. Older copper plug spec.'
WHERE id=3355;

UPDATE service_intervals SET
  notes='62TE 6-speed automatic — change ATF + filter at 100k mi (160k km); severe-duty (police/taxi/fleet/towing) at 60k mi (96k km). Fluid: Mopar ATF+4 (MS-9602). Mopar Avenger JS 2013 OM.'
WHERE id=3357;

-- 3.6L V6 plug interval — different from 2.4L.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_v6, 'spark_plugs',              100000,160000, NULL, '3.6L Pentastar V6 (ERB): spark plugs at 100k mi (160k km) — mileage-only per Mopar Avenger JS 2013 OM p.478.'),
  (@gen, NULL,    'cabin_air_filter',         20000, 32000, NULL, 'Replace cabin / air conditioning filter every 20k mi (32k km) per Mopar Avenger JS 2013 OM p.478.'),
  (@gen, NULL,    'pcv_valve_inspection',    100000,160000, NULL, 'Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Avenger JS 2013 OM p.479.'),
  (@gen, NULL,    'transmission_at_fluid_change',100000,160000, NULL, 'Normal-duty automatic transmission fluid + filter change at 100k mi (160k km) per Mopar Avenger JS 2013 OM p.478. Fluid: Mopar ATF+4 (MS-9602).'),
  (@gen, NULL,    'tire_pressure_check',      NULL,  NULL,    1,  'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Avenger JS 2013 OM p.475.'),
  (@gen, NULL,    'fluid_level_check',        NULL,  NULL,    1,  'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Avenger JS 2013 OM p.475.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_v6 AND si.service='spark_plugs' THEN 478
         WHEN si.service='cabin_air_filter'                     THEN 478
         WHEN si.service='pcv_valve_inspection'                 THEN 479
         WHEN si.service='transmission_at_fluid_change'         THEN 478
         WHEN si.service='tire_pressure_check'                  THEN 475
         WHEN si.service='fluid_level_check'                    THEN 475
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id=@eng_v6 AND si.service='spark_plugs')
    OR si.service IN ('cabin_air_filter','pcv_valve_inspection','transmission_at_fluid_change','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
