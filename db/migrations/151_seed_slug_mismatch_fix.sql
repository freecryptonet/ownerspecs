-- Fix for slug mismatches in migrations 143/145/146/147/149/150.
--
-- The previous seed batches used (make_slug, model_slug, start_year) WHERE
-- clauses that didn't match the actual rows in prod. SELECTs run on the
-- live DB on 2026-05-22 revealed:
--
--   * Mazda 3 BP — start_year is 2020 in DB, not 2019 as targeted in mig 143
--   * Chevrolet Silverado T1 — model slug is `silverado-1500`, not `silverado`
--     (mig 145 gen intro + mig 146 model bio)
--   * Hyundai Palisade LX2 — start_year is 2018 in DB (Korean launch), not
--     2020 (US MY) as targeted in mig 147
--   * Chrysler Pacifica RU — model slug is `pacifica-minivan`, not `pacifica`
--     (mig 149 gen intro + mig 150 model bio)
--
-- This migration re-applies the four gen intros and two model bios with
-- corrected WHERE clauses. Body text is identical to the originals.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- Mazda 3 BP — gen intro (was mig 143 with start_year=2019, actual is 2020)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Mazda 3 launched in early 2019 for the 2019 model year, internally designated BP. It is the first 3 built on the SkyActiv-Vehicle Architecture, replacing the BM/BN-era platform with a substantially stiffer body shell, a simpler torsion-beam rear suspension (replacing the BM''s multi-link) and a revised set of i-Activsense driver-assistance features.

Powertrains include the PE-VPS 2.0-litre and PY-VPS 2.5-litre SkyActiv-G naturally aspirated four-cylinders, the SH-VPTS 1.8-litre SkyActiv-D diesel (outside North America), the eX-VPS 2.0-litre SkyActiv-X compression-ignition petrol (also outside North America) and the PY-VPTS 2.5-litre turbocharged version that powers the AWD Turbo variants. A mild-hybrid 24V system is fitted to most petrol engines. The BP is offered in five-door hatchback and four-door sedan body styles. A facelift for 2024 brought revised front-end styling and an updated infotainment unit. Production runs at Mazda Hofu in Japan, with North-American sedans built at Mazda de México in Salamanca.'
WHERE mk.slug = 'mazda' AND m.slug = '3' AND g.codename = 'BP';

-- ----------------------------------------------------------------------------
-- Chevrolet Silverado T1 — gen intro (model_slug is silverado-1500 not silverado)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Silverado 1500 launched in autumn 2018 for the 2019 model year, internally designated T1XX (shared with the GMC Sierra 1500). The T1XX moved GM''s full-size light-duty trucks to a mixed-material body using high-strength steel for the frame and aluminium for the doors, hood and tailgate, reducing curb weight versus the K2XX predecessor. The T1XX is the first Silverado offered in six cab/bed configurations rather than the previous three.

The petrol lineup includes the L82 4.3-litre V6, the L3B 2.7-litre turbocharged four (with two states of tune), the L84 5.3-litre V8 with Dynamic Fuel Management, the L87 6.2-litre V8, and the LM2 / LZ0 3.0-litre Duramax inline-six diesel. The ZR2 off-road variant arrived in 2022 with Multimatic DSSV spool-valve dampers; the High Country trim sits at the top of the luxury range. A facelift for 2022 added the larger 13.4-inch infotainment screen and revised front fascia. Production runs at GM''s Fort Wayne Assembly in Indiana and Silao Assembly in Mexico.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'silverado-1500' AND g.start_year = 2019;

-- ----------------------------------------------------------------------------
-- Hyundai Palisade LX2 — gen intro (start_year is 2018 not 2020)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The first-generation Palisade launched for the 2020 model year, internally designated LX2. It is built on the Hyundai-Kia midsize SUV platform shared with the Kia Telluride and replaced the Santa Fe XL as Hyundai''s three-row family SUV. The Palisade was designed in California specifically for North-American taste and is sold globally as Hyundai''s flagship SUV outside markets where the Genesis GV80 fills that role.

