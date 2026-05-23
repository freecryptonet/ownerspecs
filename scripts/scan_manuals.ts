#!/usr/bin/env tsx
/**
 * scan_manuals.ts — Inventory the PDFs in F:/projects/ownerspecs/manuals/.
 *
 * Walks the manuals/ folder, hashes each PDF, and writes a row to
 * manual_inventory for any PDF whose sha256 is not yet in the table.
 *
 * Edition-code parsing uses brand-specific heuristics on the first ~3
 * pages and last ~2 pages of the PDF (where OEMs print the part
 * number / Stand / printing date / © year). Tweak BRAND_HEURISTICS
 * below as you learn new patterns.
 *
 * Usage:
 *   npx tsx scripts/scan_manuals.ts             # incremental — only new PDFs
 *   npx tsx scripts/scan_manuals.ts --reindex   # re-parse every PDF (does NOT delete; UPSERT on sha256)
 *   npx tsx scripts/scan_manuals.ts --dry-run   # report what would be inserted, no DB write
 *
 * Requires DB credentials in .env.local (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME).
 * Connect via the MariaDB tunnel ~/start-mariadb-tunnel.bat first.
 */

import { readFileSync, readdirSync, statSync } from "node:fs";
import { createHash } from "node:crypto";
import { resolve, relative, join } from "node:path";
import { config as loadEnv } from "dotenv";
import mysql from "mysql2/promise";
// @ts-expect-error — pdf-parse v2 ESM types
import { PDFParse } from "pdf-parse";

loadEnv({ path: ".env.local" });
loadEnv({ path: ".env" });

const ROOT = resolve(process.cwd(), "manuals");
const REINDEX = process.argv.includes("--reindex");
const DRY = process.argv.includes("--dry-run");

type ParsedManual = {
  file_path: string;
  sha256: string;
  manual_type: "owner" | "service" | "workshop" | "parts" | "quickref" | "other";
  brand: string | null;
  model: string | null;
  model_year_start: number | null;
  model_year_end: number | null;
  edition_code: string | null;
  edition_label: string | null;
  publication_date: string | null;
  language: string;
  region: string | null;
  page_count: number;
  title_text: string | null;
  notes: string | null;
};

const MONTHS: Record<string, number> = {
  jan: 1, feb: 2, mar: 3, apr: 4, may: 5, jun: 6, jul: 7, aug: 8, sep: 9, oct: 10, nov: 11, dec: 12,
  januar: 1, februar: 2, märz: 3, april: 4, mai: 5, juni: 6, juli: 7, august: 8, september: 9, oktober: 10, november: 11, dezember: 12,
};

function collectPdfs(dir: string, acc: string[] = []): string[] {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const st = statSync(full);
    if (st.isDirectory()) collectPdfs(full, acc);
    else if (name.toLowerCase().endsWith(".pdf")) acc.push(full);
  }
  return acc;
}

function sha256(file: string): string {
  return createHash("sha256").update(readFileSync(file)).digest("hex");
}

function detectBrand(text: string, filename: string): string | null {
  // Filename hint takes precedence for Nissan EUR pattern (omYYxx-...eur.pdf)
  if (/^om\d{2}[a-z]{2}-.+eur\.pdf$/i.test(filename)) return "nissan";
  const haystack = (text.slice(0, 4000) + " " + filename).toLowerCase();
  const brands = [
    "audi", "volkswagen", "vw", "bmw", "mercedes-benz", "mercedes", "honda", "acura",
    "toyota", "lexus", "ford", "chevrolet", "gmc", "cadillac", "chrysler", "dodge",
    "jeep", "ram", "fiat", "alfa romeo", "mazda", "subaru", "nissan", "infiniti",
    "hyundai", "kia", "genesis", "volvo", "porsche", "mini", "land rover", "jaguar",
    "tesla", "polestar", "renault", "peugeot", "citroën", "citroen", "opel", "vauxhall",
    "seat", "škoda", "skoda", "cupra"
  ];
  for (const b of brands) {
    // Word boundary — "audi" must NOT match inside "audio"
    const re = new RegExp(`\\b${b.replace(/[-\s]/g, "[-\\s]")}\\b`, "i");
    if (re.test(haystack)) return b === "vw" ? "volkswagen" : b.replace("ë", "e");
  }
  return null;
}

