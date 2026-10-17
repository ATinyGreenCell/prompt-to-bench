// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 100; // High resolution for smooth curves if needed

// Spine dimensions
SPINE_LENGTH = 70;  // X
SPINE_WIDTH = 12;   // Y
PLATE_THICKNESS = 1.5; // Z

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;  // X
TOOTH_LENGTH = 12;  // Y (extends from spine edge)
GAP_SIZE = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width occupied by teeth
TOTAL_TEETH_WIDTH = NUM_TEETH * TOOTH_WIDTH;
// Total width occupied by gaps
TOTAL_GAP_WIDTH = (NUM_TEETH - 1) * GAP_SIZE;
// Total width of the tooth row
TOOTH_ROW_WIDTH = TOTAL_TEETH_WIDTH + TOTAL_GAP_WIDTH;

// Calculate offset to center the tooth row on the spine
// Spine center is at Y = 0.
// Tooth row extends from -Y direction.
// We need to shift the row so its center aligns with the spine center.
// Row center relative to its own local origin (if defined at top edge) needs adjustment.
// Let's define the row geometry relative to the spine edge (Y = SPINE_WIDTH/2).
// The row has a total width of TOOTH_ROW_WIDTH.
// The center of this row is at (SPINE_WIDTH/2) - (TOOTH_ROW_WIDTH / 2).
// Since we are building teeth hanging in -Y, the "top" of the teeth is at Y = SPINE_WIDTH/2.
// The "bottom" of the teeth is at Y = SPINE_WIDTH/2 - TOOTH_LENGTH.
// The center of the row in Y is SPINE_WIDTH/2 - (TOOTH_ROW_WIDTH / 2).
// We want this center to be at 0.
// So we translate the whole tooth assembly by + (TOOTH_ROW_WIDTH / 2) in Y before placing it?
// Actually, simpler approach:
// Define the spine.
// Define the teeth array.
// The teeth start at Y = SPINE_WIDTH/2 and go down to Y = SPINE_WIDTH/2 - TOOTH_LENGTH.
// We need to shift the X position of the teeth so they are centered on the spine.
// Spine X range: -SPINE_LENGTH/2 to +SPINE_LENGTH/2.
// Tooth row X range: needs to be centered at 0.
// So the left edge of the first tooth should be at: - (TOOTH_ROW_WIDTH / 2).

// --- Construction ---

// 1. The Spine (Back Bar)
// A flat plate, 70x12x1.5
spine = translate([0, 0, 0])
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS]);

// 2. The Teeth
// We will create the teeth using a loop.
// The teeth hang from the edge at Y = SPINE_WIDTH/2 in the -Y direction.
// The row of teeth is centered on the spine (X=0).

teeth_group = union();

for (i = [0 : NUM_TEETH - 1]) {
    // Calculate X position for this tooth
    // Center of the row is at X=0.
    // Each tooth is TOOTH_WIDTH wide.
    // The row starts at X = -TOOTH_ROW_WIDTH/2.
    // Position of tooth i (0-indexed):
    // Left edge = Start + i * (TOOTH_WIDTH + GAP_SIZE)
    // Center = Left edge + TOOTH_WIDTH/2
    
    row_start_x = -(TOOTH_ROW_WIDTH / 2);
    tooth_center_x = row_start_x + (i * (TOOTH_WIDTH + GAP_SIZE)) + (TOOTH_WIDTH / 2);
    
    // Tooth geometry:
    // Width: TOOTH_WIDTH (X)
    // Length: TOOTH_LENGTH (Y)
    // Thickness: PLATE_THICKNESS (Z)
    // Position:
    // X: tooth_center_x
    // Y: Starts at SPINE_WIDTH/2, extends to SPINE_WIDTH/2 - TOOTH_LENGTH
    // Z: 0 to PLATE_THICKNESS
    
    tooth = translate([tooth_center_x, SPINE_WIDTH/2, 0])
        cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS]);
    
    teeth_group = union(teeth_group, tooth);
}

// 3. Combine Spine and Teeth
// Since the teeth are printed as a single object hanging off the spine,
// we can just union them. The spine covers the top edge of the teeth.
final_comb = union(spine, teeth_group);

// Render
final_comb;