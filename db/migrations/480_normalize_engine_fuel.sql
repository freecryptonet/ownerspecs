-- mig 480: normalize engines.fuel. Petrol engines were split across two labels
-- ("Petrol" 483 + "gasoline" 174) plus inconsistent case, so the engine index
-- showed "Petrol" next to "diesel"/"gasoline" — sloppy for an international site
-- and it made fuel-based suppression logic fragile. Canonicalise to lowercase
-- (petrol/diesel/electric/hybrid/...), international term "petrol".
UPDATE engines SET fuel='petrol' WHERE fuel IN ('Petrol','gasoline','Gasoline');
UPDATE engines SET fuel='diesel' WHERE fuel='Diesel';
UPDATE engines SET fuel='electric' WHERE fuel='Electric';
UPDATE engines SET fuel='hybrid' WHERE fuel='Hybrid';
