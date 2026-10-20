// Drying rack for 10 microscope slides
// Base block dimensions
BLOCK_X = 90;
BLOCK_Y = 45;
BLOCK_Z = 20;

// Slide dimensions
SLIDE_LENGTH = 75;
SLIDE_WIDTH = 25;
SLIDE_THICKNESS = 1;

// Slot dimensions
SLOT_LENGTH = 77;
SLOT_WIDTH = 1.6;
SLOT_DEPTH = 10;

// Slot spacing
SLOT_SPACING = 3.5;
NUM_SLOTS = 10;

// Calculate slot positions
// Slots are centred in X and Y
// Slot Y positions: centre of block in Y, spaced by SLOT_SPACING
// Total width of slot group = (NUM_SLOTS - 1) * SLOT_SPACING
slot_y_start = -((NUM_SLOTS - 1) * SLOT_SPACING) / 2;

// Slot X position: centred on block
slot_x_start = (BLOCK_X - SLOT_LENGTH) / 2;

// Slot Y position: centred on block (slot width is small, so slot_y is at block centre)
slot_y_centre = 0;

// Slot Z position: starts at top of block (BLOCK_Z) and goes down
slot_z_start = BLOCK_Z;

// Build the base block
difference() {
    // Base block
    cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = [false, false, false]);
    
    // Cut slots
    for (i = [0 : NUM_SLOTS - 1]) {
        slot_y_pos = slot_y_start + i * SLOT_SPACING;
        
        // Slot extends slightly past the block faces to ensure clean cuts
        translate([slot_x_start - 0.01, slot_y_pos - SLOT_WIDTH/2 - 0.01, slot_z_start - 0.01]) {
            cube([SLOT_LENGTH + 0.02, SLOT_WIDTH + 0.02, SLOT_DEPTH + 0.02]);
        }
    }
}