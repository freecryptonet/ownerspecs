/**
 * HaynesPro brand-level discovery walker.
 *
 * Runs IN THE BROWSER via Playwright browser_evaluate. Walks one make
 * (Audi, BMW, Toyota, etc.) and returns the full tree of model groups
 * and chassis modelIds. Output is a flat list that the chassis crawler
 * can iterate over.
 *
 * USAGE
 * -----
 * 1. Navigate Playwright to any workshopdata.com page.
 * 2. Run:
 *      browser_evaluate({ function: `async () => { ${this file body}; return discoverBrand('m_120'); }` })
 *
 * The function returns:
 *   {
 *     makeId: 'm_120',
 *     make_label: 'AUDI',
 *     fetched_at: '...',
 *     duration_ms: ...,
 *     model_groups: [
 *       {
 *         modelGroupId: 'dg_1000475',
 *         model_label: 'A6 1997 - ...',
 *         chassis: [
 *           { modelId: 'd_319001693', label: 'A6 /-Allroad (4A) 2019 - ...' },
 *           { modelId: 'd_319001371', label: 'A6 /-Allroad (4G) 2011 - 2018' },
 *           ...
 *         ]
 *       },
 *       ...
 *     ]
 *   }
 *
 * Caller saves to scrapers/output/haynespro-discovery-{brand}.json.
 *
 * Performance: each brand = ~1-2 seconds for the model list +
 * ~0.5s per model group for the chassis list. Full Audi discovery
 * (~12 model groups) = ~10 seconds.
 */

async function discoverBrand(makeId, options = {}) {
  const t0 = Date.now();
  const throttleMs = options.throttleMs ?? 500;

  // Step 1 — get all model groups under this make
  const moRes = await fetch(`/touch/site/layout/modelOverview?makeId=${encodeURIComponent(makeId)}`, { credentials: 'include' });
  if (!moRes.ok) return { error: `modelOverview ${moRes.status}`, makeId };
  const moDoc = new DOMParser().parseFromString(await moRes.text(), 'text/html');
  const makeLabel = moDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
  const groupLinks = Array.from(moDoc.querySelectorAll('a[href*="modelGroupId="]'))
    .map(a => ({
      modelGroupId: a.getAttribute('href').match(/modelGroupId=(dg_\d+)/)?.[1],
      model_label: a.textContent.trim().replace(/\s+/g, ' '),
    }))
    .filter(g => g.modelGroupId);
  // Dedupe by modelGroupId
  const seen = new Set();
  const uniqueGroups = groupLinks.filter(g => seen.has(g.modelGroupId) ? false : (seen.add(g.modelGroupId), true));

  // Step 2 — for each model group, get all chassis modelIds
  const model_groups = [];
  for (const g of uniqueGroups) {
    await new Promise(s => setTimeout(s, throttleMs));
    try {
      const gtRes = await fetch(`/touch/site/layout/modelTypes?modelGroupId=${g.modelGroupId}&makeId=${makeId}`, { credentials: 'include' });
      if (!gtRes.ok) {
        model_groups.push({ ...g, error: `modelTypes ${gtRes.status}`, chassis: [] });
        continue;
      }
      const gtDoc = new DOMParser().parseFromString(await gtRes.text(), 'text/html');
      const chassis = Array.from(gtDoc.querySelectorAll('a[data-model-id]'))
        .map(a => ({
          modelId: a.getAttribute('data-model-id'),
          label: a.textContent.trim().replace(/\s+/g, ' '),
        }));
      model_groups.push({ ...g, chassis });
    } catch (e) {
      model_groups.push({ ...g, error: e.message, chassis: [] });
    }
  }

  return {
    makeId,
    make_label: makeLabel,
    fetched_at: new Date().toISOString(),
    duration_ms: Date.now() - t0,
    model_groups_count: model_groups.length,
    total_chassis: model_groups.reduce((n, g) => n + (g.chassis?.length ?? 0), 0),
    model_groups,
  };
}
