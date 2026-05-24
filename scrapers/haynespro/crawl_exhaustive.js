/**
 * HaynesPro EXHAUSTIVE chassis crawler — captures every endpoint HaynesPro
 * exposes per typeId. Used to backfill data points that the lubricants-only
 * crawler missed (torque, electrical, maintenance intervals + items,
 * procedure titles + bodies, labor times).
 *
 * Endpoint map (verified 2026-05-24):
 *   1. modelTypesList?modelId=X     — list typeIds for chassis (1× per chassis)
 *   2. modelDetail?typeId=X         — overview, vehicle image, ID location
 *   3. lubricants?typeId=X          — oil/coolant/brake/transmission
 *   4. adjustmentData?typeId=X      — torque settings, electrical, wheel align
 *   5. modelDetailMaintenance?typeId=X — procedure titles + ms/mp interval IDs
 *   6. maintenanceSchedule?typeId=X&maintenanceSystemId=Y&maintenancePeriodId=Z
 *                                    — per-interval service items
 *   7. repairTimes?typeId=X         — labor times per repair
 *   8. repairManuals?typeId=X&storyId=Y&... — full procedure body / wiring
 *                                    diagram / ID location step-by-step
 *
 * NOT in HaynesPro (must come from OM/FSM PDFs in manual_inventory):
 *   - Bulbs (H7, H4, LED, P21W, W5W — none of these appear in adjustmentData)
 *   - Fuses (no fuse-box layouts in any HaynesPro endpoint)
 *
 * Usage: invoke via Playwright browser_evaluate, on an authenticated
 * workshopdata.com tab. Returns a fully-populated chassis crawl JSON.
 *
 *   const out = await browser_evaluate({
 *     function: `() => { ${this file}; return crawlExhaustive('d_319001449', { fetchProcedureBodies: false }); }`
 *   });
 *
 * Caller writes the returned object to
 *   scrapers/output/haynespro-exhaustive-{slug}-{YYYY-MM-DD}.json
 *
 * THROTTLE
 * --------
 * 600ms between same-typeId fetches (in-page fetch). Conservative because
 * adjustmentData responses are ~500KB.
 *
 * MAINTENANCE-SCHEDULE DEDUPE
 * ---------------------------
 * Maintenance schedules are gen-wide (same petrol-vs-diesel split shared
 * across engines on a chassis). The crawler caches by (typeId,ms,mp) and
 * reuses, but in practice ms/mp values often differ per typeId (different
 * service indicator strategies per engine), so the cache hit rate is low.
 * Set fetchScheduleItems=false to skip per-interval items entirely
 * (interval HEADERS still captured from modelDetailMaintenance).
 *
 * PROCEDURE BODIES
 * ----------------
 * repairManuals?storyId=X for a full procedure body is ~50KB each. With
 * ~19 procedures per typeId and 30 typeIds per chassis, that's ~570 extra
 * fetches per chassis. Default `fetchProcedureBodies=false`; pass `true`
 * to scrape bodies (slow but complete).
 */

