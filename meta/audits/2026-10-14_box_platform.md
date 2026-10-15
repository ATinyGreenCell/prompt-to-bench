# Verification: the NPU box as a closed platform

**Snapshot.** 14 October 2026, ~21:00, while the Tiiny NPU-box sweep was running (reached over
Wi-Fi; see [`bench/results/main-tiiny/README.md`](../../bench/results/main-tiiny/README.md)).

**Why.** A reader asked whether open models outside the vendor's store could be run on the box,
and whether a small model could be trained on it directly. This note records what we can and
cannot defend about the box as a platform, so the one-line limitation in the paper (§9) is
backed by evidence and honest about its confidence. Everything here was gathered with read-only
management/discovery calls that do not touch the NPU or the running sweep; we did not open the
appliance, obtain any vendor SDK, or attempt an import. As with the other audits, this was done
by Claude, not independent review.

## Claims, by confidence

### Device-reported (high confidence — the box said so, this unit, today)

- **It is a sealed appliance with a fixed interface.** You reach it over HTTP: an
  OpenAI-/Anthropic-/Ollama-compatible inference API and a management API, plus the vendor CLI's
  `download` / `import` / `load` / `unload`. The box runs its own OS (TiinyOS); from a plain Linux
  host only connection management is exposed, not a shell or general compute (our own setup notes,
  `~/tiny/PLAYBOOK.md`, and the toolkit README). A TCP port scan of the box (14 Oct 2026) found only
  port 80 (the HTTP API) and 39218 (discovery) open — no SSH, telnet or other login service — so
  there is no network path to run arbitrary code on either processor, which also rules out training
  on the host SoC. (The discrete NPU cannot train regardless: its toolchains are offline,
  inference-only.)
- **Two compute-and-memory domains.** `tiiny status` reports separate `NPU-COMPUTE` and `SOC`
  utilisation meters and a `NPU-RAM` pool (47.9 GiB) distinct from host `RAM` (31.1 GiB), over
  ~870 GB of disk. So the box is a host SoC plus a discrete accelerator with its own memory, not a
  single chip.
- **Every model in use is a vendor build.** `tiiny ls` lists 27 models, each tagged `Source:
  Store`; none were imported. The catalog spans many architectures (Qwen, Gemma, GLM, gpt-oss,
  Tencent, DeepReinforce), all compiled by the vendor.
- **The store builds are quantised.** `tiiny info` gives the dense 27B model (Qwen3.6-27B) as
  14.5 GiB on disk.
- **An import path exists.** `tiiny import <hugging_face_url>` is a documented command that takes a
  Hugging Face model.

### Inferred from the above (medium confidence)

- **~4 bits per weight.** 14.5 GiB for a dense 27B model is about 4.3 bits/parameter (a multimodal
  model carries a vision encoder and embeddings too, so this is approximate). Consistent with an
  int4-class NPU, not with 1-bit/ternary or full precision.
- **The large LLMs run on the discrete accelerator**, not the host SoC: they consume `NPU-RAM` and
  move the `NPU-COMPUTE` meter (e.g. the 27B model at ~48% during the sweep).

### Third-party / ecosystem (low confidence — flagged wherever used)

- **Silicon identity.** A teardown-from-photos analysis (bay41; Habr) reports the host SoC as a
  CIX CD8180 (P1)-class Armv9.2 part with a small built-in NPU, and the discrete accelerator as a
  VeriSilicon VIP9400-class M.2 card. **Not vendor-confirmed**, and the advertised TOPS figures
  conflict across sources, so no TOPS number is relied on here. The device's two-domain behaviour
  (above) is consistent with this account but does not prove the exact part numbers.
- **Toolchains for that silicon family.** For the CIX SoC, a neural compiler (the "Zhouyi"/NOE
  toolchain, producing a `.cix` graph) is semi-public via the Radxa Orion O6, which uses the same
  SoC. For the VeriSilicon accelerator, the model-conversion toolkit (ACUITY, producing an NBG
  blob) is proprietary/licensed; its open subset (ACUITYLite, TIM-VX) targets the older VIP9000
  series and vision/CNN workloads, with supported quantisation of int8/int16/bf16 and **no public
  precedent for 27B-class LLMs**. We did not obtain or run either toolchain; these describe the
  vendor/ecosystem tools for the silicon *family*, not this box.
