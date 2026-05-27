-- 497: normalize trims.drive_wheel to uppercase (RWD/AWD/FWD/4WD).
-- A batch of trims (incl. the EV gens + BRZ/Charger/CX-90/Escalade/Kona/Prius/
-- Q7/Range Rover/XC90/etc.) was seeded with lowercase drive_wheel, rendering
-- mixed-case "rwd"/"awd" in the Drive column. Convention is uppercase.
UPDATE trims SET drive_wheel = UPPER(drive_wheel)
WHERE BINARY drive_wheel != UPPER(drive_wheel);
