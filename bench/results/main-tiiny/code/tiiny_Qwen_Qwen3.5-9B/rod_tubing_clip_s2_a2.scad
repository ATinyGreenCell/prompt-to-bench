$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Dimensions (mm) ---
// Rod Stand Dimensions
ROD_DIAMETER = 12.7;
ROD_WALL_THICKNESS = 3;
ROD_OUTER_DIAMETER = ROD_DIAMETER + 2 * ROD_WALL_THICKNESS; // 18.7

// Tubing Dimensions
TUBING_DIAMETER = 6;
TUBING_WALL_THICKNESS = 2;
TUBING_OUTER_DIAMETER = TUBING_DIAMETER + 2 * TUBING_WALL_THICKNESS; // 10

// Positioning
RING_ROD_X = 0;
RING_TUBING_X = 15;

// Bridge Dimensions
BRIDGE_WIDTH_X = 4; // From x=8 to x=12
BRIDGE_WIDTH_Y = 6;

// Cutout Dimensions
CUTOUT_ROD_WIDTH = 10;
CUTOUT_ROD_Y_LIMIT = 5; // -5 < y < 5

CUTOUT_TUBING_WIDTH = 4.5;
CUTOUT_TUBING_Y_LIMIT = 2.25; // -2.25 < y < 2.25

// Extrusion Height
EXTRUSION_HEIGHT = 10;

// --- Generation ---

difference() {
    // 1. The Main Profile (Extruded)
    // center = false ensures the bottom of the extrusion is at z=0
    linear_extrude(height = EXTRUSION_HEIGHT, center = false) {
        translate([0, 0, EXTRUSION_HEIGHT / 2]) {
            union() {
                // --- Ring for Rod Stand ---
                circle(
                    r = ROD_OUTER_DIAMETER / 2,
                    $fn = 64
                );
                
                // --- Ring for Tubing ---
                translate([RING_TUBING_X, 0, 0]) {
                    circle(
                        r = TUBING_OUTER_DIAMETER / 2,
                        $fn = 64
                    );
                }
                
                // --- Solid Bridge ---
                // Joins x=8 to x=12, width 6mm in Y
                translate([8, -BRIDGE_WIDTH_Y / 2, 0]) 
                    cube([BRIDGE_WIDTH_X, BRIDGE_WIDTH_Y, 1]);
            }
        }
    }
    
    // 2. Cutouts for the Notches (Difference shapes)
    // These must span the full height of the part to cut through the profile.
    // Extend slightly past the limits to ensure clean cuts.
    
    // Cutout for Rod Stand (-X side)
    // Remove region: x < 0 and -5 < y < 5
    // Box: x from -10 to 0, y from -5 to 5. Center: (-5, 0).
    translate([-5, 0, 0]) {
        cube([CUTOUT_ROD_WIDTH, CUTOUT_ROD_Y_LIMIT * 2, EXTRUSION_HEIGHT + 0.1]);
    }
    
    // Cutout for Tubing (+X side)
    // Remove region: x > 15 and -2.25 < y < 2.25
    // Box: x from 15 to 19.5, y from -2.25 to 2.25. Center: (17.25, 0).
    translate([RING_TUBING_X + CUTOUT_TUBING_WIDTH / 2, 0, 0]) {
        cube([CUTOUT_TUBING_WIDTH,