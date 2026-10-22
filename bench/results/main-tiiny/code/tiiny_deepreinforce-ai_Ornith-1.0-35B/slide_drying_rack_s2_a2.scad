// Drying rack for 10 microscope slides
// Base block: 90 x 45 x 20 mm
// 10 slots: 77 mm long (X), 1.6 mm wide (Y), 10 mm deep, 3.5 mm pitch

// Base block dimensions
BLOCK_X = 90;
BLOCK_Y = 45;
BLOCK_Z = 20;

// Slot dimensions
SLOT_LENGTH = 77;
SLOT_WIDTH = 1.6;
SLOT_DEPTH = 10;

// Slot spacing
SLOT_PITCH = 3.5;
NUM_SLOTS = 10;

// Calculate slot group width and offset
SLOT_GROUP_WIDTH = (NUM_SLOTS - 1) * SLOT_PITCH;
SLOT_Y_OFFSET = SLOT_GROUP_WIDTH / 2;

// Slot X offset to centre the 77 mm slot in the 90 mm block
SLOT_X_OFFSET = (BLOCK_X - SLOT_LENGTH) / 2;

// Slot Y positions (centred on block)
SLOT_Y_START = -SLOT_Y_OFFSET;

// Cutting shape extension to avoid coplanar faces
EXTEND = 0.5;

module base_block() {
    // Centre the block on the origin in X and Y
    translate([-BLOCK_X / 2, -BLOCK_Y / 2, 0]) {
        cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
    }
}

module slot_cut(slot_y_pos) {
    // Slot extends slightly past the top face (z=20) and bottom of cut (z=10)
    // Slot is centred in X, positioned at specific Y
    translate([
        SLOT_X_OFFSET - EXTEND,
        slot_y_pos - SLOT_WIDTH / 2 - EXTEND,
        -EXTEND
    ]) {
        cube([
            SLOT_LENGTH + 2 * EXTEND,
            SLOT_WIDTH + 2 * EXTEND,
            SLOT_DEPTH + BLOCK_Z + 2 * EXTEND
        ], center = false);
    }
}

// Build the rack: base block with slots cut out
difference() {
    base_block();
    
    for (i = [0 : NUM_SLOTS - 1]) {
        slot_y = SLOT_Y_START + i * SLOT_PITCH;
        slot_cut(slot_y);
    }
}