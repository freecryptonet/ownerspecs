-- mig 407: reword door-placard / battery-fitment source citations to manufacturer framing
--
-- These 6 rows carry tyre-pressure / battery-fitment data whose authoritative origin is the
-- manufacturer's door-jamb placard (tyre & loading) or the vehicle's battery-fitment spec.
-- They were previously labelled "(aggregated reference)" because the VALUE was looked up via a
-- third-party aggregator (the OM defers to the placard, so we couldn't read it from the OM PDF).
--
-- Per the OEM-only citation directive + consistency with how we treat all other lookups (cite the
-- OEM origin; keep the aggregator as an internal is_public=0 cross-check), reword to name the
-- manufacturer placard/spec as the source of record. The placard IS manufacturer documentation
-- affixed to the vehicle; the aggregator was only our lookup path. No is_public / link change.
UPDATE sources SET citation='Dodge Durango (WD) manufacturer tire & loading placard'          WHERE id=882;
UPDATE sources SET citation='Dodge Journey (JC) manufacturer tire & loading placard'          WHERE id=886;
UPDATE sources SET citation='Jeep Cherokee (KL) manufacturer tire & loading placard'          WHERE id=888;
UPDATE sources SET citation='Jeep Renegade (BU) manufacturer battery fitment specification'   WHERE id=891;
UPDATE sources SET citation='Jeep Gladiator (JT) manufacturer tire & loading placard'         WHERE id=893;
UPDATE sources SET citation='Jeep Grand Cherokee (WK2) manufacturer tire & loading placard'   WHERE id=895;

-- NOT touched: sources 896 (Challenger LC), 897 (Dart PF), 899 (Hornet) — "aggregated service
-- reference (non-OEM)". These are the SOLE public source on 7/7/3 spec rows respectively (hiding
-- them would un-render those specs) and have NO manufacturer origin, so relabelling them "OEM"
-- would be fabrication. FLAGGED for proper OEM re-sourcing via the Mopar owner-manual portal
-- (all three are in the Mopar 687-tuple direct-PDF set) as lane-3 work, then these rows retire.
