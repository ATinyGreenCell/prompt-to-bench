// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open upward

// ---- Block dimensions ----
block_l = 106;   // length along X
block_w = 72;    // width along Y
block_h = 30;    // height along Z

// ---- Hole pattern ----
hole_n     = 24;    // number of holes
hole_rows  = 4;     // rows along Y
hole_cols  = 6;     // holes per row along X
hole_pitch = 16;    // centre-to-centre spacing (both directions)
hole_d     = 11.2;  // hole diameter
hole_depth = 25;    // hole depth from top face

// ---- Misc ----
eps = 0.5;       // overshoot for clean boolean cuts
$fn = 96;        // curve resolution

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Hole grid, centred on the block
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([(i - (hole_cols - 1)/2) * hole_pitch,
                       (j - (hole_rows - 1)/2) * hole_pitch,
                       hole_depth])
                cylinder(d = hole_d, h = eps, $fn = 96);
}