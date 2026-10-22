$fn = 128;

// --- Dimensions ---
// Base block dimensions
$base_length_X = 90;
$base_width_Y = 45;
$base_height_Z = 20;

// Slide dimensions (mm)
$slide_length = 75;
$slide_width = 25;
$slide_thickness = 1;

// Slot dimensions
$slot_length = 77;
$slot_width = 1.6;
$slot_depth = 10;

// Slot layout
$slot_count = 10;
$slot_spacing = 3.5; // centre-to-centre in Y
$group_centre_Y = 0; // Group of slots centred on block in Y

// --- Variables ---
// Calculate slot positions
// Total width of slots = slot_count * slot_width
// Total gap width = (slot_count - 1) * slot_spacing
// We need to center this group.
// The group of centers is at Y = group_centre_Y.
// Since we are using for loops with an offset, we can calculate the offset for the first slot.

// Calculate the offset for the first slot center to center the group
// The centers are at: y0, y0 + spacing, y0 + 2*spacing, ...
// The average of these centers should be 0.
// y0 + (slot_count - 1)/2 * spacing = 0
// y0 = - (slot_count - 1)/2 * spacing
$first_slot_offset = - (($slot_count - 1) / 2) * $slot_spacing;

// --- Build ---

difference() {
    
    // 1. Base Block
    // Rests on XY plane at z=0. Centred on origin.
    translate([0, 0, 0])
    cube([
        $base_length_X, 
        $base_width_Y, 
        $base_height_Z
    ]);

    // 2. Slots
    // Cut 10 parallel slots running along X.
    // Open at the top (Z direction).
    // Slots are 77mm long, 1.6mm wide, 10mm deep.
    // Spacing 3.5mm centre-to-centre in Y.
    // Group centred on block in X and Y.
    
    for (i = [0 : $slot_count - 1]) {
        // Calculate Y position for this slot
        $y_pos = $first_slot_offset + (i * $slot_spacing);
        
        // Slot geometry:
        // Length: 77 (along X)
        // Width: 1.6 (along Y)
        // Depth: 10 (along Z)
        // Position: Centred at (0, y_pos, 0) relative to the block face
        
        // Rule 5: Extend cutting shape slightly past faces to avoid coplanar faces
        // Extend 0.5mm in Z direction (depth)
        translate([0, $y_pos, 0])
        cube([
            $slot_length,
            $slot_width,
            $slot_depth + 0.5
        ]);
    }
}