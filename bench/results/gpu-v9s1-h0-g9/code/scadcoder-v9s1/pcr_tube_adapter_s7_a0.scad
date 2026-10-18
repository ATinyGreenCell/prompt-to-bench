// PCR tube adapter sleeve: fits a 0.2 mL tube into a 1.5 mL rack hole
// Print orientation: collar on the bed, tube opening facing up

// ---- Dimensions (mm) ----
collar_d      = 13;     // collar outer diameter
collar_h      = 1.5;    // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;   // sleeve body outer diameter
sleeve_h      = 19.9;   // sleeve body height above collar (z = 1.5 to 21.4)
bore_d        = 6.2;    // straight through-bore diameter
eps           = 0.5;    // cutter overshoot past faces

$fn = 96;

total_h = collar_h + sleeve_h; // 21.4 mm top of sleeve

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlapping the collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_h + 0.01);
    }
    // Full-height bore, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}