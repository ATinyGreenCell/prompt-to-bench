// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open upward

// ---- Block dimensions ----
block_len   = 106;   // length along X
block_wid   = 72;    // width along Y
block_ht    = 30;    // height along Z

// ---- Hole parameters ----
hole_count_x = 6;    // holes along X
hole_count_y = 4;    // holes along Y
hole_pitch   = 16;   // centre-to-centre spacing (both directions)
hole_d       = 11.2; // hole diameter
hole_depth   = 25;   // hole depth from top face
floor_t      = block_ht - hole_depth; // solid floor thickness (5 mm)

// ---- Misc ----
eps = 0.5;           // cutter overshoot past faces
$fn = 64;            // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid, centred on block
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1)/2) * hole_pitch,
                       (j - (hole_count_y - 1)/2) * hole_pitch,
                       floor_t])
                cylinder(d = hole_d, h = hole_depth + eps, $fn = 64);
}