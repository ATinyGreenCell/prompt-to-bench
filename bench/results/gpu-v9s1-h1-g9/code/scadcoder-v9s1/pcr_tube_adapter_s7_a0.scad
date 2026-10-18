// PCR tube adapter sleeve for 1.5 mL rack holes
// Print orientation: collar on bed (z = 0), sleeve body rises to z = 21.5

$fn = 64;

// --- Dimensions (mm) ---
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_h      = 20;    // sleeve body height (z = 1.5 to 21.5)
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

total_h = collar_h + sleeve_h; // 21.5 mm overall height

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlapping the collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_h + 0.01);
    }
    // Straight through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}