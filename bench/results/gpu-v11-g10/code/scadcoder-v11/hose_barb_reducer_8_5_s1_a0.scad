// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
tube_d1      = 8;    // inner diameter of larger tubing
tube_d2      = 5;    // inner diameter of smaller tubing
bore_d       = 3;    // through-bore diameter
barb_h1      = 10;   // height of each 8 mm barb
barb_od1_bot = 7.5;  // outer diameter of 8 mm barb at bottom
barb_od1_top = 9.5;  // outer diameter of 8 mm barb at top
collar_d     = 12;   // collar diameter (z = 20 to 25)
barb_h2      = 8;    // height of each 5 mm barb
barb_od2_bot = 6.5;  // outer diameter of 5 mm barb at bottom
barb_od2_top = 5.0;  // outer diameter of 5 mm barb at top
eps          = 0.5;  // overlap for clean boolean cuts

// ---- Derived ----
z_barbs1 = 20;       // bottom of collar
z_barbs2 = 41;       // top of second barb set
overlap  = 0.01;     // small overlap between adjacent barbs

module barb1() {
    // Sawtooth profile in XZ, extruded around Z axis
    r_bot = barb_od1_bot / 2;
    r_top = barb_od1_top / 2;
    hull() {
        for (s = [-1, 1])
            translate([s * r_bot, 0, 0])
                linear_extrude(height = barb_h1, center = true)
                    circle(r = r_bot);
        translate([0, 0, barb_h1 - overlap])
            linear_extrude(height = overlap + 0.01, center = true)
                circle(r = r_top);
    }
}

module barb2() {
    // Shrinking sawtooth profile, stepped back out at the top
    r_bot = barb_od2_bot / 2;
    r_top = barb_od2_top / 2;
    hull() {
        for (s = [-1, 1])
            translate([s * r_bot, 0, 0])
                linear_extrude(height = barb_h2, center = true)
                    circle(r = r_bot);
        translate([0, 0, barb_h2])
            linear_extrude(height = 0.01, center = true)
                circle(r = r_top);
        translate([0, 0, barb_h2])
            linear_extrude(height = barb_h2 * 2 + 0.01, center = true)
                circle(r = r_bot);
    }
}

difference() {
    union() {
        for (i = [0, 1])
            translate([0, 0, i * (barb_h1 - overlap) + overlap])
                barb1();
        translate([0, 0, z_barbs1])
            cylinder(d = collar_d, h = 5);
        for (i = [0, 1])
            translate([0, 0, i * (barb_h2 - overlap) + overlap])
                barb2();
    }
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = z_barbs2 + 2 * eps);
}