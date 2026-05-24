#!/usr/bin/env tsx
/**
 * dump_manual_text.ts — dump the text of a single PDF manual to stdout,
 * one page per line preceded by "[page N]". Used for one-off exploration:
 * which page contains the fluid table, the fuse layout, etc.
 *
 * Usage:
 *   npx tsx scripts/dump_manual_text.ts manuals/om24nl-0f16e1eur.pdf
 *   npx tsx scripts/dump_manual_text.ts manuals/om24nl-0f16e1eur.pdf 350 432
 */

import { readFileSync } from "node:fs";
// @ts-expect-error — pdf-parse v2 ESM types
import { PDFParse } from "pdf-parse";

const [path, pStart, pEnd] = process.argv.slice(2);
if (!path) {
  console.error("usage: dump_manual_text.ts <pdf-path> [start-page] [end-page]");
  process.exit(1);
}

const start = pStart ? parseInt(pStart, 10) : 1;
const end = pEnd ? parseInt(pEnd, 10) : Infinity;

async function main() {
  const buf = readFileSync(path);
  const parser = new PDFParse({ data: buf });
  const result = await parser.getText();
  const txt = (result.text || "").trim();
  console.log(`# ${path}  (chars=${txt.length})`);
  // pdf-parse v2 returns the whole text. Page boundaries are form-feed
  // characters (\f). Slice to the requested page range.
  const pages = txt.split(/\f/);
  const slice = pages.slice(start - 1, end === Infinity ? pages.length : end).join("\f");
  process.stdout.write(`# pages ${start}..${Math.min(end, pages.length)} (of ${pages.length})\n`);
  process.stdout.write(slice);
}
main().catch(e => { console.error(e); process.exit(1); });
