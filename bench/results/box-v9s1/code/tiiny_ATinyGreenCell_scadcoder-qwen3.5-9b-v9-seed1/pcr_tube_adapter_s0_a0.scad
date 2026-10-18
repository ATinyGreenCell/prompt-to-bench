// PCR tube adapter sleeve - prints upside down
// Units: mm

$fn = 64;

// --- Dimensions ---
collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;  // sleeve body outer diameter
sleeve_top_z  = 21.5;  // top of sleeve body
bore_d        = 6.2;   // through-bore diameter
eps           = 0.5;   // cutter overshoot past faces

// Derived
sleeve_h = sleeve_top_z - collar_h;  // body height between collar and top

difference() {
    union() {
        // Collar
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (overlaps collar slightly to fuse solidly)
        translate([0, 0, collar_h - 0.01])
            cylinder(d = sleeve_od, h = sleeve_h + 0.01);
    }
    // Straight through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = sleeve_top_z + eps);
}