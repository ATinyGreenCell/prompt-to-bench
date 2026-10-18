// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds up +Z

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

// ---- Chamfer ----
chamf_leg  = 5;     // 45-degree chamfer leg length
chamf_r    = block_l/2 + block_w/2 - 2*chamf_leg; // outer radius reach

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 64;

difference() {
    union() {
        // Main block, centred in X/Y, sitting on z = 0
        translate([-block_l/2, -block_w/2, 0])
            cube([block_l, block_w, block_h]);

        // Orientation chamfer at A1 corner (top right in XY)
        translate([block_l - chamf_leg, block_w - chamf_leg, block_h])
            cube([chamf_leg, chamf_leg, chamf_leg]);
    }

    // 96 through-holes, centred on the block
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([(i - (hole_cols - 1)/2) * hole_pitch + hole_x0,
                       (j - (hole_rows - 1)/2) * hole_pitch + hole_y0,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps, $fn = 64);
}