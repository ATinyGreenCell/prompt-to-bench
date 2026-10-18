// Drying Rack for Microscope Slides
// Base: 90 x 45 x 20 mm
// Slots: 10 parallel slots for 75x25mm slides
// Orientation: Rests on XY plane at Z=0, builds upward.

$fn = 128; // High resolution for smooth slot edges

// --- Base Dimensions ---
base_length_X = 90;
base_width_Y = 45;
base_height_Z = 20;

// --- Slot Dimensions ---
num_slots = 10;
slide_length = 75;
slide_width = 25;
slot_width = 1.6; // Width of the slot in Y
slot_depth = 10;  // Depth of the cut in Z
slot_spacing = 3.5; // Centre-to-centre distance in Y
slot_length = 77;  // Length of the slot in X

// --- Calculated Positions ---
// Group of slots centred on the block in X and Y

// Y Positioning:
// Total width occupied by slots and gaps
total_slot_group_width = (num_slots - 1) * slot_spacing + slot_width;
y_offset_from_edge = (base_width_Y - total_slot_group_width) / 2;
// Center of the first slot
y_first_center = y_offset_from_edge + (slot_width / 2);

// X Positioning:
// Slot is 77mm long, block is 90mm long. Centered.
x_start = (base_length_X - slot_length) / 2;

// --- Main Block ---
difference() {
    // 1. Create the solid base block
    // Position: x=0, y=0, z=0
    cube([base_length_X, base_width_Y, base_height_Z], center = false);
    
    // 2. Cut the 10 parallel slots
    // We define a cutting shape and translate it to the correct position.
    // The slot runs along X, so the cutting shape is a rectangle extruded along X.
    // We add a small overcut (0.1mm) to ensure clean separation as per rules.
    
    cut_overcut = 0.1;
    
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for this slot center
        y_pos = y_first_center + (i * slot_spacing);
        
        // Define the cutting shape dimensions
        // Length along X
        cut_len_X = slot_length + cut_overcut; 
        // Width along Y
        cut_w_Y = slot_width + cut_overcut;
        // Depth along Z (must extend from top down)
        cut_d_Z = slot_depth + cut_overcut;
        
        // Position the cutter:
        // X: Start at x_start
        // Y: Center at y_pos
        // Z: Start at (base_height_Z - cut_d_Z) to cut from top down
        translate([x_start, y_pos, base_height_Z - cut_d_Z]) {
            // Extrude along X axis
            cube([cut_len_X, cut_w_Y, cut_d_Z], center = false);
        }
    }
}