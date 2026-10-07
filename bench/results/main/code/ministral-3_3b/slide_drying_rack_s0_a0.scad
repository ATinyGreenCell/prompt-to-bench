// Dimensions for the drying rack base
$fn = 64;
var(
    base_length = 90;      // X: 90 mm long
    base_width   = 45;     // Y: 45 mm wide
    base_height  = 20;     // Z: 20 mm tall

    slide_width  = 75;     // Slide width (long edge)
    slide_depth  = 1;      // Slide thickness (Z)

    slot_length   = 77;    // Slot length along X
    slot_width    = 1.6;   // Slot width in Y
    slot_depth    = 10;    // Slot depth into Z

    slot_spacing  = 3.5;   // Centre-to-centre spacing between slots in Y
);

// Base block (solid)
cube([base_length, base_width, base_height]);

// Create 10 parallel slots for microscope slides
for (slide_num in [0..9]) {
    var(
        y_pos = slide_num * slot_spacing + (slot_spacing / 2) - (slot_spacing / 2); // Center Y position
        x_offset = (base_length / 2) - ((slot_length + 1.6) / 2); // Center X offset for slots

    );

    // Slot shape with 0.5mm overhangs on all sides
    difference() {
        translate([x_offset, y_pos, 0]) {
            cube([slot_length + 1, slot_width + 1, slot_depth + 1]);
        }
        translate([x_offset - 0.25, y_pos - 0.5, 0]) {
            cube([slot_length + 0.5, slot_width + 1, slot_depth + 1]); // Cutting plane
        }
    };
}