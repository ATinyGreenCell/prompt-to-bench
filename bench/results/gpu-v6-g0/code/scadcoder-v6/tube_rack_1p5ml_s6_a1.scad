// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, open holes facing up

// ---- Block dimensions ----
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

// ---- Hole dimensions ----
hole_d      = 11.2;  // hole diameter (mm)
hole_depth  = 25;    // hole depth from top surface (mm)
floor_t     = block_ht - hole_depth; // solid floor thickness = 5 mm

// ---- Hole grid ----
hole_count  = 24;    // total number of holes
hole_rows   = 4;     // rows along Y
hole_per_row = hole_count / hole_rows; // 6 holes along X
pitch       = 16;    // centre-to-centre spacing, both directions (mm)

// ---- Misc ----
eps         = 0.5;   // overshoot for clean boolean cuts (mm)
$fn         = 96;    // circle resolution

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid, centred on the block
    for (i = [0 : hole_count - 1]) {
        x = (i % hole_per_row - (hole_per_row - 1) / 2) * pitch;
        y = ((i / hole_per_row) - (hole_rows - 1) / 2) * pitch;
        translate([x, y, floor_t])
            cylinder(d = hole_d, h = hole_depth + eps);
    }
}