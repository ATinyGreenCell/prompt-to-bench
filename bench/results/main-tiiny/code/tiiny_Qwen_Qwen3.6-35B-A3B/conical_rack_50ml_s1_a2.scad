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

// Hole centers
// X positions: -pitch_x, 0, pitch_x (centered around 0)
// Y positions: -pitch_y/2, pitch_y/2 (centered around 0)
hole_x_positions = [-pitch_x, 0, pitch_x];
hole_y_positions = [-pitch_y/2, pitch_y/2];

// Build
module rack() {
    // 1. Main Plate
    // Plate lies on z=0 to z=4.
    difference() {
        // Base plate
        translate([0, 0, plate_z/2]) {
            cube([plate_x, plate_y, plate_z], center = true);
        }
        
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
    // Plate edge is at Y = -45. Wall is 4mm thick, flush on outside.
    // Wall spans Y = -49 to -45. Center Y = -47.
    translate([-plate_x/2, -47, 0]) {
        cube([plate_x, wall_thickness, wall_height], center = false);
    }
    
    // Wall 2 (Positive Y)
    // Plate edge is at Y = 45. Wall is 4mm thick, flush on outside.
    // Wall spans Y = 45 to 49. Center Y = 47.
    translate([-plate_x/2, 47, 0]) {
        cube([plate_x, wall_thickness, wall_height], center = false);
    }
}

rack();