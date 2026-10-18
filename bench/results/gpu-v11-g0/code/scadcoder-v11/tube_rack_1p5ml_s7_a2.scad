// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: flat on bed, holes open at the top

// ---------------- Parameters ----------------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_h      = 30;    // block height along Z (mm)

hole_count   = 24;    // total number of tube holes
hole_d       = 11.2;  // hole diameter (mm)
hole_depth   = 25;    // hole depth from top face (mm), closed at bottom

row_count    = 4;     // number of hole rows along Y
hole_pitch   = 16;    // centre-to-centre spacing along X and Y (mm)

eps          = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;             // curve resolution

// ---------------- Derived ----------------
floor_t = block_h - hole_depth;   // solid floor thickness under holes (5 mm)
x0 = -(hole_count - 1) * hole_pitch / 2;  // first hole X (grid centred)
// Y rows are also centred, offset by pitch

// ---------------- Model ----------------
difference() {
    // Main block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Tube holes
    for (i = [0 : hole_count - 1]) {
        translate([
            x0 + i % row_count * hole_pitch,
            -(i / row_count) * hole_pitch,
            floor_t
        ])
            cylinder(d = hole_d, h = hole_depth + eps);
    }
}