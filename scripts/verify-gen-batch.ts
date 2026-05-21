/**
 * verify-gen-batch.ts — run verify-gen against many gens, collect output.
 *
 * Usage:
 *   tsx scripts/verify-gen-batch.ts
 *
 * Hardcoded list of (gen-slug, sample-year) pairs. Output is written
 * sequentially to stdout — pipe it to a file for review.
 */

import { spawn } from "node:child_process";

const TARGETS: Array<[slug: string, sampleYear: number]> = [
  ["a6-c8-sedan-2018-present", 2021],
  ["i4-g26-sedan-2021-present", 2023],
  ["escalade-gmt-t1xx-suv-2021-2024", 2022],
  ["bronco-u725-suv-2021-present", 2022],
  ["sierra-1500-t1xx-pickup-2019-2024", 2021],
  ["hr-v-rv3-suv-2023-present", 2024],
  ["pilot-yf-suv-2023-present", 2024],
  ["kona-sx2-suv-2023-present", 2024],
  ["range-rover-sport-l461-suv-2022-present", 2023],
  ["is-xe30-sedan-2014-2020", 2017],
  ["navigator-u554-suv-2018-present", 2021],
  ["cx-5-kf-suv-2017-2024", 2020],
  ["cx-50-suv-2023-present", 2024],
  ["mx-5-nd-roadster-2015-present", 2019],
  ["outlander-gn-suv-2022-2025", 2023],
  ["brz-zd8-coupe-2022-present", 2023],
  ["model-s-sedan-2012-present", 2020],
  ["prius-xw60-liftback-2023-present", 2024],
  ["xc90-ii-suv-2015-present", 2020],
];

function runOne(slug: string, year: number): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = spawn("npx", ["tsx", "scripts/verify-gen.ts", slug, String(year)], {
      stdio: "inherit",
    });
    child.on("close", (code) => (code === 0 ? resolve() : reject(new Error(`exit ${code}`))));
    child.on("error", reject);
  });
}

async function main() {
  console.log(`# verify-gen batch run · ${TARGETS.length} gens · ${new Date().toISOString()}`);
  for (const [slug, year] of TARGETS) {
    try {
      await runOne(slug, year);
    } catch (e) {
      console.error(`!! failed for ${slug}: ${e}`);
    }
    // Small breathing room between requests (the NHTSA wrapper already
    // throttles, but we add a tiny extra to be polite).
    await new Promise((r) => setTimeout(r, 500));
  }
  console.log(`\n# done`);
}

main();
