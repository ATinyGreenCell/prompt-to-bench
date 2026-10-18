// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_ht     = 20;       // block height along Z

hole_d       = 6.2;      // through-hole diameter
hole_pitch   = 9.0;      // centre-to-centre spacing (X and Y)
hole_rows    = 8;        // number of rows along Y
hole_cols    = 12;       // number of columns along X

a1_x_offset  = 14.38;    // X distance from left edge to A1 centre
a1_y_offset  = 11.24;    // Y distance from back edge to A1 centre

chamfer_leg  = 5;        // 45-degree chamfer leg length at A1 corner
eps          = 0.5;      // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 through-holes, grid centred on the block
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([a1_x_offset + i * hole_pitch - hole_d/2,
                       a1_y_offset + j * hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2*eps);

    // 45-degree chamfer with 5 mm legs off the vertical edge at the A1 corner
    translate([a1_x_offset - chamfer_leg, a1_y_offset - chamfer_leg, 0])
        linear_extrude(height = block_ht)
            polygon([[-chamfer_leg, -chamfer_leg],
                     [-chamfer_leg,  block_len/2 - a1_x_offset + chamfer_leg],
                     [block_len/2 - a1_x_offset + chamfer_leg, -chamfer_leg]]);
}