async function crawlExhaustive(modelId, opts = {}) {
  const throttleMs = opts.throttleMs ?? 600;
  const fetchScheduleItems = opts.fetchScheduleItems ?? true;
  const fetchProcedureBodies = opts.fetchProcedureBodies ?? false;
  const fetchRepairTimes = opts.fetchRepairTimes ?? true;
  const log = (...a) => console.log('[exhaustive]', ...a);

  const t0 = Date.now();
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  async function get(path) {
    const r = await fetch(path, { credentials: 'include' });
    if (!r.ok) return null;
    return await r.text();
  }
  function toDoc(html) { return new DOMParser().parseFromString(html, 'text/html'); }

  // ───────── Step 1: modelTypesList ─────────
  const tlHtml = await get(`/touch/site/layout/modelTypesList?modelId=${encodeURIComponent(modelId)}`);
  if (!tlHtml) return { error: 'modelTypesList failed', modelId };
  const tlDoc = toDoc(tlHtml);
  const chassisLabel = tlDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
  const rows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]'));
  log(`chassis ${modelId}: ${rows.length} typeIds`);

  const types = [];
  const scheduleCache = new Map();   // key = `${typeId}|${ms}|${mp}` → { items[] }
  const procedureBodies = new Map(); // storyId → { title, body_text, length }

  for (let i = 0; i < rows.length; i++) {
    const r = rows[i];
    const cells = Array.from(r.querySelectorAll('td')).map(td => td.textContent.trim().replace(/\s+/g, ' '));
    const meta = {
      typeId: r.getAttribute('data-typeid'),
      type: cells[0] ?? null,
      engine_code: cells[1] ?? null,
      cc: cells[2] ? parseInt(cells[2], 10) : null,
      kw: cells[3] ? parseInt(cells[3], 10) : null,
      years: cells[4] ?? null,
    };
    const errors = [];

    // ───────── 2. modelDetail ─────────
    await sleep(throttleMs);
    let modelDetail = null;
    try {
      const html = await get(`/touch/site/layout/modelDetail?typeId=${meta.typeId}&groupId=QUICKGUIDES`);
      if (html) modelDetail = parseModelDetail(html);
    } catch (e) { errors.push(`modelDetail ${e.message}`); }

    // ───────── 3. lubricants ─────────
    await sleep(throttleMs);
    let lubricants = null;
    try {
      const html = await get(`/touch/site/layout/lubricants?typeId=${meta.typeId}&groupId=QUICKGUIDES&altView=true`);
      if (html) {
        const doc = toDoc(html);
        lubricants = parseLubricants(doc.body?.innerText ?? '');
      }
    } catch (e) { errors.push(`lubricants ${e.message}`); }

    // ───────── 4. adjustmentData ─────────
    await sleep(throttleMs);
    let adjustment = null;
    try {
      const html = await get(`/touch/site/layout/adjustmentData?typeId=${meta.typeId}&groupId=QUICKGUIDES&fromOverview=true`);
      if (html) {
        const doc = toDoc(html);
        adjustment = parseAdjustmentData(doc.body?.innerText ?? '');
      }
    } catch (e) { errors.push(`adjustmentData ${e.message}`); }

    // ───────── 5. modelDetailMaintenance ─────────
    await sleep(throttleMs);
    let maintenance = null;
    try {
      const html = await get(`/touch/site/layout/modelDetailMaintenance?typeId=${meta.typeId}&groupId=QUICKGUIDES`);
      if (html) {
        const doc = toDoc(html);
        maintenance = parseMaintenanceOverview(html, doc.body?.innerText ?? '');
      }
    } catch (e) { errors.push(`modelDetailMaintenance ${e.message}`); }

    // ───────── 6. maintenanceSchedule (per interval) ─────────
    const intervals = [];
    if (maintenance && fetchScheduleItems) {
      for (const iv of maintenance.intervals) {
        const key = `${meta.typeId}|${iv.ms}|${iv.mp}`;
        if (!scheduleCache.has(key)) {
          await sleep(throttleMs);
          try {
            const html = await get(`/touch/site/layout/maintenanceSchedule?typeId=${meta.typeId}&maintenanceSystemId=${iv.ms}&maintenancePeriodId=${iv.mp}&currentSubject=MAINTENANCE&currentPage=SCHEDULES&currentTypeCar=${meta.typeId}`);
            if (html) {
              const doc = toDoc(html);
              scheduleCache.set(key, parseMaintenanceSchedule(doc.body?.innerText ?? ''));
            } else scheduleCache.set(key, []);
          } catch (e) {
            errors.push(`maintenanceSchedule ${e.message}`);
            scheduleCache.set(key, []);
          }
        }
        intervals.push({ label: iv.label, ms: iv.ms, mp: iv.mp, items: scheduleCache.get(key) });
      }
    }

    // ───────── 7. repairTimes ─────────
    let repairTimes = null;
    if (fetchRepairTimes) {
      await sleep(throttleMs);
      try {
        const html = await get(`/touch/site/layout/repairTimes?typeId=${meta.typeId}&groupId=QUICKGUIDES`);
        if (html) {
          const doc = toDoc(html);
          repairTimes = parseRepairTimes(doc.body?.innerText ?? '');
        }
      } catch (e) { errors.push(`repairTimes ${e.message}`); }
    }

    // ───────── 8. repairManuals (procedure bodies, optional) ─────────
    if (fetchProcedureBodies && maintenance) {
      for (const p of maintenance.procedures) {
        if (!p.storyId || procedureBodies.has(p.storyId)) continue;
        await sleep(throttleMs);
        try {
          const html = await get(`/touch/site/layout/repairManuals?typeId=${meta.typeId}&currentSubject=${p.subject || 'MAINTENANCE'}&currentPage=${p.page || 'MAINTPROC'}&groupId=${p.subject === 'MAINTENANCE' ? 'MAINTENANCE' : 'QUICKGUIDES'}&storyId=${p.storyId}`);
          if (html) {
            const doc = toDoc(html);
            const body = doc.body?.innerText?.trim() ?? '';
            procedureBodies.set(p.storyId, { title: p.title, body_text: body, length: body.length });
          }
        } catch (e) { errors.push(`repairManual ${p.storyId} ${e.message}`); }
      }
    }

    types.push({
      ...meta,
      modelDetail,
      lubricants,
      adjustment,
      maintenance: maintenance ? { procedures: maintenance.procedures, intervals } : null,
      repairTimes,
      errors,
    });
    log(`  [${i + 1}/${rows.length}] ${meta.engine_code} ${meta.type} (${errors.length} err)`);
  }

  return {
    chassis: { modelId, label: chassisLabel, engines_count: rows.length, fetched_at: new Date().toISOString() },
    types,
    procedureBodies: fetchProcedureBodies ? Object.fromEntries(procedureBodies) : null,
    duration_ms: Date.now() - t0,
  };
}

