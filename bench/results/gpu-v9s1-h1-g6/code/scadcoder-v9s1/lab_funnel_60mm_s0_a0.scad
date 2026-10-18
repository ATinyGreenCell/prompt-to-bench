// Lab funnel - printed upright, open at top and bottom
// Units: mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_od_top   = 60;    // cone rim outer diameter (z = 50)
cone_h        = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // bore diameter (6.8 mm)

// ---- Model ----
difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_h);
        // Cone, overlapped slightly into spout for a clean union
        translate([0, 0, spout_h - 0.01])
            cylinder(d1 = spout_od, d2 = cone_od_top, h = cone_h + 0.01);
    }
    // Through-bore: spout bore up to cone start, then cone tip to rim
    translate([0, 0, spout_h + 0.5])
        cylinder(d = cone_od_top * 0.8, h = cone_h - 0.5);   // tip at z = 29.5
    // Bottom cutter past spout base
    translate([0, 0, -eps])
        cylinder(d = spout_od, h = eps);
}