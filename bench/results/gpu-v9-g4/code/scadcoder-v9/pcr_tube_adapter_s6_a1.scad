// PCR tube adapter sleeve - fits 0.2 mL tubes into 1.5 mL rack holes
// Print orientation: collar on bed (z = 0), sleeve body rises to z = 21.5

$fn = 64;

// --- Dimensions (mm) ---
tube_od        = 10.8;   // sleeve outer diameter
collar_d       = 13;     // collar diameter
collar_h       = 1.5;    // collar thickness
sleeve_h       = 21.5;   // total height of sleeve body from top of collar
bore_d         = 6.2;    // through-bore diameter
eps            = 0.5;    // cutter overshoot past faces

total_h = sleeve_h + collar_h;  // 23 mm overall height

difference() {
    union() {
        // Collar (z = 0 to 1.5)
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (z = 1.5 to 21.5)
        translate([0, 0, collar_h])
            cylinder(d = tube_od, h = sleeve_h);
    }
    // Full-length bore, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}