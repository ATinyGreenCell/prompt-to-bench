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

// Calculate offset to center the tooth row on the spine in Y.
// The spine is centered at Y=0, spanning from -SPINE_WIDTH/2 to +SPINE_WIDTH/2.
// The teeth hang from the edge at Y = -SPINE_WIDTH/2.
// The teeth block spans Y from -SPINE_WIDTH/2 - TOOTH_LENGTH to -SPINE_WIDTH/2.
// The center of this block is at Y = -SPINE_WIDTH/2 - TOOTH_LENGTH/2.
// To center this block at Y=0, we must translate by + (SPINE_WIDTH/2 + TOOTH_LENGTH/2).
Y_OFFSET = (SPINE_WIDTH / 2) + (TOOTH_LENGTH / 2);

// --- Main Body (Spine) ---
// Create the main rectangular block centered at origin
main_body = cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS], center = [0, 0, PLATE_THICKNESS/2]);

// --- Teeth ---
// Create the teeth as a single block to ensure solid connection
// Local coordinates: X centered, Y from 0 to -TOOTH_LENGTH, Z from 0 to PLATE_THICKNESS
teeth_block = cube([TOOTH_ROW_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS], center = [0, -TOOTH_LENGTH/2, PLATE_THICKNESS/2]);

// --- Assembly ---
// Translate the teeth block to the correct position relative to the spine
final_teeth = translate([0, Y_OFFSET, 0]) * teeth_block;

// Union the spine and the teeth
final_comb = union(main_body, final_teeth);

// --- Render ---
// Output the final solid
final_comb;