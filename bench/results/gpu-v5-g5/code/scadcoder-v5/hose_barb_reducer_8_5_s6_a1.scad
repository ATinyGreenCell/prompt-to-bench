// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y
// Units: mm

// ---------------- Parameters ----------------
// Tubing inner diameters
tubing_id_8   = 8;    // larger tubing (8 mm ID)
tubing_id_5   = 5;    // smaller tubing (5 mm ID)

// Barb dimensions (8 mm tubing side)
barb_h_8      = 10;   // height of each 8 mm tubing barb
barb_od_8_bot = 7.5;  // outer diameter of 8 mm barb at its bottom
barb_od_8_top = 9.5;  // outer diameter of 8 mm barb at its top

// Collar dimensions
collar_h      = 5;    // height of the 12 mm cylindrical collar (z = 20 to 25)
collar_od     = 12;   // outer diameter of the collar

// Barb dimensions (5 mm tubing side)
barb_h_5      = 8;    // height of each 5 mm tubing barb
barb_od_5_bot = 6.5;  // outer diameter of 5 mm barb at its bottom
barb_od_5_top = 5.0;  // outer diameter of 5 mm barb at its top

// Bore
bore_d        = 3;    // diameter of the through-bore

// Derived / helper values
eps           = 0.5;  // overshoot for clean boolean cuts
sawtooth_d    = 8.5;  // diameter of the "teeth" that form the sawtooth profile

// ---------------- Model ----------------
difference() {
    union() {
        // ---- 8 mm tubing side (z = 0 to 20) ----
        for (i = [0 : 1]) {
            translate([0, 0, i * barb_h_8])
                linear_extrude(height = barb_h_8)
                    circle(d = sawtooth_d, $fn = 64);
        }

        // ---- Collar (z = 20 to 25) ----
        translate([0, 0, 20])
            cylinder(h = collar_h, d = collar_od, $fn = 64);

        // ---- 5 mm tubing side (z = 25 to 41) ----
        for (i = [0 : 1]) {
            translate([0, 0, 25 + i * barb_h_5])
                linear_extrude(height = barb_h_5)
                    circle(d = sawtooth_d, $fn = 64);
        }
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore_d, $fn = 64);
}