The lineup uses the Lambda II G6DH 3.8-litre naturally aspirated V6 paired with an 8-speed automatic, with available all-wheel drive across all trims (SE, SEL, XRT, Limited, Calligraphy). There is no hybrid Palisade in the LX2 generation. A heavy mid-cycle refresh for 2023 introduced revised front-end styling with a more prominent cascading grille, a single curved display, the XRT off-road variant and an updated infotainment system. Production runs at Hyundai Motor Company''s Ulsan Plant 4 in South Korea.'
WHERE mk.slug = 'hyundai' AND m.slug = 'palisade' AND g.codename = 'LX2';

-- ----------------------------------------------------------------------------
-- Chrysler Pacifica RU — gen intro (model_slug is pacifica-minivan not pacifica)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The Chrysler Pacifica launched in early 2016 for the 2017 model year, internally designated RU. It is the replacement for the Chrysler Town & Country and was the most substantial minivan reset in Chrysler''s history — the Pacifica adopted a unique platform with substantially revised packaging, including Stow ''n Go second-row seats that fold flush into the floor (a Chrysler segment innovation continued from the Town & Country), and the first plug-in hybrid minivan available in the North-American market.

The lineup uses the Pentastar 3.6-litre V6 paired with a 9-speed automatic (Pacifica conventional), and the 3.6-litre V6 paired with a 16 kWh battery and electric motors integrated into the transmission for the Pacifica Hybrid (the segment''s only plug-in hybrid through most of its production). The Pacifica Voyager, a budget trim, was sold 2020-2021 to replace the Dodge Grand Caravan. Production runs at Stellantis (FCA) Windsor Assembly Plant in Ontario.'
WHERE mk.slug = 'chrysler' AND m.slug = 'pacifica-minivan' AND g.codename = 'RU';

-- ----------------------------------------------------------------------------
-- Chevrolet Silverado — model bio (model_slug is silverado-1500)
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Chevrolet Silverado is GM''s full-size light-duty pickup, with the Silverado nameplate replacing the C/K designation in 1999 for the 1999 model year. The Silverado is the GMT800 / GMT900 / K2XX / T1XX family''s Chevrolet-branded variant, sharing chassis and most mechanicals with the GMC Sierra 1500.

The Silverado has consistently been the second-best-selling vehicle in the United States behind the Ford F-150, alternating second and third place with the Ram 1500 in some years. The Silverado 1500 was joined by the Silverado HD (2500HD / 3500HD heavy-duty) in 1999 as a separate line, and by the Silverado EV (a body-on-frame electric pickup) in 2024. The current Silverado 1500 (chassis code T1XX) launched for the 2019 model year. Production runs at GM''s Fort Wayne Assembly in Indiana and at Silao Assembly in Mexico.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'silverado-1500';

-- ----------------------------------------------------------------------------
-- Chrysler Pacifica — model bio (model_slug is pacifica-minivan)
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Chrysler Pacifica is Stellantis''s minivan, launched in 2016 for the 2017 model year as the replacement for the Chrysler Town & Country (the long-running nameplate that traced back to 1989). The Pacifica nameplate had previously been used briefly on a 2004-2008 mid-size crossover; the modern Pacifica is unrelated to that car.

The Pacifica was the first plug-in hybrid minivan in the North-American market when it launched the Pacifica Hybrid for the 2017 model year, and it remained the only plug-in hybrid minivan available through most of its production run (the Toyota Sienna and Honda Odyssey were hybrid-only and gasoline-only respectively, with no plug-in option). The Pacifica retained the Stow ''n Go second-row seats that fold flush into the floor — a feature unique to Stellantis''s Chrysler minivans since their introduction on the 2005 Caravan. Production runs at Stellantis Windsor Assembly Plant in Ontario.'
WHERE mk.slug = 'chrysler' AND m.slug = 'pacifica-minivan';
