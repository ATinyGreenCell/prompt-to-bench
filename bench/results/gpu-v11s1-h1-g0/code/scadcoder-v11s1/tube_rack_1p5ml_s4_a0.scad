// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open at the top

// ---- Block dimensions ----
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

// ---- Hole dimensions ----
hole_d      = 11.2;  // hole diameter (mm)
hole_depth  = 25;    // hole depth from top surface (mm)
floor_t     = block_ht - hole_depth; // solid floor thickness = 5 mm
eps         = 0.5;   // overshoot for clean boolean cuts (mm)

// ---- Hole pattern ----
hole_n_x    = 6;     // holes along X (tube rows)
hole_n_y    = 4;     // holes along Y (tube columns)
hole_pitch  = 16;    // centre-to-centre spacing in X and Y (mm)

$fn = 64;            // circle resolution

// X position of first hole so the grid is centred on the block
hole_x0 = -(hole_n_x - 1) * hole_pitch / 2;
// Y position of first hole so the grid is centred on the block
hole_y0 = -(hole_n_y - 1) * hole_pitch / 2;

difference() {
    // Main block, centred in X and Y, sitting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Vertical tube holes, open at the top
    for (i = [0 : hole_n_x - 1])
        for (j = [0 : hole_n_y - 1])
            translate([hole_x0 + i * hole_pitch,
                       hole_y0 + j * hole_pitch,
                       floor_t])
                cylinder(d = hole_d, h = hole_depth + eps);
}