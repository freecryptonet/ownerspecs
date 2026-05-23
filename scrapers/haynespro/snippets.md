# HaynesPro browser_evaluate snippets

One snippet per HaynesPro page. Each is designed to be passed verbatim
to `mcp__playwright__browser_evaluate` after navigating to the page.

The output of each snippet is one section of the unified
`HaynesProVehicleHarvest` JSON shape defined in `types.ts`.

---

## 1. Lubricants page

**Navigate to:** `/touch/site/layout/lubricants?typeId={typeId}&groupId=QUICKGUIDES&altView=true`

**Snippet → `LubricantsBlock`:**

```js
() => {
  const text = document.body.innerText;
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
  // Engine oil block
  const oilBlock = section('Engine oil', 'Cooling system');
  let preferred = null, alternatives = [], current = null;
  if (oilBlock) {
    const lines = oilBlock.split(/\n+/).map(s => s.trim()).filter(Boolean);
    for (const line of lines) {
      const m = line.match(/Engine oil \((Preferred|Alternative) lubricant specification\)/);
      if (m) {
        if (current) {
          (current.kind === 'Preferred' ? (preferred = { viscosity: current.viscosity, spec: current.spec }) : alternatives.push({ viscosity: current.viscosity, spec: current.spec }));
        }
        current = { kind: m[1], viscosity: null, spec: null };
        continue;
      }
      if (current) {
        const v = line.match(/^SAE\s+(\d+W-\d+)/);
        if (v) current.viscosity = v[1];
        else if (/^(BMW|VW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA|GM dexos)/.test(line) && !current.spec) {
          current.spec = line.replace(/All temperatures$/, '').trim();
        }
      }
    }
    if (current) (current.kind === 'Preferred' ? (preferred = { viscosity: current.viscosity, spec: current.spec }) : alternatives.push({ viscosity: current.viscosity, spec: current.spec }));
    // Audi/Mazda format has no Preferred/Alternative labels — first SAE + spec is preferred
    if (!preferred && oilBlock) {
      const v = oilBlock.match(/SAE\s+(\d+W-\d+)/);
      const s = oilBlock.match(/(?:VW|BMW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA)\s+[^\n]+/);
      if (v || s) preferred = { viscosity: v ? v[1] : null, spec: s ? s[0].trim() : null };
    }
  }
  const oilSump = parseCap(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/, oilBlock);
  const oilDrain = parseTorque(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/, oilBlock);
  const oilDrainNote = oilBlock?.match(/Engine oil drain plug\s*\(([^)]+)\)/)?.[1] ?? null;
  // Cooling system block
  const coolBlock = section('Cooling system', 'Brake system');
  const coolSpec = coolBlock?.match(/Coolant\s*\n+\s*([^\n]+)/)?.[1] ?? null;
  const coolCap = parseCap(/Cooling system\s+([\d.]+)\s*\(l\)/, coolBlock);
  const frost = [];
  if (coolBlock) {
    const fre = /De-ionised water with (\d+%) anti-freeze[^\n]*\n[^\n]*?(-?\d+)?\s*°C/g;
    let fm;
    while ((fm = fre.exec(coolBlock)) !== null) frost.push({ antifreeze_pct: fm[1], min_temp_c: fm[2] ? parseInt(fm[2], 10) : null });
  }
  // Brake fluid block
  const brakeBlock = section('Brake system', 'transmission,');
  const brakePref = brakeBlock?.match(/Brake fluid \(Preferred lubricant specification\)\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? brakeBlock?.match(/Brake fluid\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? null;
  const brakeAlt = brakeBlock?.match(/Brake fluid \(Alternative lubricant specification\)\s*\n+\s*([^\n]+)/)?.[1]?.trim() ?? null;
  const brakeAt = parseCap(/Brake system\s*\(Automatic transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeDct = parseCap(/Brake system\s*\(Dual-clutch transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeMt = parseCap(/Brake system\s*\(Manual transmission\)\s+([\d.]+)\s*\(l\)/, brakeBlock);
  const brakeAny = parseCap(/Brake system(?:\s*\([^)]*\))?\s+([\d.]+)\s*\(l\)/, brakeBlock);
  // A/C refrigerant
  const acBlock = section('Refrigerant', 'Compressor oil');
  const acType = acBlock?.match(/R1234yf|R134a/)?.[0] ?? null;
  const acG = acBlock?.match(/Refrigerant\s+(\d+)\s*(?:±\s*(\d+))?\s*\(g\)/);
  return {
    engine_oil: {
      preferred,
      alternatives,
      sump_l: oilSump,
      drain_nm: oilDrain,
      drain_note: oilDrainNote,
    },
    coolant: coolSpec || coolCap ? {
      spec: coolSpec,
      capacity_l: coolCap,
      frost_protection: frost,
    } : null,
    brake_fluid: brakePref || brakeAny ? {
      preferred_spec: brakePref,
      alternative_spec: brakeAlt,
      capacity_at_l: brakeAt ?? brakeAny,
      capacity_dct_l: brakeDct,
      capacity_mt_l: brakeMt,
    } : null,
    ac_refrigerant: acType ? {
      type: acType,
      grams: acG ? parseInt(acG[1], 10) : null,
      tolerance_g: acG && acG[2] ? parseInt(acG[2], 10) : null,
      compressor_oil_spec: null,  // separate block; lower priority
      compressor_oil_ml: null,
    } : null,
    // Transmissions + diffs are present in lubricants but parsing them requires
    // per-vehicle context (manual vs DCT vs ZF code). Left for v2; fallback:
    transmission_at: null,
    transmission_dct: null,
    transmission_mt: null,
    transfer_case: null,
    front_differential: null,
    rear_differential: null,
    haldex: null,
  };
}
```