- **Import boundary.** Our setup notes record that the accepted imports were fine-tunes of two base
  architectures already in the store (a text model, Qwen3.5-9B, and an image model, Z-Image-Turbo),
  safetensors only, no GGUF. This is **not vendor-documented** (a web search found no official page,
  and `tiiny import --help` states no limits), and we did not exhaustively map the boundary.

## The two questions

**Can you run an arbitrary open model (e.g. a new architecture, or a ternary build like Bonsai)?**
Not at full speed without the vendor. The fast accelerator runs vendor-pre-compiled graphs; the
appliance exposes no general code execution, and its documented on-ramp for your own weights is the
narrow `import` path above. Two hard ceilings hold regardless of any toolchain: the accelerator's
quantisation support excludes 1-bit/ternary (so a Bonsai-style build cannot keep its format), and a
model needing more than ~48 GiB of NPU memory does not fit (so a ~90 GB-class model is out). Even
setting the appliance boundary aside, reproducing the vendor's LLM path on the VeriSilicon part has
no public precedent and would be a reverse-engineering/bring-up project, not a repack.

**Can you train a small model on the box directly?** No, not usefully. Both relevant toolchains are
*offline, inference-only*: you bring an already-trained model and convert it; neither exposes
gradients, an optimiser, or backprop on the NPU. The host SoC is a general Arm CPU that could in
principle train a tiny model, but the appliance offers no way to run such a job on it, and a
~12-core Arm CPU would be slower than the author's laptop anyway. The supported route is to train
elsewhere (e.g. a rented GPU) and `import` a fine-tune of a supported base; the box's useful role in
a training workflow is generating synthetic data and serving as the deployment target.

## What went into the paper

A single bullet in §9 (Limitations): the NPU-box tier is a closed platform — the set of runnable
models is vendor-gated, you cannot run arbitrary open weights or train on it, and box-tier results
are therefore "this device's vendor build of model X" (already noted in the box results README).
The specifics and confidence tiers stay here rather than in the paper body.

## Fine-tune feasibility and import de-risk

> **RESULT (2026-10-15): `tiiny import` does NOT accept language models — box deployment of a custom
> LLM is impossible on this firmware.** A direct test, `tiiny import https://huggingface.co/Qwen/Qwen3.5-9B-Base`
> (same architecture as the store's Qwen3.5-9B, a different repo id so no store collision), failed
> immediately at the metadata stage, before any download:
> `Model architecture Qwen3_5ForConditionalGeneration is not supported. Supported architectures are
> ErnieImagePipeline, Flux2KleinPipeline, ZImagePipeline. (MODEL_ARCHITECTURE_UNSUPPORTED)` — all
> three are image-generation pipelines. So `import` is for image models only; LLMs reach the box
> only through the vendor's store (compiled internally). **This corrects an earlier setup note (and
> an earlier draft of this file) that claimed `import` accepts Qwen3.5-9B fine-tunes — it does not.**
> A fine-tuned OpenSCAD model can still be deployed on a **laptop** (Ollama/GGUF); the box's role is
> a benchmark tier and, optionally, a (slow) data generator. The box was left untouched (the import
> rejected before downloading).

The rest of this section is the pre-test plan, kept for the record; its import-acceptance assumption
is now disproven by the result above.

### What we confirmed (read-only)

