// Dimensions for the rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed (z = 0 to 4), walls rise from edges
// After flipping, rack stands on walls, tubes through holes

// Plate dimensions
plate_length_X = 130;   // mm
plate_width_Y = 90;     // mm
plate_thickness_Z = 4;   // mm

// Hole parameters
hole_diameter = 30.5;   // mm
hole_spacing_X = 40;   // mm (center-to-center along X)
hole_spacing_Y = 40;   // mm (center-to-center along Y)
num_holes_X = 3;       // 3 holes along X (2 rows of 3)
num_holes_Y = 2;       // 2 rows along Y

// Wall parameters
wall_length_X = plate_length_X;     // 130 mm
wall_thickness_Y = 4;                 // mm (along Y)
wall_height_Z = 70;                 // mm (from plate to top)

// Set resolution for smooth curves
$fn = 64;

// Main module
module rack() {
    // 1. Plate: flat rectangular base, centered at origin (X, Y) = (0, 0)
    // Plate extends from -65 to +65 in X, -45 to +45 in Y, z = 0 to 4
    translate([0, 0, 0])
        cube([plate_length_X, plate_width_Y, plate_thickness_Z], center = true);

    // 2. Holes: 2 rows of 3 holes, centered on plate
    // Center of grid: (0, 0) for the whole array
    // Hole positions: offset from center by half-grid span
    for (i = [0 : num_holes_Y - 1]) {
        for (j = [0 : num_holes_X - 1]) {
            // Calculate hole center in X and Y
            hole_x = (j - (num_holes_X - 1)/2) * hole_spacing_X;
            hole_y = (i - (num_holes_Y - 1)/2) * hole_spacing_Y;

            // Cut hole through the plate (extend slightly beyond to ensure clean cut)
            translate([hole_x, hole_y, -0.01])
                cylinder(h = plate_thickness_Z + 0.02, d = hole_diameter, center = true);
        }
    }

    // 3. Wall along Y = -plate_width_Y/2 (bottom long edge)
    // Wall is 4 mm thick in Y, 130 mm long in X, from z = 0 to 70
    // Positioned at Y = -plate_width_Y/2 - wall_thickness_Y/2 (so wall is flush with edge)
    wall_offset_Y_bottom = -plate_width_Y/2 - wall_thickness_Y/2;
    translate([0, wall_offset_Y_bottom, 0])
        cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);

    // 4. Wall along Y = +plate_width_Y/2 (top long edge)
    wall_offset_Y_top = +plate_width_Y/2 - wall_thickness_Y/2;
    translate([0, wall_offset_Y_top, 0])
        cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);
}

// Render the entire rack
rack();