// 96-well PCR tube rack (0.2 mL) with ANSI/SLAS microplate footprint
// Print orientation: base on XY plane, builds upward in +Z

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X (mm)
block_wid    = 85.48;    // block width along Y (mm)
block_h      = 20;       // block height along Z (mm)

hole_d       = 6.2;      // through-hole diameter (mm)
hole_pitch   = 9.0;      // centre-to-centre spacing in X and Y (mm)
hole_nx      = 12;       // number of columns along X
hole_ny      = 8;        // number of rows along Y

a1_x         = 14.38;    // X position of first hole (A1) from left edge (mm)
a1_y         = 11.24;    // Y position of first hole (A1) from back edge (mm)

chamfer      = 5;        // 45-degree chamfer leg length at A1 corner (mm)
eps          = 0.5;      // cutter overshoot past faces (mm)

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // 96 through-holes in 8 x 12 grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([a1_x + i * hole_pitch - hole_d/2,
                       a1_y + j * hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // 45-degree chamfer off the vertical edge at the A1 corner (orientation mark)
    // cutter extends past the top face by 'eps' to keep the 45-degree profile
    translate([a1_x - hole_d/2 - eps,
               a1_y + hole_pitch - hole_d/2 - eps,
               block_h - eps])
        cube([chamfer + eps, chamfer + eps, chamfer + eps]);
}