// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 128; // High resolution for smooth edges

// Spine dimensions
SPINE_LENGTH = 70;   // X dimension
SPINE_WIDTH = 12;    // Y dimension
SPINE_THICKNESS = 1.5; // Z dimension

// Tooth dimensions
TOOTH_WIDTH = 5.0;   // X dimension
TOOTH_LENGTH = 12;   // Y dimension (extends from spine edge)
TOOTH_COUNT = 10;
TOOTH_GAP = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width of the tooth row
TOOTH_ROW_WIDTH = (TOOTH_COUNT * TOOTH_WIDTH) + ((TOOTH_COUNT - 1) * TOOTH_GAP);

// Offset to center the tooth row on the spine in X
X_OFFSET = (SPINE_LENGTH - TOOTH_ROW_WIDTH) / 2;

// Position of the spine edge from which teeth hang (-Y direction)
// Spine is centered in Y, so edge is at -SPINE_WIDTH/2
SPINE_EDGE_Y = -SPINE_WIDTH / 2;

// --- Main Construction ---
// We create the full solid (Spine + Teeth) first, then cut the gaps.
union() {
    // 1. Create the Spine
    translate([0, 0, 0])
        cube([SPINE_LENGTH, SPINE_WIDTH, SPINE_THICKNESS]);

    // 2. Create the Teeth attached to the spine
    // We add them to the union so they become one solid piece
    for (i = [0 : TOOTH_COUNT - 1]) {
        // Calculate X position for this tooth
        current_x = X_OFFSET + (i * (TOOTH_WIDTH + TOOTH_GAP));
        
        // Calculate Y position for this tooth
        // Starts at the spine edge (SPINE_EDGE_Y) and extends in -Y direction
        current_y = SPINE_EDGE_Y - TOOTH_LENGTH;
        
        translate([current_x, current_y, 0])
            cube([TOOTH_WIDTH, TOOTH_LENGTH, SPINE_THICKNESS]);
    }
}

// --- Cut the Gaps (Wells) ---
// We subtract the gaps between teeth.
// We extend the cut slightly (0.1mm) to ensure clean separation and no thin walls.
difference() {
    // The solid created above is implicitly referenced if we wrap it, 
    // but since we used union() above, we need to recreate the solid here 
    // or use a variable. To keep it self-contained and robust without variables 
    // that might confuse the difference context, we recreate the solid shape 
    // and subtract the gaps from it.
    
    // Recreate the full solid for the difference operation
    union() {
        translate([0, 0, 0])
            cube([SPINE_LENGTH, SPINE_WIDTH, SPINE_THICKNESS]);
        
        for (i = [0 : TOOTH_COUNT - 1]) {
            current_x = X_OFFSET + (i * (TOOTH_WIDTH + TOOTH_GAP));
            current_y = SPINE_EDGE_Y - TOOTH_LENGTH;
            
            translate([current_x, current_y, 0])
                cube([TOOTH_WIDTH, TOOTH_LENGTH, SPINE_THICKNESS]);
        }
    }
    
    // Subtract the gaps between teeth
    for (i = [0 : TOOTH_COUNT - 2]) {
        // Calculate X position of the gap
        gap_x = X_OFFSET + (i * (TOOTH_WIDTH + TOOTH_GAP)) + TOOTH_WIDTH;
        
        // Gap dimensions
        gap_width = TOOTH_GAP;
        gap_length = TOOTH_LENGTH;
        
        // Cut slightly past the faces to ensure separation
        translate([gap_x, SPINE_EDGE_Y - TOOTH_LENGTH, 0])
            cube([gap_width + 0.1, gap_length + 0.1, SPINE_THICKNESS + 0.1]);
    }
}