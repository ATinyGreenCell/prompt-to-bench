// Dimensions for the Falcon tube rack
$fn = 64; // Ensure smooth curves

// Plate dimensions
plate_length_X = 130;   // mm
plate_width_Y = 90;     // mm
plate_thickness_Z = 4;   // mm

// Hole dimensions
hole_diameter = 30.5;     // mm
hole_spacing_X = 40; // mm between centres (along X)
hole_spacing_Y = 40;   // mm between centres (along Y)

// Wall dimensions
wall_length_X = plate_length_X;   // 130 mm
wall_thickness_Y = 4;             // mm (along Y)
wall_height_Z = 70;             // mm (up from plate)

// Calculate hole positions: 2 rows (Y), 3 columns (X), centred on plate
// Centre of plate: (plate_length_X/2, plate_width_Y/2)
// First hole at (plate_length_X/2 - hole_spacing_X, plate_width_Y/2 - hole_spacing_Y/2)
// But we'll use for loops to place them

// Start with the base plate
module base_plate() {
    translate([0, 0, 0])
    cube([plate_length_X, plate_width_Y, plate_thickness_Z], center = true);
}

// Create the six through-holes
module holes() {
    for (i = [0:2]) {
        for (j = [0:1]) {
            // Calculate X and Y positions: 3 columns (i=0,1,2), 2 rows (j=0,1)
            // Centre of hole grid: X = plate_length_X / 2, Y = plate_width_Y / 2
            // First hole at X = plate_length_X/2 - hole_spacing_X, Y = plate_width_Y/2 - hole_spacing_Y/2
            // Then step by hole_spacing_X in X, hole_spacing_Y in Y
            x_pos = plate_length_X / 2 - hole_spacing_X + i * hole_spacing_X;
            y_pos = plate_width_Y / 2 - hole_spacing_Y/2 + j * hole_spacing_Y;

            // Cut hole through the plate: extend slightly beyond to ensure clean cut
            translate([x_pos, y_pos, -0.1])
            cylinder(h = plate_thickness_Z + 0.2, d = hole_diameter, center = true);
        }
    }
}

// Create the two walls along the long edges (along X)
// Wall 1: at Y = -plate_width_Y/2 (bottom edge)
// Wall 2: at Y = +plate_width_Y/2 (top edge)
module walls() {
    // Wall 1: at bottom edge (Y = -plate_width_Y/2)
    translate([0, -plate_width_Y/2, 0])
    cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);

    // Wall 2: at top edge (Y = +plate_width_Y/2)
    translate([0, +plate_width_Y/2, 0])
    cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);
}

// Assemble the rack: base plate + holes + walls
difference() {
    base_plate();
    holes();
}

// Add walls on top of the plate (they are solid and separate from the plate)
// Use union to attach walls to the plate
union() {
    base_plate();
    walls();
}