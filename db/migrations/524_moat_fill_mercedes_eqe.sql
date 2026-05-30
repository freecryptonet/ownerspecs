-- mig 524 — moat-fill Mercedes-Benz EQE V295 sedan from US OM.
--
-- Source: mercedes_eqe-sedan-2026-06-v295-mbux.pdf (Mercedes-Benz USA
-- 2026 EQE Sedan Operator's Manual, edition F295 0106 13). Manufacturer-
-- owned (mbusa.com/css-oom/...), public_link=1.
--
-- Mercedes US OMs publish coolant capacity for the AMG variant only and
-- leave non-AMG cells blank ("Missing values were not available by the
-- editorial deadline" — verbatim). The AMG figure is still useful as a
-- reference and we cite it explicitly.

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='eqe-v295-sedan-2022-present');

INSERT IGNORE INTO sources (citation, public_link, notes)
VALUES ('Mercedes-Benz EQE Sedan (V295) 2026 Operator''s Manual', 1,
        'Mercedes-Benz USA Operator''s Manual edition F295 0106 13; ingested via the on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz EQE Sedan (V295) 2026 Operator''s Manual');

-- Operating fluids
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'coolant_drive',       12.0, 'Mercedes-Benz Specification 320.1', 'Drive-system cooling circuit. 12.7 US qt / 12.0 L. AMG EQE 53 4MATIC+ figure; non-AMG variants not published in OM.'),
  (@gen, 'coolant_hv_battery',  13.0, 'Mercedes-Benz Specification 320.1', 'High-voltage battery cooling circuit. 13.7 US qt / 13.0 L. AMG EQE 53 4MATIC+ figure; non-AMG variants not published in OM.'),
  (@gen, 'brake',                NULL, 'Mercedes-Benz Approval 331.0',     'OM cites MB-Freigabe / MB-Approval 331.0. Replace at specified intervals at qualified workshop.'),
  (@gen, 'ac_refrigerant',       NULL, 'R-1234yf',                          'Service requires SAE J2845 certified technician.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'coolant_drive' THEN 801
         WHEN 'coolant_hv_battery' THEN 801
         WHEN 'brake' THEN 800
         WHEN 'ac_refrigerant' THEN 799
       END
FROM fluid_specs WHERE generation_id=@gen;

-- Wheel-bolt torque — OM "Lowering the vehicle after a wheel change"
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 150, 111, 'Diagonal-pattern tightening: initial 80 N·m (59 lb-ft) then final 150 N·m (111 lb-ft).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 723);

-- Service intervals — Mercedes EQE uses condition-based service via the
-- vehicle's onboard "Maintenance" display. Published OM intervals are
-- minimal; record what's there.
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'tire_pressure_check',  NULL,  NULL, 1,   'Check tire pressure (incl. spare) monthly, when the load changes, before a longer journey, and when operating conditions change.'),
  (@gen, 'brake_fluid_change',   24000, 39000, 24, 'Replace brake fluid at intervals specified in the maintenance schedule. Use only MB-Approval 331.0 brake fluid.'),
  (@gen, 'coolant_replacement',  NULL,  NULL, NULL, 'Replace coolant per condition-based service. Antifreeze concentration min 50% (down to -37°C), max 55% (-45°C).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 800 FROM service_intervals WHERE generation_id=@gen;
