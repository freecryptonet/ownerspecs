-- mig 391: backfill Dodge Durango WD (gen 333) moat — electrical, bulbs, fuses,
-- torques, service intervals, parts, tires. Fluids already complete (16 rows, mig-era).
--
-- Sources:
--   869 = "Dodge Durango (WD) 2020 Owner's Manual" (Mopar, public, existing) — OM-verified rows.
--   NEW 871 = vendor-neutral workshop service specifications — battery, ESG engine torques,
--             spark-plug gap (data the OM doesn't print). public_link=0, never names a vendor.
--   NEW 872 = third-party aggregated tire-placard reference (NON-OEM, flagged) — cold tire PSI.
--             OM + workshop data both defer tire pressure to the door placard, so this is the
--             only sourceable value; provenance is flagged honestly in the citation + notes.
--
-- Engine codes on this gen verified accurate (HaynesPro Engine-code column confirmed ESG=6.4 SRT):
--   138 Pentastar 3.6 · 166 EZB/EZH 5.7 HEMI · 167 ESG 6.4 392 · 168 EWB 6.2 Hellcat.
--   (138 "Pentastar" still lacks a specific ERB/ERC/ERG code — deferred to a Pentastar-wide cleanup.)

SET @g  := 333;
SET @om := 869;          -- Mopar OM
SET @e_36 := 138;
SET @e_57 := 166;
SET @e_64 := 167;
SET @e_62 := 168;

-- ---- source rows -------------------------------------------------------------
INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Dodge Durango (WD) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data for the WD platform (battery, engine torque sequences, spark-plug gap) — values the owner manual does not publish. Vendor-neutral per house policy.'),
  ('reference', 'Dodge Durango (WD) tire & loading placard (aggregated reference)', NULL, 0, 1, NOW(),
   'Cold tire inflation pressures. NOT from OEM documentation: the OM and workshop data both defer to the door-jamb placard, so pressures are taken from third-party tire-pressure aggregators. Provenance flagged for audit.');
SET @svc := (SELECT id FROM sources WHERE citation='Dodge Durango (WD) workshop service specifications' LIMIT 1);
SET @tp  := (SELECT id FROM sources WHERE citation='Dodge Durango (WD) tire & loading placard (aggregated reference)' LIMIT 1);

-- ---- 1. ELECTRICAL (workshop service data) ----------------------------------
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 700, 75, 220);
-- note carried in citation; BCI group not verified so left NULL rather than guessed.

-- ---- 2. BULBS (OM p201-202, gen-wide) ---------------------------------------
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low/high beam (Bi-Xenon HID)',     'D3S',     2, 0),
  (@g, 'Low/high beam (Bi-Halogen)',       '9005SL+', 2, 0),
  (@g, 'Front park/turn signal',           '3157NAK', 2, 0),
  (@g, 'Front park/DRL (uplevel)',         'LED',     2, 1),
  (@g, 'Front side marker',                'LED',     2, 1),
  (@g, 'Front fog lamp',                   'H11',     2, 0),
  (@g, 'Rear tail/side marker',            'LED',     2, 1),
  (@g, 'Rear stop/turn signal',            'LED',     2, 1),
  (@g, 'Rear backup lamp',                 '921',     2, 0),
  (@g, 'Center high-mount stop (CHMSL)',   'LED',     1, 1),
  (@g, 'Glove compartment',                '194',     1, 0),
  (@g, 'Grab handle lamp',                 'W5W',     2, 0),
  (@g, 'Overhead console reading',         'VT4976',  2, 0),
  (@g, 'Visor vanity',                     'V26377',  2, 0),
  (@g, 'Rear cargo lamp',                  '214-2',   1, 0),
  (@g, 'Underpanel courtesy',              '906',     2, 0);

