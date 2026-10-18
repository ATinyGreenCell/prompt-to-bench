// Agarose gel casting comb - 10 wells
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---------- Parameters ----------
plate_t      = 1.5;   // plate thickness (Z)
spine_l      = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
teeth_n      = 10;    // number of teeth
teeth_w      = 5.0;   // tooth width (X)
teeth_l      = 12;    // tooth length (Y)
teeth_pitch  = teeth_w + 1.5; // centre-to-centre spacing (X)
eps          = 0.5;   // cutter overshoot

$fn = 64;

// ---------- Model ----------
difference() {
    // Plate with spine
    union() {
        translate([-spine_l/2, -spine_w/2, 0])
            cube([spine_l, spine_w, plate_t]);
    }

    // Teeth cutters, centred on spine
    for (i = [0 : teeth_n - 1])
        translate([(i - (teeth_n - 1)/2) * teeth_pitch,
                   -spine_w/2 - eps,
                   -eps])
            cube([teeth_w, teeth_l + 2*eps, plate_t + 2*eps]);
}