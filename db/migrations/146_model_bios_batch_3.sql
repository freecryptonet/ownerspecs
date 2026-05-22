-- Model bios batch 3 — herstructureringsplan §3 Niveau 3.
-- Nine more 140-160 word bios. Skips 3-Series (covered in batch 1).

SET NAMES utf8mb4;

-- Honda CR-V
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Honda CR-V is Honda''s compact crossover SUV, launched in 1995 in Japan and 1997 in North America as the company''s entry into what was then a small segment. The original RD1 CR-V was based on the Civic platform with a raised body, all-wheel-drive option and a fold-flat rear seat — establishing the formula that has dominated the compact-SUV segment for three decades.

Five generations later (RD, RD4, RE, RM, RW, RS) the CR-V has been a perennial top-three seller in the United States compact-SUV segment and Honda''s highest-volume model in North America in most years. The CR-V was the first Honda to use the L15B 1.5-litre turbocharged engine (fifth-generation RW) and the first to receive Honda''s second-generation i-MMD hybrid system (RW Hybrid, 2020). The current sixth-generation RS launched for the 2023 model year. Production for North America runs at Honda''s East Liberty plant in Ohio and at Honda of Canada Manufacturing in Alliston.'
WHERE mk.slug = 'honda' AND m.slug = 'cr-v';

-- Toyota Highlander
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Highlander is Toyota''s mid-size three-row crossover SUV, launched in 2000 for the 2001 model year. The original Highlander (chassis code XU20) was Toyota''s response to the contemporary Lexus RX330 — sharing roughly the same platform as the RX and the Camry — and was the first Toyota crossover to combine three-row seating with car-derived ride and handling.

Across four generations (XU20, XU40, XU50, XU70) the Highlander has been a consistent top-fifteen vehicle in the United States by sales. Hybrid variants have been continuously offered since the XU20 generation, making the Highlander one of the longest-running hybrid SUVs in production. The Grand Highlander, introduced for 2024, is a longer-wheelbase variant sold alongside the standard Highlander. The current XU70 is built on the TNGA-K platform at Toyota Motor Manufacturing Indiana in Princeton.'
WHERE mk.slug = 'toyota' AND m.slug = 'highlander';

-- Honda Pilot
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Honda Pilot is Honda''s mid-size three-row SUV, launched in 2002 for the 2003 model year. The original Pilot (chassis code YF1) was based on the unibody Acura MDX platform and was Honda''s response to the growing three-row crossover segment after the success of the Highlander. The Pilot has remained unibody across all four generations (YF1, YF2/YF3, YF4, YF), differentiating it from body-on-frame three-row SUVs in the same price range.

The Pilot has consistently been a top-twenty vehicle in the United States by sales. The current fourth-generation Pilot, launched for 2023, is the first to offer the TrailSport off-road variant with skid plates, all-terrain tyres and a 1-inch lift — Honda''s most serious off-road effort in the Pilot''s history. Production for North America runs at Honda Manufacturing of Alabama in Lincoln.'
WHERE mk.slug = 'honda' AND m.slug = 'pilot';

-- Kia Telluride
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Kia Telluride is Kia''s largest SUV, launched in 2019 for the 2020 model year. It is built on the Hyundai-Kia midsize SUV platform shared with the Hyundai Palisade and was designed in California specifically for the North-American market. The Telluride was Kia''s first vehicle aimed exclusively at North-American taste, with styling cues and packaging distinct from the rest of the global Kia range.

The Telluride won the 2020 North American Utility Vehicle of the Year award and the Motor Trend SUV of the Year in 2020 — the first time either award was given to a Kia. It has consistently been Kia''s best-selling SUV in North America since launch. Production runs at Kia Manufacturing Georgia in West Point for the global market.'
WHERE mk.slug = 'kia' AND m.slug = 'telluride';

-- Ford Explorer
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Ford Explorer is Ford''s mid-size SUV, launched in 1990 for the 1991 model year as the four-door replacement for the two-door Bronco II. The Explorer was the vehicle that mainstreamed the mid-size SUV segment in North America — by the mid-1990s it had become Ford''s best-selling non-truck vehicle and a defining American SUV nameplate.

