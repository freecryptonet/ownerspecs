-- mig 415: seed tire_pressures for BMW 2 Series (G42, gen 215) — first German thin-gen fill
-- from the service-manual tyre-fitment table (data HaynesPro returned nothing for on this chassis).
-- Standard fitment 225/45 R18 95H XL, square 7.5J. Cold pressure 32 psi (normal/low-load end of
-- the 32-36 placard range) = 221 kPa. Cited to the existing vendor-neutral BMW 2 (G42/G87)
-- service-manual source (780); the underlying aggregator is never named, per policy.

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (215,'front','normal',32.0,221,'225/45 R18'),
  (215,'rear','normal',32.0,221,'225/45 R18');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, 780 FROM tire_pressures WHERE generation_id=215;