---

## 2. Adjustment Data page

**Navigate to:** `/touch/site/layout/adjustmentData?typeId={typeId}&groupId=QUICKGUIDES&fromOverview=true`

**Snippet → `AdjustmentDataBlock`:**

```js
() => {
  const text = document.body.innerText;
  const section = (start, end) => {
    const a = text.indexOf(start);
    if (a < 0) return null;
    const b = end ? text.indexOf(end, a + start.length) : -1;
    return text.slice(a, b > 0 ? b : a + 5000);
  };
  const num = (re, block) => { if (!block) return null; const m = block.match(re); return m ? parseFloat(m[1]) : null; };
  // Engine
  const engBlock = section('Engine (general)', 'Engine (specifications)');
  const code = engBlock?.match(/Engine code\s+([A-Z0-9-]+)/)?.[1] ?? null;
  const cc = num(/Capacity\s+(\d+)\s*\(cc\)/, engBlock);
  const cyl = num(/Number of cylinders\s+(\d+)/, engBlock);
  const vpc = num(/Valves per cylinder\s+(\d+)/, engBlock);
  const dist = engBlock?.match(/Distribution type\s+([^\n]+)/)?.[1]?.trim() ?? null;
  const engSpec = section('Engine (specifications)', 'Cooling system');
  const valveClr = engSpec?.match(/Valve clearance\s+(\w+)/)?.[1] ?? null;
  const plugs = num(/Number of spark plugs\s+(\d+)/, engSpec);
  const cpNorm = engSpec?.match(/Normal pressure\s+([\d.\- ]+)\s*\(bar\)/)?.[1]?.trim() ?? null;
  const cpMin = num(/Minimum pressure\s+([\d.]+)\s*\(bar\)/, engSpec);
  const cpDiff = num(/pressure difference[^.]+?([\d.]+)\s*\(bar\)/, engSpec);
  const opIdle = engSpec?.match(/Oil pressure at idle speed[\s\S]{0,80}([><=]\s*[\d.]+)/)?.[1] ?? null;
  const opRun = engSpec?.match(/Oil pressure[\s\S]{0,100}([><=]\s*[\d.]+\/\d+)/)?.[1] ?? null;
  const distortion = num(/Maximum cylinder head distortion\s+([\d.]+)\s*\(mm\)/, engSpec);
  // Cooling system caps
  const coolSpec = section('Cooling system', 'Electrical');
  const capBlue = coolSpec?.match(/\(Blue cap\)\s*([\d.\- ]+)\s*\(bar\)/)?.[1]?.trim() ?? null;
  const capBlack = coolSpec?.match(/\(Black cap\)\s*([\d.\- ]+)\s*\(bar\)/)?.[1]?.trim() ?? null;
  // Electrical — multiple batteries per equipment code
  const elBlock = section('Electrical', 'Brakes');
  const batteries = [];
  if (elBlock) {
    const reCode = /Equipment code\s+([A-Z0-9, ]+)\s*\n+\s*Battery capacity\s+(\d+)\s*\(Ah\)/g;
    let bm;
    while ((bm = reCode.exec(elBlock)) !== null) {
      // Look ahead for CCA + chemistry
      const after = elBlock.slice(bm.index, bm.index + 600);
      const cca = after.match(/Cold cranking amperes \(CCA\)[\s\S]+?(\d+)\s*\(A\)/)?.[1];
      const chem = after.match(/(Absorbed glass mat \(AGM\)|Enhanced flooded battery \(EFB\))/)?.[1] ?? null;
      batteries.push({
        equipment_code: bm[1].trim(),
        capacity_ah: parseInt(bm[2], 10),
        cca_din_a: cca ? parseInt(cca, 10) : null,
        chemistry: chem ? (chem.includes('AGM') ? 'AGM' : 'EFB') : null,
        jump_start_terminal_location: null,
        high_voltage_battery_location: null,
      });
    }
  }
  // Brakes
  const brakeSpec = section('Brakes', 'Steering, suspension');
  const fronts = [], rears = [];
  if (brakeSpec) {
    const reFront = /Front disc brakes,? Equipment code\s+\(?([A-Z0-9, ]+)\)?\s*\n[\s\S]*?Disc diameter, front\s+([\d.]+)\s*\(mm\)\s*\n[\s\S]*?Disc thickness, front\s+([\d.]+)\s*\(mm\)(?:\s*\n[\s\S]*?Disc thickness, front, minimum\s*\n*\s*\(.*?\)?([\d.]+)\s*\(mm\))?/g;
    let fm;
    while ((fm = reFront.exec(brakeSpec)) !== null) fronts.push({
      equipment_code: fm[1].trim(),
      disc_diameter_mm: parseFloat(fm[2]),
      disc_thickness_mm: parseFloat(fm[3]),
      disc_thickness_min_mm: fm[4] ? parseFloat(fm[4]) : null,
      pad_thickness_min_mm: null,
      disc_runout_max_mm: null,
    });
    const reRear = /Rear disc brakes,? Equipment code\s+\(?([A-Z0-9, ]+)\)?\s*\n[\s\S]*?Disc diameter, rear\s+([\d.]+)\s*\(mm\)\s*\n[\s\S]*?Disc thickness, rear\s+([\d.]+)\s*\(mm\)/g;
    let rm;
    while ((rm = reRear.exec(brakeSpec)) !== null) rears.push({
      equipment_code: rm[1].trim(),
      disc_diameter_mm: parseFloat(rm[2]),
      disc_thickness_mm: parseFloat(rm[3]),
      disc_thickness_min_mm: null,
      pad_thickness_min_mm: null,
      disc_runout_max_mm: null,
    });
  }
  // Torque settings — wheel bolts is the easy one
  const torqueSection = text.indexOf('Torque settings');
  const torqueBlock = torqueSection >= 0 ? text.slice(torqueSection) : null;
  const wheelTorque = torqueBlock ? num(/Wheel bolts\s+(\d+)\s*\(Nm\)/, torqueBlock) : null;
  // Other torque rows would need per-section parsing — v2.
  return {
    engine: code ? { code, capacity_cc: cc, distribution_type: dist, cylinders: cyl, valves_per_cyl: vpc, valve_clearance: valveClr, spark_plugs: plugs, compression_normal_bar: cpNorm, compression_min_bar: cpMin, compression_diff_max_bar: cpDiff, oil_pressure_idle_bar: opIdle, oil_pressure_run_bar_rpm: opRun, max_cylhead_distortion_mm: distortion } : null,
    cooling: capBlue || capBlack ? { cap_pressure_blue_bar: capBlue, cap_pressure_black_bar: capBlack, cap_pressure_other_bar: null } : null,
    electrical: batteries.length > 0 ? { batteries } : null,
    brakes: fronts.length || rears.length ? { front: fronts, rear: rears } : null,
    suspension: null,  // v2 — alignment rows are long, defer
    wheels_tyres: null,  // v2 — needs more layout work
    torque_settings: wheelTorque != null ? { engine: [], brakes_front: [], brakes_rear: [], transmission: [], suspension: [], wheels: { fastener: 'Wheel bolts', torque_nm: wheelTorque, torque_nm_max: null, stage: null, notes: null }, steering: [], ac: [] } : null,
  };
}
```

