// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---------- Parameters ----------
block_len    = 127.76;   // block length along X
block_wid    = 85.48;    // block width along Y
block_h      = 20;       // block height along Z
hole_d       = 6.2;      // through-hole diameter
hole_n_rows  = 8;        // number of rows along Y
hole_n_cols  = 12;       // number of columns along X
hole_pitch   = 9.0;      // centre-to-centre spacing
a1_x         = 14.38;    // first hole offset from left edge
a1_y         = 11.24;    // first hole offset from back edge
chamfer      = 5;        // 45-degree chamfer leg length
eps          = 0.5;      // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
x0 = a1_x - (hole_n_cols - 1) * hole_pitch / 2;
y0 = a1_y - (hole_n_rows - 1) * hole_pitch / 2;

// ---------- Model ----------
difference() {
    // Main block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Through-holes
    for (i = [0 : hole_n_cols - 1])
        for (j = [0 : hole_n_rows - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // Chamfer at A1 corner (vertical edge, 45 degrees)
    translate([block_len / 2 - 1, -block_wid / 2, 0])
        linear_extrude(height = block_wid + eps)
            polygon([[-chamfer, block_h - chamfer],
                     [ block_len / 2 - 1 - chamfer, block_h - chamfer],
                     [ block_len / 2 - 1, block_h - chamfer]]);
}