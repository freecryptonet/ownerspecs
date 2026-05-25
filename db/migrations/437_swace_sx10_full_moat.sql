-- 437: Full moat fill for Suzuki Swace (SX10) gen 329.
-- Swace = rebadged Toyota Corolla Touring Sports 1.8 Hybrid (E210, 2ZR-FXE, 90kW), FWD only.
-- Data from Toyota Corolla (E210) SM data (32) + Swace OM (846), cross-checked on web.
-- NOTE: the Corolla E210 also offers AWD-i (electric rear axle, rear diff 0.45-0.55 L); the
-- Swace is FWD-only so the rear differential is intentionally excluded.

SET @gen    = 329;   -- swace-sx10-wagon-2020-present
SET @eng    = 16;    -- 2ZR-FXE 1.8 VVT-i hybrid
SET @src_sm = 32;    -- Toyota Corolla (E210) Service Manual
SET @src_om = 846;   -- Suzuki Swace Owner's Manual

-- ---- FLUIDS (had 5: oil, coolant, coolant(1.5), eCVT(3.0), brake) ----
-- The 1.5 L "coolant" is the motor/inverter loop -> relabel + correct to HaynesPro 1.4 L.
UPDATE fluid_specs SET fluid_type='inverter_coolant', capacity_l=1.40, capacity_qt=ROUND(1.40*1.05669,2)
  WHERE generation_id=@gen AND fluid_type='coolant' AND capacity_l=1.50;
-- eCVT P610 (MY2020-2022) is 3.6 L refill; DB's 3.0 is the later PA10 figure.
UPDATE fluid_specs SET capacity_l=3.60, capacity_qt=ROUND(3.60*1.05669,2)
  WHERE generation_id=@gen AND fluid_type='transmission_ecvt';
UPDATE fluid_specs SET capacity_l=1.00, capacity_qt=ROUND(1.00*1.05669,2)
  WHERE generation_id=@gen AND fluid_type='brake_fluid';

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant',    NULL, NULL, 'R1234yf', 'Charge 470 +/- 30 g.'),
  (@gen, NULL, 'ac_compressor_oil', 0.12, NULL, NULL,      '117 +/- 8 ml system total.'),
  (@gen, NULL, 'washer_fluid',      NULL, NULL, NULL,      'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL: 12V auxiliary battery (engine compartment) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES
  (@gen, NULL, 36, NULL);

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',              103, 76,  NULL),
  (@gen, @eng, 'Engine oil drain plug',    37, 27,  'Renew sealing washer'),
  (@gen, @eng, 'Spark plugs',              20, 15,  NULL),
  (@gen, @eng, 'Ignition coil',            10, 7,   NULL),
  (@gen, NULL, 'Front driveshaft hub nut',216, 159, 'Renew nut'),
  (@gen, @eng, 'Oil filter cap',           18, 13,  'Cartridge element');

-- ---- BULBS (halogen-equipped trims; higher trims have LED headlamps) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'H11',   2, 0),
  (@gen, 'High beam headlight', 'HB3',   2, 0),
  (@gen, 'Front turn signal',   'WY21W', 2, 0),
  (@gen, 'Rear turn signal',    'WY21W', 2, 0),
  (@gen, 'Reverse light',       'W16W',  1, 0),
  (@gen, 'Licence plate light', 'W5W',   2, 0);

-- ---- FUSES (Corolla E210 platform; gen had none) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Engine room',      '9',  10, 'Headlight, left',                 0),
  (@gen, 'Engine room',      '10', 10, 'Headlight, right',                0),
  (@gen, 'Engine room',      '11', 20, 'Audio system',                    0),
  (@gen, 'Engine room',      '6',  10, 'Horn',                            0),
  (@gen, 'Engine room',      '29', 30, 'Wipers',                          0),
  (@gen, 'Engine room',      '28', 25, 'Multiport fuel injection (EFI)',  0),
  (@gen, 'Engine room',      '33', 10, 'Engine control unit',             0),
  (@gen, 'Engine room',      '46', 40, 'Air conditioning',                0),
  (@gen, 'Engine room',      '44', 8,  'Cigarette lighter / power outlet',0),
  (@gen, 'Engine room',      '27', 30, 'Starter',                         0),
  (@gen, 'Instrument panel', '8',  15, 'Radio and audio system',          0);

-- ---- SERVICE INTERVALS (EU schedule) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, miles_severe, km_severe, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 4650, 7500, 12,  'Whichever comes first'),
  (@gen, 'Engine air filter',   25000, 40000, NULL, NULL, NULL,NULL),
  (@gen, 'In-cabin microfilter',18600, 30000, NULL, NULL, 12,  NULL),
  (@gen, 'Brake fluid',         NULL,  NULL,  NULL, NULL, 36,  'Time-based'),
  (@gen, 'Spark plugs',         75000, 120000,NULL, NULL, 144, 'Twin-tip iridium long-life'),
  (@gen, 'Engine coolant (SLLC)',100000,160000,NULL,NULL, 120, 'First change; then 50k mi / 5 yr');

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, @eng, 'spark_plug', '90919-01298', 'Denso',  'Twin-Tip iridium, long-life'),
  (@gen, @eng, 'oil_filter', '04152-YZZA6', 'Toyota', 'Cartridge element');

-- ---- CITATIONS ----
-- Rebadge: cite ONLY the Suzuki OM publicly (donor Toyota Corolla SM + HaynesPro are the
-- internal cross-check, documented above, NOT rendered — per the sibling/donor scrub rule).
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src_om FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src_om FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src_om FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src_om FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src_om FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_om FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src_om FROM parts             WHERE generation_id=@gen;