-- ---- 3. FUSES (OM p206-208 Power Distribution Center, gen-wide) -------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F22', 20, 'Engine Control Module',                 0),
  (@g, 'Underhood PDC', 'F23', 30, 'CBC #1 / Interior lights',              0),
  (@g, 'Underhood PDC', 'F24', 30, 'Driver door module',                    0),
  (@g, 'Underhood PDC', 'F25', 30, 'Front wipers',                          0),
  (@g, 'Underhood PDC', 'F26', 30, 'ESP / ECU valves',                      0),
  (@g, 'Underhood PDC', 'F35', 30, 'Sunroof',                               0),
  (@g, 'Underhood PDC', 'F36', 30, 'Rear defroster',                        0),
  (@g, 'Underhood PDC', 'F42', 20, 'Horn',                                  0),
  (@g, 'Underhood PDC', 'F44', 10, 'Diagnostic port',                       0),
  (@g, 'Underhood PDC', 'F56', 15, 'PCM',                                   0),
  (@g, 'Underhood PDC', 'F60', 15, 'Transmission Control Module',           0),
  (@g, 'Underhood PDC', 'F62', 10, 'A/C clutch',                            0),
  (@g, 'Underhood PDC', 'F64', 25, 'Fuel injectors / powertrain',           0),
  (@g, 'Underhood PDC', 'F70', 20, 'Fuel pump motor',                       0),
  (@g, 'Underhood PDC', 'F84', 15, 'Instrument cluster',                    0),
  (@g, 'Underhood PDC', 'F93', 20, 'Cigar lighter',                         0);

-- ---- 4. TORQUE SPECS --------------------------------------------------------
-- Gen-wide lug nut (OM p267 Wheel & Tire Torque). Two values for the two wheel families.
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL, 'Wheel lug nut (alloy)',  176, 130, 'OM: M14x1.5, 22 mm socket, star pattern, re-check after 25 mi (40 km).'),
  (@g, NULL, 'Wheel lug nut (steel)',  149, 110, 'OM: alternate spec for steel-wheel applications. M14x1.5, 22 mm.'),
-- ESG 6.4 engine torques (workshop service data).
  (@g, @e_64, 'Cylinder head bolt (final stage, M-bolts 1-10)', 61, 45, 'Multi-stage: 34 Nm > 54 Nm > 61 Nm > +90 deg; renew bolts. Service data.'),
  (@g, @e_64, 'Valve/cam cover bolt', 11, 8, 'Finger-tight then 11 Nm. Clean contact surfaces. Service data.'),
  (@g, @e_64, 'Big-end (con-rod) bearing cap bolt', 40, 30, 'Renew bolts: 40 Nm then +90 deg, threads lightly oiled. Service data.');

-- ---- 5. SERVICE INTERVALS ---------------------------------------------------
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'Oil-change-indicator system; max 10,000 mi / 12 mo / 350 engine-hrs. Severe (dusty/off-road/idle) 4,000 mi. OM.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'Mopar OAT 10 yr / 150,000 mi formula (FCA MS.90032). OM fluids table.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'At every oil-change interval / first sign of irregular wear. OM.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'Inspect pads, rotors, hoses & park brake at every oil-change interval. OM.'),
  (@g, 'cabin_air_filter',      NULL, NULL, NULL, NULL, NULL, 'Replace per maintenance chart / more often in dusty conditions. OM.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'Inspect at oil change; replace per maintenance chart. OM.');

-- ---- 6. PARTS ---------------------------------------------------------------
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM specifies Mopar Engine Oil Filter; exact OE part number not published in the owner manual.'),
  (@g, @e_64, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.10, '6.4 ESG HEMI: 16 plugs, gap 1.10 mm per workshop service data; OE part number not published in OM.');

-- ---- 7. TIRE PRESSURES (sizes OEM-verified; PSI from flagged aggregator) -----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 36.0, 248, '265/60R18'),
  (@g, 'rear',  'normal', 36.0, 248, '265/60R18'),
  (@g, 'front', 'normal', 33.0, 228, '265/50R20'),
  (@g, 'rear',  'normal', 36.0, 248, '265/50R20');

-- ---- citations --------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
-- lug-nut torques -> OM; engine torques -> service data
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
-- oil_filter -> OM (brand verified there); spark_plug gap -> service data
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om  FROM parts WHERE generation_id=@g AND part_type='oil_filter';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @svc FROM parts WHERE generation_id=@g AND part_type='spark_plug';
-- tire pressures -> flagged aggregator
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @tp FROM tire_pressures WHERE generation_id=@g;
