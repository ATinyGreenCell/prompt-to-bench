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
    // We cut a rectangle slightly larger than the tooth row to remove the spine material
    // extending into the tooth area.
    translate([0, SPINE_EDGE_Y - 0.1, 0]) {
        cube([SPINE_LENGTH, TOOTH_LENGTH + 0.1, PLATE_THICKNESS]);
    }
}

// --- Teeth ---
// Loop to create 10 teeth
for (i = [0 : NUM_TEETH - 1]) {
    // Calculate X position for this tooth
    // Start at X_OFFSET, add tooth width and gaps
    current_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
    
    // Calculate Y position for this tooth
    // Centered on the spine edge in Y
    current_y = SPINE_EDGE_Y + (TOOTH_LENGTH / 2);
    
    translate([current_x, current_y, 0]) {
        // Tooth geometry: 5mm wide (X), 12mm long (Y), 1.5mm thick (Z)
        // Since the spine was cut out, we just extrude the tooth shape
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = false);
    }
}