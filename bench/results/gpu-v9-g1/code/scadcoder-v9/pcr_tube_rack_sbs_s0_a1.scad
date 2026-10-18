// 96-well PCR tube rack (0.2 mL) with ANSI/SLAS footprint
// Print orientation: base on XY plane, building up +Z

// ---------- Parameters ----------
block_len   = 127.76;   // block length along X (mm)
block_wid   = 85.48;    // block width along Y (mm)
block_h     = 20;       // block height along Z (mm)

hole_count  = 96;       // number of tube holes
hole_d      = 6.2;      // hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing in X and Y (mm)
hole_cols   = 12;       // holes along X
hole_rows   = 8;        // holes along Y

x0          = 14.38;    // first hole offset from left edge (mm)
y0          = 11.24;    // first hole offset from back edge (mm)

eps         = 0.5;      // cutter overshoot past faces (mm)
chamfer     = 5;        // 45-degree chamfer leg length (mm)
$fn         = 96;       // curve resolution

// ---------- Model ----------
difference() {
    // Main block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Tube holes
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([x0 + i * hole_pitch - block_len/2,
                       y0 + j * hole_pitch - block_wid/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // Orientation chamfer at A1 corner
    translate([block_len/2 - chamfer, block_wid/2 - chamfer, 0])
        linear_extrude(height = block_h)
            polygon([[0, 0], [chamfer, 0], [0, chamfer]]);
}