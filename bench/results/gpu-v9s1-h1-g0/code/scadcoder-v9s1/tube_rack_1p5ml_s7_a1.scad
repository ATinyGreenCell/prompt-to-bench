// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: base on XY plane, holes open upward (+Z)

// ---------------- Parameters ----------------
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

hole_d      = 11.2;  // tube hole diameter (mm)
hole_depth  = 25;    // tube hole depth from top (mm)
floor_t     = block_ht - hole_depth; // solid floor thickness = 5 mm

hole_count  = 24;    // total number of holes
hole_rows   = 4;     // number of rows along Y
hole_cols   = 6;     // number of holes along X
hole_pitch  = 16;    // centre-to-centre spacing in X and Y (mm)

eps         = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;            // circle resolution

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Holes, centred on the block
    for (i = [0 : hole_count - 1]) {
        x = (i % hole_cols - (hole_cols - 1) / 2) * hole_pitch;
        y = (i / hole_cols - (hole_rows - 1) / 2) * hole_pitch;
        translate([x, y, block_ht - hole_depth])
            cylinder(d = hole_d, h = hole_depth + eps);
    }
}