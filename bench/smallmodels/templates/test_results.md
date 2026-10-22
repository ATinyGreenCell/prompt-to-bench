## sm-template: `template:qwen2.5-coder:7b`

| Task | Within 3 | Attempt 1 | Attempt 2 | Attempt 3 | Minutes | Related design |
|---|---|---|---|---|---:|---|
| conical_rack_50ml | fail | no file `none` | no file `none` | no file `none` | 0.4 | grid_tray |
| dshaft_knob_6mm | fail | builds `knurled_knob` | builds `knurled_knob` | builds `knurled_knob` | 3.6 | knurled_knob |
| enclosure_box_and_lid | fail | builds `lidded_box` | builds `lidded_box` | builds `lidded_box` | 3.6 | lidded_box |
| gel_comb_10well | fail | builds `rounded_plate` | builds `rounded_plate` | builds `rounded_plate` | 3.4 |  |
| hose_barb_reducer_8_5 | fail | no file `none` | no file `none` | no file `none` | 0.4 | stepped_adapter / flanged_bushing |
| lab_funnel_60mm | fail | builds `funnel` | builds `funnel` | builds `funnel` | 3.0 | funnel |
| micropestle_1p5ml | fail | no file `none` | no file `none` | no file `none` | 0.3 |  |
| mini_gel_tank | fail | no file `none` | no file `none` | no file `none` | 0.3 |  |
| nema17_motor_bracket | fail | no file `none` | no file `none` | no file `none` | 0.5 |  |
| pcr_tube_adapter | fail | no file `none` | no file `none` | no file `none` | 0.2 | stepped_adapter / flanged_bushing |
| pcr_tube_rack_sbs | fail | no file `none` | no file `none` | no file `none` | 0.3 | grid_tray |
| rod_tubing_clip | fail | no file `none` | no file `none` | no file `none` | 0.4 | pipe_saddle_clamp |
| seed_sowing_template | fail | builds `grid_tray` | builds `grid_tray` | builds `grid_tray` | 2.1 |  |
| slide_drying_rack | fail | no file `none` | no file `none` | no file `none` | 0.3 |  |
| stirrer_fan_housing | fail | no file `none` | no file `none` | no file `none` | 0.4 |  |
| tube_rack_1p5ml | fail | builds `grid_tray` | builds `grid_tray` | builds `grid_tray` | 4.6 | grid_tray |

- Tasks passed within three attempts: **0/16**; on the first attempt: 0/16.
- First files that build: 6/16. Median 0.4 minutes a task.
- The same model writing OpenSCAD (`main`): 0/16 passed, 1/16 first files build, median 3.1 minutes.
- Viability bar (at least 8 of 16 within three attempts, median at most 10 minutes): not met.
- Passes on tasks with a related library design: 0 of 9; on the others: 0 of 7.

