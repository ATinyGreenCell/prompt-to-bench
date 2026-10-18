// PCR tube adapter sleeve - print upside down
// Units: mm

$fn = 96;

// ---- Dimensions ----
collar_d        = 13;    // collar outer diameter
collar_t        = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od       = 10.8;  // sleeve outer diameter
sleeve_h        = 21.5;  // sleeve total height (z = 0 to 21.5)
bore_d          = 6.2;   // through-bore diameter
eps             = 0.5;   // cutter overshoot past faces

// ---- Model ----
union() {
    // Collar on the bed
    cylinder(d = collar_d, h = collar_t);

    // Sleeve body rising from the collar
    translate([0, 0, collar_t])
        cylinder(d = sleeve_od, h = sleeve_h - collar_t);
}

// Full-height bore, open at both ends
translate([0, 0, -eps])
    cylinder(d = bore_d, h = sleeve_h + 2 * eps);