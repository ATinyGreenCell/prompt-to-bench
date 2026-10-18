
qwen3.5-9b: /home/seb/printpaper/bench/results/harness-search/hs_base.jsonl
| Harness | System prompt | Feedback | Descriptions | Pass, first attempt | Pass within three | First attempt renders | Feedback messages | File changed | Passes won by repair |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| h0 | system.md | report | 224 | 13 (6%) | 29 (13%) | 94 (42%) | 415 | 346 (83%) | 16 |
| h1 | system_idioms.md | report | 224 | 20 (9%) | 43 (19%) | 124 (55%) | 393 | 345 (88%) | 23 |
| h2 | system_examples.md | report | 224 | 33 (15%) | 56 (25%) | 143 (64%) | 364 | 327 (90%) | 23 |
| h3 | system.md | checklist | 224 | 14 (6%) | 31 (14%) | 82 (37%) | 408 | 325 (80%) | 17 |
| h4 | system_idioms_examples.md | checklist | 224 | 38 (17%) | 72 (32%) | 155 (69%) | 352 | 299 (85%) | 34 |
h1 vs h0 on 224 descriptions: only h1 passed 36, only h0 passed 22
h2 vs h0 on 224 descriptions: only h2 passed 42, only h0 passed 15
h3 vs h0 on 224 descriptions: only h3 passed 18, only h0 passed 16
h4 vs h0 on 224 descriptions: only h4 passed 56, only h0 passed 13
