// Hose-barb reducer: 8 mm tubing (ID) -> 5 mm tubing (ID)
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
bore      = 3;    // through-bore diameter
tube_id   = 8;    // larger tubing inner diameter
tube_id2  = 5;    // smaller tubing inner diameter
barb_h    = 10;   // barb height (each, stacked 2)
barb_od   = 9.5;  // barb outer diameter at top
collar_d  = 12;   // collar diameter
len2      = 8;    // second tubing length segment
eps       = 0.5;  // overshoot for clean cuts

// ---- Model ----
difference() {
    union() {
        // Lower barbs for 8 mm tubing
        for (i = [0 : 1])
            translate([0, 0, i * barb_h])
                cylinder(h = barb_h, d1 = tube_id - 2*eps, d2 = barb_od);
        // Upper barbs for 5 mm tubing
        for (i = [0 : 1])
            translate([0, 0, 20 + i * barb_h])
                cylinder(h = barb_h, d1 = tube_id2 - 2*eps, d2 = tube_id2 - 2*eps);
        // Collar at z = 20
        translate([0, 0, 20])
            cylinder(h = len2, d = collar_d);
    }
    // Straight through-bore
    translate([0, 0, -eps])
        cylinder(h = 40 + 2*eps, d = bore);
}