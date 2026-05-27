-- 496: fix two EV trim data errors surfaced during the EV spec fill.
--
-- Tesla Model 3 SR (id 94): name claimed "68.3 kWh / 325 Hp" — no Model 3 SR+ ever
-- had a 68.3 kWh pack (real SR+ ~54-57 kWh) and hp was stored as 238; the MY19 SR+
-- RWD is 283 hp. Drop the false kWh from the name, correct hp. Slug left as-is
-- (frozen URL; the kWh in the slug is opaque and not worth a redirect).
UPDATE trims SET name = 'Standard Range Plus (RWD)', hp = 283
WHERE id = 94 AND generation_id = 25;

-- Hyundai IONIQ 5 N (id 151): documented headline peak is 641 hp (478 kW, with N
-- Grin Boost); 601 hp continuous. Stored 650 hp is wrong. 84 kWh is correct.
UPDATE trims SET name = 'N 84 kWh (641 Hp) Electric AWD', hp = 641
WHERE id = 151 AND generation_id = 39;
