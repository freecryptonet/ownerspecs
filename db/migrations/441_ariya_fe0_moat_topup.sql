-- 441: Top-up moat for Nissan Ariya (FE0) gen 163 — BEV. Had fluids(6), fuses, tyres, torque, svc.
-- Missing: electrical, bulbs, parts. Also link the electric motor (AM67) to the fluids so
-- audit_gen.sh detects the BEV (its fluids had no engine_id, so it was held to the ICE min of 8).
-- Real Nissan -> cite Ariya FE0 SM (904) + OM (747). Data from HaynesPro + Nissan parts catalogue.

-- ---- ENGINE (electric motor) ----
INSERT IGNORE INTO engines (code, display_name, fuel) VALUES ('AM67', 'Nissan AM67 electric motor (Ariya)', 'electric');
SET @eng = (SELECT id FROM engines WHERE code='AM67');
SET @gen = 163;   -- ariya-fe0-suv-2022-present
SET @sm  = 904;   -- Nissan Ariya (FE0) Service Manual
SET @om  = 747;   -- Nissan 2024 Ariya Owner's Manual

-- link motor to powertrain fluids -> BEV detection
UPDATE fluid_specs SET engine_id=@eng
  WHERE generation_id=@gen AND fluid_type IN ('coolant','battery_coolant','transmission_at','differential_rear');

-- ---- ELECTRICAL: 12V auxiliary battery ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES (@gen, NULL, 50, 420);

-- ---- BULBS (Ariya = full LED) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',   'LED', 2, 1),
  (@gen, 'High beam headlight',  'LED', 2, 1),
  (@gen, 'Daytime running light','LED', 2, 1),
  (@gen, 'Front turn signal',    'LED', 2, 1),
  (@gen, 'Tail / brake light',   'LED', 2, 1),
  (@gen, 'Licence plate light',  'LED', 2, 1);

-- ---- PARTS (EV: no spark plug / oil filter) ----
INSERT INTO parts (generation_id, part_type, part_number, source_brand, size, notes) VALUES
  (@gen, 'cabin_air_filter', '27277-5MP0A', 'Nissan', NULL,                       NULL),
  (@gen, 'wiper_blade',      '28890-5MR1B', 'Nissan', '26" / 18" (650 / 450 mm)', 'Front pair');

-- ---- SERVICE INTERVALS (BEV; gen already had brake fluid + cabin filter) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Tyre rotation',          6200, 10000, NULL, NULL),
  (@gen, 'Reduction gear oil',     NULL, 30000, 12,   'Inspect; no scheduled change'),
  (@gen, 'Motor / inverter coolant',NULL,195000,180,  'Long-life; first change ~15 yr'),
  (@gen, 'Vehicle inspection',     NULL, NULL,  12,   'Annual condition check');

-- ---- CITATIONS ----
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @sm FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @sm FROM electrical_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',            id, @sm FROM bulbs            WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',            id, @om FROM parts            WHERE generation_id=@gen;
