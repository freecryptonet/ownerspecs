-- mig 503: normalise metadata for 4 new catalog-only generations created from
-- auto-data + ultimatespecs ingest (prompted by CoC scans identifying gaps).
-- Catalog data (trims/dims/engines/tyres/weights) is not citation-gated; moat
-- (fluids/torques/bulbs/fuses/service/parts + braked towing) is deferred ("catalogue
-- now, moat later" — Tim 2026-05-27). Slugs follow <model>-<codename>-<body>-<years>.
-- Slug-year wins over auto-data's EU start year per the slug-year invariant.

-- Nissan Qashqai II (J11) — gen 344
UPDATE generations
   SET slug='qashqai-j11-suv-2014-2021', start_year=2014, end_year=2021
 WHERE id=344;

-- Nissan Juke (F15) — gen 345 (scraper left codename NULL on "Juke I")
UPDATE generations
   SET slug='juke-f15-suv-2010-2019', codename='F15', display_name='Juke (F15)',
       start_year=2010, end_year=2019
 WHERE id=345;

-- Hyundai i20 II (GB) — gen 346
UPDATE generations
   SET slug='i20-gb-hatchback-2014-2020', end_year=2020
 WHERE id=346;

-- Mitsubishi Outlander III (GF) — gen 347 (codename NULL from "Outlander III")
UPDATE generations
   SET slug='outlander-gf-suv-2012-2021', codename='GF', end_year=2021
 WHERE id=347;
