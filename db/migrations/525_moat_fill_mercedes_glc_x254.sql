-- mig 525 — moat-fill Mercedes-Benz GLC X254 SUV from US OM.
--
-- Source: mercedes_glc-suv-2026-06-x254-mbux.pdf (Mercedes-Benz USA
-- 2026 GLC SUV Operator's Manual, edition F254 0219 13). Manufacturer-
-- owned (mbusa.com/css-oom/...), public_link=1.
--
-- GLC X254 ships in three powertrain trims:
--   * gas (GLC 300 4MATIC, MB 229.71/229.72 oil)
--   * plug-in hybrid (GLC 350e 4MATIC EQ, MB 229.51/229.52 oil)
--   * AMG (GLC 53 4MATIC+, oil spec not yet published by editorial deadline)
-- Engine_id is NULL because no trim rows exist yet on this gen; the powertrain
-- is encoded in fluid_type suffix + notes for now. Re-link when trims arrive.

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='glc-x254-suv-2023-present');

INSERT IGNORE INTO sources (citation, public_link, notes)
VALUES ('Mercedes-Benz GLC (X254) 2026 Operator''s Manual', 1,
        'Mercedes-Benz USA Operator''s Manual edition F254 0219 13; ingested via the on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz GLC (X254) 2026 Operator''s Manual');

-- Engine oil — split by powertrain
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, 'engine_oil',        6.0, 'SAE 0W-20', 'Mercedes-Benz Approval 229.71 / 229.72', 'Non-PHEV (GLC 300 4MATIC). Includes oil filter. 6.3 US qt / 6.0 L.'),
  (@gen, 'engine_oil_phev',   5.3, 'SAE 0W-40', 'Mercedes-Benz Approval 229.51 / 229.52', 'PHEV (GLC 350e 4MATIC with EQ hybrid technology). Includes oil filter. 5.6 US qt / 5.3 L.');

-- Coolant — split by powertrain
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'coolant',           14.0, 'Mercedes-Benz Specification 320.1', 'Non-PHEV (GLC 300 4MATIC) engine cooling circuit. 14.8 US qt / 14.0 L. 50–55% antifreeze concentration.'),
  (@gen, 'coolant_phev',      15.2, 'Mercedes-Benz Specification 320.1', 'PHEV (GLC 350e 4MATIC EQ) engine cooling circuit. 16.1 US qt / 15.2 L.'),
  (@gen, 'coolant_amg',       16.4, 'Mercedes-Benz Specification 320.1', 'AMG GLC 53 4MATIC+ (SUV and Coupe). 17.3 US qt / 16.4 L.');

-- Other fluids
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'fuel',             62.0, NULL,                            'Non-PHEV (all models). 16.4 US gal / 62.0 L total. Reserve 1.8 gal (7.0 L).'),
  (@gen, 'fuel_phev',        49.0, NULL,                            'PHEV (GLC 350e 4MATIC EQ). 12.9 US gal / 49.0 L total. Reserve 1.8 gal (7.0 L).'),
  (@gen, 'brake',            NULL, 'Mercedes-Benz Approval 331.0',  'Replace at specified intervals at qualified workshop.'),
  (@gen, 'ac_refrigerant',   NULL, 'R-1234yf',                       'Service requires SAE J2845 certified technician.');

-- Cite all fluids
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'engine_oil'       THEN 838
         WHEN 'engine_oil_phev'  THEN 838
         WHEN 'coolant'          THEN 841
         WHEN 'coolant_phev'     THEN 841
         WHEN 'coolant_amg'      THEN 840
         WHEN 'fuel'             THEN 836
         WHEN 'fuel_phev'        THEN 837
         WHEN 'brake'            THEN 839
         WHEN 'ac_refrigerant'   THEN 841
       END
FROM fluid_specs WHERE generation_id=@gen;

-- Wheel-bolt torque
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 150, 111, 'Diagonal-pattern tightening to 150 N·m (111 lb-ft). Same torque applies to the 20-inch emergency spare wheel.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 762);

-- Service intervals
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'tire_pressure_check', NULL, NULL, 1,  'Check tire pressure (incl. spare) monthly, when the load changes, before a longer journey, and when operating conditions change.'),
  (@gen, 'brake_fluid_change',  24000, 39000, 24, 'Replace brake fluid at intervals specified in the maintenance schedule. Use only MB-Approval 331.0 brake fluid.'),
  (@gen, 'engine_oil_change',   NULL, NULL, NULL, 'Condition-based service; vehicle reports oil change due via onboard "Maintenance" display. Use MB-Approval 229.71/229.72 (non-PHEV) or 229.51/229.52 (PHEV).'),
  (@gen, 'coolant_replacement', NULL, NULL, NULL, 'Replace coolant per condition-based service interval. Use only MB-Approval 320.1 coolant. Antifreeze concentration 50% (–37°C) to 55% (–45°C).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 832 FROM service_intervals WHERE generation_id=@gen;
