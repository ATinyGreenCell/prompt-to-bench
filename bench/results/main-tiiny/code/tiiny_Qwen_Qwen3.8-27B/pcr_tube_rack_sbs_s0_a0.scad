// 96-well (0.2 mL PCR tube) rack — ANSI/SLAS microplate footprint
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

// ---- Block dimensions (measured with calipers) ----
L = 127.76;   // length along X (mm)
W = 85.48;    // width  along Y (mm)
H = 20.0;     // height along Z (mm)

// ---- Hole grid ----
n_rows  = 8;  // rows along Y
n_cols  = 12; // columns along X
pitch   = 9.0;    // centre-to-centre spacing (mm)
hole_d  = 6.2;    // through-hole diameter (mm)

// A1 (first hole) offset from the left (X) and back (Y) edges of the block
off_x   = 14.38;  // from left edge
off_y   = 11.24;  // from back edge

// ---- 45° chamfer on the vertical edge at the A1 corner (orientation mark) ----
chamfer = 5.0;    // leg length on each face (mm)

// ---- Derived geometry (block centred on origin) ----
x0 = -L / 2;      // left face  (X)
x1 =  L / 2;      // right face (X)
y0 = -W / 2;      // back face   (Y)
y1 =  W / 2;      // front face  (Y)

// A1 corner is the (left, back) vertical edge
cx = x0;          // X of A1 corner
cy = y0;          // Y of A1 corner

// A1 hole centre in block coordinates
ax = x0 + off_x;  // = -49.5
ay = y0 + off_y;  = -31.5;

// ---- Chamfer cutting wedge (45°, 5 mm legs) ----
// Triangle in the XY plane at the A1 corner, extruded through the full height.
// Vertices: corner, +chamfer along X, +chamfer along Y.
chamfer_poly = [
    [cx, cy],
    [cx + chamfer, cy],
    [cx, cy + chamfer]
];

// ---- Build ----
$fn = 64;

difference() {
    // Solid block
    translate([x0, y0, 0])
        cube([L, W, H]);

    // 45° chamfer off the A1 vertical edge
    linear_extrude(height = H + 0.01)
        polygon(chamfer_poly);

    // 96 vertical through-holes (8 rows x 12 cols)
    for (r = [0 : n_rows - 1]) {
        for (c = [0 : n_cols - 1]) {
            hx = ax + c * pitch;
            hy = ay + r * pitch;
            translate([hx, hy, -0.01])
                cylinder(h = H + 0.02, d = hole_d);
        }
    }
}