// ───────────────────────── Parsers ─────────────────────────

function parseModelDetail(html) {
  const doc = new DOMParser().parseFromString(html, 'text/html');
  // Extract vehicle image URL + identification labels
  const img = doc.querySelector('img[src*="vehicle"], img[src*="vehicleImages"], .vehicleImage img');
  const labels = {};
  for (const dt of doc.querySelectorAll('dt')) {
    const dd = dt.nextElementSibling;
    if (dd && dd.tagName === 'DD') labels[dt.textContent.trim()] = dd.textContent.trim();
  }
  return { imageUrl: img?.getAttribute('src') ?? null, labels };
}

function parseLubricants(text) {
  const country = text.indexOf('Filter by country');
  const after = country >= 0 ? text.slice(country) : text;
  function findSection(label) {
    const re = new RegExp(`\\n\\s+${label.replace(/[()]/g, '\\$&')}(?:[,\\s][^\\n]*)?\\n`, 'g');
    const m = re.exec(after); return m ? m.index + m[0].indexOf(label) : -1;
  }
  const oilStart = findSection('Engine oil'); const coolStart = findSection('Cooling system');
  const oilBlock = oilStart >= 0 ? after.slice(oilStart, coolStart > 0 ? coolStart : oilStart + 5000) : '';
  const oilVisc = oilBlock.match(/SAE\s+(\d+W-\d+)/);
  const oilSpec = oilBlock.match(/(?:VW|BMW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA|JASO|Nissan|Hyundai|Kia)[^\n]+/);
  const oilSump = oilBlock.match(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/);
  const oilDrain = oilBlock.match(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/);
  const brakeStart = findSection('Brake system');
  const coolBlock = coolStart >= 0 ? after.slice(coolStart, brakeStart > 0 ? brakeStart : coolStart + 3000) : '';
  const coolSpec = coolBlock.match(/Coolant\s*\n+\s*([^\n]+)/);
  const coolCap = coolBlock.match(/Cooling system\s+([\d.]+)\s*\(l\)/);
  const transTypes = [
    { label: 'Manual transmission', code: 'transmission_mt' },
    { label: 'Automatic transmission', code: 'transmission_at' },
    { label: 'Dual-clutch transmission', code: 'transmission_dct' },
    { label: 'Continuously variable transmission', code: 'transmission_cvt' },
    { label: 'CVT', code: 'transmission_cvt' },
    { label: 'eCVT', code: 'transmission_cvt' },
    { label: 'Hybrid transmission', code: 'transmission_cvt' },
  ];
  const wheelsStart = findSection('Wheels and tyres');
  const acStart = findSection('Air conditioning');
  let firstTransIdx = Infinity, firstTrans = null;
  for (const tt of transTypes) { const idx = findSection(tt.label); if (idx > brakeStart && idx < firstTransIdx) { firstTransIdx = idx; firstTrans = tt; } }
  let transmission = null;
  if (firstTrans) {
    const endIdx = Math.min(wheelsStart > firstTransIdx ? wheelsStart : Infinity, acStart > firstTransIdx ? acStart : Infinity, firstTransIdx + 4000);
    const tblock = after.slice(firstTransIdx, endIdx);
    const tspec = tblock.match(/(?:Gear oil|ATF|CVT fluid|Transmission fluid)(?:\s*\([^)]*\))?\s*\n+\s*([A-Z0-9][^\n]{2,80})/);
    const trefill = tblock.match(/(?:Gearbox refill|Initial filling|Refill capacity|Capacity, refill|Total fill)\s+([\d.]+)\s*\(l\)/);
    transmission = { type: firstTrans.code, label: firstTrans.label, spec: tspec ? tspec[1].trim() : null, capacity_l: trefill ? parseFloat(trefill[1]) : null };
  }
  const brakeEnd = firstTransIdx < Infinity ? firstTransIdx : (wheelsStart > 0 ? wheelsStart : (brakeStart >= 0 ? brakeStart + 3000 : -1));
  const brakeBlock = brakeStart >= 0 ? after.slice(brakeStart, brakeEnd) : '';
  const bSpec = brakeBlock.match(/Brake fluid(?:\s*\([^)]*\))?\s*\n+\s*([A-Z][^\n]{2,80})/);
  const bAlt = brakeBlock.match(/Alternative lubricant specification\)\s*\n+\s*([A-Z][^\n]{2,80})/);
  const brakeCaps = [...brakeBlock.matchAll(/Brake system[^0-9\n]*?([\d.]+)\s*\(l\)/g)].map(m => parseFloat(m[1]));
  return {
    oil: { visc: oilVisc?.[1] ?? null, spec: oilSpec?.[0]?.trim() ?? null, sump_l: oilSump ? parseFloat(oilSump[1]) : null, drain_nm: oilDrain ? parseInt(oilDrain[1], 10) : null },
    coolant: { spec: coolSpec?.[1]?.trim() ?? null, capacity_l: coolCap ? parseFloat(coolCap[1]) : null },
    brake_fluid: { spec: bSpec?.[1]?.trim() ?? null, spec_alt: bAlt?.[1]?.trim() ?? null, capacity_l: brakeCaps.length ? Math.min(...brakeCaps) : null },
    transmission,
  };
}

