-- 491: BMW M5 G90 sedan (147) + G99 Touring (148) — service intervals from the
-- official BMW MY2025 Maintenance Booklet (bmwusa.com). Engine S68 4.4 V8 PHEV.
--
-- BMW uses Condition Based Service (CBS), not fixed mileage; the booklet states
-- maintenance items relative to the engine-oil service. Concrete printed figures
-- (1,200-mi running-in, 150k-mi O2 sensor, 2-yr brake fluid) are exact; the
-- "every Nth oil service" items carry the relative basis in notes plus BMW's
-- standard representative mileage.
-- Tires (no OEM G90 placard pressure available), fuses (no chart published), and
-- bulbs (all-LED, nothing replaceable) are intentionally NOT filled — they need
-- the VIN-gated G90 Driver's Guide / a placard photo.

INSERT INTO sources (type, citation, url, public_link, retrieved_at, notes, is_public)
SELECT 'oem_manual', 'BMW Maintenance Booklet (MY2025)',
       'https://www.bmwusa.com/content/dam/bmw/marketUS/common/warranty-books/2025/BMW_MY25_Maintenance_with_BEVs.pdf',
       1, NOW(), 'Official BMW US maintenance booklet, MY2025 (manufacturer-hosted on bmwusa.com).', 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'BMW Maintenance Booklet (MY2025)');
SET @bmw_mb = (SELECT id FROM sources WHERE citation = 'BMW Maintenance Booklet (MY2025)' LIMIT 1);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes)
SELECT g, s, mi, km, mo, nt FROM (
  SELECT 147 g UNION ALL SELECT 148
) gens CROSS JOIN (
  SELECT 'running_in_service' s, 1200 mi, 1931 km, NULL mo, 'M one-time running-in service: change engine oil + filter and rear-axle differential oil.' nt
  UNION ALL SELECT 'engine_oil_and_filter', NULL, NULL, 12, 'Condition Based Service (CBS) — oil-service display governs timing; annual service recommended. BMW Longlife-01 FE, SAE 0W-30.'
  UNION ALL SELECT 'brake_fluid_flush', NULL, NULL, 24, 'Date-based: every 2 years (CBS brake-fluid indicator).'
  UNION ALL SELECT 'cabin_air_filter', 20000, 32000, NULL, 'Every 2nd engine-oil service (with remote-key battery).'
  UNION ALL SELECT 'engine_air_filter', 30000, 48000, NULL, 'Every 3rd engine-oil service.'
  UNION ALL SELECT 'transfer_case_fluid', 50000, 80000, NULL, 'Every 5th engine-oil service.'
  UNION ALL SELECT 'rear_differential_fluid', 50000, 80000, NULL, 'Every 5th engine-oil service.'
  UNION ALL SELECT 'spark_plugs', 60000, 96000, NULL, 'Every 6th engine-oil service.'
  UNION ALL SELECT 'oxygen_sensor', 150000, 240000, NULL, 'Oxygen sensor replacement.'
) r
WHERE NOT EXISTS (
  SELECT 1 FROM service_intervals si WHERE si.generation_id = gens.g AND si.service = r.s
);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', si.id, @bmw_mb
FROM service_intervals si
WHERE si.generation_id IN (147,148);
