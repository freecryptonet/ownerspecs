-- Model bios batch 5 — herstructureringsplan §3 Niveau 3. Final batch.

SET NAMES utf8mb4;

-- Ford Bronco
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Ford Bronco is Ford''s body-on-frame off-road SUV, with the original first-generation Bronco launched in August 1965 as a short-wheelbase compact 4WD designed to compete with the Jeep CJ-5 and International Scout. The Bronco was sold through five generations from 1965 to 1996 before being discontinued in favour of the Ford Expedition full-size SUV, which Ford built on the F-150 platform.

After a 25-year absence the Bronco returned in 2021 as the sixth-generation U725, sharing its platform with the smaller Ford Ranger T6.2 and the Everest. The return Bronco was designed as a direct competitor to the Jeep Wrangler — body-on-frame, solid rear axle, removable doors and roof panels. The smaller Bronco Sport (a unibody crossover based on the Escape platform) is a separate model sold concurrently. The sixth-generation Bronco''s Raptor variant (2022 onwards) is the highest-performance Bronco ever offered. Production runs at Ford''s Michigan Assembly Plant in Wayne.'
WHERE mk.slug = 'ford' AND m.slug = 'bronco';

-- Jeep Grand Cherokee
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Jeep Grand Cherokee is Jeep''s mid-size SUV and Jeep''s second-best-selling vehicle in the United States behind the Wrangler. The Grand Cherokee launched in 1992 (1993 model year) as the ZJ, a unibody design that helped define the modern mid-size luxury SUV segment by combining off-road capability with passenger-car-derived ride quality.

Across five generations (ZJ, WJ, WK, WK2, WL/WL75) the Grand Cherokee has been a perennial top-twenty vehicle in the United States and Jeep''s most upmarket non-Wagoneer SUV. High-performance variants have included the SRT8 (WK), the SRT and Trackhawk (WK2, with a 707 hp 6.2-litre supercharged HEMI) — although the Trackhawk was discontinued with the WL transition. The fifth-generation WL added a long-wheelbase Grand Cherokee L (three-row, six- or seven-passenger) for the first time. Production runs at Stellantis Detroit Assembly Complex.'
WHERE mk.slug = 'jeep' AND m.slug = 'grand-cherokee';

-- Chevrolet Tahoe
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Chevrolet Tahoe is GM''s full-size SUV, launched in 1994 for the 1995 model year as a shorter-wheelbase variant of the long-running Chevrolet Suburban. The Tahoe is built on the same body-on-frame GMT platform family as the Silverado 1500 pickup and the GMC Yukon (the Tahoe''s GMC-branded sibling), with the Cadillac Escalade as the luxury variant of the same platform.

Across five generations (GMT400, GMT800, GMT900, K2XX, T1XX) the Tahoe has been a consistent top-three full-size SUV in the United States. The current fifth-generation T1XX (2021 onwards) moved the rear suspension from a live axle to an independent design, substantially improving third-row space and ride quality. The Tahoe Z71 off-road variant has been continuously offered since the K2XX. Production runs at GM''s Arlington Assembly Plant in Texas.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'tahoe';

-- Kia Sportage
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Kia Sportage is Kia''s compact SUV and one of Kia''s longest-running nameplates. The original Sportage launched in 1993 as a body-on-frame compact 4WD with a borrowed Mazda-sourced engine. The Sportage transitioned to a unibody design with the second generation (KM, 2004) and has been continuously unibody since.

Across five generations (JA, KM, SL, QL, NQ5) the Sportage has been Kia''s primary entry in the global compact-SUV segment and frequently Kia''s best-selling model worldwide. The current fifth-generation NQ5 (2022 onwards) is notable for being sold in two different wheelbase lengths — North America gets a long-wheelbase variant with substantially more rear legroom than the global Sportage, an unusual market-specific platform stretch. Production for North America runs at Kia Manufacturing Georgia in West Point.'
WHERE mk.slug = 'kia' AND m.slug = 'sportage';

-- Kia Sorento
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Kia Sorento is Kia''s mid-size three-row SUV. The original first-generation Sorento (BL, 2002) was body-on-frame and shared a platform with the Hyundai Terracan; from the second generation (XM, 2009) the Sorento moved to a unibody platform shared with the Hyundai Santa Fe and has been unibody since.

Across four generations (BL, XM, UM, MQ4) the Sorento has occupied an unusual position in the segment: smaller than the Hyundai Palisade or the Kia Telluride yet larger than the Sportage, with a standard third row that gives it more passenger flexibility than direct compact-SUV competitors. The fourth-generation MQ4 (2021 onwards) added the Smartstream T-GDi turbocharged four and both hybrid and plug-in hybrid drivetrains — the first electrified Sorento. Production runs at Kia''s Hwaseong plant in South Korea for global markets and at Kia Manufacturing Georgia in West Point for North America.'
WHERE mk.slug = 'kia' AND m.slug = 'sorento';

