// --- Dimensions in mm ---

plate_length_X = 130;      // Total length along X axis of the base plate
plate_width_Y = 90;        // Total width along Y axis of the base plate
plate_thickness = 4;       // Thickness of the base plate (Z dimension)
tube_hole_diameter = 30.5; // Diameter of the holes for Falcon tubes
tube_hole_radius = tube_hole_diameter / 2;

wall_height = 70;          // Height the side walls rise to from the base plate
wall_thickness_Y = 4;     // Thickness of the long side walls (in Y direction)

spacing_X = 40;            // Center-to-center spacing between holes along X
spacing_Y = 40;            // Center-to-center spacing between holes along Y

// --- Global Settings ---
$fn = 64; // High resolution for curves

// --- Calculations ---

// Plate is centered at (0, 0). X runs from -65 to 65. Y runs from -45 to 45.

// X positions: 3 tubes along X (indices 1, 2, 3)
// Centers should be placed symmetrically around X=0.
x_positions = [
    -spacing_X, // Center of the first tube group relative to center line
     0,          // Center of the second tube group
     spacing_X  // Center of the third tube group
];

// Y positions: 2 rows along Y (indices 1, 2)
// Centers should be placed symmetrically around Y=0.
y_positions = [
    -spacing_Y / 2, // Row 1 center
     spacing_Y / 2  // Row 2 center
];


// --- Module Definitions ---

// Creates the main base plate structure
module base_plate() {
    cube([plate_length_X, plate_width_Y, plate_thickness]);
}

// Creates one through-hole centered at (x, y)
module tube_hole(x_center, y_center) {
    // Extend slightly past the top and bottom of the base plate for clean cutting
    translate([x_center, y_center, -0.1]) 
    cylinder(h = plate_thickness + 0.2, r = tube_hole_radius);
}

// Creates the two long side walls rising from the base plate
module side_wall() {
    // The wall is 130mm (X) long and 4mm thick (Y). It rises to Z=70.
    // Long edges are at Y = +/- (plate_width_Y / 2).
    // Wall thickness is in Y direction, so it occupies a slice of width 4mm centered on the edge line.

    // Wall 1 (Positive Y side) - Centered at Y = plate_width_Y/2
    translate([0, plate_width_Y/2 - wall_thickness_Y/2, 0]) {
        cube([plate_length_X, wall_thickness_Y, wall_height]);
    }

    // Wall 2 (Negative Y side) - Centered at Y = -plate_width_Y/2
    translate([0, -plate_width_Y/2 + wall_thickness_Y/2, 0]) {
        cube([plate_length_X, wall_thickness_Y, wall_height]);
    }
}


// --- Assembly ---

difference() {
    // 1. Base Plate (The main body) and Side Walls combined
    union() {
        base_plate();

        // 2. Side Walls (These extend up from the plate)
        side_wall();
    }

    // 3. Cutouts: Holes for tubes and material removal through walls

    // A. Tube Holes (6 holes in the base plate)
    for (i = [0 : len(x_positions)-1]) {
        for (j = [0 : len(y_positions)-1]) {
            translate([x_positions[i], y_positions[j], 0]) {
                tube_hole(0, 0); // The tube_hole module is designed to be translated externally
            }
        }
    }

    // B. Cutting through the side walls (to ensure tubes pass through)
    for (i = [0 : len(x_positions)-1]) {
        for (j = [0 : len(y_positions)-1]) {

            // Hole centered at X=x_positions[i], Y=y_positions[j]
            // Cut deep enough to pass through the entire structure (plate + walls)
            translate([x_positions[i], y_positions[j], -0.1]) {
                cylinder(h = wall_height + plate_thickness + 2, r = tube_hole_radius);
            }
        }
    }

}