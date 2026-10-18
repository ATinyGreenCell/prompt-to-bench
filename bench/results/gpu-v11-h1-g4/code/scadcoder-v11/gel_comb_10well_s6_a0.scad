// 10-well agarose gel comb, printed lying flat
// Units: mm

plate_t      = 1.5;   // plate thickness (Z)
spine_l      = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
teeth_n      = 10;    // number of teeth
teeth_w      = 5;     // tooth width (X)
teeth_l      = 12;    // tooth length (Y)
teeth_gap    = 1.5;   // gap between teeth (X)
overcut      = 0.5;   // cutter overshoot past faces

$fn = 64;

pitch = teeth_w + teeth_gap;  // centre-to-centre spacing

difference() {
    // Base plate with spine
    translate([-spine_l/2, -spine_w/2, 0])
        cube([spine_l, spine_w, plate_t]);

    // Teeth hanging in -Y from one long edge
    for (i = [0 : teeth_n - 1]) {
        x = (i - (teeth_n - 1)/2) * pitch;
        translate([x - teeth_w/2, -spine_w/2 - teeth_l, -overcut])
            cube([teeth_w, teeth_l + overcut, plate_t + 2*overcut]);
    }
}