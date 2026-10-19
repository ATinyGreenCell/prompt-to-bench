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
y_offset = ((num_slots - 1) * pitch) / 2;

difference() {
    // The main solid base block
    // Centered on X and Y, sitting on Z=0
    translate([-L/2, -W/2, 0]) {
        cube([L, W, H]);
    }

    // The slots
    for (i = [0 : num_slots - 1]) {
        // Calculate Y center for this specific slot
        slot_y_pos = (i * pitch) - y_offset;
        
        // To ensure the hole is exactly 77mm wide while avoiding coplanar faces:
        // We use the exact slot_L for the cube width.
        // We translate the cube so it is centered on the block's X axis.
        // We extend the cube in Z to ensure it cuts through the top face.
        translate([-slot_L/2, slot_y_pos - slot_W/2, H - slot_D + 0.01]) {
            cube([slot_L, slot_W, slot_D + 0.01]);
        }
    }
}