// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
block_l = 127.76;   // length along X
block_w = 85.48;    // width along Y
block_h = 20;       // height along Z

// ---- Holes ----
hole_d   = 6.2;     // hole diameter
hole_n_r = 8;       // rows along Y
hole_n_c = 12;      // columns along X
hole_p   = 9.0;     // centre-to-centre spacing
x0       = 14.38;   // first hole X offset from left edge
y0       = 11.24;   // first hole Y offset from back edge

// ---- Chamfer ----
cham_f = 5;         // 45-degree chamfer leg length at A1 corner

$fn = 48;

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Through-holes
    for (i = [0 : hole_n_c - 1])
        for (j = [0 : hole_n_r - 1])
            translate([(i - (hole_n_c - 1)/2)*hole_p + x0,
                       (j - (hole_n_r - 1)/2)*hole_p + y0,
                       -1])
                cylinder(d = hole_d, h = block_h + 2);

    // Orientation chamfer at A1 corner (top edge, 45 deg, 5 mm legs)
    translate([0, 0, block_h])
        linear_extrude(height = cham_f, center = true)
            polygon(points = [
                [0, 0],
                [block_l/2 - cham_f, cham_f],
                [block_l/2, 0]
            ]);
}