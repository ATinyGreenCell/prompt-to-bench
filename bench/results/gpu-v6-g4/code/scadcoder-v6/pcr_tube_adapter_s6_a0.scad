// PCR tube adapter sleeve - print upside down
// Units: mm

$fn = 96;

// --- Dimensions ---
collar_d      = 13;    // collar outer diameter (on bed)
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve outer diameter
sleeve_h      = 20;    // sleeve body height above collar (z = 1.5 to 21.5)
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

total_h = collar_h + sleeve_h;  // full height (21.5)

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlapping into collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_h + 0.01);
    }
    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}