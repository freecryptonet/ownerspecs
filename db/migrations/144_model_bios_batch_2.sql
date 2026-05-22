-- Model bios batch 2 — herstructureringsplan §3 Niveau 3.
--
-- Ten more 140-160 word bios for high-volume mainstream nameplates. Same
-- authoring rules as 142.

SET NAMES utf8mb4;

-- Toyota RAV4
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota RAV4 launched in 1994 as a compact, car-based crossover SUV — one of the first vehicles in what would later become the most-popular vehicle segment globally. The original XA10 was built on a modified Carina chassis with optional all-wheel drive and a folding rear seat for cargo flexibility, and it predated the Honda CR-V to market by roughly two years.

Five generations later the RAV4 has become Toyota''s highest-volume passenger vehicle worldwide and a perennial top-five seller in the United States. Hybrid and plug-in Hybrid (Prime) variants accounted for the majority of RAV4 sales by the late XA50 generation. Body variants have included three-door (XA10), five-door (every generation since), and a US-market RAV4 EV (2012-2014, built in cooperation with Tesla and using a Model S-derived electric powertrain). The current sixth-generation RAV4 succeeded the XA50 after a roughly seven-year run with a hybrid-only lineup.'
WHERE mk.slug = 'toyota' AND m.slug = 'rav4';

-- Toyota Corolla
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Corolla is the best-selling automotive nameplate in history, with over 50 million units sold across twelve generations since the original Corolla launched in November 1966. Originally a small rear-wheel-drive compact sedan, the Corolla transitioned to front-wheel drive with the fifth-generation E80 in 1983 and has been front-engine, front-wheel-drive on its mainstream variants since.

The Corolla has been Toyota''s primary high-volume model in nearly every market it serves, with regional variants tailored to local taste. The European Corolla has historically been more performance-oriented; the Asian Corolla emphasises space efficiency and low cost. The current twelfth-generation E210 launched in late 2018 with separate sedan and hatchback body styles on the TNGA-C platform. North-American Corollas are built at Toyota''s Blue Springs, Mississippi plant; European cars at Toyota Manufacturing UK in Burnaston.'
WHERE mk.slug = 'toyota' AND m.slug = 'corolla';

-- Ford Mustang
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Ford Mustang is the original pony car, launched in April 1964 (the famous ''1964½'' model year) as a sporty-looking rear-wheel-drive compact based on Falcon mechanicals. The Mustang created the pony-car segment essentially single-handedly, with the first generation reaching one million sales within 18 months — one of the fastest new-car launches in automotive history.

Across seven generations the Mustang has remained continuously in production with only one significant downsizing detour (the second-generation Mustang II, 1974-1978, built on Pinto underpinnings during the oil crisis). Body styles have included fastback, notchback coupe, convertible and a brief Mustang II hatchback. High-performance variants have been a continuous fixture: Boss, Mach 1, GT350, GT500, Bullitt and Cobra Jet drag-racing specials. The Mustang is unique among American muscle cars in remaining in continuous production through both the oil crisis and the 2009 financial crisis. Production runs at Ford''s Flat Rock Assembly Plant in Michigan.'
WHERE mk.slug = 'ford' AND m.slug = 'mustang';

-- Volkswagen Golf
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Volkswagen Golf launched in May 1974 as the successor to the air-cooled Beetle, and was the car that re-established Volkswagen as a mass-market manufacturer after the Beetle''s decline. The first-generation Golf was the first water-cooled, front-engine, front-wheel-drive Volkswagen — a complete architectural reset. The Golf established the C-segment hatchback template that European and Asian competitors have followed for fifty years.

Across eight generations the Golf has been offered in increasing variety: the GTI hot hatch (continuously available since 1976), the R / Rallye / R32 high-performance variants with all-wheel drive, the diesel TDI, the plug-in hybrid GTE, the fully electric e-Golf (Mk7 only), and the GTD performance diesel. The Golf has been the best-selling car in Europe in many years. Production is centred at Volkswagen''s Wolfsburg plant in Germany, with the long-discontinued North-American Golf having been sourced from Volkswagen de México in Puebla.'
WHERE mk.slug = 'volkswagen' AND m.slug = 'golf';

-- Subaru Outback
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Subaru Outback launched in 1994 as a lifted, body-cladded variant of the second-generation Legacy wagon, aimed at customers who wanted SUV utility without an SUV. Six generations later the Outback has effectively replaced traditional Legacy wagon sales in most markets — Subaru kept the Outback on the Legacy chassis but the Outback nameplate now outsells the Legacy sedan it once supplemented by a significant margin.

The Outback has been a continuous beneficiary of Subaru''s symmetrical all-wheel-drive system, with every Outback since 1994 standard with AWD. Body cladding, raised ride height (around 8.7 inches across most generations) and roof rails have remained design constants. The Outback Wilderness variant, introduced on the sixth-generation BT in 2022, adds further ride height and all-terrain tyres for serious off-road duty. Production runs at Subaru Indiana Automotive in Lafayette for North America.'
WHERE mk.slug = 'subaru' AND m.slug = 'outback';

