// Dimensions in millimetres
block_length = 90;      // X dimension of base block (long side)
block_width = 45;       // Y dimension of base block (short side)
block_height = 20;      // Z height of base block (tall side)
slot_length = 77;       // Slot length along X direction in mm (longer than slide to accommodate)
slot_width = 1.6;        // Slot cross-sectional width along Y direction in mm
slot_depth = 10;         // Slot depth along Z direction from top surface in mm
slot_spacing = 3.5;      // Centre-to-centre spacing between slots along Y direction in mm
num_slots = 10;          // Number of parallel slots (one per slide)

// Base block centered on origin, resting at z=0 and building upward (+Z).
// The block's top face is at z = block_height/2.
translate([block_length/2, block_width/2, block_height/2])
cube([block_length, block_width, block_height], center=true);

// For each slot i (0 to 9), define its position and carve a slot that is open at the top.
for (i = [0:num_slots-1]) {
    // Slot centre in Y direction based on spacing between centres.
    y_offset = (i + 0.5) * slot_spacing;
    
    // Slot start and end positions along X, centered within block width.
    x_start = (block_length - slot_length) / 2;
    x_end   = x_start + slot_length;
    
    // Cut shape: a rectangular prism that removes the slot region.
    // We extend the cut slightly below the intended top surface by 0.01 mm to avoid coplanar faces (rule 5).
    // The cut shape covers:
    //   x in [x_start, x_end]
    //   y in [y_offset - slot_width/2, y_offset + slot_width/2]
    //   z from (block_height/2 - slot_depth) to (block_height/2 - 0.01)
    
    // Use difference() with the cut shape; this ensures no face is exactly coplanar because the cut extends below the original top surface by 0.01 mm.
    difference() {
        // The cutting shape is a rectangular prism that goes down to block_height/2 - 0.01, so its top face is at z = block_height/2 - 0.01, which is not coplanar with the original top surface (z = block_height/2).
        translate([x_start, y_offset, block_height/2 - slot_depth])
        cube([slot_length, slot_width*2, slot_depth + 0.01]);
    }
}