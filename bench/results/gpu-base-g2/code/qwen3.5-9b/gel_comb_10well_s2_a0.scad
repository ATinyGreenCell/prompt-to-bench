// 10-well Agarose Gel Casting Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 100; // High resolution for smooth edges

// Spine dimensions
SPINE_LENGTH = 70;   // X dimension
SPINE_WIDTH = 12;    // Y dimension
PLATE_THICKNESS = 1.5; // Z dimension

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;   // X dimension
TOOTH_LENGTH = 12;   // Y dimension (depth from spine)
GAP_SIZE = 1.5;      // Gap between teeth in X

// --- Calculations ---
// Total width occupied by teeth
TOTAL_TEETH_WIDTH = NUM_TEETH * TOOTH_WIDTH;
// Total width occupied by gaps
TOTAL_GAP_WIDTH = (NUM_TEETH - 1) * GAP_SIZE;
// Total width of the tooth row
TOOTH_ROW_WIDTH = TOTAL_TEETH_WIDTH + TOTAL_GAP_WIDTH;

// Calculate offset to center the tooth row on the spine
// Spine center is at Y = 0.
// Tooth row extends from -Y to +Y.
// We need to shift the row so its center aligns with the spine center.
// Since the row hangs in -Y, the "top" of the row (closest to spine) is at Y = -TOOTH_LENGTH/2 relative to row center.
// Actually, let's define the row geometry first, then translate.
// Row spans from Y = -TOOTH_LENGTH to Y = 0 relative to the spine edge? 
// No, the teeth hang from one edge. Let's assume they hang from the edge at Y = -SPINE_WIDTH/2.
// So the teeth occupy Y from -SPINE_WIDTH/2 - TOOTH_LENGTH to -SPINE_WIDTH/2.
// We need to center this block of width TOOTH_ROW_WIDTH on the spine width SPINE_WIDTH.

// Center of the tooth row block relative to its own local coordinates:
// The block spans from -TOOTH_ROW_WIDTH/2 to +TOOTH_ROW_WIDTH/2 in X.
// In Y, the block spans from -TOOTH_LENGTH to 0 (if attached at 0).
// We want the center of the block in Y to align with the center of the spine (0).
// Center of block Y = -TOOTH_LENGTH / 2.
// Target Center Y = 0.
// Translation Y needed = 0 - (-TOOTH_LENGTH / 2) = TOOTH_LENGTH / 2.
// Wait, if the teeth hang from the edge, let's define the spine from -SPINE_WIDTH/2 to +SPINE_WIDTH/2.
// Let's say the teeth hang from the edge at Y = -SPINE_WIDTH/2.
// Then the teeth occupy Y from -SPINE_WIDTH/2 - TOOTH_LENGTH to -SPINE_WIDTH/2.
// The center of this Y-range is: (-SPINE_WIDTH/2 - TOOTH_LENGTH) + TOOTH_LENGTH/2 = -SPINE_WIDTH/2 - TOOTH_LENGTH/2.
// We want this center to be 0.
// So we need to translate Y by +(SPINE_WIDTH/2 + TOOTH_LENGTH/2).

Y_OFFSET = (SPINE_WIDTH / 2) + (TOOTH_LENGTH / 2);

// --- Main Body (Spine) ---
// Create the main rectangular block
main_body = cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS], center = [0, 0, PLATE_THICKNESS/2]);

// --- Teeth ---
// We will create the teeth as a separate block and union it with the main body.
// This ensures the teeth are solid and connected.
// The teeth block is defined relative to the spine edge.
// Let's define the teeth block in a local coordinate system where the spine edge is at Y=0.
// Then we translate it to the correct position.

// Local tooth block:
// X: from -TOOTH_ROW_WIDTH/2 to +TOOTH_ROW_WIDTH/2
// Y: from 0 to -TOOTH_LENGTH (hanging down)
// Z: from 0 to PLATE_THICKNESS
teeth_block = cube([TOOTH_ROW_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = [0, -TOOTH_LENGTH/2, PLATE_THICKNESS/2]);

// --- Assembly ---
// Combine spine and teeth
// Translate teeth block to align with spine edge and center it on the spine width
final_teeth = translate([0, Y_OFFSET, 0]) * teeth_block;
final_comb = union(main_body, final_teeth);

// --- Render ---
difference() {
    // Start with the combined shape
    union() {
        translate([0, 0, PLATE_THICKNESS/2]) * main_body;
        translate([0, Y_OFFSET, PLATE_THICKNESS/2]) * teeth_block;
    }
    
    // Optional: Add a small fillet or chamfer if desired, but not requested.
    // Ensure no floating parts (none expected here).
}