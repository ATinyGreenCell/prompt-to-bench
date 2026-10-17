// Funnel with spout - printed upright, wide opening at top
// Units: mm. Wall thickness 1.6 mm throughout.

// ---------- Parameters ----------
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_top_d    = 60;    // cone rim outer diameter at z = 50
cone_bottom_d = 10;    // cone starts at same diameter as spout (z = 20)
rim_height    = 30;    // cone height, so rim at z = 20 + 30 = 50
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
spout_id = spout_od - 2 * wall;   // bore of spout (6.8 mm)
cone_top_id = cone_top_d - 2 * wall;  // rim inner diameter (56.8 mm)

// ---------- Model ----------
union() {
    // Spout: tube from z = 0 to z = 20
    difference() {
        cylinder(d = spout_od, h = spout_length);
        translate([0, 0, -eps])
            cylinder(d = spout_id, h = spout_length + 2 * eps);
    }

    // Cone: widens from 10 mm (z = 20) to 60 mm (z = 50)
    difference() {
        cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = rim_height, $fn = 64);
        translate([0, 0, spout_length - eps])
            cylinder(d1 = cone_bottom_d - 2 * wall - 0.01,
                     d2 = cone_top_id + 0.01,
                     h = rim_height + 2 * eps,
                     $fn = 64);   // open-mouthed cone through z = 50
    }
}