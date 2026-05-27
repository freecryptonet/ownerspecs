-- mig 514: fill missing internals on BMW S55B30 (235) + S58B30 (236) so the engine pages
-- and the s55b30-vs-s58b30 comparison show bore/stroke/compression/valvetrain (were "—").
-- Cross-checked: S55 84.0x89.6 mm 10.2:1 (Prestige&Performance, BimmerBoost, bmw-club.cz);
-- S58 84.0x90.0 mm 9.3:1 (Wikipedia B58 article, CarbonXtreme). Both DOHC 24v twin-turbo
-- with Double-VANOS + Valvetronic. Engine internals are catalog data (not citation-gated).

UPDATE engines SET bore_mm=84.0, stroke_mm=89.6, compression=10.2,
       valvetrain='DOHC 24V Double-VANOS, Valvetronic'
 WHERE id=235;  -- S55B30

UPDATE engines SET bore_mm=84.0, stroke_mm=90.0, compression=9.3,
       valvetrain='DOHC 24V Double-VANOS, Valvetronic'
 WHERE id=236;  -- S58B30
