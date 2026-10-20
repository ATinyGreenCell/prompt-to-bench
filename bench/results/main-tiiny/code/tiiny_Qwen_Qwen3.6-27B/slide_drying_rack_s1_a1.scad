// Drying Rack for 10 Microscope Slides
// Dimensions measured with calipers

// Base block dimensions
base_length = 90;   // mm (X)
base_width = 45;    // mm (Y)
base_height = 20;   // mm (Z)

// Slot dimensions
slot_length = 77;   // mm (X)
slot_width = 1.6;   // mm (Y)
slot_depth = 10;    // mm (Z)

// Slot arrangement
num_slots = 10;
slot_spacing = 3.5; // mm centre-to-centre (Y)

// Rendering quality
$fn = 64;

// Calculate total width of the slot group
total_slot_group_width = (num_slots - 1) * slot_spacing;

// Calculate starting Y position to centre the group on the block
// The centre of the group is at Y=0.
// The first slot centre is at -total_slot_group_width/2
start_y = -total_slot_group_width / 2;

// Build the base block
difference() {
    // Main solid block
    translate([-base_length/2, -base_width/2, 0])
        cube([base_length, base_width, base_height]);

    // Cut out the slots
    for (i = [0 : num_slots - 1]) {
        y_pos = start_y + i * slot_spacing;
        
        // Slot cutter: extends slightly past the base in X and Z to ensure clean cut
        // Centered in X at 0, centered in Y at y_pos
        // Z starts from top (base_height) and goes down by slot_depth
        // We extend 0.01mm deeper to ensure no coplanar faces
        translate([-slot_length/2, y_pos - slot_width/2, base_height - slot_depth - 0.01])
            cube([slot_length, slot_width, slot_depth + 0.02]);
    }
}