// Funnel with spout - printed upright, wide opening at top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Spout ----
spout_od     = 10;    // spout outer diameter
spout_bore   = spout_od - 2 * 1.6;  // bore = 6.8 mm
spout_len    = 20;    // spout length (z = 0 to 20)

// ---- Cone ----
cone_top_d   = 60;    // rim outer diameter at top
cone_bottom_d = spout_od;  // cone starts at spout diameter (z = 20)
cone_h       = cone_top_d - cone_bottom_d;  // cone height = 40 (z = 20 to 50)

// ---- Misc ----
eps          = 0.5;   // cutter overshoot past faces

// Combine spout and cone in one hull, then cut the bore through the full length
difference() {
    union() {
        cylinder(h = spout_len, d = spout_od);                 // spout body
        cylinder(h = cone_h, d1 = spout_od, d2 = cone_top_d);  // cone (no floor)
    }
    translate([0, 0, -eps])
        cylinder(h = spout_len + cone_h + 2 * eps, d = spout_bore);  // through-bore
}