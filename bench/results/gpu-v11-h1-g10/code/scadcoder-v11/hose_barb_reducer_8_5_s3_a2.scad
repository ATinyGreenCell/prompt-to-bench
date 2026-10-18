// Hose-barb reducer: 8 mm tubing (barb) to 5 mm tubing (barb)
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
t1_od     = 8;    // outer diameter of 8 mm tubing
t2_od     = 5;    // outer diameter of 5 mm tubing
bore      = 3;    // through-bore diameter
flange    = 1.5;  // flare at end of a barb

lz        = 20;   // length of 8 mm barb section
collar    = 5;    // length of collar section
rz        = 8;    // length of 5 mm barb section

// ---- Derived ----
inner_r   = bore / 2;
flange_r  = t1_od / 2 + flange;
collar_d  = t2_od + flange;

// ---- Model ----
difference() {
    union() {
        // 8 mm barb
        rotate_extrude() translate([0, 0, lz])
            circle(r = flange_r);
        translate([0, 0, -lz])
            cylinder(h = lz, r = t1_od / 2);

        // collar
        translate([0, 0, lz])
            cylinder(h = collar, d = collar_d);

        // 5 mm barb
        translate([0, 0, lz + collar])
            cylinder(h = rz, r = t2_od / 2);
    }
    // through bore
    translate([0, 0, -1])
        cylinder(h = lz + collar + rz + 2, r = inner_r);
}