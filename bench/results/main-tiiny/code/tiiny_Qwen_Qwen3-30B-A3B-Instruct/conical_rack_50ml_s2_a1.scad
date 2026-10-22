// Dimensions for the Falcon tube rack
$fn = 64; // Ensure smooth curves

// Plate dimensions
plate_length_X = 130;   // mm
plate_width_Y = 90;         // mm
plate_thickness_Z = 4;        // mm

// Hole dimensions
hole_diameter = 30.5;       // mm
hole_spacing_X = 40;          // mm between centres (along X)
hole_spacing_Y = 40;          // mm between centres (along Y)

// Wall dimensions
wall_length_X = plate_length_X;   // 130 mm
wall_thickness_Y = 4;             // mm (along Y)
wall_height_Z = 70;                 // mm (up from plate)

// The part must rest on the bed at z = 0, so the entire base must be at z >= 0
// The original design had the plate centred at z = 0, so it extended from z = -2 to z = +2
// We need to shift the entire model so that the bottom of the plate is at z = 0

// Adjust: move the entire model up by 2 mm so that the plate's bottom is at z = 0
// The plate now spans from z = 0 to z = 4 (its thickness), and the walls start at z = 0

// Start with the base plate, now shifted so bottom is at z = 0
module base_plate() {
    translate([0, 0, 2]) // Shift up by 2 mm so bottom is at z = 0
    cube([plate_length_X, plate_width_Y, plate_thickness_Z], center = true);
}

// Create the six through-holes, also shifted up by 2 mm
module holes() {
    for (i = [0:2]) {
        for (j = [0:1]) {
            // Calculate X and Y positions: 3 columns (i=0,1,2), 2 rows (j=0,1)
            x_pos = plate_length_X / 2 - hole_spacing_X + i * hole_spacing_X;
            y_pos = plate_width_Y / 2 - hole_spacing_Y/2 + j * hole_spacing_Y;

            // Cut hole through the plate: extend slightly beyond to ensure clean cut
            // The hole should go through the full thickness of the plate (4 mm), from z = 0 to z = 4
            // So we place the cylinder from z = -0.1 to z = 4.1 to ensure full penetration
            translate([x_pos, y_pos, 1.9]) // Center of cylinder at z = 2 (middle of plate), extend 2.1 mm above and below
            cylinder(h = 4.2, d = hole_diameter, center = true);
        }
    }
}

// Create the two walls along the long edges (along X)
// Each wall is 130 mm long (X), 4 mm thick (Y), and rises from z = 0 to z = 70
// They are flush with the plate's long edge (Y = ±plate_width_Y/2), so we place them at Y = ±45 mm
// The wall extends from z = 0 to z = 70, so we use cube with bottom at z = 0

module walls() {
    // Wall 1: at Y = -plate_width_Y/2 = -45 mm
    translate([0, -45, 0])
    cube([wall_length_X, wall_thickness_Y, wall_height_Z], center = false);

    // Wall 2: at Y = +plate_width_Y/2 = +45 mm
    translate([0, +45, 0])
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