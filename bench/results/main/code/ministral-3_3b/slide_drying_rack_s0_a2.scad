// Drying rack for 10 microscope slides (75x25x1mm) standing upright
// Base: 90mm×45mm×20mm, slots run along X (77mm long), centered in Y

$fn = 64;
var(
    base_length = 90;      // X dimension of base
    base_width  = 45;      // Y dimension of base
    slot_spacing= 3.5;     // Centre-to-centre spacing between slots (Y)
    slide_depth = 10;      // Slot depth into Z

    // Slot dimensions with 1mm overhangs
    slot_length   = 77 + 2*1;  // 80mm total length including overhangs
    slot_width    = 1.6 + 2*1;  // 3.6mm total width (including overhangs)
);

// Base block
cube([base_length, base_width, 20]);

// Create 10 slots with proper spacing and overhangs
for(i in [0..9]) {
    var(
        y_pos = -slot_spacing/2 + i * slot_spacing; // Position along Y axis
        x_offset = -(base_length/2) + (slot_length/2)/2; // Center X position

    );

    translate([x_offset, y_pos, 0]) {
        difference() {
            cube([slot_length, base_width+1.6, slide_depth+1]); // Outer box
            translate([-0.5, -0.8, 0]) { cube([slot_length-1, slot_width-1, slide_depth-1]); } // Inner cut
        }
    };
}