// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, building +Z.

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_ht     = 20;       // block height along Z

hole_d       = 6.2;      // through-hole diameter
hole_pitch   = 9.0;      // centre-to-centre spacing (X and Y)
hole_count   = 96;       // total holes (8 rows x 12 columns)

a1_x         = 14.38;    // X of first hole (A1) from left edge
a1_y         = 11.24;    // Y of first hole (A1) from back edge
a1_z         = 0;        // Z of first hole centre

chamfer_leg  = 5;        // chamfer leg length along X and Y
chamfer_ang  = 45;       // chamfer angle (degrees)

eps          = 0.5;      // cutter overshoot past faces
$fn          = 64;       // curve resolution

// Derived: rows along Y, columns along X
rows = 8;
cols = 12;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Through-holes
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([a1_x + i * hole_pitch,
                       a1_y + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2 * eps);

    // Orientation chamfer at A1 corner, cut into the block
    // (keeps the solid watertight)
    translate([a1_x - eps, a1_y - eps, 0])
        linear_extrude(height = block_ht + 2 * eps)
            polygon([[-eps, -eps], [chamfer_leg - eps, -eps],
                     [chamfer_leg - eps, chamfer_leg - eps],
                     [-eps, chamfer_leg - eps]]);
}