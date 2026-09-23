"""Aggregate per-field reliability signals into a publish/corroborate/reject verdict.

Thresholds are the spec §5 Global Constraints. A hard failure (CoC mismatch,
out-of-range, or a missing expected value — the internally-consistent mis-coding
class) rejects; softer flags downgrade to corroborate; a clean field publishes.
"""

FILL_MIN = 0.5
AGREEMENT_MIN = 0.80
RANGE_MIN = 0.95

_HARD = {"coc_mismatch", "out_of_range", "expected_values_missing", "cross_source_conflict"}


def field_verdict(signals):
    reasons = []
    if signals.get("fill_rate", 0.0) < FILL_MIN:
        reasons.append("low_fill")
    agreement = signals.get("agreement")
    if agreement is not None and agreement < AGREEMENT_MIN:
        reasons.append("low_agreement")
    range_ok = signals.get("range_ok")
    if range_ok is not None and range_ok < RANGE_MIN:
        reasons.append("out_of_range")
    if signals.get("coc_match") is False:
        reasons.append("coc_mismatch")
    if signals.get("cross_ok") is False:
        reasons.append("cross_source_conflict")
    if signals.get("expected_missing"):
        reasons.append("expected_values_missing")

    if any(r in _HARD for r in reasons):
        verdict = "reject"
    elif reasons:
        verdict = "corroborate"
    else:
        verdict = "publish"
    return {"verdict": verdict, "reasons": reasons}
