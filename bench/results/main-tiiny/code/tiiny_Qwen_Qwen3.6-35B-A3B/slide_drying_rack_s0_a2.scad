// --- Dimensions ---
// Microscope slide dimensions (for reference, not used in geometry)
slide_length = 75;    // mm (X direction of slide)
slide_width  = 25;    // mm (Y direction of slide)
slide_thick  = 1;     // mm (Z direction of slide)

// Base block dimensions
base_x = 90;          // mm (Length, X axis)
base_y = 45;          // mm (Width, Y axis)
base_z = 20;          // mm (Height, Z axis)

// Slot dimensions
slot_length = 77;     // mm (Runs along X)
slot_width  = 1.6;    // mm (Width in Y)
slot_depth  = 10;     // mm (Depth in Z, from top face)

// Slot layout
num_slots = 10;
slot_pitch = 3.5;     // mm (Centre-to-centre spacing in Y)

// --- Calculations ---
// The slots are centred on the block in X and Y.
// Y-centre of the slot group is 0.
// X-centre of the slot group is 0.

// --- Model ---
$fn = 64;

module drying_rack() {
    // 1. Create the solid base block
    // Resting on XY plane (z=0), centred in X and Y
    base = translate([0, 0, base_z / 2]) {
        cube([base_x, base_y, base_z], center = true);
    }

    // 2. Create the cutting shapes for the slots
    // Slots run along X, are slot_width wide in Y, and slot_depth deep in Z.
    // They are open at the top (Z = base_z).
    // We extend the cut slightly past the bottom face to ensure clean boolean operations.
    cut_depth = slot_depth + 0.01; 
    
    // Generate the grid of slot cuts
    slots = for (i = [0 : num_slots - 1]) {
        // Calculate Y position for each slot centre
        // For 10 slots, indices 0..9.
        // Centres are at: -4.5*pitch, -3.5*pitch, ..., +4.5*pitch
        y_pos = (i - (num_slots - 1) / 2) * slot_pitch;
        
        // X position is centred (0)
        x_pos = 0;
        
        // The slot is a rectangular prism.
        // It starts at the top surface (Z = base_z) and goes down.
        // To make the boolean difference work cleanly, we define the cut volume
        // extending from Z = base_z down to Z = base_z - cut_depth.
        // We centre the cube at Z = base_z - cut_depth/2 so it spans the correct depth.
        translate([x_pos, y_pos, base_z - cut_depth / 2]) {
            cube([slot_length, slot_width, cut_depth], center = true);
        }
    };

    // 3. Subtract the slots from the base
    difference() {
        base;
        for (slot_cut = slots) {
            slot_cut;
        }
    }
}

drying_rack();