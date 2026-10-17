// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: base on XY plane, holes open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 106;   // block length along X (mm)
block_wid    = 72;    // block width along Y (mm)
block_h      = 30;    // block height along Z (mm)

hole_d       = 11.2;  // tube hole diameter (mm)
hole_depth   = 25;    // tube hole depth from top face (mm)
floor_t      = block_h - hole_depth; // solid floor thickness = 5 mm

hole_count_x = 6;     // holes along X per row
hole_count_y = 4;     // holes along Y (rows)
hole_pitch   = 16;    // centre-to-centre spacing both directions (mm)

overcut      = 0.5;   // extra length so cutters pass through the top face (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Hole grid, centred on the block
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1)/2) * hole_pitch,
                       (j - (hole_count_y - 1)/2) * hole_pitch,
                       floor_t])
                cylinder(d = hole_d, h = hole_depth + overcut);
}