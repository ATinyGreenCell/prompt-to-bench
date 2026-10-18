// 10-well comb for casting agarose gels, printed lying flat
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
teeth_dir   = -1;   // hang direction along Y (+1 or -1)

// --- Derived ---
row_w      = (teeth_n - 1) * teeth_gap + teeth_n * teeth_w;  // row width in X
overhang   = teeth_l - plate_wid;                            // tooth overhangs end of spine
x0         = -plate_len / 2 + row_w / 2;                     // first tooth X (centred row)

difference() {
    // Plate (spine)
    translate([0, 0, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Teeth, cut into the plate
    for (i = [0 : teeth_n - 1]) {
        translate([x0 + i * (teeth_w + teeth_gap), 0, 0])
            cube([teeth_w, teeth_l, plate_thk]);
    }
}