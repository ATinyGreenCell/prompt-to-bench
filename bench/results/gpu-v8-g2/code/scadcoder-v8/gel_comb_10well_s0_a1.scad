// 10-well agarose gel comb, printed flat
// Units: mm

// ---- Spine ----
spine_len   = 70;    // spine length (X)
spine_wid   = 12;    // spine width (Y)

// ---- Teeth ----
teeth_n     = 10;    // number of teeth
teeth_w     = 5.0;   // tooth width (X)
teeth_l     = 12;    // tooth length (Y)
teeth_gap   = 1.5;   // gap between teeth (X)

// ---- Plate ----
plate_t     = 1.5;   // plate thickness (Z)

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces

$fn = 64;

// Total length of the tooth row
row_len = (teeth_n - 1) * teeth_gap + teeth_n * teeth_w;

// X position of the row's left edge so the row is centred on the spine
row_x0 = -spine_len / 2 + row_len / 2;

difference() {
    // Base plate
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth, hanging from the -Y edge of the spine
    for (i = [0 : teeth_n - 1])
        translate([row_x0 + i * (teeth_w + teeth_gap), -spine_wid / 2 - teeth_l, 0])
            cube([teeth_w, teeth_l, plate_t + eps]);
}