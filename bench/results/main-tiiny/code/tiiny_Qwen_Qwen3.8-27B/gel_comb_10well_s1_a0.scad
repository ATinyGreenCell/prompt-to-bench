// 10-well agarose gel comb, printed flat (Z = thickness)

// --- dimensions (mm) ---
plate_thick   = 1.5;   // Z thickness of the whole comb
spine_len     = 70;    // X length of the back bar (spine)
spine_width   = 12;    // Y width of the back bar
tooth_w       = 5.0;   // X width of each tooth
tooth_len     = 12;    // Y length of each tooth (hangs in -Y from the spine)
gap           = 1.5;   // X gap between neighbouring teeth
n_tooth       = 10;    // number of teeth

// --- derived layout ---
tooth_pitch   = tooth_w + gap;                       // centre-to-centre spacing in X
row_width     = n_tooth * tooth_w + (n_tooth - 1) * gap; // total X span of the tooth row
row_start_x   = -row_width / 2 + tooth_w / 2;        // X of the first tooth centre (row centred on origin)

// Y positions: spine occupies y = 0 .. spine_width; teeth hang in -Y
spine_y0      = 0;
spine_y1      = spine_width;
tooth_y0      = -tooth_len;
tooth_y1      = 0;

// --- build the comb ---
$fn = 64;

union() {
    // back bar (spine)
    translate([-spine_len / 2, spine_y0, 0])
        cube([spine_len, spine_width, plate_thick], center = [false, false, false]);

    // 10 teeth, each a rectangular prism hanging in -Y from the spine
    for (i = [0 : n_tooth - 1]) {
        tx = row_start_x + i * tooth_pitch;   // X centre of tooth i
        translate([tx - tooth_w / 2, tooth_y0, 0])
            cube([tooth_w, tooth_len, plate_thick], center = [false, false, false]);
    }
}