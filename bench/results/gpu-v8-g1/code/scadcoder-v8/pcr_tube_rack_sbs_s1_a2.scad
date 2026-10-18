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

a1_x         = 14.38;    // X of first hole (A1) from left edge (mm)
a1_y         = 11.24;    // Y of first hole (A1) from back edge (mm)

chamfer      = 5;        // 45-degree chamfer leg length at A1 corner (mm)

eps          = 0.5;      // cutter overshoot past faces (mm)
$fn          = 96;       // circle resolution

// ---------------- Derived ----------------
grid_x0 = a1_x - (hole_nx - 1) * hole_pitch / 2;   // grid origin X
grid_y0 = a1_y - (hole_ny - 1) * hole_pitch / 2;   // grid origin Y
// keep one decimal as given
grid_x0 = round(grid_x0, 1);
grid_y0 = round(grid_y0, 1);

// ---------------- Model ----------------
difference() {
    // Main block
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([grid_x0 + i * hole_pitch,
                       grid_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // Orientation chamfer at A1 corner (vertical edge, 45 deg, 5 mm legs)
    translate([-block_l / 2 + grid_x0, -block_w / 2 + grid_y0, 0])
        linear_extrude(height = block_h)
            polygon(points = [
                [0, 0],
                [chamfer, 0],
                [0, chamfer]
            ]);
}