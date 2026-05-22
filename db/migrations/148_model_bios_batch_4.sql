-- Model bios batch 4 — herstructureringsplan §3 Niveau 3.
-- Ten more 140-160 word bios.

SET NAMES utf8mb4;

-- Toyota Tacoma
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Tacoma is Toyota''s mid-size pickup, launched in 1995 as the replacement for the original Hilux-based compact pickup line in North America. The Tacoma nameplate has been continuously produced across four generations and has been the best-selling vehicle in its segment in the United States in most years since the late 1990s, frequently outselling the Chevrolet Colorado, Ford Ranger and Nissan Frontier combined.

The Tacoma transitioned from a Toyota-Hilux-derived body-on-frame compact to a dedicated mid-size body-on-frame platform with the second generation (2005), and to the TNGA-F global platform shared with the Tundra and Land Cruiser 300 with the fourth-generation Tacoma (2024). Trim levels span from work-truck SR through SR5, TRD Sport, TRD Off-Road, TRD Pro, Limited and (from 2024) the Trailhunter overlanding variant. Production for the North-American market runs at Toyota''s Guanajuato, Mexico and San Antonio, Texas plants.'
WHERE mk.slug = 'toyota' AND m.slug = 'tacoma';

-- Hyundai Palisade
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Hyundai Palisade is Hyundai''s flagship three-row SUV, launched in 2018 for the 2020 model year as the replacement for the Santa Fe XL. The Palisade is built on the Hyundai-Kia midsize SUV platform shared with the Kia Telluride and represents Hyundai''s deliberate push upmarket in North America, where it occupies the space between the smaller Santa Fe and the Genesis GV80.

The Palisade has been a consistent top-twenty SUV in the United States since launch and has been Hyundai''s highest-volume three-row SUV. The Calligraphy trim, introduced in 2021, is Hyundai''s most luxurious passenger-vehicle trim level historically and sits above the Limited as a premium variant. The second-generation Palisade arrived for the 2026 model year. Production runs at Hyundai Motor Company''s Ulsan Plant 4 in South Korea for global markets, with no current North-American assembly.'
WHERE mk.slug = 'hyundai' AND m.slug = 'palisade';

-- Ram 1500
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Ram 1500 is Stellantis (formerly FCA US, formerly Chrysler)''s full-size light-duty pickup. It was originally sold as the Dodge Ram 1500 from 1981 to 2010, when Chrysler spun the Ram nameplate off as a separate brand. The Ram 1500 has been a consistent top-three vehicle in the United States by sales, alternating second and third place with the Chevrolet Silverado behind the perennial sales leader, the Ford F-150.

Five generations later (1981 Dodge Ram, 1994 Dodge Ram, 2002 Dodge Ram, 2009 Ram DS, 2019 Ram DT) the 1500 has accumulated a reputation for the most luxurious interiors in the full-size light-duty segment, particularly on the Limited and Longhorn trims. The Ram 1500 TRX (2021-2024) was the only OEM supercharged-V8 light-duty pickup in production. The current DT generation launched for the 2019 model year and is built at Stellantis Sterling Heights Assembly Plant in Michigan.'
WHERE mk.slug = 'ram' AND m.slug = '1500';

-- Mazda CX-5
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Mazda CX-5 is Mazda''s compact crossover SUV, launched in 2012 for the 2013 model year as the replacement for the CX-7. The CX-5 was the first Mazda to use the SkyActiv chassis, engines and transmissions — a comprehensive technology rollout that Mazda used to reposition itself as a more enthusiast-oriented mainstream brand after a difficult late-2000s.

Across two generations (KE first generation 2012-2017, KF second generation 2017-2024) the CX-5 has been Mazda''s best-selling vehicle in North America and globally. The CX-5 was the first vehicle to receive the SkyActiv-Vehicle Architecture body-shell technology and SkyActiv-G compression-ratio petrol engines. The CX-50, launched in 2022 as a North-American-specific crossover sized between the CX-5 and the CX-9, replaces the CX-5 in some regions. Production runs at Mazda Hofu in Japan; CX-50 production runs at Mazda Toyota Manufacturing in Huntsville, Alabama.'
WHERE mk.slug = 'mazda' AND m.slug = 'cx-5';

-- Honda Odyssey
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Honda Odyssey is Honda''s minivan, launched in 1995 originally as a smaller, semi-station-wagon-shaped vehicle aimed at urban families. The first-generation Odyssey was a sales disappointment in North America; Honda redesigned it for the 1999 second-generation as a full-size sliding-door minivan and the Odyssey became one of the segment''s defining nameplates.

Five generations later (RA, RL1, RL3, RL5, RL6) the Odyssey has been a consistent top-three minivan in the United States, alternating leadership with the Toyota Sienna and Chrysler Pacifica. The Odyssey introduced segment innovations including Magic Slide second-row seats, fold-into-the-floor third-row seats, CabinWatch in-car video and CabinTalk intercom. The current fifth-generation RL6 launched for the 2018 model year and was discontinued from North America after the 2025 model year. Production runs at Honda Manufacturing of Alabama in Lincoln.'
WHERE mk.slug = 'honda' AND m.slug = 'odyssey';

