-- mig 538 — moat-fill Dodge Journey JC 2018 from US OM.
-- Source: Dodge_Journey_JC_2018_OM_Mopar.pdf (vehicleinfo.mopar.com).
-- Source row 877 already exists (oem_manual, public_link=1).
-- Engines: 138 = 3.6L Pentastar V6 (ERB); 2039 = 2.4L ED3 World Engine I4.

SET NAMES utf8mb4;

SET @gen    := 340;
SET @src    := 877;
SET @eng_v6 := 138;
SET @eng_24 := 2039;

-- Update existing rows with OM-stated values.
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, months=12,
  notes='Max 10k mi / 16k km / 12 mo / 350 hr OCI per Mopar Journey JC 2018 OM p.301. Severe duty: 4k mi (6.5k km). 2.4L: 5W-20 MS-6395; 3.6L Pentastar: 5W-20 MS-6395.'
WHERE id=3358;

UPDATE service_intervals SET
  notes='Rotate tires at every oil-change interval per Mopar Journey JC 2018 OM p.301. First sign of irregular wear takes precedence.'
WHERE id=3359;

UPDATE service_intervals SET
  notes='Inspect brake pads/shoes/rotors/drums/hoses at every oil change; brake linings every 20k mi (32k km) per Mopar Journey JC 2018 OM p.302-303.'
WHERE id=3360;

UPDATE service_intervals SET miles_normal=30000, km_normal=48000,
  notes='Replace engine air filter every 30k mi (48k km) — 30/60/90/120/150k per Mopar Journey JC 2018 OM p.303.'
WHERE id=3361;

-- 2.4L plugs at 30k mi (every 30k schedule, copper). Re-attribute to engine 2039.
UPDATE service_intervals SET miles_normal=30000, km_normal=48000, engine_id=@eng_24,
  notes='2.4L ED3 World Engine: spark plugs every 30k mi (48k km) — mileage-only per Mopar Journey JC 2018 OM p.303 (X at 30/60/90/120/150k schedule).'
WHERE id=3362;

UPDATE service_intervals SET
  notes='62TE 6-speed automatic — change ATF + filter at 150k mi (240k km); severe-duty (police/taxi/fleet/towing) at 60k mi (96k km). Fluid: Mopar ATF+4 (MS-9602). Mopar Journey JC 2018 OM p.303.'
WHERE id=3364;

-- 3.6L V6 plug interval (different from 2.4L). Add new row.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, @eng_v6, 'spark_plugs',                100000,160000, NULL, '3.6L Pentastar V6 (ERB): spark plugs at 100k mi (160k km) — mileage-only per Mopar Journey JC 2018 OM p.303.'),
  (@gen, NULL,    'cabin_air_filter',            20000, 32000, NULL, 'Replace air conditioning filter every 20k mi (32k km) per Mopar Journey JC 2018 OM p.303.'),
  (@gen, NULL,    'rear_drive_assembly_fluid_change', 60000, 96000, NULL, 'AWD only: replace rear drive assembly (RDA) fluid at 60k mi (96k km) per Mopar Journey JC 2018 OM p.304.'),
  (@gen, NULL,    'power_transfer_unit_fluid_change', 60000, 96000, NULL, 'AWD only: replace power transfer unit (PTU) fluid at 60k mi (96k km) per Mopar Journey JC 2018 OM p.304.'),
  (@gen, NULL,    'pcv_valve_inspection',       100000,160000, NULL, 'Inspect PCV valve at 100k mi (160k km); replace if necessary per Mopar Journey JC 2018 OM p.304.'),
  (@gen, NULL,    'tire_pressure_check',         NULL,  NULL,    1,  'Once a month or before a long trip: check tire pressures (incl. spare) and look for wear/damage per Mopar Journey JC 2018 OM p.301.'),
  (@gen, NULL,    'fluid_level_check',           NULL,  NULL,    1,  'Once a month or before a long trip: check engine oil, washer fluid, coolant, brake master cylinder per Mopar Journey JC 2018 OM p.301.');

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', si.id, @src,
       CASE
         WHEN si.engine_id=@eng_v6 AND si.service='spark_plugs'      THEN 303
         WHEN si.service='cabin_air_filter'                          THEN 303
         WHEN si.service='rear_drive_assembly_fluid_change'          THEN 304
         WHEN si.service='power_transfer_unit_fluid_change'          THEN 304
         WHEN si.service='pcv_valve_inspection'                      THEN 304
         WHEN si.service='tire_pressure_check'                       THEN 301
         WHEN si.service='fluid_level_check'                         THEN 301
       END
FROM service_intervals si
WHERE si.generation_id=@gen
  AND (
    (si.engine_id=@eng_v6 AND si.service='spark_plugs')
    OR si.service IN ('cabin_air_filter','rear_drive_assembly_fluid_change','power_transfer_unit_fluid_change','pcv_valve_inspection','tire_pressure_check','fluid_level_check')
  )
  AND NOT EXISTS (
    SELECT 1 FROM spec_sources ss
    WHERE ss.spec_table='service_intervals' AND ss.spec_id=si.id AND ss.source_id=@src
  );
