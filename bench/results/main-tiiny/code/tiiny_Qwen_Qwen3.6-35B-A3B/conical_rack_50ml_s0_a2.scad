// Dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;
hole_diameter = 30.5;
hole_radius = hole_diameter / 2;
num_rows = 2; // Along Y
num_cols = 3; // Along X
pitch_x = 40;
pitch_y = 40;
wall_top_z = 70;
wall_thickness = 4;

// Calculate hole positions
// Centred on the plate in X and Y
// X range: 0 to 130. Centres at 130/4 = 32.5, 72.5, 112.5
// Y range: 0 to 90. Centres at 25 and 65 (40mm pitch, centred on 45)

x_positions = [32.5, 72.5, 112.5];
y_positions = [25, 65];

// Wall positions
// Long edges are along X. Walls are at Y=0 and Y=plate_y.
// Wall length is 130 (X). Thickness is 4 (Y).
// Wall 1: X: 0-130, Y: 0-4, Z: 4-70
// Wall 2: X: 0-130, Y: 86-90, Z: 4-70

module rack() {
    // 1. Base Plate
    difference() {
        // Main plate
        cube([plate_x, plate_y, plate_z], center=false);
        
        // Holes
        // Extend hole cutter from z=-1 to z=5 to ensure clean cut through plate
        // Use high $fn to ensure 30.5mm diameter is accurate
        for (x = x_positions) {
            for (y = y_positions) {
                translate([x, y, 0]) {
                    $fn = 128;
                    cylinder(h=5, d=hole_diameter, center=false);
                }
            }
        }
    }
    
    // 2. Walls
    // Wall 1 (Y=0 side)
    // Height is from plate_z to wall_top_z
    wall_height = wall_top_z - plate_z;
    translate([0, 0, plate_z]) {
        cube([plate_x, wall_thickness, wall_height], center=false);
    }
    
    // Wall 2 (Y=90 side)
    translate([0, plate_y - wall_thickness, plate_z]) {
        cube([plate_x, wall_thickness, wall_height], center=false);
    }
}

rack();