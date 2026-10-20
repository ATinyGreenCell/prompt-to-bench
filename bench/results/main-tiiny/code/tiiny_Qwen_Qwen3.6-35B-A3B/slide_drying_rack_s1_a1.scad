// Dimensions for the drying rack
base_length = 90;      // X dimension of the base block
base_width = 45;       // Y dimension of the base block
base_height = 20;      // Z dimension of the base block

// Slot dimensions
slot_length = 77;      // Length of the slot (X direction)
slot_width = 1.6;      // Width of the slot (Y direction)
slot_depth = 10;       // Depth of the slot (Z direction)

// Slot arrangement
num_slots = 10;        // Number of slots
slot_pitch = 3.5;      // Centre-to-centre distance between slots (Y direction)

// Safety margin for boolean operations to ensure clean cuts
cut_extend = 0.05;

$fn = 64;

// The base block rests on the XY plane (z=0) and builds upward.
// Centered in X and Y.
module base_block() {
    // Cube centered at (0,0, base_height/2) so it sits on z=0
    translate([0, 0, base_height / 2]) {
        cube([base_length, base_width, base_height], center = true);
    }
}

// Module to define a single slot cut
// y_center: The Y coordinate of the center of the slot
module slot_cut(y_center) {
    // Slot runs along X, centered at X=0
    // X range: -slot_length/2 to +slot_length/2
    // Extend slightly past the faces for clean boolean subtraction
    x_half = slot_length / 2 + cut_extend;
    
    // Slot width is along Y, centered at y_center
    // Y range: y_center - slot_width/2 to y_center + slot_width/2
    y_half = slot_width / 2 + cut_extend;
    
    // Slot depth is along Z.
    // Top of block is at Z = base_height.
    // Slot goes down slot_depth from the top.
    // So the cut goes from Z = base_height down to Z = base_height - slot_depth.
    // We extend slightly past the bottom of the slot (into the solid) and past the top (into the air)
    // to ensure the top face is cleanly open.
    z_top = base_height + cut_extend;
    z_bottom = base_height - slot_depth - cut_extend;
    
    // Calculate center Z of the cut volume
    z_center = (z_top + z_bottom) / 2;
    
    // Define the cutting volume
    // Size in X
    size_x = 2 * x_half;
    // Size in Y
    size_y = 2 * y_half;
    // Size in Z
    size_z = z_top - z_bottom;
    
    translate([0, y_center, z_center]) {
        cube([size_x, size_y, size_z], center = true);
    }
}

module drying_rack() {
    difference() {
        base_block();
        
        // Generate 10 slots
        // The slots are centred on the block in Y.
        // For an even number of slots (10), the centers are at:
        // +/- 0.5 * pitch, +/- 1.5 * pitch, ..., +/- 4.5 * pitch
        // Formula: y_i = (i - (num_slots - 1) / 2) * pitch
        // where i goes from 0 to num_slots - 1
        
        for (i = [0 : num_slots - 1]) {
            y_c = (i - (num_slots - 1) / 2) * slot_pitch;
            slot_cut(y_c);
        }
    }
}

drying_rack();