// Nissan EUR model code → human model name mapping (drawn from filename position 4-7)
const NISSAN_MODEL_CODES: Record<string, string> = {
  "0F16": "Juke",
  "HF16": "Juke Hybrid",
  "0FE0": "Ariya",
  "HJ12": "X-Trail e-Power",
  "HT33": "Qashqai e-Power",
};
function nissanModelFromFilename(filename: string): string | null {
  const m = filename.match(/^om\d{2}[a-z]{2}-([0-9hH][a-zA-Z0-9]{3})/i);
  if (!m) return null;
  return NISSAN_MODEL_CODES[m[1].toUpperCase()] ?? null;
}
function nissanMyFromFilename(filename: string): number | null {
  const m = filename.match(/^om(\d{2})/i);
  return m ? 2000 + parseInt(m[1], 10) : null;
}

function extractMyRange(text: string): { start: number | null; end: number | null } {
  const m = text.match(/\b(20[0-2]\d)\s*[-–]\s*(20[0-2]\d)\b/);
  if (m) return { start: parseInt(m[1], 10), end: parseInt(m[2], 10) };
  const single = text.match(/\b(20[0-2]\d)\b/);
  if (single) return { start: parseInt(single[1], 10), end: parseInt(single[1], 10) };
  return { start: null, end: null };
}

function extractPublicationDate(text: string): string | null {
  let m = text.match(/Stand[:\s]+(\d{1,2})[\.\/](\d{4})/i);
  if (m) return `${m[2]}-${String(m[1]).padStart(2, "0")}-01`;
  m = text.match(/(?:Printed|Printing|Édition|Edition|Druck)[\s:]*(?:\d{1,2}[\.\/])?(\d{1,2})[\.\/-](\d{4})/i);
  if (m) return `${m[2]}-${String(m[1]).padStart(2, "0")}-01`;
  m = text.match(/©\s*(\d{4})/);
  if (m) return `${m[1]}-01-01`;
  for (const [name, num] of Object.entries(MONTHS)) {
    const re = new RegExp(`${name}[a-zé]*\\s+(20[0-2]\\d)`, "i");
    const mm = text.match(re);
    if (mm) return `${mm[1]}-${String(num).padStart(2, "0")}-01`;
  }
  return null;
}

function extractEditionCode(text: string, brand: string | null): string | null {
  const hay = text.slice(0, 6000) + " " + text.slice(-2000);
  // Honda: 31TBA610-style (2 digits + 3 letters + 3 digits, optional A-Z suffix)
  let m = hay.match(/\b(\d{2}[A-Z]{3}\d{3}[A-Z]?)\b/);
  if (m) return m[1];
  // Audi / VW: "Stand: 11.2019" — keep the full Stand string
  m = hay.match(/Stand[:\s]+\d{1,2}[\.\/]\d{4}/i);
  if (m) return m[0].trim();
  // VW group part number: NNN.NNN.NNN XX  (3 dot-separated digit groups + letters)
  m = hay.match(/\b\d{3}\.\d{3}\.\d{3}\s*[A-Z]{2}\b/);
  if (m) return m[0].replace(/\s+/g, " ");
  // BMW Bestell-Nr / Order No
  m = hay.match(/(?:Bestell[-\s]?Nr|Order\s*No|Référence)[\.:\s]+([A-Z0-9\.\-\s]{6,24})/i);
  if (m) return m[1].trim().replace(/\s+/g, " ");
  // Toyota / Lexus: "OM12345A" or "Pub. No. OMxxxxxxx"
  m = hay.match(/\b(OM[A-Z0-9]{5,8})\b/);
  if (m) return m[1];
  // Mercedes: "Bestellnummer 222 584" or "MY24"
  m = hay.match(/\bMY\d{2}\b/);
  if (m) return m[0];
  return null;
}

