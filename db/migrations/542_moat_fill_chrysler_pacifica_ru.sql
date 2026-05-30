-- mig 542 — moat-fill Chrysler Pacifica RU 2020 from US OM.
-- Source: Chrysler_Pacifica_RU_2020_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 862 (gas OM) and 865 (PHEV supplement) already exist.
-- Single engine: 59 = ERC 3.6L Pentastar V6 (both gas and PHEV).
--
-- Cleans 3 duplicate rows from an earlier session (engine_air_filter,
-- cabin_filter, spark_plugs) and corrects coolant_flush from 100k mi
-- (wrong) to 150k mi (per OM p.348).

SET NAMES utf8mb4;

SET @gen    := 86;
SET @src    := 862;
SET @eng_v6 := 59;

-- Drop duplicate rows from earlier seeding (canonical rows are 682, 683, 686).
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (3287,3288,3289);
DELETE FROM service_intervals WHERE id IN (3287,3288,3289);

-- Correct coolant interval (was 100k mi; OM specifies 150k mi / 10 yr).
UPDATE service_intervals SET miles_normal=150000, km_normal=240000, months=120,
  notes='Flush and replace engine coolant at 10 yr / 150k mi (240k km) whichever comes first per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=3291;

-- Attach engine_id + refine notes on existing rows.
UPDATE service_intervals SET engine_id=@eng_v6,
  notes='3.6L Pentastar V6: max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Pacifica RU 2020 OM p.345. SAE 0W-20 MS-6395. Pacifica Hybrid shares engine + spec.'
WHERE id=681;

UPDATE service_intervals SET
  notes='Replace engine air cleaner every 30k mi (48k km) — 30/60/90/120/150k schedule per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=682;

UPDATE service_intervals SET
  notes='Replace cabin / A/C filter every 20k mi (32k km) per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=683;

UPDATE service_intervals SET service='transmission_at_fluid_change', miles_normal=60000, km_normal=96000, months=NULL,
  notes='9-speed automatic ATF + filter change at 60k mi (96k km) severe-duty (police/taxi/fleet/towing); ZF 948TE on gas, eFlite on Hybrid. Mopar Pacifica RU 2020 OM.'
WHERE id=684;

UPDATE service_intervals SET
  notes='Brake fluid change every 24 months (time-based, not mileage) per Mopar Pacifica RU 2020 OM.'
WHERE id=685;

UPDATE service_intervals SET engine_id=@eng_v6,
  notes='3.6L Pentastar V6: spark plugs at 100k mi (160k km) — mileage-only, yearly intervals do NOT apply per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=686;

UPDATE service_intervals SET service='accessory_drive_belt_replacement',
  notes='Replace front accessory drive belt at 150k mi (240k km) per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=3290;

UPDATE service_intervals SET service='pcv_valve_replacement',
  notes='Replace PCV valve at 100k mi (160k km) per Mopar Pacifica RU 2020 OM p.348.'
WHERE id=3292;

-- Attach page numbers to existing spec_sources.
UPDATE spec_sources SET page_number=345 WHERE spec_table='service_intervals' AND spec_id IN (681) AND source_id=@src;
UPDATE spec_sources SET page_number=348 WHERE spec_table='service_intervals' AND spec_id IN (682,683,3291,3290,3292) AND source_id=@src;
UPDATE spec_sources SET page_number=348 WHERE spec_table='service_intervals' AND spec_id IN (684,686) AND source_id=@src;
UPDATE spec_sources SET page_number=348 WHERE spec_table='service_intervals' AND spec_id IN (685) AND source_id=@src;

-- Add missing items.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_v6, 'tire_rotation',    NULL, NULL, NULL, 'Rotate tires at every oil-change interval per Mopar Pacifica RU 2020 OM p.346. First sign of irregular wear takes precedence.'),
  (@gen, NULL,    'brake_inspection', NULL, NULL, NULL, 'Inspect brake pads/shoes/rotors/drums/hoses at every oil change; linings every 20k mi (32k km) per Mopar Pacifica RU 2020 OM p.346.'),
  (@gen, NULL,    'tire_pressure_check', NULL, NULL, 1, 'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Pacifica RU 2020 OM p.345.'),
  (@gen, NULL,    'fluid_level_check',   NULL, NULL, 1, 'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Pacifica RU 2020 OM p.345.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'tire_rotation'        THEN 346
         WHEN 'brake_inspection'     THEN 346
         WHEN 'tire_pressure_check'  THEN 345
         WHEN 'fluid_level_check'    THEN 345
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('tire_rotation','brake_inspection','tire_pressure_check','fluid_level_check')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
