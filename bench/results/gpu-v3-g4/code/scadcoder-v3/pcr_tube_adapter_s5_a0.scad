// Adapter sleeve: lets a 0.2 mL PCR tube sit in a rack hole made for 1.5 mL tubes
// Print orientation: upside down, collar on the bed (z = 0), sleeve rising to z = 21.5

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
total_h       = 21.5;  // overall height (top of sleeve)
bore_d        = 6.2;   // straight through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

difference() {
    union() {
        // Collar lying on the bed
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body rising from the collar (overlaps collar slightly for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = total_h - collar_h + 0.01);
    }
    // Straight bore through the full height, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}