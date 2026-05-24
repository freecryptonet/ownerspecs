-- mig 390: merge the duplicate "Hurricane" 2.0L engine rows into the correct GME-T4 row
--
-- Surfaced while verifying the mig-389 slug fix: the Wrangler JL gen page linked to
-- /engines/hurricane and /engines/hurricane-ec3. Those are engines 60 ("Hurricane / EC3")
-- and 61 ("Hurricane"), both 1995 cc 4-cyl turbo — i.e. the 2.0L GME-T4, NOT the Hurricane
-- (the real Hurricane is a 3.0L twin-turbo inline-SIX, not in the Wrangler JL at all).
--
-- The same 2.0L GME-T4 already exists correctly as engine 187 ("GME-T4 2.0T", holds the
-- gen's fluid_specs). So the Wrangler JL was split: trims → 60/61, fluids → 187. Classic
-- duplicate-engine-record pattern. Both JL 2.0T trims (143 eTorque mild-hybrid, 144 plain)
-- are the same 270 hp engine — repoint both to 187, then delete the dupes.
-- Verified: engines 60/61 have 0 fluid_specs / torque_specs / parts / service_intervals.

UPDATE trims SET engine_id = 187 WHERE id IN (143, 144);

DELETE FROM engines WHERE id IN (60, 61);
