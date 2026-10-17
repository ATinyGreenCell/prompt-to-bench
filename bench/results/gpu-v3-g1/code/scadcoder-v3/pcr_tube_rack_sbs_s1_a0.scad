// 96-well PCR tube rack - standard microplate footprint
// Units: mm

// ---- Block ----
block_l = 127.76;      // length (X)
block_w = 85.48;       // width (Y)
block_h = 20;          // height (Z)

// ---- Holes ----
hole_d     = 6.2;      // through-hole diameter
n_cols     = 12;       // columns along X
n_rows     = 8;        // rows along Y
pitch_x    = 9.0;      // centre-to-centre spacing X
pitch_y    = 9.0;      // centre-to-centre spacing Y
hole_x0    = 14.38;    // first hole X from left edge
hole_y0    = 11.24;    // first hole Y from back edge

// ---- Chamfer (orientation mark at A1 corner) ----
chamfer_d = 5;         // chamfer leg length
chamfer_a = 45;        // chamfer angle

$fn = 64;

difference() {
    // Block centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 vertical through-holes, grid centred on block
    for (i = [0 : n_cols - 1])
        for (j = [0 : n_rows - 1])
            translate([(i - (n_cols - 1)/2) * pitch_x + hole_x0,
                       (j - (n_rows - 1)/2) * pitch_y + hole_y0,
                       -1])
                cylinder(d = hole_d, h = block_h + 2);

    // 45-degree chamfer off the A1 vertical edge
    translate([-block_l/2 - 1, -block_w/2 - 1, 0])
        translate([block_l/2 + 1, block_w/2 + 1, block_h])
            chamfer_d = chamfer_d;
            chamfer_a = chamfer_a;
            linear_extrude(height = block_h + 2)
                polygon([[-block_l/2 - 1, -block_w/2 - 1],
                         [-block_l/2 - 1,  block_w/2 + 1],
                         [ block_l/2 + 1, -block_w/2 - 1],
                         [ block_l/2 + 1, -block_w/2 + chamfer_d],
                         [ block_l/2 + chamfer_d, 0],
                         [ block_l/2 + chamfer_d, block_w/2 + 1]]);
}