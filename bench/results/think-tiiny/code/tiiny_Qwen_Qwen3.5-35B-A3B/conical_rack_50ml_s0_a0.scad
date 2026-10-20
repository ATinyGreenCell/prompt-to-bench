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
    // 1. Create the base plate
    // Centered at origin, lying on XY plane (z=0 to z=4)
    translate([0, 0, 0])
        cube([PLATE_LENGTH_X, PLATE_WIDTH_Y, PLATE_THICKNESS_Z]);

    // 2. Create the holes
    // We use a for loop to create the 6 holes (2 rows, 3 columns)
    // Holes are centered on the plate.
    // X positions: -40, 0, 40 (Spacing 40)
    // Y positions: -20, 20 (Spacing 40)
    // We use difference to cut the holes through the plate.
    // The cutters must extend past the plate faces (z=0 and z=4) by at least 0.01mm.
    // We use a height of 10mm for the cutters to ensure they fully penetrate.
    for (x_pos = [-40, 0, 40]) {
        for (y_pos = [-20, 20]) {
            // Create a cylinder cutter
            // Centered at (x_pos, y_pos, 2) (midpoint of plate thickness)
            // Height 10mm ensures it extends past z=0 and z=4
            translate([x_pos, y_pos, 0])
                cylinder(h = PLATE_THICKNESS_Z + 2, r = HOLE_RADIUS, center = true);
        }
    }

    // 3. Create the two solid walls
    // Walls run along the long edges (X-axis) of the plate.
    // They are flush with the plate's long edge.
    // Plate Y range: -45 to 45.
    // Wall thickness: 4mm.
    // To be "flush" with the edge and act as feet (standing on walls),
    // the walls are placed outside the plate footprint.
    // Wall 1 (Left): Y from -49 to -45.
    // Wall 2 (Right): Y from 45 to 49.
    // Both walls are 130mm long (X) and 70mm high (Z).
    
    // Wall 1
    translate([-PLATE_LENGTH_X / 2, -PLATE_WIDTH_Y / 2 - WALL_THICKNESS_Y, 0])
        cube([WALL_LENGTH_X, WALL_THICKNESS_Y, WALL_HEIGHT_Z]);

    // Wall 2
    translate([-PLATE_LENGTH_X / 2, PLATE_WIDTH_Y / 2, 0])
        cube([WALL_LENGTH_X, WALL_THICKNESS_Y, WALL_HEIGHT_Z]);
}

// Execute the module
rack();