-- Volkswagen Tiguan
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Volkswagen Tiguan is Volkswagen''s compact crossover SUV, launched in 2007 as Volkswagen''s first car-based SUV (predating the smaller T-Roc and T-Cross). The original Tiguan was based on the Golf Mk5 platform and was positioned below the Touareg in the lineup.

The Tiguan has been a perennial top-five-selling Volkswagen globally and has been the company''s highest-volume SUV in most markets. The Tiguan grew substantially with the second generation (AD1, 2016), and Volkswagen began offering a stretched three-row Tiguan Allspace / Tiguan Long-wheelbase specifically for North America and China — making the North-American Tiguan distinct from the European model. The third-generation Tiguan launched in 2024 with both standard and long-wheelbase variants. North-American Tiguans are built at Volkswagen de México in Puebla.'
WHERE mk.slug = 'volkswagen' AND m.slug = 'tiguan';

-- Chrysler Pacifica
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Chrysler Pacifica is Stellantis''s minivan, launched in 2016 for the 2017 model year as the replacement for the Chrysler Town & Country (the long-running nameplate that traced back to 1989). The Pacifica nameplate had previously been used briefly on a 2004-2008 mid-size crossover; the modern Pacifica is unrelated to that car.

The Pacifica was the first plug-in hybrid minivan in the North-American market when it launched the Pacifica Hybrid for the 2017 model year, and it remained the only plug-in hybrid minivan available through most of its production run (the Toyota Sienna and Honda Odyssey were hybrid-only and gasoline-only respectively, with no plug-in option). The Pacifica retained the Stow ''n Go second-row seats that fold flush into the floor — a feature unique to Stellantis''s Chrysler minivans since their introduction on the 2005 Caravan. Production runs at Stellantis Windsor Assembly Plant in Ontario.'
WHERE mk.slug = 'chrysler' AND m.slug = 'pacifica';

-- Volvo XC60
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Volvo XC60 is Volvo''s mid-size luxury SUV, launched in 2008 for the 2009 model year as Volvo''s first compact luxury SUV — slotting between the smaller XC40 (which arrived later in 2017) and the larger XC90. The XC60 has consistently been Volvo''s highest-volume vehicle globally since launch.

Across two generations (first-generation 2008-2017 on Volvo''s P3 platform, second-generation 2017 onwards on Volvo''s Scalable Product Architecture) the XC60 has been continuously available with all-wheel drive and a range of four-cylinder engines exclusively since the second generation. The Polestar Engineered variant of the second-generation XC60 T8 plug-in hybrid is the highest-performance XC60 offered, with Öhlins dampers, Brembo brakes and revised software calibration. Production runs at Volvo''s Torslanda plant in Gothenburg, Sweden.'
WHERE mk.slug = 'volvo' AND m.slug = 'xc60';

-- Volvo XC90
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Volvo XC90 is Volvo''s flagship full-size three-row SUV, launched in 2002 for the 2003 model year as Volvo''s first SUV. The original first-generation XC90 was based on the Volvo P2 platform and was sold continuously for 12 years (2003-2014) — an unusually long production run that allowed it to amortise development costs across a difficult financial period for Volvo Cars.

The second-generation XC90 launched in 2014 for the 2016 model year as the first Volvo built on the Scalable Product Architecture (SPA), the platform that subsequently spread across Volvo''s mid-size and large vehicles. The second-generation XC90 introduced Volvo''s Recharge plug-in hybrid (T8 / Recharge T8) and was Volvo''s most substantial product reset under Geely ownership. The XC90 has remained on the SPA platform across its full run rather than moving to the newer SPA2. Production runs at Volvo''s Torslanda plant in Gothenburg.'
WHERE mk.slug = 'volvo' AND m.slug = 'xc90';

-- Hyundai IONIQ 5
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Hyundai IONIQ 5 is Hyundai''s first vehicle built on the dedicated E-GMP electric platform shared with the Kia EV6 and Genesis GV60, launched in 2021. The IONIQ 5 is part of Hyundai''s standalone IONIQ sub-brand, which Hyundai split off in 2020 to house its dedicated battery-electric vehicles separately from the existing Hyundai-branded model range.

The IONIQ 5 is notable for using an 800V electrical architecture (only Porsche Taycan and Audi e-tron GT used 800V at launch among non-Hyundai-group vehicles), enabling faster DC fast charging than the more common 400V systems. The high-performance IONIQ 5 N, launched in 2024, is the first vehicle from Hyundai''s N performance division built on an electric platform. Production runs at Hyundai Motor Manufacturing Czech in Nošovice for European markets and at the Hyundai Ulsan Plant in South Korea for global export including the United States, with North-American production starting at the new Hyundai Motor Group Metaplant America in Bryan County, Georgia from 2024.'
WHERE mk.slug = 'hyundai' AND m.slug = 'ioniq-5';
