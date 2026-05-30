-- mig 545 — Charger LD 2017 (gen 122): clean up duplicate svc rows from
-- two prior seeding sessions, engine-attribute the V6 / 5.7L / 6.4L SRT /
-- Hellcat schedule, correct coolant_flush (was 100k mi; OM specifies 150k),
-- and add the rows that were missing (per-engine OCI/plugs splits,
-- brake_inspection, monthly tire+fluid checks).
--
-- Source: Dodge_Charger_LD_2017_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source 860 already exists (oem_manual, public_link=1) and was used by
-- the second seeding round. Older rows cite legacy sources 590/598/611
-- which we keep as historical aggregator citations.
--
-- Engines: 138 = ERB 3.6L Pentastar V6; 166 = EZH 5.7L HEMI;
--          167 = ESG 6.4L 392 SRT HEMI; 168 = EWB 6.2L Supercharged Hellcat.

SET NAMES utf8mb4;

SET @gen     := 122;
SET @src     := 860;
SET @eng_v6  := 138;
SET @eng_57  := 166;
SET @eng_64  := 167;
SET @eng_hk  := 168;

-- ---- DROP DUPS ------------------------------------------------------------
-- 864 (cabin_air_filter 24k mi, legacy) vs 3294 (cabin_filter 20k mi, OM-cited):
-- 20k mi is correct per OM p.490; keep 3294 but rename to canonical slug.
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (864,3293,867);
DELETE FROM service_intervals WHERE id IN (864,3293,867);

-- ---- UPDATE CANONICAL ROWS ------------------------------------------------
-- 861 engine_oil: OM specifies 10k mi / 12 mo (legacy row had 8k mi).
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12, engine_id=@eng_v6,
  notes='3.6L Pentastar V6 (SXT/GT): max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Charger LD 2017 OM p.487. SAE 5W-20 MS-6395. SRT/Hellcat have separate 6k mi schedule.'
WHERE id=861;

-- 862 tire_rotation: at every oil change, no specific mileage (was 8k mi).
UPDATE service_intervals SET miles_normal=NULL, km_normal=NULL, engine_id=@eng_v6,
  notes='V6/HEMI: rotate tires at every oil-change interval per Mopar Charger LD 2017 OM p.488. First sign of irregular wear takes precedence.'
WHERE id=862;

-- 863 engine_air_filter: 30k mi (correct, kept).
UPDATE service_intervals SET engine_id=@eng_v6,
  notes='V6/HEMI: replace engine air cleaner every 30k mi (48k km) — 30/60/90/120/150k schedule per Mopar Charger LD 2017 OM p.489. Same cadence on SRT 6.4L per OM p.495.'
WHERE id=863;

-- 865 transmission_at: rename + add note (60k mi is severe-duty).
UPDATE service_intervals SET service='transmission_at_fluid_severe', miles_normal=60000, km_normal=96000, engine_id=@eng_v6,
  notes='ZF 8HP70 8-speed automatic — severe-duty ATF + filter change at 60k mi (police/taxi/fleet/towing). Normal use: fill-for-life per Mopar Charger LD 2017 OM. Fluid: MS-12892.'
WHERE id=865;

-- 866 rear_diff_oil → rear_differential_fluid_inspection (AWD only).
UPDATE service_intervals SET service='rear_differential_fluid_inspection', miles_normal=20000, km_normal=32000,
  notes='AWD only: inspect rear axle fluid every 20k mi (32k km); change at severe-duty (police/taxi/fleet/off-road/towing) per Mopar Charger LD 2017 OM p.489-491.'
WHERE id=866;

-- 868 brake_fluid_flush: keep, refine note.
UPDATE service_intervals SET
  notes='Brake fluid: replace every 24 months — time-based only per Mopar Charger LD 2017 OM. Mopar DOT 3 or DOT 4 LV per master cylinder cap label.'
WHERE id=868;

-- 920 wiper_blades: keep, refine note.
UPDATE service_intervals SET
  notes='Inspect/replace wiper blades annually or sooner if streaking/skipping per Mopar Charger LD 2017 OM.'
WHERE id=920;

