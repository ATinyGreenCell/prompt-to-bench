// PCR tube adapter sleeve - print upside down
// Units: mm

// ---- Dimensions ----
collar_d        = 13;    // collar outer diameter
collar_t        = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od       = 10.8;  // sleeve outer diameter
sleeve_h        = 20;    // sleeve body height above collar (z = 1.5 to 21.5)
bore_d          = 6.2;   // straight through-bore diameter
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
union() {
    // Collar lying on the bed
    cylinder(d = collar_d, h = collar_t);

    // Sleeve body rising from the collar top
    translate([0, 0, collar_t])
        cylinder(d = sleeve_od, h = sleeve_h);
}

// Full-height bore, open at both ends
translate([0, 0, -eps])
    cylinder(d = bore_d, h = collar_t + sleeve_h + 2 * eps);