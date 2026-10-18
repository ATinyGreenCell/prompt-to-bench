// Adapter sleeve: 0.2 mL PCR tube fits into a 1.5 mL tube rack hole
// Print orientation: collar on the bed, sleeve body pointing up (+Z)

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body (absolute Z)
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

total_h = sleeve_top_z; // overall height (21.5 mm)

difference() {
    union() {
        // Collar: disc from z = 0 to z = 1.5
        cylinder(d = collar_d, h = collar_h);

        // Sleeve body: tube from top of collar up to z = 21.5
        translate([0, 0, collar_h])
            cylinder(d = sleeve_od, h = total_h - collar_h);
    }

    // Straight bore through the full height, open at both ends
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}