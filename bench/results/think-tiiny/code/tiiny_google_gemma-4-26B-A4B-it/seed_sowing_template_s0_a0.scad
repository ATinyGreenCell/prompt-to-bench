// Dimensions
disc_diameter = 85;      // Diameter of the disc in mm
disc_thickness = 2;      // Thickness of the disc in mm
grid_count = 7;          // Number of holes in the X and Y directions
hole_diameter = 3;       // Diameter of each through-hole in mm
hole_spacing = 9;        // Center-to-center spacing of the holes in mm
notch_width = 10;        // Width of the orientation notch along the X axis in mm
notch_depth = 4;         // Depth of the orientation notch from the rim along the Y axis in mm

// Resolution
$fn = 64;

// The part is built starting from Z=0 upwards
difference() {
    // Main Disc Body
    cylinder(h = disc_thickness, d = disc_diameter);

    // 7x7 Grid of through-holes
    // We use a nested loop to create the grid and center it by offsetting the index
    for (i = [0 : grid_count - 1]) {
        for (j = [0 : grid_count - 1]) {
            // Calculate center-to-center position
            // (i - (grid_count-1)/2) centers the grid on the origin
            translate([
                (i - (grid_count - 1) / 2) * hole_spacing, 
                (j - (grid_count - 1) / 2) * hole_spacing, 
                -0.5 // Extend slightly below the base to ensure clean cut
            ])
            cylinder(h = disc_thickness + 1, d = hole_diameter);
        }
    }

    // Rectangular orientation notch on the +Y side
    // Positioned at the rim (disc_diameter/2) and extending inward by notch_depth
    translate([
        -notch_width / 2, 
        disc_diameter / 2 - notch_depth, 
        -0.5 // Extend slightly below the base to ensure clean cut
    ])
    cube([notch_width, notch_depth + 0.1, disc_thickness + 1]);
}