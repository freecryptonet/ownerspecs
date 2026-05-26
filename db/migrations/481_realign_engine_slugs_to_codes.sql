-- mig 481: realign engine slugs to the corrected codes (migs 473/476/477/478).
-- Those migrations cleaned the codes (e.g. "ESF 6.1 SRT8" -> "ESF") but the slug
-- stayed frozen at the old form ("61-srt8"), so the URL no longer matched the
-- displayed code. The site is young (GSC just verified, GA4 not live) so this is
-- the right moment to clean URLs — paired with 301 redirects in next.config.ts.
-- All 27 target slugs were collision-checked (no clash with existing slugs).
UPDATE engines
   SET slug = TRIM(BOTH '-' FROM REGEXP_REPLACE(LOWER(code), '[^a-z0-9]+', '-'))
 WHERE id IN (188,189,194,190,170,197,167,168,214,212,213,178,166,59,58,181,179,
              187,203,2038,27,202,138,26,184,226,2036,172);
