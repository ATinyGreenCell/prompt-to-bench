// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: flat on bed, holes pointing up

// ---- Block ----
block_l = 127.76;   // length along X (mm)
block_w = 85.48;    // width along Y (mm)
block_h = 20;       // height along Z (mm)

// ---- Holes ----
hole_d     = 6.2;   // through-hole diameter (mm)
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing (mm)
hole_x0    = 14.38; // first hole centre X from left edge (mm)
hole_y0    = 11.24; // first hole centre Y from back edge (mm)

// ---- Chamfer ----
chamf = 5;          // 45-degree chamfer leg length (mm) at A1 corner

// ---- Misc ----
eps   = 0.5;        // cutter overshoot past faces (mm)
$fn   = 64;         // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 vertical through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch - (hole_nx - 1) * hole_pitch / 2,
                       hole_y0 + j * hole_pitch - (hole_ny - 1) * hole_pitch / 2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // 45-degree chamfer off the vertical edge at the A1 corner
    translate([hole_x0 - (hole_nx - 1) * hole_pitch / 2,
               hole_y0 - (hole_ny - 1) * hole_pitch / 2,
               0])
        linear_extrude(height = block_h + chamf)
            polygon(points = [
                [0, 0],
                [block_l, 0],
                [block_l, chamf],
                [chamf, chamf]
            ]);
}