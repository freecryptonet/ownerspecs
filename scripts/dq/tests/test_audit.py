from scripts.dq.audit import score_cohort


def test_score_cohort_flags_body_and_passes_mass():
    rows = [{"massa_rijklaar": "1160", "inrichting": "stationwagen"}] * 99 + \
           [{"massa_rijklaar": "1160", "inrichting": "hatchback"}] * 1
    spec = {
        "fields": {
            "massa_rijklaar": {"lo": 500, "hi": 4000, "coc": 1160},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
        }
    }
    out = score_cohort(rows, spec)
    assert out["massa_rijklaar"]["verdict"] == "publish"
    assert out["inrichting"]["verdict"] == "reject"
    assert "expected_values_missing" in out["inrichting"]["reasons"]
