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
NUMBER = re.compile(r"\d+(?:\.\d+)?")
HAN = re.compile(r"[\u4e00-\u9fff]")


def audit(task_path=None, translation_path=None):
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
    if set(zh) != set(originals):
        raise ValueError(
            f"Translation IDs differ: missing={sorted(set(originals)-set(zh))}, "
            f"extra={sorted(set(zh)-set(originals))}"
        )
    problems = []
    for task_id, english in originals.items():
        localized = zh[task_id]
        if not isinstance(localized, str) or not HAN.search(localized):
            problems.append(f"{task_id}: empty or non-Chinese translation")
            continue
        source_nums = Counter(NUMBER.findall(english))
        localized_nums = Counter(NUMBER.findall(localized))
        if localized_nums != source_nums:
            problems.append(
                f"{task_id}: altered numeric constraints "
                f"missing={dict(source_nums-localized_nums)} "
                f"added={dict(localized_nums-source_nums)}"
            )
    return len(originals), problems


if __name__ == "__main__":
    total, problems = audit()
    for problem in problems:
        print("FAIL", problem, file=sys.stderr)
    print(f"zh task translations: {total-len(problems)}/{total} numerically consistent")
    if problems:
        sys.exit(1)
