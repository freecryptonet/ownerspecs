-- mig 470: Mercedes-Benz B 250 e (W246/W242) — set the electric-drive power.
-- mig 469 left hp NULL because HaynesPro showed 65 kW (the EU type-approval
-- CONTINUOUS rating / Nennleistung). The headline PEAK figure — confirmed across
-- multiple independent specs databases — is 132 kW / 179 PS, 340 Nm, 0-100 7.9 s,
-- top speed 160 km/h. Use the peak figure for the `hp` column (site convention).

UPDATE trims
   SET hp = 179,
       torque_nm = 340,
       zero_100_kmh_s = 7.9,
       top_speed_kmh = 160,
       name = 'B 250 e (179 Hp)'
 WHERE generation_id = 317 AND slug = 'b-250e';
