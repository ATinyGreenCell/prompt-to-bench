// 10-well agarose gel comb, printed flat (Z = thickness)
// All dimensions in mm, measured with calipers.

// Global
$fn = 64;

// Spine (back bar)
spine_len   = 70;   // X
spine_wid   = 12;   // Y
spine_thick = 1.5;  // Z

// Teeth
n_teeth     = 10;   // number of wells/teeth
tooth_wid   = 5.0;  // X
tooth_len   = 12;   // Y (hangs in -Y from spine)
tooth_gap   = 1.5;  // X gap between neighbouring teeth

// Derived layout
tooth_pitch = tooth_wid + tooth_gap;                 // 6.5 mm
row_width   = n_teeth * tooth_wid + (n_teeth - 1) * tooth_gap; // 56.5 mm

// Spine centred on origin in X and Y
spine_x0 = -spine_len / 2;
spine_y0 = -spine_wid / 2;

// Row of teeth centred on spine in X
row_x0 = -row_width / 2;

// Teeth hang in -Y from the spine's -Y edge (y = -spine_wid/2)
tooth_y0 = -spine_wid / 2 - tooth_len;

// Build the comb as a union of the spine and the tooth row
union() {
    // Spine
    translate([spine_x0, spine_y0, 0])
        cube([spine_len, spine_wid, spine_thick], center = false);

    // Teeth (10 of them, evenly spaced, centred on spine in X)
    for (i = [0 : n_teeth - 1]) {
        x_i = row_x0 + i * tooth_pitch;
        translate([x_i, tooth_y0, 0])
            cube([tooth_wid, tooth_len, spine_thick], center = false);
    }
}