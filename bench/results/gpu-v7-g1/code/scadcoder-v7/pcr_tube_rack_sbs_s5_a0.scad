// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---------- Parameters ----------
block_len    = 127.76;   // block length along X (mm)
block_wid    = 85.48;    // block width along Y (mm)
block_ht     = 20;       // block height along Z (mm)

hole_d       = 6.2;      // through-hole diameter (mm)
hole_pitch   = 9.0;      // centre-to-centre spacing in X and Y (mm)
hole_rows    = 8;        // number of rows along Y
hole_cols    = 12;       // number of columns along X

first_x      = 14.38;    // X of first hole (A1) from left edge (mm)
first_y      = 11.24;    // Y of first hole (A1) from back edge (mm)

chamfer_leg  = 5;        // chamfer leg length along X and Z (mm)
chamfer_ang  = 45;       // chamfer angle (degrees)

eps          = 0.5;      // cutter overshoot past faces (mm)
$fn          = 96;       // curve resolution

// ---------- Derived ----------
x0 = first_x;
y0 = first_y;

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 through-holes, 8 rows x 12 columns
    for (i = [0 : hole_rows - 1])
        for (j = [0 : hole_cols - 1])
            translate([x0 + j * hole_pitch, y0 + i * hole_pitch, -eps])
                cylinder(d = hole_d, h = block_ht + 2 * eps);

    // Orientation chamfer at A1 corner (cut off vertical edge, 45 deg, 5 mm legs)
    translate([-block_len/2 + x0, -block_wid/2 + y0, 0])
        linear_extrude(height = block_wid - 2 * chamfer_leg)
            polygon([[-chamfer_leg, 0], [chamfer_leg, 0], [chamfer_leg, chamfer_leg]]);
}