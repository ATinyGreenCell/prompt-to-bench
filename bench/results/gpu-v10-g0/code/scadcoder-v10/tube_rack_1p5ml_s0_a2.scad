// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: base on XY plane, holes open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_ht     = 30;    // block height along Z (mm)

hole_count   = 24;    // total number of tube holes
hole_rows    = 4;     // number of hole rows along Y
hole_cols    = 6;     // number of holes per row along X
hole_pitch   = 16;    // centre-to-centre spacing in X and Y (mm)

hole_d       = 11.2;  // hole diameter (mm)
hole_depth   = 25;    // hole depth from top face (mm)
floor_t      = block_ht - hole_depth; // remaining solid floor (5 mm)

overcut      = 0.5;   // extra length so cutters pass through faces (mm)

$fn = 96;             // circle resolution

// ---------------- Derived ----------------
first_x = -(hole_cols - 1) * hole_pitch / 2;  // x of first hole in a row
first_y = -(hole_rows - 1) * hole_pitch / 2;  // y of first row

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Tube holes, open at top, closed at bottom
    for (i = [0 : hole_count - 1]) {
        translate([first_x + i % hole_cols * hole_pitch,
                   first_y + (i / hole_cols) * hole_pitch,
                   floor_t])
            cylinder(d = hole_d, h = hole_depth + overcut);
    }
}