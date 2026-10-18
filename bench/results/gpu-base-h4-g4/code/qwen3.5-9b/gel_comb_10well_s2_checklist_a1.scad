// 10-well agarose gel comb - flat plate with spine and hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;
spine_w   = 12;
plate_thk = 1.5;

tooth_w   = 5.0;
tooth_len = 12;
tooth_gap = 1.5;
n_teeth   = 10;

$fn = 64;

// Calculate total width of the tooth row
tooth_row_w = n_teeth * tooth_w + (n_teeth - 1) * tooth_gap;

// Generate X positions for the teeth, centred on 0
// Formula: (i - (n-1)/2) * (tooth_w + tooth_gap)
tooth_positions = [for (i = [0 : n_teeth - 1]) let(pos = (i - (n_teeth - 1) / 2) * (tooth_w + tooth_gap)) pos];

difference() {
    // 1. Create the main spine plate
    // Extrude the spine rectangle to the full thickness.
    // Spine is 70mm long (X) and 12mm wide (Y).
    translate([0, 0, 0])
    linear_extrude(height = plate_thk)
    square([spine_len, spine_w], center = true);

    // 2. Cut out the teeth
    // The teeth hang from the edge of the spine in the -Y direction.
    // Spine Y range: -6 to +6.
    // Teeth start at Y = -6 and extend to Y = -6 - 12 = -18.
    
    cut_y_start = -spine_w / 2; // Top edge of the spine (in -Y direction)
    cut_y_end   = cut_y_start - tooth_len; // Bottom of the teeth
    
    // We subtract cylinders (extruded rectangles) for each tooth.
    // The cut shape needs to extend slightly past the bottom of the teeth to ensure clean separation.
    cut_depth = tooth_len + 0.1;

    for (x = tooth_positions) {
        // Position the cylinder at the calculated X, starting at the spine edge (Y = -6)
        // The cylinder height is the cut_depth.
        translate([x, cut_y_start, 0])
        cylinder(h = cut_depth + 0.1, d = tooth_w);
    }
}