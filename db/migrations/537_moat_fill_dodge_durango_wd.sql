-- mig 537 — moat-fill Dodge Durango WD 2020 from US OM.
-- Source: Dodge_Durango_WD_2020_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 869 already exists (oem_manual, public_link=1).
-- Engines: 138 = 3.6L Pentastar V6 (ERB); 166 = 5.7L HEMI (EZH);
--          167 = 6.4L 392 SRT (ESG); 168 = 6.2L Hellcat (EWB, R/T).

SET NAMES utf8mb4;

SET @gen     := 333;
SET @src     := 869;
SET @eng_v6  := 138;
SET @eng_57  := 166;
SET @eng_64  := 167;
SET @eng_hk  := 168;

-- Re-scope existing rows to V6 (volume engine, non-SRT schedule).
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12, engine_id=@eng_v6,
  notes='3.6L Pentastar V6: max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Durango WD 2020 OM p.224. Severe duty: 4k mi (6.5k km). 0W-20 MS-6395.'
WHERE id=3338;

UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI (non-SRT): rotate tires at every oil-change interval per Mopar Durango WD 2020 OM p.225.'
WHERE id=3340;

UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI: inspect brake pads/shoes/rotors/drums/hoses every oil change; linings every 20k mi (32k km) per Mopar Durango WD 2020 OM p.225-226.'
WHERE id=3341;

UPDATE service_intervals SET miles_normal=20000, km_normal=32000, engine_id=@eng_v6,
  notes='V6/HEMI: replace cabin / A/C filter every 20k mi (32k km) per Mopar Durango WD 2020 OM p.226. Mileage-only.'
WHERE id=3342;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000, engine_id=@eng_v6,
  notes='V6/HEMI: replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k per Mopar Durango WD 2020 OM p.226.'
WHERE id=3343;

-- 5.7L HEMI mirror rows (same as V6).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_57, 'engine_oil_and_filter', 10000, 16000, 12,   '5.7L HEMI V8 (R/T): max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Durango WD 2020 OM p.224. 5W-20 MS-6395.'),
  (@gen, @eng_57, 'tire_rotation',         NULL,  NULL,  NULL, '5.7L HEMI: rotate tires at every oil-change interval per Mopar Durango WD 2020 OM p.225.'),
  (@gen, @eng_57, 'spark_plugs',          100000,160000, NULL, '5.7L HEMI: spark plugs at 100k mi (160k km) — mileage-only per Mopar Durango WD 2020 OM p.226.'),
  (@gen, @eng_57, 'cabin_air_filter',     20000, 32000, NULL,  '5.7L HEMI: replace cabin / A/C filter every 20k mi (32k km) per Mopar Durango WD 2020 OM p.226.');

-- V6 spark plugs (engine_id=138).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_v6, 'spark_plugs',          100000,160000, NULL, '3.6L Pentastar V6: spark plugs at 100k mi (160k km) — mileage-only per Mopar Durango WD 2020 OM p.226.');

-- SRT 6.4L (aggressive schedule).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_64, 'engine_oil_and_filter',  6000, 10000,  6,   '6.4L 392 SRT (392 R/T): max 6k mi / 10k km / 6 mo OCI per Mopar Durango WD 2020 OM p.227. 0W-40 Pennzoil Ultra Platinum MS-12633.'),
  (@gen, @eng_64, 'tire_rotation',          6000, 10000, NULL, '6.4L SRT: rotate tires every 6k mi (every oil change) per Mopar Durango WD 2020 OM p.228.'),
  (@gen, @eng_64, 'spark_plugs',          150000,240000, NULL, '6.4L 392 SRT: spark plugs at 150k mi (240k km) — mileage-only per Mopar Durango WD 2020 OM p.229.'),
  (@gen, @eng_64, 'cabin_air_filter',     12000, 19000, NULL,  '6.4L SRT: replace cabin / A/C filter every 12k mi (19k km) per Mopar Durango WD 2020 OM p.229.');

-- Hellcat 6.2L (SRT-class schedule).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_hk, 'engine_oil_and_filter',  6000, 10000,  6,   '6.2L Supercharged HEMI (SRT Hellcat): max 6k mi / 10k km / 6 mo OCI per Mopar Durango WD 2020 OM (Hellcat supplement). 0W-40 Pennzoil Ultra Platinum MS-12633.'),
  (@gen, @eng_hk, 'tire_rotation',          6000, 10000, NULL, '6.2L Hellcat: rotate tires every 6k mi (every oil change) per Mopar Durango WD 2020 OM (Hellcat supplement).'),
  (@gen, @eng_hk, 'cabin_air_filter',     12000, 19000, NULL,  '6.2L Hellcat: replace cabin / A/C filter every 12k mi (19k km) per Mopar Durango WD 2020 OM (Hellcat supplement).');

-- Gen-wide additions.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'accessory_drive_belt_replacement', 150000, 240000, NULL, 'Replace accessory drive belt at 150k mi (240k km) per Mopar Durango WD 2020 OM p.226.'),
  (@gen, NULL, 'transfer_case_fluid_change',       120000, 192000, NULL, 'Change transfer case fluid at 120k mi (192k km) (AWD models) per Mopar Durango WD 2020 OM p.226.'),
  (@gen, NULL, 'pcv_valve_inspection',             100000, 160000, NULL, 'Replace PCV valve at 100k mi (160k km) per Mopar Durango WD 2020 OM p.226.'),
  (@gen, NULL, 'tire_pressure_check',              NULL,   NULL,    1,   'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Durango WD 2020 OM p.224.'),
  (@gen, NULL, 'fluid_level_check',                NULL,   NULL,    1,   'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Durango WD 2020 OM p.224.');

-- Cite all the new rows.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_v6 AND si.service='spark_plugs'           THEN 226
         WHEN si.engine_id=@eng_57 AND si.service='engine_oil_and_filter' THEN 224
         WHEN si.engine_id=@eng_57 AND si.service='tire_rotation'         THEN 225
         WHEN si.engine_id=@eng_57 AND si.service='spark_plugs'           THEN 226
         WHEN si.engine_id=@eng_57 AND si.service='cabin_air_filter'      THEN 226
         WHEN si.engine_id=@eng_64 AND si.service='engine_oil_and_filter' THEN 227
         WHEN si.engine_id=@eng_64 AND si.service='tire_rotation'         THEN 228
         WHEN si.engine_id=@eng_64 AND si.service='spark_plugs'           THEN 229
         WHEN si.engine_id=@eng_64 AND si.service='cabin_air_filter'      THEN 229
         WHEN si.engine_id=@eng_hk AND si.service='engine_oil_and_filter' THEN 227
         WHEN si.engine_id=@eng_hk AND si.service='tire_rotation'         THEN 228
         WHEN si.engine_id=@eng_hk AND si.service='cabin_air_filter'      THEN 229
         WHEN si.service='accessory_drive_belt_replacement'               THEN 226
         WHEN si.service='transfer_case_fluid_change'                     THEN 226
         WHEN si.service='pcv_valve_inspection'                           THEN 226
         WHEN si.service='tire_pressure_check'                            THEN 224
         WHEN si.service='fluid_level_check'                              THEN 224
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id=@eng_v6 AND si.service='spark_plugs')
    OR si.engine_id IN (@eng_57,@eng_64,@eng_hk)
    OR si.service IN ('accessory_drive_belt_replacement','transfer_case_fluid_change','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
