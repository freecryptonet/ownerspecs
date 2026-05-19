/**
 * Scraper CLI.
 *
 * Usage:
 *   npx tsx scrapers/cli.ts auto-data <url>
 *
 * Writes the parsed JSON to scrapers/output/<source>-<basename>.json
 * Designed for hand-inspection before any DB insert.
 */
import { writeFile, mkdir } from "node:fs/promises";
import { dirname } from "node:path";
import { scrapeAutoDataTrim } from "./auto-data.js";
import { scrapeUltimateSpecsTrim } from "./ultimatespecs.js";
import { log } from "./lib.js";

async function main() {
  const [source, url] = process.argv.slice(2);
  if (!source || !url) {
    console.error("Usage: tsx scrapers/cli.ts <source> <url>");
    console.error("  source: auto-data | ultimatespecs");
    process.exit(2);
  }

  let result: unknown;
  let basename: string;
  switch (source) {
    case "auto-data":
    case "auto-data.net":
      result = await scrapeAutoDataTrim(url);
      basename = new URL(url).pathname.split("/").filter(Boolean).pop() ?? "out";
      break;
    case "ultimatespecs":
    case "ultimatespecs.com":
      result = await scrapeUltimateSpecsTrim(url);
      basename = (new URL(url).pathname.split("/").filter(Boolean).pop() ?? "out").replace(
        /\.html$/,
        "",
      );
      break;
    default:
      console.error(`Unknown source: ${source}`);
      process.exit(2);
  }

  const outPath = `scrapers/output/${source}-${basename}.json`;
  await mkdir(dirname(outPath), { recursive: true });
  await writeFile(outPath, JSON.stringify(result, null, 2) + "\n", "utf8");
  log("cli", `wrote ${outPath}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
