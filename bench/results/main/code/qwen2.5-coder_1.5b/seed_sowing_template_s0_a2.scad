// Define variables for dimensions
$fn = 64; // For curved shapes

// Create the Petri dish disc
disc_diameter = 85;
disc_thickness = 2;
disc_radius = disc_diameter / 2;

// Create the through-holes grid
hole_spacing_x = 3;
hole_spacing_y = 9;
num_rows = 7;
num_cols = 7;

// Calculate hole positions
for (x = [0:num_cols-1], y = [0:num_rows-1]) {
    x_pos = disc_radius + hole_spacing_x * x;
    y_pos = disc_radius + hole_spacing_y * y;
    translate([x_pos, y_pos, disc_thickness / 2]) {
        cylinder(disc_radius - hole_spacing_x / 2, disc_radius + hole_spacing_x / 2, disc_thickness);
    }
}

// Create the rectangular orientation notch
notch_width = 10;
notch_depth = 4;

// Calculate notch position
notch_x = disc_radius;
notch_y = disc_radius;

// Create the notch
translate([notch_x, notch_y, notch_depth / 2]) {
    cylinder(disc_radius - notch_width / 2, disc_radius + notch_width / 2, notch_depth);
}