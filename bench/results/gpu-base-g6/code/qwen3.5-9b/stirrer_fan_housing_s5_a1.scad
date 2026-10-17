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
        
        translate([W_THICK, W_THICK, TOP_THICK]) {
            cube([void_x, void_y, void_z]);
        }
        
        // 3. Cut Screw Holes
        // Holes are in the top plate (Z: 0 to TOP_THICK)
        // We extend slightly past the bottom (Z < 0) to ensure clean cut
        hole_z_start = -0.1;
        hole_z_end = TOP_THICK + 0.1;
        
        // Define hole positions explicitly to avoid scope issues
        hole_positions = [
            [X_CENTER - HOLE_OFFSET, Y_CENTER + HOLE_OFFSET],
            [X_CENTER + HOLE_OFFSET, Y_CENTER + HOLE_OFFSET],
            [X_CENTER + HOLE_OFFSET, Y_CENTER - HOLE_OFFSET],
            [X_CENTER - HOLE_OFFSET, Y_CENTER - HOLE_OFFSET]
        ];
        
        for (p = hole_positions) {
            tx = p[0];
            ty = p[1];
            
            translate([tx, ty, hole_z_start]) {
                cylinder(h = hole_z_end - hole_z_start, 
                          r = HOLE_DIA / 2, 
                          center = false);
            }
        }
        
        // 4. Cut Cable Notch
        // Located in the front wall (Y = NOTCH_Y_POS)
        // Extends from Z = 32 to Z = 40 (8mm deep from top)
        // Width is NOTCH_WIDTH, centered at X_CENTER
        // We extend slightly past the wall thickness in X to ensure clean cut
        
        notch_z_start = TOTAL_HEIGHT - NOTCH_DEPTH - 0.1; // 40 - 8 - 0.1 = 31.9
        notch_z_end = TOTAL_HEIGHT + 0.1;                  // 40.1
        
        notch_x_start = NOTCH_X_POS - (NOTCH_WIDTH / 2) - 0.1;
        notch_x_end = NOTCH_X_POS + (NOTCH_WIDTH / 2) + 0.1;
        
        translate([notch_x_start, NOTCH_Y_POS, notch_z_start]) {
            cube([NOTCH_WIDTH + 0.2, W_THICK + 0.2, NOTCH_DEPTH + 0.2]);
        }
    }
}

// Generate the part
main_housing();