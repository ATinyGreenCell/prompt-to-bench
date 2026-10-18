// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

$fn = 100; // High resolution for smooth edges

// --- Dimensions ---
SPINE_LENGTH = 70;  // X
SPINE_WIDTH = 12;   // Y
PLATE_THICKNESS = 1.5; // Z

TOOTH_WIDTH = 5.0;  // X
TOOTH_LENGTH = 12;  // Y (extends from spine edge)
NUM_TEETH = 10;
GAP_SIZE = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width of the tooth row
TOOTH_ROW_WIDTH = (NUM_TEETH * TOOTH_WIDTH) + ((NUM_TEETH - 1) * GAP_SIZE);

// Offset to center the tooth row on the spine in X
X_OFFSET = (SPINE_LENGTH - TOOTH_ROW_WIDTH) / 2;

// Spine geometry: Centered at (0,0) in XY.
// Spine Y range: -SPINE_WIDTH/2 to +SPINE_WIDTH/2
// Spine Edge (where teeth hang): Y = -SPINE_WIDTH/2
SPINE_EDGE_Y = -SPINE_WIDTH / 2;

// Tooth Y range: Starts at SPINE_EDGE_Y, extends TOOTH_LENGTH in -Y direction.
// Tooth Center Y = SPINE_EDGE_Y - (TOOTH_LENGTH / 2)
TOOTH_CENTER_Y = SPINE_EDGE_Y - (TOOTH_LENGTH / 2);

// --- Main Body Construction ---
// We use a single union to merge the "Spine with Slots" and the "Teeth" into one solid body.
// This ensures the output is 1 separate body.

union() {
    // Part 1: Spine with slots cut out
    difference() {
        // The full spine block
        translate([0, 0, 0]) {
            cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS], center = false);
        }
        
        // Cut out slots for the teeth
        // We cut a rectangle for each tooth slot.
        // The slot extends from the spine edge (SPINE_EDGE_Y) downwards by TOOTH_LENGTH.
        // The slot width is TOOTH_WIDTH.
        // We extend the cut slightly (0.02mm) to ensure clean separation.
        
        for (i = [0 : NUM_TEETH - 1]) {
            // Calculate X position for this tooth
            tooth_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
            
            // Calculate Y position for the slot
            // The slot spans from SPINE_EDGE_Y down to SPINE_EDGE_Y - TOOTH_LENGTH
            translate([tooth_x, SPINE_EDGE_Y, 0]) {
                // Cut a rectangle slightly larger than the tooth to ensure separation
                cube([TOOTH_WIDTH + 0.02, TOOTH_LENGTH + 0.02, PLATE_THICKNESS], center = false);
            }
        }
    }
    
    // Part 2: The solid teeth
    // They sit on the bed (Z=0) and go up to PLATE_THICKNESS.
    // They hang from the spine edge.
    
    for (i = [0 : NUM_TEETH - 1]) {
        tooth_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
        
        // Position the tooth
        // X: tooth_x
        // Y: tooth_x is center. Y center is TOOTH_CENTER_Y.
        // Z: Centered at PLATE_THICKNESS/2
        
        translate([tooth_x, TOOTH_CENTER_Y, PLATE_THICKNESS / 2]) {
            cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = true);
        }
    }
}