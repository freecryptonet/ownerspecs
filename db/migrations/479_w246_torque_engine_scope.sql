-- mig 479: torque specs are engine-specific. The W246's 106 torque rows were
-- stored gen-wide (engine_id NULL) but are actually the M270 petrol (270.910)
-- values from HaynesPro — they leaked onto the diesel, 2.0-petrol and B250e EV
-- trims (a BEV showing "spark plug 23 N·m" etc.).
--
-- Scope the engine-internal fasteners to engine 1992 (270.910, M270 1.6 — the
-- documented source). Chassis/drivetrain fasteners (wheel bolts, drive shaft,
-- wheel bearing, steering, differential, AC compressor, alternator, transmission
-- drain/filler, reduction gearbox, tyre-pressure sensor) STAY gen-wide — they
-- apply across engines/trims.
--
-- Result: petrol-1.6 trims show engine torques; diesel / 2.0-petrol / EV trims
-- show only chassis torques (honest — we have no verified torque set for those
-- engines). The gen-level /torque page still lists everything.

UPDATE torque_specs
   SET engine_id = 1992
 WHERE generation_id = 317
   AND engine_id IS NULL
   AND fastener REGEXP 'spark|glow|fuel|injector|ignition|exhaust|cylinder head|valve cover|camshaft|crankshaft|timing|flywheel|flexplate|dual mass|clutch pressure|sump|engine oil|oil filter|oxygen|nox|knock|manifold|big-end|bearing cap|turbo|coolant pump|starter motor|high-pressure pump|Refer to';
