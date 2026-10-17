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
    // Slots run along X, so we cut from the top face (Z = base_height) down to Z = base_height - slot_depth
    // We use a loop to generate the 10 slots
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for current slot
        y_pos = first_slot_y + (i * slot_spacing);
        
        // Define the slot geometry
        // The slot is a rectangular prism cut into the top
        translate([
            0,              // X position (runs full length, centred)
            y_pos,          // Y position
            base_height     // Z position (start at top surface)
        ]) {
            // Cut a block that is slightly larger than the slot to ensure clean cut
            // Extending 0.1mm past the faces as per rules
            // Note: The nested difference() was removed to allow this cube to actually cut the main block
            cube([
                slot_length + 0.1,
                slot_width + 0.1,
                slot_depth + 0.1
            ]);
        }
    }
}