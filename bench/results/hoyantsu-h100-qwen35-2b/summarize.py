"""Summarize task correctness, feedback repairs and elapsed time for this run."""

import collections
import csv
import json
import re
import statistics
from pathlib import Path

ROOT = Path(__file__).resolve().parent
rows = [json.loads(line) for line in (ROOT / "results.jsonl").read_text().splitlines()]
by_task = collections.defaultdict(list)
by_sample = collections.defaultdict(list)
for row in rows:
    by_task[row["task"]].append(row)
    by_sample[row["sample"]].append(row)


def summarize(group):
    return {
        "conversations": len(group),
        "first_attempt_passes": sum(row["first_pass"] for row in group),
        "final_passes": sum(row["passed"] for row in group),
        "rendered_conversations": sum(
            any(attempt["render"]["ok"] for attempt in row["attempts"])
            for row in group
        ),
        "mean_best_score": round(statistics.mean(
            max(attempt["score"] for attempt in row["attempts"]) for row in group
        ), 4),
        "median_seconds": round(statistics.median(row["wall_s"] for row in group), 2),
        "total_seconds": round(sum(row["wall_s"] for row in group), 2),
    }


for name, groups in [("task", by_task), ("sample", by_sample)]:
    table = [{name: key, **summarize(group)} for key, group in sorted(groups.items())]
    with (ROOT / f"by_{name}.csv").open("w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=list(table[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(table)

repairs = changed = improved = 0
stop_reasons = collections.Counter()
rendered_attempts = 0
parser_errors = empty_objects = 0
for row in rows:
    model_folder = re.sub(r"[^A-Za-z0-9._-]+", "_", row["model"])
    prefix = ROOT / "code" / model_folder / f"{row['task']}_s{row['sample']}"
    for attempt in row["attempts"]:
        stop_reasons[attempt["usage"]["done_reason"]] += 1
        rendered_attempts += attempt["render"]["ok"]
        parser_errors += any("Parser error:" in message for message in attempt["render"]["messages"])
        empty_objects += any("top level object is empty" in message for message in attempt["render"]["messages"])
    for previous, current in zip(row["attempts"], row["attempts"][1:]):
        repairs += 1
        before = Path(f"{prefix}_a{previous['attempt']}.scad").read_text()
        after = Path(f"{prefix}_a{current['attempt']}.scad").read_text()
        changed += before != after
        improved += current["score"] > previous["score"]

summary = {
    **summarize(rows),
    "tasks": len(by_task),
    "samples": len(by_sample),
    "attempts": sum(len(row["attempts"]) for row in rows),
    "rendered_attempts": rendered_attempts,
    "attempts_with_parser_errors": parser_errors,
    "attempts_with_empty_objects": empty_objects,
    "feedback_attempts": repairs,
    "changed_after_feedback": changed,
    "score_improved_after_feedback": improved,
    "conversations_passed_after_feedback": sum(
        row["passed"] and not row["first_pass"] for row in rows
    ),
    "stop_reasons": dict(sorted(stop_reasons.items())),
}
(ROOT / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
print(json.dumps(summary, indent=2))
