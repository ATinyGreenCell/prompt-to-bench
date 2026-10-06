# Prompt-to-Bench-16: benchmark

Sixteen biology-lab parts, described in words and numbers. A model writes OpenSCAD, OpenSCAD renders it, and hidden geometric checks decide whether the part matches the request. When it does not, the model gets feedback and another try.

## Files

| File | What it is |
|---|---|
| [`tasks.yaml`](tasks.yaml) | the 16 prompts and their hidden checks |
| [`prompts/system.md`](prompts/system.md) | the system prompt every model receives (also the tutorial's starter prompt) |
| [`prompts/translations.yaml`](prompts/translations.yaml) | the same prompts in Spanish, Hindi and Swahili |
| [`checks.py`](checks.py) | the checker (bbox, bodies, slices, probes, lines, arcs, volume; symmetry-aware) |
| [`build_refs.py`](build_refs.py) | renders the reference designs and validates the checker against them |
| [`reference_stats.json`](reference_stats.json) | reference volumes, slice areas and design-frame centres (generated) |
| [`run_bench.py`](run_bench.py) | runs models: Ollama (local) or `claude:<model>` via the Claude Code CLI |
| [`models.yaml`](models.yaml) | model metadata: sizes, parameters, licences |
| [`analyze.py`](analyze.py) | builds `results/summary.csv`, the figures and the README results blocks |
| `run_main_local.sh`, `run_lang.sh` | the exact commands used for the paper |
| `results/<run>/` | one JSON line per conversation, plus every generated `.scad` and raw reply |

## Quick start

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
.venv/bin/python bench/build_refs.py                  # sanity-check the checker (about 30 s)
ollama pull qwen2.5-coder:7b
.venv/bin/python bench/run_bench.py --run mytest --models qwen2.5-coder:7b --tasks tube_rack_1p5ml gel_comb_10well
.venv/bin/python bench/analyze.py --no-readme
```

You need OpenSCAD on your `PATH`. A development snapshot with the Manifold backend is strongly recommended, because CGAL renders of the 96-hole rack take minutes. You also need Ollama for local models.

## Protocol (as used in the paper)

- **Prompt:** the system prompt plus the task prompt.
  - Local models run at temperature 0.2 and top-p 0.95, with a fixed seed per attempt, an 8,192-token context and "thinking" switched off.
  - Replies are streamed and end at 2,048 tokens, at the first complete OpenSCAD code block, or when the model repeats itself verbatim.
- **Code extraction:** the longest fenced OpenSCAD block, or bare code if there is no fence.
- **Render:** OpenSCAD with the default Manifold backend and a 120 s timeout.
- **Feedback** (`--feedback report`, the default; up to `--max-repairs 2` rounds):
  - When the file did not render: OpenSCAD's messages.
  - When it rendered but failed: the generic `tools/scadreport.py` measurement report, which never mentions the hidden checks.
  - `--feedback generic` replaces the report with "it does not match the specification, try again", which measures how much the measurements themselves help.
- **Pass:** every check passes. We also record partial scores, failure stages, tokens and timings.

## Robustness

- **Runtime errors are never scored.** If Ollama or the Claude CLI fails (server restart, dropped connection, rate limit), the request is retried with back-off. If it still fails, the task is skipped *without* a record, so a later run picks it up. Three runtime errors in a row stop the run.
- **Resumable and crash-safe.** Each conversation is appended with `fsync`. A line damaged by a power cut is dropped on the next start and that task reruns. Run the same command again to resume.
- **One writer per run.** A lock file refuses a second `run_bench.py` on the same `--run` folder.
- **No sleep.** `run_main_local.sh` and `run_lang.sh` hold a `systemd-inhibit` lock (where available), so the laptop does not suspend mid-run.
- **Machine-independent.** Attempts that `include`/`use` an external library are flagged (`uses_library`), because their result depends on what is installed locally.
- `python bench/test_harness.py` (or `make test`) exercises all of the above with a fake model.

## Check types

A check is written in the *design frame*: the part as the prompt describes it, with its lowest point at z = 0. Candidates are normalised by bounding-box centre. The position-dependent checks are tried under the eight bed symmetries (90° rotations and mirroring), and the best match is kept.

| Check | Example | Meaning |
|---|---|---|
| `bbox` | `{size: [106, 72, 30], tol: 0.5}` | overall size (X and Y may be swapped) |
| `bodies` | `2` | number of separate solids |
| `volume` | `{rel_tol: 0.05}` | volume within 5% of the reference |
| `slice` | `{z: 15, islands: 1, holes: 24, hole_d: [11.2, 0.4], hole_grid: {...}}` | horizontal cross-section at height z |
| `probes` | `{solid: [[x,y,z]], empty: [[x,y,z]]}` | points that must be inside or outside material |
| `line` | `{z, from, to, intervals: 10, length: [5, 0.3]}` | count of solid stretches along a line (teeth, slots) |
| `arc` | `{z, center, r, gaps: 18}` | count of gaps around a circle (grip grooves) |

## Adding results from your machine

Run with a unique `--run` name and open a pull request with the `results/<run>/` folder. Add a note on your hardware to `meta_*.json`. See [CONTRIBUTING.md](../CONTRIBUTING.md).
