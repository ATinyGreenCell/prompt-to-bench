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
slot_gap = 3.5;

// Calculate slot positions
// Total width of slots = N_slots * slot_w
// Total width of gaps = (N_slots - 1) * slot_gap
// Total occupied width = N_slots * slot_w + (N_slots - 1) * slot_gap
// Remaining width for margins = W_base - Total occupied width
// Margin per side = Remaining width / 2

total_occupied = (N_slots * slot_w) + ((N_slots - 1) * slot_gap);
margin = (W_base - total_occupied) / 2;

// Generate Y positions for the 10 slots
// Positions are centred on the origin in Y
// y_pos[i] = margin + (i - (N_slots-1)/2) * slot_gap
slot_positions = [for (i = [0 : N_slots - 1]) margin + (i - (N_slots - 1) / 2) * slot_gap];

difference() {
    // Main block
    translate([0, 0, 0]) cube([L_base, W_base, H_base]);
    
    // Cut slots
    for (y = slot_positions) {
        translate([0, y, 0]) cube([slot_len, slot_w, slot_deep]);
    }
}