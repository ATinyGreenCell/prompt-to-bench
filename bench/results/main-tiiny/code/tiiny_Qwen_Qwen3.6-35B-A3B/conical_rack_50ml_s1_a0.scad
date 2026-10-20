// Dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;

wall_height = 70;
wall_thickness = 4;

tube_hole_diameter = 30.5;

// Grid parameters
num_rows = 2; // Along Y
num_cols = 3; // Along X
pitch_x = 40;
pitch_y = 40;

// Calculated positions
// Center of the plate is at (0,0)
// X range: -plate_x/2 to plate_x/2
// Y range: -plate_y/2 to plate_y/2

// Hole centers
// X positions: -pitch_x, 0, pitch_x (centered around 0)
// Y positions: -pitch_y/2, pitch_y/2 (centered around 0)
// Wait, 3 columns with 40mm pitch: -40, 0, 40.
// 2 rows with 40mm pitch: -20, 20.

hole_x_positions = [-pitch_x, 0, pitch_x];
hole_y_positions = [-pitch_y/2, pitch_y/2];

// Wall positions
// Long edges are along X. Walls are at Y = -plate_y/2 and Y = plate_y/2.
// Wall length is 130mm (X).
// Wall thickness is 4mm (Y).
// So walls extend from Y = -plate_y/2 - 4 to -plate_y/2 and Y = plate_y/2 to plate_y/2 + 4?
// "flush with the plate's long edge" usually means the outer face is flush or the inner face is flush.
// Given "Two solid walls run along the two long edges... flush with the plate's long edge",
// and the plate is 90mm wide. If the walls are on the outside, the total width is 90 + 4 + 4 = 98.
// If they are on the inside, the total width is 90.
// "flush with the plate's long edge" implies the outer surface of the wall aligns with the outer surface of the plate.
// So the walls extend outwards from the plate.

// Let's define the main plate body
// Plate: 130x90x4

// Let's define the walls
// Wall 1 (Y negative side): X: -65 to 65, Y: -45-4 to -45, Z: 0 to 70
// Wall 2 (Y positive side): X: -65 to 65, Y: 45 to 45+4, Z: 0 to 70

// Holes
// Through holes in the plate.
// Diameter 30.5.
// Centers at (x, y) from lists above.

// Build
module rack() {
    // 1. Main Plate
    difference() {
        // Base plate
        cube([plate_x, plate_y, plate_z], center = true);
        
        // Cut holes
        for (x = hole_x_positions) {
            for (y = hole_y_positions) {
                // Extend hole slightly past z=0 and z=plate_z to ensure clean cut
                // Plate is z=0 to z=4.
                // Hole extends from -0.1 to 4.1
                translate([x, y, 0]) {
                    cylinder(d = tube_hole_diameter, h = plate_z + 0.2, center = true, $fn = 64);
                }
            }
        }
    }

    // 2. Walls
    // Wall 1 (Negative Y)
    translate([-plate_x/2, -plate_y/2 - wall_thickness/2, 0]) {
        cube([plate_x, wall_thickness, wall_height], center = false);
    }
    
    // Wall 2 (Positive Y)
    translate([-plate_x/2, plate_y/2, 0]) {
        cube([plate_x, wall_thickness, wall_height], center = false);
    }
}

rack();