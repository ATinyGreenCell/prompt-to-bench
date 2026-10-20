// === Drying Rack for 10 Microscope Slides ===
// Units: millimetres

// Block dimensions
BLOCK_X = 90;
BLOCK_Y = 45;
BLOCK_Z = 20;

// Slot dimensions
SLOT_LENGTH_X = 77;    // along X
SLOT_WIDTH_Y = 1.6;    // along Y
SLOT_DEPTH_Z = 10;   // along Z (depth from top)

// Slot layout
NUM_SLOTS = 10;
SLOT_SPACING = 3.5;  // centre-to-centre in Y

// Derived: total width of slot group
SLOT_GROUP_WIDTH = (NUM_SLOTS - 1) * SLOT_SPACING;

// Derived: slot group centre offset from block centre in Y
// Block centre in Y is BLOCK_Y/2. Slots are centred on block.
SLOT_GROUP_HALF = SLOT_GROUP_WIDTH / 2;

// Derived: slot centre positions in Y (relative to block centre)
// Slot i (0..9) centre Y = -SLOT_GROUP_HALF + i * SLOT_SPACING

// Derived: slot centre in X (centred on block)
SLOT_CENTRE_X = 0;

// Derived: slot start/end in X
SLOT_START_X = SLOT_CENTRE_X - SLOT_LENGTH_X / 2;
SLOT_END_X = SLOT_CENTRE_X + SLOT_LENGTH_X / 2;

// Derived: slot half-widths
SLOT_HALF_X = SLOT_LENGTH_X / 2;
SLOT_HALF_Y = SLOT_WIDTH_Y / 2;

// Extra extension for clean boolean cuts (rule 5)
EXT = 0.05;

// $fn for round features (rule 6)
$fn = 64;

// === Build the base block ===
base = cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = [false, false, false]);

// === Cut the slots ===
slots = [];
for (i = [0 : NUM_SLOTS - 1]) {
    slot_y = -SLOT_GROUP_HALF + i * SLOT_SPACING;
    slots.push(
        translate([SLOT_CENTRE_X, slot_y, BLOCK_Z - SLOT_DEPTH_Z])
        cube([SLOT_LENGTH_X + 2 * EXT, SLOT_WIDTH_Y + 2 * EXT, SLOT_DEPTH_Z + 2 * EXT],
             center = [true, true, true])
    );
}

// === Final part: base minus all slots ===
part = difference() {
    base;
    for (s = slots) {
        s;
    }
};

// === Output ===
part;