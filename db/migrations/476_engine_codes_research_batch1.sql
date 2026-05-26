-- mig 476: replace name/marketing engine "codes" with the real factory codes,
-- verified across multiple sources (research batch 1). Frozen /engines slugs
-- untouched (mig 389). EV motors and Asian/Stellantis engines DO carry codes —
-- e.g. the Kona EV motor is EM16, not a description.
--
--   181 "Kona EV PE"        -> EM16        (Hyundai Kona Electric PMSM motor code)
--   179 "G2.0 MPI Nu"       -> G4NA        (Hyundai Nu 2.0 MPI)
--   187 "GME-T4 2.0T"       -> GME-T4      (Stellantis Global Medium Engine; strip displacement)
--   203 "GME-T4 2.0T PHEV"  -> GME-T4 PHEV
--   2038 "GSE-T4 1.3T"      -> GSE-T4      (Stellantis Global Small Engine / FireFly)
-- Merge: 180 "G1.6T Smartstream" is a shadow of existing 27 "G4FP" -> merge in.

UPDATE engines SET code='EM16'        WHERE id=181 AND code='Kona EV PE';
UPDATE engines SET code='G4NA'        WHERE id=179 AND code='G2.0 MPI Nu';
UPDATE engines SET code='GME-T4'      WHERE id=187 AND code='GME-T4 2.0T';
UPDATE engines SET code='GME-T4 PHEV' WHERE id=203 AND code='GME-T4 2.0T PHEV';
UPDATE engines SET code='GSE-T4'      WHERE id=2038 AND code='GSE-T4 1.3T';

-- merge 180 -> 27 (G4FP), keep the descriptive display_name
UPDATE trims            SET engine_id=27 WHERE engine_id=180;
UPDATE fluid_specs      SET engine_id=27 WHERE engine_id=180;
UPDATE torque_specs     SET engine_id=27 WHERE engine_id=180;
UPDATE service_intervals SET engine_id=27 WHERE engine_id=180;
UPDATE parts            SET engine_id=27 WHERE engine_id=180;
UPDATE engines SET display_name='Hyundai Smartstream G1.6T 1.6L Turbo I4' WHERE id=27;
DELETE FROM engines WHERE id=180;
