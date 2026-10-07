// Drying rack for 10 microscope slides standing on their long edge
// Category: benchware. Shallow slots hold each slide by its bottom edge only, so the
// smear or section stays clear of the block, and a drain hole at each end of every
// slot lets liquid run out instead of wicking back up the slide; a channel under each
// row of drains carries it out from under the block.
// Print: PLA or PETG, 0.2 mm layers, 20 % infill, no supports (the drain channels bridge 4 mm).
// Fit: ISO 8037-1 slides are 76 x 26 x 1.0 mm (US 3"x1": 76.2 x 25.4). Slots print
// ~0.2-0.3 mm narrow; 1.8 mm leaves room for a 1.0-1.05 mm slide. Check with a real slide.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
// length (X) and height (Z) [mm]; Y follows the slot count
block_xz = [90, 12];
n_slots = 10;
// centre-to-centre [mm]: a 1 mm slide leans <= 8 deg, so neighbours cannot touch
slot_pitch = 8;
slot_w = 1.8; // 0.1
// along X; slide is 76 mm long
slot_len = 79;
// edge-only contact; deep enough to limit the lean
slot_depth = 6;
// drain hole at each slot end, through the floor
drain_d = 2.5; // 0.1

/* [Hidden] */
$fn = 24;
eps = 0.01;
block = [block_xz[0], n_slots * slot_pitch + 5, block_xz[1]];

// parameter checks: stop with a message instead of building a broken part
assert(n_slots >= 1, "n_slots must be at least 1");
assert(slot_pitch - slot_w >= 0.8, "slots overlap: slot_pitch must exceed slot_w by at least 0.8 mm");
assert(slot_len <= block_xz[0] - 2 * 0.8, "slots are longer than the block");
assert(slot_depth <= block_xz[1] - 2 - 0.8, "slots reach the drain channels: reduce slot_depth or raise the block");

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : n_slots - 1]) {
        y = (i - (n_slots - 1) / 2) * slot_pitch;
        translate([-slot_len / 2, y - slot_w / 2, block.z - slot_depth]) cube([slot_len, slot_w, slot_depth + eps]);
        for (sx = [-1, 1])  // drains
            translate([sx * (slot_len / 2 - drain_d / 2), y, -eps]) cylinder(d = drain_d, h = block.z + 2 * eps);
    }
    for (sx = [-1, 1])  // bottom channels under the drains (short 4 mm bridges)
        translate([sx * (slot_len / 2 - drain_d / 2) - 2, -block.y / 2 - eps, -eps]) cube([4, block.y + 2 * eps, 2]);
}
