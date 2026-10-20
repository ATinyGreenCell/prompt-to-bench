// Dimensions for DIY Magnetic Stirrer Housing
// Based on 80mm PC fan, printed upside down

// Overall outer dimensions
OUT_X = 90;       // X width in mm
OUT_Y = 90;       // Y depth in mm

// Wall thickness
WALL_THICK = 2.5; // Wall thickness in mm

// Top plate thickness (on the bed, z=0 to 2)
TOP_THICK = 2;    // Top plate thickness in mm

// Total height of the box walls
BOX_HEIGHT = 40;  // Height of walls from top plate to open edge

// Fan mounting holes
FAN_HOLE_DIA = 4.5; // Diameter of M4 screw holes
FAN_PITCH = 71.5;   // Distance between hole centres (square pattern)

// Cable notch dimensions
NOTCH_WIDTH = 12;   // Width of the notch in X direction
NOTCH_DEPTH = 8;    // Depth of the notch from the open edge (z=32 to z=40)
// Assuming notch is on the wall at Y = OUT_Y/2 (front wall)

// Helper variables
INNER_X = OUT_X - 2 * WALL_THICK;
INNER_Y = OUT_Y - 2 * WALL_THICK;

// Hole positions for the 4 mounting holes
// Centred on the plate. Plate is OUT_X x OUT_Y.
// Pattern is FAN_PITCH x FAN_PITCH.
// Offsets from center:
HALF_PITCH = FAN_PITCH / 2;

// Notch parameters
NOTCH_Z_START = BOX_HEIGHT - NOTCH_DEPTH; // z = 32
NOTCH_Z_END = BOX_HEIGHT;                 // z = 40

// Build the part
difference() {
    // Main box body
    union() {
        // Bottom plate (z=0 to z=TOP_THICK)
        cube([OUT_X, OUT_Y, TOP_THICK], center=false);
        
        // Walls (z=TOP_THICK to z=BOX_HEIGHT)
        // Front wall (Y = OUT_Y/2)
        translate([0, OUT_Y/2 - WALL_THICK/2, TOP_THICK])
            cube([OUT_X, WALL_THICK, BOX_HEIGHT - TOP_THICK], center=false);
            
        // Back wall (Y = -OUT_Y/2)
        translate([0, -OUT_Y/2 + WALL_THICK/2, TOP_THICK])
            cube([OUT_X, WALL_THICK, BOX_HEIGHT - TOP_THICK], center=false);
            
        // Left wall (X = -OUT_X/2)
        translate([-OUT_X/2 + WALL_THICK/2, 0, TOP_THICK])
            cube([WALL_THICK, OUT_Y, BOX_HEIGHT - TOP_THICK], center=false);
            
        // Right wall (X = OUT_X/2)
        translate([OUT_X/2 - WALL_THICK/2, 0, TOP_THICK])
            cube([WALL_THICK, OUT_Y, BOX_HEIGHT - TOP_THICK], center=false);
    }

    // 2. Subtract the inner void to make it hollow
    // Inner void starts at z=TOP_THICK, goes up to BOX_HEIGHT
    // Inner dimensions are INNER_X x INNER_Y
    translate([0, 0, TOP_THICK])
        cube([INNER_X, INNER_Y, BOX_HEIGHT - TOP_THICK + 0.01], center=false);

    // 3. Drill the 4 mounting holes through the top plate
    // Holes go from z=0 through the top plate to z=TOP_THICK
    // They should extend slightly into the inner void or just through the plate.
    // Rule: extend 0.01-1mm past faces. 
    // Let's extend them slightly into the void (z > TOP_THICK) to ensure clean cut.
    hole_extend = 0.5;
    for (x = [-HALF_PITCH, HALF_PITCH]) {
        for (y = [-HALF_PITCH, HALF_PITCH]) {
            translate([x, y, -0.01]) // Start slightly below z=0
            {
                $fn = 64;
                cylinder(d = FAN_HOLE_DIA, h = TOP_THICK + hole_extend, center=false);
            }
        }
    }

    // 4. Cut the cable notch in one wall
    // Notch is on the wall at Y = OUT_Y/2 (Front wall)
    // Width 12mm in X, centred (X from -6 to 6)
    // Depth 8mm from open edge (z=32 to z=40)
    // It cuts through the wall thickness.
    
    // The wall is at Y = OUT_Y/2. The material exists from Y = OUT_Y/2 - WALL_THICK to Y = OUT_Y/2.
    // We need to remove material in the notch area.
    
    // Notch X range: -NOTCH_WIDTH/2 to NOTCH_WIDTH/2
    // Notch Y range: OUT_Y/2 - WALL_THICK to OUT_Y/2 (full wall thickness)
    // Notch Z range: NOTCH_Z_START to NOTCH_Z_END
    
    // To ensure clean cutting, we extend slightly past the Z bounds and Y bounds
    notch_x_ext = 1;
    notch_y_ext = 1;
    notch_z_ext = 0.5;
    
    translate([0, OUT_Y/2, 0])
        cube([NOTCH_WIDTH + notch_x_ext, WALL_THICK + notch_y_ext, NOTCH_DEPTH + notch_z_ext], center=false);
}