/**
 * HaynesPro WorkshopData scraper — fluid/torque extraction.
 *
 * HaynesPro requires authentication, so the standalone `fetchHtml()` path
 * used by the public-aggregator scrapers won't work. Instead this module
 * is designed to run inside an already-authenticated browser session via
 * Playwright's `page.evaluate()` (or the Playwright MCP `browser_evaluate`
 * tool). The browser carries the session cookies; the in-page `fetch()`
 * pulls each lubricants/adjustment-data URL with credentials, and the
 * parser runs against the returned HTML.
 *
 * URL pattern walk
 * ----------------
 * 1. /touch/site/layout/makesOverview                        — all makes
 * 2. /touch/site/layout/modelOverview?makeId=m_XXX           — all models
 * 3. /touch/site/layout/modelTypes?modelGroupId=dg_XXX&makeId=m_XXX
 *                                                            — generations
 * 4. /touch/site/layout/modelTypesList?modelId=d_XXX         — engines/types
 *                                                              (<tr data-typeid>)
 * 5. /touch/site/layout/lubricants?typeId=t_XXX&currentSubject=REPAIR_DATA
 *                                                            — fluids
 * 6. /touch/site/layout/adjustmentData?typeId=t_XXX&groupId=QUICKGUIDES
 *                                                            — torques + capacities
 *
 * Step 5 returns server-rendered HTML with `<div id="adjcd_XXXXX">` blocks
 * already populated — no client-side JS needed to materialise them. Each
 * block represents one fluid/component category (engine oil, coolant, DSG,
 * transfer box, etc.) for the given engine.
 *
 * Legal posture
 * -------------
 * HaynesPro is stored as `is_public=0` in `sources` — its citation never
 * appears on public pages. The data extracted here is cross-verified
 * against the per-gen OEM Service Manual citation and the manufacturer
 * aggregator entry; those two `is_public=1` sources are what visitors see.
 * We extract facts (capacities, viscosities, specs, torques), never
 * verbatim text, diagrams, or the page structure.
 */

export type Category =
  | "engine_oil"
  | "coolant"
  | "brake_fluid"
  | "transmission_dct"
  | "transmission_at"
  | "transmission_mt"
  | "transfer_case"
  | "differential_front"
  | "differential_rear"
  | "haldex"
  | "ac_refrigerant"
  | "ac_compressor_oil"
  | "scr_adblue"
  | "dcc_hydraulic"
  | "other";

export type HaynesProSection = {
  id: string; // e.g. "adjcd_307888"
  category: Category;
  variant: string | null; // "Time/distance dependent service, ( - 2020)"
  fluid: string | null; // "Engine oil", "Coolant", etc.
  viscosity: string | null; // "0W-20"
  spec_standard: string | null; // "VW 508 00"
  capacity_l: number | null; // user-facing capacity (refill where both are listed; with-filter for engine oil)
  capacity_l_initial: number | null;
  capacity_l_refill: number | null;
  torque_nm: number | null;
  gearbox_code: string | null; // "0DD", "DQ381", "7SA"
  speeds: number | null;
  raw_text: string;
};

export type HaynesProEngine = {
  type_id: string;
  url: string;
  fetched_at: string;
  sections: HaynesProSection[];
};

/**
 * Classify a section by its leading label.
 *
 * The first non-whitespace token of a HaynesPro lubricants section is
 * almost always the category label (e.g. "Engine", "Cooling system",
 * "Brake system : General data"). Variant prefixes ("Time/distance
 * dependent service, ( - 2020)", "Longlife, Petrol, ( - 2020)") sit
 * before the label only on certain engines — they're handled by the
 * variant parser.
 */
