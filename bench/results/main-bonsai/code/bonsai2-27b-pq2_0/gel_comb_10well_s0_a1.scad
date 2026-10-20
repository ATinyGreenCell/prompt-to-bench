// 10-well agarose gel casting comb, printed flat on the bed.
// All units are millimetres.

// ---- Named dimensions (measured with calipers) ----
plate_z      = 1.5;   // plate thickness (Z)
spine_x      = 70.0;  // spine length (X)
spine_y      = 12.0;  // spine width (Y)
tooth_x      = 5.0;   // tooth width (X)
tooth_y      = 12.0;  // tooth length (Y)
gap_y        = 1.5;   // gap between neighbouring teeth (Y)
n_teeth      = 10;    // number of teeth

// Derived: total width of the tooth row (X)
row_x        = n_teeth * tooth_x + (n_teeth - 1) * gap_y;

// ---- Print orientation: plate rests on XY plane at z = 0, builds +Z.
// Centred on origin in X and Y. ----
$fn = 64;

module comb() {
    // Spine (back bar): 70 x 12 x 1.5, centred in X and Y.
    cube([spine_x, spine_y, plate_z], center = true);

    // 10 rectangular teeth hanging from the -Y edge of the spine.
    // Each tooth: 5.0 (X) x 12.0 (Y) x 1.5 (Z).
    // Row of teeth is centred on the spine in X.
    for (i = 0; i < n_teeth; i++) {
        tx = -row_x / 2 + tooth_x / 2 + i * (tooth_x + gap_y);
        ty = -spine_y / 2 - tooth_y / 2;
        translate([tx, ty, 0])
            cube([tooth_x, tooth_y, plate_z], center = false);
    }
}

comb();