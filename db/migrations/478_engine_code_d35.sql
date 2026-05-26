-- mig 478: Ford 3.5 EcoBoost (id 172) is the 2nd-gen engine (F-150 P702 2021-25 +
-- Navigator U554 2018+), codename D35. Set the real code.
UPDATE engines SET code='D35' WHERE id=172 AND code='3.5 EcoBoost';
