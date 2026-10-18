// 96-well PCR tube rack (0.2 mL) with ANSI/SLAS footprint
// Print orientation: base on XY plane, builds upward in +Z

// ---------- Parameters ----------
block_len   = 127.76;   // block length along X (mm)
block_wid   = 85.48;    // block width along Y (mm)
block_ht    = 20;       // block height along Z (mm)

hole_d      = 6.2;      // through-hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing in X and Y (mm)
hole_count_r = 8;       // number of rows along Y
hole_count_c = 12;      // number of columns along X

corner_x    = 14.38;    // distance of first hole (A1) from left edge (mm)
corner_y    = 11.24;    // distance of first hole (A1) from back edge (mm)

chamfer_leg = 5;        // 45-degree chamfer leg length on A1 corner (mm)
eps         = 0.5;      // cutter overshoot past faces (mm)

$fn = 96;               // circle resolution

// ---------- Derived ----------
x0 = corner_x - (hole_count_c - 1) * hole_pitch / 2;  // first hole X
y0 = corner_y - (hole_count_r - 1) * hole_pitch / 2;  // first hole Y

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 vertical through-holes
    for (i = [0 : hole_count_c - 1])
        for (j = [0 : hole_count_r - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = block_ht + 2 * eps);

    // 45-degree chamfer with 5 mm legs on the A1 corner (vertical edge)
    translate([0, 0, 0])
        linear_extrude(height = block_wid / 2 + 1)
            polygon([
                [0, 0],
                [chamfer_leg, 0],
                [0, chamfer_leg]
            ]);
}