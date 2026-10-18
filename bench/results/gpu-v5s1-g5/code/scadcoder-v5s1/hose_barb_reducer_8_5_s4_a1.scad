// Hose-barb reducer: joins 8 mm and 5 mm silicone tubing
// Print orientation: standing upright along +Z

// ---------- Parameters ----------
t8_d      = 8;     // 8 mm tubing inner diameter
t5_d      = 5;     // 5 mm tubing inner diameter
bore_d    = 3;     // through-bore diameter
z_start   = 0;     // bottom of part
z_barb8   = 20;    // top of 8 mm barbs
z_collar  = 25;    // top of collar
z_barb5   = 41;    // top of 5 mm barbs
barb_h8   = 10;    // 8 mm barb height
barb_h5   = 8;     // 5 mm barb height
od8_bot   = 7.5;   // 8 mm barb outer diameter at bottom
od8_top   = 9.5;   // 8 mm barb outer diameter at top step
od5_bot   = 6.5;   // 5 mm barb outer diameter at bottom
od5_top   = 5.0;   // 5 mm barb outer diameter at top step
eps       = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Derived ----------
l8 = z_barb8 - z_start;        // 8 mm section length
l5 = z_barb5 - z_collar;       // 5 mm section length

// ---------- Model ----------
difference() {
    union() {
        // 8 mm barbs (sawtooth profile)
        for (i = [0 : 1])
            translate([0, 0, z_start + i * barb_h8])
                linear_extrude(height = barb_h8)
                    circle(d = od8_bot + (od8_top - od8_bot) * (eps + 0.01));

        // collar
        translate([0, 0, z_barb8])
            cylinder(d = 12, h = z_collar - z_barb8);

        // 5 mm barbs (tapered profile)
        for (i = [0 : 1])
            translate([0, 0, z_collar + i * barb_h5])
                linear_extrude(height = barb_h5)
                    circle(d = od5_bot + (od5_top - od5_bot) * (eps + 0.01));
    }

    // cutters
    translate([0, 0, z_start - eps])
        cylinder(d = bore_d, h = z_barb5 - z_start + 2 * eps);

    for (i = [0 : 1])
        translate([0, 0, z_start + i * barb_h8 + 0.01])
            cylinder(d = t8_d, h = barb_h8 + 0.02);

    for (i = [0 : 1])
        translate([0, 0, z_collar + i * barb_h5 + 0.01])
            cylinder(d = t5_d, h = barb_h5 + 0.02);
}