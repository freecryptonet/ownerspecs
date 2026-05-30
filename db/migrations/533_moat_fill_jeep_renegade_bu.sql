-- mig 533 — moat-fill Jeep Renegade BU 2021 from US OM.
-- Source: Jeep_Renegade_BU_2021_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 874 already exists (oem_manual, public_link=1).
-- Engines: 2036 = 2.4L Tigershark ED6; 2038 = 1.3L Turbo GSE-T4 FireFly.

SET NAMES utf8mb4;

SET @gen := 338;
SET @src := 874;
SET @eng_24 := 2036;  -- 2.4L Tigershark
SET @eng_13 := 2038;  -- 1.3L Turbo FireFly

-- Update existing gen-wide rows with OM-stated values.
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 1 yr / 350 hr OCI per Mopar Renegade BU 2021 OM p.333. 2.4L Tigershark: 0W-20 MS-6395. 1.3L Turbo: 0W-30 ACEA C2 MS-13340.'
WHERE id=3379;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Renegade BU 2021 OM p.333. First sign of irregular wear takes precedence.'
WHERE id=3380;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change; visual front-suspension/CV inspection at every interval per Mopar Renegade BU 2021 OM p.333-335.'
WHERE id=3381;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air cleaner every 30k mi (48k km) — inspect at every oil change in dusty areas per Mopar Renegade BU 2021 OM p.337.'
WHERE id=3382;

-- Spark plugs: 2.4L Tigershark at 100k mi (mileage-only) — re-attribute to engine 2036.
UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL, engine_id=@eng_24,
  notes='2.4L Tigershark: spark plugs at 100k mi (160k km). Mileage-only — yearly intervals do NOT apply per Mopar Renegade BU 2021 OM p.337.'
WHERE id=3383;

-- ATF transmission note stays gen-wide.
UPDATE service_intervals SET
  notes='9-speed automatic (ZF 9HP) on 2.4L 4WD; 6-speed dry DCT (C635) on 1.3L Turbo. Fill-for-life under normal use; OM publishes no normal-duty change interval.'
WHERE id=3385;

-- New rows: 1.3L turbo plug interval, cabin filter, brake fluid, accessory belt, PCV, monthly checks.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_13, 'spark_plugs',             40000, 64000, NULL, '1.3L Turbo (GSE-T4 FireFly): spark plugs every 40k mi (64k km) — mileage-only per Mopar Renegade BU 2021 OM p.337 (40/80/120k schedule).'),
  (@gen, NULL,    'cabin_air_filter',        20000, 32000, NULL, 'Replace cabin air filter every 20k mi (32k km); inspect at the 10k off-interval per Mopar Renegade BU 2021 OM p.338.'),
  (@gen, NULL,    'brake_fluid_change',      NULL,  NULL,  24,   'Brake fluid change every 24 months — time-based only, mileage intervals do NOT apply per Mopar Renegade BU 2021 OM p.337.'),
  (@gen, NULL,    'accessory_drive_belt_replacement', 75000,120000, 72, 'Replace front accessory drive belt at max 75k mi (120k km) or every 6 yr. Severe-duty (dust/cold/urban/idle): 37.5k mi (60k km) or 4 yr. Mopar Renegade BU 2021 OM p.336.'),
  (@gen, NULL,    'pcv_valve_inspection',   100000,160000, NULL, 'Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Renegade BU 2021 OM p.336.'),
  (@gen, NULL,    'tire_pressure_check',     NULL,  NULL,  1,    'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Renegade BU 2021 OM p.333.'),
  (@gen, NULL,    'fluid_level_check',       NULL,  NULL,  1,    'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Renegade BU 2021 OM p.333.');

-- Cite all the new rows.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_13 AND si.service='spark_plugs'    THEN 337
         WHEN si.service='cabin_air_filter'                        THEN 338
         WHEN si.service='brake_fluid_change'                      THEN 337
         WHEN si.service='accessory_drive_belt_replacement'        THEN 336
         WHEN si.service='pcv_valve_inspection'                    THEN 336
         WHEN si.service='tire_pressure_check'                     THEN 333
         WHEN si.service='fluid_level_check'                       THEN 333
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id=@eng_13 AND si.service='spark_plugs')
    OR si.service IN ('cabin_air_filter','brake_fluid_change','accessory_drive_belt_replacement','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
