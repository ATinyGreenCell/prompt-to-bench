// Drying rack for 10 microscope slides standing on their long edge
// Category: benchware. Shallow slots hold each slide by its bottom edge only, so the
// smear or section stays clear of the block, and a drain hole at each end of every
// slot lets liquid run out instead of wicking back up the slide.
// Print: PLA or PETG, 0.2 mm layers, 20 % infill, no supports.
// Fit: ISO 8037-1 slides are 76 x 26 x 1.0 mm (US 3"x1": 76.2 x 25.4). Slots print
// ~0.2-0.3 mm narrow; 1.8 mm leaves room for a 1.0-1.05 mm slide. Check with a real slide.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
block = [90, 60, 12];  // X, Y, Z [mm]
n_slots = 10;
slot_pitch = 5;        // centre-to-centre [mm]: 4 mm air gap between slides
slot_w = 1.8;
slot_len = 79;         // along X; slide is 76 mm long
slot_depth = 4;        // edge-only contact: keep smears above the block
drain_d = 2.5;         // drain hole at each slot end, through the floor

/* [Hidden] */
$fn = 24;
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : n_slots - 1]) {
        y = (i - (n_slots - 1) / 2) * slot_pitch;
        translate([-slot_len / 2, y - slot_w / 2, block.z - slot_depth]) cube([slot_len, slot_w, slot_depth + eps]);
        for (sx = [-1, 1])  // drains
            translate([sx * (slot_len / 2 - drain_d / 2), y, -eps]) cylinder(d = drain_d, h = block.z + 2 * eps);
    }
}
