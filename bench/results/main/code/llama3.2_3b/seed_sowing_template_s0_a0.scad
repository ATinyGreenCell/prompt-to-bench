// Dimensions in mm
$fn = 64;
disc_diameter = 85;
disc_thickness = 2;
hole_diameter = 3;
hole_spacing = 9;
notch_width = 10;
notch_depth = 4;

// Calculate hole grid dimensions
hole_grid_size_x = floor((disc_diameter - (7 * hole_diameter)) / (2 * hole_spacing));
hole_grid_size_y = 7;

// Create disc
translate([0, 0, disc_thickness/2])
    cylinder(h=disc_thickness, r=(disc_diameter/2));

// Create through-holes grid
for (y = [0 : hole_grid_size_y - 1]) {
    for (x = [0 : hole_grid_size_x - 1]) {
        translate([x * hole_spacing/2 + disc_diameter/4,
                  y * hole_spacing/2 + disc_diameter/4,
                  disc_thickness/2])
            cylinder(h=disc_thickness, r=hole_diameter/2);
    }
}

// Create rectangular orientation notch
translate([0, (notch_width - 1)/2, disc_thickness/2])
    linear_extrude(height=disc_thickness)
        polygon(points=[[0, disc_thickness],
                       [notch_width, disc_thickness],
                       [notch_width, disc_thickness + notch_depth],
                       [0, disc_thickness + notch_depth]]);

// Mirror to create second half of notch
mirror([0, 1, 0])
    linear_extrude(height=disc_thickness)
        polygon(points=[[0, disc_thickness],
                       [notch_width, disc_thickness],
                       [notch_width, disc_thickness + notch_depth],
                       [0, disc_thickness + notch_depth]]);