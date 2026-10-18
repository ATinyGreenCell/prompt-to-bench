// Drying Rack for 10 Microscope Slides
// Base: 90 x 45 x 20 mm (Resting on Z=0)
// Slots: 10 parallel slots along X, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5mm centre-to-centre in Y

$fn = 128;

// Base Dimensions
base_length = 90;
base_width = 45;
base_height = 20;

// Slide Dimensions (for reference)
slide_length = 75;
slide_width = 25;
slide_thickness = 1;

// Slot Dimensions
num_slots = 10;
slot_length = 77;
slot_width = 1.6;
slot_depth = 10;
slot_spacing = 3.5; // Centre-to-centre in Y

// Calculate Y position of the first slot centre
// The group of slots is centred on the block in Y.
total_span = (num_slots - 1) * slot_spacing;
y_offset = (base_width - total_span) / 2;

// Build the solid base block starting at Z=0
difference() {
    // Main block: 90 x 45 x 20, resting on Z=0
    cube([base_length, base_width, base_height], center = false);
    
    // Cut the 10 slots
    // Slots run along X.
    // We cut from the top surface (Z=20) downwards to Z=10.
    // The cut shape must extend slightly past the slot length in X to ensure clean cut.
    cut_extension = 0.1; 
    
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for this specific slot
        y_pos = y_offset + i * slot_spacing;
        
        // Define the slot geometry
        // The slot is a rectangular prism cut into the top face.
        // It runs along X, has width in Y, and depth in Z.
        
        translate([0, y_pos, base_height - slot_depth]) {
            // Cut shape: 
            // X: slot_length + extension
            // Y: slot_width
            // Z: slot_depth (extends from current Z up to base_height)
            cube([slot_length + cut_extension, slot_width, slot_depth], center = false);
        }
    }
}