function classify(text: string): Category {
  const t = text.toLowerCase();
  if (/^(?:.*?\)\s*)?engine\b/.test(t) && /engine oil/.test(t)) return "engine_oil";
  if (/^(?:.*?\)\s*)?cooling system/.test(t)) return "coolant";
  if (/^electrical system/.test(t) && /coolant/.test(t)) return "coolant"; // PHEV HV-battery loop
  if (/^brake system/.test(t)) return "brake_fluid";
  if (/^dual-clutch transmission/.test(t)) return "transmission_dct";
  if (/^automatic transmission/.test(t)) return "transmission_at";
  if (/^manual transmission/.test(t)) return "transmission_mt";
  if (/^gearbox hydraulic control/.test(t)) return "transmission_dct"; // PDK hyd circuit
  if (/^transfer (?:box|case)/.test(t)) return "transfer_case";
  if (/^rear differential/.test(t)) return "differential_rear";
  if (/^front differential/.test(t)) return "differential_front";
  if (/^haldex/.test(t)) return "haldex";
  if (/^with r(?:134a|1234yf) refrigerant/.test(t)) return "ac_refrigerant";
  if (/compressor oil/.test(t)) return "ac_compressor_oil";
  if (/^selective catalytic reduction/.test(t) || /\badblue\b/.test(t)) return "scr_adblue";
  if (/^dynamic chassis control/.test(t)) return "dcc_hydraulic";
  return "other";
}

const NUM_RE = /([-+]?\d+(?:[.,]\d+)?)/;

// Section-end markers used by spec_standard captures — kept narrow so we
// don't truncate inside multi-word specs like "VW G 052 182 (VW TL 525 18)".
const SECTION_END =
  "(?:Engine sump|Cooling system|Brake system|Coolant\\b|Dual-clutch|Manual transmission|Automatic transmission|Gear oil|Refrigerant|Initial filling|Gearbox refill|Engine oil drain|Air-conditioning|Plug location|Above\\b|All temperatures|De-ionised|Compressor|Differential|Transfer|Haldex|SAE\\b|Engine\\b|$)";
const SECTION_RE_VISC = /SAE\s+(\d+W-\d+)/;
const SECTION_RE_SPEC_AFTER_VISC = new RegExp(
  "SAE\\s+\\d+W-\\d+\\s+(.+?)(?=\\s+" + SECTION_END + ")",
);
const SECTION_RE_SPEC_ALT = new RegExp(
  "(?:Coolant|Brake fluid(?:\\s*\\([^)]*\\))?|Dual-clutch transmission fluid|ATF(?:\\s*\\([^)]*\\))?|Hydraulic fluid|Gear oil|Diesel exhaust fluid)\\s+(.+?)(?=\\s+" +
    SECTION_END +
    ")",
);

function pickNumber(re: RegExp, text: string): number | null {
  const m = text.match(re);
  if (!m) return null;
  const n = Number(m[1].replace(",", "."));
  return Number.isFinite(n) ? n : null;
}

/**
 * Parse one section's raw text into structured fields.
 *
 * HaynesPro encodes capacity as "<label> N.N (l)" or "<label> N - N (l)".
 * Torque is "<label> NN (Nm)". Viscosity is "SAE 0W-20" or just "0W-20".
 * Spec standard follows the viscosity on the same line: "SAE 0W-20 VW 508 00".
 *
 * Initial-vs-refill: when both appear ("Initial filling 7.2 (l) Gearbox
 * refill 6.0 - 6.5 (l)") we record both. capacity_l (the user-facing
 * value) picks refill since that's what owners drain into.
 */
