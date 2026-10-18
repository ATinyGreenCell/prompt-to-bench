// Hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
bore       = 3;    // through-bore diameter (mm)
eps        = 0.5;  // cutter overshoot past faces (mm)

// Lower section (z = 0 .. 20): 8 mm tubing barbs
z_barb_a   = 20;   // height of lower barbs (mm)
outer_a    = [7.5, 9.5]; // outer diameter at bottom and top of barb (mm)
n_barb_a   = 2;    // number of barbs, stacked

// Collar (z = 20 .. 25)
z_collar   = 5;    // collar thickness (mm)
d_collar   = 12;   // collar outer diameter (mm)

// Upper section (z = 25 .. 41): 5 mm tubing barbs
z_barb_b   = 16;   // height of upper barbs (mm)
outer_b    = [6.5, 5.0]; // outer diameter at bottom and top of barb (mm)
n_barb_b   = 2;    // number of barbs, stacked

total_h    = z_barb_a + z_collar + z_barb_b; // = 41 mm

$fn = 96;          // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Lower barbs
        for (i = [0 : n_barb_a - 1])
            translate([0, 0, i * z_barb_a / n_barb_a])
                linear_extrude(height = z_barb_a / n_barb_a)
                    polygon(points = [
                        [-outer_a[0] / 2, 0],
                        [ outer_a[0] / 2, 0],
                        [ outer_a[1] / 2, 0],
                        [0, outer_a[1] / 2],
                        [0, -outer_a[1] / 2]
                    ]);

        // Collar
        translate([0, 0, z_barb_a])
            cylinder(h = z_collar, d = d_collar);

        // Upper barbs
        for (i = [0 : n_barb_b - 1])
            translate([0, 0, z_barb_a + z_collar + i * z_barb_b / n_barb_b])
                linear_extrude(height = z_barb_b / n_barb_b)
                    polygon(points = [
                        [-outer_b[0] / 2, 0],
                        [ outer_b[0] / 2, 0],
                        [ outer_b[1] / 2, 0],
                        [0, outer_b[1] / 2],
                        [0, -outer_b[1] / 2]
                    ]);
    }

    // Full-length through-bore
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = bore);
}