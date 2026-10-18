// Lab funnel - printed upright with wide opening at top
// Straight spout from z = 0 to z = 20, cone from z = 20 to z = 50

// ---- Dimensions (mm) ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_od_top   = 60;    // cone outer diameter at rim (z = 50)
cone_od_bot   = 10;    // cone outer diameter at base (z = 20)
rim_h         = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness everywhere

$fn = 128;

// ---- Derived ----
bore = spout_od - 2 * wall;   // 6.8 mm bore in spout

// ---- Model ----
union() {
    // Spout
    translate([0, 0, 0])
        cylinder(h = spout_h, d = spout_od);

    // Cone
    translate([0, 0, spout_h])
        cylinder(h = rim_h, d1 = cone_od_bot, d2 = cone_od_top);
}

// ---- Cut through bore (past both end faces) ----
translate([0, 0, -1])
    cylinder(h = spout_h + rim_h + 2, d = bore);