// --- Dimensions ---
// Microscope slide dimensions
slide_length = 75;    // mm (X direction of slide)
slide_width  = 25;    // mm (Y direction of slide)
slide_thick  = 1;     // mm (Z direction of slide)

// Base block dimensions
base_x = 90;          // mm (Length)
base_y = 45;          // mm (Width)
base_z = 20;          // mm (Height)

// Slot dimensions
slot_length = 77;     // mm (Runs along X)
slot_width  = 1.6;    // mm (Width in Y)
slot_depth  = 10;     // mm (Depth in Z)

// Slot layout
num_slots = 10;
slot_pitch = 3.5;     // mm (Centre-to-centre spacing in Y)

// --- Calculations ---
// Total width of the slot group
total_slot_width = (num_slots - 1) * slot_pitch;

// Y-centre of the slot group relative to the block centre (0,0)
// The group is centred on the block in Y.
slot_group_y_offset = 0;

// X-centre of the slot group relative to the block centre (0,0)
// The group is centred on the block in X.
slot_group_x_offset = 0;

// Slot positions
// We need to place 10 slots. The centres are spaced by 3.5mm.
// The middle of the group is at Y=0.
// For 10 slots (even number), the centres are at:
// +/- 1.75, +/- 5.25, +/- 8.75, ...
// Formula: y_i = (i - (num_slots-1)/2) * pitch, for i in 0..num_slots-1
// Let's verify:
// i=0: y = -4.5 * 3.5 = -15.75
// i=9: y = 4.5 * 3.5 = 15.75
// This centres the group around 0.

// --- Model ---
$fn = 64;

module base_block() {
    // Base block resting on XY plane, centred at origin
    translate([0, 0, base_z / 2]) {
        cube([base_x, base_y, base_z], center = true);
    }
}

module slot(x_offset, y_offset) {
    // Slot runs along X, is slot_width wide in Y, and slot_depth deep in Z.
    // Open at the top (Z = base_z).
    // We cut into the block from the top.
    // The slot is centred at (x_offset, y_offset) in XY.
    // Depth is slot_depth, so it goes from Z = base_z down to Z = base_z - slot_depth.
    // To ensure clean cuts, we extend slightly past the faces.
    
    // X extent: centred at x_offset, length slot_length
    // Y extent: centred at y_offset, width slot_width
    // Z extent: from base_z to base_z - slot_depth - 0.01 (to ensure cutting)
    
    translate([x_offset, y_offset, base_z - 0.01]) {
        // The slot is a rectangular prism cut into the block.
        // It is open at the top, so we don't need to worry about the top face.
        // We extend slightly in Z to ensure the bottom face is cut cleanly.
        cube([slot_length, slot_width, slot_depth + 0.01], center = true);
    }
}

module drying_rack() {
    difference() {
        base_block();
        
        for (i = [0 : num_slots - 1]) {
            // Calculate Y position for each slot
            y_pos = (i - (num_slots - 1) / 2) * slot_pitch;
            
            // X position is centred (0)
            x_pos = 0;
            
            slot(x_pos, y_pos);
        }
    }
}

drying_rack();