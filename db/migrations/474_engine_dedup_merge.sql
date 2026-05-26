-- mig 474: deduplicate shadow engine rows. The engines table carried pairs that
-- describe the SAME physical engine under two codes — a clean factory code plus a
-- decorated/family-prefixed twin (the classic split where trims point at one row
-- and fluid_specs at the other). For each pair: repoint every reference
-- (trims/fluid_specs/torque_specs/service_intervals/parts) onto the clean-coded
-- survivor, then delete the shadow row.
--
-- NOT merged here (refs can't be mechanically attributed to one code):
--   multi-code catch-alls  244 "DMTA, DPAA", 245 "DLBA, DKNA, DLHA",
--                          148 "CTBA, CTBB, CTBC", 21 "EA888 / DSFE, DSFF"
--   ambiguous bare rows    26 "EcoBoost", 2025 "K9K", 1076 "B47C20B"
-- Those are handled separately.

-- Each block: shadow -> survivor (survivor already holds the correct clean code).
-- 185 "5.0 Coyote"            -> 25  "Coyote"
-- 208 "LFA hybrid"            -> 32  "LFA1"
-- 67  "Dynamic Force/T24A-FTS"-> 77  "T24A-FTS"
-- 210 "i-FORCE MAX hybrid"    -> 124 "V35A-FTS"
-- 990 "M57D30 (306D3)"        -> 1255 "M57D30"
-- 108 "OM 642 .../642.873"    -> 1957 "642.873"
-- 56  "Toyota 2GR-FXS"        -> 55  "2GR-FXS"
-- 23  "EA888 DNPA"            -> 57  "DNPA"
-- 206 "Smartstream G2.5T"     -> 157 "G2.5T"
-- 207 "Smartstream G3.5T"     -> 158 "G3.5T"
-- 169 "6.2 L87 V8"            -> 62  "L87"
-- 199 "5.3 L84 V8 DFM"        -> 63  "L84"
-- 198 "5.3 L82 V8"            -> 64  "L82"
-- 2001 "608.915 (K9K)"        -> 1999 "608.915"
-- 44  "M 139.580"             -> 1890 "139.580"
-- 106 "M 177.980"             -> 1884 "177.980"
-- 45  "M 254.920"             -> 1888 "254.920"
-- 112 "M 256.930"             -> 1961 "256.930"
-- 109 "M 274 DE 20 AL/274.920"-> 1882 "274.920"
-- 107 "M 276.823"             -> 1883 "276.823"

CREATE TEMPORARY TABLE _eng_merge (shadow INT, surv INT);
INSERT INTO _eng_merge (shadow, surv) VALUES
 (185,25),(208,32),(67,77),(210,124),(990,1255),(108,1957),(56,55),(23,57),
 (206,157),(207,158),(169,62),(199,63),(198,64),(2001,1999),
 (44,1890),(106,1884),(45,1888),(112,1961),(109,1882),(107,1883);

UPDATE trims            t  JOIN _eng_merge m ON t.engine_id=m.shadow  SET t.engine_id=m.surv;
UPDATE fluid_specs      f  JOIN _eng_merge m ON f.engine_id=m.shadow  SET f.engine_id=m.surv;
UPDATE torque_specs     ts JOIN _eng_merge m ON ts.engine_id=m.shadow SET ts.engine_id=m.surv;
UPDATE service_intervals si JOIN _eng_merge m ON si.engine_id=m.shadow SET si.engine_id=m.surv;
UPDATE parts            p  JOIN _eng_merge m ON p.engine_id=m.shadow  SET p.engine_id=m.surv;

DELETE e FROM engines e JOIN _eng_merge m ON e.id=m.shadow;
DROP TEMPORARY TABLE _eng_merge;
