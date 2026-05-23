/**
 * HaynesPro chassis-level crawler.
 *
 * Runs IN THE BROWSER via Playwright's browser_evaluate. The page must
 * already be on workshopdata.com so document.cookie + session is valid
 * for in-page fetch() calls.
 *
 * USAGE
 * -----
 * Navigate Playwright to any workshopdata.com page (e.g. makesOverview).
 * Then run:
 *
 *   const out = await browser_evaluate({
 *     function: `() => { ${crawlChassisJs}; return crawlChassis('d_319001693'); }`
 *   });
 *
 * Where `crawlChassisJs` is the contents of THIS file (without the
 * top-level comment block). The function returns:
 *
 *   {
 *     chassis: { modelId, label, engines_count, fetched_at },
 *     types: [
 *       {
 *         typeId, type, engine_code, displacement_cc, kw, years,
 *         lubricants: { ... LubricantsBlock ... } | null,
 *         adjustment_data: { ... AdjustmentDataBlock ... } | null,
 *         errors: [],
 *       },
 *       ...
 *     ],
 *     duration_ms,
 *   }
 *
 * Caller writes the returned object to
 * scrapers/output/haynespro-crawl/{chassis-slug}.json.
 *
 * RATE LIMITING
 * -------------
 * 3 seconds between requests to workshopdata.com (polite — slightly
 * faster than the 4s used elsewhere because in-page fetches don't
 * carry the full page render overhead).
 */

async function crawlChassis(modelId, options = {}) {
  const t0 = Date.now();
  const throttleMs = options.throttleMs ?? 3000;
  const log = (...a) => console.log('[crawl]', ...a);

  // Step 1 — modelTypesList: list all engines on this chassis
  const tlUrl = `/touch/site/layout/modelTypesList?modelId=${encodeURIComponent(modelId)}`;
  const tlRes = await fetch(tlUrl, { credentials: 'include' });
  if (!tlRes.ok) return { error: `modelTypesList ${tlRes.status}`, modelId };
  const tlHtml = await tlRes.text();
  const tlDoc = new DOMParser().parseFromString(tlHtml, 'text/html');
  const chassisLabel = tlDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
  const typeRows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]')).map(r => {
    const cells = Array.from(r.querySelectorAll('td')).map(td => td.textContent.trim().replace(/\s+/g, ' '));
    return {
      typeId: r.getAttribute('data-typeid'),
      type: cells[0] ?? null,
      engine_code: cells[1] ?? null,
      displacement_cc: cells[2] ? parseInt(cells[2], 10) : null,
      kw: cells[3] ? parseInt(cells[3], 10) : null,
      years: cells[4] ?? null,
    };
  });
  log(`chassis ${modelId}: ${typeRows.length} engines`);

  // Step 2 — for each typeId, fetch lubricants + adjustmentData
  const types = [];
  for (let i = 0; i < typeRows.length; i++) {
    const row = typeRows[i];
    const errors = [];
    let lubricants = null;
    let adjustment_data = null;
    try {
      await new Promise(r => setTimeout(r, throttleMs));
      const lubUrl = `/touch/site/layout/lubricants?typeId=${row.typeId}&groupId=QUICKGUIDES&altView=true`;
      const lubRes = await fetch(lubUrl, { credentials: 'include' });
      if (lubRes.ok) {
        const html = await lubRes.text();
        const doc = new DOMParser().parseFromString(html, 'text/html');
        lubricants = parseLubricants(doc.body?.innerText ?? '');
      } else errors.push(`lubricants ${lubRes.status}`);
    } catch (e) { errors.push(`lubricants ${e.message}`); }
    try {
      await new Promise(r => setTimeout(r, throttleMs));
      const adjUrl = `/touch/site/layout/adjustmentData?typeId=${row.typeId}&groupId=QUICKGUIDES&fromOverview=true`;
      const adjRes = await fetch(adjUrl, { credentials: 'include' });
      if (adjRes.ok) {
        const html = await adjRes.text();
        const doc = new DOMParser().parseFromString(html, 'text/html');
        adjustment_data = parseAdjustmentData(doc.body?.innerText ?? '');
      } else errors.push(`adjustmentData ${adjRes.status}`);
    } catch (e) { errors.push(`adjustmentData ${e.message}`); }
    types.push({ ...row, lubricants, adjustment_data, errors });
    log(`  [${i+1}/${typeRows.length}] ${row.engine_code} ${row.type}: ${errors.length === 0 ? 'OK' : 'errors=' + errors.length}`);
  }

  return {
    chassis: { modelId, label: chassisLabel, engines_count: typeRows.length, fetched_at: new Date().toISOString() },
    types,
    duration_ms: Date.now() - t0,
  };
}

