#!/usr/bin/env node
// One-off: patches a generated ingest migration's fluid_specs INSERT IGNORE
// block to use individual INSERT...WHERE NOT EXISTS statements that respect
// existing hand-seeded (gen_id, fluid_type, engine_id) rows.

const fs = require('fs');
const path = require('path');

const migsArg = process.argv.slice(2);
if (migsArg.length === 0) {
  console.error('Usage: node _patch_not_exists.js <mig_number> [<mig_number>...]');
  process.exit(1);
}

const sqlStr = "(?:'(?:[^']|'')*'|NULL)";
const rowRe = new RegExp(
  "\\(@gen,\\s*'(\\w+)',\\s*(\\(SELECT id FROM engines WHERE code = '[^']+'\\)),\\s*(NULL|[\\d.]+),\\s*(NULL|[\\d.]+),\\s*(" + sqlStr + "),\\s*(" + sqlStr + "),\\s*(" + sqlStr + ")\\)",
  'g'
);

const migDir = path.resolve(__dirname, '..', '..', 'db', 'migrations');
for (const n of migsArg) {
  const files = fs.readdirSync(migDir).filter(f => f.startsWith(n + '_'));
  if (!files.length) { console.error('no migration found for ' + n); continue; }
  const p = path.join(migDir, files[0]);
  let sql = fs.readFileSync(p, 'utf8');
  const start = sql.indexOf('INSERT IGNORE INTO fluid_specs');
  if (start < 0) { console.error(files[0] + ': no fluid_specs block'); continue; }
  const valuesIdx = sql.indexOf('VALUES', start);
  const end = sql.indexOf(');', valuesIdx) + 2;
  const block = sql.slice(start, end);
  const rows = [];
  let m;
  while ((m = rowRe.exec(block)) !== null) {
    rows.push({ ftype: m[1], engLookup: m[2], capL: m[3], capQt: m[4], visc: m[5], spec: m[6], notes: m[7] });
  }
  const newRows = rows.map(r =>
    "INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)\n" +
    "SELECT @gen, '" + r.ftype + "', " + r.engLookup + ", " + r.capL + ", " + r.capQt + ", " + r.visc + ", " + r.spec + ", " + r.notes + "\n" +
    "WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @gen AND fluid_type = '" + r.ftype + "' AND engine_id = " + r.engLookup + ");"
  ).join('\n');
  sql = sql.slice(0, start) + newRows + sql.slice(end);
  fs.writeFileSync(p, sql);
  console.log(files[0] + ': patched ' + rows.length + ' fluid_specs rows with NOT EXISTS guard');
}
