// PCR tube adapter sleeve: 0.2 mL tube in a 1.5 mL rack hole
// Print orientation: collar on the bed, sleeve body rising upward

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body (z)
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

total_h = sleeve_top_z; // overall height (21.5)

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (overlaps slightly into collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = total_h - collar_h + 0.01);
    }
    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}