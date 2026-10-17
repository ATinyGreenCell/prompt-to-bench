// PCR tube adapter sleeve: sits in a 1.5 mL rack hole and cradles a 0.2 mL tube
// Print orientation: collar on the bed (z = 0), sleeve body builds upward (+Z)

// ---------------- Parameters ----------------
collar_d        = 13;    // collar outer diameter (keeps the 1.5 mL hole)
collar_t        = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od       = 10.8;  // sleeve body outer diameter
sleeve_h        = 21.5;  // sleeve body height above the collar (z = 1.5 to 23.0)
bore_d          = 6.2;   // straight through-bore diameter (0.2 mL tube clearance)
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Collar: disc from z = 0 to 1.5
    cylinder(d = collar_d, h = collar_t);

    // Sleeve body: tube from z = 1.5 to 23.0 (10.8 mm OD, 6.2 mm bore)
    translate([0, 0, collar_t])
        cylinder(d = sleeve_od, h = sleeve_h, $fn = 96);
}

// Through-bore: open at both ends, extends eps above and below the part
translate([0, 0, -eps])
    cylinder(d = bore_d, h = sleeve_h + 2 * eps, $fn = 64);