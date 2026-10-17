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
X_OFFSET = (W_PLATE_X / 2) - (W_PLATE_X / 2); // 0
Y_OFFSET = (W_PLATE_Y / 2) - (W_PLATE_Y / 2); // 0

// Hole grid positions
// Rows along X: 3 holes. Spacing 40mm.
// Centres at: -40, 0, +40
HOLE_X_POS = [-40, 0, 40];

// Cols along Y: 2 holes. Spacing 40mm.
// Plate Y is 90mm. Centres should be symmetric.
// If spacing is 40, and we have 2 holes, distance between them is 40.
// We need to fit this within 90mm plate width symmetrically.
// Let's calculate exact Y positions for 2 holes with 40mm spacing centered on Y=0.
// y1 = -20, y2 = +20. Distance = 40.
// Check clearance: 20 + 20 = 40 < 45 (half plate width). OK.
HOLE_Y_POS = [-20, 20];

// Wall positions
// Walls run along the long edges (X direction).
// Plate Y is 90mm. Half is 45mm.
// Wall thickness is 4mm.
// Wall 1 (Left): Extends from Y = -45 to Y = -41
// Wall 2 (Right): Extends from Y = +41 to Y = +45
WALL_Y_MIN = -45;
WALL_Y_MAX = 45;
WALL_Y_INNER = -41;
WALL_Y_OUTER = 41;

// --- Configuration ---
$fn = 128; // High resolution for holes and walls

module plate() {
    translate([0, 0, 0]) {
        cube([W_PLATE_X, W_PLATE_Y, H_PLATE], center = false);
    }
}

module hole(x, y) {
    translate([x, y, 0]) {
        // Cut a cylinder through the plate
        difference() {
            cube([W_PLATE_X, W_PLATE_Y, H_PLATE], center = false);
            cylinder(h = H_PLATE + 1, d = D_HOLE, $fn = 128);
        }
    }
}

module wall() {
    // Wall runs along X, from Y = -45 to -41 (Left) and +41 to +45 (Right)
    // We create two separate wall blocks to ensure clean geometry
    // Left Wall
    translate([0, WALL_Y_MIN, 0]) {
        cube([W_PLATE_X, WALL_Y_OUTER - WALL_Y_MIN, H_WALL], center = false);
    }
    // Right Wall
    translate([0, WALL_Y_MAX, 0]) {
        cube([W_PLATE_X, WALL_Y_MAX - WALL_Y_INNER, H_WALL], center = false);
    }
}

module main() {
    union() {
        // 1. Create the base plate
        plate();
        
        // 2. Create the holes
        for (xi = [0:N_ROWS-1]) {
            for (yi = [0:N_COLS-1]) {
                hole(
                    HOLE_X_POS[xi], 
                    HOLE_Y_POS[yi]
                );
            }
        }
        
        // 3. Create the walls
        // Since we used difference() for holes, the walls need to be added back
        // or we can build the whole thing as a union of (Plate + Holes) + Walls.
        // However, the holes cut through the plate. The walls are attached to the plate edges.
        // The holes do NOT intersect the walls because the walls are at Y=+-45 and holes are at Y=+-20.
        // So we can simply union the walls on top of the holed plate.
        
        wall();
    }
}

main();