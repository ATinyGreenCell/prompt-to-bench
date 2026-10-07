// Dimensions in mm
X = 106;
Y = 72;
Z = 30;

// Hole grid dimensions
hole_diameter = 11.2;
hole_depth = 25;
floor_thickness = 5;

// Calculate hole spacing and centre point
hole_spacing_x = (X - hole_diameter * 6) / 7;
hole_spacing_y = (Y - hole_diameter * 4) / 3;
hole_centre_x = X / 2;
hole_centre_y = Y / 2;

// Create the bench rack
difference() {
    // Main block
    linear_extrude(Z)
        polygon([0, Y, Y, 0, 0], $fn=64);

    // Hole grid
    for (y = [0:3]) {
        y_offset = hole_centre_y + y * hole_spacing_y;
        for (x = [0:5]) {
            x_offset = hole_centre_x + x * hole_spacing_x;
            translate([x_offset, y_offset, 0])
                cylinder(h=hole_depth, r=(hole_diameter/2), $fn=64);
        }
    }

    // Floor
    linear_extrude(Z - floor_thickness)
        polygon([0, Y, Y, 0, 0], $fn=64);

}