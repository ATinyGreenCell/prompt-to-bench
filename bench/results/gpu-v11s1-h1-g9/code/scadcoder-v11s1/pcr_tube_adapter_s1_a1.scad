// Adapter sleeve: 0.2 mL PCR tube for 1.5 mL tube rack
// Print orientation: collar on bed (z = 0), sleeve body upward

$fn = 64;

// --- Dimensions (mm) ---
collar_d      = 13;    // collar diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot

total_h = sleeve_top_z - collar_h; // body height (20)

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (slightly overlaps collar for a clean union)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = total_h + 0.01);
    }
    // Full-height bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}