// 10-well agarose gel comb, printed flat
// Units: mm

$fn = 64;

// Plate
plate_len   = 70;   // spine length (X)
plate_wid   = 12;   // spine width (Y)
plate_thk   = 1.5;  // plate thickness (Z)

// Teeth
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width (X)
tooth_l     = 12;   // tooth length (Y)
tooth_gap   = 1.5;  // gap between teeth (X)

// Derived
row_len    = (tooth_count - 1) * tooth_gap + tooth_count * tooth_w;  // 55 mm
overhang   = row_len / 2;                                            // centre offset in -Y

difference() {
    union() {
        // Spine
        translate([0, 0, 0])
            cube([plate_len, plate_wid, plate_thk]);

        // Teeth
        for (i = [0 : tooth_count - 1]) {
            x = (i - (tooth_count - 1) / 2) * tooth_gap + tooth_count * tooth_w / 2;
            translate([x, -overhang, 0])
                cube([tooth_w, tooth_l, plate_thk]);
        }
    }
}