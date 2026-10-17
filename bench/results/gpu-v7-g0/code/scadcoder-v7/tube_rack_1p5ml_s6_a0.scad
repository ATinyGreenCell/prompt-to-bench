// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open upward (+Z)

// ---------------- Parameters ----------------
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

hole_count_x = 6;    // holes per row along X
hole_count_y = 4;    // number of rows along Y
hole_pitch   = 16;   // centre-to-centre spacing in X and Y (mm)
hole_d       = 11.2; // hole diameter (mm)
hole_depth   = 25;   // hole depth from top face (mm)

eps          = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid, centred on the block
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1)/2) * hole_pitch,
                       (j - (hole_count_y - 1)/2) * hole_pitch,
                       block_ht - hole_depth])
                cylinder(d = hole_d, h = hole_depth + eps);
}