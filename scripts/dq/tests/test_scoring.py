from scripts.dq.scoring import is_present, fill_rate, modal_agreement, range_conformance, expected_presence


def test_is_present():
    assert is_present("1600") is True
    assert is_present(0) is True          # numeric zero is a value at this layer
    assert is_present(None) is False
    assert is_present("") is False
    assert is_present("   ") is False


def test_fill_rate():
    rows = [{"m": "1"}, {"m": ""}, {"m": "3"}, {"m": None}]
    assert fill_rate(rows, "m") == 0.5
    assert fill_rate([], "m") == 0.0


def test_modal_agreement():
    assert modal_agreement(["a", "a", "a", "b"]) == ("a", 0.75, 4)
    assert modal_agreement([]) == (None, 0.0, 0)
    assert modal_agreement([None, "", "x"]) == ("x", 1.0, 1)


def test_range_conformance():
    rows = [{"kg": "1600"}, {"kg": "1700"}, {"kg": "50"}, {"kg": ""}]
    # 2 of 3 present numerics within [500,4000]; the 50 is out of range
    assert range_conformance(rows, "kg", 500, 4000) == 2 / 3
    assert range_conformance([{"kg": ""}], "kg", 500, 4000) is None


def test_expected_presence_flags_the_body_bug():
    # 99 wagons, 1 hatchback -> hatchback share 0.01 which is NOT below min_share 0.02 -> flagged
    rows = [{"body": "stationwagen"}] * 99 + [{"body": "hatchback"}] * 1
    missing = expected_presence(rows, "body", must_include=["hatchback"], min_share=0.02)
    assert missing == ["hatchback"]
    # when hatchback is well represented, nothing is flagged
    rows2 = [{"body": "stationwagen"}] * 60 + [{"body": "hatchback"}] * 40
    assert expected_presence(rows2, "body", must_include=["hatchback"], min_share=0.02) == []
