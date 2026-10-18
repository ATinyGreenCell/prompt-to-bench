// Lab funnel - printed upright, wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Dimensions ----
spout_od     = 10;    // outer diameter of spout (and cone base)
spout_id     = spout_od - 2 * 1.6;  // spout bore = 6.8 mm
spout_h      = 20;    // spout height, z = 0 .. 20

cone_top_od  = 60;    // funnel rim outer diameter
cone_rim_h   = 50;    // rim height, z = 50
cone_h       = cone_rim_h - spout_h;  // cone height = 30 mm

eps          = 0.5;   // overlap for clean booleans

// ---- Model ----
difference() {
    union() {
        // Spout
        translate([0, 0, 0])
            cylinder(h = spout_h, d = spout_od);

        // Cone, slightly sunk into the spout so the union is one solid
        translate([0, 0, spout_h - eps])
            cylinder(h = cone_h + eps, d1 = spout_od, d2 = cone_top_od);
    }

    // Open bottom: cut a hole through the spout
    translate([0, 0, -eps])
        cylinder(h = spout_h + 2 * eps, d = spout_id);
}