$fn = 64;

// Dimensions
thickness = 1.5;          // Plate thickness in Z
spine_len_x = 70;         // Spine length in X
spine_wid_y = 12;         // Spine width in Y
num_teeth = 10;           // Number of teeth
tooth_wid_x = 5.0;        // Tooth width in X
tooth_len_y = 12;         // Tooth length in Y
gap_wid_x = 1.5;          // Gap width between teeth in X

// Calculate total width of the tooth row to center it on the spine
total_tooth_row_x = num_teeth * tooth_wid_x + (num_teeth - 1) * gap_wid_x;
start_x = -total_tooth_row_x / 2;

union() {
    // Spine (back bar)
    translate([-spine_len_x / 2, -spine_wid_y / 2, 0])
        cube([spine_len_x, spine_wid_y, thickness]);

    // Teeth row
    for (i = [0 : num_teeth - 1]) {
        x_pos = start_x + i * (tooth_wid_x + gap_wid_x);
        y_pos = -spine_wid_y / 2 - tooth_len_y;
        translate([x_pos, y_pos, 0])
            cube([tooth_wid_x, tooth_len_y, thickness]);
    }
}