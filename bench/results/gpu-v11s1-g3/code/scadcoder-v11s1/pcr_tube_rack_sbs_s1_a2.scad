// 96-well PCR tube rack - microplate footprint (ANSI/SLAS)
// Print orientation: flat on bed, holes open top and bottom

// ---- Block ----
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---- Holes ----
hole_d     = 6.2;   // hole diameter
hole_rows  = 8;     // rows along Y
hole_cols  = 12;    // columns along X
hole_pitch = 9.0;   // centre-to-centre spacing
hole_x0    = 14.38; // first hole offset from left edge
hole_y0    = 11.24; // first hole offset from back edge

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 96;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 through-holes
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([hole_x0 + i*hole_pitch - block_l/2,
                       hole_y0 + j*hole_pitch - block_w/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps, $fn = 96);
}

// Orientation mark: 45-degree chamfer off the A1 corner (x = -56.69, y = 39.12)
translate([-block_l/2, -block_w/2, 0])
    linear_extrude(height = block_h)
        polygon(points = [
            [-66.69, 44.12], [-56.69, 44.12], [-56.69, 39.12],
            [-61.69, 34.12], [-66.69, 34.12]
        ]);