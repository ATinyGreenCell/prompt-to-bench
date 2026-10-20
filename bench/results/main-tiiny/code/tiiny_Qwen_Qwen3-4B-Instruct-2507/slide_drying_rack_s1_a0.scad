// Dimensions in millimetres
$fn = 64;

// Base block dimensions
base_length = 90;        // X dimension
base_width = 45;         // Y dimension
base_height = 20;        // Z dimension

// Slot specifications
slot_count = 10;
slot_length = 77;        // along X
slot_width = 1.6;        // along Y
slot_depth = 10;         // along Z
slot_center_spacing = 3.5; // centre-to-centre in Y

// Calculate slot positions in Y (centered on the base)
slot_y_positions = [];
for (i = [0 : slot_count - 1]) {
    slot_y_positions.push_back(base_width / 2 - slot_center_spacing * i - slot_width / 2);
}

// Create the base block
base = cube([base_length, base_width, base_height]);

// Create the slots on the top face (Z = base_height)
// We cut from the top face down into the block, so we use difference
// Each slot is a rectangular prism cut from the top face
top_face_slot = translate([0, 0, base_height]) 
    cube([slot_length, slot_width, slot_depth]);

// Adjust the slot positions to be centered in X and Y
// The slots are centered in X (so symmetric about X=base_length/2)
// and centered in Y (so symmetric about Y=base_width/2)

// Create all slots using a for loop
for (i = [0 : slot_count - 1]) {
    y_offset = base_width / 2 - slot_center_spacing * i - slot_width / 2;
    slot = translate([base_length / 2 - slot_length / 2, y_offset, base_height - slot_depth]) 
        cube([slot_length, slot_width, slot_depth]);
    base = difference() {
        base;
        translate([0, 0, 0]) // dummy to avoid translation issues
        // We use difference to subtract each slot from the base
        // The slot is cut from the top face, so we place it at the top
        // and subtract it from the base
        // We must ensure the slot extends slightly beyond the face
        // to avoid coplanar issues
        base = difference() {
            base;
            translate([base_length / 2 - slot_length / 2, y_offset, base_height - slot_depth])
                cube([slot_length, slot_width, slot_depth + 0.1]); // extend slightly below the top
        };
    }
}

// Final base with slots
// We build the base and subtract each slot
// Start with the full base
final_rack = base;

// Now subtract each slot with a small extension to avoid coplanar faces
for (i = [0 : slot_count - 1]) {
    y_offset = base_width / 2 - slot_center_spacing * i - slot_width / 2;
    final_rack = difference() {
        final_rack;
        translate([base_length / 2 - slot_length / 2, y_offset, base_height - slot_depth])
            cube([slot_length, slot_width, slot_depth + 0.1]);
    };
}

// Final output
final_rack;