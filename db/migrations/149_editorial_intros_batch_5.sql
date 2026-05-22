-- Editorial intros batch 5 — herstructureringsplan §3 Niveau 4 #2.
-- Final batch to round out catalogue coverage. Same authoring rules as previous batches.

SET NAMES utf8mb4;

-- Ford Bronco U725 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The sixth-generation Bronco launched in mid-2021 for the 2021 model year, internally designated U725 — the first Bronco produced since the 1996 fifth-generation was discontinued in favour of the Expedition. The U725 returned to the Bronco''s body-on-frame, solid-rear-axle, removable-door-and-roof formula and was explicitly positioned to compete head-to-head with the Jeep Wrangler JL, which had effectively had the segment to itself for 25 years.

The lineup uses Ford''s 2.3-litre EcoBoost turbocharged four (base 2-door and 4-door) and the 2.7-litre EcoBoost twin-turbo V6 (Wildtrak, Badlands, Outer Banks at higher trims, Raptor). The 7-speed Getrag manual gearbox was offered with the 2.3 only — uniquely for a modern Bronco. The Bronco Raptor, launched 2022, uses a higher-output version of the 3.0-litre EcoBoost paired with the 10R60 10-speed automatic, with significantly wider track and Fox Live Valve dampers. Production runs at Ford''s Michigan Assembly Plant in Wayne.'
WHERE mk.slug = 'ford' AND m.slug = 'bronco' AND g.start_year = 2021;

-- Jeep Grand Cherokee WL (start 2022)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Grand Cherokee launched for the 2022 model year, internally designated WL. It is built on Stellantis''s Giorgio platform (also used by the Alfa Romeo Stelvio and Giulia), substantially upgraded for higher load capacity and a longer wheelbase. The WL was the first Grand Cherokee offered in both standard-length five-passenger and stretched-wheelbase seven-passenger (Grand Cherokee L) configurations, with the L launching first in 2021.

The lineup uses the Pentastar 3.6-litre V6 (base Laredo, Limited, Overland), the HEMI 5.7-litre V8 (Overland, Summit, Trailhawk), and the 4xe plug-in hybrid pairing the 2.0-litre Hurricane turbocharged four with electric motors. The 6.4-litre HEMI was offered briefly in the SRT and Trackhawk variants before Stellantis''s discontinuation of those trims. The Grand Cherokee L (3-row) is sold alongside the 2-row Grand Cherokee through 2025. Production runs at the Stellantis Detroit Assembly Complex.'
WHERE mk.slug = 'jeep' AND m.slug = 'grand-cherokee' AND g.start_year = 2022;

