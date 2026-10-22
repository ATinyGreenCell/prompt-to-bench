// 96-well PCR tube rack (0.2 mL) — ANSI/SLAS microplate footprint
// Print orientation: rests on XY plane (z = 0), builds upward (+Z), centred on origin in X and Y.

// ---- Block dimensions (mm) ----
L = 127.76;   // length along X
W = 85.48;    // width  along Y
H = 20;       // height along Z

// ---- Hole grid ----
n_rows  = 8;  // rows along Y
n_cols  = 12; // columns along X
pitch   = 9.0;    // centre-to-centre spacing (both X and Y)
hole_d  = 6.2;    // hole diameter
hole_r  = hole_d / 2;

// A1 (first hole) offset from the left (X) and back (Y) edges
a1_x = 14.38;
a1_y = 11.24;

// ---- Chamfer (orientation mark at the A1 corner) ----
chamfer_leg = 5;   // 5 mm legs, 45° chamfer on the vertical edge at the A1 corner

// ---- Derived centred coordinates ----
// Block spans x in [-L/2, L/2] and y in [-W/2, W/2]
x0 = -L / 2;  // left edge
y0 = -W / 2;  // back edge

// Hole centre positions (absolute, centred on origin)
hole_x = x0 + a1_x + [0 : n_cols - 1] * pitch;   // 12 columns
hole_y = y0 + a1_y + [0 : n_rows - 1] * pitch;   // 8 rows

// Chamfer corner (the A1 vertical edge) in absolute coordinates
cx = x0 + a1_x;
cy = y0 + a1_y;

// ---- Build ----
$fn = 64;

difference() {
    // Main block
    translate([0, 0, 0])
        cube([L, W, H], center = [true, true, false]);

    // 96 vertical through-holes
    for (hx = hole_x)
        for (hy = hole_y)
            translate([hx, hy, -1])   // extend 1 mm below z=0 so the cut is clean
                cylinder(h = H + 2, r = hole_r, $fn = 64);

    // 45° chamfer (5 mm legs) off the vertical edge at the A1 corner
    // The A1 corner is the vertical edge of the block nearest the A1 hole.
    // We cut a triangular prism that removes a 5 mm x 5 mm corner from that vertical edge.
    // The corner in plan view is at (cx, cy). The block edges meeting there are:
    //   - the left edge  (x = x0)  running along Y
    //   - the back edge  (y = y0)  running along X
    // The chamfer removes the corner between these two edges.
    // In plan view the cut is a right triangle with legs of length chamfer_leg
    // along +X and +Y from the corner point (x0, y0).
    // We model it as a polygon extruded through the full height, extended 1 mm past top and bottom.
    translate([x0, y0, -1])
        linear_extrude(h = H + 2, center = false)
            polygon(points = [
                [0, 0],
                [chamfer_leg, 0],
                [0, chamfer_leg]
            ]);
}