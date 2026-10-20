// Drying rack for 10 microscope slides (75 x 25 x 1 mm)
// Slides stand upright on their long edge (75 mm along X).
// Base block: 90 mm (X) x 45 mm (Y) x 20 mm (Z)
// 10 parallel slots cut into the top face, open at the top.

// --- Dimensions (mm) ---
block_x = 90;      // length of base block (X)
block_y = 45;      // width of base block (Y)
block_z = 20;      // height of base block (Z)

slot_len   = 77;   // slot length along X
slot_w     = 1.6;  // slot width along Y
slot_depth = 10;   // slot depth from top face (Z)

slot_pitch = 3.5;  // centre-to-centre spacing between slots (Y)
n_slots    = 10;   // number of slots

// --- Print orientation ---
// The rack rests on the XY plane at z = 0 and builds upward (+Z).
// Centred on the origin in X and Y.

// --- Main solid ---
block = cube([block_x, block_y, block_z], center=[0, 0, block_z/2]);

// --- Cutting shapes (extend 0.01-1 mm past the faces they cut) ---
// Each slot is a rectangular prism running along X, open at the top.
// Cut from z = block_z - slot_depth to z = block_z + 1 (1 mm past top).
// Slot length extends 1 mm past each end of the block in X.
// Slot width extends 0.01 mm past each side in Y.

slot_cut_x = slot_len + 2;   // 79 mm, extends 1 mm past each end of block
slot_cut_y = slot_w + 0.02;  // 1.62 mm, extends 0.01 mm past each side
slot_cut_z = slot_depth + 1; // 11 mm, extends 1 mm past the top face

// --- Build the final part ---
difference() {
    block;

    // 10 parallel slots, centred in Y
    for (i = 0; i < n_slots; i++) {
        y_pos = (i - (n_slots - 1) / 2) * slot_pitch;
        translate([0, y_pos, block_z - slot_depth]) {
            cube([slot_cut_x, slot_cut_y, slot_cut_z], center=[0, 0, 0]);
        }
    }
}