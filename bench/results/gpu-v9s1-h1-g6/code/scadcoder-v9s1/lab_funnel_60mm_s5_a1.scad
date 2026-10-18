// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_h       = 20;   // spout height (z = 0 to 20)
cone_od_top   = 60;   // cone rim outer diameter (z = 50)
cone_h        = 30;   // cone height (z = 20 to 50)
wall          = 1.6;  // wall thickness everywhere

// --- Derived ---
spout_id      = spout_od - 2 * wall;   // bore diameter
cone_od_bot   = spout_od;             // cone starts at spout diameter

// --- Model ---
union() {
    // Straight spout (tube)
    translate([0, 0, 0])
        cylinder(d = spout_od, h = spout_h);

    // Cone: od = cone_od_bot at z = spout_h, od = cone_od_top at z = spout_h + cone_h
    translate([0, 0, spout_h])
        cylinder(d1 = cone_od_bot, d2 = cone_od_top, h = cone_h);
}

// Cut the bore through the full height
translate([0, 0, -1])
    cylinder(d = spout_id, h = spout_h + cone_h + 2);