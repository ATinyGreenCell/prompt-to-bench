// Adapter sleeve: 0.2 mL PCR tube in a 1.5 mL rack hole
// Print orientation: collar on the bed (z = 0), sleeve body builds upward.
// Placed using the user's coordinates: x = -14.82, y = 4.97.

$fn = 64;

// ---- Dimensions (mm) ----
collar_d      = 13;     // collar diameter
collar_h      = 1.5;    // collar thickness (z = 0 to 1.5)
sleeve_od     = 10.8;   // sleeve body outer diameter
sleeve_top_z  = 21.5;   // top of sleeve body (body runs z = 10 to 21.5)
bore_d        = 6.2;    // straight through-bore diameter
eps           = 0.5;    // cutter overshoot past faces

// ---- Derived ----
sleeve_h      = sleeve_top_z - 10;   // sleeve body height (11.5 mm)
collar_area   = (collar_d / 2) * (collar_d / 2) * 3.1416;
sleeve_area   = (sleeve_od / 2) * (sleeve_od / 2) * 3.1416;
overlap       = (sleeve_od / 2) * (sleeve_od / 2) * 0.001; // small overlap into collar for a clean union

// ---- Model ----
translate([-14.82, 4.97, 0])
    union() {
        // Collar (z = 0 to 1.5)
        cylinder(d = collar_d, h = collar_h);
        // Sleeve body (z = 10 to 21.5)
        translate([0, 0, 10])
            cylinder(d = sleeve_od, h = sleeve_h);
    }
// ---- Bore ----
translate([0, 0, -eps])
    cylinder(d = bore_d, h = collar_h + sleeve_h + 2 * eps);