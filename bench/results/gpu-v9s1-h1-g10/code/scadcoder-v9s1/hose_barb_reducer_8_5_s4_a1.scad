// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 96;

// ---- Dimensions (mm) ----
id1      = 8;     // 8 mm tubing inner diameter
id2      = 5;     // 5 mm tubing inner diameter
bore     = 3;     // through-bore diameter
barb_h1  = 10;    // 8 mm tubing barb height
barb_od1 = 7.5;   // 8 mm tubing barb outer diameter (bottom)
barb_od2 = 9.5;   // 8 mm tubing barb outer diameter (top)
collar_d = 12;    // collar diameter
collar_h = 5;     // collar height
barb_h2  = 8;     // 5 mm tubing barb height
barb_od3 = 6.5;   // 5 mm tubing barb outer diameter (bottom)
barb_od4 = 5.0;   // 5 mm tubing barb outer diameter (top)
z0       = 0;     // start of 8 mm barbs
z1       = 20;    // start of collar
z2       = 25;    // start of 5 mm barbs
z3       = 41;    // end of 5 mm barbs

eps = 0.5;        // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs (sawtooth profile)
        for (s = [-1, 1])
            translate([0, 0, z0])
                rotate([0, 90, 0])
                    linear_extrude(height = bore + 2 * eps, center = true)
                        polygon(points = [
                            [barb_od1, -barb_h1 / 2],
                            [barb_od2,  barb_h1 / 2],
                            [barb_od1,  barb_h1 / 2]
                        ]);
        // collar
        translate([0, 0, z1])
            cylinder(d = collar_d, h = collar_h);
        // 5 mm tubing barbs (shrinking profile)
        for (s = [-1, 1])
            translate([0, 0, z2])
                rotate([0, 90, 0])
                    linear_extrude(height = bore + 2 * eps, center = true)
                        polygon(points = [
                            [barb_od3, -barb_h2 / 2],
                            [barb_od4,  barb_h2 / 2],
                            [barb_od3,  barb_h2 / 2]
                        ]);
    }
    // through-bore
    translate([0, 0, z0 - eps])
        rotate([0, 90, 0])
            linear_extrude(height = z3 - z0 + 2 * eps, center = true)
                circle(d = bore);
}