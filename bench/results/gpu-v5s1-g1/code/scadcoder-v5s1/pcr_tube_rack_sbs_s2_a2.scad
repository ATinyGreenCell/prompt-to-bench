// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------- Block ----------
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---------- Holes ----------
hole_d     = 6.2;   // hole diameter
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing (X and Y)
hole_x0    = 14.38; // centre of A1 from left edge
hole_y0    = 11.24; // centre of A1 from back edge

// ---------- Chamfer ----------
chamf_leg  = 5;     // leg length of 45-degree chamfer
chamf_edge = "A1";  // corner: left (X=0) and back (Y=0)

// ---------- Misc ----------
eps = 0.5;          // cutter overshoot past faces
$fn = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i*hole_pitch - hole_d/2,
                       hole_y0 + j*hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // Orientation chamfer at A1 corner (extends past X<0 and Y<0 faces)
    translate([-chamf_leg, -chamf_leg, 0])
        linear_extrude(height = block_h)
            polygon([[-chamf_leg, 0], [0, -chamf_leg], [0, 0]]);
}