#!/usr/bin/env python3
"""Pinned Chinese geometry-semantics review anchors for the original 16 tasks.

This rejects high-risk wording reversals which do not change numeric tokens:
blind vs. through holes, print orientation, openings and assembly clearance.

Anchors are manually selected against the current translated source. They
are a regression guard, NOT an independent certified translation or a model
evaluation. A legitimate revised translation may require bilingual review
and corresponding updates to these anchors.
"""
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[2]

# Every baseline task has two or more independent, task-specific physical
# semantics that must remain visible in its Chinese prompt. These are not
# scores, structural classifier predictions, or an automatic translator.
REQUIRED = {
    "tube_rack_1p5ml": ("盲孔", "顶部开口", "底部封闭"),
    "conical_rack_50ml": ("倒置", "通孔", "两面支撑墙", "翻转"),
    "slide_drying_rack": ("竖立", "平行槽", "顶部敞开"),
    "pcr_tube_rack_sbs": ("通孔", "倒角", "方向标识"),
    "gel_comb_10well": ("梳背", "梳齿", "间隙"),
    "micropestle_1p5ml": ("锥台", "球体", "环形凹槽"),
    "lab_funnel_60mm": ("顶部和底部都必须敞开", "中心通道"),
    "seed_sowing_template": ("通孔阵列", "矩形缺口", "方向"),
    "dshaft_knob_6mm": ("D 形盲孔", "防滑槽", "指针槽"),
    "pcr_tube_adapter": ("倒置", "直通孔", "两端均敞开"),
    "hose_barb_reducer_8_5": ("旋转对称", "通孔", "锯齿形轮廓"),
    "rod_tubing_clip": ("卡扣式", "开口圆环", "不得阻塞"),
    "stirrer_fan_housing": ("倒扣", "封闭的顶板", "敞开"),
    "nema17_motor_bracket": ("通孔", "竖直电机安装板", "三角形加强筋"),
    "enclosure_box_and_lid": ("两件式", "开口", "装配间隙"),
    "mini_gel_tank": ("缓冲液腔室", "上方连通", "水平通孔"),
}


def audit_semantics(translations):
    """Return human-readable missing anchors; don't silently accept missing IDs."""
    zh = translations.get("zh")
    if not isinstance(zh, dict):
        raise ValueError("Missing zh translations dictionary")
    problems = []
    for task_id, anchors in REQUIRED.items():
        text = zh.get(task_id, "")
        if not isinstance(text, str):
            text = ""
        for anchor in anchors:
            if anchor not in text:
                problems.append(f"{task_id}: missing semantic anchor {anchor!r}")
    return problems


def main():
    data = yaml.safe_load((ROOT / "bench/prompts/translations.yaml").read_text(encoding="utf-8"))
    problems = audit_semantics(data)
    for p in problems:
        print("FAIL", p, file=sys.stderr)
    print(f"zh semantic-review anchors: {len(REQUIRED)} task IDs, "
          f"{sum(map(len, REQUIRED.values()))} anchors, {len(problems)} defects")
    if problems:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
