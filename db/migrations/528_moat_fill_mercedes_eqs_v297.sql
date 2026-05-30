-- mig 528 — moat-fill Mercedes-Benz EQS Sedan V297 from US OM.
--
-- Source: mercedes_eqs-sedan-2026-06-v297-mbux.pdf (Mercedes-Benz USA
-- 2026 EQS Sedan Operator's Manual). Manufacturer-owned (mbusa.com),
-- public_link=1.
--
-- EQS Sedan ships as EQS 450+, EQS 500 4MATIC, and EQS 580 4MATIC.
-- The 2026 OM published coolant capacity as blank ("Missing values
-- were not yet available by the editorial deadline" — verbatim) for
-- BOTH the drive-system and HV-battery cooling circuits across all
-- three powertrain variants. Refrigerant + brake fluid are listed.

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='eqs-v297-sedan-2021-present');

INSERT IGNORE INTO sources (citation, public_link, type, retrieved_at, notes) VALUES
  ('Mercedes-Benz EQS Sedan (V297) 2026 Operator''s Manual', 1, 'owner_manual', NOW(),
   'Mercedes-Benz USA Operator''s Manual for the 2026 EQS Sedan; ingested via on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz EQS Sedan (V297) 2026 Operator''s Manual');

INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'brake',           NULL, 'Mercedes-Benz Approval 331.0', 'Replace at specified intervals at qualified workshop.'),
  (@gen, 'ac_refrigerant',  1.15, 'R-1234yf',                      'Charge 1150 ± 10 g (40.6 ± 0.4 oz) — applies to all variants (EQS 450+, 500 4MATIC, 580 4MATIC). PAG oil 190 ± 10 g.'),
  (@gen, 'coolant_drive',   NULL, 'Mercedes-Benz Specification 320.1', 'Drive-system cooling circuit. EQS 450+, 500 4MATIC and 580 4MATIC — filling quantity NOT published in OM (left blank by Mercedes). 50–55% antifreeze.'),
  (@gen, 'coolant_hv_battery', NULL, 'Mercedes-Benz Specification 320.1', 'High-voltage battery cooling circuit. Same as above — EQS 450+/500/580 capacities not published in OM. 50–55% antifreeze.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'brake' THEN 804
         WHEN 'ac_refrigerant' THEN 807
         WHEN 'coolant_drive' THEN 805
         WHEN 'coolant_hv_battery' THEN 805
       END
FROM fluid_specs WHERE generation_id=@gen;

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 150, 111, 'Diagonal-pattern tightening to 150 N·m (111 lb-ft).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 723);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'tire_pressure_check', NULL, NULL, 1, 'Check tire pressure (incl. spare) monthly, when load changes, before a longer journey, and when operating conditions change.'),
  (@gen, 'brake_fluid_change',  24000, 39000, 24, 'Replace brake fluid at specified intervals at qualified workshop. Use only MB-Approval 331.0.'),
  (@gen, 'coolant_replacement', NULL, NULL, NULL, 'Replace coolant per condition-based service. Antifreeze 50% (–37°C) to 55% (–45°C).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 803 FROM service_intervals WHERE generation_id=@gen;