-- Chevrolet Tahoe T1XX (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Tahoe launched in early 2020 for the 2021 model year, internally designated T1XX (shared with the Suburban, GMC Yukon and the Cadillac Escalade). The T1XX moved GM''s full-size SUVs to an independent rear suspension — replacing the live-axle rear of the K2XX predecessor — which added substantial third-row legroom and improved ride quality on broken surfaces.

The lineup uses the L84 5.3-litre V8 with Dynamic Fuel Management (base LS, LT, Z71, Premier), the L87 6.2-litre V8 (RST and Premier, standard on High Country), and the LM2 / LZ0 3.0-litre Duramax inline-six diesel. The 10-speed automatic is the only transmission. A mid-cycle refresh for 2025 brought a redesigned interior with a 17.7-inch infotainment display, the High Country with revised front-end styling and Super Cruise hands-free driving available. Production runs at GM''s Arlington Assembly in Texas.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'tahoe' AND g.start_year = 2021;

-- Kia Sportage NQ5 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Sportage launched for the 2023 model year (later in some markets), internally designated NQ5. It is built on Hyundai''s N3 platform shared with the Hyundai Tucson NX4. The North-American Sportage NQ5 uses a slightly stretched wheelbase compared with the global model — Kia made the unusual choice of producing two different sized Sportages for different markets, with the North-American long-wheelbase variant adding rear legroom.

The North-American lineup uses the Smartstream G2.5 GDi 2.5-litre naturally aspirated four (base LX, EX), a hybrid variant with the 1.6-litre T-GDi turbocharged four (Hybrid LX, EX, SX), and a plug-in hybrid using the same drivetrain with a larger lithium-polymer battery. The X-Pro and X-Pro Prestige trims add off-road equipment including all-terrain tyres, raised ride height and skid plates. Production for North America runs at Kia Manufacturing Georgia in West Point.'
WHERE mk.slug = 'kia' AND m.slug = 'sportage' AND g.start_year = 2021;

-- Kia Sorento MQ4 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Sorento launched in early 2020 for the 2021 model year, internally designated MQ4. It is built on Hyundai-Kia''s N3 platform shared with the Hyundai Santa Fe TM and the smaller Sportage NQ5. The MQ4 moved the Sorento to a unibody platform after the previous-generation BL/UM had been body-on-frame (technically a Hyundai Santa Fe platform sibling), making the MQ4 a full unibody mid-size three-row SUV.

The lineup uses the Smartstream G2.5 GDi 2.5-litre naturally aspirated four (base LX, S), the Theta III T-GDi 2.5-litre turbocharged four (EX, SX, SX Prestige, X-Line), a Hybrid variant pairing the Smartstream 1.6 T-GDi with electric motors, and a plug-in hybrid using the same hybrid drivetrain with a larger battery. The X-Pro variant arrived in 2023 with off-road tyres, raised ground clearance and revised gearing. Production for the global market runs at Kia''s Hwaseong plant in South Korea, with North-American production at Kia Manufacturing Georgia in West Point.'
WHERE mk.slug = 'kia' AND m.slug = 'sorento' AND g.start_year = 2021;

-- Volkswagen Tiguan AD1 (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The second-generation Tiguan launched in late 2015 for the 2016 model year in Europe and 2017 in North America, internally designated AD1 / Tiguan Mk2. It is built on the Volkswagen Group MQB platform shared with the Golf Mk7/Mk8, Audi Q3, Skoda Karoq and SEAT Ateca. The AD1 grew substantially over the first-generation Tiguan and offered two wheelbase lengths globally — the standard wheelbase for Europe and a long-wheelbase variant (Tiguan Allspace / Tiguan Long-wheelbase) specifically for North America with a third row of seating.

The North-American lineup uses the EA888 evo3 2.0-litre TSI turbocharged four with the AQ300 8-speed automatic. Outside North America the EA211 1.5 TSI and various TDI diesels are also offered. The R variant (sold in Europe and Asia) uses a higher-output EA888 with permanent all-wheel drive and rear torque vectoring. A facelift for 2022 brought revised exterior styling and a new infotainment unit. North-American Tiguans are built at Volkswagen de México in Puebla.'
WHERE mk.slug = 'volkswagen' AND m.slug = 'tiguan' AND g.start_year = 2017;

-- Chrysler Pacifica RU (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The Chrysler Pacifica launched in early 2016 for the 2017 model year, internally designated RU. It is the replacement for the Chrysler Town & Country and was the most substantial minivan reset in Chrysler''s history — the Pacifica adopted a unique platform with substantially revised packaging, including Stow ''n Go second-row seats that fold flush into the floor (a Chrysler segment innovation continued from the Town & Country), and the first plug-in hybrid minivan available in the North-American market.

The lineup uses the Pentastar 3.6-litre V6 paired with a 9-speed automatic (Pacifica conventional), and the 3.6-litre V6 paired with a 16 kWh battery and electric motors integrated into the transmission for the Pacifica Hybrid (the segment''s only plug-in hybrid through most of its production). The Pacifica Voyager, a budget trim, was sold 2020-2021 to replace the Dodge Grand Caravan. Production runs at Stellantis (FCA) Windsor Assembly Plant in Ontario.'
WHERE mk.slug = 'chrysler' AND m.slug = 'pacifica' AND g.start_year = 2017;

-- Volvo XC60 mk2 (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The second-generation XC60 launched in mid-2017 for the 2018 model year. It is built on Volvo''s Scalable Product Architecture (SPA) shared with the XC90 II, S90, V90 and S60 of the same era — a major platform reset that moved Volvo''s mid-size and large vehicles to a common architecture for the first time. The second-generation XC60 introduced Volvo''s contemporary "Thor''s Hammer" headlamp design and the portrait-orientation Sensus infotainment screen.

The lineup uses Volvo''s VEA family of 2.0-litre four-cylinder engines — the T5 turbocharged (FWD only, dropped from later years), T6 supercharged + turbocharged (AWD), and the T8 plug-in hybrid pairing the T6 with an electric motor on the rear axle. A B5 / B6 mild-hybrid designation replaced the T5/T6 with the 2020 model year. The Polestar Engineered variant of the T8 added Öhlins dampers and Brembo brakes. Production runs at Volvo''s Torslanda plant in Gothenburg, Sweden.'
WHERE mk.slug = 'volvo' AND m.slug = 'xc60' AND g.start_year = 2017;

-- Volvo XC90 II (start 2015)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The second-generation XC90 launched in mid-2015 for the 2016 model year. It was the first Volvo built on the company''s Scalable Product Architecture (SPA), the platform that subsequently spread to the XC60 II, S90, V90, S60 III and V60 III. The second-generation XC90 marked Volvo''s most substantial product reset under Geely ownership — the launch followed Geely''s 2010 acquisition of Volvo Cars from Ford.

The lineup uses Volvo''s VEA family of 2.0-litre four-cylinder engines exclusively: the T5 turbocharged, the T6 supercharged + turbocharged ("twin-charged"), and the T8 plug-in hybrid pairing the T6 with a rear-axle electric motor. A diesel D5 was offered outside North America. A B5 / B6 mild-hybrid designation replaced the T5/T6 with the 2020 model year. A heavy mid-cycle refresh launched in 2019 with revised front-end styling and the Recharge plug-in hybrid trim across the lineup. The XC90 has remained on the SPA platform across its entire run rather than moving to Volvo''s newer SPA2. Production runs at Torslanda.'
WHERE mk.slug = 'volvo' AND m.slug = 'xc90' AND g.start_year = 2015;

-- Honda Civic X (10th gen, start 2016)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The tenth-generation Civic launched in late 2015 for the 2016 model year, internally designated FC for the sedan and FK for the hatchback. It was a substantial reset from the conservative ninth-generation Civic FB — the FC adopted a longer, lower silhouette, more aggressive styling and a substantially upgraded interior with the new Honda Sensing driver-assistance suite as standard on most trims. The FC was the first Civic to use Honda''s L15B 1.5-litre turbocharged four.

The North-American range carried the L15B7 1.5-litre turbocharged four (Sport, EX, EX-L, Touring) and the R18 1.8-litre naturally aspirated four (base LX, dropped after the 2019 model year). The Si variant carried the L15B7 with a six-speed manual and a stiffer chassis tune; the Type R FK8 (2017-2021) used the K20C1 turbocharged 2.0-litre paired with a six-speed manual and was the first US-market Type R. The eleventh-generation Civic FE replaced the FC for the 2022 model year. Production ran at Honda''s Greensburg, Indiana plant for North America and at Yorii in Saitama, Japan for the home market.'
WHERE mk.slug = 'honda' AND m.slug = 'civic' AND g.start_year = 2016;
