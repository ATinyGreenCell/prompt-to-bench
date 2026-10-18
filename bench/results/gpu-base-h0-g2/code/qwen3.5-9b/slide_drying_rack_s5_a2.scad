// Drying Rack for 10 Microscope Slides
// Base: 90mm (X) x 45mm (Y) x 20mm (Z)
// Slots: 10 parallel slots along X, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5mm centre-to-centre (Y), centred on block in X and Y

$fn = 128;

// --- Dimensions ---
// Base dimensions
base_length = 90;   // X
base_width = 45;    // Y
base_height = 20;   // Z

// Slide dimensions (for reference)
slide_length = 75;  // X
slide_width = 25;   // Y
slide_thickness = 1; // Z

// Slot dimensions
slot_length = 77;   // X
slot_width = 1.6;   // Y
slot_depth = 10;    // Z

// Layout
num_slots = 10;
slot_spacing = 3.5; // Centre-to-centre in Y

// --- Calculations ---
// Calculate the Y position of the first slot centre to ensure the group is centred.
// The span from the first slot centre to the last slot centre is (num_slots - 1) * slot_spacing.
// To centre this span on the block width:
// First Slot Y = (Block Width / 2) - (Span / 2)
span_length = (num_slots - 1) * slot_spacing;
first_slot_y = (base_width / 2) - (span_length / 2);

// --- Build ---

difference() {
    // 1. Main block
    cube([base_length, base_width, base_height], center = false);
    
    // 2. Cut the 10 slots
    // Slots run along X. We cut a long thin rectangle from the top face downwards.
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position for current slot
        current_slot_y = first_slot_y + (i * slot_spacing);
        
        // Define the cutting shape
        // The slot is 77mm long (X), 1.6mm wide (Y), 10mm deep (Z).
        // Rule 5: Extend slightly past the faces to ensure clean cuts.
        cut_length = slot_length + 0.1; 
        cut_width = slot_width + 0.1;
        cut_depth = slot_depth + 0.1;
        
        // Position the cutter
        // X: Centered on the block (0)
        // Y: current_slot_y
        // Z: Top of block is at base_height, we cut down to base_height - slot_depth
        // So the cutter top is at base_height, bottom at base_height - cut_depth
        translate([0, current_slot_y, base_height - cut_depth]) {
            cube([cut_length, cut_width, cut_depth]);
        }
    }
}