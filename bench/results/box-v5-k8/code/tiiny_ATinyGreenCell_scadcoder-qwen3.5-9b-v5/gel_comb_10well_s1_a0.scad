// 10-well comb for agarose gel casting, printed lying flat
// Units: mm. Plate thickness (Z) = 1.5 mm.

$fn = 64;

// ---- Dimensions ----
spine_len      = 70;   // spine length along X
spine_wid      = 12;   // spine width along Y
plate_thk      = 1.5;  // plate thickness along Z

tooth_count    = 10;   // number of teeth
tooth_w        = 5.0;  // tooth width along X
tooth_l        = 12;   // tooth length along Y
tooth_pitch    = 1.5;  // centre-to-centre spacing along X

eps            = 0.5;  // overcut for clean differences

// ---- Derived ----
total_tooth_w  = tooth_count * tooth_w;
gaps           = tooth_count - 1;
row_start_x    = (spine_len - total_tooth_w - gaps * tooth_pitch) / 2;

// ---- Model ----
difference() {
    union() {
        // Spine (back bar)
        translate([0, 0, 0])
            cube([spine_len, spine_wid, plate_thk]);

        // Teeth, centred on spine in X
        for (i = [0 : tooth_count - 1]) {
            translate([row_start_x + i * tooth_pitch, 0, 0])
                cube([tooth_w, tooth_l, plate_thk]);
        }
    }

    // Wells: cut into the -Y side of the plate, through full thickness
    for (i = [0 : tooth_count - 1]) {
        translate([row_start_x + i * tooth_pitch - eps, -eps, 0])
            cube([tooth_w, tooth_l + 2 * eps, plate_thk + 2 * eps]);
    }
}