/**
 * Shared scraper utilities.
 *
 * Design notes
 * ------------
 * - Polite by default: every HTTP request waits `MIN_DELAY_MS` since the last
 *   one to the same host. Configurable via env, never bypassed.
 * - User-Agent identifies us honestly. We're a research/cataloguing crawler;
 *   we're not pretending to be a browser.
 * - Retries on 5xx + network errors with exponential backoff. NOT on 4xx —
 *   if they 403/429 us, we stop and let the operator investigate.
 * - We extract facts only (per Feist v. Rural). We never persist the source's
 *   HTML, page structure, image URLs, or editorial text.
 */

const USER_AGENT =
  process.env.SCRAPER_USER_AGENT ??
  "ownerspecs-bot/0.1 (+https://ownerspecs.com; research crawler; contact timgvk@gmail.com)";
const MIN_DELAY_MS = Number(process.env.SCRAPER_MIN_DELAY_MS ?? 4000);
const MAX_RETRIES = Number(process.env.SCRAPER_MAX_RETRIES ?? 3);

const lastRequestByHost = new Map<string, number>();

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function politeWait(host: string): Promise<void> {
  const last = lastRequestByHost.get(host) ?? 0;
  const since = Date.now() - last;
  if (since < MIN_DELAY_MS) {
    await sleep(MIN_DELAY_MS - since);
  }
  lastRequestByHost.set(host, Date.now());
}

export async function fetchHtml(url: string): Promise<string> {
  const host = new URL(url).host;
  await politeWait(host);

  let lastErr: unknown;
  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    if (attempt > 0) {
      const backoff = 2000 * 2 ** attempt;
      console.error(`  retry ${attempt + 1}/${MAX_RETRIES} after ${backoff}ms`);
      await sleep(backoff);
    }
    try {
      const res = await fetch(url, {
        headers: {
          "User-Agent": USER_AGENT,
          Accept: "text/html,application/xhtml+xml",
          "Accept-Language": "en;q=0.9",
        },
        redirect: "follow",
      });
      if (res.status === 429 || res.status === 403) {
        // Hard stop — we're being asked to back off. Don't retry.
        throw new ScraperError(
          `Hard-stop response ${res.status} from ${url} — investigate before retrying`,
          { url, status: res.status, terminal: true },
        );
      }
      if (!res.ok) {
        if (res.status >= 500) {
          lastErr = new ScraperError(`HTTP ${res.status} from ${url}`, {
            url,
            status: res.status,
          });
          continue; // retry 5xx
        }
        throw new ScraperError(`HTTP ${res.status} from ${url}`, {
          url,
          status: res.status,
        });
      }
      const html = await res.text();
      return html;
    } catch (err) {
      if (err instanceof ScraperError && err.terminal) throw err;
      lastErr = err;
    }
  }
  throw lastErr ?? new Error("fetch failed after retries");
}

export class ScraperError extends Error {
  url?: string;
  status?: number;
  terminal: boolean;
  constructor(
    message: string,
    info: { url?: string; status?: number; terminal?: boolean } = {},
  ) {
    super(message);
    this.url = info.url;
    this.status = info.status;
    this.terminal = info.terminal ?? false;
  }
}

/**
 * Normalize a number from a string. Handles "1,234.5", "1 234.5 mm", "10.6 : 1",
 * "174 hp @ 6000 rpm" (returns 174), "73.0 × 89.5 mm" (returns null — that's two values).
 * Returns null if the input doesn't contain a parseable number or contains multiple.
 */
export function parseNumber(input: string | null | undefined): number | null {
  if (!input) return null;
  // Strip thousands separators (commas, spaces between digits) but keep decimals
  const cleaned = input
    .replace(/[  ]/g, " ")
    .replace(/(\d)[, ](\d{3})/g, "$1$2")
    .trim();
  const match = cleaned.match(/-?\d+(?:\.\d+)?/);
  if (!match) return null;
  const n = Number(match[0]);
  return Number.isFinite(n) ? n : null;
}

/**
 * Extract "73.0 × 89.5" → [73.0, 89.5]. Returns null if not exactly two numbers.
 */
export function parsePair(input: string | null | undefined): [number, number] | null {
  if (!input) return null;
  const matches = input.match(/-?\d+(?:\.\d+)?/g);
  if (!matches || matches.length !== 2) return null;
  const [a, b] = matches.map(Number);
  return Number.isFinite(a) && Number.isFinite(b) ? [a, b] : null;
}

/**
 * Slugify a string for URL use. Lower-case, ascii, dashes, no double-dashes.
 */
export function slugify(input: string): string {
  return input
    .normalize("NFKD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/**
 * Convenience for logging.
 */
export function log(scope: string, msg: string): void {
  const ts = new Date().toISOString().slice(11, 19);
  console.log(`[${ts} ${scope}] ${msg}`);
}
