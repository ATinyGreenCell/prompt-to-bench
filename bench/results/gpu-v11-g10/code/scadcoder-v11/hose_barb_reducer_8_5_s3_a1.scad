// Hose-barb reducer: 8 mm OD barb -> 5 mm OD barb
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
barb_od       = 8;    // outer diameter of the 8 mm tubing barb
collar_od     = 12;   // outer diameter of the collar
collar_h      = 5;    // collar height (z = 20 to 25)
bore          = 3;    // through-bore diameter
eps           = 0.5;  // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // 8 mm barb (z = 0 to 20)
        translate([0, 0, 0])
            cylinder(h = 20, d = barb_od);

        // Collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(h = collar_h, d = collar_od);

        // 5 mm barb (z = 25 to 41)
        translate([0, 0, 25])
            cylinder(h = 16, d = 5);
    }

    // Through bore
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore);
}