- **The box's `Qwen/Qwen3.5-9B` is the public multimodal model**
  ([Hugging Face](https://huggingface.co/Qwen/Qwen3.5-9B), Apache-2.0): text+image input, a vision
  encoder, a Gated DeltaNet + gated-attention hybrid (32 layers, 4096 hidden), ~262k context,
  5.7 GiB on the box (so quantised). A real, fine-tunable base exists.
- **`tiiny import` has no dry-run/validate mode** (flags: `-d/--description`, `--json`, `-y`,
  `--device-address`). Testing the import path therefore *means running it on the box*: it downloads
  the model to the box over its Wi-Fi and compiles it on-device, so it contends with the sweep.
- **Disk headroom:** 402 / 870 GiB used, ~468 GiB free — ample for an ~18 GiB base plus compile
  artifacts. Clean up test models with `tiiny rm`.

### Edge cases to design around

- **Base identity (the big one).** The box's Qwen3.5-9B is *multimodal and hybrid-attention*, not a
  vanilla text transformer. (a) Fine-tuning is more involved than a plain LoRA: target the language
  path, keep the vision tower, and pick LoRA targets that fit DeltaNet/gated-attention, not the
  usual q/k/v/o assumption. (b) The import blob must keep the full multimodal architecture or import
  may reject/mis-compile it.
- **Not the laptop's model.** The paper's laptop run used `qwen3.5:9b` (Ollama GGUF, listed 9.65B,
  text-only path). Whether that is the *same base* as the box's multimodal build is unconfirmed, so
  the "one fine-tune deploys to both laptop and box" idea is **not** safe to assume — confirm the
  bases match before promising a single artifact; otherwise it is two targets.
- **Does import accept *modified* weights?** The whole plan rests on this. Import may checksum or
  allowlist against the exact stock repo and refuse any change, or restrict by HF owner. Untested.
- **Compile re-quantises.** The box compiles to its own ~int4-class format, so a fine-tune's quality
  on the box can differ from its bf16 GPU eval — evaluate **on the box**, not only on the GPU.
- **Benchmark contamination.** Hold the 16 tasks and `bench/variants/` out of all training data.
- **Tokenizer/chat-template drift**, **licensing/provenance of synthetic data**, and **rollback**
  (every spike model removable with `tiiny rm`, reclaiming disk and NPU).

### Staged de-risk (cheapest first; all need a box window, not mid-sweep)

- **Stage A — happy path.** `tiiny import https://huggingface.co/Qwen/Qwen3.5-9B` (stock). Does it
  accept, compile and appear in `tiiny ls`? Record compile time and what it loads. Needs only the
  box + the URL — no GPU, no HF account.
- **Stage B — the real question.** Import a weight-modified copy of that base (a trivial CPU-only
  perturbation is enough to test acceptance; no training needed). Requires uploading the copy to a
  Hugging Face account (so: the user's HF account + consent, ~18 GiB up/down). Establishes whether a
  fine-tune is importable at all.
- **Stage C — runs.** `load` the imported model, one prompt through the bridge, confirm sane output,
  then `tiiny rm`. The `load` step uses the NPU, so it must be in a sweep gap or after the sweep.

### Constraints / what's needed from the user

- **A box window.** Import+load contends with the sweep (could fail a sweep task for non-model
  reasons). Run Stage A/C either after the sweep or during a deliberate pause (`touch STOP` at a job
  boundary, spike, `tiiny rm`, resume — the `guard_restart.sh` pattern).
- **A Hugging Face account** for Stage B (and later to host the real fine-tune).
- **A rented GPU** for the actual fine-tune (the laptop is CPU-only); the de-risk stages A/C do not
  need one.

## Sources

- CIX P1 / NOE toolchain, via the Radxa Orion O6 (same SoC): [Radxa CIX SDK build docs](https://docs.radxa.com/en/orion/o6/low-level-dev/cix-sdk/build); [NOE `.cix` format note](https://readme.hex.pm/cix_p1_tpu/0.1.1); [CIX P1 developer guides](https://www.cnx-software.com/news/software-development-kit/?amp=1).
- VeriSilicon accelerator toolchain: [VIP9400 IP page](https://verisilicon.com/cn/IPPortfolio/VivanteVIP9400); [ACUITYLite (open subset)](https://github.com/VeriSilicon/acuitylite); [Vivante/ACUITY SDK guide (VIP9000-series)](https://docs.radxa.com/en/cubie/a7a/app-dev/npu-dev/cubie-acuity-sdk).
- Ternary example referenced in discussion: [Bonsai model family](https://www.llmreference.com/model-family/bonsai).
- Silicon identity: third-party teardown analysis (bay41; Habr), not vendor-confirmed — no stable URL recorded.
