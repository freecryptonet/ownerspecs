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
import { reconcile } from "./reconcile.js";
import { log } from "./lib.js";

async function main() {
  const [source, ...rest] = process.argv.slice(2);
  if (!source) {
    console.error("Usage:");
    console.error("  tsx scrapers/cli.ts auto-data <url>");
    console.error("  tsx scrapers/cli.ts ultimatespecs <url>");
    console.error("  tsx scrapers/cli.ts reconcile <auto-data-url> <ultimatespecs-url>");
    process.exit(2);
  }

  let result: unknown;
  let basename: string;
  switch (source) {
    case "auto-data":
    case "auto-data.net": {
      const url = rest[0];
      if (!url) {
        console.error("auto-data: missing <url>");
        process.exit(2);
      }
      result = await scrapeAutoDataTrim(url);
      basename = new URL(url).pathname.split("/").filter(Boolean).pop() ?? "out";
      break;
    }
    case "ultimatespecs":
    case "ultimatespecs.com": {
      const url = rest[0];
      if (!url) {
        console.error("ultimatespecs: missing <url>");
        process.exit(2);
      }
      result = await scrapeUltimateSpecsTrim(url);
      basename = (new URL(url).pathname.split("/").filter(Boolean).pop() ?? "out").replace(
        /\.html$/,
        "",
      );
      break;
    }
    case "reconcile": {
      const [adUrl, usUrl] = rest;
      if (!adUrl || !usUrl) {
        console.error("reconcile: need both <auto-data-url> and <ultimatespecs-url>");
        process.exit(2);
      }
      const [ad, us] = await Promise.all([
        scrapeAutoDataTrim(adUrl),
        scrapeUltimateSpecsTrim(usUrl),
      ]);
      result = reconcile(ad, us);
      basename = `reconciled-${(new URL(adUrl).pathname.split("/").filter(Boolean).pop() ?? "out")}`;
      break;
    }
    case "ingest": {
      const [adUrl, usUrl] = rest;
      if (!adUrl || !usUrl) {
        console.error("ingest: need both <auto-data-url> and <ultimatespecs-url>");
        process.exit(2);
      }
      const { insertReconciled } = await import("./insert.js");
      const [ad, us] = await Promise.all([
        scrapeAutoDataTrim(adUrl),
        scrapeUltimateSpecsTrim(usUrl),
      ]);
      const rec = reconcile(ad, us);
      const ins = await insertReconciled(rec);
      result = { reconciled: rec, inserted: ins };
      basename = `ingested-${(new URL(adUrl).pathname.split("/").filter(Boolean).pop() ?? "out")}`;
      break;
    }
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
