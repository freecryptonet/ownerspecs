-- 435: Full moat fill for Suzuki Across (AX10) gen 321.
-- Across = rebadged Toyota RAV4 PHEV (XA50, A25A-FXS 2.5 PHEV, 225kW). Mechanically identical,
-- so all values are sourced from the Toyota RAV4 (XA50) Service Manual data (src 40) and the
-- Across owner's manual (src 845), cross-checked against independent web sources (per Tim's
-- "own research, double-checked" rule, 2026-05-25). US RAV4 Prime blog figures (4.8/5.1 L oil,
-- Group-48 680 CCA) were REJECTED as wrong engine/market; the EU PHEV hybrid uses a low-CCA
-- auxiliary 12V battery (engine cranks via MG1, not a 12V starter).

SET @gen     = 321;   -- across-ax10-suv-2020-present
SET @eng     = 6;     -- A25A-FXS 2.5 L hybrid Atkinson
SET @src_sm  = 40;    -- Toyota RAV4 (XA50) Service Manual
SET @src_om  = 845;   -- Suzuki Across Owner's Manual

-- ---- FLUIDS: correct existing rows + add the two missing universal fluids ----
-- Oil capacity corrected 4.3 -> 4.5 L (sump incl. filter; A25A-FXS hybrid spec, not the 4.8/5.1 gas figure).
UPDATE fluid_specs SET capacity_l = 4.50, capacity_qt = ROUND(4.50 * 1.05669, 2)
  WHERE generation_id = @gen AND fluid_type = 'engine_oil';
-- The 2.0 L "coolant" row is the electric-motor/inverter loop -> relabel.
UPDATE fluid_specs SET fluid_type = 'inverter_coolant'
  WHERE generation_id = @gen AND fluid_type = 'coolant' AND capacity_l = 2.00;
-- Brake reservoir capacity (was NULL).
UPDATE fluid_specs SET capacity_l = 1.00, capacity_qt = ROUND(1.00 * 1.05669, 2)
  WHERE generation_id = @gen AND fluid_type = 'brake_fluid';

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf', 'A/C compressor oil ND-OIL 8/12, 80 ml system total. Refrigerant charge per under-hood label.'),
  (@gen, NULL, 'washer_fluid',   NULL, NULL, NULL,      'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL: 12V auxiliary battery ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES
  (@gen, NULL, 55, 345);

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel nuts',                   103, 76,  NULL),
  (@gen, @eng, 'Engine oil drain plug',         40, 30,  'Renew gasket'),
  (@gen, @eng, 'Spark plugs',                   20, 15,  NULL),
  (@gen, @eng, 'Oil filter cap (cartridge)',    18, 13,  '17.5 Nm'),
  (@gen, NULL, 'Hybrid transaxle drain plug',   50, 37,  'P810 eCVT, renew sealing washer'),
  (@gen, NULL, 'Hybrid transaxle filler plug',  50, 37,  'P810 eCVT, renew sealing washer'),
  (@gen, NULL, 'Rear e-drive drain/filler plug',39, 29,  'Q610 electric drive unit'),
  (@gen, @eng, 'Crankshaft pulley bolt',       260, 192, NULL),
  (@gen, NULL, 'Front driveshaft hub nut',     294, 217, 'Renew nut');

-- ---- TYRES (cold pressures; both factory fitments at 2.3 bar) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 33.0, 230, '225/60 R18 100H'),
  (@gen, 'rear',  'standard', 33.0, 230, '225/60 R18 100H'),
  (@gen, 'front', 'standard', 33.0, 230, '235/55 R19 101V'),
  (@gen, 'rear',  'standard', 33.0, 230, '235/55 R19 101V');

-- ---- BULBS (top-trim PHEV: full LED exterior; reverse lamp is the only replaceable bulb) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'LED',  2, 1),
  (@gen, 'High beam headlight', 'LED',  2, 1),
  (@gen, 'Daytime running light','LED', 2, 1),
  (@gen, 'Front turn signal',   'LED',  2, 1),
  (@gen, 'Tail / brake light',  'LED',  2, 1),
  (@gen, 'Reverse light',       'W16W', 1, 0),
  (@gen, 'Licence plate light', 'LED',  2, 1);

-- ---- FUSES (RAV4 XA50 platform; core owner-relevant circuits) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Instrument panel', '15', 15, 'Radio and audio system',          0),
  (@gen, 'Instrument panel', '5',  10, 'Dome and interior lights',        0),
  (@gen, 'Instrument panel', '22', 15, 'Cigarette lighter / power outlet',0),
  (@gen, 'Engine room',      '2',  10, 'Headlight high beam, left',       0),
  (@gen, 'Engine room',      '3',  10, 'Headlight high beam, right',      0),
  (@gen, 'Engine room',      '20', 20, 'Headlight low beam, left',        0),
  (@gen, 'Engine room',      '15', 50, 'Air conditioning / heater',       0),
  (@gen, 'Engine room',      '26', 10, 'Horn',                            0),
  (@gen, 'Engine room',      '27', 20, 'Fuel injection main (EFI)',       0),
  (@gen, 'Engine room',      '47', 10, 'Fuel injectors',                  0),
  (@gen, 'Engine room',      '49', 10, 'Engine control unit (IG2)',       0),
  (@gen, 'Engine room',      '31', 30, 'Starter',                         0),
  (@gen, 'Engine room',      '36', NULL,'Wipers',                         1);

-- ---- SERVICE INTERVALS (EU schedule for the Across) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, miles_severe, km_severe, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 4650,  7500,  12,  'Whichever comes first'),
  (@gen, 'Tyre rotation',       6200,  10000, NULL,  NULL,  NULL,NULL),
  (@gen, 'Engine air filter',   25000, 40000, NULL,  NULL,  NULL,NULL),
  (@gen, 'Brake fluid',         NULL,  NULL,  NULL,  NULL,  36,  'Time-based'),
  (@gen, 'Spark plugs',         120000,192000,NULL,  NULL,  144, 'Iridium'),
  (@gen, 'Engine coolant (SLLC)',100000,160000,NULL, NULL,  120, 'First change; then every 50k mi / 5 yr');

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @eng, 'spark_plug', 'FC16HR-Q8',   'Denso',  0.80, 'Iridium; Toyota PN 90919-A1001'),
  (@gen, @eng, 'oil_filter', '04152-YZZA6', 'Toyota', NULL, 'Cartridge element (Dynamic Force)');

-- ---- CITATIONS: link every gen row to the RAV4 XA50 SM; fluids also keep the Across OM ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src_sm FROM fluid_specs       WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src_om FROM fluid_specs       WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src_sm FROM electrical_specs  WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src_sm FROM torque_specs      WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src_sm FROM tire_pressures    WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src_sm FROM bulbs             WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src_sm FROM fuses             WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_sm FROM service_intervals WHERE generation_id = @gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src_sm FROM parts             WHERE generation_id = @gen;
