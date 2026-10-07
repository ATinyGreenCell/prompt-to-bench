# Contributing to Prompt to Bench

Thank you for helping. This repository is a *living paper*: [`README.md`](README.md) is the manuscript, and everything it reports can be rerun from this repository. You can contribute text, designs, benchmark tasks, model runs, translations or physical test prints.

## Ground rules

- **Never commit confidential material.** No client designs, unpublished collaborators' parts, patient or personal data, or anything you do not have the right to share under the licences below.
- **Be kind and constructive.** We follow the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Many contributors write in a second language; edit for clarity, never mock.
- **Disclose AI assistance.** Using AI tools is welcome; it is the subject of this paper. Say in your pull request what you used and for what. You are responsible for checking what you submit, especially references and numbers.
- **Cite primary sources.** Every new factual claim in the paper needs a reference that you have opened yourself. Give its DOI or URL and the date you accessed it.

## Ways to contribute

### 1. Run the benchmark on your hardware

This contribution helps the global-access question most: how do these models behave on *your* laptop, in *your* language?

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
ollama pull qwen2.5-coder:7b            # or any model from bench/models.yaml
.venv/bin/python bench/run_bench.py --run <your-handle>-<machine> --models qwen2.5-coder:7b
```

- Then open a pull request that adds `bench/results/<your-handle>-<machine>/`.
- Add a line to the run's `meta_*.json` describing your CPU, RAM, GPU (if any) and operating system.
- Please do not edit other people's results.

### 2. Add a model

1. Add an entry to [`bench/models.yaml`](bench/models.yaml) with its tag, family, parameter count, download size and licence (read the licence from the model card).
2. Run it as above.

### 3. Add a task from your lab

A good task is a part your lab prints, described the way a careful student would describe it. It needs three things:

- **A prompt** in [`bench/tasks.yaml`](bench/tasks.yaml). It gives every dimension in mm, the print orientation (which face is on the bed at z = 0), and coordinates wherever position matters. It must be checkable: avoid "nice", "ergonomic" or "about".
- **A reference design** in [`bench/reference/`](bench/reference/) that is exactly what the prompt asks for (and, if you like, a lab-ready version in [`designs/<category>/`](designs/)), following the design conventions below.
- **Checks** in the same YAML entry, using the check types in [`bench/checks.py`](bench/checks.py): `bbox`, `bodies`, `slice` (holes, sizes, grids, areas), `probes`, `line`, `arc` and `volume`. Write probe coordinates in the frame of your reference design.

Then run `python bench/build_refs.py --write` (this adds your task to `reference_stats.json`). Your reference must pass its own checks, still pass after rotation and mirroring, fail when scaled by 3%, and not pass any other task's checks. Add one or two plausible wrong versions to [`bench/mutants/`](bench/mutants/) (`<task>__<what is wrong>.scad`): they must fail.

### 4. Add or review a translation

[`bench/prompts/translations.yaml`](bench/prompts/translations.yaml) holds AI-drafted Spanish, Hindi and Swahili prompts. Native-speaker review is very welcome, and so are new languages. Keep every number, unit, axis name and coordinate unchanged. Use the vocabulary a student in your country would actually use.

### 5. Print and measure

Print a reference design and measure the critical features with calipers. Open an issue with:

- your printer, material and slicer settings;
- a photo;
- your measurements;
- whether it fit and worked.

Physical validation is the biggest gap in the current version of the paper.

### 6. Improve the paper or the tutorial

Typos, unclear sentences, missing references, better figures and translations of the [tutorial](tutorial/README.md) are all welcome.

## Design conventions (`designs/`)

- One part per file (or one print plate per file), in OpenSCAD, using **built-in modules only** so it runs on any OpenSCAD install.
- **Header comment:**
  - the title on the first line;
  - category, purpose, print settings and orientation, and any safety notes;
  - `// SPDX-License-Identifier: CERN-OHL-P-2.0`.
- **Parameters:**
  - Every dimension is a named variable at the top, in mm, with its description on the line above (that is where the Customizer reads it). Give decimal values a step, e.g. `hole_d = 11.6; // 0.1`.
  - Group them under `/* [Section] */` Customizer headings.
  - Put helper values under `/* [Hidden] */`.
- **Modelling:**
  - Model the part in print orientation: it rests on z = 0, needs no supports where possible, and is centred in XY unless the geometry says otherwise.
  - Cutters overshoot by `eps` so no faces are coplanar.
  - Set `$fn` for round holes.
  - Add `assert()` checks for parameter combinations that would break the part (holes overlapping, a floor or wall under 0.8 mm), and add a valid and an impossible case for your design to [`tools/check_designs.py`](tools/check_designs.py). Run `make designs`.
- **Repository hygiene:**
  - Commit only the `.scad` source.
  - STL and G-code files are build outputs (see `.gitignore`).

## Authorship

- Everyone who contributes is listed in the acknowledgements.
- A **substantial** contribution earns co-authorship on the next tagged version of the paper. Examples:
  - a new task with reference and validation;
  - a full benchmark run on new hardware or in a new language;
  - a reviewed translation of the prompts or tutorial;
  - physical validation of several designs;
  - a significant section of text.
- Authorship is discussed openly in the pull request.
- The corresponding author keeps the final list, following the [CRediT](https://credit.niso.org/) contributor roles.

## Licences

By contributing you agree that your contribution is released under the licence of the folder you contribute to:

- text and figures: CC BY 4.0;
- designs: CERN-OHL-P-2.0;
- code: MIT.

See [`LICENSE`](LICENSE).
