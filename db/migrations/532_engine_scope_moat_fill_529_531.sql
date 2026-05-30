-- mig 532 — engine-scope corrections for migs 529 + 531.
--
-- migs 529 (Gladiator) and 531 (Challenger) wrote service_intervals with
-- engine_id=NULL even where the row only applies to one engine. Per the
-- "specs are engine-specific" rule, retro-attribute to the correct engines
-- and ADD missing rows for engines whose schedule differs from the gen
-- default.
--
-- Gladiator JT (gen 334), engines: 59 = ERC 3.6L Pentastar V6 (petrol);
-- 202 = EXF 3.0L EcoDiesel V6 (diesel).
--
-- Challenger LC (gen 332), engines: 138 = ERB 3.6L Pentastar V6;
-- 166 = EZH 5.7L HEMI; 167 = ESG 6.4L 392 SRT HEMI;
-- 168 = EWB 6.2L Supercharged HEMI (Hellcat).

SET NAMES utf8mb4;

-- -----------------------------------------------------------------------
-- Gladiator JT
-- -----------------------------------------------------------------------
SET @gen_gl  := 334;
SET @src_gl  := 870;
SET @eng_pen := 59;   -- 3.6L Pentastar
SET @eng_ed  := 202;  -- 3.0L EcoDiesel

-- Pentastar-only: spark plugs (diesel has none)
UPDATE service_intervals SET engine_id=@eng_pen,
  notes='3.6L Pentastar V6 only: spark plugs at 100k mi (160k km). Mileage-only — yearly intervals do NOT apply. Mopar Gladiator JT 2022 OM p.304. EcoDiesel = compression ignition, no spark plugs.'
WHERE generation_id=@gen_gl AND service='spark_plugs' AND engine_id IS NULL;

-- EcoDiesel-only services
UPDATE service_intervals SET engine_id=@eng_ed
WHERE generation_id=@gen_gl AND service IN ('fuel_filter','accessory_drive_belt','def_fluid_refill') AND engine_id IS NULL;

-- -----------------------------------------------------------------------
-- Challenger LC
-- -----------------------------------------------------------------------
SET @gen_ch  := 332;
SET @src_ch  := 868;
SET @eng_v6  := 138;  -- 3.6L Pentastar V6 (ERB)
SET @eng_57  := 166;  -- 5.7L HEMI (EZH)
SET @eng_64  := 167;  -- 6.4L 392 SRT HEMI (ESG)
SET @eng_hk  := 168;  -- 6.2L Hellcat (EWB)

-- Re-scope the existing "standard schedule" rows to V6 + 5.7L only.
UPDATE service_intervals SET engine_id=@eng_v6,
  notes='3.6L Pentastar V6 (SXT/GT) — max 10k mi / 16k km / 12 mo / 350 hr OCI. SAE 5W-20 MS-6395. Mopar Challenger LC 2017 OM p.487.'
WHERE generation_id=@gen_ch AND service='engine_oil_and_filter' AND engine_id IS NULL;
UPDATE service_intervals SET engine_id=@eng_v6,
  notes='3.6L Pentastar V6: spark plugs at 100k mi (160k km) — mileage-only per Mopar Challenger LC 2017 OM p.489.'
WHERE generation_id=@gen_ch AND service='spark_plugs' AND engine_id IS NULL;
UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI schedule: rotate tires at every oil change interval (≈10k mi) per Mopar Challenger LC 2017 OM p.488.'
WHERE generation_id=@gen_ch AND service='tire_rotation' AND engine_id IS NULL;
UPDATE service_intervals SET engine_id=@eng_v6, miles_normal=20000, km_normal=32000,
  notes='V6/HEMI: replace cabin / A/C filter every 20k mi (32k km) per Mopar Challenger LC 2017 OM p.489. Mileage-only.'
WHERE generation_id=@gen_ch AND service='cabin_air_filter' AND engine_id IS NULL;

