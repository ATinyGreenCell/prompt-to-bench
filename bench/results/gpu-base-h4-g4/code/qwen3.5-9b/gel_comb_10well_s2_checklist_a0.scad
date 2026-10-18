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

// Position the tooth row so it is centred on the spine in X
// The spine is from -spine_len/2 to +spine_len/2.
// The tooth row is centred at X=0.
// The teeth hang in -Y direction from the spine edge at Y = -spine_w/2.
// So the top of the teeth is at Y = -spine_w/2.
// The bottom of the teeth is at Y = -spine_w/2 - tooth_len.

// Define the 2D profile for the spine (a rectangle)
// We will extrude this to get the base plate.
// Spine profile: width = spine_w, height = plate_thk.
// Centred at origin.
spine_profile = [spine_w / 2, plate_thk / 2];

// Define the 2D profile for the teeth relative to the spine edge.
// We will subtract these from the extruded spine.
// Tooth profile: width = tooth_w, height = tooth_len.
// Positioned at X = 0, Y = -spine_w/2 (top edge of spine).
// We need to generate the list of tooth positions.

// Generate X positions for the teeth, centred on 0
// Formula: (i - (n-1)/2) * (tooth_w + tooth_gap)
tooth_positions = [for (i = [0 : n_teeth - 1]) let(pos = (i - (n_teeth - 1) / 2) * (tooth_w + tooth_gap)) pos];

difference() {
    // 1. Create the main spine plate
    // Extrude the spine rectangle to the full thickness
    translate([0, 0, 0])
    linear_extrude(height = plate_thk)
    square([spine_len, spine_w], center = true);

    // 2. Cut out the teeth
    // We subtract cylinders (or extruded rectangles) for each tooth.
    // The teeth hang down from the top edge of the spine (which is at Y = -spine_w/2).
    // The cut shape needs to extend slightly past the bottom of the teeth to ensure clean separation.
    cut_depth = tooth_len + 0.1;
    cut_y_start = -spine_w / 2; // Top of the spine
    cut_y_end   = cut_y_start - cut_depth; // Bottom of the cut

    for (x = tooth_positions) {
        translate([x, cut_y_start, 0])
        cylinder(h = cut_depth + 0.1, d = tooth_w);
    }
}