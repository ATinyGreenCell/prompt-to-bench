// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

// Block dimensions (measured with calipers)
L = 106;   // length along X
W = 72;    // width along Y
H = 30;    // height along Z

// Hole grid
n_rows = 4;        // rows along Y
n_cols = 6;        // columns along X
pitch = 16;        // centre-to-centre spacing in both X and Y
hole_d = 11.2;     // hole diameter
hole_depth = 25;   // depth of each hole (open at top, closed at bottom)
floor = 5;         // solid floor thickness (H - hole_depth)

// Chamfer at the top of each hole: turns the flat downward-facing ceiling
// into a 45-degree slope so FDM printing needs no supports.
cham = 1;          // chamfer size (mm)

// Curved-surface resolution
$fn = 64;

// Grid extents (centres)
x_span = (n_cols - 1) * pitch;   // 80 mm
y_span = (n_rows - 1) * pitch;   // 48 mm

// Base block, centred on origin in X and Y, sitting on z = 0
module block() { translate([-L/2, -W/2, 0]) cube([L, W, H]); }

// One vertical hole (cylinder) with a 45-degree chamfer at its top,
// centred at (x, y). Open at the top, closed at the bottom.
module hole() {
    // Straight cylindrical wall, from the floor up to the start of the chamfer.
    // Extended 1 mm past the top face so the difference cut is not coplanar.
    cylinder(h = hole_depth + 1 - cham, d = hole_d, $fn = $fn);
    // 45-degree conical chamfer at the top of the hole.
    // Bottom radius = hole_d/2, top radius = hole_d/2 + cham, height = cham.
    // Extended 1 mm past the top face so the cut is not coplanar.
    translate([0, 0, hole_depth - cham])
        cylinder(h = cham + 1, r1 = hole_d/2, r2 = hole_d/2 + cham, $fn = $fn);
}

// Difference: block minus all 24 holes
difference() {
    block();
    for (i = [0 : n_cols - 1]) {
        for (j = [0 : n_rows - 1]) {
            x = -x_span/2 + i * pitch;
            y = -y_span/2 + j * pitch;
            translate([x, y, 0]) hole();
        }
    }
}