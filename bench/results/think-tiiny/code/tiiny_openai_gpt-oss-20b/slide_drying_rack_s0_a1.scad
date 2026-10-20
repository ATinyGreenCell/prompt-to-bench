$fn = 64; // resolution for curved shapes (not used here but kept for consistency)

// Base block dimensions (X, Y, Z)
block_L = 90;   // length in X
block_W = 45;   // width in Y
block_H = 20;   // height in Z

// Slot dimensions (X, Y, Z)
slot_L = 77;      // length along X
slot_W = 1.6;     // width along Y
slot_H = 10;      // depth along Z (cut into block)
slot_H_extra = 0.01; // extra depth to avoid coplanarity with block top face

// Slot spacing
slot_spacing = 3.5;   // centre‑to‑centre distance in Y
num_slots = 10;       // total number of slots

// Compute the X start coordinate of the slot shape so that its centre is at X = block_L/2
slot_X_start = block_L/2 - slot_L/2; // 45 - 38.5 = 6.5

// Compute the Y start coordinate of the first slot so that the group of slots is centred in Y
slot_Y_start = block_W/2 - ((num_slots-1)/2)*slot_spacing; // 22.5 - 4.5*3.5 = 6.75

// Build the drying rack
difference() {
    // Solid base block
    cube([block_L, block_W, block_H], center=false);

    // Subtract the 10 slots
    for (i = [0 : num_slots-1]) {
        translate([slot_X_start, slot_Y_start + i*slot_spacing, block_H - slot_H]) 
        cube([slot_L, slot_W, slot_H + slot_H_extra], center=false);
    }
}