-- 921 drive_belt_inspection: align with Mopar standard 150k mi.
UPDATE service_intervals SET service='accessory_drive_belt_replacement', miles_normal=150000, km_normal=240000, months=NULL,
  notes='Replace front accessory drive belt at 150k mi (240k km) per Mopar Charger LD 2017 OM p.491.'
WHERE id=921;

-- 922 battery_12v_inspect: keep but legacy 8k mi is non-OM; correct to monthly.
UPDATE service_intervals SET miles_normal=NULL, km_normal=NULL, months=1,
  notes='Inspect 12V battery (terminals, cable tightness, corrosion) monthly per Mopar Charger LD 2017 OM p.487. Maintenance-free (AGM on SRT/Hellcat).'
WHERE id=922;

-- 3294 cabin_filter → cabin_air_filter (canonical slug), V6/HEMI 20k mi.
UPDATE service_intervals SET service='cabin_air_filter', miles_normal=20000, km_normal=32000, engine_id=@eng_v6,
  notes='V6/HEMI: replace cabin / A/C filter every 20k mi (32k km) per Mopar Charger LD 2017 OM p.489. SRT 6.4L every 12k mi (separate row).'
WHERE id=3294;

-- 3295 spark_plugs: V6 100k mi (kept; attribute to V6).
UPDATE service_intervals SET miles_normal=100000, km_normal=160000, engine_id=@eng_v6,
  notes='3.6L Pentastar V6: spark plugs at 100k mi (160k km) — mileage-only, yearly intervals do NOT apply per Mopar Charger LD 2017 OM p.490.'
WHERE id=3295;

-- 3296 coolant_flush: CORRECT 100k → 150k mi.
UPDATE service_intervals SET miles_normal=150000, km_normal=240000, months=120,
  notes='Flush and replace engine coolant at 10 yr / 150k mi (240k km) whichever comes first per Mopar Charger LD 2017 OM p.490. Coolant: Mopar OAT 10yr/150k (FCA MS.90032).'
WHERE id=3296;

-- 3297 transfer_case → transfer_case_fluid_inspection (AWD only, severe duty change).
UPDATE service_intervals SET service='transfer_case_fluid_change_severe', miles_normal=60000, km_normal=96000,
  notes='AWD only: change transfer case fluid every 60k mi (96k km) severe-duty (police/taxi/fleet/off-road/towing) per Mopar Charger LD 2017 OM p.490.'
WHERE id=3297;

-- 3298 axle_fluid_change → differential_fluid_change_severe.
UPDATE service_intervals SET service='differential_fluid_change_severe', miles_normal=60000, km_normal=96000,
  notes='Severe-duty change (police/taxi/fleet/off-road/towing): rear axle (and front on AWD) fluid every 60k mi (96k km) per Mopar Charger LD 2017 OM p.491.'
WHERE id=3298;

-- 3299 pcv_valve → pcv_valve_inspection.
UPDATE service_intervals SET service='pcv_valve_inspection', miles_normal=100000, km_normal=160000,
  notes='Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Charger LD 2017 OM p.491.'
WHERE id=3299;

-- ---- ADD MISSING PER-ENGINE ROWS ------------------------------------------
-- 5.7L HEMI mirror rows.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_57, 'engine_oil_and_filter', 10000, 16000, 12,   '5.7L HEMI V8 (R/T): max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Charger LD 2017 OM p.487. SAE 5W-20 MS-6395.'),
  (@gen, @eng_57, 'tire_rotation',         NULL,  NULL,  NULL, '5.7L HEMI: rotate tires at every oil-change interval per Mopar Charger LD 2017 OM p.488.'),
  (@gen, @eng_57, 'spark_plugs',          100000,160000, NULL, '5.7L HEMI V8 (EZH): spark plugs at 100k mi (160k km) — mileage-only per Mopar Charger LD 2017 OM p.490.'),
  (@gen, @eng_57, 'cabin_air_filter',     20000, 32000, NULL,  '5.7L HEMI: cabin / A/C filter every 20k mi (32k km) per Mopar Charger LD 2017 OM p.489.');

