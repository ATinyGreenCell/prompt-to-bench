// Drying rack for 10 microscope slides
// Units: millimetres

// Base block dimensions
base_length = 90;      // X dimension
base_width = 45;        // Y dimension
base_height = 20;       // Z dimension

// Slide dimensions (for reference)
slide_length = 75;
slide_width = 25;
slide_thickness = 1;

// Slot dimensions
slot_length = 77;      // X dimension
slot_width = 1.6;      // Y dimension
slot_depth = 10;     // Z dimension (depth from top)

// Slot placement
num_slots = 10;
slot_spacing = 3.5;    // Centre-to-centre spacing in Y

// Calculate total width of slot group
total_slot_width = (num_slots - 1) * slot_spacing;

// Calculate offset to centre the slots on the base
slot_offset_y = (base_width - total_slot_width) / 2;

// Calculate X offset to centre the slots on the base
slot_offset_x = (base_length - slot_length) / 2;

// Base block
base = cube([base_length, base_width, base_height], center = true);

// Create the slots
for (i = [0 : num_slots - 1]) {
    // Calculate Y position for each slot
    slot_y = slot_offset_y + i * slot_spacing;
    
    // Create a slot cutter
    // Extends 0.01mm past the base faces to ensure clean cuts
    // The cutter is positioned so its top is at the base top (z=10) and extends down
    // Base center is at z=0, top is at z=10. We want to cut from z=10 down to z=0.
    // So the cutter top should be at z=10, and height should be 10.01 to go slightly past.
    slot_cutter = translate([slot_offset_x, slot_y, 10 - 0.01])
                  * cube([slot_length, slot_width, slot_depth + 0.02], center = false);
    
    base = difference() {
        base;
        slot_cutter;
    }
}

// Render the part
base;