// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: base on the bed (z = 0), holes open at the top

// ---------- Dimensions ----------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_h      = 30;    // block height along Z (mm)

hole_d       = 11.2;  // tube hole diameter (mm)
hole_depth   = 25;    // tube hole depth from the top face (mm)
hole_floor   = block_h - hole_depth;  // solid floor thickness under holes (mm) = 5

pitch        = 16;    // centre-to-centre spacing of holes in X and Y (mm)
holes_x      = 6;     // number of holes along X
holes_y      = 4;     // number of holes along Y
total_holes  = holes_x * holes_y;  // = 24

eps          = 0.5;   // overshoot so cutters pass cleanly through the top face (mm)

// ---------- Model ----------
difference() {
    // Main block, centred in X and Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Hole grid, centred on the block
    for (i = [0 : total_holes - 1]) {
        x = (i % holes_x) * pitch - (holes_x - 1) * pitch / 2;
        y = (i / holes_x) * pitch - (holes_y - 1) * pitch / 2;
        translate([x, y, hole_floor])
            cylinder(d = hole_d, h = hole_depth + eps);
    }
}