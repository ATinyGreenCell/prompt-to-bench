// Sowing Template for 90mm Petri Dish
// Designed to sit flat on the XY plane (Z=0)

// --- Dimensions ---
// Disc outer diameter
D_OUTER = 85;
// Disc thickness
T_THICK = 2;
// Grid configuration
GRID_ROWS = 7;
GRID_COLS = 7;
// Hole diameter
D_HOLE = 3;
// Hole spacing (center-to-center)
S_SPACING = 9;
// Notch dimensions
N_WIDTH = 10;   // Width in X
N_DEPTH = 4;    // Depth in Y (from rim)
// Orientation notch location: +Y side, centered on Y axis

// --- Derived Dimensions ---
// Radius of the disc
R_OUTER = D_OUTER / 2;
// Radius of the hole
R_HOLE = D_HOLE / 2;
// Radius of the notch cut (half width)
R_NOTCH_X = N_WIDTH / 2;
// Y position of the notch start (Rim radius - Notch depth)
Y_NOTCH_START = R_OUTER - N_DEPTH;

// --- Main Body ---
// Create the flat disc
difference() {
    // Main disc cylinder
    // Note: center=false ensures the bottom face is at Z=0
    cylinder(
        h = T_THICK,
        r = R_OUTER,
        center = false
    );
    
    // --- Cut Holes ---
    // Loop to create the 7x7 grid of holes
    for (y = [-(GRID_ROWS-1)/2 : 1 : (GRID_ROWS-1)/2]) {
        for (x = [-(GRID_COLS-1)/2 : 1 : (GRID_COLS-1)/2]) {
            translate([x * S_SPACING, y * S_SPACING, 0]) {
                // Extend slightly past the face to ensure clean cut
                cylinder(
                    h = T_THICK + 0.1, 
                    r = R_HOLE,
                    center = false
                );
            }
        }
    }
    
    // --- Cut Orientation Notch ---
    // The notch is on the +Y side, centered on the Y axis.
    // It cuts into the rim.
    // We define a rectangular prism that intersects the cylinder.
    // The notch is 10mm wide (X) and 4mm deep (Y).
    // Position: Centered at X=0. Starts at Y = R_OUTER - N_DEPTH.
    translate([0, Y_NOTCH_START, 0]) {
        // The cut shape needs to extend slightly past the Z=0 and Z=T_THICK faces
        // to ensure the cut goes all the way through.
        cube([
            N_WIDTH,      // X size
            N_DEPTH,      // Y size
            T_THICK + 0.1 // Z size (extends slightly past top and bottom)
        ]);
    }
}