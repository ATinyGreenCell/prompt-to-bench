// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, builds up +Z.

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_ht     = 20;       // block height along Z

hole_d       = 6.2;      // through-hole diameter
hole_count_r = 8;        // number of rows along Y
hole_count_c = 12;       // number of columns along X
hole_pitch   = 9.0;      // centre-to-centre spacing (X and Y)

a1_x         = 14.38;    // X of first hole (A1) from left edge
a1_y         = 11.24;    // Y of first hole (A1) from back edge

chamf_leg    = 5;        // 45-degree chamfer leg length
chamf_face   = [0, 0, 1]; // normal of the A1 corner vertical face

eps          = 0.5;      // cutter overshoot past faces
$fn          = 96;       // curve resolution

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 through-holes, 8 rows x 12 columns
    for (i = [0 : hole_count_r - 1])
        for (j = [0 : hole_count_c - 1])
            translate([a1_x + j * hole_pitch,
                       a1_y + i * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2 * eps);

    // 45-degree chamfer on the A1 corner vertical edge
    translate([a1_x - eps, a1_y - eps, 0])
        linear_extrude([chamf_leg * sqrt(2)])
            polygon([[-chamf_leg, -chamf_leg],
                     [-chamf_leg, chamf_leg],
                     [chamf_leg, chamf_leg]]);
}