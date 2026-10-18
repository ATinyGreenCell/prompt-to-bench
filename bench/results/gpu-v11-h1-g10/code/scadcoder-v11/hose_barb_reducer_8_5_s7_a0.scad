// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
bore      = 3;    // through-bore diameter (mm)
eps       = 0.5;  // cutter overshoot past faces (mm)

// Lower section (z = 0 .. 20): 8 mm tubing barbs
z_barb_a  = 20;   // height of lower barbs (mm)
d_barb_a  = 7.5;  // outer diameter of lower barbs at bottom (mm)
d_barb_t  = 9.5;  // outer diameter of lower barbs at top (mm)
n_barb_a  = 2;    // number of lower barbs, stacked

// Collar (z = 20 .. 25)
z_collar  = 5;    // collar thickness (mm)
d_collar  = 12;   // collar outer diameter (mm)

// Upper section (z = 25 .. 41): 5 mm tubing barbs
z_barb_b  = 16;   // height of upper barbs (mm)
d_barb_c  = 6.5;  // outer diameter of upper barbs at bottom (mm)
d_barb_d  = 5.0;  // outer diameter of upper barbs at top (mm)
n_barb_b  = 2;    // number of upper barbs, stacked

total_h   = z_barb_a + z_collar + z_barb_b;  // 41 mm overall

// ---------------- Model ----------------
difference() {
    union() {
        // Lower barbs: sawtooth profile, extended above collar for a clean union
        for (i = [0 : n_barb_a - 1])
            translate([0, 0, i * z_barb_a / (n_barb_a - 1)])
                linear_extrude(height = z_barb_a + 0.01)
                    polygon(points = [
                        [-d_barb_a / 2, 0],
                        [ d_barb_t / 2, z_barb_a * 0.5],
                        [ d_barb_a / 2, z_barb_a]
                    ]);

        // Collar
        translate([0, 0, z_barb_a])
            cylinder(h = z_collar, d = d_collar);

        // Upper barbs: sawtooth profile, extended below collar for a clean union
        for (i = [0 : n_barb_b - 1])
            translate([0, 0, z_barb_a + z_collar + i * z_barb_b / (n_barb_b - 1)])
                linear_extrude(height = z_barb_b + 0.01)
                    polygon(points = [
                        [-d_barb_c / 2, 0],
                        [ d_barb_d / 2, z_barb_b * 0.5],
                        [ d_barb_c / 2, z_barb_b]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = bore);
}