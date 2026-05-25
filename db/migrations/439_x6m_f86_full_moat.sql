-- 439: Full moat fill for BMW X6 M (F86) gen 236 — was completely empty (0 in all lanes, no engine).
-- Engine S63B44T2 4.4 V8 M TwinPower Turbo (423 kW / 575 PS), 2014-2019. AWD.
-- Data from BMW X6 (F16, F86) workshop manual (src 786) + HaynesPro adjustment data,
-- cross-checked on web. Real BMW (not a rebadge) so the BMW manual is cited directly.

-- ---- ENGINE + TRIM ----
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression)
VALUES ('S63B44T2', 'S63B44T2 4.4 V8 M TwinPower Turbo', 4395, 'gasoline', 'twin-turbo', 'DOHC', 8, 89.0, 88.3, 10.0);
SET @eng = (SELECT id FROM engines WHERE code='S63B44T2');
SET @gen = 236;   -- x6-m-f86-suv-2014-2019
SET @src = 786;   -- Workshop service manual — BMW X6 (F16, F86)

INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, start_year, end_year, hp, torque_nm, top_speed_kmh, drive_wheel, tire_size)
VALUES (@gen, 'x6-m', 'X6 M', @eng, 2014, 2019, 575, 750, 250, 'AWD', '275/40 R20 / 315/35 R20');

-- ---- FLUIDS (8) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, @eng, 'engine_oil',       9.50, NULL, 'BMW Longlife-01',          'Sump incl. filter'),
  (@gen, @eng, 'coolant',         16.80, NULL, 'BMW blue antifreeze (ethylene glycol)', NULL),
  (@gen, NULL, 'brake_fluid',      1.00, NULL, 'DOT 4 (BMW)',              NULL),
  (@gen, NULL, 'transmission_at',  8.70, NULL, 'ZF Lifeguard 8 (GA8HP75Z)','Filled for life; initial fill'),
  (@gen, NULL, 'transfer_case',    0.60, NULL, 'BMW ATC transfer-case oil','ATC 45L'),
  (@gen, NULL, 'differential_rear',1.00, NULL, 'BMW M rear-axle oil',      'Active M diff; inner chamber (outer 0.54 / 0.58 L)'),
  (@gen, NULL, 'ac_refrigerant',   NULL, NULL, 'R134a',                    'Charge 675 +/- 10 g (early); later cars R1234yf.'),
  (@gen, NULL, 'washer_fluid',     NULL, NULL, NULL,                       'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL: AGM battery, luggage compartment ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES
  (@gen, NULL, 90, 900);

-- ---- TORQUES (7) ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel bolts',              140, 103, 'Criss-cross; do not grease bolts'),
  (@gen, @eng, 'Engine oil drain plug',     40, 30,  'Renew seal'),
  (@gen, @eng, 'Spark plugs',               23, 17,  '20-26 Nm (M12)'),
  (@gen, @eng, 'Oil filter housing cap',    30, 22,  NULL),
  (@gen, NULL, 'Front driveshaft hub nut', 420, 310, 'Renew nut'),
  (@gen, NULL, 'Tyre pressure sensor',       4, 3,   '3.5 Nm'),
  (@gen, @eng, 'A/C compressor mounting',   25, 18,  NULL);

-- ---- TYRES (staggered; cold) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 38.0, 260, '275/40 R20 106Y'),
  (@gen, 'rear',  'standard', 38.0, 260, '315/35 R20 110Y'),
  (@gen, 'front', 'full',     44.0, 300, '275/40 R20 106Y'),
  (@gen, 'rear',  'full',     44.0, 300, '315/35 R20 110Y');

-- ---- BULBS ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'D1S', 2, 0),
  (@gen, 'High beam headlight', 'H7',  2, 0),
  (@gen, 'Front turn signal',   'LED', 2, 1),
  (@gen, 'Front fog light',     'H11', 2, 0),
  (@gen, 'Tail / brake light',  'LED', 2, 1),
  (@gen, 'Licence plate light', 'W5W', 2, 0);

-- ---- FUSES (BMW X6 F16 platform) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Luggage',        '101', 15, 'Headlight, right',              0),
  (@gen, 'Luggage',        '115', 20, 'Headlight, right',              0),
  (@gen, 'Luggage',        '121', 20, 'Head unit (audio)',            0),
  (@gen, 'Luggage',        '122', 30, 'Audio amplifier',              0),
  (@gen, 'Luggage',        '140', 20, 'Tailgate lock',                0),
  (@gen, 'Luggage',        '162', 20, 'Rear / luggage power sockets', 0),
  (@gen, 'Luggage',        '165', 20, 'Fuel pump control unit (EKPS)',0),
  (@gen, 'Passenger',      '39',  15, 'Headlight, left',              0),
  (@gen, 'Passenger',      '57',  20, 'Headlight, left',              0),
  (@gen, 'Passenger',      '37',  20, 'Cigarette lighter',            0),
  (@gen, 'Passenger',      '60',  40, 'Heater / HVAC blower',         0),
  (@gen, 'Passenger',      '23',  10, 'Engine management (DME)',      0);

-- ---- SERVICE INTERVALS (BMW Condition Based Service) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Engine oil & filter', 10000, 16000, 24,  'Condition Based Service (CBS) — condition-monitored'),
  (@gen, 'Brake fluid',         NULL,  NULL,  24,  'Time-based (CBS)'),
  (@gen, 'In-cabin microfilter',18600, 30000, 24,  NULL),
  (@gen, 'Spark plugs',         37000, 60000, 48,  NULL),
  (@gen, 'Engine air filter',   37000, 60000, 48,  NULL),
  (@gen, 'Vehicle inspection',  NULL,  NULL,  12,  'Annual condition check');

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, @eng, 'spark_plug', '12120039664', 'NGK',   'Set of 8; S63 4.4 V8'),
  (@gen, @eng, 'oil_filter', '11427848321', 'BMW',   'N63/S63 4.4 V8 element');

-- ---- CITATIONS (real BMW gen -> cite the BMW workshop manual directly) ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