---

## 3. Maintenance category — procedure inventory

**Navigate to:** `/touch/site/layout/modelDetailMaintenance?typeId={typeId}&currentSubject=MAINTENANCE`

**Snippet → `MaintenanceProcedure[]`:**

```js
() => {
  // Wait for hydration if needed before calling
  const items = Array.from(document.querySelectorAll('a[href*="/repairManuals?"]'));
  const seen = new Set();
  const out = [];
  for (const a of items) {
    const href = a.getAttribute('href');
    if (!href || seen.has(href)) continue;
    seen.add(href);
    const title = (a.textContent || '').trim().replace(/\s+/g, ' ');
    if (!title) continue;
    const storyId = href.match(/storyId=(\d+)/)?.[1] ?? null;
    const group = href.match(/groupId=([A-Z_]+)/)?.[1] ?? null;
    const page = href.match(/currentPage=([A-Z_]+)/)?.[1] ?? null;
    out.push({
      story_id: storyId,
      title,
      group: page || group,
      url: location.origin + href,
    });
  }
  return out;
}
```

---

## Combine into a single harvest

After running all 3 snippets for a given typeId, write the unified JSON
to `scrapers/output/haynespro-vehicle-{typeId}.json` with this shape:

```json
{
  "engine_code": "DMTA",
  "typeId": "t_619035648",
  "modelId": "d_319001693",
  "vehicle_label": "Audi A6/-Allroad (4A) 45 TFSI (DMTA) 2021 - ...",
  "years": "2021 - ...",
  "fetched_at": "2026-05-23T05:50:00Z",
  "source_urls": {
    "lubricants": "https://www.workshopdata.com/touch/site/layout/lubricants?typeId=t_619035648&...",
    "adjustment_data": "https://www.workshopdata.com/touch/site/layout/adjustmentData?typeId=t_619035648&...",
    "maintenance": "https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_619035648&..."
  },
  "lubricants": { ... },
  "adjustment_data": { ... },
  "procedures": [ ... ]
}
```

The `harvest_vehicle.md` workflow chains all three navigations + extractions.
