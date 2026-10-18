// 10-well agarose gel comb - printed lying flat
// Units: mm

// ---------- Parameters ----------
plate_thk     = 1.5;    // plate thickness (Z)
spine_len     = 70;     // spine length (X)
spine_wid     = 12;     // spine width (Y)
tooth_count   = 10;     // number of teeth
tooth_w       = 5.0;    // tooth width (X)
tooth_len     = 12;     // tooth length (Y)
gap           = 1.5;    // gap between teeth (X)
overcut       = 0.5;    // extra length on cutters past faces
$fn           = 64;     // curve resolution

// ---------- Derived ----------
pitch   = tooth_w + gap;                 // centre-to-centre tooth spacing
x0      = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred)
teeth_span = (tooth_count - 1) * pitch + tooth_w; // distance first-to-last tooth

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_len/2, -spine_wid/2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth hanging in -Y from the spine
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_w/2, -spine_wid/2 - tooth_len, 0])
            cube([tooth_w, tooth_len + overcut, plate_thk + overcut]);
}