// Tubing barbed hose coupler (reducer): joins two round tubing lines side by side,
// with a through-bore to pass fluid or wire from end to end. NOVEL general part.
//

// ---------------- Parameters ----------------
t1_id   = 8;     // inner diameter of the first (larger) tubing
t2_id   = 5;     // inner diameter of the second (smaller) tubing
length  = 41;    // total length of the coupler along Z
bore    = 3;     // diameter of the straight through-bore
eps     = 0.5;   // overshoot for clean boolean cuts

$fn = 96;

// Barb dimensions
b1_h = 10;        // height of each barb on the larger tubing
b1_d = 8.5;       // outer diameter of each barb on the larger tubing
b2_h = 8;         // height of each barb on the smaller tubing
b2_d = 5.5;       // outer diameter of each barb on the smaller tubing

// ---------------- Model ----------------
difference() {
    union() {
        // Larger tubing section (z = 0 to 20)
        for (i = [0 : 1])
            translate([0, 0, i * b1_h])
                cylinder(h = b1_h, d1 = b1_d, d2 = b1_d - 2 * eps);

        // Smaller tubing section (z = 25 to 41)
        for (i = [0 : 1])
            translate([0, 0, 25 + i * b2_h])
                cylinder(h = b2_h, d1 = b2_d, d2 = b2_d - 2 * eps);

        // Central cylindrical collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(h = 5, d = 12);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = length + 2 * eps, d = bore);
}