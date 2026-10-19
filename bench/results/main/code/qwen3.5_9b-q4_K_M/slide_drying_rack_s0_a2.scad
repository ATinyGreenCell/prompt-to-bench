// =============================================================================
// Drying Rack for Microscope Slides
// Designed to hold 10 microscope slides standing upright on their long edge.
// Base dimensions: 90mm (X) x 45mm (Y) x 20mm (Z).
// Slots run along X, centered in the block.
// =============================================================================

$fn = 64; // Ensure smooth curves for any rounded corners if modified later

// --- User Dimensions (Measured with calipers) ---
BLOCK_LENGTH_X   = 90;  // Total length of the base block
BLOCK_WIDTH_Y    = 45;  // Total width of the base block
BLOCK_HEIGHT_Z   = 20;  // Height of the base block

SLIDE_LONG       = 75;  // Long dimension of a microscope slide (X axis)
// Note: Slides stand on their long edge, so they occupy ~1mm in Z.

SLOT_LENGTH_X    = 77;  // Length of each slot along X
SLOT_WIDTH_Y     = 1.6; // Width of each slot across Y
SLOT_DEPTH_Z     = 10;  // Depth of the cut into the block (from top)

SPACING_CENTRE   = 3.5; // Centre-to-centre distance between slots in Y
NUM_SLOTS        = 10;  // Number of slides to hold

// --- Calculated Variables ---
// Calculate total width occupied by slots and gaps to ensure symmetry
TOTAL_SLOT_WIDTH_SPAN = (NUM_SLOTS * SPACING_CENTRE) + SLOT_WIDTH_Y; 

// Offset from centerline for the first slot in Y direction
CENTER_OFFSET_Y  = (BLOCK_WIDTH_Y - TOTAL_SLOT_WIDTH_SPAN) / 2.0;

// --- Geometry Construction ---

difference() {
    // 1. Create the solid base block
    translate([0, 0, 0]) 
        cube([BLOCK_LENGTH_X, BLOCK_WIDTH_Y, BLOCK_HEIGHT_Z]);

    // 2. Cut the slots into the top face (Z = BLOCK_HEIGHT_Z)
    // Slots run along X. They are spaced in Y.
    
    for(i = [-(NUM_SLOTS-1)/2 : NUM_SLOTS/2 - 0.5]) { 
        // Calculate position of each slot center relative to block center
        
        // Determine the offset from global zero based on loop index i
        // If we want centers at y_center, y_center + spacing...
        // Let's calculate absolute Y positions for the slots centered in the block width
        
        current_slot_y = CENTER_OFFSET_Y + (i * SPACING_CENTRE);

        translate([0, current_slot_y, BLOCK_HEIGHT_Z - SLOT_DEPTH_Z]) 
            cube([SLOT_LENGTH_X, SLOT_WIDTH_Y, SLOT_DEPTH_Z]);
    }
}