function extractLanguage(text: string, filename: string): string {
  // Filename hint: Nissan EUR-NL pattern omYYnl-...eur
  if (/^om\d{2}nl-/i.test(filename)) return "nl-NL";
  if (/^om\d{2}de-/i.test(filename)) return "de-DE";
  if (/^om\d{2}fr-/i.test(filename)) return "fr-FR";
  if (/^om\d{2}it-/i.test(filename)) return "it-IT";
  if (/^om\d{2}es-/i.test(filename)) return "es-ES";

  const head = text.slice(0, 5000).toLowerCase();
  // Dutch
  if (/(instructieboekje|gebruikershandleiding|eigenaarshandleiding|bedieningshandleiding|handleiding\s+voor)/.test(head)) return "nl-NL";
  // German
  if (/(bedienungsanleitung|betriebsanleitung|fahrzeughandbuch)/.test(head)) return "de-DE";
  // French
  if (/(manuel\s*du\s*conducteur|guide\s*du\s*propriétaire|notice\s*d'utilisation)/.test(head)) return "fr-FR";
  // Italian
  if (/(manuale\s*del\s*proprietario|libretto\s*di\s*uso)/.test(head)) return "it-IT";
  // Spanish
  if (/(manual\s*del\s*propietario|manual\s*del\s*conductor)/.test(head)) return "es-ES";
  // English variants
  if (/(owner'?s\s+manual|owner manual)/.test(head)) {
    if (/\b(canada|canadian|québec)\b/.test(head)) return "en-CA";
    if (/\b(united kingdom|britain|british)\b/.test(head)) return "en-GB";
    return "en-US";
  }
  return "en-US";
}

function extractRegion(text: string): string | null {
  const hay = text.slice(0, 5000);
  if (/\bU\.?S\.?A?\.?\b|United States/i.test(hay)) return "US";
  if (/\b(Europe|European|EU)\b/i.test(hay)) return "EU";
  if (/\bCanada\b/i.test(hay)) return "CA";
  if (/\bJapan\b/i.test(hay)) return "JP";
  if (/\b(China|PRC)\b/i.test(hay)) return "CN";
  if (/\b(Australia|ANZ)\b/i.test(hay)) return "AU";
  return null;
}

// Nissan EUR filename pattern: omYYxx-<modelCode><rev><variant>eur.pdf — extract the model+rev as edition code
function extractFilenameCode(filename: string): string | null {
  const m = filename.match(/^(om\d{2}[a-z]{2}-[0-9a-z]+eur)\.pdf$/i);
  return m ? m[1].toUpperCase() : null;
}

function firstTitleLine(text: string): string {
  for (const ln of text.split(/\r?\n/).slice(0, 30)) {
    const t = ln.trim();
    if (t.length >= 8 && t.length <= 120 && !/^\d+$/.test(t)) return t;
  }
  return text.slice(0, 100).trim();
}

function pdfDateToISO(raw: string | undefined | null): string | null {
  if (!raw) return null;
  const m = raw.match(/D:(\d{4})(\d{2})(\d{2})/);
  return m ? `${m[1]}-${m[2]}-${m[3]}` : null;
}

async function parsePdf(filepath: string): Promise<ParsedManual & { pdf_info?: any }> {
  const buf = readFileSync(filepath);
  const file_path = relative(process.cwd(), filepath).replace(/\\/g, "/");
  const sha = createHash("sha256").update(buf).digest("hex");
  const parser = new PDFParse({ data: buf });
  const infoResult = await parser.getInfo();
  const textResult = await parser.getText();
  const text = textResult.text || "";
  const page_count = infoResult.total || 0;
  const pdf_info = infoResult.info || {};
  const pdf_creation = pdfDateToISO(pdf_info.CreationDate);

  // Use first ~6000 chars + last ~2000 for heuristics (title pages + colophon)
  const filename = file_path.split("/").pop() || "";
  const brand = detectBrand(text, filename);
  // Nissan filenames are deterministic: omYY = MY, 4-char model code = vehicle.
  const nissanMy = brand === "nissan" ? nissanMyFromFilename(filename) : null;
  const nissanModel = brand === "nissan" ? nissanModelFromFilename(filename) : null;
  const my = nissanMy ? { start: nissanMy, end: nissanMy } : extractMyRange(text.slice(0, 6000) + " " + filename);
  // Prefer PDF metadata date if present, else text-extracted
  const publication_date = pdf_creation || extractPublicationDate(text);
  const edition_code = extractEditionCode(text, brand) || extractFilenameCode(filename);
  const language = extractLanguage(text, filename);
  // Nissan EUR-NL pattern → EU region. Else try text extraction.
  const region = /^om\d{2}[a-z]{2}-.+eur\.pdf$/i.test(filename) ? "EU" : extractRegion(text);

  // Manual type from filename or text
  let manual_type: ParsedManual["manual_type"] = "owner";
  const ftLower = (filename + " " + text.slice(0, 1500)).toLowerCase();
  if (/(workshop|service)\s*manual|werkstatthandbuch/.test(ftLower)) manual_type = "workshop";
  else if (/parts\s*catalog|teilekatalog/.test(ftLower)) manual_type = "parts";
  else if (/quick\s*(reference|start)/.test(ftLower)) manual_type = "quickref";

  const title_text = firstTitleLine(text);

  return {
    file_path,
    sha256: sha,
    manual_type,
    brand,
    model: nissanModel,
    model_year_start: my.start,
    model_year_end: my.end,
    edition_code,
    edition_label: null,
    publication_date,
    language,
    region,
    page_count,
    title_text,
    notes: null,
  };
}

async function main() {
  const pdfs = collectPdfs(ROOT);
  if (pdfs.length === 0) {
    console.log("manuals/ is empty — drop some PDFs in there first.");
    return;
  }
  console.log(`Found ${pdfs.length} PDFs under ${ROOT}`);

  let conn: any = null;
  let existing = new Map<string, number>();
  if (!DRY) {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT || "3306", 10),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      multipleStatements: false,
    });
    const [existingRows] = (await conn.query("SELECT sha256, id FROM manual_inventory")) as any;
    existing = new Map<string, number>(existingRows.map((r: any) => [r.sha256, r.id]));
  }
  let inserted = 0, skipped = 0, reindexed = 0, errors = 0;

  for (const pdf of pdfs) {
    try {
      const hash = sha256(pdf);
      if (existing.has(hash) && !REINDEX) { skipped++; continue; }
      const parsed = await parsePdf(pdf);
      console.log(`  ${parsed.file_path} — brand=${parsed.brand ?? "?"} my=${parsed.model_year_start ?? "?"}-${parsed.model_year_end ?? "?"} edition=${parsed.edition_code ?? "?"} pages=${parsed.page_count}`);
      if (DRY) continue;
      if (existing.has(hash)) {
        await conn.query(
          `UPDATE manual_inventory SET file_path=?, manual_type=?, brand=?, model_year_start=?, model_year_end=?, edition_code=?, publication_date=?, language=?, region=?, page_count=?, title_text=?, extracted_at=NOW() WHERE sha256=?`,
          [parsed.file_path, parsed.manual_type, parsed.brand, parsed.model_year_start, parsed.model_year_end, parsed.edition_code, parsed.publication_date, parsed.language, parsed.region, parsed.page_count, parsed.title_text, hash]
        );
        reindexed++;
      } else {
        await conn.query(
          `INSERT INTO manual_inventory (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end, edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)`,
          [parsed.file_path, parsed.sha256, parsed.manual_type, parsed.brand, parsed.model, parsed.model_year_start, parsed.model_year_end, parsed.edition_code, parsed.edition_label, parsed.publication_date, parsed.language, parsed.region, parsed.page_count, parsed.title_text, parsed.notes]
        );
        inserted++;
      }
    } catch (e: any) {
      console.error(`  ! ${pdf}: ${e.message}`);
      errors++;
    }
  }

  if (conn) await conn.end();
  console.log(`\nDone. inserted=${inserted} skipped=${skipped} reindexed=${reindexed} errors=${errors}`);
}

main().catch(e => { console.error(e); process.exit(1); });
