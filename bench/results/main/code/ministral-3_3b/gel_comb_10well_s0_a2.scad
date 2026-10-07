// Agarose comb design (flat print orientation)
$fn = 64;

// Spine dimensions
spine_length_x = 70;      // Long edge length (X)
spine_width_y = 12;       // Width along Y

// Tooth dimensions
tooth_count = 10;
tooth_width_x = 5.0;      // Width in X
tooth_length_y = 12;     // Length in Y
tooth_gap_y = 1.5;       // Gap between teeth in Y

// Thickness and print orientation
thickness_z = 1.5;       // Height (Z) of comb plate

module agarose_comb() {
    // Calculate tooth positions along X-axis (centered)
    tooth_x_positions = [];
    for (i in [0:tooth_count-1]) {
        tooth_x_positions.push(
            spine_width_y/2 - (tooth_count-1-i)*(tooth_width_x + tooth_gap_y) - tooth_width_x/2
        );
    }

    // Create teeth by extruding and rotating
    teeth = [];
    for (i in [0:tooth_count]) {
        tooth = translate([tooth_x_positions[i], spine_width_y/2, 0],
            rotate([90, 0, 0], linear_extrude(height=thickness_z),
                polygon(points=[[0, 0], [tooth_length_y, 0], [tooth_length_y, tooth_width_x], [0, tooth_width_x]]))
        );
        teeth.push(tooth);
    }

    // Create spine
    spine = cube([spine_length_x, spine_width_y, thickness_z]);

    // Combine all parts
    comb = union(spine, intersection(teeth));
}

// Print the model
module() {
    agarose_comb();
}