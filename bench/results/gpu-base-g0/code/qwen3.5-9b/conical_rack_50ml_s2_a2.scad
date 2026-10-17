// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over to stand on the two walls.

// --- Dimensions ---
// Plate dimensions
W_PLATE_X = 130; // mm
W_PLATE_Y = 90;  // mm
H_PLATE = 4;     // mm

// Hole specifications
N_ROWS = 3;      // Rows along X
N_COLS = 2;      // Cols along Y
D_HOLE = 30.5;   // mm (Diameter)
C_X = 40;        // mm (Centre-to-centre spacing X)
C_Y = 40;        // mm (Centre-to-centre spacing Y)

// Wall specifications
H_WALL = 70;     // mm (Total height from bed)
W_WALL_THICK = 4; // mm (Thickness of wall)

// --- Derived Positions ---
// Plate is centred on origin
// Hole grid positions
// Rows along X: 3 holes. Spacing 40mm. Centres at: -40, 0, +40
HOLE_X_POS = [-40, 0, 40];

// Cols along Y: 2 holes. Spacing 40mm.
// Plate Y is 90mm. Half is 45mm.
// We need to fit 2 holes with 40mm spacing symmetrically.
// Distance between holes = 40mm.
// Center of the pair = 0.
// y1 = -20, y2 = +20.
HOLE_Y_POS = [-20, 20];

// Wall positions
// Walls run along the long edges (X direction).
// Plate Y is 90mm. Half is 45mm.
// Wall thickness is 4mm.
// Wall 1 (Left): Extends from Y = -45 to Y = -41
// Wall 2 (Right): Extends from Y = +41 to Y = +45
WALL_Y_START_LEFT = -45;
WALL_Y_END_LEFT = -41;

WALL_Y_START_RIGHT = 41;
WALL_Y_END_RIGHT = 45;

// --- Configuration ---
$fn = 128; // High resolution for holes and walls

module main() {
    // Create the base plate
    // We use difference() to cut holes from the plate
    difference() {
        // 1. The Plate
        translate([0, 0, 0]) {
            cube([W_PLATE_X, W_PLATE_Y, H_PLATE], center = false);
        }
        
        // 2. The Holes
        for (xi = [0:N_ROWS-1]) {
            for (yi = [0:N_COLS-1]) {
                translate([HOLE_X_POS[xi], HOLE_Y_POS[yi], 0]) {
                    // Cut cylinder through the plate
                    cylinder(h = H_PLATE + 0.1, d = D_HOLE, $fn = 128);
                }
            }
        }
    }
    
    // Add the walls
    // Left Wall: 130mm long, 4mm thick (Y), 70mm high
    translate([0, WALL_Y_START_LEFT, 0]) {
        cube([W_PLATE_X, WALL_Y_END_LEFT - WALL_Y_START_LEFT, H_WALL], center = false);
    }
    
    // Right Wall: 130mm long, 4mm thick (Y), 70mm high
    translate([0, WALL_Y_START_RIGHT, 0]) {
        cube([W_PLATE_X, WALL_Y_END_RIGHT - WALL_Y_START_RIGHT, H_WALL], center = false);
    }
}

main();