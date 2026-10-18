// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout height (z = 0 to 20)
cone_od_top   = 60;    // funnel rim outer diameter (z = 50)
wall           = 1.6;   // wall thickness everywhere
eps            = 0.5;   // cutter overshoot past faces

// Derived
cone_od_bot   = spout_od;  // cone starts at spout diameter (z = 20)
cone_h        = spout_h;   // cone runs z = 20 to 50 (height 30)

difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_h);
        // Cone: z = 20 (spout top) to z = 50 (rim)
        translate([0, 0, spout_h])
            cylinder(d1 = cone_od_bot, d2 = cone_od_top, h = cone_h);
    }
    // Bottom cutter (through the spout)
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + 2 * eps);
    // Top cutter (through the rim)
    translate([0, 0, spout_h + cone_h - eps])
        cylinder(d = cone_od_top - 2 * wall, h = eps);
}