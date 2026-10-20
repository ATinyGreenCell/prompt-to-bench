$fn = 128;

// --- Dimensions ---
// Base block dimensions
base_length_X = 90;
base_width_Y = 45;
base_height_Z = 20;

// Slide dimensions (mm)
slide_length = 75;
slide_width = 25;
slide_thickness = 1;

// Slot dimensions
slot_length = 77;
slot_width = 1.6;
slot_depth = 10;

// Slot spacing and positioning
slot_spacing = 3.5; // Centre-to-centre in Y
num_slots = 10;

// --- Calculation ---
// Calculate the Y position of the first slot to center the group
// Total width occupied by slots = num_slots * slot_width
// Total spacing between slots = (num_slots - 1) * slot_spacing
// Total group width = (num_slots * slot_width) + ((num_slots - 1) * slot_spacing)
// Offset from center = (Total group width / 2)
// First slot center Y = Offset - (Total group width / 2) + (slot_width / 2)
// Simplified: First slot center Y = (base_width_Y / 2) - (Total group width / 2)

total_group_width = (num_slots * slot_width) + ((num_slots - 1) * slot_spacing);
first_slot_center_Y = (base_width_Y / 2) - (total_group_width / 2);

// --- Build ---

difference() {
    // 1. Create the solid base block
    // Centered on origin, resting on Z=0
    translate([0, 0, 0])
        cube([base_length_X, base_width_Y, base_height_Z]);

    // 2. Cut the 10 parallel slots
    // Slots run along X, so they are extruded in X direction.
    // We use a for loop to position them along Y.
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for current slot
        // i=0 is the first slot, i=num_slots-1 is the last
        current_slot_Y = first_slot_center_Y + (i * slot_spacing);
        
        // Define the cutting shape
        // The slot is 77mm long (X), 1.6mm wide (Y), 10mm deep (Z)
        // We extend slightly past the faces (0.1mm) to ensure clean cut
        cut_length = slot_length + 0.1;
        cut_width = slot_width + 0.1;
        cut_depth = slot_depth + 0.1;
        
        translate([0, current_slot_Y, 0])
            cube([cut_length, cut_width, cut_depth]);
    }
}