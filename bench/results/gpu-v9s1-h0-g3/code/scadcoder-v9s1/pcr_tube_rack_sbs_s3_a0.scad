// 96-well PCR tube rack (0.2 mL) - ANSI/SLAS footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---- Holes ----
hole_d = 6.2;       // hole diameter
hole_nx = 12;       // columns along X
hole_ny = 8;        // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing
hole_x0 = 14.38;    // first hole X from left edge
hole_y0 = 11.24;    // first hole Y from back edge

// ---- Chamfer ----
chamf = 5;          // 45-degree leg length at A1 corner

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch - hole_d/2 - eps,
                       hole_y0 + j * hole_pitch - hole_d/2 - eps,
                       -eps])
                cylinder(d = hole_d + 2 * eps, h = block_h + 2 * eps);

    // Orientation chamfer at A1 corner
    translate([block_l/2 - chamf, block_w/2 - chamf, 0])
        linear_extrude(height = block_h, center = true)
            polygon([[-chamf, -chamf], [chamf, -chamf], [-chamf, chamf]]);
}