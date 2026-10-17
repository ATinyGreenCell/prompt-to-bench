// 96-well PCR tube rack - standard microplate footprint
// Units: mm

// ---- Block ----
block_l = 127.76;      // length (X)
block_w = 85.48;       // width (Y)
block_h = 20;          // height (Z)

// ---- Holes ----
hole_d     = 6.2;       // through-hole diameter
n_cols     = 12;        // columns along X
n_rows     = 8;         // rows along Y
pitch_x    = 9.0;       // centre-to-centre spacing X
pitch_y    = 9.0;       // centre-to-centre spacing Y
hole_x0    = 14.38;     // first hole X from left edge
hole_y0    = 11.24;     // first hole Y from back edge

// ---- Chamfer ----
chamfer_t  = 5;         // chamfer leg length
chamfer_d  = 45;        // chamfer angle from vertical

$fn = 64;

difference() {
    // Block, centred in XY, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // 96 tube holes, grid centred on block
    for (i = [0 : n_cols - 1])
        for (j = [0 : n_rows - 1])
            translate([hole_x0 + i * pitch_x, hole_y0 + j * pitch_y, -1])
                cylinder(d = hole_d, h = block_h + 2);

    // Orientation mark: 45-degree chamfer on A1 corner edge
    translate([-block_l/2 - 0.01, -block_w/2 - 0.01, 0])
        linear_extrude(height = block_h + 0.01)
            polygon([[-block_l/2, -block_w/2],
                     [-block_l/2 + chamfer_t, -block_w/2],
                     [-block_l/2, -block_w/2 + chamfer_t]]);
}