// 96 PCR tube (0.2 mL) rack - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
plate_len   = 127.76;   // X length of block
plate_wid   = 85.48;    // Y width of block
plate_ht    = 20;       // block height (Z)

// ---- Holes ----
hole_d      = 6.2;      // through-hole diameter
hole_rows   = 8;        // rows along Y
hole_cols   = 12;       // columns along X
hole_pitch  = 9.0;      // centre-to-centre spacing
hole_x0     = 14.38;    // first hole X offset from left edge
hole_y0     = 11.24;    // first hole Y offset from back edge

// ---- Chamfer ----
chamfer_leg = 5;        // 45-degree chamfer leg length
chamfer_r   = chamfer_leg / sqrt(2); // radius of the corner circle

// ---- Misc ----
eps         = 0.5;      // cutter overshoot past faces
$fn         = 96;       // curve resolution

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_ht]);

    // 96 through-holes, 8 x 12 grid
    for (r = [0 : hole_rows - 1])
        for (c = [0 : hole_cols - 1])
            translate([hole_x0 + c * hole_pitch,
                       hole_y0 + r * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_ht + 2 * eps);

    // 45-degree chamfer at the A1 corner (minimum X/Y)
    translate([-plate_len/2 - eps, -plate_wid/2 - eps, 0])
        rotate([0, 90, 0])
            cylinder(r = chamfer_r, h = plate_ht + eps);
}