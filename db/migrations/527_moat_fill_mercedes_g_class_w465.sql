-- mig 527 — moat-fill Mercedes-Benz G-Class W465 SUV from US OM.
--
-- Source: mercedes_g-class-suv-2026-05-w465-mbux.pdf (Mercedes-Benz USA
-- 2026 G-Class Operator's Manual, edition F465 0046 13). Manufacturer-
-- owned (mbusa.com/css-oom/...), public_link=1.
--
-- W465 ships as G 550 (V8) and Mercedes-AMG G 63 (V8 BiTurbo) — both
-- share the same chassis and the same fuel tank / refrigerant figures
-- but differ on engine oil viscosity and engine coolant capacity. The
-- non-AMG coolant capacity was left blank in the OM ("Missing values
-- were not yet available by the editorial deadline" — verbatim).

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='g-class-w465-suv-2024-present');

INSERT IGNORE INTO sources (citation, public_link, type, retrieved_at, notes) VALUES
  ('Mercedes-Benz G-Class (W465) 2026 Operator''s Manual', 1, 'owner_manual', NOW(),
   'Mercedes-Benz USA Operator''s Manual edition F465 0046 13; ingested via on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz G-Class (W465) 2026 Operator''s Manual');

-- Fluid specs
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, 'engine_oil',      9.0,  'SAE 0W-20', 'Mercedes-Benz Approval 229.71 / 229.72', 'G 550 (V8). Includes oil filter. 9.5 US qt / 9.0 L.'),
  (@gen, 'engine_oil_amg',  NULL, 'SAE 0W-40 / SAE 5W-40', 'Mercedes-Benz Approval 229.71 / 229.72', 'Mercedes-AMG G 63 (V8 BiTurbo). Filling quantity not published in OM.'),
  (@gen, 'coolant_amg',     15.6, NULL, 'Mercedes-Benz Specification 320.1', 'Mercedes-AMG G 63 engine cooling. 16.5 US qt / 15.6 L. Non-AMG (G 550) capacity not published in OM. 50–55% antifreeze.'),
  (@gen, 'fuel',            100.0, NULL, NULL, 'G 550 and AMG G 63 both 26.4 US gal / 100.0 L. Premium unleaded 91 AKI / 95 RON required. Reserve 12.0 L (3.2 gal).'),
  (@gen, 'brake',           NULL, NULL, 'Mercedes-Benz Approval 331.0', 'Replace at specified intervals at qualified workshop.'),
  (@gen, 'ac_refrigerant',  0.63, NULL, 'R-1234yf', 'Charge 630 ± 10 g (22.2 ± 0.4 oz) for both G 550 and AMG G 63. PAG oil 140 ± 10 g.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'engine_oil'     THEN 737
         WHEN 'engine_oil_amg' THEN 738
         WHEN 'coolant_amg'    THEN 739
         WHEN 'fuel'           THEN 735
         WHEN 'brake'          THEN 738
         WHEN 'ac_refrigerant' THEN 741
       END
FROM fluid_specs WHERE generation_id=@gen;

-- Wheel-bolt torque — note G-Class is higher than EQE/GLC (180 N·m)
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 180, 133, 'Diagonal-pattern tightening to 180 N·m (133 lb-ft). Higher than most W-platform cars (150 N·m) — heavy-duty G-Class hub.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 656);

-- Service intervals
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'tire_pressure_check', NULL,  NULL, 1, 'Check tire pressure (incl. spare) monthly, before a longer journey, and when load/operating conditions change.'),
  (@gen, 'brake_fluid_change',  24000, 39000, 24, 'Replace brake fluid at intervals specified in the maintenance schedule. Use only MB-Approval 331.0 brake fluid.'),
  (@gen, 'engine_oil_change',   NULL, NULL, NULL, 'Condition-based service; vehicle reports oil change due via onboard "Maintenance" display. Use MB-Approval 229.71/229.72.'),
  (@gen, 'coolant_replacement', NULL, NULL, NULL, 'Replace per condition-based service. Antifreeze concentration 50% (–37°C) to 55% (–45°C).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 731 FROM service_intervals WHERE generation_id=@gen;
