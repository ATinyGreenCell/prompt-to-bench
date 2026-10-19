// Microscope Slide Drying Rack
// Designed for 10 slides (75x25x1mm) standing upright on long edge.

// Block Dimensions
L = 90;             // Length (X)
W = 45;             // Width (Y)
H = 20;             // Height (Z)

// Slot Dimensions
slot_L = 77;        // Slot length (X)
slot_W = 1.6;       // Slot width (Y)
slot_D = 10;        // Slot depth (Z)
num_slots = 10;     // Number of slots
pitch = 3.5;        // Center-to-center spacing (Y)

$fn = 64;

// Calculate the starting Y position to center the group of slots
// The total width occupied by centers is (num_slots - 1) * pitch
// We center this group on the block's Y axis.
y_offset = ((num_slots - 1) * pitch) / 2;

difference() {
    // The main solid base block
    translate([-L/2, -W/2, 0]) {
        cube([L, W, H]);
    }

    // The slots
    // We iterate from 0 to num_slots-1 and calculate the Y position
    for (i = [0 : num_slots - 1]) {
        // Calculate Y center for this specific slot
        // We subtract y_offset to shift the whole group to the center
        slot_y_pos = (i * pitch) - y_offset;
        
        // We translate the slot so it is centered on the X axis
        // and positioned at the calculated Y position.
        // The slot is "open at the top", so we subtract it from the top face.
        // To ensure a clean cut, we extend the slot slightly in Z and X.
        translate([-slot_L/2 - 1, slot_y_pos - slot_W/2, H - slot_D + 0.01]) {
            cube([slot_L + 2, slot_W, slot_D]);
        }
    }
}