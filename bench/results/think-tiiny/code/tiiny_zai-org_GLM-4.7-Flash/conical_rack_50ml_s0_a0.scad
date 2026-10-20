$fn = 64;

// Plate Dimensions
plate_length_x = 130;
plate_width_y = 90;
plate_thickness_z = 4;

// Tube Rack Dimensions
hole_diameter = 30.5;
grid_cols = 3;
grid_rows = 2;
spacing = 40;

// Wall Dimensions
wall_length_x = 130;
wall_thickness_y = 4;
wall_height_z = 70;

// Calculate hole positions
// Center the grid on the plate
x_offsets = [for (i = [0 : grid_cols - 1]) (i - (grid_cols - 1) / 2) * spacing];
y_offsets = [for (j = [0 : grid_rows - 1]) (j - (grid_rows - 1) / 2) * spacing];

module base_plate() {
    cube([plate_length_x, plate_width_y, plate_thickness_z]);
}

module holes() {
    for (x = x_offsets) {
        for (y = y_offsets) {
            // Extrude slightly past the top face to ensure clean cut
            translate([x, y, 0])
            cylinder(r = hole_diameter / 2, h = plate_thickness_z + 0.01, $fn = 64);
        }
    }
}

module walls() {
    // Wall 1 (Back/Left edge)
    // Centered on y = -plate_width_y / 2
    translate([0, -plate_width_y / 2, 0])
    cube([wall_length_x, wall_thickness_y, wall_height_z]);

    // Wall 2 (Front/Right edge)
    // Centered on y = +plate_width_y / 2
    translate([0, plate_width_y / 2, 0])
    cube([wall_length_x, wall_thickness_y, wall_height_z]);
}

union() {
    base_plate();
    holes();
    walls();
}