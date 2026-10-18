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
spout_id = spout_od - 2 * wall;   // bore diameter
cone_id_top = cone_od_top - 2 * wall; // rim bore diameter

// ---- Model ----
union() {
    // Spout (tube)
    translate([0, 0, 0])
        cylinder(d = spout_od, h = spout_h);

    // Cone (widens from spout top to rim)
    translate([0, 0, spout_h])
        cylinder(d1 = spout_od, d2 = cone_od_top, h = cone_h);
}

// Cut through the axis so liquid runs straight through
translate([0, 0, -eps])
    cylinder(d = spout_id, h = spout_h + cone_h + 2 * eps);