# main-tiiny: the main protocol on a Tiiny AI Pocket Lab

The same protocol and harness as [`main`](../main/): 16 tasks, temperature 0.2, replies capped at 2,048 tokens, thinking requested off, and up to 2 repairs with `scadreport` feedback. The models run on a Tiiny AI Pocket Lab instead of the laptop CPU. The box is an NPU on USB-C, with 48 GB of NPU memory (47.9 GiB as the box reports it) and 31 GiB of host RAM, on
tiiny_os 0.1.35 when we first inspected it on 2026-10-14 (the build log; `box_*.json` does not record the version). It is reached through the tiinykit bridge, which makes the box look like an Ollama server (`OLLAMA_HOST=http://127.0.0.1:11435`, models named `tiiny/<store id>`).

- **Several samples per model.** The box ignores `seed` and is not reproducible even at temperature 0. Every model therefore gets more than one sample (`--samples`), and results should be reported per sample.
- **Vendor builds.** The models are the Tiiny store's builds, in a proprietary format. A result means "this device's build of model X". At the start of every pass, `box_*.json` records the model's store catalog entry (with the build's tag, manifest and version) and the load time. The first 9 passes, up to 2026-10-14 20:13, also record `tiiny info` (including the build date) and `tiiny status`; once the box was reached over Wi-Fi the vendor's command-line tool no longer found it, and those two fields say "No Tiiny device connected". The store's Qwen3.8 27B is a Turbo build (manifest `Qwen3.8-27B_turbo_20260819`: speculative decoding); no other model we ran is.
- **Timings.** Timings are measured on the laptop and include the link to the box. That link was USB-C until 2026-10-14 20:22. From then on the bridge reached the box over its Wi-Fi, and the cable was unplugged at 20:25. Qwen3.6-27B's first sample straddles the change. The `ollama` field in `meta_*.json` is the laptop's own Ollama version, forwarded by the bridge, not anything on the box.
- **Merged records.** Records finished before 2026-10-14 16:45 were first written to three scratch run folders: `tiiny-base`, `tiiny-coder-next` and `tiiny-gpt-oss-120b`. Their `meta_*.json` files still carry those names. That harness was a byte-identical copy of commit 44ff169 without git metadata, so its `git_commit` is empty.
- **Harness version.** Records from 2026-10-14 16:48 onwards come from the harness that was committed as 7a8ca5d at 17:21 (the 16:48 `meta_*.json` records it as 44ff169 with uncommitted changes), which never scores a reply the server broke off mid-stream. From 17:23 the sweep ran a frozen copy of `bench/` and `tools/` outside the repository, so that work on the repository could not change the protocol mid-run. That copy has no git metadata, so its `meta_*.json` show an empty `git_commit`. Its protocol files are byte-identical to 7a8ca5d, and `box_*.json` records their sha256 hashes.
- **Checker switch.** After the Qwen3.8-27B job of round 1, the frozen copy was replaced by commit c43e250. That commit has the hardened harness and the final checks of the third audit ([`meta/audits/2026-10-14_hardening.md`](../../../meta/audits/2026-10-14_hardening.md)).
  - Every earlier record was rescored with those checks (`rescore.py`, recorded in each changed record's `rescored` field).
  - The conversations whose pass did not survive were flagged `needs_rerun` and run again; the new record supersedes the old one.
    The reruns wrote their files over the old ones in `code/`, so the three superseded conversations survive only as
    their records: code hashes, render messages and the checks that failed.
  - From then on, the final checks also decide, inside the loop, when a model gets another try.
- **gpt-oss reasons regardless.** The gpt-oss models ignore the thinking-off request. Their records say `think: false`, but every reply carries reasoning (`thinking_chars`), and many end at the 2,048-token cap: all 96 attempts of gpt-oss-20b and 45 of gpt-oss-120b's 82.

- **Pauses and one change of order.** The sweep was stopped on 2026-10-16, after 02:08, during gpt-oss-20b's
  thinking-on job (which resumed with 3 conversations left), and restarted on 2026-10-18 at 02:36. Meanwhile the box ran
  the fine-tunes' tests (`scadcoder-box`, `scadcoder-box-3ep` and `scadcoder-3ep-nearmiss` on 2026-10-16; `box-v5`,
  `box-v5-k8`, `box-v6` and `box-v9` on 2026-10-17 and 18) and was out for most of a day, its model service
  answering HTTP 502 until the vendor's app was logged in again. On 2026-10-18 it paused again for `box-v10` (04:39-05:18),
  `box-v9s1` (16:10-16:45) and the h4-prompt run of Gemma 4 26B (19:12-20:53, [`box-gemma-h4`](../box-gemma-h4/)). Gemma's
  third sample was then moved to the front of the queue so that comparison could use three samples on each side
  ([`box-gemma-h0`](../box-gemma-h0/) is a copy of Gemma's records here). Other models' third samples were still queued
  when this folder was first published (v0.3.0, 2026-10-19). All times are the laptop's (US Eastern).
- **Redaction.** In the `box_*.json` files the box's private network address and the home-directory path are redacted
  (`[private-ip]`, `~`) by [`meta/redact_results.py`](../../../meta/redact_results.py), which applies the build log's
  patterns and changes nothing else.
