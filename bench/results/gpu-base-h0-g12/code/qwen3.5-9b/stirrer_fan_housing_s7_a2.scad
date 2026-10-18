// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down. Top plate on bed (Z=0), walls rise to Z=40.

// --- Dimensions ---
// Outer size of the box (X, Y)
W = 90;
H = 90;

// Wall height (above the top plate)
// Spec: Walls rise to Z=40. Top plate is 2mm thick.
// Wall height = 40 - 2 = 38 mm.
D_WALL_HEIGHT = 38;

// Wall thickness
T_WALL = 2.5;

// Top plate thickness
T_TOP = 2;

// Total height of the part (Top plate + Walls)
Z_MAX = T_TOP + D_WALL_HEIGHT; // Should be 40

// Fan mounting hole pattern
// 71