function parseSection(id: string, rawText: string): HaynesProSection {
  const category = classify(rawText);

  // Variant prefix: matches "(... - 2020)", "(2021 - ...)", "Longlife, ...",
  // "Time/distance dependent service, ..." at the start of the section
  let variant: string | null = null;
  const variantMatch = rawText.match(
    /^((?:Time\/distance dependent service|Longlife|Petrol[^.]*?|\([^)]*?\))[^A-Z]*?)\s+Engine\b/,
  );
  if (variantMatch) variant = variantMatch[1].trim().replace(/,$/, "");

  // Engine oil viscosity ("SAE 0W-20")
  const viscMatch = rawText.match(SECTION_RE_VISC);
  const viscosity = viscMatch ? viscMatch[1] : null;

  // Spec standard — first try the after-viscosity pattern (engine oil case),
  // then fall back to the no-viscosity pattern (coolant, brake, DSG, etc.).
  let spec: string | null = null;
  if (viscMatch) {
    const sm = rawText.match(SECTION_RE_SPEC_AFTER_VISC);
    if (sm) spec = sm[1].trim();
  }
  if (!spec) {
    const sm = rawText.match(SECTION_RE_SPEC_ALT);
    if (sm) spec = sm[1].trim();
  }

  // Capacity. Refill takes precedence over initial.
  let capacity_l: number | null = null;
  let capacity_l_initial: number | null = null;
  let capacity_l_refill: number | null = null;

  const refillMatch = rawText.match(/(?:Gearbox\s+refill|refill|Differential\s+refill|Haldex coupling refill|Refilling)\s+(\d+(?:\.\d+)?)(?:\s*-\s*(\d+(?:\.\d+)?))?\s*\(l\)/i);
  if (refillMatch) {
    capacity_l_refill = Number(refillMatch[1]);
    capacity_l = capacity_l_refill;
  }
  const initialMatch = rawText.match(/Initial filling\s+(\d+(?:\.\d+)?)(?:\s*-\s*(\d+(?:\.\d+)?))?\s*\(l\)/i);
  if (initialMatch) {
    capacity_l_initial = Number(initialMatch[1]);
    if (capacity_l == null) capacity_l = capacity_l_initial;
  }

  // Engine sump (with filter) — the canonical engine_oil capacity
  if (category === "engine_oil") {
    const sumpMatch = rawText.match(/Engine sump,\s*including filter\s+(\d+(?:\.\d+)?)\s*\(l\)/i);
    if (sumpMatch) capacity_l = Number(sumpMatch[1]);
  }

  // Coolant total / Cooling system N.N (l)
  if (category === "coolant" && capacity_l == null) {
    const coolMatch = rawText.match(/(?:Cooling system(?:,\s*high-voltage battery)?)\s+(\d+(?:\.\d+)?)\s*\(l\)/i);
    if (coolMatch) capacity_l = Number(coolMatch[1]);
  }

  // Brake system N.N (l)
  if (category === "brake_fluid" && capacity_l == null) {
    const bMatch = rawText.match(/Brake system(?:\s*\([^)]*\))?\s+(\d+(?:\.\d+)?)\s*\(l\)/i);
    if (bMatch) capacity_l = Number(bMatch[1]);
  }

  // Transfer box N.NN (l)
  if (category === "transfer_case" && capacity_l == null) {
    const tMatch = rawText.match(/Transfer box(?:\s*\([^)]*\))?\s+(\d+(?:\.\d+)?)\s*\(l\)/i);
    if (tMatch) capacity_l = Number(tMatch[1]);
  }

  // Differential N.NN (l)
  if ((category === "differential_front" || category === "differential_rear") && capacity_l == null) {
    const dMatch = rawText.match(/Differential(?:,\s*\w+)?\s+(\d+(?:\.\d+)?)\s*\(l\)/i);
    if (dMatch) capacity_l = Number(dMatch[1]);
  }

  // Drain plug torque NN (Nm)
  const torqueMatch = rawText.match(/drain plug[^.]*?(\d+)\s*\(Nm\)/i);
  const torque_nm = torqueMatch ? Number(torqueMatch[1]) : null;

  // Gearbox code: "0DD", "0GC", "0D9", "0DL", "0AY", "0CN", "0CP", "0FN", "0CR",
  //               "0CQ", "0A6", "7SA", "CDT50", "DQ381", "DQ250", "DQ500",
  //               "DQ400e"
  const gMatch = rawText.match(/transmission,\s*([A-Z0-9]+(?:\s*\([^)]*\))?)/i);
  let gearbox_code = gMatch ? gMatch[1].trim() : null;
  // DQXXX codes appear differently — extract from spec note where present
  if (!gearbox_code) {
    const dqMatch = rawText.match(/\b(DQ\d{3}[a-z]?|7SA|CDT50)\b/);
    if (dqMatch) gearbox_code = dqMatch[1];
  }

  const speedsMatch = rawText.match(/(\d+)-speed/);
  const speeds = speedsMatch ? Number(speedsMatch[1]) : null;

  // Refrigerant charge — distinct unit (grams)
  let refrigerantG: number | null = null;
  if (category === "ac_refrigerant") {
    const rMatch = rawText.match(/Refrigerant\s+(\d+)\s*(?:\+\s*\d+)?\s*(?:±\s*\d+)?\s*\(g\)/);
    if (rMatch) refrigerantG = Number(rMatch[1]);
  }

  // First-token label as "fluid" name
  const fluidMatch = rawText.match(/^[A-Za-z\s\d:.,()-]+?(?=\s+(?:SAE|VW|Porsche|ACEA|TL-VW|Glysantin|Hydraulan|R\d|Diesel exhaust|Pentosin|Mobil|Castrol|Refrigerant|Initial|Gearbox|Engine sump|Brake system|Cooling system|Transfer box|Differential|Haldex|Compressor|Air|Refilling)\b)/);
  const fluid = fluidMatch ? fluidMatch[0].trim() : null;

  return {
    id,
    category,
    variant,
    fluid,
    viscosity,
    spec_standard: spec,
    capacity_l: capacity_l ?? refrigerantG, // refrigerant uses grams but we surface it here for completeness
    capacity_l_initial,
    capacity_l_refill,
    torque_nm,
    gearbox_code,
    speeds,
    raw_text: rawText,
  };
}

