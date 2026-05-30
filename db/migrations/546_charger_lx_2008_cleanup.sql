-- mig 546 — Charger LX 2008 (gen 123): dedup partial rows from a second seeding
-- session, correct OCI months (was 12; OM specifies 6), and add the missing
-- gen-wide rows. The older engine-attributed rows (869, 871, 873, 877, 882, 929-931)
-- already correctly capture: OCI 6k mi, 5.7L HEMI EZB plugs at 30k mi (Eagle copper
-- era), 2.7L EER + 3.5L EGG + 6.1L SRT plugs at 102k mi, 3.5L timing belt at 102k mi.
--
-- Source: Dodge_Charger_LX_2008_OM_Mopar.pdf (vehicleinfo.mopar.com, source 859).

SET NAMES utf8mb4;

SET @gen := 123;
SET @src := 859;

-- DROP partial duplicates from second seeding round.
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (3332,3333,3334,3335,3337);
DELETE FROM service_intervals WHERE id IN (3332,3333,3334,3335,3337);

-- CORRECT OCI months on the canonical row (869 had 12; OM p.428 specifies 6).
UPDATE service_intervals SET miles_normal=6000, km_normal=10000, months=6,
  notes='Max 6k mi (10k km) or 6 mo OCI per Mopar Charger LX 2008 OM. Older Mopar OCI era. 2.7L/3.5L V6 and 5.7L/6.1L HEMI V8.'
WHERE id=869;

-- 3336 is a new brake_inspection row — confirm and refine its notes.
UPDATE service_intervals SET miles_normal=6000, km_normal=10000, months=NULL,
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change (6k mi / 10k km) per Mopar Charger LX 2008 OM. Brake linings every 12k mi (20k km).'
WHERE id=3336;

UPDATE service_intervals SET
  notes='Rotate tires at every oil change (6k mi / 10k km) per Mopar Charger LX 2008 OM.'
WHERE id=870;

UPDATE service_intervals SET
  notes='Engine air cleaner: replace at 30k mi (50k km) or 30 mo per Mopar Charger LX 2008 OM. Inspect every 12k mi if used in dusty/off-road conditions.'
WHERE id=871;

UPDATE service_intervals SET
  notes='5.7L HEMI V8 (EZB, Eagle 16-plug): replace spark plugs every 30k mi (50k km) or 30 mo per Mopar Charger LX 2008 OM. Mileage-based copper-plug spec — modern Eagle 5.7L iridium spec is 100k mi.'
WHERE id=873;

UPDATE service_intervals SET
  notes='2.7L EER V6 (SOHC): replace spark plugs every 102k mi (170k km) per Mopar Charger LX 2008 OM. Iridium plugs.'
WHERE id=929;

UPDATE service_intervals SET
  notes='3.5L EGG V6 (SOHC): replace spark plugs every 102k mi (170k km) per Mopar Charger LX 2008 OM. Iridium plugs. (3.5L also has a 102k mi timing belt — separate row.)'
WHERE id=930;

UPDATE service_intervals SET
  notes='6.1L SRT8 HEMI V8 (ESF Apache, 425 hp) — interval taken from main LX schedule. SRT supplement may specify a shorter cadence; verify against the SRT8 supplement when available.'
WHERE id=931;

UPDATE service_intervals SET
  notes='3.5L EGG V6 timing belt: replace at 102k mi (170k km) or 102 mo per Mopar Charger LX 2008 OM. Interference engine — failure to replace can cause catastrophic engine damage.'
WHERE id=880;

UPDATE service_intervals SET
  notes='2.7L EER V6 accessory drive belt: replace at 120k mi (200k km) or 120 mo per Mopar Charger LX 2008 OM.'
WHERE id=882;

-- ADD missing gen-wide rows.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'cabin_air_filter',       12000, 20000, NULL, 'A/C filter (cabin): replace every 12k mi (20k km) per Mopar Charger LX 2008 OM. Mileage-only.'),
  (@gen, NULL, 'tire_pressure_check',     NULL,  NULL,  1,   'Check tire pressures monthly (cold pressure, including spare) per Mopar Charger LX 2008 OM.'),
  (@gen, NULL, 'fluid_level_check',       NULL,  NULL,  1,   'Check engine oil, washer fluid, coolant reservoir, brake master cylinder monthly per Mopar Charger LX 2008 OM.'),
  (@gen, NULL, 'cv_joint_inspection',    24000, 40000,  24,  'Inspect CV joints first at 12k mi (20k km), then every 24k mi (40k km) per Mopar Charger LX 2008 OM.'),
  (@gen, NULL, 'exhaust_system_inspection',24000,40000, 24,  'Inspect exhaust system first at 12k mi (20k km), then every 24k mi (40k km) per Mopar Charger LX 2008 OM.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE si.service
         WHEN 'cabin_air_filter'           THEN 430
         WHEN 'tire_pressure_check'        THEN 428
         WHEN 'fluid_level_check'          THEN 428
         WHEN 'cv_joint_inspection'        THEN 429
         WHEN 'exhaust_system_inspection'  THEN 429
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND si.service IN ('cabin_air_filter','tire_pressure_check','fluid_level_check','cv_joint_inspection','exhaust_system_inspection')
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );

-- Re-cite the brake_inspection row (3336) which was added in earlier seeding.
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', 3336, @src, 429
WHERE NOT EXISTS (
  SELECT 1 FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id=3336 AND ss.source_id=@src
);
