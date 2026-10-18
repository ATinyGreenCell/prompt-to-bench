// Adapter sleeve: 0.2 mL PCR tube in a 1.5 mL rack hole
// Print orientation: collar down on the bed (z = 0), sleeve up (+Z)

$fn = 128;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar diameter (bottom)
collar_h      = 1.5;   // collar thickness
sleeve_od     = 10.8;  // sleeve outer diameter
sleeve_top_z  = 21.5;  // top of sleeve
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlapping collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_top_z - collar_h + 0.01);
    }
    // Full-height bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_top_z + 2 * eps);
}