/**
 * Parse a lubricants HTML document into a HaynesProEngine record.
 *
 * Uses a DOMParser-style approach. When called from Node, pass a DOM
 * built with `linkedom` or `jsdom`. When called from a browser via
 * page.evaluate, the global `DOMParser` is already available.
 */
export function parseLubricantsHtml(
  html: string,
  typeId: string,
  url: string,
  parser: { parseFromString(html: string, mime: string): Document },
): HaynesProEngine {
  const doc = parser.parseFromString(html, "text/html");
  const blocks = Array.from(doc.querySelectorAll('div[id^="adjcd_"]')) as Element[];
  const sections: HaynesProSection[] = blocks
    .map((el) => {
      const id = (el as HTMLElement).id;
      const text = (el.textContent ?? "").replace(/\s+/g, " ").trim();
      return parseSection(id, text);
    })
    .filter((s) => s.raw_text.length > 0);
  return {
    type_id: typeId,
    url,
    fetched_at: new Date().toISOString(),
    sections,
  };
}

/**
 * Self-contained string designed to run in the browser via
 * `page.evaluate(haynesProBrowserScript, ...args)`.
 *
 * It re-implements `parseSection` inline because eval'd code can't
 * import ESM modules. Returns `HaynesProEngine[]`.
 *
 * Usage from MCP browser_evaluate:
 *   const fn = `async (typeIds) => { ${haynesProBrowserScript}; return run(typeIds); }`;
 *   const result = await page.evaluate(fn, ["t_619032506", "t_619035252"]);
 *
 * Honours the polite-throttle convention (2 s between fetches) since
 * we are hitting an authenticated session — slower than a fresh fetch
 * but kinder to the upstream service.
 */
