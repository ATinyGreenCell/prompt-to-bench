// Hose-barb reducer: 8 mm OD tubing (split into two barbs) to 5 mm OD tubing
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
tube8_od      = 9.5;   // outer diameter of 8 mm tubing (split)
tube8_inner   = 7.5;   // inner diameter of 8 mm tubing (split)
tube5_od      = 5.0;   // outer diameter of 5 mm tubing
tube5_inner   = 3.0;   // inner diameter of 5 mm tubing
bore          = 3;     // through-bore diameter
collar_od     = 12;    // collar outer diameter
collar_id     = 9.5;   // collar inner diameter (overlap into 8 mm section)
collar_h      = 5;     // collar height

section8_h    = 20;    // height of 8 mm tubing section
section5_h    = 15;    // height of 5 mm tubing section
eps           = 0.5;   // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing section with two stacked barbs
        for (a = [0, 180])
            rotate([0, 0, a])
                translate([0, -tube8_inner/2, 0])
                    cylinder(h = section8_h, d = tube8_od);

        // Collar
        translate([0, 0, section8_h - 0.01])
            cylinder(h = collar_h + 0.01, d = collar_od);
    }

    // 5 mm tubing section
    translate([0, 0, section8_h])
        cylinder(h = section5_h, d = tube5_od);

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = section8_h + section5_h + 2*eps, d = bore);
}