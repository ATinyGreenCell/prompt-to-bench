// 10-well agarose gel comb, printed flat on the bed (Z = 0).
// All dimensions in millimetres.

// --- Named dimensions ---
plate_thick   = 1.5;   // Z thickness of the flat plate
spine_len     = 70;    // X length of the straight spine (back bar)
spine_width   = 12;    // Y width of the spine
tooth_width   = 5.0;   // X width of each rectangular tooth
tooth_len     = 12;    // Y length of each tooth (hangs in -Y from the spine)
gap           = 1.5;   // X gap between neighbouring teeth
n_tooth       = 10;    // number of teeth

// --- Derived values ---
// Total X span of the tooth row (10 teeth + 9 gaps)
row_span = n_tooth * tooth_width + (n_tooth - 1) * gap;

// X position of the left edge of the first tooth so the row is centred on the spine
x0 = -row_span / 2;

// Y position of the spine's front edge (teeth hang from this edge in -Y)
spine_front_y = spine_width / 2;

// Y position of the tooth tips (front edge of spine minus tooth length)
tooth_tip_y = spine_front_y - tooth_len;

// --- Build the comb ---
$fn = 64;

union() {
    // Straight spine (back bar), centred on the origin in X and Y
    translate([-spine_len / 2, -spine_width / 2, 0])
        cube([spine_len, spine_width, plate_thick], center = false);

    // 10 rectangular teeth hanging in -Y from the spine's front edge
    for (i = [0 : n_tooth - 1]) {
        tx = x0 + i * (tooth_width + gap);   // left X edge of tooth i
        ty = tooth_tip_y;                    // front (tip) Y edge of tooth i
        translate([tx, ty, 0])
            cube([tooth_width, tooth_len, plate_thick], center = false);
    }
}