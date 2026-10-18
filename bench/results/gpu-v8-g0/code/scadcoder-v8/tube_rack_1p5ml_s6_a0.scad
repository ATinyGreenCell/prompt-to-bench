// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, open holes facing up

// ---- Block ----
block_l = 106;      // block length along X
block_w = 72;       // block width along Y
block_h = 30;       // block height along Z

// ---- Holes ----
hole_d     = 11.2;  // hole diameter
hole_depth = 25;    // hole depth from top (closed floor = 5 mm)
hole_nx    = 6;     // holes along X
hole_ny    = 4;     // holes along Y
hole_pitch = 16;    // centre-to-centre spacing, both directions

// ---- Misc ----
eps = 0.5;          // cutter overshoot past top face
$fn = 96;           // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Hole grid, centred on block
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       block_h - hole_depth])
                cylinder(d = hole_d, h = hole_depth + eps);
}