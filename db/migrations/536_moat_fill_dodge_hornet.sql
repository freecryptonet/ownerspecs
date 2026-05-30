-- mig 536 — moat-fill Dodge Hornet 2024 from US OM.
-- Source: Dodge_Hornet_2024_OM_Mopar.pdf + Dodge_Hornet_Hybrid_2024_OH_Mopar.pdf
-- (vehicleinfo.mopar.com). Italian-platform Alfa Romeo Tonale rebadge.
-- Source rows 875 (2.0L OM) + 876 (R/T PHEV supplement) already exist.
-- Engines: 187 = 2.0L Turbo Hurricane 4 (GME-T4); 2038 = 1.3L Turbo PHEV (GSE-T4).

SET NAMES utf8mb4;

SET @gen     := 339;
SET @src     := 875;  -- 2.0L OM
SET @src_phev:= 876;  -- 1.3L PHEV R/T supplement
SET @eng_20t := 187;
SET @eng_13t := 2038;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Hornet 2024 OM p.236. 2.0L Turbo: 0W-20 MS-6395; 1.3L Turbo PHEV R/T: 0W-30 ACEA C2 MS-13340.'
WHERE id=3414;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Hornet 2024 OM p.236. First sign of irregular wear takes precedence.'
WHERE id=3415;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change per Mopar Hornet 2024 OM p.236. Brake fluid change every 24 mo (time-based only).'
WHERE id=3416;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air cleaner every 30k mi (48k km) — 30/60/90/120/150k per Mopar Hornet 2024 OM p.238.'
WHERE id=3417;

-- 2.0L plugs: 60k mi. Re-attribute to engine 187.
UPDATE service_intervals SET miles_normal=60000, km_normal=96000, engine_id=@eng_20t,
  notes='2.0L Turbo (Hurricane 4 GME-T4): spark plugs every 60k mi (96k km) — mileage-only per Mopar Hornet 2024 OM p.238 (X at 60k/120k schedule).'
WHERE id=3418;

UPDATE service_intervals SET miles_normal=150000, km_normal=240000,
  notes='Flush and replace engine, power electronics, and battery coolant at 10 yr / 150k mi (240k km) per Mopar Hornet 2024 OM p.238.'
WHERE id=3419;

UPDATE service_intervals SET
  notes='9-speed automatic (ZF 9HP) on 2.0L; 6-speed dry DCT on 1.3L Turbo PHEV. Fill-for-life under normal use per Mopar Hornet 2024 OM.'
WHERE id=3420;

-- PHEV 1.3L plug interval (engine 2038, same as Renegade BU). Add new row.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_13t, 'spark_plugs',            40000, 64000, NULL, '1.3L Turbo PHEV (R/T): spark plugs every 40k mi (64k km) — mileage-only per Mopar Hornet Hybrid 2024 Owner Handbook (GSE-T4 FireFly engine, same as Renegade BU).'),
  (@gen, NULL,     'cabin_air_filter',       12000, 19000, NULL, 'Replace cabin air filter every 12k mi (19k km) — mileage-only per Mopar Hornet 2024 OM p.238.'),
  (@gen, NULL,     'brake_fluid_change',     NULL,  NULL,  24,   'Brake fluid change every 24 months — time-based only, regardless of mileage, per Mopar Hornet 2024 OM p.238.'),
  (@gen, NULL,     'accessory_drive_belt_inspection', 150000, 240000, NULL, 'Inspect front accessory drive belt, tensioner, idler pulley at 150k mi (240k km); replace if necessary per Mopar Hornet 2024 OM p.238.'),
  (@gen, NULL,     'pcv_valve_inspection',  140000,224000, NULL, 'Inspect PCV valve at 140k mi (224k km); replace if necessary per Mopar Hornet 2024 OM p.238.'),
  (@gen, NULL,     'tire_pressure_check',    NULL,  NULL,  1,    'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Hornet 2024 OM p.236.'),
  (@gen, NULL,     'fluid_level_check',      NULL,  NULL,  1,    'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Hornet 2024 OM p.236.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id,
       CASE WHEN si.engine_id=@eng_13t THEN @src_phev ELSE @src END,
       CASE
         WHEN si.engine_id=@eng_13t AND si.service='spark_plugs'  THEN NULL
         WHEN si.service='cabin_air_filter'                       THEN 238
         WHEN si.service='brake_fluid_change'                     THEN 238
         WHEN si.service='accessory_drive_belt_inspection'        THEN 238
         WHEN si.service='pcv_valve_inspection'                   THEN 238
         WHEN si.service='tire_pressure_check'                    THEN 236
         WHEN si.service='fluid_level_check'                      THEN 236
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id=@eng_13t AND si.service='spark_plugs')
    OR si.service IN ('cabin_air_filter','brake_fluid_change','accessory_drive_belt_inspection','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id
      AND ss.source_id=(CASE WHEN si.engine_id=@eng_13t THEN @src_phev ELSE @src END)
  );
