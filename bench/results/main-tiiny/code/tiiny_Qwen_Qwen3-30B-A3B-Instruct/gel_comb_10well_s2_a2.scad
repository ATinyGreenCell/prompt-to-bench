// Dimensions for 10-well agarose gel comb
$fn = 64;

// Spine (back bar) dimensions
spine_length = 70;   // X direction
spine_width = 12;    // Y direction
spine_thickness = 1.5; // Z direction (height)

// Tooth dimensions
tooth_width = 5.0;   // X direction (width of each tooth)
tooth_length = 12;     // Y direction (length of each tooth, extending from spine)
tooth_gap = 1.5;      // Gap between adjacent teeth (in Y direction)

// Number of teeth
num_teeth = 10;

// The spine is centered at (0, 0, 0) and lies on the bed (z = 0)
// The tooth row is attached to the spine's -Y edge (Y = -spine_width/2 = -6 mm)
// The tooth row extends in the -Y direction from that edge

// Total Y span of the tooth row: 10 teeth × 12 mm + 9 gaps × 1.5 mm = 120 + 13.5 = 133.5 mm
// So the tooth row extends from Y = -6 - 133.5 = -139.5 mm to Y = -6 mm

// The spine is 70 mm long in X, so we center the tooth row in X over the spine
// Each tooth is 5.0 mm wide in X, so we center each tooth at X = 0

// The tooth row is centered in X, so the X center of each tooth is 0
// The Y center of the first tooth is at Y = -6 - tooth_length/2 - tooth_gap/2 = -6 - 6 - 0.75 = -12.75

// But we can compute the Y position of each tooth's center as:
// Y_center = -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i

// However, we must ensure the entire comb is properly positioned so that the spine is at z = 0 and the part lies flat on the bed

// The spine is 1.5 mm thick, so we place it at z = 0 to z = 1.5, but the bed is at z = 0
// So we need to ensure the lowest point is at z = 0

// The spine is centered at z = 0, so its bottom is at z = -0.75, top at z = 0.75
// But the bed is at z = 0, so the part is floating — we need to shift it so that the bottom is at z = 0

// Therefore, we translate the entire comb by +0.75 in Z

// Now, the spine will go from z = 0 to z = 1.5, and the comb lies flat on the bed

// Build the comb: start with the spine centered at (0, 0, 0), then shift it up by 0.75 in Z

module comb() {
    // Spine (back bar) — centered at (0, 0, 0), then shifted up
    translate([0, 0, 0.75])
        cube([spine_length, spine_width, spine_thickness], center = true);

    // Add teeth using a loop
    for (i = [0 : num_teeth - 1]) {
        // Y position of this tooth's center
        // The first tooth starts at Y = -spine_width/2 - tooth_length/2 - tooth_gap/2
        // Then each next tooth is offset by (tooth_length + tooth_gap) in Y
        // But we want to center the tooth row in X over the spine
        // So each tooth is centered at X = 0
        // Y center = -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i

        // However, the spine is 70 mm long in X, and the tooth is 5.0 mm wide in X
        // So to center the tooth in X, we place it at X = 0
        // But the spine's X is from -35 to 35, so we need to ensure the tooth is within that

        // The tooth is 5.0 mm wide in X, so we center it at X = 0
        // The Y center of the tooth is:
        // Y_center = -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i

        // But this would make the tooth row extend from Y = -6 - 6 - 0.75 = -12.75 for the first tooth
        // Then next at Y = -12.75 - (12 + 1.5) = -12.75 - 13.5 = -26.25

        // But the total Y span should be 133.5 mm, so the last tooth should be at Y = -12.75 - 13.5 * 9 = -12.75 - 121.5 = -134.25

        // That matches the report: Y: -134.25 .. 6.00

        // So the Y center of the first tooth is at Y = -6 - 6 - 0.75 = -12.75
        // But we can compute it as:
        // Y_center = -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i

        // Actually, we can simplify: the first tooth's Y center is at Y = -spine_width/2 - tooth_length/2 - tooth_gap/2
        // Then subtract (tooth_length + tooth_gap) * i

        // But we can also think: the tooth row is symmetric in X, so we place each tooth centered at X = 0

        // So:
        // X: 0 (centered)
        // Y: -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i
        // Z: 0.75 (to lift the bottom to z = 0)

        // But we can do it in one translate

        // Calculate Y center for this tooth
        tooth_y_center = -spine_width/2 - tooth_length/2 - tooth_gap/2 - (tooth_length + tooth_gap) * i;

        // X center is 0 (centered over spine)
        // Z is 0.75 (to lift the bottom to z = 0)

        // But the tooth is 5.0 mm wide in X, so we need to center it at X = 0
        // So we translate to (0, tooth_y_center, 0.75)

        // However, the tooth is 5.0 mm wide in X, so we need to place it so that it's centered at X = 0
        // So we use:
        // translate([0, tooth_y_center, 0.75])
        //   cube([tooth_width, tooth_length, spine_thickness], center = true);

        // But the tooth is 5.0 mm wide in X, so we need to ensure it's centered at X = 0

        // Yes, so:
        translate([0, tooth_y_center, 0.75])
            cube([tooth_width, tooth_length, spine_thickness], center = true);
    }
}

// Render the comb
comb();