-- Add 5.7L HEMI mirror rows (same intervals as V6, separate engine attribution).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen_ch, @eng_57, 'engine_oil_and_filter',  10000, 16000, 12,   '5.7L HEMI V8 (R/T) — max 10k mi / 16k km / 12 mo / 350 hr OCI. SAE 5W-20 MS-6395. Mopar Challenger LC 2017 OM p.487.'),
  (@gen_ch, @eng_57, 'spark_plugs',           100000,160000, NULL, '5.7L HEMI: spark plugs at 100k mi (160k km) — mileage-only per Mopar Challenger LC 2017 OM p.489.'),
  (@gen_ch, @eng_57, 'tire_rotation',          NULL,  NULL,  NULL, '5.7L HEMI: rotate tires at every oil change interval (≈10k mi) per Mopar Challenger LC 2017 OM p.488.'),
  (@gen_ch, @eng_57, 'cabin_air_filter',      20000, 32000, NULL,  '5.7L HEMI: replace cabin / A/C filter every 20k mi (32k km) per Mopar Challenger LC 2017 OM p.489.');

-- Add SRT 6.4L rows (6k OCI, 150k plugs, 12k cabin filter, 6k rotate).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen_ch, @eng_64, 'engine_oil_and_filter',   6000, 10000,  6,   '6.4L 392 SRT HEMI (Scat Pack / SRT 392) — max 6k mi / 10k km / 6 mo OCI. SAE 0W-40 Pennzoil Ultra Platinum MS-12633. Mopar Challenger LC 2017 OM p.492.'),
  (@gen_ch, @eng_64, 'spark_plugs',           150000,240000, NULL, '6.4L 392 SRT: spark plugs at 150k mi (240k km) — mileage-only per Mopar Challenger LC 2017 OM p.495.'),
  (@gen_ch, @eng_64, 'tire_rotation',           6000, 10000, NULL, '6.4L SRT: rotate tires at every oil change (every 6k mi) per Mopar Challenger LC 2017 OM p.494.'),
  (@gen_ch, @eng_64, 'cabin_air_filter',      12000, 19000, NULL,  '6.4L 392 SRT: replace cabin / A/C filter every 12k mi (19k km) per Mopar Challenger LC 2017 OM p.495.');

-- Add Hellcat 6.2L rows (same OCI cadence as 6.4L; OM defers spark-plug spec to the Hellcat supplement).
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen_ch, @eng_hk, 'engine_oil_and_filter',   6000, 10000,  6,   '6.2L Supercharged HEMI (Hellcat) — max 6k mi / 10k km / 6 mo OCI. SAE 0W-40 Pennzoil Ultra Platinum MS-12633. Mopar Challenger LC 2017 OM (Hellcat supplement).'),
  (@gen_ch, @eng_hk, 'tire_rotation',           6000, 10000, NULL, '6.2L Hellcat: rotate tires at every oil change (every 6k mi) per Mopar Challenger LC 2017 OM (SRT-class schedule).'),
  (@gen_ch, @eng_hk, 'cabin_air_filter',      12000, 19000, NULL,  '6.2L Hellcat: replace cabin / A/C filter every 12k mi (19k km) per Mopar Challenger LC 2017 OM (SRT-class schedule).');

-- Cite all the new rows.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src_ch,
       CASE
         WHEN si.engine_id=@eng_57 AND si.service='engine_oil_and_filter' THEN 487
         WHEN si.engine_id=@eng_57 AND si.service='spark_plugs'           THEN 489
         WHEN si.engine_id=@eng_57 AND si.service='tire_rotation'         THEN 488
         WHEN si.engine_id=@eng_57 AND si.service='cabin_air_filter'      THEN 489
         WHEN si.engine_id=@eng_64 AND si.service='engine_oil_and_filter' THEN 492
         WHEN si.engine_id=@eng_64 AND si.service='spark_plugs'           THEN 495
         WHEN si.engine_id=@eng_64 AND si.service='tire_rotation'         THEN 494
         WHEN si.engine_id=@eng_64 AND si.service='cabin_air_filter'      THEN 495
         WHEN si.engine_id=@eng_hk AND si.service='engine_oil_and_filter' THEN 492
         WHEN si.engine_id=@eng_hk AND si.service='tire_rotation'         THEN 494
         WHEN si.engine_id=@eng_hk AND si.service='cabin_air_filter'      THEN 495
       END
FROM service_intervals si
WHERE si.generation_id=@gen_ch
  AND si.engine_id IN (@eng_57,@eng_64,@eng_hk)
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src_ch
  );
