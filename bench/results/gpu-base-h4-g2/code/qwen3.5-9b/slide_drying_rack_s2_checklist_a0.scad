// Drying rack for 10 microscope slides.
// Base: 90 x 45 x 20 mm.
// Slots: 10 parallel slots along X, 77 mm long, 1.6 mm wide, 10 mm deep.
// Spacing: 3.5 mm centre-to-centre in Y, centred on the block.

// Base dimensions
L_base = 90;
W_base = 45;
H_base = 20;

// Slide dimensions (for reference)
slide_w = 25;
slide_h = 75;
slide_t = 1;

// Slot dimensions
slot_len = 77;
slot_w   = 1.6;
slot_d   = 10;

// Spacing
slot_spacing = 3.5;

// Tolerance for cutting
tol = 0.05;

$fn = 64;

// Calculate the Y position of the first slot centre.
// We have 10 slots. The group is centred on the block in Y.
// The distance from the block centre to the first slot centre is:
// (W_base / 2) - ( (n-1)/2 * spacing + slot_w/2 )
// Or simply: start_pos = - ( (n-1)*spacing/2 + slot_w/2 )
n_slots = 10;
y_start = - ( (n_slots - 1) * slot_spacing / 2 + slot_w / 2 );

difference() {
    // 1. Create the solid base block
    translate([0, 0, 0]) 
        cube([L_base, W_base, H_base]);

    // 2. Cut the 10 slots
    // Slots run along X, so we cut a long thin rectangle going into the block.
    // The slot is open at the top (Z=0) and goes down to Z = H_base - slot_d.
    // We extend the cut slightly past the bottom to ensure clean removal.
    for (i = [0 : n_slots - 1]) {
        // Calculate Y position for this slot
        y_pos = y_start + i * slot_spacing;
        
        // Define the cutting shape
        // It is a prism: length = slot_len + tolerance, width = slot_w + tolerance, height = slot_d + tolerance
        translate([0, y_pos, 0]) 
            cube([slot_len + tol, slot_w + tol, slot_d + tol]);
    }
}