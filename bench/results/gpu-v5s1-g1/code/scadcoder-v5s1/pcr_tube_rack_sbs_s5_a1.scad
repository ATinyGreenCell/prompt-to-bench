// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------- Block ----------
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---------- Holes ----------
hole_d     = 6.2;   // hole diameter (through)
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing (X and Y)
hole_x0    = 14.38; // centre of A1 from left edge
hole_y0    = 11.24; // centre of A1 from back edge

// ---------- Chamfer ----------
chamf_leg  = 5;     // chamfer leg length
chamf_ang  = 45;    // chamfer angle (degrees)

// ---------- Misc ----------
eps        = 0.5;   // cutter overshoot past faces
$fn        = 96;    // curve resolution

// Derived
chamf_h = chamf_leg / tan(chamf_ang);  // height of 45 deg chamfer

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i*hole_pitch - hole_d/2,
                       hole_y0 + j*hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // Orientation chamfer at A1 corner (vertical edge, 45 deg, 5 mm legs)
    translate([hole_x0 - 1, hole_y0 - 1, 0])
        linear_extrude(height = block_h)
            polygon([[-chamf_leg, 0], [0, -chamf_leg], [0, 0]]);
}