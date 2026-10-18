// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open at the top

// ---- Block dimensions ----
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

// ---- Hole dimensions ----
hole_d      = 11.2;  // hole diameter (mm)
hole_depth  = 25;    // hole depth from the top surface (mm)
hole_count  = 24;    // total number of holes
hole_rows   = 4;     // number of rows along Y
hole_pitch  = 16;    // centre-to-centre spacing in X and Y (mm)

// ---- Cutting overlap ----
eps         = 0.5;   // extension of cutters past the top face (mm)

$fn = 64;

difference() {
    // Main block, centred in X and Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid, centred on the block
    for (i = [0 : hole_rows - 1])
        for (j = [0 : hole_count/hole_rows - 1])
            translate([(j - (hole_count/hole_rows - 1)/2) * hole_pitch,
                       (i - (hole_rows - 1)/2) * hole_pitch,
                       hole_depth])
                cylinder(d = hole_d, h = eps);
}