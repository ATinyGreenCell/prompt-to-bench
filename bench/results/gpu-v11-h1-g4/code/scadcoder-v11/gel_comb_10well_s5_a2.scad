// 10-well agarose gel comb - printed lying flat
// Units: mm

plate_t     = 1.5;   // plate thickness (Z)
spine_len   = 70;    // spine length (X)
spine_w     = 12;    // spine width (Y)
teeth_n     = 10;    // number of teeth
teeth_w     = 5;     // tooth width (X)
teeth_l     = 12;    // tooth length (Y)
gap         = 1.5;   // gap between teeth (X)

pitch       = teeth_w + gap;          // centre-to-centre spacing
x_start     = -(teeth_n - 1) * pitch / 2;  // first tooth centre (row centred)

difference() {
    // Spine
    translate([-spine_len / 2, -spine_w / 2, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth, cut into the spine
    for (i = [0 : teeth_n - 1])
        translate([x_start + i * pitch - teeth_w / 2, -teeth_l, -1])
            cube([teeth_w, teeth_l + 1, plate_t + 2]);
}