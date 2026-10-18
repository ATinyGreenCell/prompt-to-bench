// Lab funnel - printed upright with wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Dimensions ----
spout_od        = 10;    // outer diameter of straight spout
spout_id        = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h         = 20;    // spout height, z = 0 .. 20

cone_bottom_od  = spout_od;       // cone starts at spout diameter
cone_top_od     = 60;    // cone rim diameter
cone_h          = spout_h + 30;   // cone height, z = 20 .. 50

eps             = 0.5;   // overlap for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, d = spout_od);

        // Cone (extended slightly into spout to fuse solids)
        translate([0, 0, spout_h - eps])
            cylinder(h = cone_h + eps, d1 = cone_bottom_od, d2 = cone_top_od);
    }

    // Bottom outlet
    translate([0, 0, -eps])
        cylinder(h = eps + 1, d = spout_id);

    // Top rim cut (open top)
    translate([0, 0, spout_h + cone_h])
        cylinder(h = eps + 1, d = cone_top_od - 1);
}