-- SRT 6.4L 392.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_64, 'engine_oil_and_filter',  6000, 10000,  6,   '6.4L 392 SRT HEMI: max 6k mi / 10k km / 6 mo OCI per Mopar Charger LD 2017 OM p.492. 0W-40 Pennzoil Ultra Platinum MS-12633.'),
  (@gen, @eng_64, 'tire_rotation',          6000, 10000, NULL, '6.4L SRT: rotate tires every 6k mi (every oil change) per Mopar Charger LD 2017 OM p.494.'),
  (@gen, @eng_64, 'spark_plugs',          150000,240000, NULL, '6.4L 392 SRT (ESG): spark plugs at 150k mi (240k km) — mileage-only per Mopar Charger LD 2017 OM p.495.'),
  (@gen, @eng_64, 'cabin_air_filter',     12000, 19000, NULL,  '6.4L SRT: cabin / A/C filter every 12k mi (19k km) per Mopar Charger LD 2017 OM p.495.');

-- Hellcat 6.2L.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_hk, 'engine_oil_and_filter',  6000, 10000,  6,   '6.2L Supercharged HEMI (Hellcat): max 6k mi / 10k km / 6 mo OCI per Mopar Charger LD 2017 OM (Hellcat supplement). 0W-40 Pennzoil Ultra Platinum MS-12633.'),
  (@gen, @eng_hk, 'tire_rotation',          6000, 10000, NULL, '6.2L Hellcat: rotate tires every 6k mi (every oil change) per Mopar Charger LD 2017 OM (Hellcat supplement).'),
  (@gen, @eng_hk, 'cabin_air_filter',     12000, 19000, NULL,  '6.2L Hellcat: cabin / A/C filter every 12k mi (19k km) per Mopar Charger LD 2017 OM (Hellcat supplement).');

-- Gen-wide adds.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'brake_inspection',            NULL,  NULL, NULL, 'Inspect brake pads/shoes/rotors/drums/hoses at every oil change per Mopar Charger LD 2017 OM p.488. Linings every 20k mi (V6/HEMI) or 12k mi (SRT 6.4L) per OM p.489/495.'),
  (@gen, NULL, 'tire_pressure_check',         NULL,  NULL,  1,   'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Charger LD 2017 OM p.487.'),
  (@gen, NULL, 'fluid_level_check',           NULL,  NULL,  1,   'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder, power steering per Mopar Charger LD 2017 OM p.487.');

-- ---- CITATIONS ------------------------------------------------------------
-- Add page numbers to the existing source-860 citations (3294 etc.).
UPDATE spec_sources SET page_number=489 WHERE spec_table='service_intervals' AND spec_id=3294 AND source_id=@src;
UPDATE spec_sources SET page_number=490 WHERE spec_table='service_intervals' AND spec_id=3295 AND source_id=@src;
UPDATE spec_sources SET page_number=490 WHERE spec_table='service_intervals' AND spec_id=3296 AND source_id=@src;
UPDATE spec_sources SET page_number=490 WHERE spec_table='service_intervals' AND spec_id=3297 AND source_id=@src;
UPDATE spec_sources SET page_number=491 WHERE spec_table='service_intervals' AND spec_id=3298 AND source_id=@src;
UPDATE spec_sources SET page_number=491 WHERE spec_table='service_intervals' AND spec_id=3299 AND source_id=@src;

-- Cite each canonical row to the OM (source 860) with a page number.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'engine_oil_and_filter'             THEN 487
         WHEN 'tire_rotation'                     THEN 488
         WHEN 'engine_air_filter'                 THEN 489
         WHEN 'cabin_air_filter'                  THEN 489
         WHEN 'spark_plugs'                       THEN 490
         WHEN 'transmission_at_fluid_severe'      THEN 491
         WHEN 'rear_differential_fluid_inspection' THEN 489
         WHEN 'brake_fluid_flush'                 THEN 491
         WHEN 'accessory_drive_belt_replacement'  THEN 491
         WHEN 'transfer_case_fluid_change_severe' THEN 490
         WHEN 'differential_fluid_change_severe'  THEN 491
         WHEN 'pcv_valve_inspection'              THEN 491
         WHEN 'brake_inspection'                  THEN 488
         WHEN 'tire_pressure_check'               THEN 487
         WHEN 'fluid_level_check'                 THEN 487
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
