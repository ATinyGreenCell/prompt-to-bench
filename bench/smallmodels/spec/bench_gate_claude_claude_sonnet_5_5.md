# Spec gate on the 16 tasks: writer claude:claude-sonnet-5-5

Accepts 15/16 reference parts.

- tube_rack_1p5ml: accepts
- conical_rack_50ml: accepts
- slide_drying_rack: accepts
- pcr_tube_rack_sbs: accepts
- gel_comb_10well: accepts
- micropestle_1p5ml: accepts
- lab_funnel_60mm: accepts
- seed_sowing_template: accepts
- dshaft_knob_6mm: accepts
- pcr_tube_adapter: accepts
- hose_barb_reducer_8_5: accepts
- rod_tubing_clip: REJECTS: 0 round holes of 12.7 mm vs 1; 0 round holes of 6 mm vs 1
- stirrer_fan_housing: accepts
- nema17_motor_bracket: accepts
- enclosure_box_and_lid: accepts
- mini_gel_tank: accepts

All saved local attempts: 2883, right 166; the gate accepts 410, of them right 0.38 (precision), right parts accepted 0.95 (recall).

| Run | Model | First attempts | right | gate accepts | of them right | right accepted |
|---|---|---:|---:|---:|---:|---:|
| main | gemma4:e2b-it-q4_K_M | 16 | 0 | 2 | 0.00 | nan |
| main | gemma4:e4b-it-q4_K_M | 16 | 0 | 1 | 0.00 | nan |
| main | granite4.2:3b | 16 | 0 | 0 | nan | nan |
| main | lfm2.5:8b-a1b-q4_K_M | 16 | 0 | 0 | nan | nan |
| main | llama3.2:3b | 16 | 0 | 0 | nan | nan |
| main | ministral-3:3b | 16 | 0 | 0 | nan | nan |
| main | qwen2.5-coder:0.5b | 16 | 0 | 0 | nan | nan |
| main | qwen2.5-coder:1.5b | 16 | 0 | 0 | nan | nan |
| main | qwen2.5-coder:3b | 16 | 0 | 1 | 0.00 | nan |
| main | qwen2.5-coder:7b | 16 | 0 | 0 | nan | nan |
| main | qwen2.5:1.5b | 16 | 0 | 0 | nan | nan |
| main | qwen3.5:2b-q4_K_M | 16 | 0 | 0 | nan | nan |
| main | qwen3.5:4b-q4_K_M | 16 | 0 | 0 | nan | nan |
| main | qwen3.5:9b-q4_K_M | 16 | 0 | 0 | nan | nan |
| main-bonsai | bonsai2-27b-pq2_0 | 16 | 0 | 1 | 0.00 | nan |
| ft-scad | scadcoder | 16 | 0 | 0 | nan | nan |
| base-scad | qwen2.5-coder:7b | 16 | 0 | 0 | nan | nan |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Instruct | 32 | 2 | 6 | 0.33 | 1.00 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking | 32 | 0 | 0 | nan | nan |
| main-tiiny | tiiny/Qwen/Qwen3-4B-Instruct-2507 | 32 | 0 | 0 | nan | nan |
| main-tiiny | tiiny/Qwen/Qwen3-8B | 32 | 0 | 2 | 0.00 | nan |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct | 32 | 0 | 2 | 0.00 | nan |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-Next | 32 | 3 | 6 | 0.33 | 0.67 |
| main-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B | 32 | 1 | 2 | 0.50 | 1.00 |
| main-tiiny | tiiny/Qwen/Qwen3.5-9B | 32 | 0 | 2 | 0.00 | nan |
| main-tiiny | tiiny/Qwen/Qwen3.6-27B | 32 | 6 | 16 | 0.38 | 1.00 |
| main-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B | 32 | 1 | 7 | 0.14 | 1.00 |
| main-tiiny | tiiny/Qwen/Qwen3.8-27B | 32 | 5 | 6 | 0.83 | 1.00 |
| main-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B | 32 | 3 | 9 | 0.33 | 1.00 |
| main-tiiny | tiiny/google/gemma-4-26B-A4B-it | 48 | 9 | 16 | 0.56 | 1.00 |
| main-tiiny | tiiny/openai/gpt-oss-120b | 32 | 6 | 6 | 1.00 | 1.00 |
| main-tiiny | tiiny/openai/gpt-oss-20b | 32 | 0 | 0 | nan | nan |
| main-tiiny | tiiny/zai-org/GLM-4.7-Flash | 32 | 0 | 4 | 0.00 | nan |
| think-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking | 16 | 0 | 1 | 0.00 | nan |
| think-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B | 16 | 1 | 2 | 0.50 | 1.00 |
| think-tiiny | tiiny/Qwen/Qwen3.5-9B | 16 | 1 | 2 | 0.50 | 1.00 |
| think-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B | 32 | 8 | 11 | 0.73 | 1.00 |
| think-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B | 16 | 2 | 6 | 0.33 | 1.00 |
| think-tiiny | tiiny/google/gemma-4-26B-A4B-it | 16 | 8 | 9 | 0.89 | 1.00 |
| think-tiiny | tiiny/openai/gpt-oss-120b | 32 | 5 | 10 | 0.50 | 1.00 |
| think-tiiny | tiiny/openai/gpt-oss-20b | 29 | 4 | 4 | 0.75 | 0.75 |
| think-tiiny | tiiny/zai-org/GLM-4.7-Flash | 16 | 1 | 3 | 0.33 | 1.00 |
| box-gemma-h4 | tiiny/google/gemma-4-26B-A4B-it | 48 | 22 | 30 | 0.70 | 0.95 |

