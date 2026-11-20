#!/usr/bin/env python3
"""Audit zh labware prompts against their English task definitions.

Run: python bench/prompts/validate_zh.py
Requires PyYAML (already used by the benchmark).
Checks are lexical, not a substitute for independent semantic review.
"""
from collections import Counter
from pathlib import Path
import re
import sys

import yaml

ROOT = Path(__file__).resolve().parents[2]
NUMBER = re.compile(r"\d+(?:\.\d+)?(?:[eE][+-]?\d+)?")
SIGNED_NUMBER = re.compile(r"(?<![A-Za-z0-9_.])[+-]\s*\d+(?:\.\d+)?(?:[eE][+-]?\d+)?")
SIGNED_AXIS = re.compile(r"(?<![A-Za-z0-9_])[+-]\s*[XYZxyz]\b")
# Bind explicit coordinate assignment to its axis rather than only its number.
COORD_ASSIGNMENT = re.compile(
    r"(?<![A-Za-z0-9_])([xyzXYZ])\s*=\s*([+-]?\s*\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)"
)
HAN = re.compile(r"[\u4e00-\u9fff]")

# Geometry text may use Unicode minus/full-width mathematical signs. Normalize
# only mathematical sign characters: ordinary Chinese prose is unchanged.
MATH_SIGNS = str.maketrans({"−": "-", "－": "-", "﹣": "-", "＋": "+", "﹢": "+"})


def normalize_math_signs(text):
    return text.translate(MATH_SIGNS)


# Frozen pre-contribution English task identities. New tasks may be added by
# independent PRs, but the original 16 Chinese translations must not disappear.
BASELINE_TASK_IDS = frozenset({
    "tube_rack_1p5ml",
    "conical_rack_50ml",
    "slide_drying_rack",
    "pcr_tube_rack_sbs",
    "gel_comb_10well",
    "micropestle_1p5ml",
    "lab_funnel_60mm",
    "seed_sowing_template",
    "dshaft_knob_6mm",
    "pcr_tube_adapter",
    "hose_barb_reducer_8_5",
    "rod_tubing_clip",
    "stirrer_fan_housing",
    "nema17_motor_bracket",
    "enclosure_box_and_lid",
    "mini_gel_tank",
})



def audit(task_path=None, translation_path=None, expected_baseline_ids=None):
    task_path = task_path or ROOT / "bench/tasks.yaml"
    translation_path = translation_path or ROOT / "bench/prompts/translations.yaml"
    tasks = yaml.safe_load(Path(task_path).read_text(encoding="utf-8"))
    translations = yaml.safe_load(Path(translation_path).read_text(encoding="utf-8"))
    originals = {task["id"]: task["prompt"] for task in tasks}
    if len(originals) != len(tasks):
        raise ValueError("Duplicate benchmark task id")
    zh = translations.get("zh")
    if not isinstance(zh, dict):
        raise ValueError("Missing zh language mapping")
    # New English benchmark tasks may be merged independently of this
    # translation PR. Validate the translated subset, never silently label
    # untranslated tasks as Chinese. run_bench.py already refuses to run
    # --lang zh if any *selected* task lacks a translation.
    extra = set(zh) - set(originals)
    if extra:
        raise ValueError(f"Translation IDs not present in benchmark: {sorted(extra)}")
    required = BASELINE_TASK_IDS if expected_baseline_ids is None else frozenset(expected_baseline_ids)
    missing_english = required - set(originals)
    if missing_english:
        raise ValueError(f"Missing baseline English benchmark tasks: {sorted(missing_english)}")
    missing_zh = required - set(zh)
    if missing_zh:
        raise ValueError(f"Missing baseline Chinese translations: {sorted(missing_zh)}")
    problems = []
    for task_id, localized in zh.items():
        english = originals[task_id]
        if not isinstance(localized, str) or not HAN.search(localized):
            problems.append(f"{task_id}: empty or non-Chinese translation")
            continue
        english = normalize_math_signs(english)
        localized = normalize_math_signs(localized)
        source_nums = Counter(NUMBER.findall(english))
        localized_nums = Counter(NUMBER.findall(localized))
        if localized_nums != source_nums:
            problems.append(
                f"{task_id}: altered numeric constraints "
                f"missing={dict(source_nums-localized_nums)} "
                f"added={dict(localized_nums-source_nums)}"
            )
        # Global number multisets alone cannot detect swapped X/Y values.
        def coordinate_bindings(text):
            return Counter(
                (axis.upper(), re.sub(r"\s+", "", number))
                for axis, number in COORD_ASSIGNMENT.findall(text)
            )
        expected_bindings = coordinate_bindings(english)
        observed_bindings = coordinate_bindings(localized)
        if expected_bindings != observed_bindings:
            problems.append(
                f"{task_id}: altered coordinate axis-value assignments "
                f"missing={dict(expected_bindings-observed_bindings)} "
                f"added={dict(observed_bindings-expected_bindings)}"
            )
        # Unsigned number parity alone would miss x=-25 becoming x=25, or -Y becoming +Y.
        # Compare signed tokens separately; independent technical review remains necessary.
        for kind, pattern in (("signed numbers", SIGNED_NUMBER), ("signed axes", SIGNED_AXIS)):
            canonical = lambda text: Counter(
                re.sub(r"\s+", "", match).upper()
                for match in pattern.findall(text)
            )
            expected, observed = canonical(english), canonical(localized)
            if observed != expected:
                problems.append(
                    f"{task_id}: altered {kind} "
                    f"missing={dict(expected-observed)} "
                    f"added={dict(observed-expected)}"
                )
    return len(zh), problems


if __name__ == "__main__":
    total, problems = audit()
    for problem in problems:
        print("FAIL", problem, file=sys.stderr)
    invalid_ids = {problem.split(":", 1)[0] for problem in problems}
    print(f"zh task translations: {total-len(invalid_ids)}/{total} numerically consistent")
    if problems:
        sys.exit(1)
