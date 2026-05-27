-- mig 505: add the Kona SX2 Hybrid trim (gen 118) — flagged missing by the CoC scan
-- (KMHHB8117SU082237). Catalog data; values cross-checked across auto-data +
-- automobile-catalog + the EU Certificate of Conformity:
--   G4LE 1.6 GDI Hybrid (Kappa, 1580cc, bore 72.0 x stroke 55.5)
--   system 129 PS / 95 kW, 265 Nm, 0-100 12.0 s, Vmax 165, WLTP 4.5 l/100km, 103 g/km,
--   FWD, 6-speed DCT, kerb ~1485 kg, OE tyre 205/65 R16.

-- engine (code is UNIQUE -> INSERT IGNORE is idempotent; slug auto-derived by trigger)
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm)
VALUES ('G4LE', 'Hyundai Kappa 1.6 GDI Hybrid 1.6L I4', 1580, 'hybrid', 'NA', 4, 72.00, 55.50);

-- 6-speed DCT (only 7/8-gear DCTs existed)
INSERT INTO transmissions (type, gears, display_name)
SELECT 'DCT', 6, '6 gears, automatic transmission DCT' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM transmissions WHERE type='DCT' AND gears=6);

SET @eng := (SELECT id FROM engines WHERE code='G4LE' LIMIT 1);
SET @tx  := (SELECT id FROM transmissions WHERE type='DCT' AND gears=6 LIMIT 1);

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, end_year,
                   hp, torque_nm, zero_100_kmh_s, top_speed_kmh, fuel_combined_l_100km, co2_g_km,
                   drive_wheel, curb_weight_kg, tire_size)
SELECT 118, 'kona-hybrid-1-6-gdi', 'Kona Hybrid 1.6 GDi', @eng, @tx, 2024, NULL,
       129, 265, 12.0, 165, 4.5, 103, 'FWD', 1485, '205/65 R16'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=118 AND slug='kona-hybrid-1-6-gdi');
