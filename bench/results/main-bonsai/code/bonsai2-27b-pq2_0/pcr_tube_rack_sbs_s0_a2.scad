// 96-well PCR tube rack (0.2 mL)
// ANSI/SLAS microplate footprint: 127.76 x 85.48 x 20 mm
// 96 through-holes, 6.2 mm dia, 8 rows x 12 cols, 9.0 mm pitch
// 45-degree chamfer, 5 mm legs, on the A1 vertical edge

// Block dimensions
L = 127.76;   // length (X)
W = 85.48;    // width  (Y)
H = 20.0;     // height (Z)

// Hole grid
d_hole = 6.2;  // hole diameter
n_rows = 8;    // rows along Y
n_cols = 12;   // columns along X
pitch = 9.0;   // centre-to-centre spacing

// A1 hole position (centre of first hole)
x_a1 = 14.38;  // from left edge (X)
y_a1 = 11.24;  // from back edge (Y)

// Chamfer
chamfer_leg = 5.0;  // leg length of 45-degree chamfer

// Render settings
$fn = 64;

// Build the block
block = cube([L, W, H], center=[0, 0, H/2]);

// Build the 96 through-holes
// Holes are centred on the block in X and Y
// A1 is at (x_a1, y_a1) from the left/back edges
// Block is centred at origin, so left edge is at x = -L/2, back edge at y = -W/2
// A1 centre in block coords: x = -L/2 + x_a1, y = -W/2 + y_a1
// Row i (0..7) is at y = y_a1 + i*pitch from back edge
// Col j (0..11) is at x = x_a1 + j*pitch from left edge

holes = union();
for (i = 0; i < n_rows; i++) {
    for (j = 0; j < n_cols; j++) {
        hx = -L/2 + x_a1 + j * pitch;
        hy = -W/2 + y_a1 + i * pitch;
        // Extend 0.5 mm past top and bottom faces
        translate([hx, hy, -H/2 - 0.5])
            cylinder(d = d_hole, h = H + 1.0, $fn = $fn);
    }
}

// Chamfer: 45-degree cut on the vertical edge at the A1 corner
// A1 corner is at the left-back-top corner of the block
// Left edge: x = -L/2, Back edge: y = -W/2
// The vertical edge at A1 corner is the line x = -L/2, y = -W/2, z from 0 to H
// A 45-degree chamfer with 5 mm legs cuts a triangular prism
// from the top face and the two side faces meeting at that edge
// The chamfer removes material where:
//   (x - (-L/2)) + (y - (-W/2)) < chamfer_leg  AND  z > H - chamfer_leg
// i.e. x + L/2 + y + W/2 < chamfer_leg  AND  z > H - chamfer_leg

// Build the chamfer cutter as a triangular prism
// In the XY plane at the A1 corner, the cut region is a right triangle
// with legs of length chamfer_leg along +X and +Y from the corner
// The prism extends from z = H - chamfer_leg to z = H + 0.5 (past top)

// Triangle vertices in XY (relative to corner at (-L/2, -W/2)):
//   (0, 0), (chamfer_leg, 0), (0, chamfer_leg)
// In absolute XY:
//   (-L/2, -W/2), (-L/2 + chamfer_leg, -W/2), (-L/2, -W/2 + chamfer_leg)

chamfer_cutter = linear_extrude(
    height = chamfer_leg + 0.5,
    center = false
) polygon(
    points = [
        [-L/2, -W/2],
        [-L/2 + chamfer_leg, -W/2],
        [-L/2, -W/2 + chamfer_leg]
    ]
);

// Place the cutter so its bottom is at z = H - chamfer_leg
// and it extends 0.5 mm past the top face
translate([0, 0, H - chamfer_leg])
    chamfer_cutter;

// Final model
difference() {
    block;
    holes;
    translate([0, 0, H - chamfer_leg])
        chamfer_cutter;
}