// Dimensions for DIY magnetic stirrer housing
$fn = 64;

// Overall dimensions
outer_width = 90;        // X dimension
outer_depth = 90;        // Y dimension
top_thickness = 2;       // Z thickness of top plate
wall_height = 40;         // Height of walls from top plate
wall_thickness = 2.5;      // Thickness of side walls

// Screw hole parameters
screw_diameter = 4.5;      // Diameter of screw holes
screw_pattern_diameter = 71.5; // Diagonal distance between screw holes (square pattern)

// Cable notch parameters
notch_width = 12;         // Width of cable notch
notch_depth = 8;          // Depth of notch from open edge (z = 32 to z = 40)
notch_position = 45;        // Center of notch along the wall (Y direction)

// Calculate center of top plate
plate_center_x = outer_width / 2;
plate_center_y = outer_depth / 2;

// Calculate screw hole positions (on a square pattern)
screw_offset = screw_pattern_diameter / 2;

// Define the housing as a top plate with walls and features
module housing() {
    // Top plate (z = 0 to 2)
    translate([0, 0, 0])
        cube([outer_width, outer_depth, top_thickness], center = true);

    // Four walls (2.5 mm thick) rising from top plate
    // Front wall (Y = -45 to -45 + wall_thickness) and back wall (Y = 45 - wall_thickness to 45)
    // Left wall (X = -45 to -45 + wall_thickness) and right wall (X = 45 - wall_thickness to 45)

    // Front wall (Y = -45 to -45 + wall_thickness, Z = 0 to 40)
    translate([0, -45 + wall_thickness/2, 0])
        cube([outer_width, wall_thickness, wall_height], center = true);

    // Back wall (Y = 45 - wall_thickness to 45, Z = 0 to 40)
    translate([0, 45 - wall_thickness/2, 0])
        cube([outer_width, wall_thickness, wall_height], center = true);

    // Left wall (X = -45 to -45 + wall_thickness, Z = 0 to 40)
    translate([-45 + wall_thickness/2, 0, 0])
        cube([wall_thickness, outer_depth, wall_height], center = true);

    // Right wall (X = 45 - wall_thickness to 45, Z = 0 to 40)
    translate([45 - wall_thickness/2, 0, 0])
        cube([wall_thickness, outer_depth, wall_height], center = true);

    // Cut screw holes through top plate (z = 0 to 2) using cylinders
    for (i = [0:1]) {
        for (j = [0:1]) {
            // Two screws on each diagonal: (i,j) = (0,0): bottom-left, (0,1): bottom-right, etc.
            // Screw positions: (±screw_offset, ±screw_offset)
            screw_x = (i == 0 ? -screw_offset : screw_offset);
            screw_y = (j == 0 ? -screw_offset : screw_offset);

            translate([screw_x, screw_y, -0.1]) // -0.1 to ensure full penetration through top plate
                cylinder(h = top_thickness + 0.2, r = screw_diameter / 2, center = true);
        }
    }

    // Cut cable notch in the back wall (Y = 45 - wall_thickness to 45)
    // Notch is 12 mm wide, centered along Y, from z = 32 to z = 40 (8 mm deep)
    // Position: X = -45 to 45 (full X span), Y = 45 - wall_thickness to 45, Z = 32 to 40
    // But we cut a rectangular hole in the back wall

    // Define notch dimensions: centered on Y = 45 - wall_thickness/2, but we need to cut from Y = 45 - wall_thickness to 45
    // So we cut a rectangle in the back wall from Y = 45 - wall_thickness to 45, X = -45 to 45, Z = 32 to 40
    // But we want a notch that is 12 mm wide in X, centered at X = 0

    notch_x_min = -notch_width / 2;
    notch_x_max = notch_width / 2;
    notch_y_min = 45 - wall_thickness;
    notch_y_max = 45;
    notch_z_min = 32;
    notch_z_max = 40;

    // Cut notch using a cube that extends slightly beyond the wall
    translate([0, 45 - wall_thickness/2, 32])
        cube([notch_width + 0.1, wall_thickness + 0.1, notch_depth + 0.1], center = true);
}

// Render the housing
housing();