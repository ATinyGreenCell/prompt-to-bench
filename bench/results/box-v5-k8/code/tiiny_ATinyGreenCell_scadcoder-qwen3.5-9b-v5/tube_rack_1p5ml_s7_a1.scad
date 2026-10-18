// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open upward (+Z)

// ---- Block dimensions ----
block_len   = 106;   // block length along X (mm)
block_wid   = 72;    // block width along Y (mm)
block_ht    = 30;    // block height along Z (mm)

// ---- Hole pattern ----
hole_count  = 24;    // total number of tube holes
hole_rows   = 4;     // rows of holes along Y
hole_cols   = 6;     // holes per row along X
hole_pitch  = 16;    // centre-to-centre spacing in X and Y (mm)
hole_dia    = 11.2;  // hole diameter (mm)
hole_depth  = 25;    // hole depth from top surface (mm)
floor_thk   = block_ht - hole_depth; // solid floor thickness = 5 mm

// ---- Cutting overlap ----
eps = 0.5;           // extension past cut faces to avoid coplanar faces

$fn = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid centred on the block
    for (i = [0 : hole_count - 1]) {
        x = (i % hole_cols) * hole_pitch - (hole_cols - 1) * hole_pitch / 2;
        y = (i / hole_cols) * hole_pitch - (hole_rows - 1) * hole_pitch / 2;
        translate([x, y, block_ht - hole_depth])
            cylinder(d = hole_dia, h = hole_depth + eps);
    }
}