// Drying rack for 10 microscope slides (75 x 25 x 1 mm) standing on edge
// Category: benchware. Block with parallel slots; prints without supports.
// Print: PLA or PETG, 0.2 mm layers, 20 % infill. Check slot width with a real slide.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
block = [90, 45, 20];  // X, Y, Z [mm]
n_slots = 10;
slot_pitch = 3.5;      // centre-to-centre [mm]
slot_w = 1.6;          // 1.0-1.2 mm slides + clearance
slot_len = 77;         // along X, slide is 75 mm long
slot_depth = 10;

/* [Hidden] */
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : n_slots - 1])
        translate([-slot_len / 2, (i - (n_slots - 1) / 2) * slot_pitch - slot_w / 2, block.z - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}
