// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: flat on bed, z = 0 up to block_top

// ---------- Block ----------
block_l = 127.76;   // length along X (mm)
block_w = 85.48;    // width along Y (mm)
block_h = 20;       // height along Z (mm)

// ---------- Holes ----------
hole_d     = 6.2;   // through-hole diameter (mm)
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing (mm)
hole_a1_x  = 14.38; // first hole offset from left edge (mm)
hole_a1_y  = 11.24; // first hole offset from back edge (mm)

// ---------- Chamfer ----------
chamf = 5;          // 45-degree chamfer leg length (mm) at A1 corner

// ---------- Misc ----------
eps   = 0.5;        // cutter overshoot past faces (mm)
$fn   = 64;         // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 vertical through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_a1_x + i*hole_pitch - (hole_nx - 1)*hole_pitch/2,
                       hole_a1_y + j*hole_pitch - (hole_ny - 1)*hole_pitch/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // 45-degree chamfer at A1 corner (vertical edge), orientation mark
    translate([-block_l/2 - 0.01, -block_w/2 - 0.01, 0])
        linear_extrude(height = block_h + 0.01)
            polygon([
                [0, 0],
                [block_l/2 + 0.01, 0],
                [block_l/2 + 0.01, block_w/2 + 0.01],
                [0, block_w/2 + 0.01]
            ]);
}