// Drying Rack for 10 Microscope Slides
// Base dimensions
base_length = 90;   // X
base_width = 45;    // Y
base_height = 20;   // Z

// Slot dimensions
slot_length = 77;   // X
slot_width = 1.6;   // Y
slot_depth = 10;    // Z

// Slot arrangement
num_slots = 10;
slot_spacing = 3.5; // centre-to-centre in Y

// Calculate total width of the slot group
total_slot_group_width = (num_slots - 1) * slot_spacing;

// Starting Y position for the first slot (to centre the group)
start_y = -total_slot_group_width / 2;

$fn = 64;

// Base block
translate([-base_length/2, -base_width/2, 0])
    cube([base_length, base_width, base_height]);

// Cut out slots
for (i = [0 : num_slots-1]) {
    y_pos = start_y + i * slot_spacing;
    
    // Slot extends slightly past the base in X and Z to ensure clean cuts
    translate([-slot_length/2, y_pos, base_height])
        cube([slot_length + 0.02, slot_width, slot_depth + 0.02], center = true);
}