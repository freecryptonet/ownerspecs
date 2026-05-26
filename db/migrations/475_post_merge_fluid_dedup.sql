-- mig 475: clean the duplicate fluid_specs rows created when mig 474 merged
-- shadow engines into their canonical row (both rows had a fluid for the same
-- generation+type). Keep the richer/original row in each group, drop the twin,
-- and remove the dropped rows' spec_sources.
--
-- Kept vs dropped (dropped id listed):
--   (18,57 oil)    keep 1150 VW 508.00 + filter PN  | drop 3025 "VW 508 00", no PN
--   (18,57 cool)   keep 1156 (canonical DNPA)        | drop 3026
--   (18,57 mt)     keep 1163 VW MTF G052171          | drop 3374 generic "SAE 75W"
--   (35,55 cool)   keep 1281                          | drop 1282 (identical)
--   (35,55 oil)    keep 1278                          | drop 1279 (identical)
--   (35,55 cvt)    keep 1284                          | drop 1285 (identical)
--   (75,124 oil)   keep 946                           | drop 947  (identical)
--   (315,1999 cool)keep 8261 (has spec note)          | drop 8255 (spec NULL)

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (3025,3026,3374,1282,1279,1285,947,8255);
DELETE FROM fluid_specs WHERE id IN (3025,3026,3374,1282,1279,1285,947,8255);
