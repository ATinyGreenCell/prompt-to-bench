// 96 PCR tube (0.2 mL) rack - ANSI/SLAS microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---- Holes ----
hole_d     = 6.2;   // hole diameter
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing
hole_x0    = 14.38;  // first hole offset from left edge
hole_y0    = 11.24;  // first hole offset from back edge

// ---- Chamfer ----
chamf_leg  = 5;     // chamfer leg length
chamf_ang  = 45;    // chamfer angle (degrees)

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 96;

// Chamfer helper: cylinder with a flat face cut at the given angle
module chamfer_cylinder(d, leg, ang) {
    h = leg / tan(ang);
    translate([0, 0, -eps])
        union() {
            cylinder(d = d, h = h + 2 * eps);
            translate([0, 0, -eps])
                cube([d + 2 * eps, d + 2 * eps, h + 2 * eps]);
        }
}

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch - block_l / 2,
                       hole_y0 + j * hole_pitch - block_w / 2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // Orientation mark: 45-degree chamfer at the A1 corner (X minimum, Y minimum, Z maximum)
    translate([hole_x0 - block_l / 2, hole_y0 - block_w / 2, block_h - eps])
        rotate([0, 90, 0])
            chamfer_cylinder(block_w / 2 + eps, chamf_leg, chamf_ang);
}