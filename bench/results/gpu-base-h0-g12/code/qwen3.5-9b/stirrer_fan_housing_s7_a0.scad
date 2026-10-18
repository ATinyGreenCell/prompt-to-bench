// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down. Top plate on bed (Z=0), walls rise to Z=40.

// --- Dimensions ---
// Outer size of the box
W = 90;
H = 90;
D = 90; // Depth (Z height of walls)

// Wall thickness
T_WALL = 2.5;

// Top plate thickness
T_TOP = 2;

// Total height of the part (Top plate + Walls)
Z_MAX = T_TOP + D;

// Fan mounting hole pattern
// 71.5 mm square pattern centred on the plate
PATTERN_SIZE = 71.5;
// Hole diameter for M4 screws
D_HOLE = 4.5;

// Cable notch dimensions
NOTCH_W = 12;
NOTCH_Y = (H - NOTCH_W) / 2; // Center Y position
NOTCH_DEPTH = 8; // Depth from open edge (Z = 32 to 40)

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate holes

// --- Main Body Construction ---
// We build the solid from the bottom up.
// 1. Create the base block (Top plate + Walls)
// 2. Cut the screw holes through the top plate.
// 3. Cut the cable notch in one wall.

difference() {
    // 1. The Main Block
    // Outer dimensions: W x H x Z_MAX
    // We subtract the wall thickness from the outer dimensions to get the inner void
    // Inner X = W - 2*T_WALL
    // Inner Y = H - 2*T_WALL
    // Inner Z = Z_MAX - T_WALL (since the top is open)
    
    cube([W, H, Z_MAX], center = false);
    
    // 2. Screw Holes
    // Pattern: 71.5mm square centered on the plate.
    // The plate is at Z=0 to Z=2.
    // We need to cut through the top plate only.
    // To ensure clean cutting, we extend the cutter slightly past the plate thickness.
    
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            // Calculate position based on pattern size
            // Center is 0,0. Half pattern size is PATTERN_SIZE/2
            // Offset by i and j to get the four corners of the square pattern
            x_pos = (PATTERN_SIZE / 2) * i;
            y_pos = (PATTERN_SIZE / 2) * j;
            
            // Cylinder cutter
            // Extend 0.1mm past the top plate (Z=2) to ensure full cut
            translate([x_pos, y_pos, -0.1]) 
                cylinder(h = T_TOP + 0.1, d = D_HOLE, $fn = 64);
        }
    }
    
    // 3. Cable Notch
    // Location: One wall. Let's choose the front wall (Y = H/2 - T_WALL).
    // Dimensions: 12mm wide, centered along the wall.
    // Depth: 8mm down from the open edge.
    // Open edge is at Z = Z_MAX. So notch goes from Z = Z_MAX - 8 to Z = Z_MAX.
    
    // Wall position (Front wall)
    wall_y = H/2 - T_WALL;
    
    // Notch geometry
    // Width: NOTCH_W
    // Height (Z): NOTCH_DEPTH
    // Y position: Centered on the wall face.
    // The wall face is at Y = wall_y. The notch goes inward (negative Y direction).
    // Center of notch in Y relative to the wall face:
    notch_y_center = NOTCH_W / 2;
    
    // Create the notch cutter
    // It needs to be tall enough to cut through the wall thickness
    translate([0, wall_y - notch_y_center, Z_MAX - NOTCH_DEPTH])
        cube([NOTCH_W, T_WALL, NOTCH_DEPTH]);
}