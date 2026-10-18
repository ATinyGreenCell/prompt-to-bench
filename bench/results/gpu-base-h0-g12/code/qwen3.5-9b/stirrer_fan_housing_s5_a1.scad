// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Upside down (Top plate on bed, walls rising up)

// --- Dimensions ---
// Outer dimensions of the box
W = 90;      // Width (X)
D = 90;      // Depth (Y)
H_WALL = 40; // Height of walls (Z) - Must be exactly 40

// Wall thickness
T_WALL = 2.5;

// Top plate thickness
T_TOP = 2;

// Fan mounting hole pattern
PATTERN_SIZE = 71.5; // Distance between opposite holes
HOLE_SIZE = 4.5;      // Diameter of M4 screw holes - Must be exactly 4.5

// Cable notch dimensions
NOTCH_WIDTH = 12;
NOTCH_DEPTH = 8;      // Depth from the open top edge (Z = H_WALL)

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Main Body Construction ---
// We build the solid from the bottom up.
// The base is the top plate (z=0 to z=2).
// The walls rise from z=2 to z=40.

difference() {
    union() {
        // 1. The Top Plate (Base)
        // Outer size W x D, thickness T_TOP
        translate([0, 0, 0]) 
            cube([W, D, T_TOP]);

        // 2. The Walls
        // Rise from z = T_TOP to z = H_WALL
        // Outer dimensions W x D
        translate([0, 0, T_TOP]) 
            cube([W, D, H_WALL]);
    }

    // --- Cutouts ---

    // 1. Screw Holes in the Top Plate
    // Pattern: 71.5mm square centered on the plate.
    // Plate is 90x90. Center is (45, 45).
    // Pattern center is (45, 45).
    // Hole positions: +/- 35.75 from center.
    // Coordinates: 9.25, 80.75
    
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            // Calculate position
            px = 45 + (PATTERN_SIZE / 2) * i;
            py = 45 + (PATTERN_SIZE / 2) * j;
            
            // Cut hole through the top plate only (z=0 to z=2)
            // To ensure a clean cut, the cylinder extends slightly past the plate thickness
            // but the diameter is exactly HOLE_SIZE.
            translate([px, py, 0]) 
                cylinder(h = T_TOP + 0.1, r = HOLE_SIZE / 2);
        }
    }

    // 2. Cable Notch in One Wall
    // Location: One of the walls. Let's choose the front wall (Y = 0).
    // The wall is at Y = 0 (face) to Y = 2.5 (inner face).
    // The notch is 12mm wide, centered along the wall (X=45).
    // Notch X range: 45 - 6 = 39 to 45 + 6 = 51.
    // Notch Z range: From open edge (Z=40) down 8mm -> Z=32 to Z=40.
    // Notch Y range: Through the wall thickness (2.5mm). Centered at Y=1.25.
    
    // We cut a block that removes the material from Z=32 to Z=40
    // The block dimensions: [NOTCH_WIDTH, T_WALL, NOTCH_DEPTH]
    // Position: X=39, Y=1.25, Z=32
    
    translate([