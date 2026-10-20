// Dimensions (mm)
base_length = 90;      // X dimension of the base block
base_width  = 45;      // Y dimension of the base block
base_height = 20;      // Z dimension of the base block (bottom at Z=0)

slot_length = 77;      // Length of each slot along X
slot_width  = 1.6;    // Width of each slot along Y
slot_depth  = 10;      // Depth of each slot into the block (from top surface)
slot_extra = 0.2;      // Extra material removed beyond the top face (to avoid coplanar faces)

slot_spacing = 3.5;    // Centre‑to‑centre spacing of slots in Y
slot_count   = 10;    // Number of slots

$fn = 64; // resolution for any curved shapes (not used here)

// Base block, rests on XY plane at Z=0 and centred in X/Y
module base_block() {
    translate([-base_length/2, -base_width/2, 0])
        cube([base_length, base_width, base_height]);
}

// Cutter for a single slot (open at the top)
module slot_cutter(ypos) {
    // Position the cutter so its bottom starts at (base_height - slot_depth)
    // and its top extends slot_extra beyond the top surface.
    translate([
        -slot_length/2,
        ypos - slot_width/2,
        base_height - slot_depth
    ])
        cube([slot_length, slot_width, slot_depth + slot_extra]); // default center = false
}

// Assemble all slot cutters
module all_slots() {
    union() {
        for (i = [0:slot_count-1])
            slot_cutter((i - (slot_count - 1)/2) * slot_spacing);
    }
}

// Final part: base block with slots cut out
difference() {
    base_block();
    all_slots();
}