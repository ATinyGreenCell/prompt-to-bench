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

// --- Main Body (Spine) ---
// Create the main rectangular block
difference() {
    // Main spine block
    translate([0, 0, 0])
        cube([SPINE_LENGTH, SPINE_WIDTH, SPINE_THICKNESS]);
    
    // Cut out the area where teeth will be attached to create a clean separation
    // We cut a rectangle slightly larger than the tooth row to ensure separation
    translate([X_OFFSET, SPINE_EDGE_Y, 0])
        cube([TOOTH_ROW_WIDTH, TOOTH_LENGTH + 0.1, SPINE_THICKNESS + 0.1]);
}

// --- Teeth ---
// Loop to create each tooth hanging from the spine
for (i = [0 : TOOTH_COUNT - 1]) {
    // Calculate X position for this tooth
    // Start at X_OFFSET, add (i * (width + gap))
    current_x = X_OFFSET + (i * (TOOTH_WIDTH + TOOTH_GAP));
    
    // Calculate Y position for this tooth
    // Starts at the spine edge (SPINE_EDGE_Y) and extends in -Y direction
    current_y = SPINE_EDGE_Y - TOOTH_LENGTH;
    
    // Tooth geometry
    translate([current_x, current_y, 0])
        cube([TOOTH_WIDTH, TOOTH_LENGTH, SPINE_THICKNESS]);
}