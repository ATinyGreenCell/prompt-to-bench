// PCR tube adapter sleeve - fits a 0.2 mL tube in a 1.5 mL rack hole
// Print orientation: collar on the bed (z = 0), sleeve body builds upward.

// ---------- Dimensions (mm) ----------
collar_d        = 13;     // collar outer diameter
collar_t        = 1.5;    // collar thickness (z = 0 to 1.5)
sleeve_od       = 10.8;   // sleeve outer diameter
sleeve_h        = 20;     // sleeve body height above collar (z = 1.5 to 21.5)
bore_d          = 6.2;    // through-bore diameter
eps             = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Collar: disc on the bed, centred in XY
        cylinder(d = collar_d, h = collar_t);

        // Sleeve body: tube rising from the top face of the collar
        translate([0, 0, collar_t])
            cylinder(d = sleeve_od, h = sleeve_h);
    }

    // Straight bore through the full height, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_h + collar_t + 2 * eps);
}