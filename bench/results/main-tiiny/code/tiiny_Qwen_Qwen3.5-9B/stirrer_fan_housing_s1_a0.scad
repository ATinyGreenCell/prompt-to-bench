// DIY Magnetic Stirrer Housing (PC Fan Adapter)
// Print Orientation: Top plate on bed (Z=0), walls rising to Z=40.
// Units: mm

// --- Dimensions ---
// Outer footprint of the housing
W_OUT = 90;
H_OUT = 90;

// Thickness of the top plate (bottom of the box)
THICK_TOP = 2;

// Height of the walls
H_WALL = 40;

// Wall thickness
THICK_WALL = 2.5;

// Fan size (for reference, inner cavity matches this)
FAN_SIZE = 80;

// Screw hole specs
D_SCREW = 4.5;
PATTERN_SIZE = 71.5; // Distance between screw centers

// Cable notch specs
W_NOTCH = 12;
H_NOTCH = 8; // Depth from open edge

// Resolution for curves
$fn = 64;

// --- Construction ---

// 1. Create the solid block (Outer box minus inner cavity)
// We build the outer shell first, then subtract the internal volume.
// Outer dimensions: W_OUT x H_OUT x (THICK_TOP + H_WALL)
// Inner cavity dimensions: (W_OUT - 2*THICK_WALL) x (H_OUT - 2*THICK_WALL) x H_WALL
// Note: The top plate is solid, so the inner cavity starts at Z = THICK_TOP.

block_outer = cube([W_OUT, H_OUT, THICK_TOP + H_WALL], center=false);

// Calculate inner cavity dimensions
W_IN = W_OUT - 2 * THICK_WALL;
H_IN = H_OUT - 2 * THICK_WALL;

// Create the inner cavity (hole)
// Position: Centered in X/Y, starting at Z = THICK_TOP
cavity = translate([0, 0, THICK_TOP]) 
    cube([W_IN, H_IN, H_WALL], center=false);

// 2. Create the screw holes
// Pattern: 71.5 mm square, centered on the plate.
// 4 holes at corners of this square.
screw_holes = translate([0, 0, THICK_TOP]) 
    union(
        for (i = [0, 1])
            translate([
                (PATTERN_SIZE/2) * (i ? 1 : -1), 
                (PATTERN_SIZE/2) * (i ? 1 : -1)
            ]) 
                cylinder(h = THICK_TOP + 0.1, r = D_SCREW/2, center=false)
    );

// 3. Create the cable notch
// Location: In one wall. Let's place it on the front wall (Y = H_OUT/2).
// "Centred along the wall" implies centered in X.
// "Reaching 8 mm down from the open edge": Open edge is at Z = THICK_TOP + H_WALL.
// So the notch goes from Z = (THICK_TOP + H_WALL) - H_NOTCH to Z = (THICK_TOP + H_WALL).
notch = translate([
    0, // X: Centered
    H_OUT/2, // Y: Front wall
    (THICK_TOP + H_WALL) - H_NOTCH // Z: Start of cut
]) 
    cube([W_NOTCH, THICK_WALL + 0.1, H_NOTCH], center=false);

// --- Assembly ---

difference() {
    // Main body
    union([block_outer, cavity])
    
    // Cutouts (extended slightly past faces as per rule 5)
    union([
        screw_holes,
        notch
    ])
}