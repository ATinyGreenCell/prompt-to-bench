$fn = 64;

// --- Dimensions ---
// Base plate dimensions
PLATE_LENGTH_X = 130;
PLATE_WIDTH_Y = 90;
PLATE_THICKNESS_Z = 4;

// Hole dimensions
HOLE_DIAMETER = 30.5;
HOLE_RADIUS = HOLE_DIAMETER / 2;

// Hole grid spacing
HOLE_SPACING_X = 40;
HOLE_SPACING_Y = 40;

// Wall dimensions
WALL_LENGTH_X = 130;
WALL_THICKNESS_Y = 4;
WALL_HEIGHT_Z = 70;

// --- Geometry Construction ---

module rack() {
    // 1. Create the base plate with holes
    // Centered at origin, lying on XY plane (z=0 to z=4)
    plate_with_holes = difference() {
        // The plate
        translate([0, 0, 0])
            cube([PLATE_LENGTH_X, PLATE_WIDTH_Y, PLATE_THICKNESS_Z]);
        
        // Cutters for the 6 holes
        for (x_pos = [-40, 0, 40]) {
            for (y_pos = [-20, 20]) {
                // Cylinder cutter - must extend past z=0 and z=4
                // Use center=false to ensure it starts at z=0
                // Height should be at least 4mm + 0.01mm to ensure full cut
                translate([x_pos, y_pos, 0])
                    cylinder(h = PLATE_THICKNESS_Z + 0.02, r = HOLE_RADIUS, center = false);
            }
        }
    }

    // 2. Create the two solid walls
    // Walls run along the long edges (X-axis) of the plate
    // They are flush with the plate's long edge
    // Plate Y range: -45 to 45
    // Wall thickness: 4mm
    // Walls should be outside the plate to act as feet
    
    // Wall 1 (Left): Y from -49 to -45 (4mm thick, flush with left edge)
    wall1 = translate([-PLATE_LENGTH_X / 2, -PLATE_WIDTH_Y / 2 - WALL_THICKNESS_Y, 0])
        cube([WALL_LENGTH_X, WALL_THICKNESS_Y, WALL_HEIGHT_Z]);

    // Wall 2 (Right): Y from 45 to 49 (4mm thick, flush with right edge)
    wall2 = translate([-PLATE_LENGTH_X / 2, PLATE_WIDTH_Y / 2, 0])
        cube([WALL_LENGTH_X, WALL_THICKNESS_Y, WALL_HEIGHT_Z]);

    // Combine all parts
    union() {
        plate_with_holes;
        wall1;
        wall2;
    }
}

// Execute the module
rack();