# think-tiiny: thinking on, 16,384-token replies, on a Tiiny AI Pocket Lab

An ablation of the main protocol, run on the same box as [`main-tiiny`](../main-tiiny/) (see its README for the device, bridge and provenance notes). It differs from the main protocol in two settings: thinking is requested **on** (`--think`), and replies may run to **16,384 tokens** (`--num-predict 16384`) instead of 2,048. Everything else is unchanged: 16 tasks, temperature 0.2, and up to 2 repairs with `scadreport` feedback.

The paper's main protocol asked for thinking off and capped replies at 2,048 tokens. That made it affordable on a laptop CPU, but it cut off most replies from models that reason first (§9 of the paper). This run measures what those models do with room to think.

- All records come from the frozen harness copy described in `main-tiiny`, at commit c43e250 (hardened harness, final checks).
- Ten of the store's twelve models that can reason: the gpt-oss models and Qwen3 30B-A3B Thinking, which always reason, and
  seven with a thinking switch. Ornith is one of the seven: none of its 90 thinking-off attempts in `main-tiiny` carried any
  reasoning. GLM-4.7-Flash is another: its catalog entry says thinking is not supported, yet none of its 96 thinking-off
  attempts carried reasoning and all 46 thinking-on replies did. Qwen3 8B, still queued at v0.3.0, ran later; the two dense 27B models (Qwen3.6 27B, Qwen3.8 27B) were not queued.
- The `meta_*.json` files record `num_ctx` 8192, the harness's default. The bridge ignores it (models get their full
  window), and thinking-on replies did reach the 16,384-token cap.
- Only the visible reply is kept in the conversation history. The reasoning is counted in `thinking_chars` but is not sent back on repair turns.
- A reply still ends at the first complete OpenSCAD block, at the cap, or when its visible text repeats itself. A loop inside the reasoning is bounded only by the cap.

- **Second samples, chosen after the first.** On 2026-10-19 second thinking-on samples were queued for the four models
  whose first sample here beat the better of their thinking-off samples then run (two each) by three tasks or more: gpt-oss-120b,
  Qwen3.6 35B-A3B, gpt-oss-20b and Qwen3 30B-A3B Thinking. Ornith (4 against 3 and 1) and GLM-4.7-Flash (1 against 0
  and 0) also beat both, by one task, and got no second sample. Because they were picked for a high first sample, their second sample is the unbiased
  estimate; expect some regression towards the thinking-off level. The other models have one sample. gpt-oss-120b's third
  thinking-off sample, which passed 7, came later, so its first thinking-on sample (8) now beats its best thinking-off
  sample by one task.
- **Final state (21 October 2026).** All 224 conversations had finished by 2026-10-21 13:31. The results are in Table 13
  of the paper. Records made before the v0.3.1 checker reached the sweep's frozen copy were re-checked with
  `rescore.py --only-open`, with no change.
