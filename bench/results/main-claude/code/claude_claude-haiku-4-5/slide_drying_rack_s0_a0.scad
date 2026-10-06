// Microscope slide drying rack

// Base block dimensions
base_length = 90;      // X dimension of base block (mm)
base_width = 45;       // Y dimension of base block (mm)
base_height = 20;      // Z dimension of base block (mm)

// Slot dimensions
slot_length = 77;      // Length of each slot along X (mm)
slot_width = 1.6;      // Width of each slot in Y direction (mm)
slot_depth = 10;       // Depth of each slot in Z direction (mm)

// Slot layout
num_slots = 10;        // Number of slots
slot_spacing = 3.5;    // Center-to-center spacing between slots in Y (mm)

// Derived dimensions
slot_group_span = (num_slots - 1) * slot_spacing;  // Total span of slot group in Y (31.5 mm)

$fn = 64;

difference() {
    // Create base block (centered at origin in X and Y, from z=0 to z=20)
    translate([0, 0, base_height/2]) {
        cube([base_length, base_width, base_height], center = true);
    }
    
    // Cut 10 parallel slots
    for (i = [0 : num_slots - 1]) {
        // Y position of current slot (centered in Y)
        slot_y = -slot_group_span / 2 + i * slot_spacing;
        
        // Remove slot with a cube that extends slightly past the boundaries
        translate([0, slot_y, base_height - slot_depth/2]) {
            cube([slot_length + 1, slot_width + 0.02, slot_depth + 1], center = true);
        }
    }
}