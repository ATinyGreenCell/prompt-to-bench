// Adapter sleeve: 0.2 mL PCR tube for a 1.5 mL rack hole
// Print orientation: collar on the bed (z = 0), sleeve body on top

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body (absolute z)
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

bore_h        = sleeve_top_z - collar_h;  // bore height in sleeve body

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (from top of collar to top)
        translate([0, 0, collar_h])
            cylinder(d = sleeve_od, h = bore_h + 0.01);
    }
    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_h + 2 * eps);
}