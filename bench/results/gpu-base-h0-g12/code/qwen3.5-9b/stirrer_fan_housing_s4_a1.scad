// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Top plate on bed (Z=0), walls rise to Z=40

// --- Dimensions ---
// Outer size of the housing
W = 90;
H = 90;

// Thickness of the top plate (resting on bed)
T_top = 2;

// Height of the walls
H_wall = 40;

// Wall thickness
T_wall = 2.5;

// Fan mounting hole pattern
// The user specified a 71.5mm square pattern for M4 screws.
// This implies the distance between opposite holes is 71.5mm.
// So the offset from center is 71.5 / 2 = 35.75mm in X and Y.
PATTERN_SIZE = 71.5;
HOFFSET = PATTERN_SIZE / 2; // 35.75

// Screw hole diameter
D_screw = 4.5;

// Cable notch dimensions
NOTCH_W = 12;
NOTCH_DEPTH = 8; // Reaches 8mm down from open edge (Z=40 to Z=32)

// --- Configuration ---
$fn = 64; // Ensure smooth curves and round holes

// --- Main Block Construction ---

// 1. Create the solid block representing the housing
// Outer dimensions: W x H x (T_top + H_wall)
block = cube([W, H, T_top + H_wall], center = false);

// 2. Cut the internal void
// The void starts at Z = T_top and goes up to Z = T_top + H_wall
// The void dimensions are the outer dimensions minus the wall thickness on all sides.
void_x = W - (2 * T_wall);
void_y = H - (2 * T_wall);
void_z_start = T_top;
void_z_end = T_top + H_wall;

void = cube([void_x, void_y, void_z_end - void_z_start], 
            center = [void_x/2, void_y/2, void_z_start + (void_z_end - void_z_start)/2]);

// 3. Cut the four screw holes
// Pattern: 71.5mm square centered on the plate.
// Hole centers are at (W/2 +/- HOFFSET, H/2 +/- HOFFSET).
// Holes go through the top plate (Z = T_top) and slightly into the void to ensure clean cut.
hole_depth = T_top + 0.5;
hole_radius = D_screw / 2;

// Define the 4 hole positions relative to the part center
hole_positions = [
    [HOFFSET, HOFFSET],
    [-HOFFSET, HOFFSET],
    [HOFFSET, -HOFFSET],
    [-HOFFSET, -HOFFSET]
];

// Loop to create holes
hole_list = [];
for (p = hole_positions) {
    x = p[0];
    y = p[1];
    // Translate to hole center, then extrude cylinder downwards
    // Cylinder center at (x, y, T_top)
    // Cylinder extends from T_top down to T_top - hole_depth
    h = cylinder(r = hole_radius, h = hole_depth, center = [x, y, T_top]);
    hole_list = union(hole_list, h);
}

// 4. Cut the cable notch
// Location: One wall. Let's choose the wall at X = W/2 (Right wall).
// The notch is 12mm wide, centered along the wall.
// The wall runs from Y = -H/2 to Y = H/2.
// Center of wall is Y = 0 (relative to part center).
// Notch reaches 8mm down from open edge (Z = 40).
// So notch goes from Z = 32 to Z = 40.
// Width = 12mm.
// Position in Y: Centered at 0. So from -6 to +6.

notch_x_start = W/2 - NOTCH_W/2;
notch_x_end = W/2 + NOTCH_W/2;
notch_y_start = -NOTCH_W/2;
notch_y_end = NOTCH_W/2;
notch_z_start = T_top + H_wall - NOTCH_DEPTH; // 40 - 8 = 32
notch_z_end = T_top + H_wall; // 40

notch = cube([NOTCH_W, NOTCH_W, NOTCH_DEPTH], 
             center = [W/2, 0, T_top + H_wall - NOTCH_DEPTH/2]);

// --- Final Assembly ---
// Start with the full block
final_part = block;

// Subtract the internal void
final_part = difference(final_part, void);

// Subtract the screw holes
final_part = difference(final_part, hole_list);

// Subtract the cable notch
final_part = difference(final_part, notch);

// Render
final_part;