// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

// ---- Parameters ----
eps      = 0.5;   // overcut for clean differences
$fn      = 96;    // smoothness of curved surfaces

tube_d1  = 8;     // inner diameter of large tubing
tube_d2  = 5;     // inner diameter of small tubing
bore     = 3;     // through-bore diameter

base_h   = 20;    // height of first barb section
collar_d = 12;    // diameter of joining collar
collar_h = 5;     // height of collar

top_h    = 8;     // height of second barb section
total_l  = base_h + collar_h + top_h;  // 41 mm overall length

// ---- Derived ----
r_bore = bore / 2;
r_c1   = tube_d1 / 2 + 0.5;              // outer radius, growing
r_c2   = tube_d2 / 2 + 0.5;              // outer radius, shrinking

// ---- Model ----
difference() {
    union() {
        // Sawtooth barbs 1 (8 mm tubing)
        for (z = [0 : base_h - 1])
            translate([0, 0, z])
                cylinder(h = 1, d = 7.5 + 0.5 * z / base_h);

        // Collar
        translate([0, 0, base_h])
            cylinder(h = collar_h, d = collar_d);

        // Sawtooth barbs 2 (5 mm tubing)
        for (z = [0 : top_h - 1])
            translate([0, 0, base_h + collar_h + z])
                cylinder(h = 1, d = 6.5 - 0.5 * z / top_h);
    }

    // Full-length bore
    translate([0, 0, -eps])
        cylinder(h = total_l + 2 * eps, d = bore);
}