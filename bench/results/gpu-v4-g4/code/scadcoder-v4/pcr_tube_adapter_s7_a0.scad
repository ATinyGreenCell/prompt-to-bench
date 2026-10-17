// PCR tube adapter sleeve: fits a 0.2 mL tube in a 1.5 mL rack hole
// Print orientation: collar on bed (z = 0), sleeve body rises to z = 21.5

// ---------------- Parameters ----------------
collar_d      = 13;    // collar outer diameter (mm)
collar_t      = 1.5;   // collar thickness (mm)
sleeve_d      = 10.8;  // sleeve body outer diameter (mm)
sleeve_h      = 20;    // sleeve body height (mm), top at z = 21.5
bore_d        = 6.2;   // through-bore diameter (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 96;    // curve resolution

// Derived
sleeve_r = sleeve_d / 2;
collar_r = collar_d / 2;

// ---------------- Model ----------------
difference() {
    union() {
        // Collar: z = 0 to 1.5
        cylinder(r = collar_r, h = collar_t);

        // Sleeve body: z = 1.5 to 21.5 (slight overlap into collar for clean union)
        translate([0, 0, collar_t - 0.01])
            cylinder(r = sleeve_r, h = sleeve_h + 0.01);
    }

    // Straight through-bore, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = collar_t + sleeve_h + 2 * eps);
}