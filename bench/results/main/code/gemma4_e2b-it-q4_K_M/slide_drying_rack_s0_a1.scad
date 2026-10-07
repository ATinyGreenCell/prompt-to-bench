// Dimensions for the Drying Rack
// Base Block Dimensions
base_length = 90;  // Length of the base block along X axis (mm)
base_width = 45;    // Width of the base block along Y axis (mm)
base_height = 20;   // Height of the base block along Z axis (mm)

// Slide Slot Dimensions
num_slots = 10;     // Number of slots to create
slot_length = 77;   // Length of each slot along X axis (mm)
slot_width = 1.6;    // Width of each slot along Y axis (mm)
slot_depth = 10;     // Depth of the slot along Z axis (mm)
slot_spacing = 3.5;  // Center-to-center spacing between slots in Y direction (mm)

// Slot Positioning Calculations
// The slots are centered on the block in X and Y.

// Calculate the total required width for the slots and gaps:
// Total span occupied by slots and gaps along Y axis:
// Span = (num_slots - 1) * slot_spacing + slot_width
total_span = (num_slots - 1) * slot_spacing + slot_width;

// Center of the block in Y: base_width / 2 = 45 / 2 = 22.5
y_center = base_width / 2;

// Calculate the starting position for the first slot's center (relative to origin)
start_y = y_center - (total_span / 2);

slot_positions = [];
for (i = [0 : num_slots - 1]) {
    // Center of the i-th slot: start_y + i * slot_spacing + slot_width / 2
    pos = start_y + i * slot_spacing + (slot_width / 2);
    slot_positions = concat(slot_positions, [pos]);
}


// --- Main Model ---

module drying_rack() {
    // 1. Base Block (Cuboid)
    // The block rests on the XY plane at z=0.
    cube([base_length, base_width, base_height], center = true);

    // 2. Slots (Cutouts)
    for (i = [0 : num_slots - 1]) {
        slot_y = slot_positions[i];

        // Create the slot using a moving cube/box for extrusion along Z
        translate([0, slot_y, 0]) {
            // The slot runs along X (length=77), has width=1.6 (Y), and depth=10 (Z)
            // Since the block height is 20mm, a depth of 10mm fits within the block.
            cube([slot_length, slot_width, slot_depth], center = false);
        }
    }
}

drying_rack();