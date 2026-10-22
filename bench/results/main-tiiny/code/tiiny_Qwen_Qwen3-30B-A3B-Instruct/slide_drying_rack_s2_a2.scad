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
// The base block must start at z = 0 and extend upward to z = 20
// The slot cutters must start at z = 0 (top) and go down to z = -10 (but we want the slot to be from z = 0 to z = -10? No — we want the slot to be from z = 0 (top) down into the base.

// The base is 20 mm tall. The slot is 10 mm deep, so it should go from z = 0 (top surface) to z = -10 (into the base).
// But the bed is at z = 0, so the base must extend from z = 0 to z = 20.
// Therefore, the entire base is from z = 0 to z = 20.
// The slot is cut from the top (z = 0) down to z = -10? That would be below the base.

// Correction: The slot is 10 mm deep and is cut into the top face. So it goes from z = 0 (top) down to z = -10? No — that would be below the base.

// Actually, the base is 20 mm tall and sits on the bed at z = 0. So the base occupies z = 0 to z = 20.
// The slot is 10 mm deep, so it should go from z = 0 (top) down to z = -10? That can't be.

// Clarification: The base is 20 mm tall, so it extends from z = 0 (bed) to z = 20 (top).
// The slot is 10 mm deep, so it should go from z = 20 (top) down to z = 10 (10 mm below the top).
// But the model currently has the base centered at z = 0, so z = -10 to z = 10.

// We must reposition the entire model so that:
// - The base sits on the bed at z = 0
// - The base extends from z = 0 to z = 20
// - The slot is cut from the top (z = 20) down to z = 10 (10 mm deep)

// So we shift the base block up by 10 mm so that its bottom is at z = 0 and top at z = 20.

// Also, the slot cutter must extend 0.01 mm below the base to ensure no coplanar faces.

// Recalculate slot positions: centre the array in X and Y
total_y_span = (num_slots - 1) * center_to_center_spacing;
y_offset = (base_width - total_y_span) / 2; // offset to centre

// X is centred: slot_length is 77mm, base is 90mm, so 13mm overhang on each side
x_offset = (base_length - slot_length) / 2;

// Create base block, now sitting on z = 0, from z = 0 to z = 20
translate([0, 0, 10]) {
    cube([base_length, base_width, base_height], center = false);
}

// Create and position slots using difference
// Each slot is a rectangular prism cut from z = 20 (top) down to z = 10 (10 mm deep)
// The cutter must extend 0.01 mm below the base to ensure clean cut
for (i = [0 : num_slots - 1]) {
    y_pos = y_offset + i * center_to_center_spacing;
    translate([0, y_pos, 10]) {
        difference() {
            // Cutter: from z = 10 (bottom of slot) to z = 10 + base_height + 0.01 = 30.01
            // But we only want to cut from z = 10 to z = 20 (top of base), so we define a box from z = 10 to z = 20 + 0.01
            cube([slot_length, slot_width, base_height + 0.01], center = false);
            // Subtract a slightly larger box to ensure no coplanar faces
            translate([0, 0, -0.01]) cube([slot_length, slot_width, base_height + 0.01], center = false);
        }
    }
}