-- Toyota Sienna
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Sienna is Toyota''s minivan, launched in 1997 for the 1998 model year as the replacement for the smaller, less practical Toyota Previa. The Sienna was the first Toyota minivan built on a unibody platform shared with a passenger car (the Camry V20 generation), and the first Toyota minivan assembled in the United States.

Across four generations (XL10, XL20, XL30, XL40) the Sienna has been a consistent top-three minivan in the United States. The Sienna is the only minivan in the segment to offer all-wheel drive continuously since the second generation (introduced as an option in 2004). The current fourth-generation XL40 (2021 onwards) is the first hybrid-only minivan in the North-American market, replacing the long-running 2GR-FKS 3.5-litre V6 with a 2.5-litre four-cylinder hybrid drivetrain. Production runs at Toyota Motor Manufacturing Indiana in Princeton.'
WHERE mk.slug = 'toyota' AND m.slug = 'sienna';

-- Audi A4
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Audi A4 is Audi''s compact executive sedan, launched in 1994 as the replacement for the Audi 80. The A4 has been the Audi brand''s highest-volume passenger car in most markets and is the principal competitor to the BMW 3 Series and Mercedes-Benz C-Class.

Across five generations (B5, B6, B7, B8, B9) the A4 has continuously offered sedan and Avant estate body styles, with the Cabriolet variant sold through the B6 and B7 generations before splitting off as the A5 Cabriolet. The S4 high-performance variant has used various engines: 2.7T V6 (B5), 4.2 V8 (B6, B7), supercharged 3.0 V6 (B8), and turbocharged 3.0 V6 (B9). The RS 4, sold mainly as an Avant, has continuously used high-output V6 or V8 engines and has been a B6, B7, B8 and B9 model. Production runs at Audi Ingolstadt in Germany and at Audi Neckarsulm for some variants.'
WHERE mk.slug = 'audi' AND m.slug = 'a4';

-- Mercedes-Benz E-Class
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Mercedes-Benz E-Class is Mercedes'' mid-size executive sedan, with the W124 generation (1985-1995) the first model to use the E-Class designation when Mercedes introduced its current naming convention in 1993. The E-Class lineage traces back to the W120 Ponton sedan of 1953 — making it one of the longest-running automobile lineages still in production.

Across five E-Class generations (W210, W211, W212, W213, W214) the E-Class has been Mercedes-Benz''s highest-volume vehicle globally in most years. Body variants have included sedan, T-Modell estate, coupe, cabriolet, the long-wheelbase Chinese-market V-codes, and the All-Terrain raised estate (W213 onwards). The AMG E63 high-performance variant has been continuously offered since the W210 (E55 AMG initially), and has used the M113 supercharged 5.4 V8, the naturally aspirated M156 6.2 V8, the M157 5.5 twin-turbo V8 and the M177 4.0 twin-turbo V8. Production runs at Mercedes-Benz Sindelfingen in Germany.'
WHERE mk.slug = 'mercedes-benz' AND m.slug = 'e-class';

-- BMW X3
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The BMW X3 is BMW''s compact luxury SUV, launched in 2003 (E83 generation, 2004 model year) as the second BMW SUV after the X5. The original E83 was built in Austria by Magna Steyr under contract for BMW, marking the first BMW SUV outsourced to a contract manufacturer. From the second-generation F25 (2010) the X3 moved to BMW''s own production at Spartanburg, South Carolina.

Four generations later (E83, F25, G01, G45) the X3 has become one of BMW''s top-three highest-volume models globally. The X3 was the first BMW to offer the high-performance X3 M variant (E83 era featured the xDrive35is, full M only arrived on the G01 in 2019). The X3 M and X3 M Competition use the S58 inline-six shared with the M3 and M4. The current G01 launched for the 2018 model year; its successor G45 launched in 2024. Production runs at BMW Spartanburg in South Carolina for global markets.'
WHERE mk.slug = 'bmw' AND m.slug = 'x3';

-- Hyundai Elantra
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Hyundai Elantra is Hyundai''s compact sedan, launched in 1990 as a model originally aimed at North American and European markets. The Elantra is sold as the Avante in South Korea and in some Asian markets — the global product itself has been continuous through seven generations under the Elantra and Avante names.

Across seven generations the Elantra has been a consistent top-five compact sedan in the United States by sales. The Elantra GT hatchback variant was offered through the AD (sixth) generation but discontinued for the CN7 (seventh). The high-performance Elantra N (CN7, 2022 onwards) is the first Elantra developed by Hyundai''s N performance division and shares its 2.0-litre turbocharged four with the Veloster N and Kona N. A hybrid Elantra was offered from the CN7 onwards as Hyundai''s first hybrid compact sedan in the North-American market. Production for North America runs at Hyundai Motor Manufacturing Alabama in Montgomery.'
WHERE mk.slug = 'hyundai' AND m.slug = 'elantra';
