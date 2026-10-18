// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open upward (+Z)

// ---------- Parameters ----------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_ht     = 30;    // block height along Z (mm)

hole_d       = 11.2;  // tube hole diameter (mm)
hole_depth   = 25;    // tube hole depth from top surface (mm)
floor_t      = block_ht - hole_depth;  // solid floor thickness = 5 mm

hole_count   = 24;    // total number of holes
hole_rows    = 4;     // holes along Y
hole_cols    = 6;     // holes along X
hole_pitch   = 16;    // centre-to-centre spacing in X and Y (mm)

eps          = 0.5;   // cutter overshoot past top face (mm)
$fn          = 96;    // circle resolution

// ---------- Derived ----------
x0 = -(hole_cols - 1) * hole_pitch / 2;  // first hole X (grid centred)
y0 = -(hole_rows - 1) * hole_pitch / 2;  // first hole Y (grid centred)

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Vertical tube holes, open at top, closed at bottom
    for (i = [0 : hole_count - 1])
        translate([x0 + i * hole_pitch, y0 + (i / hole_cols) * hole_pitch, floor_t])
            cylinder(d = hole_d, h = hole_depth + eps);
}