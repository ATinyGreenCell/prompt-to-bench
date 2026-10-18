// Sowing Template for 90mm Petri Dish
// Designed to sit flat on the XY plane (Z=0)

// --- Dimensions ---
// Main disc diameter
D_DISC = 85;
// Main disc thickness
T_DISC = 2;
// Grid configuration
N_ROWS = 7;
N_COLS = 7;
// Hole specifications
D_HOLE = 3;
// Grid spacing (center-to-center)
S_GRID = 9;
// Notch specifications (on +Y side)
W_NOTCH = 10; // Width in X
D_NOTCH = 4;  // Depth in Y (from rim)

// --- Geometry Calculation ---
// Calculate center offset for the grid so it fits within the disc
// The grid spans (N_ROWS-1)*S_GRID in Y and (N_COLS-1)*S_GRID in X
// We center this span on the disc center (0,0)
OFFSET_Y = ((N_ROWS - 1) * S_GRID) / 2;
OFFSET_X = ((N_COLS - 1) * S_GRID) / 2;

// Calculate rim depth for the notch to ensure it cuts cleanly
// Rim radius = D_DISC / 2
RIM_RADIUS = D_DISC / 2;
// Notch starts at Y = RIM_RADIUS - D_NOTCH
NOTCH_Y_START = RIM_RADIUS - D_NOTCH;

// --- Main Body ---
difference() {
    // 1. Create the main disc
    // Centered at (0,0), lying on Z=0, height T_DISC
    translate([0, 0, 0])
    cylinder(h = T_DISC, d = D_DISC, $fn = 64);

    // 2. Cut the 7x7 grid of holes
    // Loop through rows and columns
    for (r = [0 : N_ROWS - 1]) {
        for (c = [0 : N_COLS - 1]) {
            // Calculate position of current hole
            y_pos = OFFSET_Y - (r * S_GRID);
            x_pos = OFFSET_X - (c * S_GRID);
            
            translate([x_pos, y_pos, 0])
            cylinder(h = T_DISC + 0.1, d = D_HOLE, $fn = 64);
        }
    }

    // 3. Cut the rectangular orientation notch on the +Y side
    // The notch is centered on the Y axis (X=0)
    // It extends from the rim inwards by D_NOTCH
    // Width is W_NOTCH in X direction
    // Depth is D_NOTCH in Y direction
    
    // Define the notch block to subtract
    // X range: -W_NOTCH/2 to +W_NOTCH/2
    // Y range: NOTCH_Y_START to NOTCH_Y_START + D_NOTCH
    // Z range: 0 to T_DISC + 0.1 (slightly deeper to ensure clean cut)
    
    translate([
        -W_NOTCH / 2, 
        NOTCH_Y_START, 
        0
    ])
    cube([
        W_NOTCH, 
        D_NOTCH, 
        T_DISC + 0.1
    ]);
}