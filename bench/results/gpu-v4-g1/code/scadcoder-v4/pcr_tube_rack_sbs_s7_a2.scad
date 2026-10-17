// 96-well PCR tube (0.2 mL) rack - microplate footprint (ANSI/SLAS)
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---- Holes ----
hole_d   = 6.2;     // hole diameter
hole_nx  = 12;      // columns along X
hole_ny  = 8;       // rows along Y
hole_p   = 9.0;     // centre-to-centre spacing (X and Y)
hole_x0  = 14.38;   // first hole centre offset from left edge
hole_y0  = 11.24;   // first hole centre offset from back edge

// ---- Chamfer ----
cham_f = 5;         // chamfer leg length
cham_a = 45;        // chamfer angle (degrees)

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 64;

cham_v = cham_f / tan(cham_a);  // depth of 45 deg chamfer

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 through-holes, grid centred on block
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_p, hole_y0 + j * hole_p, -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // Orientation mark: 45-degree chamfer off A1 corner (X- / Y- / Z+)
    translate([-block_l/2 - cham_v, -block_w/2 - cham_v, 0])
        cube([cham_v + eps, cham_v + eps, block_h + eps]);
}