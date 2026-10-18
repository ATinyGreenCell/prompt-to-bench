// PCR tube adapter sleeve: 0.2 mL tube in a 1.5 mL rack hole
// Print orientation: collar on bed (z = 0), sleeve rises to z = 21.5

// ---- Dimensions (mm) ----
collar_d        = 13;    // collar outer diameter
collar_h        = 1.5;   // collar thickness
sleeve_od       = 10.8;  // sleeve outer diameter
sleeve_top_z    = 21.5;  // top of sleeve body
bore_d          = 6.2;   // through-bore diameter
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlapping collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_top_z - collar_h + 0.01);
    }
    // Full-height bore, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_top_z + 2 * eps);
}