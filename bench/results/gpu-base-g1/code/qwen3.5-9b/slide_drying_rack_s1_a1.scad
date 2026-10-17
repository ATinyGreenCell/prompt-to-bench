// Drying Rack for 10 Microscope Slides
// Base: 90 x 45 x 20 mm
// Slots: 10 parallel slots along X, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5mm centre-to-centre in Y

$fn = 128;

// Base Dimensions
base_length = 90;   // X
base_width = 45;    // Y
base_height = 20;   // Z

// Slot Dimensions
num_slots = 10;
slot_length = 77;   // X (runs along length)
slot_width = 1.6;   // Y
slot_depth = 10;    // Z

// Spacing
slot_spacing = 3.5; // Centre-to-centre in Y

// Calculation for Y positioning
// The group of slot centers must be centered on the block (Y=0).
// The distance from the center of the block to the center of the first slot is:
// (base_width - (num_slots * slot_width)) / 2 + (slot_width / 2)
// However, it is easier to calculate the position of the i-th slot directly.
// The centers are spaced by slot_spacing.
// The center of the first slot (i=0) is at: - (num_slots - 1) * slot_spacing / 2
// The center of the i-th slot is: i * slot_spacing + center_of_first_slot

// Main Block
difference() {
    // 1. The Solid Base
    // Centered at origin: X from -45 to 45, Y from -22.5 to 22.5, Z from -10 to 10
    cube([base_length, base_width, base_height], center = true);
    
    // 2. The Slots (Cutting shapes)
    // We cut 10 slots. Each slot is a rectangular prism.
    // Dimensions: length X, width Y, depth Z.
    // The slot is open at the top. The block top is at Z=10.
    // The slot goes from Z=10 down to Z=0 (10mm deep).
    // We extend the cutting shape slightly below Z=0 (to Z=-0.1) to ensure clean removal.
    
    // Calculate the Y offset for the first slot to center the group
    first_slot_y = -((num_slots - 1) * slot_spacing) / 2;
    
    for (i = [0 : num_slots - 1]) {
        y_pos = first_slot_y + (i * slot_spacing);
        
        translate([0, y_pos, 10]) {
            // Slot dimensions:
            // X: 77mm
            // Y: 1.6mm
            // Z: 10mm deep (from Z=10 down to Z=0)
            // We add 0.1mm extension below Z=0 for clean cutting
            cube([slot_length, slot_width, slot_depth + 0.1], center = [0, 0, -slot_depth/2]);
        }
    }
}