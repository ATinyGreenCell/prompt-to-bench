// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
bore      = 3;    // through-bore diameter (mm)
eps       = 0.5;  // cutter overshoot past faces (mm)

// Lower section (z = 0 .. 20): 8 mm tubing barbs
z_barb_a  = 20;   // height of lower barbs (mm)
d_barb_a  = 8;    // tubing inner diameter (mm)
d_barb_o  = 9.5;  // outer diameter at top of barb (mm)
d_barb_b  = 7.5;  // outer diameter at bottom of barb / after step (mm)

// Collar (z = 20 .. 25)
z_collar  = 5;    // collar height (mm)
d_collar  = 12;   // collar outer diameter (mm)

// Upper section (z = 25 .. 41): 5 mm tubing barbs
z_barb_c  = 41;   // top of upper barbs (mm)
d_barb_d  = 5;    // tubing inner diameter (mm)
d_barb_e  = 6.5;  // outer diameter at bottom of barb / after step (mm)
d_barb_f  = 5.0;  // outer diameter at top of barb (mm)

n_barbs   = 2;    // number of barbs, stacked

// ---------------- Model ----------------
difference() {
    union() {
        // Lower barbs
        for (i = [0 : n_barbs - 1]) {
            translate([0, 0, i * z_barb_a / n_barbs])
                cylinder(h = z_barb_a / n_barbs,
                         d1 = d_barb_b,
                         d2 = d_barb_o,
                         $fn = 96);
        }

        // Collar
        translate([0, 0, z_barb_a])
            cylinder(h = z_collar, d = d_collar, $fn = 96);

        // Upper barbs
        for (i = [0 : n_barbs - 1]) {
            translate([0, 0, z_barb_a + z_collar + i * z_barb_c / n_barbs])
                cylinder(h = z_barb_c / n_barbs,
                         d1 = d_barb_e,
                         d2 = d_barb_f,
                         $fn = 96);
        }
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = z_barb_c + 2 * eps, d = bore, $fn = 64);
}