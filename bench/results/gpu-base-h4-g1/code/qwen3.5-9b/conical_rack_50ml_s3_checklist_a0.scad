// Rack for six 50 mL conical (Falcon-type) tubes.
// Print orientation: Flat plate on bed (z=0), walls rising to z=70.
// After printing, flip over so walls are on the bed and tubes hang down.

// Plate dimensions
L     = 130; // Length (X)
W     = 90;  // Width (Y)
t_plate = 4; // Plate thickness (Z)

// Tube hole dimensions
n_rows = 2; // Rows along Y
n_cols = 3; // Columns along X
d_hole = 30.5; // Hole diameter
p_x = 40; // Centre-to-centre spacing X
p_y = 40; // Centre-to-centre spacing Y

// Wall dimensions
wall_h = 70; // Wall height (Z)
wall_t = 4;  // Wall thickness (Y)

// Geometry calculations
// Plate is centred on origin, so edges are at +/- L/2 and +/- W/2.
// Holes are centred on plate.
// Rows are along Y, Columns along X.
// Spacing is 40mm. With 2 rows, distance from centre is 20mm.
// With 3 cols, positions are -40, 0, +40.

hole_y_offset = (n_rows - 1) * p_y / 2;
hole_x_positions = [for (i = [0 : n_cols - 1]) (i - (n_cols - 1) / 2) * p_x];
hole_y_positions = [for (i = [0 : n_rows - 1]) (i - (n_rows - 1) / 2) * p_y];

$fn = 64;

module tube_hole(y_pos) {
    translate([0, y_pos, 0]) cylinder(h = t_plate + 1, d = d_hole);
}

difference() {
    union() {
        // 1. The flat base plate
        translate([-L / 2, -W / 2, 0]) cube([L, W, t_plate]);

        // 2. Two solid walls along the long edges (X axis)
        // Left wall at Y = -W/2
        translate([-L / 2, -W / 2, 0]) cube([L, wall_t, wall_h]);
        // Right wall at Y = +W/2
        translate([-L / 2, W / 2, 0]) cube([L, wall_t, wall_h]);
    }

    // Cut the holes
    for (y in hole_y_positions) {
        for (x in hole_x_positions) {
            translate([x, y, 0]) cylinder(h = t_plate + 1, d = d_hole);
        }
    }
}