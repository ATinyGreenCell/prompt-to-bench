// 96-well PCR tube rack - microplate footprint (ANSI/SLAS)
// Print orientation: flat on bed, holes open top and bottom

// ---- Block ----
block_l = 127.76;   // block length along X (mm)
block_w = 85.48;    // block width along Y (mm)
block_h = 20;       // block height along Z (mm)

// ---- Holes ----
hole_d     = 6.2;   // hole diameter (mm)
hole_rows  = 8;     // number of rows along Y
hole_cols  = 12;    // number of columns along X
hole_pitch = 9.0;   // centre-to-centre spacing (mm)
hole_x0    = 14.38; // first hole offset from left edge (mm)
hole_y0    = 11.24; // first hole offset from back edge (mm)

// ---- Chamfer ----
chamf_leg  = 5;     // 45-degree chamfer leg length off A1 corner (mm)

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces (mm)
$fn = 96;           // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 through-holes
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([hole_x0 + i*hole_pitch - block_l/2,
                       hole_y0 + j*hole_pitch - block_w/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // Orientation chamfer at A1 corner (positive X, positive Y)
    translate([hole_x0 - block_l/2, hole_y0 - block_w/2, 0])
        linear_extrude(height = block_h)
            polygon([
                [chamf_leg, chamf_leg],
                [block_l/2 - hole_x0 + block_l/2 - chamf_leg, chamf_leg],
                [block_l/2 - hole_x0 + block_l/2 - chamf_leg,
                 block_w/2 - hole_y0 + block_w/2 - chamf_leg]
            ]);
}