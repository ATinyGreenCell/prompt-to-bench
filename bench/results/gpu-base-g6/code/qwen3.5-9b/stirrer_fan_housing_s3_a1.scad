// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down (Top plate on bed, walls rising up)
// Units: mm

// --- Dimensions ---
// Outer size of the box
W = 90;
H = 90;

// Thickness of the top plate (resting on bed)
T_top = 2;

// Height of the walls
H_wall = 40;

// Wall thickness
T_wall = 2.5;

// Fan mounting hole pattern
// Pattern is 71.5mm square, centred on the plate
PATTERN_SIZE = 71.5;
HOLE_SIZE = 4.5; // M4 screw hole

// Cable notch dimensions
NOTCH_WIDTH = 12;
NOTCH_DEPTH = 8; // Reaches from z=32 to z=40 (40-8=32)
NOTCH_WALL = 0; // Index of the wall to cut (0:Front, 1:Right, 2:Back, 3:Left)

// --- Configuration ---
// Fan is 80mm. Outer box is 90mm.
// Wall thickness is 2.5mm.
// Inner width = 90 - 2*2.5 = 85mm.
// Fan (80mm) fits inside 85mm inner space with 2.5mm clearance on each side.

$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Main Assembly ---
// We build the part as a single solid by subtracting the inner cavity from the outer block.
// This ensures the base and walls are one continuous piece.

difference() {
    // 1. The Outer Block (Base + Walls)
    // Dimensions: W x H x (T_top + H_wall)
    // Position: Centered at (0,0) in X and Y to match the "centre it on the origin" rule.
    // The user said "Model it in print orientation... centre it on the origin in X and Y".
    // So the box goes from -45 to +45 in X and Y.
    translate([0, 0, 0]) {
        cube([W, H, T_top + H_wall]);
    }

    // 2. The Inner Cavity (The empty space inside the box)
    // Dimensions: (W - 2*T_wall) x (H - 2*T_wall) x H_wall
    // Position: Starts at Z = T_top.
    // X/Y offset: T_wall from the edges.
    translate([T_wall, T_wall, T_top]) {
        cube([W - 2*T_wall, H - 2*T_wall, H_wall]);
    }

    // 3. Screw Holes
    // Pattern: 71.5mm square, centred on the plate.
    // The plate is 90x90, centred at (0,0).
    // Hole centers: (0,0) +/- (71.5/2 - 4.5/2)
    // Offset = 35.75 - 2.25 = 33.5
    offset = (PATTERN_SIZE / 2) - (HOLE_SIZE / 2);
    
    // Cut holes through the top plate (and slightly into the wall to ensure clean cut)
    // Height of cut: T_top + 0.1
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                i * offset,
                j * offset,
                0
            ]) {
                cylinder(
                    h = T_top + 0.1,
                    r = HOLE_SIZE / 2,
                    $fn = 32
                );
            }
        }
    }

    // 4. Cable Notch
    // "In one wall, cut a notch... 12 mm wide, centred along the wall, reaching 8 mm down from the open edge"
    // Open edge is at Z = T_top + H_wall = 42.
    // Notch goes from Z = 42 - 8 = 34 to Z = 42.
    // Wait, the prompt says "reaching 8 mm down from the open edge (from z = 32 to z = 40)".
    // This implies the total height of the walls is 40mm?
    // Let's re-read: "four walls, 2.5 mm thick, rise from it to z = 40".
    // Ah, the prompt explicitly says "rise from it to z = 40".
    // So the top of the walls is at