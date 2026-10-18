// Hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z

// ---------- Parameters ----------
id_large   = 8;    // larger tubing inner diameter
id_small   = 5;    // smaller tubing inner diameter
bore       = 3;    // through-bore diameter
eps        = 0.5;  // cutter overshoot

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Lower barb section (8 mm tubing)
        cylinder(h = 20, d = id_large + 1.5);

        // Upper collar section
        translate([0, 0, 20])
            cylinder(h = 5, d = id_small + 2);

        // Upper barb section (5 mm tubing)
        translate([0, 0, 25])
            cylinder(h = 8, d = id_small + 1);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = 43, d = bore);
}