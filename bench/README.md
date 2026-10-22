# Prompt-to-Bench-16: benchmark

Sixteen biology-lab parts, described in words and numbers. A model writes OpenSCAD, OpenSCAD renders it, and hidden geometric checks decide whether the part matches the request. When it does not, the model gets feedback and another try.

## Files

| File | What it is |
|---|---|
| [`tasks.yaml`](tasks.yaml) | the 16 prompts and their hidden checks |
| [`prompts/system.md`](prompts/system.md) | the system prompt every model receives (also the tutorial's starter prompt) |
| [`prompts/translations.yaml`](prompts/translations.yaml) | the same prompts in Spanish, Hindi and Swahili |
| [`checks.py`](checks.py) | the checker (bbox, bodies, slices, probes, lines, arcs, volume; symmetry-aware) |
| [`reference/`](reference/) | the 16 frozen answer keys (v1); the lab-ready parts in `designs/` have since diverged |
| [`build_refs.py`](build_refs.py) | renders the reference designs and validates the checker against them, against known-wrong parts in [`mutants/`](mutants/) (must fail) and against known-right parts in [`variants/`](variants/) (must pass) |
| [`rescore.py`](rescore.py) | re-checks every saved attempt of a run with the current checker and reports changed verdicts |
| [`reference_stats.json`](reference_stats.json) | reference volumes, slice areas and design-frame centres (generated) |
| [`run_bench.py`](run_bench.py) | runs models: Ollama (local), `claude:<model>` via the Claude Code CLI, and the small-model methods `template:<model>` and `features:<model>` (paper §6.6) |
| [`models.yaml`](models.yaml) | model metadata: sizes, parameters, licences |
| [`analyze.py`](analyze.py) | builds `results/summary.csv`, the figures and the README results blocks (with no options, exactly the paper's) |
| [`sample_stats.py`](sample_stats.py) | per-task pass statistics for multi-sample runs (`--samples 8`), merging a run split over `<run>-g0..g7` |
| [`finetune_table.py`](finetune_table.py) | the paper's Table 8: fine-tunes on the in-family / out-of-family split of the 16 tasks |
| [`repair_stats.py`](repair_stats.py) | how a model uses feedback: file changed, score rose, passes won by repair (§6.4) |
| [`self_consistency.py`](self_consistency.py) | picks one of k samples by agreement of the rendered parts' size and volume, no hidden checks (§6.4) |
| [`spec_select.py`](spec_select.py) | picks one of k samples by checking each rendered part against the numbers in its own request (sizes, hole diameters, counts), agreement as a tie-breaker; no hidden checks (§6.4) |
| [`harness_search.py`](harness_search.py) | compares harnesses (system prompt x feedback) on batch-C descriptions, scored against their reference files, never the 16 tasks (§6.4, Table 10) |
| [`ollama_openai_shim.py`](ollama_openai_shim.py) | an Ollama-API front for an OpenAI-compatible server (vLLM or llama-server), so `run_bench.py` can drive such models unchanged; `--grammar` adds grammar-constrained decoding (§6.6) |
| [`heldout/`](heldout/) | HO-16, sixteen more tasks written blind, with their references, known-wrong and known-right parts, a frozen copy of the harness and its runs (paper §5.6, §6.7) |
| [`smallmodels/`](smallmodels/) | the pre-registered tests of seven cheaper fixes for small models and the held-out analyses: [`PROTOCOL.md`](smallmodels/PROTOCOL.md), the methods and their summaries (paper §6.6, §6.7) |
| [`printcheck/`](printcheck/) | ten held-out parts to print and measure, with predictions written before printing |
| `run_main_local.sh`, `run_lang.sh` | the exact commands used for the paper |
| `results/<run>/` | one JSON line per conversation, plus every generated `.scad` and raw reply (a redone conversation's earlier files move to `code/<model>/superseded/`) |

## Quick start

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
.venv/bin/python bench/build_refs.py                  # sanity-check the checker (about 30 s)
ollama pull qwen2.5-coder:7b
.venv/bin/python bench/run_bench.py --run mytest --models qwen2.5-coder:7b --tasks tube_rack_1p5ml gel_comb_10well
.venv/bin/python bench/analyze.py --no-readme --runs mytest
```

You need OpenSCAD on your `PATH`. A development snapshot with the Manifold backend is strongly recommended, because CGAL renders of the 96-hole rack take minutes. You also need Ollama for local models.

## The held-out set and the small-model methods

```bash
sha256sum -c bench/heldout/FROZEN.sha256 bench/heldout/harness/HARNESS.sha256   # from the repo root
.venv/bin/python bench/heldout/build_refs_heldout.py                          # validate HO-16 (a few minutes)
.venv/bin/python bench/heldout/harness/bench/run_bench.py --run mytest-ho --models qwen2.5-coder:7b
.venv/bin/python bench/heldout/harness/bench/sample_stats.py mytest-ho
.venv/bin/python bench/smallmodels/r4_summary.py --pair r4-gemma26b-h4 r4-gemma26b-std --fisher r4-qwen38-scadfix r4-qwen38-std
.venv/bin/python bench/smallmodels/heldout_unblind.py                         # the per-task analyses of §6.7
.venv/bin/python bench/smallmodels/test_methods.py                            # method backends, scripted model
.venv/bin/python bench/run_bench.py --run mytest-tpl --models template:qwen2.5-coder:7b --tasks tube_rack_1p5ml
```

- The harness copy runs the held-out tasks with its own frozen `checks.py` and `tools/scadreport.py` from any folder,
  and writes to `bench/heldout/harness/bench/results/<run>/`.
- The frozen template library reads `finetune/seeds/` by an absolute path (`/home/seb/printpaper/finetune/seeds`).
  In a checkout anywhere else it loads no designs, so every `template:` conversation answers "none"; link that path
  to your checkout first.
- `r4_summary.py` with no options prints counts only; the options above add the pre-registered tests of §6.7.
  Method runs, their commands and their frozen hashes are listed in `smallmodels/PROTOCOL.md`. Several development
  scripts there (`dev_*`, `chain*`, `queue_*`) are records of the author's runs and use the author's paths.

## Protocol (as used in the paper)

- **Prompt:** the system prompt plus the task prompt.
  - Local models run at temperature 0.2 and top-p 0.95, with a fixed seed per attempt, an 8,192-token context and "thinking" requested off (LFM2.5 ignores the switch).
  - Replies are streamed and end at 2,048 tokens (1,024 for the Qwen2.5-Coder 3B and 7B runs, which never reached it), at the first complete OpenSCAD code block, or when the model repeats itself verbatim.
- **Code extraction:** the longest OpenSCAD-labelled fenced block; otherwise the longest fenced block of any label, the text after an unclosed fence, or the whole reply if it contains OpenSCAD calls. `<think>` reasoning is removed first.
- **Render:** OpenSCAD with the default Manifold backend and a 120 s timeout.
- **Feedback** (`--feedback report`, the default; up to `--max-repairs 2` rounds):
  - When the file did not render: OpenSCAD's messages.
  - When it rendered but failed: the generic `tools/scadreport.py` measurement report, which never mentions the hidden checks.
  - `--feedback generic` replaces the report with "it does not match the specification, try again", which measures how much the measurements themselves help.
  - `--feedback checklist` keeps the report and adds instructions: common causes of a parser error, a request to list every size and count of the specification beside the report's value before rewriting, and a note when the file came back unchanged. With `--system bench/prompts/system_idioms_examples.md` it is the h4 harness of §6.4; the paper's main results all use the default.
- **Pass:** every check passes. We also record partial scores, failure stages, tokens and timings.

## Robustness

- **Runtime errors are never scored.** If Ollama or the Claude CLI fails (server restart, dropped connection, rate limit, or an error event in the middle of a streamed reply), the request is retried with back-off, and a partial reply is discarded. If it still fails, the task is skipped *without* a record, so a later run picks it up. Three runtime errors in a row stop the run.
- **Resumable and crash-safe.** Each conversation is appended with `fsync`. A line damaged by a power cut is dropped on the next start and that task reruns. Run the same command again to resume.
- **One writer per run.** A lock file refuses a second `run_bench.py` on the same `--run` folder.
- **No sleep.** `run_main_local.sh` and `run_lang.sh` hold a `systemd-inhibit` lock (where available), so the laptop does not suspend mid-run.
- **Library use is flagged.** Attempts that `include`/`use` an external library are flagged (`uses_library`), because their result depends on what is installed locally.
- `.venv/bin/python bench/test_harness.py` (or `make test`) exercises all of the above with a fake model.
- **Resume keys ignore settings.** A run folder is resumed by (model, task, sample, language, feedback); use a new `--run` name when you change `--num-predict`, `--think` or the temperature.
- After any change to `checks.py` or `tasks.yaml`, run `.venv/bin/python bench/rescore.py <run> --dry-run` to see which verdicts would change, then without `--dry-run` to apply.

## Check types

A check is written in the *design frame*: the part as the prompt describes it, with its lowest point at z = 0. Candidates are normalised by bounding-box centre. The position-dependent checks are tried under the eight bed symmetries (90° rotations and mirroring), and the best match is kept. A task whose prompt leaves the azimuth free (the round knob) sets `rotation_step: 1` to try every 1° rotation as well.

| Check | Example | Meaning |
|---|---|---|
| `bbox` | `{size: [106, 72, 30], tol: 0.5}` | overall size (X and Y may be swapped) |
| `bodies` | `2` | number of separate solids; a sealed cavity counts, unless it is closed only by a floating-point skin (a cutter ending exactly at a face) |
| `volume` | `{rel_tol: 0.05}` | volume within 5% of the reference |
| `slice` | `{z: 15, islands: 1, holes: 24, hole_d: [11.2, 0.4], hole_grid: {...}}` | horizontal cross-section at height z; `hole_d` and `island_d` also require a round outline (its enclosing rectangle within 1.5 × tol of d) |
| `probes` | `{solid: [[x,y,z]], empty: [[x,y,z]]}` | points that must be inside or outside material |
| `line` | `{z, from, to, intervals: 10, length: [5, 0.3]}` | count of solid stretches along a line (teeth, slots) |
| `arc` | `{z, center, r, gaps: 18}` | count of gaps around a circle (grip grooves) |
| `bores` | `{z: [0.15, 19.85], grid: {nx: 12, ny: 8, px: 9, py: 9}}` or `{z, at: [[x, y]]}` | vertical passages: a ray up each one must not enter material between the two heights (a skin, plug or floor fails) |

## Adding results from your machine

Run with a unique `--run` name and open a pull request with the `results/<run>/` folder. Add a note on your hardware to `meta_*.json`. See [CONTRIBUTING.md](../CONTRIBUTING.md).
