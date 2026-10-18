// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
t8_od      = 9.5;   // 8 mm tubing barb outer diameter (top)
t8_base    = 7.5;   // 8 mm tubing barb outer diameter (bottom)
t8_h       = 10;    // 8 mm tubing barb height
t8_steps   = 2;     // number of 8 mm barbs, stacked

t5_od      = 5.0;   // 5 mm tubing barb outer diameter (top)
t5_base    = 6.5;   // 5 mm tubing barb outer diameter (bottom)
t5_h       = 8;     // 5 mm tubing barb height
t5_steps   = 2;     // number of 5 mm barbs, stacked

collar_d   = 12;    // collar diameter
collar_z0  = 20;    // collar bottom (z)
collar_z1  = 25;    // collar top (z)

bore       = 3;     // through-bore diameter

total_h    = t8_h + collar_z1 - collar_z0 + t5_h;  // 41 mm

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs
        for (i = [0 : t8_steps - 1])
            translate([0, 0, i * t8_h])
                cylinder(h = t8_h, d1 = t8_base, d2 = t8_od);

        // collar
        translate([0, 0, collar_z0])
            cylinder(h = collar_z1 - collar_z0, d = collar_d);

        // 5 mm barbs
        for (i = [0 : t5_steps - 1])
            translate([0, 0, collar_z1 + i * t5_h])
                cylinder(h = t5_h, d1 = t5_base, d2 = t5_od);
    }

    // through-bore
    translate([0, 0, -1])
        cylinder(h = total_h + 2, d = bore);
}