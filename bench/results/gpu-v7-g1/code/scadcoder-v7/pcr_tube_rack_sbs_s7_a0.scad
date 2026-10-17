// 96-well PCR tube (0.2 mL) rack - microplate footprint
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------- Parameters ----------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_ht     = 20;       // block height along Z

hole_d       = 6.2;      // through-hole diameter
hole_nx      = 12;       // columns along X
hole_ny      = 8;        // rows along Y
hole_pitch   = 9.0;      // centre-to-centre spacing

first_x      = 14.38;    // centre of A1 from left edge
first_y      = 11.24;    // centre of A1 from back edge

chamfer_leg  = 5;        // chamfer leg length (45 deg)
eps          = 0.5;      // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 through-holes, grid centred on the block
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([first_x + i * hole_pitch - hole_d/2,
                       first_y + j * hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2*eps);

    // Orientation mark: 45-degree chamfer off the A1 corner vertical edge
    translate([-block_len/2 - eps, -block_wid/2 - eps, 0])
        linear_extrude(len = block_ht + 2*eps)
            polygon([[-chamfer_leg, -chamfer_leg],
                     [chamfer_leg, -chamfer_leg],
                     [chamfer_leg, chamfer_leg],
                     [-chamfer_leg, chamfer_leg]]);
}