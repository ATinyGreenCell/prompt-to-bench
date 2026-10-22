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

// Chamfer corner (the A1 vertical edge) in absolute coordinates
cx = x0 + a1_x;
cy = y0 + a1_y;

// ---- Build ----
$fn = 64;

difference() {
    // Main block, centred on origin in X and Y, base at z = 0
    translate([0, 0, 0])
        cube([L, W, H], center = [true, true, false]);

    // 96 vertical through-holes (extend 1 mm past each face so cuts are clean)
    for (i = [0 : n_cols - 1])
        for (j = [0 : n_rows - 1])
            translate([x0 + a1_x + i * pitch, y0 + a1_y + j * pitch, -1])
                cylinder(h = H + 2, r = hole_r, $fn = 64);

    // 45° chamfer (5 mm legs) off the vertical edge at the A1 corner.
    // The A1 corner is the block corner nearest the A1 hole: the left edge (x = x0)
    // meets the back edge (y = y0) at (x0, y0). Remove a right-triangle corner
    // with 5 mm legs along +X and +Y, extruded through the full height.
    translate([x0, y0, -1])
        linear_extrude(h = H + 2, center = false)
            polygon(points = [
                [0, 0],
                [chamfer_leg, 0],
                [0, chamfer_leg]
            ]);
}