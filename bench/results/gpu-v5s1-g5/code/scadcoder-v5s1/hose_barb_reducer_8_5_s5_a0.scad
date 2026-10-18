// Hose-barb reducer: joins 8 mm and 5 mm silicone tubing
// Print orientation: standing upright along +Z

// ---------------- Parameters ----------------
t8_d      = 8;     // 8 mm tubing inner diameter
t5_d      = 5;     // 5 mm tubing inner diameter
bore_d    = 3;     // through-bore diameter
z0        = 0;     // start of 8 mm section
z20       = 20;    // end of 8 mm section / start of collar
z25       = 25;    // end of collar / start of 5 mm section
z41       = 41;    // end of 5 mm section

// 8 mm barbs
b8_h      = 10;    // barb height
b8_d0     = 7.5;   // barb outer diameter at bottom
b8_d1     = 9.5;   // barb outer diameter at top

// Collar
c_d       = 12;    // collar diameter

// 5 mm barbs
b5_h      = 8;     // barb height
b5_d0     = 6.5;   // barb outer diameter at bottom
b5_d1     = 5.0;   // barb outer diameter at top

// ---------------- Helpers ----------------
eps       = 0.5;   // overshoot for clean boolean cuts

function barb_d(z, d0, d1, h) {
    // sawtooth: linear growth, then step back
    t = (z - (h - 0.01)) / h;   // 0 <= t <= 1 within the barb
    return d0 + (d1 - d0) * t;
}

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing section (z = 0 .. 20)
        for (s = [0, 1])
            translate([0, 0, z0 + s * b8_h])
                cylinder(h = b8_h + 0.01,
                          d = barb_d(z0 + s * b8_h, b8_d0, b8_d1, b8_h));

        // Cylindrical collar (z = 20 .. 25)
        translate([0, 0, z20])
            cylinder(h = z25 - z20 + 0.01, d = c_d);

        // 5 mm tubing section (z = 25 .. 41)
        for (s = [0, 1])
            translate([0, 0, z25 + s * b5_h])
                cylinder(h = b5_h + 0.01,
                          d = barb_d(z25 + s * b5_h, b5_d0, b5_d1, b5_h));
    }

    // Central through-bore
    translate([0, 0, -eps])
        cylinder(h = z41 - z0 + 2 * eps, d = bore_d);
}