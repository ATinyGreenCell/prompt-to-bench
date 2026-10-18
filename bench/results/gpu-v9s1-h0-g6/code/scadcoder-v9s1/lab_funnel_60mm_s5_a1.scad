// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter (z = 0 to 20)
spout_length  = 20;    // spout length
cone_top_od   = 10;    // cone outer diameter at spout junction (z = 20)
cone_rim_od   = 60;    // cone rim outer diameter (z = 50)
cone_height   = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness everywhere

// --- Derived ---
spout_id = spout_od - 2 * wall;   // bore of spout
eps      = 0.5;                  // cutter overshoot

// --- Model ---
difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_length);
        // Cone
        translate([0, 0, spout_length])
            cylinder(d1 = cone_top_od, d2 = cone_rim_od, h = cone_height);
    }
    // Through-bore: spout bore up to cone, then cone wall thins to rim (open top)
    translate([0, 0, spout_length - eps])
        linear_extrude(height = cone_height + eps)
            circle(d = spout_id);
}