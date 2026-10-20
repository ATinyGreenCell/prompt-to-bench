// Dimensions for the rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed (z = 0 to 4), walls rise from edges
// After flipping, rack stands on walls, tubes through holes

// Plate dimensions
plate_length_X = 130;   // mm
plate_width_Y = 90;       // mm
plate_thickness_Z = 4;   // mm

// Hole parameters
hole_diameter = 30.5;     // mm
hole_spacing_X = 40;     // mm (center-to-center along X)
hole_spacing_Y = 40;     // mm (center-to-center along Y)
num_holes_X = 3;         // 3 holes along X (2 rows of 3)
num_holes_Y = 2;         // 2 rows along Y

// Wall parameters
wall_length_X = plate_length_X;     // 130 mm
wall_thickness_Y = 4;                 // mm (along Y)
wall_height_Z = 70;             // mm (from plate to top)

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
// Ensure the entire part is at or above z = 0 to avoid bed contact below z = 0
// The current model has the plate from z = 0 to 4, so the bottom of the plate is at z = 0
// But the walls extend from z = 0 to 70, so the lowest point is at z = 0
// However, the measurement report shows z = -2.02, which suggests the origin is not aligned

// The issue: the cube for the plate is centered at (0,0,0), so it extends from z = -2 to z = +2
// But the specification says: "a flat plate 130 mm (X) by 90 mm (Y) and 4 mm thick lies on the bed (z = 0 to 4)"

// Fix: shift the entire model so that the plate's bottom is at z = 0
// That means the plate should go from z = 0 to z = 4, not centered at z = 0

// Recompute: move the entire model up by 2 mm in Z
// Apply this translation to all components

// Revised module with correct Z alignment
module rack() {
    // 1. Plate: flat rectangular base, from z = 0 to 4 (not centered at z = 0)
    // So center of plate in Z is at z = 2
    translate([0, 0, 2])
        cube([plate_length_X, plate_width_Y, plate_thickness_Z], center = true);

    // 2. Holes: same X,Y positions, but now at Z = 2 (centered in Z)
    for (i = [0 : num_holes_Y - 1]) {
        for (j = [0 : num_holes_X - 1]) {
            hole_x = (j - (num_holes_X - 1)/2) * hole_spacing_X;
            hole_y = (i - (num_holes_Y - 1)/2) * hole_spacing_Y;

            // Cut hole through the plate (extend slightly beyond to ensure clean cut)
            translate([hole_x, hole_y, 2 - 0.01])
                cylinder(h = plate_thickness_Z + 0.02, d = hole_diameter, center = true);
        }
    }

    // 3. Wall along Y = -plate_width_Y/2 (bottom long edge)
    wall_offset_Y_bottom = -plate_width_Y/2 - wall_thickness_Y/2;
    translate([0, wall_offset_Y_bottom, 2])  // shift wall base to z = 0
        cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);

    // 4. Wall along Y = +plate_width_Y/2 (top long edge)
    wall_offset_Y_top = +plate_width_Y/2 - wall_thickness_Y/2;
    translate([0, wall_offset_Y_top, 2])
        cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);
}

// Render the entire rack with correct Z alignment
rack();