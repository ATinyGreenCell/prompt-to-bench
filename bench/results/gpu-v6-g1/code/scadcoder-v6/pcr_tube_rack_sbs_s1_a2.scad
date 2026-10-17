// 96-well PCR tube rack (0.2 mL, microplate footprint)
// Print orientation: base on XY plane, builds upward (+Z)

// ---------------- Parameters ----------------
block_len    = 127.76;   // block length along X (mm)
block_wid    = 85.48;    // block width along Y (mm)
block_h      = 20;       // block height along Z (mm)

hole_d       = 6.2;      // through-hole diameter (mm)
hole_pitch   = 9.0;      // centre-to-centre spacing (mm)
hole_nx      = 12;       // number of columns along X
hole_ny      = 8;        // number of rows along Y

a1_x         = 14.38;    // X of first hole (A1) from left edge (mm)
a1_y         = 11.24;    // Y of first hole (A1) from back edge (mm)

chamfer      = 5;        // 45-degree chamfer leg length at A1 corner (mm)

eps          = 0.5;      // cutter overshoot past faces (mm)
$fn          = 96;       // curve resolution

// ---------------- Derived ----------------
x0 = a1_x - (hole_nx - 1) * hole_pitch / 2;   // first hole X (absolute)
y0 = a1_y - (hole_ny - 1) * hole_pitch / 2;   // first hole Y (absolute)

// ---------------- Model ----------------
difference() {
    // Main block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // 45-degree chamfer at A1 corner (vertical edge, not the top edge)
    translate([x0, y0, 0])
        linear_extrude(height = block_h - chamfer + 0.01)
            polygon(points = [
                [0, 0],
                [chamfer, 0],
                [chamfer, chamfer]
            ]);
}