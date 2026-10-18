// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---------- Parameters ----------
plate_len    = 127.76;  // block length along X
plate_wid    = 85.48;   // block width along Y
plate_h      = 20;      // block height along Z
hole_d       = 6.2;     // through-hole diameter
hole_n_rows  = 8;       // holes along Y
hole_n_cols  = 12;      // holes along X
hole_pitch   = 9.0;     // centre-to-centre spacing
a1_x         = 14.38;   // first hole offset from left edge
a1_y         = 11.24;   // first hole offset from back edge
chamfer      = 5;       // 45-degree chamfer leg length
eps          = 0.5;     // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
total_x = (hole_n_cols - 1) * hole_pitch + 2 * a1_x;   // 101.38
total_y = (hole_n_rows - 1) * hole_pitch + 2 * a1_y;   // 89.48

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-plate_len / 2, -plate_wid / 2, 0])
        cube([plate_len, plate_wid, plate_h]);

    // 96 through-holes
    for (i = [0 : hole_n_cols - 1])
        for (j = [0 : hole_n_rows - 1])
            translate([a1_x + i * hole_pitch - total_x / 2,
                       a1_y + j * hole_pitch - total_y / 2,
                       -eps])
                cylinder(d = hole_d, h = plate_h + 2 * eps);

    // Chamfer at A1 corner (bottom-left-rear), 45 degrees, 5 mm legs
    translate([a1_x - total_x / 2, a1_y - total_y / 2, 0])
        linear_extrude(height = plate_h)
            polygon([[-chamfer, -chamfer],
                     [chamfer, -chamfer],
                     [chamfer, chamfer]]);
}