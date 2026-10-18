// Microscope slide drying rack - solid base with 10 parallel slots for standing slides.

// Base dimensions
L_base = 90;
W_base = 45;
H_base = 20;

// Slide dimensions (standard 75x25x1 mm)
slide_len = 75;
slide_w   = 25;
slide_thk = 1;

// Slot dimensions
slot_len = 77;
slot_w   = 1.6;
slot_deep = 10;

// Spacing and positioning
slot_spacing = 3.5;
num_slots = 10;

$fn = 64;

difference() {
    // 1. The solid base block
    // Centre it in X and Y, sit it on Z=0
    translate([-L_base / 2, -W_base / 2, 0]) 
        cube([L_base, W_base, H_base]);

    // 2. Cut the 10 slots
    // Slots run along X, so they are long in X and narrow in Y.
    // They are cut into the top face, so they go down from Z = H_base.
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for this slot.
        // For a symmetric array centred at 0:
        // Position = (i - (num_slots - 1) / 2) * slot_spacing
        // Example i=0: (0 - 4.5) * 3.5 = -15.75
        // Example i=9: (9 - 4.5) * 3.5 = 15.75
        // Total span = 31.5, half span = 15.75. Correct.
        y_pos = (i - (num_slots - 1) / 2) * slot_spacing;
        
        // Slot geometry:
        // Length along X: slot_len
        // Width along Y: slot_w
        // Depth along Z: slot_deep
        
        // To cut a slot, we extrude a rectangle along Z downwards.
        // We extend slightly past the bottom to ensure clean cut.
        
        translate([
            -slot_len / 2,          // Centre in X
            y_pos,                  // Position in Y
            H_base - slot_deep      // Start at top of slot depth
        ]) {
            // Extrude a rectangle downwards (negative Z)
            translate([0, 0, -slot_deep - 0.1]) 
                cube([slot_len, slot_w, slot_deep + 0.1]);
        }
    }
}