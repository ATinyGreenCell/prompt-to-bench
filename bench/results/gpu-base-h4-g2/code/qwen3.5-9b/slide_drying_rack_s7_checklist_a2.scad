// Microscope slide drying rack - solid base with 10 parallel slots for standing slides.

// Base dimensions
L_base = 90;
W_base = 45;
H_base = 20;

// Slide dimensions
slide_w = 25;
slide_h = 75;
slide_t = 1;

// Slot dimensions
slot_len = 77;
slot_w   = 1.6;
slot_d   = 10;

// Spacing and positioning
slot_c2c = 3.5;
n_slots  = 10;

// Derived positions
// Slots are centred in Y on the block
y_offset = (W_base - (n_slots - 1) * slot_c2c) / 2;

// Slots are centred in X on the block
x_offset = (L_base - slot_len) / 2;

$fn = 64;

difference() {
    // Main solid block
    translate([0, 0, 0]) cube([L_base, W_base, H_base]);

    // Cut 10 slots running along X
    // Slots are 10mm deep and open at the top, so they are cut from the top face (z=20) down to z=10.
    for (i = [0 : n_slots - 1]) {
        // Calculate Y position for this slot
        y_pos = y_offset + i * slot_c2c;
        
        // Slot geometry: runs along X, width in Y, depth in Z
        // Position Z at the top of the block (H_base)
        translate([x_offset, y_pos, H_base - slot_d]) {
            // Cut a rectangular prism for the slot
            // Length = slot_len, Width = slot_w, Depth = slot_d
            cube([slot_len, slot_w, slot_d]);
        }
    }
}