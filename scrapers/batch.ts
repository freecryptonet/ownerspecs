/**
 * Batch orchestrator.
 *
 * Usage:
 *   tsx scrapers/batch.ts --auto-data-gen <url> --ultimatespecs-gen <url> [--limit N]
 *
 * Walks both generation index pages, pairs trims by signature, then ingests
 * each pair. Writes a manifest to scrapers/output/batch-<timestamp>.json with
 * per-trim status (ok | reused | error) and any reconciliation warnings.
 *
 * Idempotent: re-running over the same trims upserts cleanly.
 * Polite: the underlying fetchHtml already enforces per-host delay.
 */
import { writeFile, mkdir } from "node:fs/promises";
import { dirname } from "node:path";
import {
  discoverAutoDataTrims,
  discoverUltimateSpecsTrims,
  pairTrims,
  type DiscoveredTrim,
} from "./discover.js";
import { scrapeAutoDataTrim } from "./auto-data.js";
import { scrapeUltimateSpecsTrim } from "./ultimatespecs.js";
import { reconcile } from "./reconcile.js";
import { insertReconciled } from "./insert.js";
import { log } from "./lib.js";

type ManifestEntry = {
  trim_label: string;
  auto_data_url: string;
  ultimatespecs_url: string | null;
  status: "ok" | "ok_reused" | "ok_auto_data_only" | "error" | "skipped_no_pair";
  trim_id?: number;
  warnings?: number;
  warning_fields?: string[];
  error?: string;
};

function arg(name: string, fallback?: string): string | undefined {
  const idx = process.argv.indexOf(name);
  if (idx === -1) return fallback;
  return process.argv[idx + 1];
}

async function main() {
  const adGen = arg("--auto-data-gen");
  const usGen = arg("--ultimatespecs-gen");
  const limit = Number(arg("--limit", "999"));

  if (!adGen || !usGen) {
    console.error(
      "Usage: tsx scrapers/batch.ts --auto-data-gen <gen-url> --ultimatespecs-gen <gen-url> [--limit N]",
    );
    process.exit(2);
  }

  log("batch", `auto-data gen: ${adGen}`);
  log("batch", `ultimatespecs gen: ${usGen}`);

  const [adTrims, usTrims] = await Promise.all([
    discoverAutoDataTrims(adGen),
    discoverUltimateSpecsTrims(usGen),
  ]);

  const pairs = pairTrims(adTrims, usTrims);
  log("batch", `paired ${pairs.length} trims (${pairs.filter((p) => p.ultimatespecs).length} matched)`);

  const ranAt = new Date().toISOString();
  const manifest: ManifestEntry[] = [];

  let processed = 0;
  for (const pair of pairs) {
    if (processed >= limit) break;
    processed++;

    const ad = pair.autoData as DiscoveredTrim;
    const us = pair.ultimatespecs;
    log("batch", `[${processed}/${Math.min(limit, pairs.length)}] ${ad.label}`);

    try {
      // When no ultimatespecs pair is found, fall back to auto-data only.
      // reconcile() with the same spec on both arms produces a clean record
      // identical to the input (every field will "agree" trivially).
      const adSpec = await scrapeAutoDataTrim(ad.url);
      const usSpec = us
        ? await scrapeUltimateSpecsTrim(us.url)
        : { ...adSpec, source: "ultimatespecs.com" as const };
      const rec = reconcile(adSpec, usSpec);
      const ins = await insertReconciled(rec);
      manifest.push({
        trim_label: ad.label,
        auto_data_url: ad.url,
        ultimatespecs_url: us?.url ?? null,
        status: us ? (ins.reused.trim ? "ok_reused" : "ok") : "ok_auto_data_only",
        trim_id: ins.trimId,
        warnings: rec.warnings.length,
        warning_fields: rec.warnings.map((w) => w.field),
      });
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      log("batch", `ERROR on ${ad.label}: ${message}`);
      manifest.push({
        trim_label: ad.label,
        auto_data_url: ad.url,
        ultimatespecs_url: us?.url ?? null,
        status: "error",
        error: message,
      });
    }
  }

  const outPath = `scrapers/output/batch-${ranAt.replace(/[:.]/g, "-")}.json`;
  await mkdir(dirname(outPath), { recursive: true });
  await writeFile(
    outPath,
    JSON.stringify(
      {
        ran_at: ranAt,
        auto_data_gen: adGen,
        ultimatespecs_gen: usGen,
        total_pairs: pairs.length,
        processed,
        ok: manifest.filter((m) => m.status === "ok").length,
        ok_reused: manifest.filter((m) => m.status === "ok_reused").length,
        errors: manifest.filter((m) => m.status === "error").length,
        skipped: manifest.filter((m) => m.status === "skipped_no_pair").length,
        manifest,
      },
      null,
      2,
    ) + "\n",
    "utf8",
  );
  log("batch", `wrote ${outPath}`);
  log(
    "batch",
    `summary: ${manifest.filter((m) => m.status === "ok").length} new, ` +
      `${manifest.filter((m) => m.status === "ok_reused").length} reused, ` +
      `${manifest.filter((m) => m.status === "error").length} errors, ` +
      `${manifest.filter((m) => m.status === "skipped_no_pair").length} skipped`,
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
