-- mig 531 — moat-fill Dodge Challenger LC 2017 from US OM.
-- Source: Dodge_Challenger_LC_2017_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 868 already exists; reuse directly. Notes ≤255 chars.
--
-- The 2017 LX/LC ships with 4 engines:
--   3.6L Pentastar V6 / 5.7L HEMI V8 → 10k mi / 12 mo OCI
--   6.4L 392 SRT V8  / 6.2L Hellcat  → 6k mi / 6 mo OCI

SET NAMES utf8mb4;

SET @gen := 332;
SET @src := 868;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='V6/5.7 HEMI: max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Challenger LC 2017 OM p.487. 6.4L SRT + Hellcat 6.2L: 6k mi / 6 mo per OM p.492.'
WHERE id=3400;

UPDATE service_intervals SET
  notes='Rotate at first sign of irregular wear, or every oil-change interval per Mopar Challenger LC 2017 OM p.488 (V6/HEMI) / p.494 (6.4L SRT — every 6k mi).'
WHERE id=3401;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses every oil change; brake linings every 20k mi (V6/HEMI) or 12k mi (6.4L SRT) per Mopar Challenger LC 2017 OM.'
WHERE id=3402;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k for V6/HEMI per Mopar Challenger LC 2017 OM p.489; same cadence for 6.4L per p.495.'
WHERE id=3403;

UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL,
  notes='3.6L V6 + 5.7L HEMI: spark plugs at 100k mi (160k km) — mileage-only per Mopar Challenger LC 2017 OM p.489. 6.4L SRT: 150k mi (240k km) per OM p.495.'
WHERE id=3404;

UPDATE service_intervals SET
  notes='ZF 8HP70 8-speed automatic (845RE) — fill-for-life under normal use. Fluid: Mopar ZF 8 & 9 Speed ATF (MS-12892). Mopar Challenger LC 2017 OM.'
WHERE id=3406;

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'cabin_air_filter',     12000, 19000, NULL, 'Cabin / A/C filter every 12k mi (19k km) for 6.4L SRT per Mopar Challenger LC 2017 OM p.495; V6/HEMI cadence every 20k mi per OM p.489. Mileage-only.'),
  (@gen, 'pcv_valve_inspection',140000,224000, NULL, 'Inspect PCV valve at 140k mi (224k km); replace if necessary per Mopar Challenger LC 2017 OM p.491 (V6/HEMI) / p.495 (6.4L SRT).'),
  (@gen, 'tire_pressure_check',  NULL,  NULL,    1, 'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Challenger LC 2017 OM p.487 / p.493.'),
  (@gen, 'fluid_level_check',    NULL,  NULL,    1, 'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder, power steering per Mopar Challenger LC 2017 OM.'),
  (@gen, 'manual_transmission_fluid_inspection', 20000, 32000, NULL, 'Inspect TR-6060 6MT fluid every 20k mi (32k km) per Mopar Challenger LC 2017 OM p.489. Severe-duty change every 60k mi.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src,
       CASE service
         WHEN 'cabin_air_filter'                     THEN 489
         WHEN 'pcv_valve_inspection'                 THEN 491
         WHEN 'tire_pressure_check'                  THEN 487
         WHEN 'fluid_level_check'                    THEN 487
         WHEN 'manual_transmission_fluid_inspection' THEN 489
       END
FROM service_intervals
WHERE generation_id=@gen
  AND service IN ('cabin_air_filter','pcv_valve_inspection','tire_pressure_check','fluid_level_check','manual_transmission_fluid_inspection');
