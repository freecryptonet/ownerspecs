-- mig 535 — moat-fill Jeep Grand Cherokee WK2 2018 from US OM.
-- Source: Jeep_GrandCherokee_WK2_2018_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 871 already exists (oem_manual, public_link=1).
-- WK2 ships with 5 engines:
--   138 = 3.6L Pentastar V6 (ERB) — petrol, standard
--   166 = 5.7L HEMI V8 (EZH) — petrol, standard
--   167 = 6.4L 392 SRT HEMI (ESG) — petrol, aggressive schedule
--   168 = 6.2L Supercharged Hellcat (EWB) — Trackhawk, aggressive
--   202 = 3.0L EcoDiesel V6 (EXF) — diesel

SET NAMES utf8mb4;

SET @gen := 335;
SET @src := 871;
SET @eng_v6  := 138;
SET @eng_57  := 166;
SET @eng_64  := 167;
SET @eng_hk  := 168;
SET @eng_ed  := 202;

-- Re-scope existing rows to the V6 (the volume engine), with shared schedule.
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12, engine_id=@eng_v6,
  notes='3.6L Pentastar V6: max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Grand Cherokee WK2 2018 OM p.435. Severe duty: 4k mi (6.5k km). 0W-20 MS-6395.'
WHERE id=3393;

UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI: rotate tires at every oil-change interval per Mopar Grand Cherokee WK2 2018 OM p.436.'
WHERE id=3394;

UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI: inspect brake pads/shoes/rotors/drums/hoses every oil change; linings every 20k mi (32k km) per Mopar Grand Cherokee WK2 2018 OM p.437.'
WHERE id=3395;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000, engine_id=@eng_v6,
  notes='V6/HEMI/EcoDiesel: replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k per Mopar Grand Cherokee WK2 2018 OM p.437.'
WHERE id=3396;

UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL, engine_id=@eng_v6,
  notes='3.6L Pentastar V6: spark plugs at 100k mi (160k km) — mileage-only per Mopar Grand Cherokee WK2 2018 OM p.437.'
WHERE id=3397;

UPDATE service_intervals SET
  notes='ZF 8HP70/8HP75 8-speed automatic — fill-for-life under normal use; OM publishes no normal-duty interval. Fluid: Mopar ZF 8 & 9 Speed ATF (MS-12892).'
WHERE id=3399;

-- Mirror rows for 5.7L HEMI (same standard intervals as V6).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_57, 'engine_oil_and_filter', 10000, 16000, 12,   '5.7L HEMI V8 (R/T): max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Grand Cherokee WK2 2018 OM p.435. 5W-20 MS-6395.'),
  (@gen, @eng_57, 'tire_rotation',         NULL,  NULL,  NULL, '5.7L HEMI: rotate tires at every oil-change interval per Mopar Grand Cherokee WK2 2018 OM p.436.'),
  (@gen, @eng_57, 'spark_plugs',          100000,160000, NULL, '5.7L HEMI V8 (EZH): spark plugs at 100k mi (160k km) — mileage-only per Mopar Grand Cherokee WK2 2018 OM p.437.');

-- SRT 6.4L rows (more aggressive schedule).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_64, 'engine_oil_and_filter',  6000, 10000,  6,   '6.4L 392 SRT HEMI: max 6k mi / 10k km / 6 mo OCI. 0W-40 Pennzoil Ultra Platinum MS-12633 per Mopar Grand Cherokee WK2 2018 OM (SRT supplement).'),
  (@gen, @eng_64, 'tire_rotation',          6000, 10000, NULL, '6.4L SRT: rotate tires every 6k mi (every oil change) per Mopar Grand Cherokee WK2 2018 OM (SRT supplement).'),
  (@gen, @eng_64, 'spark_plugs',          150000,240000, NULL, '6.4L 392 SRT (ESG): spark plugs at 150k mi (240k km) — mileage-only per Mopar Grand Cherokee WK2 2018 OM (SRT supplement).');

-- Hellcat 6.2L rows (SRT-class schedule; plug interval deferred to Hellcat supplement).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_hk, 'engine_oil_and_filter',  6000, 10000,  6,   '6.2L Supercharged HEMI (Trackhawk): max 6k mi / 10k km / 6 mo OCI. 0W-40 Pennzoil Ultra Platinum MS-12633 per Mopar Grand Cherokee WK2 2018 OM (Trackhawk supplement).'),
  (@gen, @eng_hk, 'tire_rotation',          6000, 10000, NULL, '6.2L Hellcat: rotate tires every 6k mi (every oil change) per Mopar Grand Cherokee WK2 2018 OM (Trackhawk supplement).');

