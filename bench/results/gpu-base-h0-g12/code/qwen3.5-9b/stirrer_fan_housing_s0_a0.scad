// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Upside down (Top plate on bed, walls rising up)

// --- Dimensions ---
// Outer size of the housing
W = 90;
H = 90;

// Thickness of the top plate (resting on bed)
T_TOP = 2;

// Height of the walls
WALL_HEIGHT = 40;

// Wall thickness
WALL_THICK = 2.5;

// Hole specifications
HOLE_DIAM = 4.5;
HOLE_PATTERN_SIZE = 71.5; // Distance between hole centers
HOLE_COUNT = 4;

// Cable notch specifications
NOTCH_WIDTH = 12;
NOTCH_DEPTH_FROM_TOP = 8; // Distance from the open edge (z=40) down to z=32

// --- Derived Dimensions ---
// Inner dimensions (for reference in logic, though we build by subtraction)
I_W = W - 2*WALL_THICK;
I_H = H - 2*WALL_THICK;

// --- Main Body Construction ---
// We build the solid block first, then subtract holes and notches.
// The base is the top plate, walls rise from it.

difference() {
    // 1. The Main Block
    // Dimensions: W x H x (T_TOP + WALL_HEIGHT)
    // Centered at origin.
    // Since it rests on Z=0, the block goes from Z=0 to Z=T_TOP+WALL_HEIGHT.
    block_size = [W, H, T_TOP + WALL_HEIGHT];
    
    union() {
        // We construct the walls and top plate as a single solid block for simplicity,
        // then cut the features.
        cube(block_size);
    }
    
    // 2. Cut the 4 Screw Holes through the top plate
    // Pattern: 71.5mm square centered on the plate.
    // Plate center is (0,0).
    // Holes are at +/- 35.75mm in X and Y.
    for (i = [0, 1]) {
        for (j = [0, 1]) {
            translate([
                (HOLE_PATTERN_SIZE / 2) * (i - 0.5),
                (HOLE_PATTERN_SIZE / 2) * (j - 0.5),
                0 // Start cutting from bottom of top plate
            ]) {
                // Cut a cylinder through the top plate only (depth = T_TOP)
                // Extend slightly past the face to ensure clean cut
                cylinder(
                    h = T_TOP + 0.1, 
                    d = HOLE_DIAM,
                    $fn = 64
                );
            }
        }
    }
    
    // 3. Cut the Cable Notch
    // Location: In one wall. Let's choose the wall at X = +W/2 (Right wall).
    // The notch is 12mm wide, centered along the wall.
    // The wall runs from Y = -H/2 to Y = +H/2.
    // Center of wall in Y is 0.
    // Notch reaches 8mm down from the open edge (Z=40).
    // So it cuts from Z = 40 - 8 = 32 to Z = 40.
    
    translate([
        W/2 - NOTCH_WIDTH/2, // X position: Center of the right wall
        0,                   // Y position: Centered along the wall
        32                   // Z position: Start of the cut (8mm up from bed)
    ]) {
        // Cut a rectangular prism for the notch
        // Width = NOTCH_WIDTH
        // Height = NOTCH_DEPTH_FROM_TOP (8mm)
        // Depth (Z) = 8mm
        cube([NOTCH_WIDTH, H, NOTCH_DEPTH_FROM_TOP]);
    }
}