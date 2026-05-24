-- mig 366: cite existing bulb rows on Stellantis gens to their Mopar OEM Owner's Manual
--
-- Tire pressures: Mopar OMs (all 7) defer entirely to the door-jamb placard sticker
-- for cold inflation values. No PSI numbers published in the manual itself, so
-- nothing to extract for tire_pressures. Existing tire_pressures rows on these gens
-- (where any) came from the door-placard via prior sessions / HaynesPro.
--
-- Bulbs: clean structured tables verified in Mopar PDFs for 4 gens (Ram 1500 DT p343,
-- Pacifica RU p308, Charger LD p496-497, Chrysler 300 LX p459-460). Wrangler JL
-- bulbs are listed inline with replacement procedures (narrative, not a clean table).
-- All existing bulb rows on these gens are consistent with Mopar's published bulb codes,
-- so this mig just adds the Mopar OM citation as a 2nd source per row.

-- Cite existing bulbs to their Mopar OM source row (mig 363 → sources 858-864)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', b.id, CASE
      WHEN b.generation_id = 37  THEN 864   -- Jeep Wrangler JL 2020 OM
      WHEN b.generation_id = 43  THEN 861   -- Ram 1500 DT 2022 OM
      WHEN b.generation_id = 69  THEN 858   -- Jeep Grand Cherokee WL 2023 OM
      WHEN b.generation_id = 86  THEN 862   -- Chrysler Pacifica RU 2020 OM
      WHEN b.generation_id = 122 THEN 860   -- Dodge Charger LD 2017 OM
    END
  FROM bulbs b
  WHERE b.generation_id IN (37, 43, 69, 86, 122);