Cascade (per sample of 16 tasks; escalated tasks take the hosted model's saved outcome):

| Run | Model (samples) | Check | Kept, right | Kept, wrong | Sent to hosted | of them cut short | Right in the end, Sonnet 5.5 | Haiku 4.5 |
|---|---|---|---:|---:|---:|---:|---:|---:|
| main | gemma4:e2b-it-q4_K_M (1) | render | 0 | 12 | 4 | 0 | 4 | 2 |
| main | gemma4:e2b-it-q4_K_M (1) | spec | 0 | 2 | 14 | 0 | 14 | 12 |
| main | gemma4:e2b-it-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | gemma4:e4b-it-q4_K_M (1) | render | 0 | 11 | 5 | 0 | 5 | 4 |
| main | gemma4:e4b-it-q4_K_M (1) | spec | 0 | 2 | 14 | 0 | 14 | 12 |
| main | gemma4:e4b-it-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | granite4.2:3b (1) | render | 0 | 5 | 11 | 0 | 11 | 9 |
| main | granite4.2:3b (1) | spec | 0 | 1 | 15 | 0 | 15 | 13 |
| main | granite4.2:3b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | lfm2.5:8b-a1b-q4_K_M (1) | render | 0 | 0 | 16 | 0 | 16 | 14 |
| main | lfm2.5:8b-a1b-q4_K_M (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | lfm2.5:8b-a1b-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | llama3.2:3b (1) | render | 0 | 10 | 6 | 0 | 6 | 6 |
| main | llama3.2:3b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | llama3.2:3b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | ministral-3:3b (1) | render | 0 | 2 | 14 | 0 | 14 | 13 |
| main | ministral-3:3b (1) | spec | 0 | 1 | 15 | 0 | 15 | 13 |
| main | ministral-3:3b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:0.5b (1) | render | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:0.5b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:0.5b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:1.5b (1) | render | 0 | 1 | 15 | 0 | 15 | 13 |
| main | qwen2.5-coder:1.5b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:1.5b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:3b (1) | render | 0 | 3 | 13 | 0 | 13 | 11 |
| main | qwen2.5-coder:3b (1) | spec | 0 | 1 | 15 | 0 | 15 | 13 |
| main | qwen2.5-coder:3b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:7b (1) | render | 0 | 1 | 15 | 0 | 15 | 13 |
| main | qwen2.5-coder:7b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5-coder:7b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5:1.5b (1) | render | 0 | 2 | 14 | 0 | 14 | 13 |
| main | qwen2.5:1.5b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen2.5:1.5b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:2b-q4_K_M (1) | render | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:2b-q4_K_M (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:2b-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:4b-q4_K_M (1) | render | 0 | 1 | 15 | 0 | 15 | 13 |
| main | qwen3.5:4b-q4_K_M (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:4b-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main | qwen3.5:9b-q4_K_M (1) | render | 0 | 2 | 14 | 0 | 14 | 12 |
| main | qwen3.5:9b-q4_K_M (1) | spec | 0 | 2 | 14 | 0 | 14 | 12 |
| main | qwen3.5:9b-q4_K_M (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-bonsai | bonsai2-27b-pq2_0 (1) | render | 0 | 4 | 12 | 0 | 12 | 11 |
| main-bonsai | bonsai2-27b-pq2_0 (1) | spec | 2 | 1 | 13 | 0 | 15 | 14 |
| main-bonsai | bonsai2-27b-pq2_0 (1) | oracle | 2 | 0 | 14 | 0 | 16 | 14 |
| ft-scad | scadcoder (1) | render | 0 | 14 | 2 | 0 | 2 | 1 |
| ft-scad | scadcoder (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| ft-scad | scadcoder (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| base-scad | qwen2.5-coder:7b (1) | render | 0 | 1 | 15 | 0 | 15 | 13 |
| base-scad | qwen2.5-coder:7b (1) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| base-scad | qwen2.5-coder:7b (1) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Instruct (2) | render | 1 | 9 | 6 | 0 | 7 | 6 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Instruct (2) | spec | 1 | 3.5 | 11.5 | 0 | 12.5 | 10.5 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Instruct (2) | oracle | 1 | 0 | 15 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (2) | render | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (2) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-4B-Instruct-2507 (2) | render | 0 | 3.5 | 12.5 | 0 | 12.5 | 11 |
| main-tiiny | tiiny/Qwen/Qwen3-4B-Instruct-2507 (2) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-4B-Instruct-2507 (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-8B (2) | render | 0 | 2.5 | 13.5 | 0 | 13.5 | 11.5 |
| main-tiiny | tiiny/Qwen/Qwen3-8B (2) | spec | 0 | 1 | 15 | 0 | 15 | 13 |
| main-tiiny | tiiny/Qwen/Qwen3-8B (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct (2) | render | 0 | 5.5 | 10.5 | 0 | 10.5 | 8.5 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct (2) | spec | 0 | 1.5 | 14.5 | 0 | 14.5 | 12.5 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-Next (2) | render | 1.5 | 12.5 | 2 | 0 | 3.5 | 3 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-Next (2) | spec | 2 | 3.5 | 10.5 | 0.5 | 12.5 | 10.5 |
| main-tiiny | tiiny/Qwen/Qwen3-Coder-Next (2) | oracle | 3 | 0 | 13 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (2) | render | 0.5 | 4.5 | 11 | 0 | 11.5 | 10 |
| main-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (2) | spec | 1 | 0.5 | 14.5 | 0 | 15.5 | 13.5 |
| main-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (2) | oracle | 1 | 0 | 15 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3.5-9B (2) | render | 0 | 7.5 | 8.5 | 0 | 8.5 | 7 |
| main-tiiny | tiiny/Qwen/Qwen3.5-9B (2) | spec | 0.5 | 1.5 | 14 | 0 | 14.5 | 12.5 |
| main-tiiny | tiiny/Qwen/Qwen3.5-9B (2) | oracle | 0.5 | 0 | 15.5 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3.6-27B (2) | render | 3 | 12.5 | 0.5 | 0 | 3.5 | 3.5 |
| main-tiiny | tiiny/Qwen/Qwen3.6-27B (2) | spec | 4 | 6.5 | 5.5 | 0 | 9.5 | 9.5 |
| main-tiiny | tiiny/Qwen/Qwen3.6-27B (2) | oracle | 5.5 | 0 | 10.5 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | render | 0.5 | 8 | 7.5 | 0 | 8 | 7 |
| main-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | spec | 0.5 | 4 | 11.5 | 0 | 12 | 10.5 |
| main-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | oracle | 1.5 | 0 | 14.5 | 0 | 16 | 14 |
| main-tiiny | tiiny/Qwen/Qwen3.8-27B (2) | render | 3.5 | 2 | 10.5 | 0 | 14 | 13.5 |
| main-tiiny | tiiny/Qwen/Qwen3.8-27B (2) | spec | 4 | 1 | 11 | 0 | 15 | 14.5 |
| main-tiiny | tiiny/Qwen/Qwen3.8-27B (2) | oracle | 4 | 0 | 12 | 0 | 16 | 15 |
| main-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (2) | render | 1.5 | 10 | 4.5 | 0 | 6 | 6 |
| main-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (2) | spec | 2 | 4.5 | 9.5 | 0 | 11.5 | 10.5 |
| main-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (2) | oracle | 2 | 0 | 14 | 0 | 16 | 14 |
| main-tiiny | tiiny/google/gemma-4-26B-A4B-it (3) | render | 3.67 | 12.33 | 0 | 0 | 3.67 | 3.67 |
| main-tiiny | tiiny/google/gemma-4-26B-A4B-it (3) | spec | 8 | 4.67 | 3.33 | 0.67 | 11.33 | 11.33 |
| main-tiiny | tiiny/google/gemma-4-26B-A4B-it (3) | oracle | 9.33 | 0 | 6.67 | 0 | 16 | 15.33 |
| main-tiiny | tiiny/openai/gpt-oss-120b (2) | render | 4.5 | 2.5 | 9 | 0 | 13.5 | 12.5 |
| main-tiiny | tiiny/openai/gpt-oss-120b (2) | spec | 4 | 0.5 | 11.5 | 0.5 | 15.5 | 14 |
| main-tiiny | tiiny/openai/gpt-oss-120b (2) | oracle | 4.5 | 0 | 11.5 | 0 | 16 | 14.5 |
| main-tiiny | tiiny/openai/gpt-oss-20b (2) | render | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/openai/gpt-oss-20b (2) | spec | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/openai/gpt-oss-20b (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| main-tiiny | tiiny/zai-org/GLM-4.7-Flash (2) | render | 0 | 13.5 | 2.5 | 0 | 2.5 | 2.5 |
| main-tiiny | tiiny/zai-org/GLM-4.7-Flash (2) | spec | 0 | 2.5 | 13.5 | 0 | 13.5 | 12 |
| main-tiiny | tiiny/zai-org/GLM-4.7-Flash (2) | oracle | 0 | 0 | 16 | 0 | 16 | 14 |
| think-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (1) | render | 1 | 2 | 13 | 0 | 14 | 12 |
| think-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (1) | spec | 2 | 1 | 13 | 0 | 15 | 13 |
| think-tiiny | tiiny/Qwen/Qwen3-30B-A3B-Thinking (1) | oracle | 3 | 0 | 13 | 0 | 16 | 14 |
| think-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (1) | render | 1 | 4 | 11 | 0 | 12 | 11 |
| think-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (1) | spec | 2 | 1 | 13 | 0 | 15 | 14 |
| think-tiiny | tiiny/Qwen/Qwen3.5-35B-A3B (1) | oracle | 2 | 0 | 14 | 0 | 16 | 14 |
| think-tiiny | tiiny/Qwen/Qwen3.5-9B (1) | render | 1 | 10 | 5 | 0 | 6 | 5 |
| think-tiiny | tiiny/Qwen/Qwen3.5-9B (1) | spec | 1 | 5 | 10 | 0 | 11 | 10 |
| think-tiiny | tiiny/Qwen/Qwen3.5-9B (1) | oracle | 1 | 0 | 15 | 0 | 16 | 14 |
| think-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | render | 4.5 | 8.5 | 3 | 0 | 7.5 | 7.5 |
| think-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | spec | 4.5 | 4.5 | 7 | 0 | 11.5 | 11 |
| think-tiiny | tiiny/Qwen/Qwen3.6-35B-A3B (2) | oracle | 5.5 | 0 | 10.5 | 0 | 16 | 15.5 |
| think-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (1) | render | 2 | 7 | 7 | 0 | 9 | 9 |
| think-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (1) | spec | 3 | 4 | 9 | 0 | 12 | 11 |
| think-tiiny | tiiny/deepreinforce-ai/Ornith-1.0-35B (1) | oracle | 4 | 0 | 12 | 0 | 16 | 15 |
| think-tiiny | tiiny/google/gemma-4-26B-A4B-it (1) | render | 9 | 4 | 3 | 0 | 12 | 12 |
| think-tiiny | tiiny/google/gemma-4-26B-A4B-it (1) | spec | 10 | 1 | 5 | 0 | 15 | 15 |
| think-tiiny | tiiny/google/gemma-4-26B-A4B-it (1) | oracle | 10 | 0 | 6 | 0 | 16 | 16 |
| think-tiiny | tiiny/openai/gpt-oss-120b (2) | render | 6.5 | 4 | 5.5 | 0 | 12 | 10.5 |
| think-tiiny | tiiny/openai/gpt-oss-120b (2) | spec | 6.5 | 2.5 | 7 | 0.5 | 13.5 | 12 |
| think-tiiny | tiiny/openai/gpt-oss-120b (2) | oracle | 8.5 | 0 | 7.5 | 0 | 16 | 14.5 |
| think-tiiny | tiiny/openai/gpt-oss-20b (1) | render | 3 | 4 | 9 | 0 | 12 | 10 |
| think-tiiny | tiiny/openai/gpt-oss-20b (1) | spec | 4 | 1 | 11 | 0 | 15 | 13 |
| think-tiiny | tiiny/openai/gpt-oss-20b (1) | oracle | 4 | 0 | 12 | 0 | 16 | 14 |
| think-tiiny | tiiny/zai-org/GLM-4.7-Flash (1) | render | 1 | 10 | 5 | 0 | 6 | 6 |
| think-tiiny | tiiny/zai-org/GLM-4.7-Flash (1) | spec | 1 | 4 | 11 | 0 | 12 | 12 |
| think-tiiny | tiiny/zai-org/GLM-4.7-Flash (1) | oracle | 1 | 0 | 15 | 0 | 16 | 14 |
| box-gemma-h4 | tiiny/google/gemma-4-26B-A4B-it (3) | render | 8 | 8 | 0 | 0 | 8 | 8 |
| box-gemma-h4 | tiiny/google/gemma-4-26B-A4B-it (3) | spec | 9 | 4 | 3 | 1 | 12 | 12 |
| box-gemma-h4 | tiiny/google/gemma-4-26B-A4B-it (3) | oracle | 11 | 0 | 5 | 0 | 16 | 15.67 |

Teams and best of k samples (conversations in order; the first one the check accepts is kept):

| Team (rounds) | Check | Kept, right | Kept, wrong | Sent to hosted | Right in the end, Sonnet 5.5 |
|---|---|---:|---:|---:|---:|
| laptop: Gemma 4 E4B, scadcoder, Bonsai 2 27B (1) | spec | 1 | 3 | 12 | 13 |
| laptop: Gemma 4 E4B, scadcoder, Bonsai 2 27B (1) | oracle | 2 | 0 | 14 | 16 |
| box: Gemma 4 26B, gpt-oss-120b thinking, Qwen3.6 27B (2) | spec | 7.5 | 6.5 | 2 | 9.5 |
| box: Gemma 4 26B, gpt-oss-120b thinking, Qwen3.6 27B (2) | oracle | 11.5 | 0 | 4.5 | 16 |
| tiiny/Qwen/Qwen3-30B-A3B-Instruct (main-tiiny), best of its 2 samples (1) | spec | 2 | 6 | 8 | 10 |
| tiiny/Qwen/Qwen3-30B-A3B-Instruct (main-tiiny), best of its 2 samples (1) | oracle | 2 | 0 | 14 | 16 |
| tiiny/Qwen/Qwen3-30B-A3B-Thinking (main-tiiny), best of its 2 samples (1) | spec | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-30B-A3B-Thinking (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-4B-Instruct-2507 (main-tiiny), best of its 2 samples (1) | spec | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-4B-Instruct-2507 (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-8B (main-tiiny), best of its 2 samples (1) | spec | 0 | 1 | 15 | 15 |
| tiiny/Qwen/Qwen3-8B (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct (main-tiiny), best of its 2 samples (1) | spec | 0 | 3 | 13 | 13 |
| tiiny/Qwen/Qwen3-Coder-30B-A3B-Instruct (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3-Coder-Next (main-tiiny), best of its 2 samples (1) | spec | 3 | 5 | 8 | 11 |
| tiiny/Qwen/Qwen3-Coder-Next (main-tiiny), best of its 2 samples (1) | oracle | 5 | 0 | 11 | 16 |
| tiiny/Qwen/Qwen3.5-35B-A3B (main-tiiny), best of its 2 samples (1) | spec | 2 | 1 | 13 | 15 |
| tiiny/Qwen/Qwen3.5-35B-A3B (main-tiiny), best of its 2 samples (1) | oracle | 2 | 0 | 14 | 16 |
| tiiny/Qwen/Qwen3.5-9B (main-tiiny), best of its 2 samples (1) | spec | 1 | 2 | 13 | 14 |
| tiiny/Qwen/Qwen3.5-9B (main-tiiny), best of its 2 samples (1) | oracle | 1 | 0 | 15 | 16 |
| tiiny/Qwen/Qwen3.6-27B (main-tiiny), best of its 2 samples (1) | spec | 5 | 7 | 4 | 9 |
| tiiny/Qwen/Qwen3.6-27B (main-tiiny), best of its 2 samples (1) | oracle | 8 | 0 | 8 | 16 |
| tiiny/Qwen/Qwen3.6-35B-A3B (main-tiiny), best of its 2 samples (1) | spec | 1 | 7 | 8 | 9 |
| tiiny/Qwen/Qwen3.6-35B-A3B (main-tiiny), best of its 2 samples (1) | oracle | 3 | 0 | 13 | 16 |
| tiiny/Qwen/Qwen3.8-27B (main-tiiny), best of its 2 samples (1) | spec | 6 | 2 | 8 | 14 |
| tiiny/Qwen/Qwen3.8-27B (main-tiiny), best of its 2 samples (1) | oracle | 6 | 0 | 10 | 16 |
| tiiny/deepreinforce-ai/Ornith-1.0-35B (main-tiiny), best of its 2 samples (1) | spec | 3 | 7 | 6 | 9 |
| tiiny/deepreinforce-ai/Ornith-1.0-35B (main-tiiny), best of its 2 samples (1) | oracle | 3 | 0 | 13 | 16 |
| tiiny/google/gemma-4-26B-A4B-it (main-tiiny), best of its 3 samples (1) | spec | 9 | 5 | 2 | 11 |
| tiiny/google/gemma-4-26B-A4B-it (main-tiiny), best of its 3 samples (1) | oracle | 14 | 0 | 2 | 16 |
| tiiny/openai/gpt-oss-120b (main-tiiny), best of its 2 samples (1) | spec | 6 | 1 | 9 | 15 |
| tiiny/openai/gpt-oss-120b (main-tiiny), best of its 2 samples (1) | oracle | 7 | 0 | 9 | 16 |
| tiiny/openai/gpt-oss-20b (main-tiiny), best of its 2 samples (1) | spec | 0 | 0 | 16 | 16 |
| tiiny/openai/gpt-oss-20b (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/zai-org/GLM-4.7-Flash (main-tiiny), best of its 2 samples (1) | spec | 0 | 5 | 11 | 11 |
| tiiny/zai-org/GLM-4.7-Flash (main-tiiny), best of its 2 samples (1) | oracle | 0 | 0 | 16 | 16 |
| tiiny/Qwen/Qwen3.6-35B-A3B (think-tiiny), best of its 2 samples (1) | spec | 5 | 6 | 5 | 10 |
| tiiny/Qwen/Qwen3.6-35B-A3B (think-tiiny), best of its 2 samples (1) | oracle | 8 | 0 | 8 | 16 |
| tiiny/openai/gpt-oss-120b (think-tiiny), best of its 2 samples (1) | spec | 7 | 3 | 6 | 13 |
| tiiny/openai/gpt-oss-120b (think-tiiny), best of its 2 samples (1) | oracle | 10 | 0 | 6 | 16 |
| tiiny/google/gemma-4-26B-A4B-it (box-gemma-h4), best of its 3 samples (1) | spec | 8 | 6 | 2 | 10 |
| tiiny/google/gemma-4-26B-A4B-it (box-gemma-h4), best of its 3 samples (1) | oracle | 13 | 0 | 3 | 16 |