// ---------- Parsers (same as snippets.md, hoisted into one function) ----------

function parseLubricants(text) {
  const country = text.indexOf('Filter by country');
  const after = country >= 0 ? text.slice(country) : text;
  const section = (start, end) => {
    const a = after.indexOf(start);
    if (a < 0) return null;
    const b = end ? after.indexOf(end, a + start.length) : -1;
    return after.slice(a, b > 0 ? b : a + 5000);
  };
  const parseCap = (re, block) => { if (!block) return null; const m = block.match(re); return m ? parseFloat(m[1]) : null; };
  const parseTorque = (re, block) => { if (!block) return null; const m = block.match(re); return m ? parseInt(m[1], 10) : null; };
  const oilBlock = section('Engine oil', 'Cooling system');
  let preferred = null, alternatives = [], current = null;
  if (oilBlock) {
    const lines = oilBlock.split(/\n+/).map(s => s.trim()).filter(Boolean);
    for (const line of lines) {
      const m = line.match(/Engine oil \((Preferred|Alternative) lubricant specification\)/);
      if (m) {
        if (current) (current.kind === 'Preferred' ? (preferred = { viscosity: current.viscosity, spec: current.spec }) : alternatives.push({ viscosity: current.viscosity, spec: current.spec }));
        current = { kind: m[1], viscosity: null, spec: null };
        continue;
      }
      if (current) {
        const v = line.match(/^SAE\s+(\d+W-\d+)/);
        if (v) current.viscosity = v[1];
        else if (/^(BMW|VW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA|JASO|Nissan|Hyundai|Kia|Stellantis)/.test(line) && !current.spec) {
          current.spec = line.replace(/All temperatures$/, '').trim();
        }
      }
    }
    if (current) (current.kind === 'Preferred' ? (preferred = { viscosity: current.viscosity, spec: current.spec }) : alternatives.push({ viscosity: current.viscosity, spec: current.spec }));
    if (!preferred && oilBlock) {
      const v = oilBlock.match(/SAE\s+(\d+W-\d+)/);
      const s = oilBlock.match(/(?:VW|BMW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA|JASO|Nissan|Hyundai|Kia)[^\n]+/);
      if (v || s) preferred = { viscosity: v ? v[1] : null, spec: s ? s[0].trim() : null };
    }
  }
  const oilSump = parseCap(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/, oilBlock);
  const oilDrain = parseTorque(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/, oilBlock);
  const oilDrainNote = oilBlock?.match(/Engine oil drain plug\s*\(([^)]+)\)/)?.[1] ?? null;
  const coolBlock = section('Cooling system', 'Brake system');
  const coolSpec = coolBlock?.match(/Coolant\s*\n+\s*([^\n]+)/)?.[1] ?? null;
  const coolCap = parseCap(/Cooling system\s+([\d.]+)\s*\(l\)/, coolBlock);
  const brakeBlock = section('Brake system', 'transmission,');
  const brakePref = brakeBlock?.match(/Brake fluid \(Preferred lubricant specification\)\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? brakeBlock?.match(/Brake fluid\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? null;
  const brakeAlt = brakeBlock?.match(/Brake fluid \(Alternative lubricant specification\)\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? null;
  const brakeAt = parseCap(/Brake system\s*\(Automatic transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeDct = parseCap(/Brake system\s*\(Dual-clutch transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeMt = parseCap(/Brake system\s*\(Manual transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeAny = parseCap(/Brake system(?:\s*\([^)]*\))?\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const acBlock = section('Refrigerant', 'Compressor oil');
  const acType = acBlock?.match(/R1234yf|R134a/)?.[0] ?? null;
  const acG = acBlock?.match(/Refrigerant\s+(\d+)\s*(?:±\s*(\d+))?\s*\(g\)/);
  return {
    engine_oil: { preferred, alternatives, sump_l: oilSump, drain_nm: oilDrain, drain_note: oilDrainNote },
    coolant: (coolSpec || coolCap) ? { spec: coolSpec, capacity_l: coolCap } : null,
    brake_fluid: (brakePref || brakeAny) ? { preferred_spec: brakePref, alternative_spec: brakeAlt, capacity_at_l: brakeAt ?? brakeAny, capacity_dct_l: brakeDct, capacity_mt_l: brakeMt } : null,
    ac_refrigerant: acType ? { type: acType, grams: acG ? parseInt(acG[1], 10) : null, tolerance_g: acG && acG[2] ? parseInt(acG[2], 10) : null } : null,
  };
}

function parseAdjustmentData(text) {
  const section = (start, end) => {
    const a = text.indexOf(start);
    if (a < 0) return null;
    const b = end ? text.indexOf(end, a + start.length) : -1;
    return text.slice(a, b > 0 ? b : a + 5000);
  };
  const num = (re, block) => { if (!block) return null; const m = block.match(re); return m ? parseFloat(m[1]) : null; };
  const engBlock = section('Engine (general)', 'Engine (specifications)');
  const code = engBlock?.match(/Engine code\s+([A-Z0-9-]+)/)?.[1] ?? null;
  const cc = num(/Capacity\s+(\d+)\s*\(cc\)/, engBlock);
  const cyl = num(/Number of cylinders\s+(\d+)/, engBlock);
  const vpc = num(/Valves per cylinder\s+(\d+)/, engBlock);
  const dist = engBlock?.match(/Distribution type\s+([^\n]+)/)?.[1]?.trim() ?? null;
  const elBlock = section('Electrical', 'Brakes');
  const batteries = [];
  if (elBlock) {
    const reCode = /Equipment code\s+([A-Z0-9, ]+)\s*\n+\s*Battery capacity\s+(\d+)\s*\(Ah\)/g;
    let bm;
    while ((bm = reCode.exec(elBlock)) !== null) {
      const after2 = elBlock.slice(bm.index, bm.index + 600);
      const cca = after2.match(/Cold cranking amperes \(CCA\)[\s\S]+?(\d+)\s*\(A\)/)?.[1];
      const chem = after2.match(/(Absorbed glass mat \(AGM\)|Enhanced flooded battery \(EFB\))/)?.[1] ?? null;
      batteries.push({
        equipment_code: bm[1].trim(),
        capacity_ah: parseInt(bm[2], 10),
        cca_din_a: cca ? parseInt(cca, 10) : null,
        chemistry: chem ? (chem.includes('AGM') ? 'AGM' : 'EFB') : null,
      });
    }
  }
  const torqueSection = text.indexOf('Torque settings');
  const torqueBlock = torqueSection >= 0 ? text.slice(torqueSection) : null;
  const wheelTorque = torqueBlock ? num(/Wheel bolts\s+(\d+)\s*\(Nm\)/, torqueBlock) : null;
  return {
    engine: code ? { code, capacity_cc: cc, distribution_type: dist, cylinders: cyl, valves_per_cyl: vpc } : null,
    electrical: batteries.length > 0 ? { batteries } : null,
    torque_settings: wheelTorque != null ? { wheel_bolts_nm: wheelTorque } : null,
  };
}

// ---------- exports for use via Function('return crawlChassis') pattern ----------
// (When eval'd in browser, the functions above are in scope.)
