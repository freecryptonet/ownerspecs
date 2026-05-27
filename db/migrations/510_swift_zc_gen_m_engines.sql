-- mig 510: 2nd-gen Suzuki Swift (ZC/ZD, 2004-2010) metadata + M-engine enrichment.
-- Catalog ingested from auto-data (gen 348); engine internals (bore/stroke/compression)
-- came through correct. Enrich valvetrain + display names (engine internals cross-checked
-- vs Wikipedia + engine-specs.net + mymotorlist). All three M-engines: DOHC 16V with VVT-i
-- on the intake cam, common 78.0 mm bore, stroke grows 69.5 -> 78.0 -> 83.0 mm.

UPDATE generations
   SET slug='swift-zc-hatchback-2004-2010', codename='ZC/ZD',
       display_name='Swift (ZC/ZD)', start_year=2004, end_year=2010
 WHERE id=348;

UPDATE engines SET valvetrain='DOHC 16V VVT-i', display_name='Suzuki M16A 1.6L I4' WHERE id=2069;
UPDATE engines SET valvetrain='DOHC 16V VVT-i', display_name='Suzuki M15A 1.5L I4' WHERE id=2070;
UPDATE engines SET valvetrain='DOHC 16V VVT-i', display_name='Suzuki M13A 1.3L I4' WHERE id=2071;
