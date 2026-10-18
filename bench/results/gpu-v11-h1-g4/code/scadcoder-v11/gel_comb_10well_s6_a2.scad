// 10-well agarose gel comb - printed lying flat
// Units: mm

plate_t     = 1.5;    // plate thickness (Z)
spine_l     = 70;     // spine length (X)
spine_w     = 12;     // spine width (Y)
teeth_n     = 10;     // number of teeth
teeth_w     = 5;      // tooth width (X)
teeth_l     = 12;     // tooth length (Y)
gap         = 1.5;    // gap between teeth (X)
eps         = 0.5;    // overcut past faces

pitch = teeth_w + gap;

difference() {
    // Spine
    translate([-spine_l/2, -spine_w/2, 0])
        cube([spine_l, spine_w, plate_t]);

    // Teeth, centred on spine in X
    for (i = [0 : teeth_n - 1])
        translate([(i - (teeth_n - 1)/2) * pitch, -spine_w/2 - teeth_l, -eps])
            cube([teeth_w, teeth_l + eps, plate_t + 2*eps]);
}