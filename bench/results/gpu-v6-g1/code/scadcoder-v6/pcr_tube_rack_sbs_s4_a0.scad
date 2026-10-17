// 96-well PCR tube rack (0.2 mL, microplate footprint)
// Print orientation: base on XY plane, builds upward in +Z

// ---------- Block ----------
block_len   = 127.76;   // block length along X (mm)
block_wid   = 85.48;    // block width along Y (mm)
block_h     = 20;       // block height along Z (mm)

// ---------- Hole grid ----------
hole_count  = 96;       // total number of tube holes
hole_d      = 6.2;      // hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing (mm)
hole_x0     = 14.38;    // X position of first hole A1 (mm)
hole_y0     = 11.24;    // Y position of first hole A1 (mm)
hole_cols   = 12;       // number of columns along X
hole_rows   = 8;        // number of rows along Y

// ---------- Chamfer ----------
chamfer     = 5;        // 45-degree chamfer leg length (mm)

// ---------- Misc ----------
eps         = 0.5;      // overshoot for clean boolean cuts (mm)
$fn         = 64;       // curve resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Tube holes, grid centred on the block
    for (i = [0 : hole_count - 1]) {
        x = hole_x0 + (i % hole_cols) * hole_pitch;
        y = hole_y0 + floor(i / hole_cols) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = block_h + 2*eps);
    }

    // Orientation chamfer at the A1 corner (vertical edge, 45-degree bevel)
    translate([0, block_wid/2 - chamfer, 0])
        cube([block_len, chamfer, block_h]);
}