-- Mazda 3
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Mazda 3 is the company''s C-segment compact, launched in 2003 as the successor to the Familia / Mazda 323 / Protégé nameplate (which dated back to 1963). The Mazda 3 has been a continuous fixture in Mazda''s lineup across four generations (BK, BL, BM/BN, BP) and has been the company''s highest-volume passenger car in most markets.

The Mazda 3 was the first Mazda to receive the SkyActiv chassis and engines (third-generation BM/BN, 2013) and the first to use SkyActiv-X compression-ignition petrol (fourth-generation BP, where offered). Body styles have been continuous sedan and five-door hatchback, with a brief two-door coupe in the first generation. The Mazdaspeed 3 / Mazda 3 MPS hot hatch was offered on the first and second generations with the L3-VDT turbocharged 2.3-litre four. The current BP launched in 2019 and runs SkyActiv-Vehicle Architecture.'
WHERE mk.slug = 'mazda' AND m.slug = '3';

-- Tesla Model Y
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Tesla Model Y is a compact crossover SUV based on the Model 3 sedan platform, launched in March 2020. It has been Tesla''s highest-volume vehicle since launch and was the best-selling car of any kind globally in 2023 — the first electric vehicle to take the global sales crown according to JATO Dynamics.

The Model Y shares approximately 75% of its parts with the Model 3 but uses a taller, wider body with a larger cargo area, a higher seating position and an optional third row (sold in some markets and discontinued in others). Production began at Tesla''s Fremont, California plant and has since expanded to Giga Shanghai (2021), Giga Berlin (2022) and Giga Texas in Austin (2022). The Austin and Berlin cars are the first Teslas built with the structural 4680 battery pack, where the battery housing serves as part of the body structure. A refresh (internally Juniper) launched in early 2025.'
WHERE mk.slug = 'tesla' AND m.slug = 'model-y';

-- Honda Accord
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Honda Accord is Honda''s mid-size sedan, launched in 1976 as a three-door hatchback with the CVCC engine and continuously produced across eleven generations since. The Accord was the first Japanese-branded automobile assembled in the United States — Honda''s Marysville Auto Plant in Ohio began Accord production in November 1982, predating Toyota and Nissan US assembly.

The Accord has been the best-selling Japanese-branded car in the United States in many years, alternating market leadership with the Toyota Camry. The Accord has been offered in sedan, coupe (discontinued after the ninth generation), hatchback and Crosstour (a tall five-door variant offered 2010-2015) body styles. The current eleventh-generation Accord launched for the 2023 model year as a sedan only, with most trims using the e:HEV two-motor hybrid system. Production runs at Honda Manufacturing of Alabama and Marysville Auto Plant in Ohio for North America.'
WHERE mk.slug = 'honda' AND m.slug = 'accord';

-- Mercedes-Benz C-Class
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Mercedes-Benz C-Class is the company''s compact executive sedan, launched in 1993 as the W202 to replace the W201 (190E). The C-Class has been Mercedes'' highest-volume vehicle worldwide for most of its production run and serves as the brand''s primary entry into the luxury-sedan market for newer buyers.

Across five generations (W202, W203, W204, W205, W206) the C-Class has expanded from sedan-only to a body-style range including coupe, cabriolet, T-Modell estate and a US-market sport coupe (W203 generation). The AMG C 63 high-performance variant has been continuously offered since the W203 and has used the M177 4.0-litre V8, the naturally aspirated M156 6.3-litre V8, the M157 5.5-litre V8 and — from the W206 — a four-cylinder hybrid pairing the M139 turbo four with a rear-axle electric motor. The current W206 launched for the 2022 model year. Production runs at Mercedes-Benz Bremen in Germany and at Beijing Benz Automotive for the Chinese market.'
WHERE mk.slug = 'mercedes-benz' AND m.slug = 'c-class';

-- BMW X5
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The BMW X5 launched in 1999 as the first SUV from BMW and the founding member of the company''s X-series SUV lineup. The original E53 X5 was developed during BMW''s ownership of Rover Group and shared a platform with the contemporary Range Rover L322, though BMW divested Rover before the X5 reached production.

Across four generations (E53, E70, F15, G05) the X5 has expanded from a single body to include a coupe-roofline variant (the X6, launched 2008 on the E71 platform, now sharing chassis with the X5), an extended-wheelbase variant for China (G05 generation) and a plug-in hybrid xDrive50e / xDrive45e. The high-performance X5 M arrived on the E70 (2009) and has been continuously offered since. North-American X5s have been produced exclusively at BMW Spartanburg in South Carolina since the model''s launch — the X5 was the first BMW assembled in the United States.'
WHERE mk.slug = 'bmw' AND m.slug = 'x5';
