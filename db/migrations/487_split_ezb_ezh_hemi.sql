-- 487: split the combined "EZB / EZH" 5.7 HEMI engine row into two real engines
--
-- EZB (2003-2008): Gen III 5.7 HEMI, MDS, no VVT, 9.6:1.
-- EZH (2009+): "Eagle" 5.7 HEMI, VVT + revised heads, 10.5:1.
-- These are different, non-interchangeable engines and must not share one row
-- (engine-codes-are-an-asset rule). Engine 166 was the combined row.
--
-- Of 166's applications, only the 300 LX (gen 124, 2005-2010) and Charger LX
-- (gen 123, 2006-2010) are EZB-rooted (340 hp tune); all others are 2009+ EZH
-- (Challenger LC 5.7 R/T began MY2009, Charger LD, Durango WD, GC WK2, GC WL,
-- RAM 1500 DT). So: relabel 166 -> EZH, create EZB, move gens 123+124 to EZB.
-- URL: 166 slug ezb-ezh -> ezh; next.config.ts adds 301 ezb-ezh->ezh + 57-hemi->ezh.

-- 1) Relabel the combined row as EZH (its compression 10.5 already = EZH)
UPDATE engines
SET code = 'EZH', slug = 'ezh',
    display_name = 'Chrysler 5.7L HEMI V8 (EZH, Eagle, VVT, 2009+)'
WHERE id = 166 AND code = 'EZB / EZH';

-- 2) Create the EZB engine row (idempotent)
INSERT INTO engines (code, slug, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, compression)
SELECT 'EZB', 'ezb', 'Chrysler 5.7L HEMI V8 (EZB, MDS, 2003-2008)', 5654, 'petrol', 'NA', 'OHV', 8, 9.60
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM engines WHERE code = 'EZB');
SET @ezb = (SELECT id FROM engines WHERE code = 'EZB' LIMIT 1);

-- 3) Repoint the two EZB-rooted gens (123 Charger LX, 124 300 LX) onto EZB
UPDATE trims             SET engine_id = @ezb WHERE engine_id = 166 AND generation_id IN (123,124);
UPDATE fluid_specs       SET engine_id = @ezb WHERE engine_id = 166 AND generation_id IN (123,124);
UPDATE parts             SET engine_id = @ezb WHERE engine_id = 166 AND generation_id IN (123,124);
UPDATE torque_specs      SET engine_id = @ezb WHERE engine_id = 166 AND generation_id IN (123,124);
UPDATE service_intervals SET engine_id = @ezb WHERE engine_id = 166 AND generation_id IN (123,124);
