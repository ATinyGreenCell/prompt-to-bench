#!/usr/bin/env python3
"""Make a merged Qwen3.5-9B fine-tune importable on the Tiiny box.

The box's app *Import Model* (HF URL, safetensors) gates on the repo's HF-COMPUTED metadata, not just
on config.json. A merge saved by a recent transformers (5.x) is rejected ("This architecture is not
supported yet") until the repo matches the STOCK base in three things:

  1. config.json schema -- recent transformers renames vision_config.model_type qwen3_5 -> qwen3_5_vision,
     torch_dtype -> dtype, and relocates rope params; the box's 4.57-era importer wants the stock schema.
  2. the stock file set  -- preprocessor_config.json, video_preprocessor_config.json, merges.txt, vocab.json.
  3. a model card        -- README.md YAML frontmatter (library_name: transformers, pipeline_tag:
     image-text-to-text, base_model) so HF computes pipeline_tag / transformersInfo.auto_model, which is
     what the importer ACTUALLY reads (the raw config alone is not enough -- verified twice, 2026-10-16).

A LoRA-merge changes weight VALUES, not architecture, so the stock base's config.json describes the
merged model exactly. This script verifies the merged tensor names match the stock index first, then
overwrites config.json, adds the stock aux files, and writes the model card. Idempotent.

usage: python box_import_fix.py MERGED_DIR [--base Qwen/Qwen3.5-9B] [--repo ATinyGreenCell/<name>] [--desc "..."]
then:  hf upload <repo> MERGED_DIR . --repo-type=model     # uses the laptop's cached HF token
"""
from __future__ import annotations
import argparse, json, sys, urllib.request, pathlib

STOCK_FILES = ["config.json", "preprocessor_config.json", "video_preprocessor_config.json",
               "merges.txt", "vocab.json"]


def fetch(base: str, name: str, timeout: int = 60) -> bytes:
    url = f"https://huggingface.co/{base}/raw/main/{name}"
    with urllib.request.urlopen(url, timeout=timeout) as r:
        return r.read()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("merged_dir")
    ap.add_argument("--base", default="Qwen/Qwen3.5-9B")
    ap.add_argument("--repo", default="", help="target HF repo id, only used to print the upload command")
    ap.add_argument("--desc", default="A LoRA fine-tune of Qwen3.5-9B for generating parametric "
                                      "OpenSCAD models of bio-lab hardware, for the Tiiny AI Pocket Lab.")
    a = ap.parse_args()
    d = pathlib.Path(a.merged_dir)
    if not d.is_dir():
        raise SystemExit(f"no such dir: {d}")

    # 1. verify the merged tensor names match the stock base, so the stock config.json is valid for it
    midx = list(d.glob("*.index.json"))
    if midx:
        mkeys = set(json.load(open(midx[0]))["weight_map"])
        try:
            bkeys = set(json.loads(fetch(a.base, "model.safetensors.index.json"))["weight_map"])
            miss, extra = bkeys - mkeys, mkeys - bkeys
            if miss or extra:
                print(f"WARN tensor-name mismatch vs stock (missing {len(miss)}, extra {len(extra)}): "
                      f"the stock config may not fit this merge", file=sys.stderr)
            else:
                print(f"OK tensor names match stock base ({len(mkeys)} tensors)")
        except Exception as e:  # noqa: BLE001
            print(f"(skipped tensor-name check: {type(e).__name__}: {e})", file=sys.stderr)

    # 2. overwrite config.json with the stock (4.57-schema) one and add the stock aux files
    for name in STOCK_FILES:
        try:
            (d / name).write_bytes(fetch(a.base, name))
            print(f"wrote {name}")
        except Exception as e:  # noqa: BLE001
            print(f"WARN could not fetch {name}: {e}", file=sys.stderr)

    # 3. model card -- the frontmatter is what makes HF compute pipeline_tag/transformersInfo
    repo_name = a.repo.split("/")[-1] if a.repo else d.parent.name
    (d / "README.md").write_text(
        "---\n"
        "library_name: transformers\n"
        "pipeline_tag: image-text-to-text\n"
        "license: apache-2.0\n"
        "base_model:\n"
        f"- {a.base}\n"
        "tags:\n- qwen3_5\n- openscad\n- code\n---\n\n"
        f"# {repo_name}\n\n{a.desc}\n\n"
        f"- Base: `{a.base}` (arch `Qwen3_5ForConditionalGeneration`); vision encoder preserved, "
        "language layers LoRA-merged to bf16 safetensors.\n"
        "- Run with reasoning/thinking **off**.\n")
    print("wrote README.md")

    # verify the config landed in the stock schema the importer accepts
    c = json.load(open(d / "config.json"))
    vmt = c.get("vision_config", {}).get("model_type")
    print(f"VERIFY: arch={c['architectures'][0]} vision_model_type={vmt} tf={c.get('transformers_version')}")
    print("IMPORT-READY" if vmt == "qwen3_5"
          else "WARN vision_model_type != qwen3_5 -- check the base id")
    if a.repo:
        print(f"\nNext:  hf upload {a.repo} {d} . --repo-type=model")


if __name__ == "__main__":
    main()
