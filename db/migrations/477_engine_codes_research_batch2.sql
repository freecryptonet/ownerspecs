-- mig 477: real engine codes (research batch 2) + merges of shadows surfaced by
-- collision-checking against the correct codes. Verified across multiple sources.
--
-- Relabels (no collision):
--   202 "3.0 EcoDiesel V6" -> EXF              (Jeep/VM Motori L630, NAFTA sales code)
--   138 "Pentastar"        -> ERB / ERC / ERG  (3.6 Pentastar family — true multi-code)
--   26  "EcoBoost"         -> 2.3 EcoBoost     (Mustang S550 2.3T; Ford's designation)
--   184 "2.7 EcoBoost"     -> Nano             (Ford 2.7 TT V6 codename)
--   226 "3.7 Ti-VCT V6"    -> Duratec 37       (Ford Cyclone-family NA V6)
--   2036 "2.4 Tigershark MA2" -> ED6           (FCA 2.4 Tigershark MultiAir2)
--
-- Merges (decorated/mislabelled row -> existing clean-coded row):
--   129 "Dynamic Force" (Mazda CX-50 Hybrid)  -> 6   A25A-FXS  (Toyota hybrid powerplant)
--   209 "Type S 3.0T"                         -> 119 J30AC
--   171 "3.0 Duramax"                         -> 125 LM2
--   204 "Smartstream G2.0T" (is Theta II)     -> 75  Theta II / G4KH
--   205 "Smartstream G3.3T" (is Lambda II)    -> 140 Lambda II / G6DP

UPDATE engines SET code='EXF'             WHERE id=202 AND code='3.0 EcoDiesel V6';
UPDATE engines SET code='ERB / ERC / ERG' WHERE id=138 AND code='Pentastar';
UPDATE engines SET code='2.3 EcoBoost'    WHERE id=26  AND code='EcoBoost';
UPDATE engines SET code='Nano'            WHERE id=184 AND code='2.7 EcoBoost';
UPDATE engines SET code='Duratec 37'      WHERE id=226 AND code='3.7 Ti-VCT V6';
UPDATE engines SET code='ED6'             WHERE id=2036 AND code='2.4 Tigershark MA2';

-- merges: repoint refs onto survivor, adopt the richer display_name, delete shadow
CREATE TEMPORARY TABLE _m (shadow INT, surv INT);
INSERT INTO _m VALUES (129,6),(209,119),(171,125),(204,75),(205,140);
UPDATE trims            x JOIN _m m ON x.engine_id=m.shadow SET x.engine_id=m.surv;
UPDATE fluid_specs      x JOIN _m m ON x.engine_id=m.shadow SET x.engine_id=m.surv;
UPDATE torque_specs     x JOIN _m m ON x.engine_id=m.shadow SET x.engine_id=m.surv;
UPDATE service_intervals x JOIN _m m ON x.engine_id=m.shadow SET x.engine_id=m.surv;
UPDATE parts            x JOIN _m m ON x.engine_id=m.shadow SET x.engine_id=m.surv;
UPDATE engines SET display_name='Acura 3.0L V6 twin-turbo (MDX Type S, TLX Type S)' WHERE id=119;
UPDATE engines SET display_name='GM Duramax 3.0L I6 Diesel' WHERE id=125;
UPDATE engines SET display_name='Hyundai-Kia 2.0L Theta II T-GDi turbo' WHERE id=75;
UPDATE engines SET display_name='Hyundai-Kia 3.3L Lambda II V6 twin-turbo' WHERE id=140;
DELETE e FROM engines e JOIN _m m ON e.id=m.shadow;
DROP TEMPORARY TABLE _m;
