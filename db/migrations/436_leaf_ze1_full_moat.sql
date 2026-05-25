-- 436: Full moat fill for Nissan Leaf (ZE1) gen 319 — first BEV under the lowered fluid floor.
-- BEV: no engine oil/coolant/gearbox. Fluids = inverter coolant, brake, reduction-gear oil,
-- A/C refrigerant, washer (5 = BEV floor). Electric motor (EM57, id 2026) linked to fluids so
-- audit_gen.sh detects the BEV. Data from Nissan Leaf ZE1 Service Manual (903) + OM (839),
-- cross-checked against independent web sources (HaynesPro adjustment data, bulb charts,
-- startmycar fuses, Nissan parts catalog).

SET @gen    = 319;   -- leaf-ze1-hatchback-2018-2024
SET @eng    = 2026;  -- EM57 PM synchronous motor (electric)
SET @src_sm = 903;   -- Nissan Leaf (ZE1) Service Manual
SET @src_om = 839;   -- Nissan Leaf (ZE1) Owner's Manual MY2023

-- ---- FLUIDS ----
UPDATE fluid_specs SET capacity_l = 1.00, capacity_qt = ROUND(1.00*1.05669,2), spec_standard = 'DOT 3 (Genuine Nissan Super Heavy Duty)'
  WHERE generation_id = @gen AND fluid_type = 'brake_fluid';
UPDATE fluid_specs SET spec_standard = 'R1234yf', notes = 'Charge 425 g (without heat pump) / 850 g (with heat pump). Compressor oil 150 ml / 140 ml.'
  WHERE generation_id = @gen AND fluid_type = 'ac_refrigerant';

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, @eng, 'inverter_coolant', 4.67, NULL, 'Nissan Long Life Coolant (blue)', 'Motor/inverter cooling loop'),
  (@gen, @eng, 'reduction_gear',   1.40, NULL, 'Nissan Matic-S ATF',             'Single-speed reduction gear'),
  (@gen, NULL, 'washer_fluid',     NULL, NULL, NULL,                              'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL: 12V auxiliary battery (front service compartment) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES
  (@gen, NULL, 50, 420);

-- ---- TORQUES (EV has no spark plug / oil drain) ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',                    108, 80,  NULL),
  (@gen, NULL, 'Front driveshaft hub nut',      183, 135, '180-185 Nm; renew nut'),
  (@gen, NULL, 'Tyre pressure sensor',            8, 6,   '7.7 Nm'),
  (@gen, NULL, 'Steering wheel bolt',            34, 25,  '34.3 Nm'),
  (@gen, NULL, 'A/C compressor mounting',        25, 18,  NULL);

-- TYRES + FUSES already present on this gen (prior tyre seed + mig 434 Nissan fuse batch).
-- HaynesPro confirms 205/55 R16 & 215/50 R17 @ 2.5 bar; existing rows kept (no dup insert).

-- ---- BULBS (halogen-equipped trims; ECE codes for the identical physical bulbs) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'H11',   2, 0),
  (@gen, 'High beam headlight', 'HB3',   2, 0),
  (@gen, 'Front turn signal',   'WY21W', 2, 0),
  (@gen, 'Rear turn signal',    'WY21W', 2, 0),
  (@gen, 'Reverse light',       'W16W',  1, 0),
  (@gen, 'Licence plate light', 'W5W',   2, 0);

-- ---- SERVICE INTERVALS (BEV) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Brake fluid',           15000, 24000, 12,  'Annual change (Genuine Nissan SHD / DOT 3)'),
  (@gen, 'Reduction gear oil',    NULL,  24000, 12,  'Inspect; no scheduled change interval'),
  (@gen, 'In-cabin microfilter',  NULL,  24000, 12,  NULL),
  (@gen, 'Tyre rotation',         6200,  10000, NULL,NULL),
  (@gen, 'Motor/inverter coolant',NULL,  195000,180, 'Long-life; first change ~15 yr');

-- ---- PARTS (EV: no spark plug / oil filter) ----
INSERT INTO parts (generation_id, part_type, part_number, source_brand, size, notes) VALUES
  (@gen, 'cabin_air_filter', '27891-9AE0A', 'Nissan', NULL, NULL),
  (@gen, 'wiper_blade',      '650/400 mm',  NULL,     '26" / 16" (650 / 400 mm)', 'Front pair; sized, no single OE assembly PN');

-- ---- CITATIONS ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src_sm FROM fluid_specs       WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src_om FROM fluid_specs       WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src_sm FROM electrical_specs  WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src_sm FROM torque_specs      WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src_om FROM bulbs             WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_om FROM service_intervals WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src_om FROM parts             WHERE generation_id = @gen;
