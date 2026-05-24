-- mig 364: maintenance-schedule data from Mopar.com for 5 Stellantis gens
-- Scraped 2026-05-25 from www.mopar.com/en-us/my-vehicle/maintenance-schedule.html
-- Inspection-only items skipped (already covered by existing rows). Real replace/change/flush only.

-- gen 86 (Chrysler Pacifica (RU) 2020)
--   engine_air_filter              normal @30000mi  (Replace engine air cleaner filter.)
--   cabin_filter                   normal @20000mi  (Replace air conditioning/cabin air filter.)
--   spark_plugs                    normal @100000mi  (Replace spark plugs.)
--   drive_belt                     normal @150000mi  (Replace the front accessory drive belt.)
--   coolant_flush                  normal @100000mi  (Flush and replace the engine coolant at 10 years or 150,000 )
--   pcv_valve                      normal @100000mi  (Replace PCV valve.)
-- gen 122 (Dodge Charger (LD) 2017)
--   engine_air_filter              normal @30000mi  (Replace engine air filter.)
--   cabin_filter                   normal @20000mi  (Replace cabin/air conditioning filter.)
--   spark_plugs                    normal @100000mi  (Replace spark plugs.)
--   coolant_flush                  normal @100000mi  (Flush and replace the engine coolant at 10 years or 150,000 )
--   transfer_case                  severe @60000mi  (Change the transfer case fluid; if using your vehicle for an)
--   axle_fluid_change              severe @50000mi  (Change the rear axle fluid and on models equipped with All W)
--   pcv_valve                      normal @100000mi  (Inspect and replace PCV valve if necessary.)
-- gen 69 (Jeep Grand Cherokee (WL) 2023)
--   engine_air_filter              normal @30000mi  (Replace engine air cleaner filter.)
--   cabin_filter                   normal @20000mi  (Replace the cabin air filter.)
--   spark_plugs                    normal @60000mi  (Replace spark plugs - 2.0L. The spark plug change interval i)
--   spark_plugs                    normal @100000mi  (Replace spark plugs - 3.6L & 5.7L. The spark plug change int)
--   coolant_flush                  normal @100000mi  (Flush and replace the engine coolant at 10 years or 150,000 )
--   drive_belt                     normal @150000mi  (Replace accessory drive belt.)
--   transfer_case                  normal @120000mi  (Change transfer case fluid - Normal Usage.)
--   transfer_case                  severe @70000mi  (Change transfer case fluid - Severe Usage (police, taxi, fle)
--   pcv_valve                      normal @100000mi  (Replace PCV valve.)
-- gen 37 (Jeep Wrangler (JL) 2020)
--   engine_air_filter              normal @30000mi  (Replace engine air cleaner filter)
--   cabin_filter                   normal @20000mi  (Replace air conditioning/cabin air filter)
--   spark_plugs                    normal @60000mi  (Replace Spark Plugs - 2.0L Engine. The spark plug change int)
--   spark_plugs                    normal @100000mi  (Replace spark plugs - 3.6L Engine. The spark plug change int)
--   coolant_flush                  normal @100000mi  (Flush and replace the engine, intercooler (if equipped), bat)
--   transmission_mt                severe @30000mi  (Change the manual transmission fluid if using your vehicle f)
--   transfer_case                  severe @60000mi  (Change transfer case fluid if using your vehicle for any of )
--   pcv_valve                      normal @100000mi  (Inspect and replace PCV valve if necessary)
--   axle_fluid_change              severe @40000mi  (Change front and rear axle fluid if using your vehicle for p)
-- gen 43 (Ram 1500 (DT) 2022)
--   cabin_filter                   normal @20000mi  (Replace cabin air filter.)
--   evap_fresh_air_filter          severe @20000mi  (For severe dusty driving conditions, inspect and replace the)
--   engine_air_filter              normal @30000mi  (Replace engine air cleaner.)
--   drive_belt                     normal @150000mi  (If equipped with Stop/Start, replace accessory drive belt wi)
--   spark_plugs                    normal @100000mi  (Replace spark plugs. The spark plug change interval is milea)
--   coolant_flush                  normal @100000mi  (Flush and replace the engine coolant at 10 years or 150,000 )
--   transfer_case                  normal @120000mi  (Change the transfer case fluid.)
--   pcv_valve                      normal @100000mi  (Inspect and replace PCV valve if necessary.)

INSERT INTO service_intervals
  (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, notes)
VALUES
  (86, 'engine_air_filter', 30000, NULL, 48280, NULL, 'Replace engine air cleaner filter.'),
  (86, 'cabin_filter', 20000, NULL, 32187, NULL, 'Replace air conditioning/cabin air filter.'),
  (86, 'spark_plugs', 100000, NULL, 160934, NULL, 'Replace spark plugs.'),
  (86, 'drive_belt', 150000, NULL, 241402, NULL, 'Replace the front accessory drive belt.'),
  (86, 'coolant_flush', 100000, NULL, 160934, NULL, 'Flush and replace the engine coolant at 10 years or 150,000 miles (240,000 km) whichever comes first.'),
  (86, 'pcv_valve', 100000, NULL, 160934, NULL, 'Replace PCV valve.'),
  (122, 'engine_air_filter', 30000, NULL, 48280, NULL, 'Replace engine air filter.'),
  (122, 'cabin_filter', 20000, NULL, 32187, NULL, 'Replace cabin/air conditioning filter.'),
  (122, 'spark_plugs', 100000, NULL, 160934, NULL, 'Replace spark plugs.'),
  (122, 'coolant_flush', 100000, NULL, 160934, NULL, 'Flush and replace the engine coolant at 10 years or 150,000 miles (240,000 km) whichever comes first.'),
  (122, 'transfer_case', NULL, 60000, NULL, 96561, 'Change the transfer case fluid; if using your vehicle for any of the following: police, taxi, fleet, off-road, or frequent trailer towing. (All Wheel Drive Only).'),
  (122, 'axle_fluid_change', NULL, 50000, NULL, 80467, 'Change the rear axle fluid and on models equipped with All Wheel Drive (AWD) change the front axle fluid if using your vehicle for any of the following: police, taxi, fleet, off-road, or frequent trailer towing.'),
  (122, 'pcv_valve', 100000, NULL, 160934, NULL, 'Inspect and replace PCV valve if necessary.'),
  (69, 'engine_air_filter', 30000, NULL, 48280, NULL, 'Replace engine air cleaner filter.'),
  (69, 'cabin_filter', 20000, NULL, 32187, NULL, 'Replace the cabin air filter.'),
  (69, 'spark_plugs', 60000, NULL, 96561, NULL, 'Replace spark plugs - 2.0L. The spark plug change interval is mileage-based only, yearly intervals do not apply.'),
  (69, 'spark_plugs', 100000, NULL, 160934, NULL, 'Replace spark plugs - 3.6L & 5.7L. The spark plug change interval is mileage-based only, yearly intervals do not apply.'),
  (69, 'coolant_flush', 100000, NULL, 160934, NULL, 'Flush and replace the engine coolant at 10 years or 150,000 miles (240,000 km) whichever comes first.'),
  (69, 'drive_belt', 150000, NULL, 241402, NULL, 'Replace accessory drive belt.'),
  (69, 'transfer_case', 120000, NULL, 193121, NULL, 'Change transfer case fluid - Normal Usage.'),
  (69, 'transfer_case', NULL, 70000, NULL, 112654, 'Change transfer case fluid - Severe Usage (police, taxi, fleet, off-road, or frequent trailer towing).'),
  (69, 'pcv_valve', 100000, NULL, 160934, NULL, 'Replace PCV valve.'),
  (37, 'engine_air_filter', 30000, NULL, 48280, NULL, 'Replace engine air cleaner filter'),
  (37, 'cabin_filter', 20000, NULL, 32187, NULL, 'Replace air conditioning/cabin air filter'),
  (37, 'spark_plugs', 60000, NULL, 96561, NULL, 'Replace Spark Plugs - 2.0L Engine. The spark plug change interval is mileage based only, yearly intervals do not apply.'),
  (37, 'spark_plugs', 100000, NULL, 160934, NULL, 'Replace spark plugs - 3.6L Engine. The spark plug change interval is mileage based only, yearly intervals do not apply.'),
  (37, 'coolant_flush', 100000, NULL, 160934, NULL, 'Flush and replace the engine, intercooler (if equipped), battery (if equipped), and Motor Generator Unit (MGU) (if equipped) coolant at 10 years or 150,000 miles (240,000 km) whichever comes first'),
  (37, 'transmission_mt', NULL, 30000, NULL, 48280, 'Change the manual transmission fluid if using your vehicle for any of the following: trailer towing, snow plowing, heavy loading, taxi, police, delivery service (commercial service), off-road, desert operation or more than 50% of your driving is at sus...'),
  (37, 'transfer_case', NULL, 60000, NULL, 96561, 'Change transfer case fluid if using your vehicle for any of the following: police, taxi, fleet, or frequent trailer towing'),
  (37, 'pcv_valve', 100000, NULL, 160934, NULL, 'Inspect and replace PCV valve if necessary'),
  (37, 'axle_fluid_change', NULL, 40000, NULL, 64374, 'Change front and rear axle fluid if using your vehicle for police, taxi, fleet, off-road or frequent trailer towing'),
  (43, 'cabin_filter', 20000, NULL, 32187, NULL, 'Replace cabin air filter.'),
  (43, 'evap_fresh_air_filter', NULL, 20000, NULL, 32187, 'For severe dusty driving conditions, inspect and replace the Evaporative System Fresh Air Filter as necessary.'),
  (43, 'engine_air_filter', 30000, NULL, 48280, NULL, 'Replace engine air cleaner.'),
  (43, 'drive_belt', 150000, NULL, 241402, NULL, 'If equipped with Stop/Start, replace accessory drive belt with OEM grade Mopar belt.'),
  (43, 'spark_plugs', 100000, NULL, 160934, NULL, 'Replace spark plugs. The spark plug change interval is mileage-based only; yearly intervals do not apply.'),
  (43, 'coolant_flush', 100000, NULL, 160934, NULL, 'Flush and replace the engine coolant at 10 years or 150,000 miles (240,000 km) whichever comes first.'),
  (43, 'transfer_case', 120000, NULL, 193121, NULL, 'Change the transfer case fluid.'),
  (43, 'pcv_valve', 100000, NULL, 160934, NULL, 'Inspect and replace PCV valve if necessary.');

-- Cite each new row to the gen's Mopar Owner's Manual source
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'service_intervals', si.id, CASE
      WHEN si.generation_id = 86 THEN 862
      WHEN si.generation_id = 122 THEN 860
      WHEN si.generation_id = 69 THEN 858
      WHEN si.generation_id = 37 THEN 864
      WHEN si.generation_id = 43 THEN 861
    END
  FROM service_intervals si
  WHERE si.generation_id IN (86,122,69,37,43)
    AND si.id > (SELECT MAX(id)-44 FROM service_intervals);
