// 10-well comb for casting agarose gels, printed lying flat
// Units: mm

$fn = 64;

// --- Spine (back bar) ---
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y
plate_thk   = 1.5;  // plate thickness along Z

// --- Teeth ---
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (hangs in -Y)
tooth_gap   = 1.5;  // gap between neighbouring teeth along X

// --- Cutting overlap ---
eps = 0.5;          // extension past cut faces to avoid coplanar faces

difference() {
    // Base plate: spine + teeth
    union() {
        // Spine
        translate([-spine_len/2, -spine_wid/2, 0])
            cube([spine_len, spine_wid, plate_thk]);

        // Teeth row, centred on spine in X
        for (i = [0 : tooth_count - 1]) {
            x = (i - (tooth_count - 1)/2) * (tooth_w + tooth_gap);
            translate([x, -spine_wid/2 - tooth_l, 0])
                cube([tooth_w, tooth_l + spine_wid, plate_thk]);
        }
    }

    // Wells: cut up from -Z into the plate, through the full thickness
    for (i = [0 : tooth_count - 1]) {
        x = (i - (tooth_count - 1)/2) * (tooth_w + tooth_gap);
        translate([x, -spine_wid/2, -eps])
            cube([tooth_w, tooth_l + spine_wid, plate_thk + 2*eps]);
    }
}