/**
 * URL discovery: given a single starting page on auto-data.net or
 * ultimatespecs.com, enumerate the trim URLs underneath it.
 *
 * Both sites have a hierarchy of index pages. The simplest entry point for
 * ours is a generation page — we list every link that follows the trim URL
 * pattern and return them. Caller can then fan out to ingest each one.
 *
 * Auto-data generation URL pattern:
 *   /en/{brand}-{model}-{body}-{codename}-generation-{id}
 * Trim URL pattern (links from generation page):
 *   /en/{brand}-{model}-{body}-{codename}-{powertrain}-{N}hp-{trans}-{numeric-id}
 *
 * Ultimatespecs generation URL pattern:
 *   /car-specs/{Brand}/{M-id}/{Codename}-{Model}
 * Trim URL pattern:
 *   /car-specs/{Brand}/{trim-numeric}/{Brand}-{Codename}-{Model}-{trim}.html
 *
 * The discoverer is deliberately narrow: it returns a flat list of trim URLs
 * found on the input page, with light filtering. The orchestrator decides
 * which to fetch and how to pair them across sources.
 */
import * as cheerio from "cheerio";
import { fetchHtml, log } from "./lib.js";

export type DiscoveredTrim = {
  source: "auto-data.net" | "ultimatespecs.com";
  url: string;
  label: string;
};

const AD_TRIM_PATTERN = /^https?:\/\/(www\.)?auto-data\.net\/en\/[a-z0-9-]+-\d+$/i;
const US_TRIM_PATTERN =
  /^https?:\/\/(www\.)?ultimatespecs\.com\/car-specs\/[^/]+\/\d+\/[^/]+\.html$/i;

function abs(base: string, href: string): string | null {
  try {
    return new URL(href, base).toString();
  } catch {
    return null;
  }
}

/** Auto-data generation page → list of trim URLs. */
export async function discoverAutoDataTrims(generationUrl: string): Promise<DiscoveredTrim[]> {
  log("discover", `auto-data GET ${generationUrl}`);
  const html = await fetchHtml(generationUrl);
  const $ = cheerio.load(html);

  const seen = new Set<string>();
  const out: DiscoveredTrim[] = [];
  $("a[href]").each((_, a) => {
    const href = $(a).attr("href") || "";
    const full = abs(generationUrl, href);
    if (!full) return;
    // Reject anything that's not a trim leaf — must end with numeric id and not
    // be a brand/model/generation index page (those have "-brand-", "-model-",
    // or "-generation-" before the numeric).
    if (!AD_TRIM_PATTERN.test(full)) return;
    if (/-(brand|model|generation)-\d+$/.test(full)) return;
    if (seen.has(full)) return;
    seen.add(full);
    const label = $(a).text().replace(/\s+/g, " ").trim();
    out.push({ source: "auto-data.net", url: full, label });
  });

  log("discover", `auto-data found ${out.length} trim URLs`);
  return out;
}

/** Ultimatespecs generation page → list of trim URLs. */
export async function discoverUltimateSpecsTrims(
  generationUrl: string,
): Promise<DiscoveredTrim[]> {
  log("discover", `ultimatespecs GET ${generationUrl}`);
  const html = await fetchHtml(generationUrl);
  const $ = cheerio.load(html);

  const seen = new Set<string>();
  const out: DiscoveredTrim[] = [];
  $("a[href]").each((_, a) => {
    const href = $(a).attr("href") || "";
    const full = abs(generationUrl, href);
    if (!full) return;
    if (!US_TRIM_PATTERN.test(full)) return;
    if (seen.has(full)) return;
    seen.add(full);
    const label = $(a).text().replace(/\s+/g, " ").trim();
    out.push({ source: "ultimatespecs.com", url: full, label });
  });

  log("discover", `ultimatespecs found ${out.length} trim URLs`);
  return out;
}

/**
 * Trim signature for cross-source matching. Index-page link labels vary
 * wildly ("More info" on one side, full descriptive name on the other) so
 * we sign by URL slug instead — both sites encode the powertrain in the
 * URL itself.
 *
 *   auto-data:     /en/bmw-3-series-sedan-g20-330i-258hp-steptronic-34421
 *                  → slug parts: bmw 3 series sedan g20 330i 258hp steptronic
 *                  → trim tokens: ["330i", "258hp", "steptronic"]
 *   ultimatespecs: /car-specs/BMW/115065/BMW-G20-3-Series-330i.html
 *                  → slug parts: bmw g20 3 series 330i
 *                  → trim tokens: ["330i"]
 *
 * We extract powertrain tokens (model-number-letter codes + hp, after the
 * generation codename) and match on token-set overlap. Robust against the
 * cross-site naming differences.
 */
const COMMON_NOISE = new Set([
  "bmw","audi","honda","toyota","ford","volkswagen","vw","mercedes","mercedes-benz",
  "porsche","chevrolet","kia","hyundai","mazda","nissan","subaru","tesla","peugeot",
  "renault","fiat","opel","seat","skoda","volvo","jaguar","mini","lexus","dodge",
  "jeep","mitsubishi","citroen","suzuki",
  "series","sedan","coupe","wagon","hatchback","estate","touring","saloon","convertible",
  "model","trim","car","cars","auto",
  "steptronic","tiptronic","automatic","manual","auto","cvt","dct","xdrive","quattro",
  "us","eu","uk","html","htm","en",
]);

export function trimTokens(url: string): string[] {
  let path: string;
  try {
    path = new URL(url).pathname;
  } catch {
    path = url;
  }
  // Drop file extensions; replace separators with spaces; lower-case.
  const cleaned = path
    .replace(/\.html?$/i, "")
    .replace(/[/_\\-]/g, " ")
    .toLowerCase();
  const tokens = cleaned
    .split(/\s+/)
    .filter((t) => t.length >= 2 && t.length <= 20)
    .filter((t) => !COMMON_NOISE.has(t))
    // Drop pure number IDs (the trailing numeric URL id and codenames like "115065")
    .filter((t) => !/^\d{4,}$/.test(t))
    // Keep generation codenames + powertrain identifiers
    ;
  return tokens;
}

/** Pair auto-data and ultimatespecs trim URLs by token overlap. */
export function pairTrims(
  ad: DiscoveredTrim[],
  us: DiscoveredTrim[],
): Array<{ autoData: DiscoveredTrim; ultimatespecs: DiscoveredTrim | null }> {
  const usWithTokens = us.map((t) => ({ trim: t, tokens: new Set(trimTokens(t.url)) }));
  const pairs: Array<{ autoData: DiscoveredTrim; ultimatespecs: DiscoveredTrim | null }> = [];

  for (const adTrim of ad) {
    const adTokens = trimTokens(adTrim.url);
    // Score each ultimatespecs candidate by token intersection size.
    // Tie-break by smaller candidate (more specific match).
    let best: { trim: DiscoveredTrim; score: number; tokenCount: number } | null = null;
    for (const c of usWithTokens) {
      let score = 0;
      for (const t of adTokens) if (c.tokens.has(t)) score++;
      if (
        score >= 2 &&
        (best === null ||
          score > best.score ||
          (score === best.score && c.tokens.size < best.tokenCount))
      ) {
        best = { trim: c.trim, score, tokenCount: c.tokens.size };
      }
    }
    pairs.push({ autoData: adTrim, ultimatespecs: best?.trim ?? null });
  }
  return pairs;
}
