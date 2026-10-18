// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open at the top

// ---------- Parameters ----------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_h      = 30;    // block height along Z (mm)

hole_d       = 11.2;  // tube hole diameter (mm)
hole_depth   = 25;    // tube hole depth from top (mm)
hole_pitch   = 16;    // centre-to-centre spacing in X and Y (mm)
hole_count_x = 6;     // number of holes along X
hole_count_y = 4;     // number of holes along Y

eps          = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Hole grid, centred on the block
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1)/2) * hole_pitch,
                       (j - (hole_count_y - 1)/2) * hole_pitch,
                       block_h - hole_depth])
                cylinder(d = hole_d, h = hole_depth + eps);
}