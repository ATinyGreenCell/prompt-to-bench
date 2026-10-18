// Drying rack for 10 microscope slides.
// Base: 90 x 45 x 20 mm.
// 10 slots: 77 x 1.6 x 10 mm, spaced 3.5 mm C-C in Y, centred on block.

$fn = 64;

// Base dimensions
L_base = 90;
W_base = 45;
H_base = 20;

// Slot dimensions
N_slots = 10;
slot_len = 77;
slot_w   = 1.6;
slot_deep = 10;

// Spacing: 3.5 mm centre-to-centre
slot_cc = 3.5;

// Calculate positions
// Total span of slots = (N_slots - 1) * slot_cc + slot_w
total_span = (N_slots - 1) * slot_cc + slot_w;
margin = (W_base - total_span) / 2;

// Generate Y positions for the 10 slots
// Positions are centred on the origin in Y
// y_pos[i] = margin + (i - (N_slots-1)/2) * slot_cc
slot_positions = [for (i = [0 : N_slots - 1]) margin + (i - (N_slots - 1) / 2) * slot_cc];

difference() {
    // Main block
    translate([0, 0, 0]) cube([L_base, W_base, H_base]);
    
    // Cut slots
    for (y = slot_positions) {
        translate([0, y, 0]) cube([slot_len, slot_w, slot_deep]);
    }
}