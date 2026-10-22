$fn = 64;

// Dimensions
slide_length = 75;     // mm
slide_width = 25;      // mm
slide_thickness = 1;    // mm

base_length = 90;      // mm (X)
base_width = 45;       // mm (Y)
base_height = 20;        // mm (Z)

slot_length = 77;       // mm (along X)
slot_width = 1.6;      // mm (Y direction)
slot_depth = 10;        // mm (into Z)

num_slots = 10;
center_to_center_spacing = 3.5; // mm (Y direction)

// Adjust for correct print orientation: part must rest on XY plane at z = 0
// The current model is centered at z = 0, but we want the base to sit flat on the bed at z = 0
// So we shift the entire model down by base_height / 2 = 10 mm

// Recalculate slot positions: centre the array in X and Y
total_y_span = (num_slots - 1) * center_to_center_spacing;
y_offset = (base_width - total_y_span) / 2; // offset to centre

// X is centred: slot_length is 77mm, base is 90mm, so 13mm overhang on each side
x_offset = (base_length - slot_length) / 2;

// Create base block, now shifted so that its bottom is at z = 0
translate([0, 0, -base_height / 2]) {
    cube([base_length, base_width, base_height], center = false);
}

// Create and position slots using difference
// Each slot is a rectangular prism cut into the top face, from z = 0 to z = slot_depth
// The slot must be fully within the base and open at the top (z = 0)
// We use a negative offset to ensure the slot is cut properly without coplanar faces

for (i = [0 : num_slots - 1]) {
    y_pos = y_offset + i * center_to_center_spacing;
    translate([0, y_pos, -base_height / 2]) {
        difference() {
            // Full rectangular prism to remove from base: from z = -base_height/2 to z = -base_height/2 + base_height
            // But we only want to cut from z = 0 (top) down to z = -10 (slot_depth)
            // So we define a cutter that extends 0.01 mm below the base to ensure clean cut
            cube([slot_length, slot_width, base_height + 0.01], center = false);
            // Subtract a slightly larger box to ensure no coplanar faces
            translate([0, 0, -0.01]) cube([slot_length, slot_width, base_height + 0.01], center = false);
        }
    }
}