// 10-well Agarose Gel Casting Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).

// --- Dimensions ---
$fn = 64; // Smoothness for curved features

// Spine dimensions
SPINE_LENGTH = 70;   // mm (X)
SPINE_WIDTH = 12;    // mm (Y)
PLATE_THICKNESS = 1.5; // mm (Z)

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;   // mm (X)
TOOTH_LENGTH = 12;   // mm (Y) (extends from spine edge)
GAP_SIZE = 1.5;      // mm (X) between teeth

// --- Calculations ---
// Total width of the tooth row
TOOTH_ROW_WIDTH = (NUM_TEETH * TOOTH_WIDTH) + ((NUM_TEETH - 1) * GAP_SIZE);

// Offset to center the tooth row on the spine in X
X_OFFSET = (SPINE_LENGTH - TOOTH_ROW_WIDTH) / 2;

// Position of the spine edge where teeth hang (in Y)
// Spine is centered at Y=0, so it goes from -SPINE_WIDTH/2 to +SPINE_WIDTH/2.
// Teeth hang in -Y direction from the bottom edge (-SPINE_WIDTH/2).
SPINE_Y_HALF = SPINE_WIDTH / 2;
SPINE_Y_START = -SPINE_Y_HALF; // Bottom of spine
TEETH_Y_START = SPINE_Y_START - TOOTH_LENGTH; // Bottom of teeth

// --- Main Body (Spine) ---
// A flat plate 70x12x1.5, centered at origin
difference() {
    // Outer block (centered)
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS], center = true);
    
    // Cut out the area where teeth will hang to ensure clean separation
    // We cut a rectangle slightly larger than the tooth row to avoid coplanar faces
    // Start at the bottom of the spine (Y = -6)
    translate([X_OFFSET, SPINE_Y_START, 0]) {
        cube([TOOTH_ROW_WIDTH, TOOTH_LENGTH + 0.1, PLATE_THICKNESS + 0.1], center = false);
    }
}

// --- Teeth ---
// We iterate through each tooth position
for (i = [0 : NUM_TEETH - 1]) {
    // Calculate X position for this tooth
    // Start at X_OFFSET, add tooth width and gaps
    current_x = X_OFFSET + (i * (TOOTH_WIDTH + GAP_SIZE));
    
    // Translate to position
    translate([current_x, TEETH_Y_START, 0]) {
        // Tooth geometry: 5.0 wide (X) x 12 long (Y) x 1.5 thick (Z)
        // The tooth hangs down from the spine edge.
        // With TEETH_Y_START = -18, and cube growing positive Y, it occupies Y from -18 to -6.
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = false);
    }
}