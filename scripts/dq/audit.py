"""CLI: run the 4-signal reliability audit over the sample, emit a scorecard.

score_cohort() is PURE (rows + spec -> per-field verdicts) and unit-tested.
main() does the live RDW fetch per sample entry and writes JSON + Markdown.
"""
import json
import os
import sys

# Allow `python scripts/dq/audit.py` (direct script invocation) as well as
# `python -m scripts.dq.audit` — same bootstrap as tests/conftest.py.
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from scripts.dq import rdw_client
from scripts.dq.sample import SAMPLE
from scripts.dq.scoring import (fill_rate, modal_agreement, range_conformance,
                                expected_presence, coc_match, within_cross_range)
from scripts.dq.verdict import field_verdict

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "output")


def score_cohort(rows, spec):
    """Pure: given cohort rows and a spec, return {field: verdict-dict}."""
    result = {}
    for field, cfg in spec["fields"].items():
        signals = {"fill_rate": fill_rate(rows, field)}
        values = [r.get(field) for r in rows]
        _, agreement, _ = modal_agreement(values)
        signals["agreement"] = agreement if agreement else None
        if "lo" in cfg and "hi" in cfg:
            signals["range_ok"] = range_conformance(rows, field, cfg["lo"], cfg["hi"])
        if "expected_body" in cfg:
            signals["expected_missing"] = expected_presence(
                rows, field, cfg["expected_body"], cfg.get("min_share", 0.01))
        if "coc" in cfg:
            modal_val, _, _ = modal_agreement(values)
            signals["coc_match"] = coc_match(modal_val, cfg["coc"], cfg.get("tol", 5))
        if "cross_lo" in cfg and "cross_hi" in cfg:
            modal_val, _, _ = modal_agreement(values)
            signals["cross_ok"] = within_cross_range(modal_val, cfg["cross_lo"], cfg["cross_hi"])
        result[field] = {**field_verdict(signals), "signals": signals}
    return result


def _where(entry):
    hb = " or ".join(f"upper(handelsbenaming) like '%{s.upper()}%'" for s in entry["hb"])
    return (f"merk='{entry['merk']}' and ({hb}) and voertuigsoort='Personenauto' "
            f"and datum_eerste_toelating>='{entry['date_van']}' "
            f"and datum_eerste_toelating<'{entry['date_tot']}'")


def main():
    scorecard = {}
    for entry in SAMPLE:
        fields = ",".join(["variant", "uitvoering", "inrichting", "handelsbenaming"] +
                          [f for f in entry["fields"] if f not in ("inrichting",)])
        rows = rdw_client.soda("m9d7-ebf2", {"$select": fields, "$where": _where(entry),
                                             "$limit": "2000"})
        scorecard[entry["key"]] = {"n": len(rows), "fields": score_cohort(rows, entry)}
        verdicts = {f: v["verdict"] for f, v in scorecard[entry["key"]]["fields"].items()}
        print(f"{entry['key']}: n={len(rows)} {verdicts}")
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, "rdw_dq_scorecard.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(scorecard, f, ensure_ascii=False, indent=2)
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
