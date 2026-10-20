// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down (Top plate on bed)
// Units: mm

// --- Dimensions ---
// Outer footprint of the housing
W_OUT = 90;
H_OUT = 90;

// Thickness of the top plate (bottom of the box in print orientation)
THICK_TOP = 2;

// Height of the walls
H_WALL = 38; // Total height 40mm - 2mm top plate

// Wall thickness
THICK_WALL = 2.5;

// Fan mounting hole diameter (M4 clearance)
D_FAN_HOLE = 4.5;

// Fan mounting hole pattern: 71.5mm square, centred
PATTERN_SIZE = 71.5;

// Cable notch dimensions
NOTCH_W = 12;
NOTCH_H = 8; // Depth from open edge (z=40) down to z=32

// Resolution for curved features
$fn = 64;

// --- Helper: Create the main box block ---
module stirrer_housing() {
    // We build the box as a single solid using difference to cut holes and notches
    // Base block: Outer dimensions, total height (top plate + walls)
    h_total = THICK_TOP + H_WALL;
    
    difference() {
        // 1. Main Block
        // Outer size: W_OUT x H_OUT
        // Height: h_total
        translate([0, 0, 0])
            cube([W_OUT, H_OUT, h_total], center = false);
        
        // 2. Cut Fan Mounting Holes through the top plate
        // Pattern: 71.5mm square centred on the 90x90 plate
        // Hole centers: (71.5/2, 71.5/2), (71.5/2, -71.5/2), (-71.5/2, 71.5/2), (-71.5/2, -71.5/2)
        // Z range: 0 to THICK_TOP (2mm)
        
        for (i = [0, 1]) {
            for (j = [0, 1]) {
                // Calculate offset for the 4 corners of the square pattern
                // i=0, j=0 -> -X, -Y
                // i=0, j=1 -> -X, +Y
                // i=1, j=0 -> +X, -Y
                // i=1, j=1 -> +X, +Y
                x_off = (i == 0) ? (-PATTERN_SIZE/2) : (PATTERN_SIZE/2);
                y_off = (j == 0) ? (-PATTERN_SIZE/2) : (PATTERN_SIZE/2);
                
                translate([x_off, y_off, 0])
                    cylinder(
                        h = THICK_TOP + 0.1, // Extend slightly past top plate to ensure clean cut
                        r = D_FAN_HOLE/2,
                        center = true
                    );
            }
        }
        
        // 3. Cut Cable Notch
        // Location: One wall. Let's choose the wall at X = -W_OUT/2 (Left wall).
        // Width: 12mm. Centred along the wall (Y direction).
        // Depth: 8mm from the open edge (z=40) down to z=32.
        // Open edge is at z = THICK_TOP + H_WALL = 40.
        // Notch goes from z = 40 - 8 = 32 to z = 40.
        
        // Wall center X: -45
        // Wall center Y: 0
        // Notch width: 12
        // Notch height: 8
        
        translate([-W_OUT/2, 0, 0]) {
            // Create a box that cuts into the wall
            // The notch is a void. We define a box of size [W, H, D]
            // W = NOTCH_W (12)
            // H = NOTCH_H (8)
            // D = THICK_WALL (2.5) - extending slightly past the wall thickness to ensure clean cut
            
            // Position:
            // X: Centered on the wall face. The wall face is at X = -45.
            // The notch width is 12. So it spans from -45 - 6 to -45 + 6.
            // Y: Centered on the wall. Wall height is 90. Center is 0.
            // Z: From 32 to 40.
            
            // To cut correctly in difference(), the cutting object must exist where the hole is.
            // We define a block that represents the "missing material".
            
            translate([
                -W_OUT/2 - NOTCH_W/2, // X start of notch
                -NOTCH_H/2,           // Y center (0)
                32                    // Z start of notch
            ])
                cube([
                    NOTCH_W,          // Width 12
                    H_OUT,            // Height 90 (must cover full wall height)
                    NOTCH_H + 0.1     // Depth 8 + epsilon to cut through wall thickness
                ]);
        }
    }
}

// --- Main Assembly ---
// Center the part on the origin as requested
translate([0, 0, 0])
    stirrer_housing();