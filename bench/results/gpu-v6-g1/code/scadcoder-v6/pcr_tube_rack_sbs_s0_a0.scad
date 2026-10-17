// 96-well PCR tube rack (0.2 mL, microplate footprint)
// Units: mm. Print orientation: base on XY plane, building up +Z.

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_h      = 20;       // block height along Z

hole_count   = 96;       // number of tube holes
hole_d       = 6.2;      // hole diameter
hole_pitch   = 9.0;      // centre-to-centre spacing (X and Y)
hole_x0      = 14.38;    // X of first hole (A1) from left edge
hole_y0      = 11.24;    // Y of first hole (A1) from back edge

chamfer      = 5;        // 45-degree chamfer leg length at A1 corner
eps          = 0.5;      // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // 8 rows (Y) x 12 columns (X) of vertical through-holes
    for (i = [0 : 11])
        for (j = [0 : 7])
            translate([hole_x0 + i * hole_pitch - hole_d/2,
                       hole_y0 + j * hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // 45-degree chamfer on the vertical edge at the A1 corner
    translate([hole_x0 - hole_d/2 - 1, hole_y0, 0])
        linear_extrude(height = block_h + 1)
            polygon(points = [
                [0, 0],
                [hole_d/2 + 1 + eps, 0],
                [hole_d/2 + 1 + eps - chamfer, chamfer],
                [hole_d/2 + 1, chamfer]
            ]);
}