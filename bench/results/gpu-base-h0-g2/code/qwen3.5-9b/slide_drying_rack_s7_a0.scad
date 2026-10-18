// Drying Rack for 10 Microscope Slides
// Base: 90 x 45 x 20 mm
// Slots: 10 parallel slots along X, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5mm centre-to-centre in Y, centred on block

$fn = 128;

// Base Dimensions
base_length = 90;
base_width = 45;
base_height = 20;

// Slide Dimensions (for reference)
slide_length = 75;
slide_width = 25;
slide_thickness = 1;

// Slot Dimensions
slot_length = 77;
slot_width = 1.6;
slot_depth = 10;

// Layout Dimensions
slot_spacing = 3.5; // Centre-to-centre in Y
num_slots = 10;

// Calculate Y position of the first slot centre
// Total width of slots = num_slots * slot_width
// Total width of gaps = (num_slots - 1) * slot_spacing
// Remaining space to distribute on both sides = (base_width - total_slots - total_gaps) / 2
total_slot_width = num_slots * slot_width;
total_gap_width = (num_slots - 1) * slot_spacing;
offset_from_edge = (base_width - total_slot_width - total_gap_width) / 2;
first_slot_y = offset_from_edge + slot_width / 2;

// Build the solid block
difference() {
    // Main Block
    cube([base_length, base_width, base_height], center = false);
    
    // Cut Slots
    // Slots run along X, so we cut from the top face downwards
    // We use a loop to generate 10 slots
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for current slot
        current_y = first_slot_y + i * slot_spacing;
        
        // Define the slot geometry
        // The slot is a rectangular prism cut out from the top
        // We extend slightly past the edges to ensure clean cuts
        slot_x = slot_length / 2;
        slot_y = slot_width / 2;
        slot_z = slot_depth;
        
        translate([0, current_y, base_height - slot_z]) {
            cube([slot_length, slot_width, slot_depth], center = false);
        }
    }
}