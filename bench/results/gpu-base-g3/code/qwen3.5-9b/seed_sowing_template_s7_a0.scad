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
// Grid spacing (centre-to-centre)
S_GRID = 9;
// Notch specifications (on +Y side)
W_NOTCH = 10; // Width in X
D_NOTCH = 4;  // Depth in Y (from rim)

// --- Geometry Setup ---
// Calculate grid offset to center the grid on the disc
// The grid spans (N_ROWS-1)*S_GRID in Y and (N_COLS-1)*S_GRID in X
GRID_OFFSET_X = ((N_COLS - 1) * S_GRID) / 2;
GRID_OFFSET_Y = ((N_ROWS - 1) * S_GRID) / 2;

// Calculate rim depth for the notch cut
// Radius of disc minus half the notch width to center it on Y
RIM_DEPTH = (D_DISC / 2) - (W_NOTCH / 2);

// --- Main Body ---
difference() {
    // 1. Create the main disc
    // Centered at origin, lying on Z=0
    translate([0, 0, 0])
    cylinder(h = T_DISC, d = D_DISC, $fn = 64);

    // 2. Cut the 7x7 grid of holes
    for (r = [0 : N_ROWS - 1]) {
        for (c = [0 : N_COLS - 1]) {
            // Calculate position of each hole
            x_pos = GRID_OFFSET_X - (c * S_GRID);
            y_pos = GRID_OFFSET_Y - (r * S_GRID);
            
            translate([x_pos, y_pos, 0])
            cylinder(h = T_DISC + 0.1, d = D_HOLE, $fn = 64);
        }
    }

    // 3. Cut the rectangular orientation notch on the +Y side
    // The notch is centered on the Y axis, so X range is [-W_NOTCH/2, W_NOTCH/2]
    // It starts at the rim (Y = RIM_DEPTH) and goes inward by D_NOTCH
    translate([0, RIM_DEPTH, 0])
    cube([W_NOTCH, D_NOTCH, T_DISC + 0.1]);
}