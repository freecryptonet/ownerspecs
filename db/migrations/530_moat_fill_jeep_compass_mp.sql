-- mig 530 — moat-fill Jeep Compass MP 2022 from US OM.
-- Source: Jeep_Compass_MP_2022_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 873 already exists; reuse directly. Notes ≤255 chars.

SET NAMES utf8mb4;

SET @gen := 337;
SET @src := 873;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10,000 mi / 16,000 km / 1 yr / 350 hr per Mopar Compass MP 2022 OM p.257-259. 2.4L Tigershark: SAE 0W-20 full synthetic, MS-6395.'
WHERE id=3372;

UPDATE service_intervals SET
  notes='Rotate at first sign of irregular wear, or every oil-change interval per Mopar Compass MP 2022 OM p.258.'
WHERE id=3373;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses every oil change; inspect brake linings every 20k mi (32k km) per Mopar Compass MP 2022 OM p.258-259.'
WHERE id=3374;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air cleaner every 30k mi (48k km) — 30/60/90/120/150k per Mopar Compass MP 2022 OM p.259.'
WHERE id=3375;

UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL,
  notes='2.4L Tigershark: spark plugs at 100k mi (160k km). Mileage-only — yearly intervals do NOT apply per Mopar Compass MP 2022 OM p.260.'
WHERE id=3376;

UPDATE service_intervals SET
  notes='Aisin AW 6AT (FWD) or ZF 9HP48 9AT (4WD) — fill-for-life under normal use. Fluid: Mopar AW-1 (6AT) or MS-12892 (9AT) per Compass MP 2022 OM.'
WHERE id=3378;

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'cabin_air_filter',     12000, 19000, NULL, 'Cabin air filter every 12k mi (19k km); mileage-only per Mopar Compass MP 2022 OM p.259.'),
  (@gen, 'accessory_drive_belt',150000,240000, NULL, 'Inspect front accessory drive belt, tensioner, idler pulley at 150k mi (240k km); replace if necessary per Mopar Compass MP 2022 OM p.259.'),
  (@gen, 'pcv_valve_inspection',140000,224000, NULL, 'Inspect PCV valve at 140k mi (224k km); replace if necessary per Mopar Compass MP 2022 OM p.260.'),
  (@gen, 'tire_pressure_check',  NULL,  NULL,    1, 'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Compass MP 2022 OM p.259.'),
  (@gen, 'fluid_level_check',    NULL,  NULL,    1, 'Once a month or before a long trip: check engine oil, washer fluid, coolant reservoir, brake master cylinder per Mopar Compass MP 2022 OM p.259.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src,
       CASE service
         WHEN 'cabin_air_filter'      THEN 259
         WHEN 'accessory_drive_belt'  THEN 259
         WHEN 'pcv_valve_inspection'  THEN 260
         WHEN 'tire_pressure_check'   THEN 259
         WHEN 'fluid_level_check'     THEN 259
       END
FROM service_intervals
WHERE generation_id=@gen
  AND service IN ('cabin_air_filter','accessory_drive_belt','pcv_valve_inspection','tire_pressure_check','fluid_level_check');
