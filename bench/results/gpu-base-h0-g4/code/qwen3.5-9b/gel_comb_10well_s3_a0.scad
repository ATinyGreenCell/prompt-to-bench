// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 100; // High resolution for smooth edges

// Spine dimensions
SPINE_LENGTH = 70;  // X
SPINE_WIDTH = 12;   // Y
PLATE_THICKNESS = 1.5; // Z

// Tooth dimensions
TOOTH_WIDTH = 5.0;  // X
TOOTH_LENGTH = 12;  // Y (extends from spine edge)
NUM_TEETH = 10;
GAP_SIZE = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width of the tooth row
TOOTH_ROW_WIDTH = (NUM_TEETH * TOOTH_WIDTH) + ((NUM_TEETH - 1) * GAP_SIZE);

// Offset to center the tooth row on the spine in X
X_OFFSET = (SPINE_LENGTH - TOOTH_ROW_WIDTH) / 2;

// Position of the spine edge where teeth hang (in -Y direction)
// Spine goes from -SPINE_WIDTH/2 to +SPINE_WIDTH/2.
// Teeth hang from the edge at -SPINE_WIDTH/2.
SPINE_EDGE_Y = -SPINE_WIDTH / 2;

// --- Main Body (Spine) ---
// Create the flat plate spine
difference() {
    // Outer block
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS], center = false);
    
    // Cut out the area where teeth will hang to ensure clean separation
    // We cut a rectangle slightly larger than the total tooth row width
    // to ensure no material bridges the teeth.
    translate([0, SPINE_EDGE_Y - 1, 0]) {
        cube([TOOTH_ROW_WIDTH + 2, TOOTH_LENGTH + 2, PLATE_THICKNESS]);
    }
}

// --- Teeth ---
// Loop to create each tooth
for (i = [0 : NUM_TEETH - 1]) {
    // Calculate X position for this tooth
    // Start at X_OFFSET, add tooth width and gap for each previous tooth
    tooth_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
    
    // Calculate Y position for this tooth
    // Centered on the spine edge in Y
    tooth_y = SPINE_EDGE_Y + (TOOTH_LENGTH / 2);
    
    translate([tooth_x, tooth_y, 0]) {
        // Tooth geometry: Width x Length x Thickness
        // Note: The tooth hangs down from the spine edge.
        // The spine edge is at Y = SPINE_EDGE_Y.
        // The tooth extends from SPINE_EDGE_Y to SPINE_EDGE_Y - TOOTH_LENGTH.
        // However, the previous difference() cut already removed the spine material 
        // in that region. We just need to print the tooth shape.
        
        // To make it a solid tooth, we extrude the rectangle.
        // The tooth sits on the bed (Z=0) and goes up to PLATE_THICKNESS.
        // It hangs from the spine edge.
        
        // Define the tooth box relative to its center
        // X: tooth_x is center. Width = TOOTH_WIDTH.
        // Y: tooth_y is center. Length = TOOTH_LENGTH.
        // Z: 0 to PLATE_THICKNESS.
        
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = false);
        
        // Adjust position to match the calculated center
        // The cube command above uses center=false, so we need to translate to the corner or center?
        // Let's use center=true for the cube command to simplify translation logic.
    }
}

// Re-do the teeth loop with correct centering logic for the cube command
for (i = [0 : NUM_TEETH - 1]) {
    tooth_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
    tooth_y = SPINE_EDGE_Y + (TOOTH_LENGTH / 2);
    
    translate([tooth_x, tooth_y, 0]) {
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = true);
    }
}