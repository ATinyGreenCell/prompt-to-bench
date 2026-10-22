$fn = 64; // smoothness for cylinders

// Plate dimensions
plate_X = 130;
plate_Y = 90;
plate_Z = 4;

// Hole dimensions
hole_d = 30.5;
hole_r = hole_d/2;

// Hole grid: 3 columns (X), 2 rows (Y), 40 mm centre‑to‑centre
hole_grid_X = 3;
hole_grid_Y = 2;
hole_spacing = 40;

// Wall dimensions
wall_X = 130;
wall_Y = 4;
wall_Z = 70;

// ---------------------------------------------------------------------
// Build plate with through‑holes
// ---------------------------------------------------------------------
plate = difference() {
    // Plate (centred on origin)
    translate([ -plate_X/2, -plate_Y/2, 0 ])
        cube([ plate_X, plate_Y, plate_Z ], center=false);

    // Holes (extend 0.01 mm beyond each face)
    for (i = [0:hole_grid_X-1]) {
        for (j = [0:hole_grid_Y-1]) {
            // Relative centre positions
            x_rel = -hole_spacing*(hole_grid_X-1)/2 + i*hole_spacing;
            y_rel = -hole_spacing*(hole_grid_Y-1)/2 + j*hole_spacing;

            // Absolute positions (plate is centred on origin)
            x_abs = -plate_X/2 + x_rel;
            y_abs = -plate_Y/2 + y_rel;

            translate([ x_abs, y_abs, -0.01 ])
                cylinder( h = plate_Z + 0.02, r = hole_r, center=false );
        }
    }
}

// ---------------------------------------------------------------------
// Build walls
// ---------------------------------------------------------------------
// Left wall flush with plate's long edge at Y = -45
left_wall = translate([ -wall_X/2, -plate_Y/2 - wall_Y, 0 ])
                cube([ wall_X, wall_Y, wall_Z ], center=false);

// Right wall flush with plate's long edge at Y = +45
right_wall = translate([ -wall_X/2, +plate_Y/2, 0 ])
                cube([ wall_X, wall_Y, wall_Z ], center=false);

// ---------------------------------------------------------------------
// Combine all parts
// ---------------------------------------------------------------------
rack = union() {
    plate;
    left_wall;
    right_wall;
}

rack;