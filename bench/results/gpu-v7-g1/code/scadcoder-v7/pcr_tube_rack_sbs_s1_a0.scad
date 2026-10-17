// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------- Block ----------
block_l = 127.76;   // block length along X
block_w = 85.48;    // block width along Y
block_h = 20;       // block height along Z

// ---------- Hole grid ----------
hole_d     = 6.2;   // through-hole diameter
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing
hole_x0    = 14.38; // centre of A1 from left edge
hole_y0    = 11.24; // centre of A1 from back edge

// ---------- Chamfer (orientation mark) ----------
chamf_leg  = 5;     // chamfer leg length along X and Z
chamf_ang  = 45;    // chamfer angle (degrees)

// ---------- Misc ----------
eps = 0.5;          // cutter overshoot past faces
$fn = 64;

// Derived: grid start so the pattern is centred on the block
grid_x_start = hole_x0 - (hole_nx - 1) * hole_pitch / 2;
grid_y_start = hole_y0 - (hole_ny - 1) * hole_pitch / 2;

difference() {
    // Main block
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([grid_x_start + i * hole_pitch,
                       grid_y_start + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // Chamfer off the A1 corner (vertical edge, 45 deg, 5 mm legs)
    translate([grid_x_start - chamf_leg,
               grid_y_start - chamf_leg,
               0])
        linear_extrude(height = block_h + 2 * eps, center = true)
            polygon([[-chamf_leg, -chamf_leg],
                     [chamf_leg, -chamf_leg],
                     [chamf_leg, chamf_leg]]);
}