export const haynesProBrowserScript = `
const SECTION_END = '(?:Engine sump|Cooling system|Brake system|Coolant\\\\b|Dual-clutch|Manual transmission|Automatic transmission|Gear oil|Refrigerant|Initial filling|Gearbox refill|Engine oil drain|Air-conditioning|Plug location|Above\\\\b|All temperatures|De-ionised|Compressor|Differential|Transfer|Haldex|SAE\\\\b|Engine\\\\b|$)';
const SECTION_RE_REFILL = /(?:Gearbox\\s+refill|refill|Differential\\s+refill|Haldex coupling refill|Refilling)\\s+(\\d+(?:\\.\\d+)?)(?:\\s*-\\s*(\\d+(?:\\.\\d+)?))?\\s*\\(l\\)/i;
const SECTION_RE_INITIAL = /Initial filling\\s+(\\d+(?:\\.\\d+)?)(?:\\s*-\\s*(\\d+(?:\\.\\d+)?))?\\s*\\(l\\)/i;
const SECTION_RE_SUMP = /Engine sump,\\s*including filter\\s+(\\d+(?:\\.\\d+)?)\\s*\\(l\\)/i;
const SECTION_RE_COOLANT = /Cooling system(?:,\\s*high-voltage battery)?\\s+(\\d+(?:\\.\\d+)?)\\s*\\(l\\)/i;
const SECTION_RE_BRAKE = /Brake system(?:\\s*\\([^)]*\\))?\\s+(\\d+(?:\\.\\d+)?)\\s*\\(l\\)/i;
const SECTION_RE_TC = /Transfer box(?:\\s*\\([^)]*\\))?\\s+(\\d+(?:\\.\\d+)?)\\s*\\(l\\)/i;
const SECTION_RE_DIFF = /Differential(?:,\\s*\\w+)?\\s+(\\d+(?:\\.\\d+)?)\\s*\\(l\\)/i;
const SECTION_RE_TORQUE = /drain plug[^.]*?(\\d+)\\s*\\(Nm\\)/i;
const SECTION_RE_VISC = /SAE\\s+(\\d+W-\\d+)/;
const SECTION_RE_SPEEDS = /(\\d+)-speed/;
const SECTION_RE_GEARBOX = /transmission,\\s*([A-Z0-9]+)/i;
const SECTION_RE_REFRIG = /Refrigerant\\s+(\\d+)\\s*(?:\\+\\s*\\d+)?\\s*(?:±\\s*\\d+)?\\s*\\(g\\)/;
const SECTION_RE_SPEC_AFTER_VISC = new RegExp('SAE\\\\s+\\\\d+W-\\\\d+\\\\s+(.+?)(?=\\\\s+' + SECTION_END + ')');
const SECTION_RE_SPEC_ALT = new RegExp('(?:Coolant|Brake fluid(?:\\\\s*\\\\([^)]*\\\\))?|Dual-clutch transmission fluid|ATF(?:\\\\s*\\\\([^)]*\\\\))?|Hydraulic fluid|Gear oil|Diesel exhaust fluid)\\\\s+(.+?)(?=\\\\s+' + SECTION_END + ')');

function classify(t) {
  const s = t.toLowerCase();
  if (/^(?:.*?\\)\\s*)?engine\\b/.test(s) && /engine oil/.test(s)) return "engine_oil";
  if (/^(?:.*?\\)\\s*)?cooling system/.test(s)) return "coolant";
  if (/^electrical system/.test(s) && /coolant/.test(s)) return "coolant";
  if (/^brake system/.test(s)) return "brake_fluid";
  if (/^dual-clutch transmission/.test(s)) return "transmission_dct";
  if (/^automatic transmission/.test(s)) return "transmission_at";
  if (/^manual transmission/.test(s)) return "transmission_mt";
  if (/^gearbox hydraulic control/.test(s)) return "transmission_dct";
  if (/^transfer (?:box|case)/.test(s)) return "transfer_case";
  if (/^rear differential/.test(s)) return "differential_rear";
  if (/^front differential/.test(s)) return "differential_front";
  if (/^haldex/.test(s)) return "haldex";
  if (/^with r(?:134a|1234yf) refrigerant/.test(s)) return "ac_refrigerant";
  if (/compressor oil/.test(s)) return "ac_compressor_oil";
  if (/^selective catalytic reduction/.test(s) || /\\badblue\\b/.test(s)) return "scr_adblue";
  if (/^dynamic chassis control/.test(s)) return "dcc_hydraulic";
  return "other";
}

function parseSection(id, raw) {
  const cat = classify(raw);
  let cap = null, capInit = null, capRefill = null;
  let m = raw.match(SECTION_RE_REFILL); if (m) { capRefill = Number(m[1]); cap = capRefill; }
  m = raw.match(SECTION_RE_INITIAL); if (m) { capInit = Number(m[1]); if (cap == null) cap = capInit; }
  if (cat === "engine_oil")    { m = raw.match(SECTION_RE_SUMP);    if (m) cap = Number(m[1]); }
  if (cat === "coolant" && cap == null)      { m = raw.match(SECTION_RE_COOLANT); if (m) cap = Number(m[1]); }
  if (cat === "brake_fluid" && cap == null)  { m = raw.match(SECTION_RE_BRAKE);   if (m) cap = Number(m[1]); }
  if (cat === "transfer_case" && cap == null){ m = raw.match(SECTION_RE_TC);      if (m) cap = Number(m[1]); }
  if ((cat === "differential_front" || cat === "differential_rear") && cap == null) {
    m = raw.match(SECTION_RE_DIFF); if (m) cap = Number(m[1]);
  }
  const v = raw.match(SECTION_RE_VISC);
  const visc = v ? v[1] : null;
  let spec: string | null = null;
  if (v) {
    const sm = raw.match(SECTION_RE_SPEC_AFTER_VISC);
    if (sm) spec = sm[1].trim();
  }
  if (!spec) {
    const sm = raw.match(SECTION_RE_SPEC_ALT);
    if (sm) spec = sm[1].trim();
  }
  const torque = (raw.match(SECTION_RE_TORQUE) ?? [])[1];
  const speeds = (raw.match(SECTION_RE_SPEEDS) ?? [])[1];
  const gearbox = (raw.match(SECTION_RE_GEARBOX) ?? [])[1] ?? null;
  let variant = null;
  const vm = raw.match(/^((?:Time\\/distance dependent service|Longlife|Petrol[^.]*?|\\([^)]*?\\))[^A-Z]*?)\\s+Engine\\b/);
  if (vm) variant = vm[1].trim().replace(/,$/, "");
  let refrigG = null;
  if (cat === "ac_refrigerant") {
    const rm = raw.match(SECTION_RE_REFRIG);
    if (rm) refrigG = Number(rm[1]);
  }
  return {
    id, category: cat, variant,
    fluid: null,
    viscosity: visc, spec_standard: spec,
    capacity_l: cap ?? refrigG,
    capacity_l_initial: capInit, capacity_l_refill: capRefill,
    torque_nm: torque != null ? Number(torque) : null,
    gearbox_code: gearbox, speeds: speeds != null ? Number(speeds) : null,
    raw_text: raw,
  };
}

async function fetchOne(typeId) {
  const url = '/touch/site/layout/lubricants?typeId=' + typeId + '&currentSubject=REPAIR_DATA&groupId=QUICKGUIDES';
  const r = await fetch(url, { credentials: 'include' });
  if (!r.ok) throw new Error('HTTP ' + r.status + ' on ' + typeId);
  const html = await r.text();
  const doc = new DOMParser().parseFromString(html, 'text/html');
  const blocks = Array.from(doc.querySelectorAll('div[id^="adjcd_"]'));
  const sections = blocks.map(el => {
    const raw = (el.textContent || '').replace(/\\s+/g, ' ').trim();
    return parseSection(el.id, raw);
  }).filter(s => s.raw_text.length > 0);
  return { type_id: typeId, url: url, fetched_at: new Date().toISOString(), sections };
}

async function run(typeIds) {
  const out = [];
  for (const id of typeIds) {
    try {
      out.push(await fetchOne(id));
      await new Promise(r => setTimeout(r, 2000)); // polite 2s gap
    } catch (e) {
      out.push({ type_id: id, error: String(e) });
    }
  }
  return out;
}
`;
