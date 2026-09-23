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


def test_score_cohort_coc_is_tvv_scoped():
    # dominant TVV mass 1104 (would mismatch CoC 1160); the CoC's own TVV has 1160 (matches)
    rows = [{"massa_rijklaar": "1104", "variant": "F5P41", "uitvoering": "M52AZ1"}] * 90 + \
           [{"massa_rijklaar": "1160", "variant": "B5P11", "uitvoering": "M61BZ1"}] * 10
    spec = {"fields": {"massa_rijklaar": {"lo": 700, "hi": 2000, "coc": 1160,
                                          "coc_tvv": ("B5P11", "M61BZ1")}}}
    out = score_cohort(rows, spec)
    assert out["massa_rijklaar"]["signals"]["coc_match"] is True
    assert "coc_mismatch" not in out["massa_rijklaar"]["reasons"]


def test_score_cohort_coc_absent_tvv_is_unknown_not_mismatch():
    rows = [{"massa_rijklaar": "1104", "variant": "F5P41", "uitvoering": "M52AZ1"}] * 50
    spec = {"fields": {"massa_rijklaar": {"lo": 700, "hi": 2000, "coc": 1160,
                                          "coc_tvv": ("B5P11", "M61BZ1")}}}
    out = score_cohort(rows, spec)
    assert out["massa_rijklaar"]["signals"]["coc_match"] is None
    assert "coc_mismatch" not in out["massa_rijklaar"]["reasons"]