function parseAdjustmentData(text) {
  // Torque pairs — HaynesPro DOM splits each row across 3-4 lines after
  // .innerText extraction:
  //   <fastener name>             e.g. "Cylinder head bolts"
  //   <qualifier>                 e.g. "(Bolts A)" or "Stage 1" (optional)
  //   <numeric value>             e.g. "30"
  //   "(Nm)"                      unit on its own line
  // So we anchor on "(Nm)" lines, walk backward past qualifiers/numerics, and
  // merge with the nearest plain-text header for full context.
  const torques = [];
  const seen = new Set();
  const lines = text.split('\n').map(l => l.replace(/\s+/g, ' ').trim()).filter(l => l.length > 0);
  // Lines that are bare units (e.g. "(Nm)", "(°)", "(°C)", "(Ah)")
  const UNIT_LINE = /^\(\s*(?:Nm|N\.m|°|°C|°F|Ah|A|l|bar|psi|mm|kPa|mph|km\/h)\s*\)$/i;
  // HaynesPro instruction sub-headers — NOT fastener names. The parser must
  // walk past these to find the real fastener heading above.
  const INSTRUCTION_HEADER = /^(?:Z?Enlarge\b|ZExpand\b|Renew(?:al)?\b|Use\b|Apply\b|Carry out\b|Note\b|Notes?\s*$|Tighten\b|Pre[- ]tighten\b|Loosen\b|Lubric|Final tightening|Initial tightening|Threads? and\b|Important|Caution|Warning|Optional\b|If \w+|Re-?fit\b|Removed\b|Removal\b|Installation\b|Refitting\b)/i;
  const isQualifier = (s) =>
    (/^\(.+\)$/.test(s) && !UNIT_LINE.test(s)) ||
    /^Stage\s+\d+/i.test(s) ||
    /^Step\s+\d+/i.test(s) ||
    /^Angle\b/i.test(s) ||
    /^\+\s*\d+°/.test(s);
  const isHeader = (s) =>
    /^[A-Z]/.test(s) &&
    !isQualifier(s) &&
    !UNIT_LINE.test(s) &&
    !INSTRUCTION_HEADER.test(s) &&
    !/^\d/.test(s) &&
    s.length >= 3 && s.length <= 90 &&
    !/\(Nm\)|\(Ah\)|\(A\)|\(l\)|\(bar\)|\(°C\)|\(mm\)/.test(s);
  for (let i = 0; i < lines.length; i++) {
    if (lines[i] !== '(Nm)') continue;
    const val = lines[i - 1];
    if (!val || !/^\d+$/.test(val)) continue;
    const nm = parseInt(val, 10);
    if (nm <= 0 || nm > 999) continue;
    // Walk back past qualifiers + numeric stages to find the nearest plain header
    const qualifiers = [];
    let j = i - 2;
    let header = null;
    while (j >= 0) {
      const l = lines[j];
      if (isHeader(l)) { header = l; break; }
      if (isQualifier(l)) qualifiers.unshift(l);
      // Skip numeric-only stage values and short connectors
      j--;
      if (qualifiers.length + (i - 1 - j) > 10) break; // safety
    }
    if (!header) continue;
    let fastener = header;
    if (qualifiers.length > 0) {
      // Keep at most 2 qualifiers; drop bare "Stage N" if there's a more
      // specific parenthetical qualifier. Drop overly-long "(Note: …)" or
      // "(Tighten in sequence …)" qualifiers — they're prose, not identity.
      const paren = qualifiers
        .filter(q => /^\(.+\)$/.test(q))
        .filter(q => q.length <= 40)
        .filter(q => !/^\(Note:|^\(Tighten/i.test(q));
      const stage = qualifiers.filter(q => /^Stage\s+\d+/i.test(q));
      const pick = [...paren, ...stage].slice(0, 2);
      if (pick.length) fastener = `${header} ${pick.join(' ')}`;
    }
    fastener = fastener.replace(/\s+/g, ' ').trim();
    // Truncate at last word boundary to avoid mid-word cuts
    if (fastener.length > 64) {
      const slice = fastener.slice(0, 64);
      const lastSp = slice.lastIndexOf(' ');
      fastener = lastSp > 30 ? slice.slice(0, lastSp) : slice;
    }
    if (fastener.length < 4) continue;
    const key = `${fastener}|${nm}`;
    if (seen.has(key)) continue;
    seen.add(key);
    torques.push({ fastener, torque_nm: nm });
  }
  // Battery info
  const electrical = [];
  const reBat = /Equipment code\s+([A-Z0-9, ]+)\s*\n+\s*Battery capacity\s+(\d+)\s*\(Ah\)/g;
  let bm;
  while ((bm = reBat.exec(text)) !== null) {
    const after = text.slice(bm.index, bm.index + 600);
    const cca = after.match(/Cold cranking amperes \(CCA\)[\s\S]+?(\d+)\s*\(A\)/)?.[1];
    const chem = after.match(/(Absorbed glass mat \(AGM\)|Enhanced flooded battery \(EFB\))/)?.[1] ?? null;
    electrical.push({
      equipment_code: bm[1].trim(),
      capacity_ah: parseInt(bm[2], 10),
      cca_din_a: cca ? parseInt(cca, 10) : null,
      chemistry: chem ? (chem.includes('AGM') ? 'AGM' : 'EFB') : null,
    });
  }
  // Wheel alignment
  const alignment = {};
  const toeFront = text.match(/Toe-in, front\s+(\d+°\d+'(?:\s*±\s*\d+°\d+')?)/);
  const toeRear = text.match(/Toe-in, rear\s+(\d+°\d+'(?:\s*±\s*\d+°\d+')?)/);
  const camberFront = text.match(/Camber,\s*front[^-\d]*?(-?\d+°\d+')/);
  const camberRear = text.match(/Camber,\s*rear[^-\d]*?(-?\d+°\d+')/);
  if (toeFront) alignment.toe_front = toeFront[1];
  if (toeRear) alignment.toe_rear = toeRear[1];
  if (camberFront) alignment.camber_front = camberFront[1];
  if (camberRear) alignment.camber_rear = camberRear[1];
  return { torques, electrical, alignment };
}

function parseMaintenanceOverview(html, text) {
  const doc = new DOMParser().parseFromString(html, 'text/html');
  const procedures = Array.from(doc.querySelectorAll('a[href*="storyId="]')).map(a => {
    const href = a.getAttribute('href');
    const storyId = href.match(/storyId=(\d+)/)?.[1] ?? null;
    const subject = href.match(/currentSubject=(\w+)/)?.[1] ?? null;
    const page = href.match(/currentPage=(\w+)/)?.[1] ?? null;
    const title = a.textContent.trim().replace(/\s+/g, ' ');
    return { title, storyId, subject, page };
  }).filter(p => p.storyId && p.title.length > 2 && p.title.length < 200);
  const intervals = Array.from(doc.querySelectorAll('a[href*="maintenanceSchedule"]')).map(a => {
    const href = a.getAttribute('href');
    const ms = href.match(/maintenanceSystemId=(ms_\d+|timing_\d+|service_item_intervals)/)?.[1] ?? null;
    const mp = href.match(/maintenancePeriodId=([\w_]+)/)?.[1] ?? null;
    const label = a.textContent.trim().replace(/\s+/g, ' ');
    return { label, ms, mp };
  }).filter(i => i.ms && i.mp && i.label.length > 2);
  return { procedures, intervals };
}

function parseMaintenanceSchedule(text) {
  return text.split('\n').map(l => l.trim())
    .filter(l => l.length > 5 && l.length < 250)
    .filter(l => /^(Replace|Inspect|Check|Drain|Top.?up|Tighten|Test|Adjust|Reset|Lubricate|Change|Clean|Renew|Refit|Visual|Carry|Perform)\b/i.test(l))
    .map(s => s.replace(/\s+/g, ' '));
}

function parseRepairTimes(text) {
  // Repair times are labelled lines like "Engine oil filter replace  0.3 hr"
  const lines = text.split('\n').map(l => l.trim()).filter(Boolean);
  const items = [];
  for (const ln of lines) {
    const m = ln.match(/^(.{4,80}?)\s+(\d+(?:\.\d+)?)\s*hr$/);
    if (m) items.push({ task: m[1].trim().replace(/\s+/g, ' '), hours: parseFloat(m[2]) });
  }
  return items;
}
