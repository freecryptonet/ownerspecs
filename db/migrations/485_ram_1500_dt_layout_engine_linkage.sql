-- 485: RAM 1500 (DT) 2019-2024 — fix gen layout, link trims to engines, add TRX 6.2 oil
--
-- Findings (gen id 43):
--  * layout was 'AWD' — wrong for a body-on-frame truck (base is RWD, 4x4 optional).
--  * 5 of 6 trims had NULL engine_id, so their per-engine oil/coolant (already in
--    fluid_specs on engines 138/166) never rendered. Link them to the existing
--    engine rows the fluids already use (no new shadow-dup engine rows).
--  * TRX engine ESD (id 70) had no engine_oil row. The 2022 DT OM does NOT cover the
--    6.2L (TRX ships a separate manual), so cite the Stellantis factory oil spec
--    (source 611); value cross-checked against 4 sibling 6.2 SC gens (Challenger/
--    Charger/Durango/Grand Cherokee Hellcat = engine 168): 6.6 L / 7.0 qt, 0W-40,
--    Mopar Pennzoil Ultra Platinum MS-12633. TRX coolant left OUT — FSM-only, could
--    not verify against >=2 sources, so omitted rather than guessed.

-- 1) Drivetrain label
UPDATE generations SET layout = 'RWD / 4WD' WHERE id = 43 AND layout = 'AWD';

-- 2) Link trims to the engine rows whose fluids already exist
UPDATE trims SET engine_id = 138 WHERE generation_id = 43 AND id = 170 AND engine_id IS NULL; -- 3.6 Pentastar V6 eTorque
UPDATE trims SET engine_id = 166 WHERE generation_id = 43 AND id IN (166,167,168,169) AND engine_id IS NULL; -- 5.7 HEMI V8 (±eTorque)

-- 3) TRX 6.2 Supercharged HEMI engine oil (engine 70 / ESD)
INSERT INTO fluid_specs
  (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, notes)
SELECT 43, 70, 'engine_oil', 6.60, 7.00, '0W-40',
       'API SP / Mopar Pennzoil Ultra Platinum (MS-12633); SAE 0W-40 full synthetic',
       '68191349AC',
       '6.2L Supercharged HEMI V8 (TRX): 6.6 L (7 qt) with filter, SAE 0W-40.'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM fluid_specs
  WHERE generation_id = 43 AND engine_id = 70 AND fluid_type = 'engine_oil'
);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, 611
FROM fluid_specs fs
WHERE fs.generation_id = 43 AND fs.engine_id = 70 AND fs.fluid_type = 'engine_oil';
