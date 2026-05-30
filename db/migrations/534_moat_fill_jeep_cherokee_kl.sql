-- mig 534 — moat-fill Jeep Cherokee KL 2020 from US OM.
-- Source: Jeep_Cherokee_KL_2020_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 872 already exists (oem_manual, public_link=1).
-- Engines: 187 = 2.0L Turbo GME-T4; 2036 = 2.4L Tigershark; 2037 = 3.2L Pentastar V6 (EHK).

SET NAMES utf8mb4;

SET @gen := 336;
SET @src := 872;
SET @eng_20t := 187;   -- 2.0L Turbo GME-T4
SET @eng_24  := 2036;  -- 2.4L Tigershark
SET @eng_32  := 2037;  -- 3.2L Pentastar V6 EHK

-- Update existing gen-wide rows.
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Cherokee KL 2020 OM p.234. Severe duty: 4k mi (6.5k km). 2.0L Turbo + 2.4L: 0W-20 MS-6395; 3.2L V6: 0W-20 MS-6395.'
WHERE id=3365;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Cherokee KL 2020 OM p.234. First sign of irregular wear takes precedence.'
WHERE id=3366;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change; brake linings every 20k mi (32k km) per Mopar Cherokee KL 2020 OM p.235.'
WHERE id=3367;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air cleaner every 30k mi (48k km) — schedule at 30/60/90/120/150k per Mopar Cherokee KL 2020 OM p.236.'
WHERE id=3368;

-- Spark plugs: 2.4L Tigershark at 100k mi (the most common engine on KL).
UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL, engine_id=@eng_24,
  notes='2.4L Tigershark: spark plugs at 100k mi (160k km). Mileage-only — yearly intervals do NOT apply per Mopar Cherokee KL 2020 OM p.236.'
WHERE id=3369;

UPDATE service_intervals SET
  notes='9-speed automatic (ZF 9HP) standard — fill-for-life under normal use. Fluid spec: Mopar ZF 8 & 9 Speed ATF (MS-12892). Mopar Cherokee KL 2020 OM.'
WHERE id=3371;

-- New rows: per-engine spark plug variants + cabin / belt / PCV / monthly checks.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_20t, 'spark_plugs',     60000,  96000, NULL, '2.0L Turbo (GME-T4 "Hurricane 4"): spark plugs every 60k mi (96k km) — mileage-only per Mopar Cherokee KL 2020 OM p.236.'),
  (@gen, @eng_32,  'spark_plugs',    100000, 160000, NULL, '3.2L Pentastar V6 (EHK): spark plugs at 100k mi (160k km) — mileage-only per Mopar Cherokee KL 2020 OM p.236.'),
  (@gen, NULL,     'cabin_air_filter',20000,  32000, NULL, 'Replace cabin / A/C filter every 20k mi (32k km) per Mopar Cherokee KL 2020 OM p.236.'),
  (@gen, NULL,     'accessory_drive_belt_inspection', 150000, 240000, NULL, 'Inspect front accessory drive belt, tensioner, idler pulley at 150k mi (240k km); replace if necessary per Mopar Cherokee KL 2020 OM p.235.'),
  (@gen, NULL,     'pcv_valve_inspection', 100000, 160000, NULL, 'Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Cherokee KL 2020 OM p.236.'),
  (@gen, NULL,     'tire_pressure_check', NULL, NULL, 1,        'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Cherokee KL 2020 OM p.234.'),
  (@gen, NULL,     'fluid_level_check',   NULL, NULL, 1,        'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Cherokee KL 2020 OM p.234.');

-- Cite new rows.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id IN (@eng_20t,@eng_32) AND si.service='spark_plugs' THEN 236
         WHEN si.service='cabin_air_filter'                                   THEN 236
         WHEN si.service='accessory_drive_belt_inspection'                    THEN 235
         WHEN si.service='pcv_valve_inspection'                               THEN 236
         WHEN si.service='tire_pressure_check'                                THEN 234
         WHEN si.service='fluid_level_check'                                  THEN 234
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id IN (@eng_20t,@eng_32) AND si.service='spark_plugs')
    OR si.service IN ('cabin_air_filter','accessory_drive_belt_inspection','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
