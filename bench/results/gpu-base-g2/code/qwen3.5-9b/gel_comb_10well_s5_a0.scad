// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).

// --- Dimensions ---
$fn = 128; // High resolution for smooth edges

// Spine dimensions
SPINE_LENGTH = 70;   // X dimension
SPINE_WIDTH = 12;     // Y dimension
PLATE_THICKNESS = 1.5; // Z dimension

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;    // X dimension
TOOTH_LENGTH = 12;    // Y dimension (depth from spine)
TOOTH_GAP = 1.5;      // Gap between teeth

// --- Calculations ---
// Total width occupied by teeth
TOOTH_TOTAL_WIDTH = NUM_TEETH * TOOTH_WIDTH;
// Total width occupied by gaps
GAP_TOTAL_WIDTH = (NUM_TEETH - 1) * TOOTH_GAP;
// Total width of the tooth row
ROW_WIDTH = TOOTH_TOTAL_WIDTH + GAP_TOTAL_WIDTH;

// Offset to center the tooth row on the spine in X
// Spine center is at X=0. Row center must be at X=0.
// Row extends from -ROW_WIDTH/2 to +ROW_WIDTH/2.
// Tooth centers are at -ROW_WIDTH/2 + (TOOTH_WIDTH + TOOTH_GAP)/2 + i * (TOOTH_WIDTH + TOOTH_GAP)
TOOTH_OFFSET_X = (SPINE_LENGTH - ROW_WIDTH) / 2;

// --- Main Body (Spine) ---
// The spine is a flat plate.
// It rests on Z=0.
// Width in Y is SPINE_WIDTH.
// Length in X is SPINE_LENGTH.
// Thickness in Z is PLATE_THICKNESS.
difference() {
    // Create a slightly larger block to ensure clean subtraction of teeth
    // Extend Z slightly to avoid coplanar faces during subtraction
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS + 0.1], center = false);
    
    // Position the block so its bottom is at Z=0
    translate([0, 0, 0]) {
        // We will subtract the teeth from this block.
        // The teeth hang in the -Y direction from the top edge (Y = SPINE_WIDTH/2).
        
        // Loop through each tooth
        for (i = [0 : NUM_TEETH - 1]) {
            // Calculate X position for this tooth
            // Start at the left edge of the row, add half a tooth+gap, then add i * (tooth+gap)
            tooth_x = -ROW_WIDTH/2 + (TOOTH_WIDTH + TOOTH_GAP)/2 + i * (TOOTH_WIDTH + TOOTH_GAP);
            
            // Calculate Y position for this tooth
            // The teeth hang from the top edge of the spine.
            // Spine top edge is at Y = SPINE_WIDTH/2.
            // Tooth extends TOOTH_LENGTH in the -Y direction.
            tooth_y = SPINE_WIDTH/2 - TOOTH_LENGTH/2;
            
            // Define the tooth shape to subtract
            // Width: TOOTH_WIDTH (X)
            // Height: TOOTH_LENGTH (Y)
            // Depth: PLATE_THICKNESS + 0.1 (Z) - slightly more than plate to ensure full cut
            tooth_shape = cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS + 0.1]);
            
            // Translate the tooth shape to the correct position
            translate([tooth_x, tooth_y, 0]) {
                tooth_shape;
            }
        }
    }
}