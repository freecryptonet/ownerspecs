#!/usr/bin/env tsx
/**
 * Phase D-1: write fetched HaynesPro procedure bodies into procedures.body_md_source_text.
 *
 * - Input: scrapers/output/story_bodies_all.json (707 unique storyIds with body text)
 * - body_md_source_text is INTERNAL — never rendered publicly (Feist v Rural).
 *   Later a restating pass produces public body_md from this raw text.
 * - Updates all procedure rows where the storyId reference matches.
 *   We don't store storyId on procedures; we match by procedure title +
 *   procedure_type since titles came from HaynesPro along with storyIds.
 *
 * BUT — many gens share the same procedure (e.g. 'Battery: procedures for
 * disconnection/reconnection') with the SAME body. So we update on
 * (title, procedure_type) which propagates to every gen with that title.
 */
import { readFileSync, writeFileSync } from "node:fs";

type Body = { storyId: string; ok: boolean; len: number; body: string };
const bodies: Body[] = JSON.parse(readFileSync("scrapers/output/story_bodies_all.json", "utf8"));

// Aggregate maint_all to map storyId → title (so we can update by title match)
const maint = JSON.parse(readFileSync("scrapers/output/maint_all_chassis.json", "utf8"));
const titleByStory = new Map<string, string>();
const pageByStory = new Map<string, string>();
for (const cw of maint) {
  for (const p of (cw.procedures ?? [])) {
    if (p.storyId && p.title) {
      titleByStory.set(p.storyId, p.title);
      pageByStory.set(p.storyId, p.page || 'MAINTPROC');
    }
  }
}

function esc(s: string | null): string {
  if (s == null) return "NULL";
  return "'" + s.replace(/\\/g, "\\\\").replace(/'/g, "''") + "'";
}
function procType(page: string): string {
  return page === "SERVICERESET" ? "service_reset" : page === "SCHEDULES" ? "schedule_note" : "maintenance";
}

const lines: string[] = [];
lines.push("-- mig 347 — Phase D-1: ingest 707 fetched procedure bodies into procedures.body_md_source_text.");
lines.push("--");
lines.push("-- body_md_source_text is INTERNAL — never rendered publicly. It exists so a");
lines.push("-- later restating pass (LLM-aided or manual) can produce the public body_md.");
lines.push("-- Update matches on (procedure_type, title) so the same procedure on multiple");
lines.push("-- gens gets the same source text (titles came from the same upstream catalog).");
lines.push("");
lines.push("SET NAMES utf8mb4;");
lines.push("");

let updates = 0;
for (const b of bodies) {
  if (!b.ok || !b.body || b.len < 30) continue;
  const title = titleByStory.get(b.storyId);
  const page = pageByStory.get(b.storyId) || 'MAINTPROC';
  if (!title) continue;
  const pt = procType(page);
  // Cap stored body at 35KB to be safe (mediumtext = 16MB max anyway)
  const body = b.body.slice(0, 35000);
  lines.push(`UPDATE procedures SET body_md_source_text = ${esc(body)} WHERE procedure_type = ${esc(pt)} AND title = ${esc(title)} AND body_md_source_text IS NULL;`);
  updates++;
}
lines.push("");
lines.push(`-- ${updates} UPDATE statements`);
lines.push("");
lines.push("-- Audit");
lines.push("SELECT 'with_source_text' AS metric, COUNT(*) FROM procedures WHERE body_md_source_text IS NOT NULL");
lines.push("UNION ALL SELECT 'without_source_text', COUNT(*) FROM procedures WHERE body_md_source_text IS NULL;");

writeFileSync("db/migrations/347_ingest_procedure_bodies.sql", lines.join("\n"), "utf8");
console.log(`Wrote db/migrations/347_ingest_procedure_bodies.sql (${updates} UPDATEs)`);
