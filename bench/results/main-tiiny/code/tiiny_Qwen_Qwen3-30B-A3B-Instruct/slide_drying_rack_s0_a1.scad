$fn = 64;

// Dimensions
slide_length = 75;     // mm (length of slide)
slide_width = 25;      // mm (width of slide)
slide_thickness = 1;    // mm (thickness of slide)

base_length = 90;       // mm (X direction)
base_width = 45;         // mm (Y direction)
base_height = 20;        // mm (Z direction)

slot_length = 77;      // mm (along X)
slot_width = 1.6;      // mm (in Y direction)
slot_depth = 10;      // mm (into Z)

num_slots = 10;
center_to_center_spacing = 3.5; // mm (Y direction)

// Center of base
center_x = base_length / 2;
center_y = base_width / 2;

// Calculate Y positions of slot centers
// Total span of centers: (num_slots - 1) * spacing
offset_y = (num_slots - 1) * center_to_center_spacing / 2;

// Build the base
base = cube([base_length, base_width, base_height], center = true);

// Create the slots using difference
// We'll subtract a series of rectangular extrusions from the top face
// Each slot is a rectangular prism: length along X, width in Y, depth in Z
// But we need to offset each slot in Y direction

slots = difference() {
    base;
    for (i = [0 : num_slots - 1]) {
        // Y position of this slot's center
        y_pos = center_y - offset_y + i * center_to_center_spacing;
        
        // Define the slot: centered on its Y position, and centered in X
        // The slot is 77 mm long (X), 1.6 mm wide (Y), 10 mm deep (Z)
        // We extend slightly beyond the base to ensure clean cut
        translate([center_x - slot_length / 2, y_pos - slot_width / 2, -0.1])
            cube([slot_length + 0.1, slot_width + 0.1, slot_depth + 0.2], center = false);
    }
};

// Output the final model
slots;