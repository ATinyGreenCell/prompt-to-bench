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
        linear_extrude(height = cone_h)
            circle(d = cone_od_bot);
    translate([0, 0, spout_h + cone_h])
        rotate([0, 0, 90])
            linear_extrude(height = cone_od_top - cone_od_bot)
                circle(d = cone_od_top);
}

// Cut the bore through the full height
translate([0, 0, -1])
    difference() {
        cylinder(d = spout_id, h = spout_h + cone_h + 2);
        translate([0, 0, -1])
            cylinder(d = spout_id + 0.02, h = spout_h + cone_h + 2);
    }