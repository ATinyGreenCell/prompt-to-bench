// PCR tube adapter sleeve: fits in a 1.5 mL rack hole, holds a 0.2 mL tube
// Print orientation: collar on the bed (z = 0), sleeve body rises to z = 21.5

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body (absolute Z)
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