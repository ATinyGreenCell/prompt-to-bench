// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: base on XY plane, holes open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_h      = 30;    // block height along Z (mm)

hole_d       = 11.2;  // tube hole diameter (mm)
hole_depth   = 25;    // tube hole depth from top surface (mm)
hole_pitch   = 16;    // centre-to-centre spacing in X and Y (mm)
hole_count_x = 6;     // number of holes along X
hole_count_y = 4;     // number of holes along Y

eps          = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;             // smoothness of curved surfaces

// Derived: offset so the hole grid is centred on the block
grid_x0 = -(hole_count_x - 1) * hole_pitch / 2;   // -40
grid_y0 = -(hole_count_y - 1) * hole_pitch / 2;   // -20

// ---------------- Model ----------------
difference() {
    // Solid block
    translate([0, 0, 0])
        cube([block_len, block_wid, block_h]);

    // Tube holes: open at top, closed at bottom (5 mm solid floor)
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([grid_x0 + i * hole_pitch,
                       grid_y0 + j * hole_pitch,
                       hole_depth])
                cylinder(d = hole_d, h = block_h - hole_depth + eps);
}