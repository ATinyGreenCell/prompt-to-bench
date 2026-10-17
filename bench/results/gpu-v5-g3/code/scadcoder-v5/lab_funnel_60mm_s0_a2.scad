// Funnel with spout - printed upright, wide opening at top
// Units: mm. Wall thickness 1.6 mm throughout.

// ---------- Parameters ----------
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_top_d    = 10;    // cone outer diameter at z = 20 (spout top)
cone_rim_d    = 60;    // cone outer diameter at rim (z = 50)
rim_z         = 50;    // rim height
wall          = 1.6;   // wall thickness
cut_extra     = 0.5;   // overshoot for clean boolean cuts

$fn = 64;

// ---------- Derived ----------
spout_id = spout_od - 2 * wall;   // bore = 6.8 mm
cone_h   = rim_z - spout_length;  // cone height = 30 mm

// ---------- Model ----------
union() {
    // Spout (tube)
    difference() {
        cylinder(d = spout_od, h = spout_length);
        translate([0, 0, -cut_extra])
            cylinder(d = spout_id, h = spout_length + 2 * cut_extra);
    }

    // Cone, joined at z = 20
    translate([0, 0, spout_length])
        linear_extrude(height = cone_h)
            circle(d1 = cone_top_d, d2 = cone_rim_d);

    // Bottom outlet: bore through the spout end at z = 0
    translate([0, 0, -cut_extra])
        cylinder(d = spout_id, h = spout_length + 2 * cut_extra);
}