-- EcoDiesel rows.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_ed, 'engine_oil_and_filter', 10000, 16000, 12,   '3.0L EcoDiesel V6 (EXF): max 10k mi / 16k km / 12 mo OCI. 5W-40 full synthetic MS-12991 per Mopar Grand Cherokee WK2 2018 OM (diesel supplement).'),
  (@gen, @eng_ed, 'tire_rotation',         NULL,  NULL,  NULL, '3.0L EcoDiesel: rotate tires at every oil-change interval per Mopar Grand Cherokee WK2 2018 OM (diesel supplement).'),
  (@gen, @eng_ed, 'fuel_filter',          10000, 16000, 12,    '3.0L EcoDiesel only: replace fuel filter and drain water at every oil change (max 10k mi / 12 mo) per Mopar Grand Cherokee WK2 2018 OM.'),
  (@gen, @eng_ed, 'def_fluid_refill',     10000, 16000, 12,    '3.0L EcoDiesel only: fill DEF tank at every oil change (max 10k mi / 12 mo). DEF API-Certified to ISO 22241. Mopar Grand Cherokee WK2 2018 OM.'),
  (@gen, @eng_ed, 'accessory_drive_belt',100000,160000, NULL,  '3.0L EcoDiesel only: replace accessory drive belt(s) at 100k mi (160k km) per Mopar Grand Cherokee WK2 2018 OM.');

-- Gen-wide additions (cabin filter, PCV, transfer case, monthly checks).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'cabin_air_filter',          20000, 32000, NULL, 'Replace cabin / A/C filter every 20k mi (32k km) per Mopar Grand Cherokee WK2 2018 OM p.437.'),
  (@gen, NULL, 'transfer_case_fluid_change',120000,192000, NULL,'Change transfer case fluid at 120k mi (192k km) — severe duty (police/taxi/fleet/off-road/towing) per Mopar Grand Cherokee WK2 2018 OM p.438.'),
  (@gen, NULL, 'pcv_valve_inspection',     150000,240000, NULL, 'Inspect PCV valve at 150k mi (240k km); replace if necessary per Mopar Grand Cherokee WK2 2018 OM p.438.'),
  (@gen, NULL, 'tire_pressure_check',       NULL,  NULL,  1,    'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Grand Cherokee WK2 2018 OM p.435.'),
  (@gen, NULL, 'fluid_level_check',         NULL,  NULL,  1,    'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Grand Cherokee WK2 2018 OM p.435.');

-- Cite all the new rows.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_57 AND si.service='engine_oil_and_filter' THEN 435
         WHEN si.engine_id=@eng_57 AND si.service='tire_rotation'         THEN 436
         WHEN si.engine_id=@eng_57 AND si.service='spark_plugs'           THEN 437
         WHEN si.engine_id=@eng_64 AND si.service='engine_oil_and_filter' THEN 435
         WHEN si.engine_id=@eng_64 AND si.service='tire_rotation'         THEN 436
         WHEN si.engine_id=@eng_64 AND si.service='spark_plugs'           THEN 437
         WHEN si.engine_id=@eng_hk AND si.service='engine_oil_and_filter' THEN 435
         WHEN si.engine_id=@eng_hk AND si.service='tire_rotation'         THEN 436
         WHEN si.engine_id=@eng_ed AND si.service='engine_oil_and_filter' THEN 435
         WHEN si.engine_id=@eng_ed AND si.service='tire_rotation'         THEN 436
         WHEN si.engine_id=@eng_ed AND si.service='fuel_filter'           THEN 437
         WHEN si.engine_id=@eng_ed AND si.service='def_fluid_refill'      THEN 437
         WHEN si.engine_id=@eng_ed AND si.service='accessory_drive_belt'  THEN 437
         WHEN si.service='cabin_air_filter'                               THEN 437
         WHEN si.service='transfer_case_fluid_change'                     THEN 438
         WHEN si.service='pcv_valve_inspection'                           THEN 438
         WHEN si.service='tire_pressure_check'                            THEN 435
         WHEN si.service='fluid_level_check'                              THEN 435
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    si.engine_id IN (@eng_57,@eng_64,@eng_hk,@eng_ed)
    OR si.service IN ('cabin_air_filter','transfer_case_fluid_change','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
