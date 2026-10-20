// Dimensions for 10-well comb for agarose gel casting
$fn = 64;

// Plate thickness (Z-direction, lying flat on bed)
plate_thickness = 1.5;

// Spine dimensions (back bar)
spine_length = 70;        // mm (X-direction)
spine_width = 12;         // mm (Y-direction)

// Tooth dimensions
tooth_width = 5.0;        // mm (X-direction)
tooth_length = 12;       // mm (Y-direction)
gap_between_teeth = 1.5; // mm

// Number of wells (teeth)
num_teeth = 10;

// Total length of the tooth row in Y direction (from first to last tooth)
total_length_y = (num_teeth - 1) * (tooth_length + gap_between_teeth) + tooth_length;
start_y = -total_length_y / 2;

// Create the full comb as a union of spine and teeth
union() {
    // Spine: 70 mm long (X), 12 mm wide (Y), 1.5 mm thick
    cube([spine_length, spine_width, plate_thickness]);

    // Each tooth extends from y = start_y + i*(tooth_length + gap) to y = start_y + i*(tooth_length + gap) + tooth_length
    for (i = [0 : num_teeth - 1]) {
        y_offset = start_y + i * (tooth_length + gap_between_teeth);
        // Each tooth is 5.0 mm wide (X), 12 mm long (Y), 1.5 mm thick
        // Positioned at (0, y_offset, 0) with orientation
        translate([0, y_offset, 0]) {
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}