Across six generations the Explorer has moved between body-on-frame (first three generations, Ranger-derived) and unibody (fourth and fifth generations, transverse front-wheel-drive-based) before returning to a rear-wheel-drive-based unibody platform (sixth-generation U625, on the CD6 platform shared with the Lincoln Aviator). The Explorer ST high-performance variant has been offered since the U625. The current generation was launched for 2020 and received a heavy refresh for 2025. Production runs at Ford''s Chicago Assembly Plant.'
WHERE mk.slug = 'ford' AND m.slug = 'explorer';

-- Chevrolet Silverado
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Chevrolet Silverado is GM''s full-size light-duty pickup, with the Silverado nameplate replacing the C/K designation in 1999 for the 1999 model year. The Silverado is the GMT800 / GMT900 / K2XX / T1XX family''s Chevrolet-branded variant, sharing chassis and most mechanicals with the GMC Sierra 1500.

The Silverado has consistently been the second-best-selling vehicle in the United States behind the Ford F-150, alternating second and third place with the Ram 1500 in some years. The Silverado 1500 was joined by the Silverado HD (2500HD / 3500HD heavy-duty) in 1999 as a separate line, and by the Silverado EV (a body-on-frame electric pickup) in 2024. The current Silverado 1500 (chassis code T1XX) launched for the 2019 model year. Production runs at GM''s Fort Wayne Assembly in Indiana and at Silao Assembly in Mexico.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'silverado';

-- Toyota Tundra
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Tundra is Toyota''s full-size light-duty pickup, launched in 1999 for the 2000 model year as a successor to the T100. The original Tundra (chassis code XK30/XK40) was the first Japanese-branded pickup with a full-size V8 engine, and was assembled in the United States from launch — a deliberate effort by Toyota to compete directly with the F-150, Silverado and Ram in the segment they dominated.

Across three generations (XK30/40, XK50, XK70) the Tundra has remained a niche player relative to the Detroit Three in absolute volume, but with a strong reputation for long-term durability — the Tundra was Vincentric''s lowest-cost-of-ownership full-size pickup multiple times in the 2010s. The current XK70 Tundra (2022 onwards) is the first Tundra without a V8 — the long-running 3UR-FE 5.7-litre V8 was replaced with the V35A-FTS twin-turbo V6. Production has been at Toyota Motor Manufacturing Texas in San Antonio since 2008.'
WHERE mk.slug = 'toyota' AND m.slug = 'tundra';

-- Porsche 911
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Porsche 911 is Porsche''s flagship sports car and one of the longest continuously-produced nameplates in automotive history, launched in 1964 as the 901 (renamed 911 after a trademark dispute with Peugeot). Across eight generations (901, 930, 964, 993, 996, 997, 991, 992) the 911 has retained the rear-engine, rear-wheel-drive or four-wheel-drive layout that has defined its character since the original.

The 911 transitioned from air-cooled to water-cooled engines with the 996 generation in 1997 — a controversial change among enthusiasts at the time but one that enabled the longevity of the platform. High-performance variants include the Turbo (continuously offered since 1975), the GT3 / GT3 RS (track-focused), the GT2 / GT2 RS (extreme high-power), the Carrera 4 / 4S (all-wheel drive), the Targa (lift-off roof) and the Cabriolet. The 911 is built exclusively at Porsche''s historic Zuffenhausen plant in Stuttgart.'
WHERE mk.slug = 'porsche' AND m.slug = '911';

-- Subaru Forester
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Subaru Forester is Subaru''s compact crossover SUV, launched in 1997 as a tall-roofed Impreza-derived wagon. The original SF Forester was one of the first vehicles in what would later become the compact-SUV segment, predating the Honda CR-V and the Toyota RAV4 in some markets.

Across five generations (SF, SG, SH, SJ, SK) the Forester has retained Subaru''s symmetrical all-wheel-drive system as standard, the flat-four engine layout and the tall, boxy proportions that distinguish it from car-derived crossovers. The Forester has been Subaru''s best-selling model in the United States in many years. The Forester Wilderness variant, introduced on the fifth-generation SK in 2022, adds raised ride height, all-terrain tyres and revised gearing for serious off-road duty. Production runs at Subaru of Indiana Automotive in Lafayette for North America.'
WHERE mk.slug = 'subaru' AND m.slug = 'forester';
