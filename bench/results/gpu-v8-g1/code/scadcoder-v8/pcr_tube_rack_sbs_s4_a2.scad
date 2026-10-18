// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: flat on bed, z = 0 up to block_top

// ---------------- Parameters ----------------
block_l      = 127.76;   // block length along X (mm)
block_w      = 85.48;    // block width along Y (mm)
block_h      = 20;       // block height along Z (mm)

hole_d       = 6.2;      // through-hole diameter (mm)
hole_nx      = 12;       // number of columns along X
hole_ny      = 8;        // number of rows along Y
hole_pitch   = 9.0;      // centre-to-centre spacing (mm)

a1_x         = 14.38;    // X offset of first hole from left edge (mm)
a1_y         = 11.24;    // Y offset of first hole from back edge (mm)

chamfer      = 5;        // 45-degree chamfer leg length at A1 corner (mm)

eps          = 0.5;      // cutter overshoot past faces (mm)
$fn          = 64;       // circle resolution

// ---------------- Derived ----------------
grid_x0 = a1_x - (hole_nx - 1) * hole_pitch / 2;   // grid centre X
grid_y0 = a1_y - (hole_ny - 1) * hole_pitch / 2;   // grid centre Y

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // 96 vertical through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([grid_x0 + i * hole_pitch,
                       grid_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // 45-degree chamfer (cone) at the A1 corner, extended above the top face
    translate([grid_x0, grid_y0, block_h])
        cylinder(r1 = hole_d / 2 + eps,
                 r2 = chamfer + hole_d / 2 + eps,
                 h  = chamfer + eps);
}