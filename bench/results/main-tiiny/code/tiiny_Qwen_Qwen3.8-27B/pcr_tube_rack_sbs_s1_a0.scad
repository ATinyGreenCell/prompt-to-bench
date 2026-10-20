// 96-well PCR tube rack (0.2 mL) — ANSI/SLAS microplate footprint
// Print orientation: block rests on XY plane (z = 0), builds upward (+Z), centred on origin in X & Y.

// ---- Block dimensions (measured with calipers) ----
L = 127.76;   // length  (X)
W = 85.48;    // width   (Y)
H = 20.0;     // height  (Z)

// ---- Hole grid ----
n_rows  = 8;  // rows along Y
n_cols  = 12; // columns along X
pitch   = 9.0;    // centre-to-centre spacing (mm)
hole_d  = 6.2;    // through-hole diameter (mm)
hole_r  = hole_d / 2;

// A1 (first hole) is 14.38 mm from the left edge and 11.24 mm from the back edge.
// With the block centred on the origin, the left edge is at x = -L/2 and the back edge at y = -W/2.
x0 = -L/2 + 14.38;   // X coordinate of the A1 hole centre
y0 = -W/2 + 11.24;   // Y coordinate of the A1 hole centre

// ---- 45° chamfer on the vertical edge at the A1 corner (orientation mark) ----
// The A1 corner is the (left, back) vertical edge, i.e. the corner at (x = -L/2, y = -W/2).
// A 5 mm leg on each side gives a 45° chamfer.
chamfer_leg = 5.0;

$fn = 64;

// ---- Build the rack ----
difference() {
    // Solid block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // 96 vertical through-holes (extend 1 mm past top and bottom faces)
    for (i = [0 : n_rows - 1]) {
        for (j = [0 : n_cols - 1]) {
            hx = x0 + j * pitch;
            hy = y0 + i * pitch;
            translate([hx, hy, -1])
                cylinder(h = H + 2, r = hole_r, $fn = 64);
        }
    }

    // 45° chamfer cutter at the A1 corner (left-back vertical edge)
    // The cutter is a triangular prism that removes a 5 mm × 5 mm corner.
    // It extends 1 mm past the top and bottom faces to ensure a clean cut.
    translate([-L/2, -W/2, -1])
        linear_extrude(height = H + 2, center = false)
            polygon(points = [
                [0, 0],
                [chamfer_leg, 0],
                [0, chamfer_leg]
            ]);
}