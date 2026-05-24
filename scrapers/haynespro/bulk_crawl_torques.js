/**
 * Bulk Phase C-1 crawler — torques + electrical for every chassis in
 * chassis_registry.json. Skips per-(ms,mp) maintenanceSchedule fetches
 * (deferred to Phase C-2) so each chassis is ~5-15 sec instead of ~45 sec.
 *
 * Run via Playwright browser_evaluate on an authenticated workshopdata.com
 * tab. Each invocation processes ONE chassis (modelId arg).
 *
 *   const result = await browser_evaluate({
 *     function: `() => { ${bulk_crawl_torques.js content}; return crawlChassisTorques('d_317000026', { throttleMs: 400 }); }`
 *   });
 *
 * Returns:
 *   {
 *     modelId, label, engines_count,
 *     uniqueTorques: N,
 *     uniqueElectrical: N,
 *     torques: [{ fastener, torque_nm }],   // deduped across typeIds
 *     electrical: [{ equipment_code, capacity_ah, cca_din_a, chemistry }],
 *   }
 */

async function crawlChassisTorques(modelId, opts = {}) {
  const throttleMs = opts.throttleMs ?? 400;
  const sleep = ms => new Promise(r => setTimeout(r, ms));

  const UNIT_LINE = /^\(\s*(?:Nm|N\.m|°|°C|°F|Ah|A|l|bar|psi|mm|kPa|mph|km\/h)\s*\)$/i;
  const INSTRUCTION_HEADER = /^(?:Z?Enlarge\b|ZExpand\b|Renew(?:al)?\b|Use\b|Apply\b|Carry out\b|Note\b|Notes?\s*$|Tighten\b|Pre[- ]tighten\b|Loosen\b|Lubric|Final tightening|Initial tightening|Threads? and\b|Important|Caution|Warning|Optional\b|If \w+|Re-?fit\b|Removed\b|Removal\b|Installation\b|Refitting\b)/i;
  const isQualifier = (s) =>
    (/^\(.+\)$/.test(s) && !UNIT_LINE.test(s)) ||
    /^Stage\s+\d+/i.test(s) || /^Step\s+\d+/i.test(s) || /^Angle\b/i.test(s) || /^\+\s*\d+°/.test(s);
  const isHeader = (s) =>
    /^[A-Z]/.test(s) && !isQualifier(s) && !UNIT_LINE.test(s) && !INSTRUCTION_HEADER.test(s) &&
    !/^\d/.test(s) && s.length >= 3 && s.length <= 90 &&
    !/\(Nm\)|\(Ah\)|\(A\)|\(l\)|\(bar\)|\(°C\)|\(mm\)/.test(s);

  function parseTorques(text) {
    const torques = [];
    const seen = new Set();
    const lines = text.split('\n').map(l => l.replace(/\s+/g, ' ').trim()).filter(l => l.length > 0);
    for (let i = 0; i < lines.length; i++) {
      if (lines[i] !== '(Nm)') continue;
      const val = lines[i-1];
      if (!val || !/^\d+$/.test(val)) continue;
      const nm = parseInt(val, 10);
      if (nm <= 0 || nm > 999) continue;
      const qualifiers = [];
      let j = i - 2, header = null;
      while (j >= 0) {
        const l = lines[j];
        if (isHeader(l)) { header = l; break; }
        if (isQualifier(l)) qualifiers.unshift(l);
        j--;
        if (qualifiers.length + (i - 1 - j) > 12) break;
      }
      if (!header) continue;
      let fastener = header;
      if (qualifiers.length > 0) {
        const paren = qualifiers.filter(q => /^\(.+\)$/.test(q)).filter(q => q.length <= 40).filter(q => !/^\(Note:|^\(Tighten/i.test(q));
        const stage = qualifiers.filter(q => /^Stage\s+\d+/i.test(q));
        const pick = [...paren, ...stage].slice(0, 2);
        if (pick.length) fastener = `${header} ${pick.join(' ')}`;
      }
      fastener = fastener.replace(/\s+/g, ' ').trim();
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
    return torques;
  }

  function parseElectrical(text) {
    const electrical = [];
    const reBat = /Equipment code\s+([A-Z0-9, ]+)\s*\n+\s*Battery capacity\s+(\d+)\s*\(Ah\)/g;
    let bm;
    while ((bm = reBat.exec(text)) !== null) {
      const after = text.slice(bm.index, bm.index + 600);
      const cca = after.match(/Cold cranking amperes \(CCA\)[\s\S]+?(\d+)\s*\(A\)/)?.[1];
      const chem = after.match(/(Absorbed glass mat \(AGM\)|Enhanced flooded battery \(EFB\))/)?.[1] ?? null;
      electrical.push({
        equipment_code: bm[1].trim().slice(0, 24),
        capacity_ah: parseInt(bm[2], 10),
        cca_din_a: cca ? parseInt(cca, 10) : null,
        chemistry: chem ? (chem.includes('AGM') ? 'AGM' : 'EFB') : null,
      });
    }
    return electrical;
  }

  // 1. modelTypesList
  let tlHtml;
  try {
    tlHtml = await fetch(`/touch/site/layout/modelTypesList?modelId=${encodeURIComponent(modelId)}`, {credentials:'include'}).then(r=>r.text());
  } catch (e) { return { modelId, error: 'modelTypesList ' + e.message }; }
  const tlDoc = new DOMParser().parseFromString(tlHtml, 'text/html');
  const chassisLabel = tlDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
  const rows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]')).map(r => r.getAttribute('data-typeid'));

  // 2. adjustmentData per typeId — aggregate torques + electrical
  const torquesMap = new Map();
  const electricalMap = new Map();
  let errors = 0;
  for (const typeId of rows) {
    await sleep(throttleMs);
    try {
      const html = await fetch(`/touch/site/layout/adjustmentData?typeId=${typeId}&groupId=QUICKGUIDES&fromOverview=true`, {credentials:'include'}).then(r=>r.text());
      const doc = new DOMParser().parseFromString(html, 'text/html');
      const text = doc.body?.innerText ?? '';
      for (const t of parseTorques(text)) {
        const k = `${t.fastener}|${t.torque_nm}`;
        if (!torquesMap.has(k)) torquesMap.set(k, t);
      }
      for (const e of parseElectrical(text)) {
        if (!electricalMap.has(e.equipment_code)) electricalMap.set(e.equipment_code, e);
      }
    } catch (e) {
      errors++;
    }
  }

  return {
    modelId,
    label: chassisLabel,
    engines_count: rows.length,
    errors,
    uniqueTorques: torquesMap.size,
    uniqueElectrical: electricalMap.size,
    torques: [...torquesMap.values()],
    electrical: [...electricalMap.values()],
  };
}
