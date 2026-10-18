// PCR tube adapter sleeve - fits 0.2 mL tubes into 1.5 mL rack holes
// Print orientation: collar on bed (z = 0), sleeve body rises to z = 21.5

// ---------------- Parameters ----------------
tube_od        = 10.8;   // outer diameter of sleeve body (mm)
collar_d       = 13;     // outer diameter of base collar (mm)
collar_h       = 1.5;    // collar thickness (mm), z = 0 to 1.5
sleeve_h       = 21.5;   // top of sleeve body (mm)
bore_d         = 6.2;    // through-bore diameter (mm)
eps            = 0.5;    // cutter overshoot past faces (mm)
$fn            = 96;     // curve resolution

sleeve_body_h  = sleeve_h - collar_h;  // body height above collar (20 mm)

// ---------------- Model ----------------
difference() {
    union() {
        // Base collar, z = 0 to 1.5
        cylinder(d = collar_d, h = collar_h);

        // Sleeve body, z = 1.5 to 21.5 (slight overlap into collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = tube_od, h = sleeve_body_h + 0.01);
    }

    // Straight through-bore, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_h + 2 * eps);
}