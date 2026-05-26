-- mig 472: align the B 250 e electric-drive engine label to its peak power.
-- engines.display_name read "250 e (780.990) 65kW" (the EU type-approval continuous
-- rating) while the trim shows 179 Hp (132 kW peak). That inconsistency reads badly
-- and undermines trust — align the engine label to the same 132 kW peak figure.
-- Only display_name changes; the frozen /engines/780990 slug is untouched.

UPDATE engines
   SET display_name = '250 e (780.990) 132kW'
 WHERE id = 2011 AND display_name = '250 e (780.990) 65kW';
