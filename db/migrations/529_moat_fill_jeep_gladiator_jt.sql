-- mig 529 — moat-fill Jeep Gladiator JT 2022 from US OM.
-- Source: Jeep_Gladiator_JT_2022_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 870 already exists; reuse directly. Notes ≤255 chars (varchar).

SET NAMES utf8mb4;

SET @gen := 334;
SET @src := 870;

UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10,000 mi / 16,000 km / 12 mo / 350 hr per Mopar Gladiator JT 2022 OM p.300. 3.6L Pentastar = SAE 0W-20 MS-6395; 3.0L EcoDiesel = SAE 5W-40 MS-12991.'
WHERE id=3386;

UPDATE service_intervals SET
  notes='Rotate at first sign of irregular wear, or every oil-change interval per Mopar Gladiator JT 2022 OM p.300.'
WHERE id=3387;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses and parking brake at every oil-change interval per Mopar Gladiator JT 2022 OM p.300.'
WHERE id=3388;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air cleaner every 30k mi (48k km) — 30/60/90/120/150k per Mopar Gladiator JT 2022 OM p.303 (gas) / p.307 (diesel).'
WHERE id=3389;

UPDATE service_intervals SET miles_normal=100000, km_normal=160000, months=NULL,
  notes='3.6L Pentastar: spark plugs at 100k mi (160k km). Mileage-only — yearly intervals do NOT apply per Mopar Gladiator JT 2022 OM p.304.'
WHERE id=3390;

UPDATE service_intervals SET
  notes='850RE 8-speed automatic (ZF 8HP-derived) — fill-for-life under normal use; OM publishes no normal-duty interval. Fluid: Mopar MS-12892.'
WHERE id=3392;

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'cabin_air_filter',     12000, 19000, NULL, 'Cabin air filter every 12k mi (19k km); mileage-only. Both gas + diesel per Mopar Gladiator JT 2022 OM p.303 / p.307.'),
  (@gen, 'fuel_filter',          10000, 16000,   12, '3.0L EcoDiesel only: replace fuel filter and drain water at every oil change (max 10k mi / 12 mo). 8k mi / 6 mo on B6–B20. Mopar OM p.305.'),
  (@gen, 'accessory_drive_belt',100000,160000, NULL, '3.0L EcoDiesel only: replace accessory drive belt(s) at 100k mi (160k km) per Mopar Gladiator JT 2022 OM p.307.'),
  (@gen, 'def_fluid_refill',     10000, 16000,   12, '3.0L EcoDiesel only: fill DEF tank at every oil change (max 10k mi / 12 mo). DEF API-Certified to ISO 22241. Mopar OM p.306.'),
  (@gen, 'tire_pressure_check',  NULL,  NULL,    1, 'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Gladiator JT 2022 OM p.300.'),
  (@gen, 'fluid_level_check',    NULL,  NULL,    1, 'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder, power steering per Mopar OM p.300.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src,
       CASE service
         WHEN 'cabin_air_filter'     THEN 303
         WHEN 'fuel_filter'          THEN 305
         WHEN 'accessory_drive_belt' THEN 307
         WHEN 'def_fluid_refill'     THEN 306
         WHEN 'tire_pressure_check'  THEN 300
         WHEN 'fluid_level_check'    THEN 300
       END
FROM service_intervals
WHERE generation_id=@gen
  AND service IN ('cabin_air_filter','fuel_filter','accessory_drive_belt','def_fluid_refill','tire_pressure_check','fluid_level_check');
