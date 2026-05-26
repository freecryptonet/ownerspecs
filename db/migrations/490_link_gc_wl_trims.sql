-- 490: link Grand Cherokee WL (gen 69) trims to engines (all were NULL)
--
-- Surfaced by the Pentastar split (mig 489): gen 69's 3.6 fluids moved to ERC but
-- its trims had no engine_id, so nothing rendered. Link all four to the engine
-- whose fluids already exist for this gen.
UPDATE trims SET engine_id=166 WHERE id=285 AND generation_id=69 AND engine_id IS NULL; -- 5.7 V8 -> EZH
UPDATE trims SET engine_id=59  WHERE id IN (286,287) AND generation_id=69 AND engine_id IS NULL; -- 3.6 Pentastar -> ERC
UPDATE trims SET engine_id=203 WHERE id=288 AND generation_id=69 AND engine_id IS NULL; -- 2.0T 4xe -> GME-T4 PHEV
