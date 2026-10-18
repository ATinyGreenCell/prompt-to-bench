// PCR tube adapter sleeve: fits a 0.2 mL tube into a 1.5 mL rack hole
// Print orientation: collar on the bed (z = 0), sleeve body rises to z = 21.5

// ---------------- Parameters ----------------
collar_d      = 13;    // collar outer diameter (mm)
collar_h      = 1.5;   // collar thickness (mm)
sleeve_od     = 10.8;  // sleeve body outer diameter (mm)
sleeve_h      = 20;    // sleeve body height above collar (mm)
bore_d        = 6.2;   // through-bore diameter (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;              // facet count for round features

// ---------------- Derived ----------------
sleeve_top_z   = collar_h + sleeve_h;   // 21.5 mm overall height
sleeve_id      = sleeve_od - bore_d;    // inner diameter of sleeve body
collar_id      = collar_d - bore_d;     // inner diameter of collar

// ---------------- Model ----------------
difference() {
    union() {
        // Collar: rests on z = 0, extends to collar_h
        cylinder(d = collar_d, h = collar_h);

        // Sleeve body: sits on top of the collar, runs from collar_h to sleeve_top_z
        translate([0, 0, collar_h])
            cylinder(d = sleeve_od, h = sleeve_h);
    }

    // Through-bore: starts below z = 0 and ends above sleeve_top_z,
    // so it is open at both ends and cuts cleanly through every face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_top_z + 2 * eps);
}