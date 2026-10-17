// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 128; // High resolution for smooth edges

// Spine dimensions
SPINE_LENGTH = 70;   // X dimension
SPINE_WIDTH = 12;    // Y dimension
PLATE_THICKNESS = 1.5; // Z dimension

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;   // X dimension
TOOTH_LENGTH = 12;   // Y dimension (extends from spine edge)
TOOTH_GAP = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width of the tooth row
TOOTH_ROW_WIDTH = (NUM_TEETH * TOOTH_WIDTH) + ((NUM_TEETH - 1) * TOOTH_GAP);

// Offset to center the tooth row on the spine in X
X_OFFSET = (SPINE_LENGTH - TOOTH_ROW_WIDTH) / 2;

// Position of the spine edge from which teeth hang (negative Y direction)
// Spine spans from -SPINE_WIDTH/2 to +SPINE_WIDTH/2.
// Teeth hang from the edge at Y = -SPINE_WIDTH/2.
SPINE_EDGE_Y = -SPINE_WIDTH / 2;

// --- Main Body (Spine) ---
// Create the flat plate spine
spine = translate([0, 0, PLATE_THICKNESS/2])
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS]);

// --- Teeth ---
// Generate teeth using a for loop
// Each tooth is a rectangular prism hanging from the spine edge in -Y
teeth = concat();
for (i = [0 : NUM_TEETH - 1]) {
    // Calculate X position for this tooth
    // Start at X_OFFSET, add tooth width and gap for each previous tooth
    current_x = X_OFFSET + (i * (TOOTH_WIDTH + TOOTH_GAP));
    
    // Calculate Y position
    // The tooth starts at the spine edge (SPINE_EDGE_Y) and extends TOOTH_LENGTH in -Y
    current_y_start = SPINE_EDGE_Y;
    current_y_end = SPINE_EDGE_Y - TOOTH_LENGTH;
    
    // Define the tooth geometry
    tooth = translate([current_x, current_y_start, PLATE_THICKNESS/2])
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS]);
    
    teeth = concat(teeth, tooth);
}

// --- Assembly ---
// Union the spine and all teeth
final_comb = union(
    spine,
    teeth
);

// Render the final part
final_comb;