// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

$fn = 64;

// --- Plate ---
plate_len   = 70;   // spine length (X)
plate_wid   = 12;   // spine width (Y)
plate_thk   = 1.5;  // plate thickness (Z)

// --- Teeth ---
teeth_n     = 10;   // number of teeth
teeth_w     = 5.0;  // tooth width (X)
teeth_l     = 12;   // tooth length (Y)
teeth_gap   = 1.5;  // gap between teeth (X)

// Derived
teeth_total_w = (teeth_n - 1) * teeth_gap + teeth_n * teeth_w;  // row width in X
overhang      = (plate_len - teeth_total_w) / 2;                // centre offset

difference() {
    // Plate with spine
    translate([-plate_len / 2, -plate_wid / 2, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Teeth hanging in -Y from one long edge
    for (i = [0 : teeth_n - 1]) {
        translate([-plate_len / 2 + overhang + i * (teeth_w + teeth_gap),
                   -plate_wid / 2 - teeth_l,
                   0])
            cube([teeth_w, teeth_l, plate_thk]);
    }
}