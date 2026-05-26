-- mig 469: Mercedes-Benz B-Class (W246) gen 317 — build the trim lineup.
-- The gen had ZERO trims, so the hub's "Available engines" section and the
-- oil-capacity per-engine comparison rendered "0 engines" even though the 6
-- engine records exist (they were linked only via fluid_specs).
--
-- Variants + power (kW) + year spans taken from the HaynesPro model-type list for
-- the W246; kW converted to metric PS for the `hp` column (site convention, e.g.
-- "AMG E 43 (401 Hp)"). B 250 e left hp NULL: HaynesPro's 65 kW conflicts with the
-- widely-documented 132 kW peak, so no figure is asserted.

SET @gen := 317;

INSERT INTO trims (generation_id, slug, name, engine_id, hp, start_year, end_year, drive_wheel) VALUES
  (@gen, 'b-160-102-hp',          'B 160 (102 Hp)',            1992, 102, 2015, 2018, 'FWD'),
  (@gen, 'b-180-122-hp',          'B 180 (122 Hp)',            1992, 122, 2011, 2018, 'FWD'),
  (@gen, 'b-200-156-hp',          'B 200 (156 Hp)',            1992, 156, 2011, 2018, 'FWD'),
  (@gen, 'b-200-ngt-156-hp',      'B 200 NGT (156 Hp)',        1996, 156, 2013, 2018, 'FWD'),
  (@gen, 'b-220-4matic-184-hp',   'B 220 4MATIC (184 Hp)',     1996, 184, 2013, 2018, 'AWD'),
  (@gen, 'b-250-4matic-211-hp',   'B 250 4MATIC (211 Hp)',     1996, 211, 2012, 2018, 'AWD'),
  (@gen, 'b-160-cdi-90-hp',       'B 160 CDI (90 Hp)',         1993,  90, 2013, 2018, 'FWD'),
  (@gen, 'b-180-cdi-109-hp',      'B 180 CDI (109 Hp)',        1994, 109, 2011, 2015, 'FWD'),
  (@gen, 'b-200-cdi-136-hp',      'B 200 CDI (136 Hp)',        1994, 136, 2011, 2015, 'FWD'),
  (@gen, 'b-200-cdi-4matic-136-hp','B 200 CDI 4MATIC (136 Hp)',1995, 136, 2014, 2018, 'AWD'),
  (@gen, 'b-220-cdi-170-hp',      'B 220 CDI (170 Hp)',        1995, 170, 2013, 2018, 'FWD'),
  (@gen, 'b-220d-4matic-177-hp',  'B 220 d 4MATIC (177 Hp)',   1995, 177, 2015, 2018, 'AWD'),
  (@gen, 'b-250e',                'B 250 e',                   2011, NULL,2015, 2018, 'FWD');
