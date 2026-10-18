// DIY magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: upside-down open box, top plate on the bed

// ---------- Dimensions (mm) ----------
box_top     = 90;    // outer size in X and Y
box_height  = 40;    // wall height (z = 0 to 40)
plate       = 2;     // top plate thickness
wall        = 2.5;   // wall thickness
screw       = 4.5;   // M4 screw hole diameter
screw_pitch = 71.5;  // square pattern diagonal for 4 screw holes
notch_w     = 12;    // power cable notch width
notch_depth = 8;     // notch depth from open edge (z = 32 to 40)
eps         = 0.5;   // overcut for clean differences

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate, centred in XY, lying on z = 0
        translate([-box_top/2, -box_top/2, 0])
            cube([box_top, box_top, plate]);

        // Four walls rising from the plate to z = box_height
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx > 0 ? box_top/2 - wall : -box_top/2,
                       sy > 0 ? box_top/2 - wall : -box_top/2,
                       plate])
                cube([box_top - 2*wall, box_top - 2*wall, box_height - plate]);
        }
    }

    // Four M4 screw holes through the top plate on a square pattern
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([screw_pitch/2, 0, -eps])
                cylinder(d = screw, h = plate + 2*eps);
    }

    // Notch for the power cable in one wall (centred along the wall)
    translate([-box_top/2 + wall + eps, 0, box_height - notch_depth])
        cube([notch_w, box_top - 2*wall + 2*eps, notch_depth + eps]);
}