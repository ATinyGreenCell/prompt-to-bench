// Lab funnel - printed upright with wide opening at top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter (z = 0 to 20)
spout_h       = 20;    // spout height
cone_od_top   = 60;    // cone outer diameter at rim (z = 50)
cone_od_base  = 10;    // cone outer diameter where it meets spout (z = 20)
cone_h        = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness
eps           = 0.5;   // cutter overshoot past faces

// Derived
bore = spout_od - 2 * wall;   // spout bore = 6.8 mm

difference() {
    union() {
        // Spout tube
        cylinder(d = spout_od, h = spout_h);
        // Cone: r at z = 20 is 5, at z = 50 is 30
        translate([0, 0, spout_h])
            cylinder(h = cone_h, d1 = cone_od_base, d2 = cone_od_top);
    }
    // Through-bore along Z from bottom to top rim
    translate([0, 0, -eps])
        cylinder(h = spout_h + cone_h + 2 * eps, d = bore);
}