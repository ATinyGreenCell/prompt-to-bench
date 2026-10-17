// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Upside down (Top plate on bed, walls rising up)

$fn = 128; // High resolution for clean holes and edges

// --- Dimensions ---
// Outer size of the box
W_OUT = 90;
H_OUT = 90;
D_OUT = 90;

// Wall thickness
W_THICK = 2.5;

// Top plate thickness
TOP_THICK = 2;

// Total height of the part (Top of walls)
TOTAL_HEIGHT = 40;

// Wall height (from top plate surface to open top)
WALL_HEIGHT = TOTAL_HEIGHT - TOP_THICK;

// Fan mounting hole pattern
// 4 holes on a square pattern, centred on the plate
// Distance between hole centers
PATTERN_SIZE = 71.5;
// Hole diameter for M4 screws
HOLE_DIA = 4.5;

// Cable notch dimensions
NOTCH_WIDTH = 12;
NOTCH_DEPTH = 8; // Reaches 8mm down from the open edge (z = 32 to z = 40)

// --- Calculated Positions ---
// Center of the top plate
X_CENTER = W_OUT / 2;
Y_CENTER = H_OUT / 2;

// Screw hole positions (relative to center)
// Pattern is 71.5mm square. Half is 35.75mm.
HOLE_OFFSET = PATTERN_SIZE / 2;

// Notch position (in the front wall, Y = Y_CENTER - W_THICK/2)
NOTCH_Y_POS = Y_CENTER - (W_THICK / 2);
NOTCH_X_POS = X_CENTER; // Centred along the wall

// --- Main Construction ---

module main_housing() {
    difference() {
        // 1. The main solid block
        // X: 0 to W_OUT
        // Y: 0 to H_OUT
        // Z: 0 to TOTAL_HEIGHT
        cube([W_OUT, H_OUT, TOTAL_HEIGHT], center = false);
        
        // 2. Cut the internal void (the open box part)
        // The void starts at Z = TOP_THICK and goes up to Z = TOTAL_HEIGHT
        // The void is inset by wall thickness on all sides
        void_x = W_OUT - (2 * W_THICK);
        void_y = H_OUT - (2 * W_THICK);
        void_z = WALL_HEIGHT;
        
        translate([W_THICK, W_THICK,